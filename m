Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaBUWcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:32:13 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:64703 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaBUWcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:32:12 -0500
Date: Fri, 21 Feb 2014 17:34:08 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
In-Reply-To: <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1402211732290.11615@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402211521040.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014, Vince Weaver wrote:

> On Fri, 21 Feb 2014, Vince Weaver wrote:
> 
> > So I'm not sure who exactly to report this to.  Some perf people CC'd as
> > I trigger it while using the perf_fuzzer.
> > 
> > This is with 3.14-rc3 on a core2 machine, although I've had the reboots 
> > happen throughout at least 3.14-rc*
> > 
> > I'm having a hard time coming up with a reproducible test case.  Using the 
> > random seed that caused the below will cause the perf_fuzzer to segfault 
> > but not reboot.
> > 
> > The log isn't very helpful, it reboots so fast that the oops doesn't 
> > finish printing and the serial log just moves to the bootloader...
> > 
> > [ 4466.804123] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
> > [ 4466.808014] IP: [<ffffffff81111783>] cache_reap+0x5e/0x1c5
> > [ 4466.808014] PGD 0 
> > [ 4466.808014] Oops: 0000 [#1] GNU GRUB  version 2.00-17
> 
> Maybe related, this is on an x32-compiled binary.
> 
> When trying to reproduce the perf_fuzzer myseriously segfaults on what 
> appears to be perfectly valid mmap'd perf ring-buffers.
> 
> (running under gdb)
> 
> Program received signal SIGSEGV, Segmentation fault.
> 0x0041efbb in __memset_sse2 ()
> 
> => 0x0041efbb <+2203>:  movdqa %xmm0,(%rdi)
> 
> rdi            0xf7f61000       4160098304
> 
> f7f61000-f7f72000 rw-s 00000000 00:08 4475  anon_inode:[perf_event]
> 
> So I'm not sure if somehow something is wrong with the page mapping, that 
> makes a valid write fail and sometimes (possibly due to address space 
> randomization) reboot the system?

also strange, when I look at the core dumps it always shows the bad memory
address happening at the beginning of an mmap page as expected for the
ip listed, but the segfault listed in the kernel happens at some 
completely unrelated address that isn't even page aligned and shouldn't be 
possible based on the gdb/coredump results?

[ 1560.313863] perf_fuzzer[2826]: segfault at 503283ff ip 000000000041efbb 
sp 00000000ffd367d8 error 6 in perf_fuzzer[400000+d1000]
[ 1704.673245] perf_fuzzer[2835]: segfault at 503283ff ip 000000000041efbb 
sp 00000000ff972be8 error 6 in perf_fuzzer[400000+d1000]
[ 2978.101276] perf_fuzzer[2841]: segfault at 503283ff ip 000000000041efbb 
sp 00000000ff92ba68 error 6 in perf_fuzzer[400000+d1000]
[ 4907.185366] perf_fuzzer[2868]: segfault at 503283ff ip 000000000041efbb 
sp 00000000ffadcd28 error 6 in perf_fuzzer[400000+d1000]
[ 9570.793746] perf_fuzzer[6183]: segfault at 4d0bf28e ip 000000000041efbb 
sp 00000000ff83f688 error 6 in perf_fuzzer[400000+d1000]
[ 9743.888431] perf_fuzzer[6187]: segfault at 91734d5 ip 000000000041efbb 
sp 00000000ffb4e288 error 6 in perf_fuzzer[400000+d1000]

Vince
