Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaFCJBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:01:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbaFCJBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:01:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+icZUV5P=fVwe_MJJHixwBOBoj7HoKSFuySLdS6AU5L++S=4g@mail.gmail.com>
References: <CA+icZUV5P=fVwe_MJJHixwBOBoj7HoKSFuySLdS6AU5L++S=4g@mail.gmail.com> <1400838223-30844-1-git-send-email-miklos@szeredi.hu> <28592.1401382081@warthog.procyon.org.uk> <11446.1401420931@jrobl> <7184.1401439773@warthog.procyon.org.uk>
To: sedat.dilek@gmail.com
Cc: dhowells@redhat.com, "J. R. Okajima" <hooanon05g@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        Felix Fietkau <nbd@openwrt.org>, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, mszeredi@suse.cz
Subject: Re: Unionmount and overlayfs testsuite
Date: Tue, 03 Jun 2014 10:00:56 +0100
Message-ID: <15839.1401786056@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> wrote:

> [ Re-Tested with 3.15.0-rc8-1-iniza-lockdep ]
> 
> Running the impermissible test on OverlayFS with TERMSLASH=1 is
> successful here

That's not very surprising.  utimensat() doesn't even get out of pathwalk if
the filename has a terminal slash and the fs_op macro correctly overrides the
expected error code in this case.

> (TERMSLASH=0 still fails):

It's possible that the test is wrong.  utimes is icky, at least on unionmount,
because the copy up has to be done before we call notify_change() - but
notify_change() can still reject the operation (in which case we didn't want
to copy up at all).  The problem is that notify_change() has i_mutex.

Ideally, we'd do copy-up inside notify_change() - but we can't do that in
unionmount.  I imagine you can do that in overlayfs.

> # LC_ALL=C TEST_OVERLAYFS=1 TERMSLASH=1 ./run.sh
> 
> [ NOTE-1: I still see the reported call-trace which you Dave see as a
> problem in OverlayFS. ]

There should be zero lockdep complaints.  It may be a real locking problem or
it may just be a missing nesting annotation.

One problem I had with unionmounts that I don't think applies to overlayfs is
that i_{,mdir_}mutex on inodes on the upper (union) layer and the lower layers
may come from the same superblock and thus have the same lockdep class keys
(which are per struct file_system_type).  This means that lockdep thinks
they're conflicting - when actually they are not.  What I did was to give
i_{,dir_}mutex in the upper layer different lockdep classes.

The reason this works for unionmounts is that there unionmounting is done by
the VFS and the upper/glue layer is an ordinary superblock (tmpfs, ext2, ...)
and I get to meddle with the lockdep classes of the upper superblock during
mount before any inodes exist.

I don't think this would work for overlayfs for two reasons: (1) the top layer
is an overlayfs superblock and would have different lockdep classes anyway and
(2) you cannot change the lockdep class once inodes exist in the filesystem -
and overlayfs requires both the upper and lower layers to exist prior to the
glue layer being mounted.

My suspicion is that overlayfs is doing stuff to the lower layer whilst
holding a lock on the upper layer or vice versa.

> [ NOTE-2: The call-trace I have seen once (TERMSLASH=0). ]

Do you know for which operation?

David
