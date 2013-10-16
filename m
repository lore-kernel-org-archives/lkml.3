Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902Ab3JPPk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:40:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59329 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab3JPPk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:40:26 -0400
Message-ID: <525EB320.2000607@zytor.com>
Date: Wed, 16 Oct 2013 08:39:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
CC: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] x86-64: properly handle FPU code/data selectors
References: <525E9BFF02000078000FB74E@nat28.tlf.novell.com>
In-Reply-To: <525E9BFF02000078000FB74E@nat28.tlf.novell.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 05:00 AM, Jan Beulich wrote:
> Having had reports of certain Windows versions, when put in some
> special driver verification mode, blue-screening due to the FPU state
> having changed across interrupt handler runs (resulting from a host/
> hypervisor side context switch somewhere in the middle of the guest
> interrupt handler execution) on Xen, and assuming that KVM would suffer
> from the same problem, as well as having also noticed (long ago) that
> 32-bit processes don't behave correctly in this regard when run on a
> 64-bit kernel, this is the resulting attempt to port (and suitably
> extend) the Xen side fix to Linux.
> 
> The basic idea here is to either use a priori information on the
> intended state layout (in the case of 32-bit processes) or "sense" the
> proper layout (in the case of KVM guests) by inspecting the already
> saved FPU rip/rdp, and reading their actual values in a second save
> operation.
> 
> This second save operation could be another [F]XSAVE, but on all
> systems I measured this on using FNSTENV turned out to be the faster
> alternative.

It is not at all clear to me from the description what the flow is that
causes the problem, whatever the problem is.  Perhaps it should be if I
wasn't horribly sleep-deprived, but the description should be clear
enough that one should be able to tell the problem at a glance.

Please describe the flow that causes trouble.

Is this basically a problem with the 32-bit version of FXSAVE versus the
64-bit version?

Furthermore, you define X86_FEATURE_NO_FPU_SEL, but you don't set it
anywhere.  At least that bit needs to be factored out into a separate patch.

+	if (config_enabled(CONFIG_IA32_EMULATION) &&
+	    test_tsk_thread_flag(tsk, TIF_IA32))

is_ia32_task()?

	-hpa


