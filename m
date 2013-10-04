Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab3JDRYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:24:50 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:37030 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3JDRYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:24:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130918095003.GB1783@mudshark.cambridge.arm.com>
References: <20130917215749.GA11109@obsidianresearch.com>
	<20130918091748.GA1783@mudshark.cambridge.arm.com>
	<20130918095003.GB1783@mudshark.cambridge.arm.com>
Date: Fri, 4 Oct 2013 19:24:48 +0200
Message-ID: <CAPNxggZ0WesjMdi=Yy=QYd_ASrGRiosimqzqb++1=mgus3RRdA@mail.gmail.com>
Subject: Re: Commit breaks strace: ARM: entry: allow ARM-private syscalls to
 be restarted
From: Arokux X <arokux@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 11:50 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Wed, Sep 18, 2013 at 10:17:48AM +0100, Will Deacon wrote:
>> On Tue, Sep 17, 2013 at 10:57:49PM +0100, Jason Gunthorpe wrote:
>> > This happens with the latest git head for strace, as well as the 4.7
>> > release.
>> >
>> > Hopefully you can cook up a fix :)
>>
>> I'll take a look today, thanks.
>
> Ok, looks like the backwards branch to the syscall dispatching logic from
> the trace entry is busted. Can you try the patch below please?
>
> I might also take a look at unifying the function prototypes for arm_syscall
> and syscall_trace_enter, since it should help us remove some of the argument
> shuffling in the trace path.
>
> Will
>
> --->8
>
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index 74ad15d1..bc6bd96 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -442,10 +442,10 @@ local_restart:
>         ldrcc   pc, [tbl, scno, lsl #2]         @ call sys_* routine
>
>         add     r1, sp, #S_OFF
> -       cmp     scno, #(__ARM_NR_BASE - __NR_SYSCALL_BASE)
> +2:     cmp     scno, #(__ARM_NR_BASE - __NR_SYSCALL_BASE)
>         eor     r0, scno, #__NR_SYSCALL_BASE    @ put OS number back
>         bcs     arm_syscall
> -2:     mov     why, #0                         @ no longer a real syscall
> +       mov     why, #0                         @ no longer a real syscall
>         b       sys_ni_syscall                  @ not private func
>
>  #if defined(CONFIG_OABI_COMPAT) || !defined(CONFIG_AEABI)

Just stumbled upon the same issue. The patch seems to cure the problem. Thanks.
