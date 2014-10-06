Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaJFUmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 16:42:42 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:37173 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbaJFUml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 16:42:41 -0400
Message-ID: <5432FEB8.401@imgtec.com>
Date: Mon, 6 Oct 2014 13:42:32 -0700
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paul Burton <paul.burton@imgtec.com>
CC: <linux-mips@linux-mips.org>, <Zubair.Kakakhel@imgtec.com>,
        <david.daney@cavium.com>, <peterz@infradead.org>,
        <paul.gortmaker@windriver.com>, <davidlohr@hp.com>,
        <macro@linux-mips.org>, <chenhc@lemote.com>, <zajec5@gmail.com>,
        <james.hogan@imgtec.com>, <keescook@chromium.org>,
        <alex@alex-smith.me.uk>, <tglx@linutronix.de>, <blogic@openwrt.org>,
        <jchandra@broadcom.com>, <qais.yousef@imgtec.com>,
        <linux-kernel@vger.kernel.org>, <ralf@linux-mips.org>,
        <markos.chandras@imgtec.com>, <manuel.lauss@gmail.com>,
        <akpm@linux-foundation.org>, <lars.persson@axis.com>
Subject: Re: [PATCH 2/3] MIPS: Setup an instruction emulation in VDSO protected
 page instead of user stack
References: <20141004030438.28569.85536.stgit@linux-yegoshin> <20141004031730.28569.38511.stgit@linux-yegoshin> <20141006122917.GB4704@pburton-laptop>
In-Reply-To: <20141006122917.GB4704@pburton-laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 05:29 AM, Paul Burton wrote:

>>
>> First some general questions: is there any reason to need the page used
>> to be at the same virtual address for each thread? I can't think of one,
>> and if that's the case then why not simply allocate a series of pages
>> per-thread via mmap_region or similar, on demand when a thread first
>> executes an FP branch instruction? That would of course consume some
>> more virtual address space, but would avoid the hassles of manually
>> prodding at the TLB, tracking ASIDs & flushing the caches. Perhaps the
>> shrinker interface could be used to allow freeing those pages if & when
>> it becomes necessary for long running threads.
The only reason to have the same virtual address is to keep mmap 
accounting the same. An original 'VDSO' is presented in mmap for all 
threads of the same mmap.

As for another approach, I think it may be too much code to handle it 
and too much implicit interlinks with common Linux code and GLIBC/bionic.

>>
>> Also VDSO is really a misnomer throughout, as I've pointed out to you
>> before. I'm aware it's an existing misnomer, but it would be nice if
>> we could clear that up rather than repeat it...
>>
Yes, I agree but that is outside of this patch. I think it has sense to 
rename the current stuff to something like "Emulation" right before some 
patch which implement the real VDSO capability on MIPS.

>> +		if (get_isa16_mode(regs->cp0_epc)) {
>> +			*(u16 *)&fr->emul = (u16)(ir >> 16);
>> +			*((u16 *)(&fr->emul) + 1) = (u16)(ir & 0xffff);
> This microMIPS case doesn't set badinst, as I pointed out internally.
Thank you, I missed it, may be due to long citation. I will add it.

>   I
> think it would be much cleaner if you were to do something along the
> lines of:
>
I try to keep it as close as an original code for better understanding. 
Even with it there are questions.

Your variant may be cleaner but it may be some next style change patch.

- Leonid.

