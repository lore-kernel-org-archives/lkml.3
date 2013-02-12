Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab3BLVl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:41:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3BLVl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:41:57 -0500
Date: Tue, 12 Feb 2013 13:41:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, <stable@vger.kernel.org>,
        <nbd-general@lists.sf.net>, Paul Clements <Paul.Clements@steeleye.com>
Subject: Re: [PATCH 2/3] nbd: fsync and kill block device on shutdown
Message-Id: <20130212134155.f23f2223.akpm@linux-foundation.org>
In-Reply-To: <1360685171-3792-3-git-send-email-pbonzini@redhat.com>
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com>
	<1360685171-3792-3-git-send-email-pbonzini@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2013 17:06:10 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> There are two problems with shutdown in the NBD driver.  The first is
> that receiving the NBD_DISCONNECT ioctl does not sync the filesystem;
> this is useful because BLKFLSBUF is restricted to processes that have
> CAP_SYS_ADMIN, and the NBD client may not possess it (fsync of the
> block device does not sync the filesystem, either).

hm, this says that the lack of a sync is "useful".  I think you mean
that the patch-which-adds-the-sync is the thing which is useful, yes?

> The second is that once we clear the socket we have no guarantee that
> later reads will come from the same backing storage.  Thus the page cache
> must be cleaned, lest reads that hit on the page cache will return stale
> data from the previously-accessible disk.

That sounds like a problem.

> Example:
> 
>     # qemu-nbd -r -c/dev/nbd0 /dev/sr0
>     # file -s /dev/nbd0
>     /dev/stdin: # UDF filesystem data (version 1.5) etc.
>     # qemu-nbd -d /dev/nbd0
>     # qemu-nbd -r -c/dev/nbd0 /dev/sda
>     # file -s /dev/nbd0
>     /dev/stdin: # UDF filesystem data (version 1.5) etc.
> 
> While /dev/sda has:
> 
>     # file -s /dev/sda
>     /dev/sda: x86 boot sector; etc.

OK, we've described the problems but there's no description here of how
the patch addresses those problems.


How does this look?


: There are two problems with shutdown in the NBD driver.
: 
: 1: Receiving the NBD_DISCONNECT ioctl does not sync the filesystem. 
: 
:    This patch adds the sync operation into __nbd_ioctl()'s
:    NBD_DISCONNECT handler.  This is useful because BLKFLSBUF is restricted
:    to processes that have CAP_SYS_ADMIN, and the NBD client may not
:    possess it (fsync of the block device does not sync the filesystem,
:    either).
: 
: 2: Once we clear the socket we have no guarantee that later reads will
:    come from the same backing storage.
: 
:    The patch adds calls to kill_bdev() in __nbd_ioctl()'s socket
:    clearing code so the page cache is cleaned, lest reads that hit on the
:    page cache will return stale data from the previously-accessible disk.
: 
: Example:
: 
:     # qemu-nbd -r -c/dev/nbd0 /dev/sr0
:     # file -s /dev/nbd0
:     /dev/stdin: # UDF filesystem data (version 1.5) etc.
:     # qemu-nbd -d /dev/nbd0
:     # qemu-nbd -r -c/dev/nbd0 /dev/sda
:     # file -s /dev/nbd0
:     /dev/stdin: # UDF filesystem data (version 1.5) etc.
: 
: While /dev/sda has:
: 
:     # file -s /dev/sda
:     /dev/sda: x86 boot sector; etc.

