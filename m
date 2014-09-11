Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbaIKXkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:40:07 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:33375 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaIKXkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:40:05 -0400
Date: Thu, 11 Sep 2014 18:39:58 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Piotr Karbowski <piotr.karbowski@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: /proc/<pid>/exe symlink behavior change in >=3.15.
Message-ID: <20140911183958.1e45b99e@as>
In-Reply-To: <20140907075607.GA11240@mguzik>
References: <540B8040.5010206@gmail.com>
	<20140907075607.GA11240@mguzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Sep 2014 09:56:08 +0200
Mateusz Guzik <mguzik@redhat.com> wrote:

> On Sat, Sep 06, 2014 at 11:44:32PM +0200, Piotr Karbowski wrote:
> > Hi,
> > 
> > Starting with kernel 3.15 the 'exe' symlink under /proc/<pid>/ acts diffrent
> > than it used to in all the pre-3.15 kernels.
> > 
> > The usecase:
> > 
> > run /root/testbin (app that just sleeps)
> > cp /root/testbin /root/testbin.new
> > mv /root/testbin.new /root/testbin
> > ls -al /proc/`pidof testbin`/exe
> > 
> > <=3.14: /root/testbin (deleted)
> > >=3.15: /root/testbin.new (deleted)
> > 
> > Was the change intentional? It does render my system unusable and I failed
> > to find a information about such change in the ChangeLog.
> > 
> 
> It looks like this was already broken for "long" (> DNAME_INLINE_LEN)
> names.
> 
> Short names share the problem since da1ce0670c14d8 "vfs: add
> cross-rename".
> 
> The following change to switch_names is the culprit:
> 
> -       memcpy(dentry->d_iname, target->d_name.name,
> -                   target->d_name.len + 1);
> -       dentry->d_name.len = target->d_name.len;
> -       return;
> +       unsigned int i;
> +       BUILD_BUG_ON(!IS_ALIGNED(DNAME_INLINE_LEN, sizeof(long)));
> +       for (i = 0; i < DNAME_INLINE_LEN / sizeof(long); i++) {
> +     		  swap(((long *) &dentry->d_iname)[i],
> +  			((long *) &target->d_iname)[i]);
> +       }
> 
> 
> Dentries can have names from embedded structure or from an external buffer.
> 
> If you take a look around you will see the code just swaps pointers for
> "both external" case. But this results in the same behavoiur you are seeing.
> 

Looks like the real problem here is that __d_materialise_dentry() needs the
old behavior of switch_names() . At least that's how it got fixed in grsecurity.
