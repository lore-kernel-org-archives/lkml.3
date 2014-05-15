Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbaEOSjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:39:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392AbaEOSjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:39:47 -0400
Message-ID: <1400179157.21547.147.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: fix pud_huge() for 2-level pagetables
From: Mark Salter <msalter@redhat.com>
To: Steve Capper <steve.capper@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 15 May 2014 14:39:17 -0400
In-Reply-To: <CAPvkgC2WQcvn5e01Y70cm5nzenYZ6tk_1BampHw66VoRFn7Jiw@mail.gmail.com>
References: <1400163562-7481-1-git-send-email-msalter@redhat.com>
	 <20140515144424.GA23884@linaro.org>
	 <1400171258.21547.136.camel@deneb.redhat.com>
	 <CAPvkgC2WQcvn5e01Y70cm5nzenYZ6tk_1BampHw66VoRFn7Jiw@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-15 at 18:55 +0100, Steve Capper wrote:
> On 15 May 2014 17:27, Mark Salter <msalter@redhat.com> wrote:
> > On Thu, 2014-05-15 at 15:44 +0100, Steve Capper wrote:
> >> On Thu, May 15, 2014 at 10:19:22AM -0400, Mark Salter wrote:
> >> > The following happens when trying to run a kvm guest on a kernel
> >> > configured for 64k pages. This doesn't happen with 4k pages:
> >> >
> >> >   BUG: failure at include/linux/mm.h:297/put_page_testzero()!
> >> >   Kernel panic - not syncing: BUG!
> >> >   CPU: 2 PID: 4228 Comm: qemu-system-aar Tainted: GF            3.13.0-0.rc7.31.sa2.k32v1.aarch64.debug #1
> >> >   Call trace:
> >> >   [<fffffe0000096034>] dump_backtrace+0x0/0x16c
> >> >   [<fffffe00000961b4>] show_stack+0x14/0x1c
> >> >   [<fffffe000066e648>] dump_stack+0x84/0xb0
> >> >   [<fffffe0000668678>] panic+0xf4/0x220
> >> >   [<fffffe000018ec78>] free_reserved_area+0x0/0x110
> >> >   [<fffffe000018edd8>] free_pages+0x50/0x88
> >> >   [<fffffe00000a759c>] kvm_free_stage2_pgd+0x30/0x40
> >> >   [<fffffe00000a5354>] kvm_arch_destroy_vm+0x18/0x44
> >> >   [<fffffe00000a1854>] kvm_put_kvm+0xf0/0x184
> >> >   [<fffffe00000a1938>] kvm_vm_release+0x10/0x1c
> >> >   [<fffffe00001edc1c>] __fput+0xb0/0x288
> >> >   [<fffffe00001ede4c>] ____fput+0xc/0x14
> >> >   [<fffffe00000d5a2c>] task_work_run+0xa8/0x11c
> >> >   [<fffffe0000095c14>] do_notify_resume+0x54/0x58
> >> >
> >> > In arch/arm/kvm/mmu.c:unmap_range(), we end up doing an extra put_page()
> >> > on the stage2 pgd which leads to the BUG in put_page_testzero(). This
> >> > happens because a pud_huge() test in unmap_range() returns true when it
> >> > should always be false with 2-level pages tables used by 64k pages.
> >> > This patch removes support for huge puds if 2-level pagetables are
> >> > being used.
> >>
> >> Hi Mark,
> >> I'm still catching up with myself, sorry  (was off sick for a couple
> >> of days)...
> >>
> >> I thought unmap_range was going to be changed?
> >> Does the following help things?
> >> https://lists.cs.columbia.edu/pipermail/kvmarm/2014-May/009388.html
> >
> > No, I get the same BUG. Regardless, pud_huge() should always return
> > false for 2-level pagetables, right?
> 
> Okay, thanks for giving that a go.
> 
> Yeah I agree for 64K granule it doesn't make sense to have a huge_pud.
> The patch looks sound now, but checking for a folded pmd may run into
> problems if/when we get to 3-levels and 64K pages in future.
> 
> Perhaps checking for PAGE_SHIFT==12 (or something similar) would be a
> bit more robust?
> 

I don't think testing based on granule size is generally correct either.
Maybe support for 3-level page tables with 64k granule gets added as an
option. That would break the pagesize based test. With a folded pmd, we
know there is no pud, so pud_huge() should always be false.



