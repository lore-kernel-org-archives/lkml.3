Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbaA3AaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 19:30:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaA3AaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 19:30:11 -0500
Date: Wed, 29 Jan 2014 16:34:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memblock: Add limit checking to memblock_virt_alloc
Message-Id: <20140129163407.a46408a4.akpm@linux-foundation.org>
In-Reply-To: <CA+8MBbLggLtM6ZQhmS0qZQaRG0b+HxtawxXSu5bUzHS-rMVcYg@mail.gmail.com>
References: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
	<52E82A40.3040104@intel.com>
	<CAE9FiQVGuN0f5xo9fbfsurmO3E=45A3m0oS75HYPV7BSEwrvsg@mail.gmail.com>
	<20140129015048.GA14629@konrad-lan.dumpdata.com>
	<CA+8MBbJjEUJKo2ip8bDzDRVbBT+yhzqZXV0BYP3X52OJ3zA6Pg@mail.gmail.com>
	<CAE9FiQWfZk7ogmORm7euBy1bncUhFW0Ms2hV_g8_9uBVU71RRQ@mail.gmail.com>
	<CAE9FiQX6CiumfOi2cgU1ODrKuaTHCZxo3zNmW01kn+GT1CAT3w@mail.gmail.com>
	<CA+8MBbLggLtM6ZQhmS0qZQaRG0b+HxtawxXSu5bUzHS-rMVcYg@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jan 2014 16:12:13 -0800 Tony Luck <tony.luck@gmail.com> wrote:

> Applying on top of Linus' tree (commit =
> dda68a8c1707b4011dc3c656fa1b2c6de6f7f304) I just get:
> 
> patching file include/linux/bootmem.h
> Hunk #1 FAILED at 264.
> Hunk #2 FAILED at 272.
> 2 out of 2 hunks FAILED -- saving rejects to file include/linux/bootmem.h.rej
> 
> - not a promising start :-(
> 

It applies for me.  MIME getting you down?


From: Yinghai Lu <yinghai@kernel.org>
Subject: memblock, bootmem: restore goal for alloc_low

Now we have memblock_virt_alloc_low to replace original bootmem api
in swiotlb.

But we should not use BOOTMEM_LOW_LIMIT for arch that does not support
CONFIG_NOBOOTMEM, as old api take 0.

| #define alloc_bootmem_low(x) \
|        __alloc_bootmem_low(x, SMP_CACHE_BYTES, 0)
|#define alloc_bootmem_low_pages_nopanic(x) \
|        __alloc_bootmem_low_nopanic(x, PAGE_SIZE, 0)

and we have
 #define BOOTMEM_LOW_LIMIT __pa(MAX_DMA_ADDRESS)
for CONFIG_NOBOOTMEM.

Restore goal to 0 to fix ia64 crash, that Tony found.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reported-by: Tony Luck <tony.luck@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/bootmem.h~memblock-bootmem-restore-goal-for-alloc_low include/linux/bootmem.h
--- a/include/linux/bootmem.h~memblock-bootmem-restore-goal-for-alloc_low
+++ a/include/linux/bootmem.h
@@ -264,7 +264,7 @@ static inline void * __init memblock_vir
 {
 	if (!align)
 		align = SMP_CACHE_BYTES;
-	return __alloc_bootmem_low(size, align, BOOTMEM_LOW_LIMIT);
+	return __alloc_bootmem_low(size, align, 0);
 }
 
 static inline void * __init memblock_virt_alloc_low_nopanic(
@@ -272,7 +272,7 @@ static inline void * __init memblock_vir
 {
 	if (!align)
 		align = SMP_CACHE_BYTES;
-	return __alloc_bootmem_low_nopanic(size, align, BOOTMEM_LOW_LIMIT);
+	return __alloc_bootmem_low_nopanic(size, align, 0);
 }
 
 static inline void * __init memblock_virt_alloc_from_nopanic(
_

