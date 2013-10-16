Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794Ab3JPQH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:07:57 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55922 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab3JPQHz convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Wed, 16 Oct 2013 12:07:55 -0400
Message-Id: <525ED5F602000078000FB948@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 16 Oct 2013 17:07:50 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] x86-64: properly handle FPU code/data
 selectors
References: <525E9BFF02000078000FB74E@nat28.tlf.novell.com>
 <525EB320.2000607@zytor.com>
In-Reply-To: <525EB320.2000607@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.10.13 at 17:39, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 10/16/2013 05:00 AM, Jan Beulich wrote:
>> Having had reports of certain Windows versions, when put in some
>> special driver verification mode, blue-screening due to the FPU state
>> having changed across interrupt handler runs (resulting from a host/
>> hypervisor side context switch somewhere in the middle of the guest
>> interrupt handler execution) on Xen, and assuming that KVM would suffer
>> from the same problem, as well as having also noticed (long ago) that
>> 32-bit processes don't behave correctly in this regard when run on a
>> 64-bit kernel, this is the resulting attempt to port (and suitably
>> extend) the Xen side fix to Linux.
>> 
>> The basic idea here is to either use a priori information on the
>> intended state layout (in the case of 32-bit processes) or "sense" the
>> proper layout (in the case of KVM guests) by inspecting the already
>> saved FPU rip/rdp, and reading their actual values in a second save
>> operation.
>> 
>> This second save operation could be another [F]XSAVE, but on all
>> systems I measured this on using FNSTENV turned out to be the faster
>> alternative.
> 
> It is not at all clear to me from the description what the flow is that
> causes the problem, whatever the problem is.  Perhaps it should be if I
> wasn't horribly sleep-deprived, but the description should be clear
> enough that one should be able to tell the problem at a glance.
> 
> Please describe the flow that causes trouble.
> 
> Is this basically a problem with the 32-bit version of FXSAVE versus the
> 64-bit version?

Correct. The problem is that if you save a 32-bit entity's context
with a 64-bit [F]XSAVE, the selectors will get lost.

The problem arises with that special Windows driver verification
mode saving floating point state before and after an interrupt
handler (or some such) gets invoked, bug checking if the two
saved images don't match (which they can't if Windows is 32-bit
but there was a context save/restore in between in the 64-bit
hypervisor using 64-bit [F]XSAVE).

> Furthermore, you define X86_FEATURE_NO_FPU_SEL, but you don't set it
> anywhere.  At least that bit needs to be factored out into a separate patch.

That's already being done in get_cpu_cap(), as it's part of
x86_capability[9].

> +	if (config_enabled(CONFIG_IA32_EMULATION) &&
> +	    test_tsk_thread_flag(tsk, TIF_IA32))
> 
> is_ia32_task()?

That'd imply that "tsk == current" in all cases, which I don't
think is right here.

Jan

