Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128AbaJJAHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 20:07:19 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:32382 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaJJAHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 20:07:17 -0400
Message-ID: <5437232F.60800@imgtec.com>
Date: Thu, 9 Oct 2014 17:07:11 -0700
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: <linux-mips@linux-mips.org>, <Zubair.Kakakhel@imgtec.com>,
        <geert+renesas@glider.be>, <david.daney@cavium.com>,
        <peterz@infradead.org>, <paul.gortmaker@windriver.com>,
        <davidlohr@hp.com>, <macro@linux-mips.org>, <chenhc@lemote.com>,
        <richard@nod.at>, <zajec5@gmail.com>, <keescook@chromium.org>,
        <alex@alex-smith.me.uk>, <tglx@linutronix.de>, <blogic@openwrt.org>,
        <jchandra@broadcom.com>, <paul.burton@imgtec.com>,
        <qais.yousef@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <ralf@linux-mips.org>, <markos.chandras@imgtec.com>,
        <dengcheng.zhu@imgtec.com>, <manuel.lauss@gmail.com>,
        <akpm@linux-foundation.org>, <lars.persson@axis.com>
Subject: Re: [PATCH v2 2/3] MIPS: Setup an instruction emulation in VDSO protected
 page instead of user stack
References: <20141009195030.31230.58695.stgit@linux-yegoshin> <20141009200017.31230.69698.stgit@linux-yegoshin> <20141009224304.GA4818@jhogan-linux.le.imgtec.org> <543715D7.1020505@imgtec.com> <20141009234044.GB4818@jhogan-linux.le.imgtec.org>
In-Reply-To: <20141009234044.GB4818@jhogan-linux.le.imgtec.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 04:40 PM, James Hogan wrote:
>
>> It may be a case for mix of FPU and MIPS R6 emulations. I just keep both
>> emulators separate as much as possible but I assume that without prove
>> it may be stackable - some rollback is needed to join both and it may
>> (probably) cause a double emulation setup - dsemul may be called twice
>> for the same pair of instructions. I didn't see that yet, honestly and
>> you may be right.
> If the only time they're used is for emulation of a branch delay slot
> instruction which should never be another branch, and signals always
> undo the emuframe before being handled (btw, should the BD bit in cause
> get set if rewinding for signal handlers/gdb?), then it stands to reason
> it should never nest.

I don't want to give a chance. If it is proved excessive, then slashing 
it - 15minutes, it doesn't harm.

OK, I will spend some time to look into that, it have sense to 
reconsider after unwinding signals.

>
> You could then avoid the whole stack and per-thread thing and just have
> a maximum of one emuframe dedicated to each thread or allocated on
> demand, and if there genuinely is a use case for nesting later on, worry
> about it then.

As I understand, you propose to allocate some space in mmap.

This requires a stuff to handle allocation of user space beyond VMAs.
It also may have some pain during thread creation, stopping and 
subsequent cloning because that memory allocator should service that 
events too and it may be not easy if emulation blocks are packed into 
page. If it is not packed then it waste of user space and put additional 
constraint to number of thread on single mmap.

Some cooperation with GLIBC may be needed to prevent re-use of user 
address space, at a moment not sure the extent of it.

I estimated that it can be much more troubling.

>
> So long as the kernel handles a long sequence of sequential emulated
> branches gracefully (not necessarily correctly).
>
I don't understand a question. Each pair/single instruction is emulated 
separately but there is some pipeline of that, even in FPU emulator, it 
is just not this patch issue.

