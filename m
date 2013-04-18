Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966979Ab3DRLly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:41:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966598Ab3DRLlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:41:53 -0400
Date: Thu, 18 Apr 2013 13:41:48 +0200
From: Petr Tesarik <ptesarik@suse.cz>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, vgoyal@redhat.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH 0/2] kdump: Enter 2nd kernel with BSP for enabling
 multiple CPUs
Message-ID: <20130418134148.53704982@azariah.suse.cz>
In-Reply-To: <20120416021951.9303.58568.stgit@localhost6.localdomain6>
References: <20120416021951.9303.58568.stgit@localhost6.localdomain6>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012 11:21:28 +0900
HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:

> Currently, booting up 2nd kernel with multiple CPUs fails in most
> cases since it enters 2nd kernel with AP if the crash happens on the
> AP. The problem is to signal startup IPI from AP to BSP. Typical
> result of the operation I saw is the machine hanging during the 2nd
> kernel boot.
> 
> To solve this issue, always enter 2nd kernel with BSP. To do this, I
> modify logic for shooting down CPUs. I use simple existing logic only
> in this mechanism, not complicating crash path to machine_kexec().

These patches looked pretty good. I seem to recall that Fenghua (from
Intel) had an alternative solution for booting from AP. Unfortunately I
can't find his mails in my kexec mailbox...

Anyway, what's the latest upstream status?

Petr

> I did stress tests about 100 in total on the processors below:
> 
>   Intel(R) Xeon(R) CPU E7- 4820  @ 2.00GHz
>   Socket x 4, Core x 8, Thread x 16 (160 LCPUS in total)
> 
>   Intel(R) Xeon(R) CPU E7- 8870  @ 2.40GHz
>   Socket x 8, Core x 10, Thread x 20 (64 LCPUS in total)
> 
> * Motivation of enabling multiple CPUs on the 2nd kernel
> 
> This patch is aimed at doing parallel compression on the 2nd
> kernel. The machine that has more than tera bytes memory requires
> several hours to generate crash dump.
> 
> There are several ways to reduce generation time of crash time, but
> they have different pros and cons:
> 
>   Fast I/O devices
>     pros
>       - Can obtain high-speed stably
>     cons
>       - Big financial cost for good performance I/O devices. It's
>         difficult financially to prepare these for all environments as
>         dump devices.
> 
>   Filtering
>     pros
>       - No financial cost.
>       - Large reduction of crash dump size
> 
>     cons
>       - Some data is definitely lost. So, we cannot use this on some
>         situations:
> 
>         1) High availability configuration where application triggers
>         OS to crash and users want to debug the application later by
>         retrieving the application's user process image from the
>         system's crash dump.
> 
>         2) KVM virtualization configuration where KVM host machine
>         contains KVM guest machine images as user processes.
> 
>         3) Page cache is needed for debugging filesystem related bugs.
> 
>   Compression
>     pros
>       - No financial cost.
>       - No data lost.
> 
>     cons
>       - Compression doesn't always reduce crash dump size.
>       - take heavy CPU time. Slow if CPU is weak in speed.
> 
> Machines with large memory tend to have a lot of CPUs. Parallel
> compression is sutable for parallel processing. My goal is to make
> compression as for free as possible.
> 
> * TODO
> 
>   - Extend 512MB limit of reserved memory size for 2nd kernel for
>     multiple CPUs.
> 
>   - Intel microcode patch loading on the 2nd kenrel is slow for the
>     2nd and later CPUs: about one or more minutes per one CPU.
> 
>   - There are a limited number of irq vectors for TLB flush IPI on
>     x86_64: 32 for recent 3.x kernels and 8 for around 2.6.x
>     kernels. So compression doesn't scale if a lot of page reclaim
>     happens when reading kernel image larger than memory. Special
>     handling without page cache could be applicable to parallel dump
>     mechanism, but more investigation is needed.
> 
> ---
> 
> HATAYAMA Daisuke (2):
>       Enter 2nd kernel with BSP
>       Introduce crash ipi helpers to wait for APs to stop
> 
> 
>  arch/x86/include/asm/reboot.h |    4 +++
>  arch/x86/kernel/crash.c       |   15 +++++++++-
>  arch/x86/kernel/reboot.c      |   63 +++++++++++++++++++++++++++++------------
>  3 files changed, 62 insertions(+), 20 deletions(-)
> 

