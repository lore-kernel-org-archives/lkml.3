Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934016Ab3BMNGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:06:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933965Ab3BMNF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:05:58 -0500
Message-ID: <511B8FA4.1080400@redhat.com>
Date: Wed, 13 Feb 2013 14:05:40 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        nbd-general@lists.sf.net, Paul Clements <Paul.Clements@steeleye.com>
Subject: Re: [PATCH 2/3] nbd: fsync and kill block device on shutdown
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com> <1360685171-3792-3-git-send-email-pbonzini@redhat.com> <20130212134155.f23f2223.akpm@linux-foundation.org>
In-Reply-To: <20130212134155.f23f2223.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/02/2013 22:41, Andrew Morton ha scritto:
>> > There are two problems with shutdown in the NBD driver.  The first is
>> > that receiving the NBD_DISCONNECT ioctl does not sync the filesystem;
>> > this is useful because BLKFLSBUF is restricted to processes that have
>> > CAP_SYS_ADMIN, and the NBD client may not possess it (fsync of the
>> > block device does not sync the filesystem, either).
> hm, this says that the lack of a sync is "useful".  I think you mean
> that the patch-which-adds-the-sync is the thing which is useful, yes?

Yes.

>> > The second is that once we clear the socket we have no guarantee that
>> > later reads will come from the same backing storage.  Thus the page cache
>> > must be cleaned, lest reads that hit on the page cache will return stale
>> > data from the previously-accessible disk.
> That sounds like a problem.
> 
>> > Example:
>> > 
>> >     # qemu-nbd -r -c/dev/nbd0 /dev/sr0
>> >     # file -s /dev/nbd0
>> >     /dev/stdin: # UDF filesystem data (version 1.5) etc.
>> >     # qemu-nbd -d /dev/nbd0
>> >     # qemu-nbd -r -c/dev/nbd0 /dev/sda
>> >     # file -s /dev/nbd0
>> >     /dev/stdin: # UDF filesystem data (version 1.5) etc.
>> > 
>> > While /dev/sda has:
>> > 
>> >     # file -s /dev/sda
>> >     /dev/sda: x86 boot sector; etc.
> OK, we've described the problems but there's no description here of how
> the patch addresses those problems.
> 
> How does this look?

Perfect, thanks very much.  I tried to similarly balance the "why" and
"how" in the new commit message for patch 1.

Paolo
