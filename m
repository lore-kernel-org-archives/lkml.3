Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab3BNPIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:08:15 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:53071 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab3BNPIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:08:14 -0500
Date: Thu, 14 Feb 2013 16:08:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [-rc7 regression] Block IO/VFS/ext3/timer spinlock lockup?
Message-ID: <20130214150810.GA26095@gmail.com>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
 <20130213111007.GA11367@gmail.com>
 <CA+55aFxrjsVkBwUdjmc4MYvEsjEyCJZ7AFpGrWvbbQFB3EVtHA@mail.gmail.com>
 <alpine.LFD.2.02.1302140012460.22263@ionos>
 <20130214144510.GC25282@gmail.com>
 <20130214145424.GA26071@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214145424.GA26071@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> > CPU0 appears to be idle:
> > 
> > [  118.510000] Call Trace:
> > [  118.510000]  [<7900844b>] cpu_idle+0x86/0xb4
> > [  118.510000]  [<792a91df>] rest_init+0x103/0x108
> > [  118.510000]  [<794558cc>] start_kernel+0x2c7/0x2cc
> 
> 
> So, I've done a partial bisection, the breakage appears to have 
> gone upstream between v3.8-rc3 and v3.8-rc4.
> 
> This roughly coincides with the time frame when I first saw 
> these lockups pop up, so in that sense it's a plausible result - 
> but there weren't all that many commits in -rc4 and none looks 
> really suspicious, so this might be one of those non-bisectable 
> bugs.
> 
> ( Later today I'll try to finish the bisection just in case it
>   results in something useful. )

Managed to squeeze in some more bisection steps - and in fact 
the mm/ changes in -rc4 are still included in the bisection 
window:

 git bisect bad 7c8284c3aa127ffe72a90a1bad52183ec9ad870a
 git bisect good 0a1af1d61edae189b0a81bc46386ab37eb3d9d4d

vega:~/linux/linux> gll 0a1af1..7c8284c3a mm/
8fb74b9fb2b1 mm: compaction: partially revert capture of suitable high-order page
062f1af2170a mm: thp: acquire the anon_vma rwsem for write during split
572043c90db6 mm: mmap: annotate vm_lock_anon_vma locking properly for lockdep
10d73e655cef mm: bootmem: fix free_all_bootmem_core() with odd bitmap alignment
c060f943d092 mm: use aligned zone start for pfn_to_bitidx calculation
7964c06d66c7 mm: compaction: fix echo 1 > compact_memory return error issue
c0232ae861df mm: memblock: fix wrong memmove size in memblock_merge_regions()
04fa5d6a6547 mm: migrate: check page_count of THP before migrating

these three:

10d73e655cef mm: bootmem: fix free_all_bootmem_core() with odd bitmap alignment
c060f943d092 mm: use aligned zone start for pfn_to_bitidx calculation
c0232ae861df mm: memblock: fix wrong memmove size in memblock_merge_regions()

might have highmem=512m boot parameter sensitivity.

Thanks,

	Ingo
