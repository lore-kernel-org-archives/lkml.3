Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaBCWkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:40:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42775 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbaBCWkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:40:40 -0500
Date: Mon, 3 Feb 2014 22:40:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <ilya.dryomov@inktank.com>, Sage Weil <sage@inktank.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
Message-ID: <20140203224034.GF10323@ZenIV.linux.org.uk>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
 <1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
 <CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com>
 <20140130075421.GA10050@infradead.org>
 <CA+55aFxbVFpy8Y8P5fMCmmTSGbFxU9dTbOj9uTH+fKWGUzwgNg@mail.gmail.com>
 <20140203102943.GF11829@infradead.org>
 <CA+55aFytvTPdBsv6BwSomUGWXZ_tKP=BxaeJ7FXBft0JNnjBCQ@mail.gmail.com>
 <20140203215908.GD10323@ZenIV.linux.org.uk>
 <CA+55aFz3PyyCqOLs_SBRS3cbGxWd5ez4Svz2+xK+4KtCez8iGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz3PyyCqOLs_SBRS3cbGxWd5ez4Svz2+xK+4KtCez8iGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 02:12:00PM -0800, Linus Torvalds wrote:

> >> -int afs_permission(struct inode *inode, int mask)
> >> +int afs_permission(struct dentry *dentry, struct inode *inode, int mask)
> >
> > Oh, _lovely_.  So not only do we pass dentry, the arguments are redundant
> > as well.
> 
> Note that *not* passing in inode would make the patch much bigger,
> because now every filesystem would have to add the
> 
>        struct inode *inode = dentry->d_inode;
> 
> at the top.
> 
> Also, I'm not actually convinced it is redundant at all. Remember the
> RCU lookup case? dentry->d_inode is not safe.

Umm...  Point, but that actually means that we get an extra pitfall for
filesystem writers here.  foo_permission() passes dentry (now that it
has one) to foo_wank_a_lot(), with the latter using dentry->d_inode at
some point...

> >> +static int gfs2_vfs_permission(struct dentry *dentry, struct inode *inode, int mask)
> >> +{
> >> +     return gfs2_permission(inode, mask);
> >> +}
> >
> > Er...  You do realize that callers of gfs2_permission() tend to have
> > the dentry in question, either directly or as ->d_parent of something
> > they have?
> 
> Not true. Look closer.
> 
> Look at gfs2_lookupi() in particular, and check how it is called.

Yeowch...  gfs2_ok_to_move() is particulary nasty...  WTF do we need
it for and why is it not racy as hell?
