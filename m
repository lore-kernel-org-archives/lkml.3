Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbaIKX5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:57:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241AbaIKX5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:57:49 -0400
Date: Fri, 12 Sep 2014 01:57:36 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Piotr Karbowski <piotr.karbowski@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: /proc/<pid>/exe symlink behavior change in >=3.15.
Message-ID: <20140911235735.GA12362@mguzik>
References: <540B8040.5010206@gmail.com>
 <20140907075607.GA11240@mguzik>
 <20140911183958.1e45b99e@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140911183958.1e45b99e@as>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 06:39:58PM -0500, Chuck Ebbert wrote:
> On Sun, 7 Sep 2014 09:56:08 +0200
> Mateusz Guzik <mguzik@redhat.com> wrote:
> 
> > On Sat, Sep 06, 2014 at 11:44:32PM +0200, Piotr Karbowski wrote:
> > > Hi,
> > > 
> > > Starting with kernel 3.15 the 'exe' symlink under /proc/<pid>/ acts diffrent
> > > than it used to in all the pre-3.15 kernels.
> > > 
> > > The usecase:
> > > 
> > > run /root/testbin (app that just sleeps)
> > > cp /root/testbin /root/testbin.new
> > > mv /root/testbin.new /root/testbin
> > > ls -al /proc/`pidof testbin`/exe
> > > 
> > > <=3.14: /root/testbin (deleted)
> > > >=3.15: /root/testbin.new (deleted)
> > > 
> > > Was the change intentional? It does render my system unusable and I failed
> > > to find a information about such change in the ChangeLog.
> > > 
> > 
> > It looks like this was already broken for "long" (> DNAME_INLINE_LEN)
> > names.
> > 
> > Short names share the problem since da1ce0670c14d8 "vfs: add
> > cross-rename".
> > 
> > The following change to switch_names is the culprit:
> > 
> > -       memcpy(dentry->d_iname, target->d_name.name,
> > -                   target->d_name.len + 1);
> > -       dentry->d_name.len = target->d_name.len;
> > -       return;
> > +       unsigned int i;
> > +       BUILD_BUG_ON(!IS_ALIGNED(DNAME_INLINE_LEN, sizeof(long)));
> > +       for (i = 0; i < DNAME_INLINE_LEN / sizeof(long); i++) {
> > +     		  swap(((long *) &dentry->d_iname)[i],
> > +  			((long *) &target->d_iname)[i]);
> > +       }
> > 
> > 
> > Dentries can have names from embedded structure or from an external buffer.
> > 
> > If you take a look around you will see the code just swaps pointers for
> > "both external" case. But this results in the same behavoiur you are seeing.
> > 
> 
> Looks like the real problem here is that __d_materialise_dentry() needs the
> old behavior of switch_names() . At least that's how it got fixed in grsecurity.

No.

Regression in question is an effect of swap instead of memcpy in
switch_names, as called by d_move. Fix in grsecurity reverts to previous
behaviour when needed and imho should be applied for the time being.

The real problem is that __d_move always switches parent dentry and
calls switch_names, which actually switches names in some cases.

Without the regression you get expected results only for short names
when you move stuff around within the same directory.

For instance with current code:
mv /foo/bar/baz /1/2/3

will replace the whole path.

Previous behavoiur would result in /foo/bar/3 as the new path, which is
clearly still incorrect

Leaving the old dentry under the same parent would mean that the "tree"
associated with now moved dentry will possibly need to be freed.

In addition to that one has to deal with the need of having renamed
dentry the new name which possibly came from an external buffer. An idea
I came up with (atomic_t refcount; char name[0]; with ->name assigned to
dentry) may require adding an additional field to struct dentry, which
would be bad.

I didn't have the time yet to look at this stuff properly.

-- 
Mateusz Guzik
