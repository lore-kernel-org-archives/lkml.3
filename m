Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaEFTP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:15:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45909 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbaEFTPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:15:25 -0400
Date: Tue, 6 May 2014 20:15:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140506191524.GW18016@ZenIV.linux.org.uk>
References: <20140502210813.GB32527@tucsk.piliscsaba.szeredi.hu>
 <CA+55aFzbtGwxTf_d97pSLc4hAciErGDdkOSzLkpt_hP-UmLPWg@mail.gmail.com>
 <20140502224022.GJ18016@ZenIV.linux.org.uk>
 <20140503042604.GM18016@ZenIV.linux.org.uk>
 <20140503182110.GN18016@ZenIV.linux.org.uk>
 <20140504062915.GQ18016@ZenIV.linux.org.uk>
 <CAJfpegvWOzd01tW5nRfWKW7EoBgPD8rudODJJm5OqxPd5Pd7uA@mail.gmail.com>
 <CA+55aFxeVn2Xfa4Dwt2+GzAL7MxV3UK-jMf-+Nvm2HE9hETS9w@mail.gmail.com>
 <20140506165233.GR18016@ZenIV.linux.org.uk>
 <CA+55aFwzkKAFD3Bmq3G9xu2xNgbwfwY1gDv+2CWcjJJb0PCD5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwzkKAFD3Bmq3G9xu2xNgbwfwY1gDv+2CWcjJJb0PCD5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 10:01:21AM -0700, Linus Torvalds wrote:
> On Tue, May 6, 2014 at 9:52 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > OK...  There's one more thing I would like to put there, if you are going to
> > be away for the week.  It has sat in -next for a while, and it could stay
> > there, except that there's a _lot_ of followups touching stuff all over the
> > tree and I'd obviously prefer those to go into subsystem trees.  Which
> > means inter-tree dependencies ;-/  Would you be OK if I included that one
> > into pull request?  It just turns kvfree() into inline and takes it to
> > mm.h, next to is_vmalloc_addr();
> 
> Is there any particular reason for inlining this? I'd actually rather
> not, _especially_ if it means that a lot of "is_vmalloc_addr()" usage
> goes away and we may end up with this as a real interface.

OK, I can live with that.  dcache fixes + kvfree() (uninlined, exported by
mm/util.c) + posix_acl bugfix from hch.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (9):
      fix races between __d_instantiate() and checks of dentry flags
      fold d_kill() and d_free()
      fold try_prune_one_dentry()
      new helper: dentry_free()
      expand the call of dentry_lru_del() in dentry_kill()
      dentry_kill(): don't try to remove from shrink list
      don't remove from shrink list in select_collect()
      more graceful recovery in umount_collect()
      nick kvfree() from apparmor

Christoph Hellwig (1):
      posix_acl: handle NULL ACL in posix_acl_equiv_mode

Miklos Szeredi (1):
      dcache: don't need rcu in shrink_dentry_list()

Diffstat:
 fs/dcache.c                          |  318 ++++++++++++++++++++++++---------------------------------------------------
 fs/namei.c                           |    6 +-
 fs/posix_acl.c                       |    6 ++
 include/linux/dcache.h               |    2 +
 include/linux/mm.h                   |    2 +
 mm/util.c                            |   10 +++
 security/apparmor/include/apparmor.h |    1 -
 security/apparmor/lib.c              |   14 ----
 8 files changed, 125 insertions(+), 234 deletions(-)

