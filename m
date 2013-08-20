Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab3HTQRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:17:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33799 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255Ab3HTQRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:17:36 -0400
Date: Tue, 20 Aug 2013 17:16:58 +0100
From: Will Deacon <will.deacon@arm.com>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v3 4/6] ARM64: arch_timer: configure and enable event
 stream
Message-ID: <20130820161658.GD27819@mudshark.cambridge.arm.com>
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376414984-14182-5-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <20130820132712.GE26129@mudshark.cambridge.arm.com>
 <52137CD5.7010201@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52137CD5.7010201@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 03:27:33PM +0100, Sudeep KarkadaNagesha wrote:
> On 20/08/13 14:27, Will Deacon wrote:
> > On Tue, Aug 13, 2013 at 06:29:42PM +0100, Sudeep KarkadaNagesha wrote:
> >> diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
> >> index 6d4482f..effd8f9 100644
> >> --- a/arch/arm64/include/asm/hwcap.h
> >> +++ b/arch/arm64/include/asm/hwcap.h
> >> @@ -30,6 +30,7 @@
> >>  #define COMPAT_HWCAP_IDIVA	(1 << 17)
> >>  #define COMPAT_HWCAP_IDIVT	(1 << 18)
> >>  #define COMPAT_HWCAP_IDIV	(COMPAT_HWCAP_IDIVA|COMPAT_HWCAP_IDIVT)
> >> +#define COMPAT_HWCAP_EVTSTRM	(1 << 21)
> > 
> > Looking at the context, we should also add COMPAT_HWCAP_LPAE as a separate
> > patch (not part of this series).
> > 
> Ok make sense, I can do that. IIUC even this needs at least under some
> config option, assuming can't be dynamic ?

I'm not sure I follow you... if you're asking whether the LPAE HWCAP should
be dynamic for ARMv8, then no, since the capabilities offered by LPAE are
included in ARMv8 as far as userspace is concerned.

> >>  #ifndef __ASSEMBLY__
> >>  /*
> >> @@ -41,7 +42,8 @@
> >>  				 COMPAT_HWCAP_FAST_MULT|COMPAT_HWCAP_EDSP|\
> >>  				 COMPAT_HWCAP_TLS|COMPAT_HWCAP_VFP|\
> >>  				 COMPAT_HWCAP_VFPv3|COMPAT_HWCAP_VFPv4|\
> >> -				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV)
> >> +				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV|\
> >> +				 COMPAT_HWCAP_EVTSTRM)
> > 
> > So here you're hardcoding COMPAT_HWCAP_EVTSTRM in the COMPAT_ELF_HWCAP, yet
> > we only enable the native one from the arch-timer driver. The question then is
> > "Can we rely on the event-stream working for AArch64?". If so, we don't need
> > the native hwcap at all. If not, then we need to make the compat hwcap
> > dynamic.
> 
> How about something like this ? I am not sure if
> arch/arm64/kernel/setup.c is apt place for compat_elf_hwcap though.

Looks like the right sort of idea, yes. I can't think of a better place to
put it. You could adjust it slightly so that COMPAT_ELF_HWCAP stays like it
is, with an extra '| compat_dyn_elf_hwcap' on the end, but I have no real
preference.

Will
