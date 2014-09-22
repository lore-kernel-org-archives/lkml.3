Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaIVPg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:36:28 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:36422 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIVPg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:36:27 -0400
Date: Mon, 22 Sep 2014 08:36:21 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] resource: Add NULL check in next_resource
Message-ID: <20140922153621.GA5054@roeck-us.net>
References: <1411314704-27072-1-git-send-email-linux@roeck-us.net>
 <20140922145704.GC4250@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922145704.GC4250@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 10:57:04AM -0400, Vivek Goyal wrote:
> On Sun, Sep 21, 2014 at 08:51:44AM -0700, Guenter Roeck wrote:
> > Commit 8c86e70acead ("resource: provide new functions to walk through
> > resources") adds a suble new requirement that iomem_resource.child must
> > not be NULL when walk_system_ram_range is called. This can cause a crash
> > if it turns out that there are no children. The crash ('Unable to handle
> > kernel NULL pointer dereference') is seen when trying to test a crisv32
> > image on kernels with this commit applied.
> > 
> > Fix by adding a NULL check into next_resource().
> > 
> > Fixes: 8c86e70acead ("resource: provide new functions to walk through resources")
> 
> Hi Guenter,
> 
> Can you please provide backtrace of the crash.
> 

Unable to handle kernel NULL pointer dereferenceOops: 0000
CPU: 0
ERP: c000f998 SRP: c000fbfa  CCS: 00028008 USP: 00000000 MOF: 00000000
 r0: 00000014  r1: c1ffffff   r2: c0123790  r3: 00000000
 r4: c1ff3e98  r5: c1ff3e94   r6: c027e4f0  r7: 00000001
 r8: c1ff3ea0  r9: c1ff3ea0  r10: c1ff3e94 r11: c027e4f0
r12: 00000001 r13: 80000200 oR10: c1ff3e94 acr: 00000018
 sp: c1ff3df4
       Data MMU Cause: 00000100
Instruction MMU Cause: 00000000
Process swapper (pid: 1, stackpage=c1ff1a20)

Stack from c1ff3cec:
       c0004982 c025ab4c c1ff3e48 00000000 c1ff3e40 c1ff3e94 c00057c0 00000018 
       00000000 c1ff3df4 c0397db0 00000000 c1ff1a20 c1ff3e98 c0004a7e 00000000 
       c0005186 c004a7e2 00000014 c1ffffff c0123790 00000000 c1ff3e98 c1ff3e94 
Call Trace: [<c0004982>] [<c025ab4c>] [<c00057c0>] [<c0004a7e>] [<c0005186>] [<c004a7e2>] [<c0123790>] 
       [<c0120314>] [<c01a33f6>] [<c011a750>] [<c0127d18>] [<c0028b34>] [<c011ab60>] [<c011a6a4>] [<c011aa0c>] 
       [<c005b492>] [<c006985a>] [<c0008572>] [<c0123790>] [<c000fbfa>] [<c000f998>] [<c000f8e4>] [<c00b2024>] 
       [<c0120314>] [<c000fbfa>] [<c00041a8>] [<c00ac3b6>] [<c00b20fc>] [<c00041a8>] [<c0120314>] [<c00041a8>] 
       [<c00042a0>] [<c00041a8>] [<c0120314>] [<c001e600>] [<c0120314>] [<c0259160>] [<c025916e>] [<c00053b6>] 
Code: f7 30 10 02 90 02 08 e0 6f 06 14 02 (60) 0a c0 02 8b 20 b0 05 b5 e0 b0 05 
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

-----------

bisect:

8c86e70acead629aacb4afcd818add66bf6844d9 is the first bad commit
commit 8c86e70acead629aacb4afcd818add66bf6844d9
Author: Vivek Goyal <vgoyal@redhat.com>
Date:   Fri Aug 8 14:25:50 2014 -0700

    resource: provide new functions to walk through resources

# bad: [9e82bf014195d6f0054982c463575cdce24292be] Linux 3.17-rc5
# good: [19583ca584d6f574384e17fe7613dfaeadcdc4a6] Linux 3.16
git bisect start 'v3.17-rc5' 'v3.16'
# good: [ae045e2455429c418a418a3376301a9e5753a0a8] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect good ae045e2455429c418a418a3376301a9e5753a0a8
# good: [10c8e0562057b5d64ea170feab148e1550420030] Merge tag 'drivers-for-3.17' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good 10c8e0562057b5d64ea170feab148e1550420030
# bad: [a8e4def604a9affa04fdd4efa0692da1385ffa3f] Merge tag 'mmc-v3.17-1' of git://git.linaro.org/people/ulf.hansson/mmc
git bisect bad a8e4def604a9affa04fdd4efa0692da1385ffa3f
# bad: [c23190c0bf1236e1eb5521a8b10d0102fbc1338c] Merge tag 'trace-ipi-tracepoints' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
git bisect bad c23190c0bf1236e1eb5521a8b10d0102fbc1338c
# bad: [34b20e6df6970e36b93f445669ba5ef7a05fe01a] Merge tag 'pwm/for-3.17-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm
git bisect bad 34b20e6df6970e36b93f445669ba5ef7a05fe01a
# bad: [e46d12c65998c7ac6a8544fc356e2297228b207a] MAINTAINERS: update DMA BUFFER SHARING patterns
git bisect bad e46d12c65998c7ac6a8544fc356e2297228b207a
# good: [8b6aaf65d3b001ec9b5dcba0992b3b68cbf6057f] tools/testing/selftests/ptrace/peeksiginfo.c: add PAGE_SIZE definition
git bisect good 8b6aaf65d3b001ec9b5dcba0992b3b68cbf6057f
# good: [12fe08b2b5acada5ce708866786d08918e1f4819] sky2: use pci_zalloc_consistent
git bisect good 12fe08b2b5acada5ce708866786d08918e1f4819
# good: [1db22e8b837246608a467e7f0a7d1b2ff0c92a19] MAINTAINERS: remove unusd ARM/QUALCOMM MSM pattern
git bisect good 1db22e8b837246608a467e7f0a7d1b2ff0c92a19
# good: [255aedd90e3e804fb52e1a71636a3b22cf12f81b] kexec: use common function for kimage_normal_alloc() and kimage_crash_alloc()
git bisect good 255aedd90e3e804fb52e1a71636a3b22cf12f81b
# bad: [8fc5b4d4121c95482b2583a07863c6b0aba2d9e1] purgatory: core purgatory functionality
git bisect bad 8fc5b4d4121c95482b2583a07863c6b0aba2d9e1
# bad: [f0895685c7fd8c938c91a9d8a6f7c11f22df58d2] kexec: new syscall kexec_file_load() declaration
git bisect bad f0895685c7fd8c938c91a9d8a6f7c11f22df58d2
# bad: [815d5704a337a662bf960757edbff7a0680d40fd] kexec: make kexec_segment user buffer pointer a union
git bisect bad 815d5704a337a662bf960757edbff7a0680d40fd
# bad: [8c86e70acead629aacb4afcd818add66bf6844d9] resource: provide new functions to walk through resources
git bisect bad 8c86e70acead629aacb4afcd818add66bf6844d9
# first bad commit: [8c86e70acead629aacb4afcd818add66bf6844d9] resource: provide new functions to walk through resources
