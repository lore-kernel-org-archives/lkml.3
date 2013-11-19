Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab3KSLjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:39:46 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53631 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751776Ab3KSLjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:39:44 -0500
Date: Tue, 19 Nov 2013 11:38:58 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alex Courbot <acourbot@nvidia.com>, Alexandre Courbot <gnurou@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Stephen Warren <swarren@nvidia.com>, Tomasz Figa <t.figa@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: move firmware_ops to drivers/firmware
Message-ID: <20131119113858.GE26487@arm.com>
References: <1384678169-28228-1-git-send-email-acourbot@nvidia.com>
 <CAHkRjk5LBOFx3ir49RgEsaFwvp5UCpTjYFWto+URXebAsOP0RA@mail.gmail.com>
 <52898417.80601@nvidia.com>
 <20131118115842.GE4050@arm.com>
 <528A4869.2020701@wwwdotorg.org>
 <20131118173047.GF9838@arm.com>
 <528A53E4.90401@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528A53E4.90401@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 05:52:36PM +0000, Stephen Warren wrote:
> On 11/18/2013 10:30 AM, Catalin Marinas wrote:
> > On Mon, Nov 18, 2013 at 05:03:37PM +0000, Stephen Warren wrote:
> >> On 11/18/2013 04:58 AM, Catalin Marinas wrote:
> >> ...
> >>> Of course, trusted foundations interface could be plugged into cpu_ops
> >>> on arm64 but I will NAK it on the grounds of not using the PSCI API, nor
> >>> the SMC calling convention (and it's easy to fix when porting to ARMv8).
> >>> If a supported standard API is used, then there is no need for
> >>> additional code in the kernel.
> >>
> >> What happens when someone takes an existing working secure-mode SW stack
> >> and simply re-uses it on some new ARMv8 SoC. Are you going to force
> >> people working on upstream to re-write the secure mode firmware in
> >> shipped hardware before allowing upstream kernel support?
> > 
> > Don't confuse the secure stack with the secure monitor running at EL3.
> > If you want AArch64 support for lower levels (EL2, EL1, EL0), your
> > monitor _must_ be AArch64. You can't run legacy AArch32 code at EL3 and
> > have lower levels in AArch64 mode (architectural constraint).
> 
> I was assuming that vendors would take the existing source code and
> simply rebuild it to create the AArch64 secure world.

Some C code can probably be reused but not the EL3 entry/exit code,
world switching and AArch64 initialisation. The main differences in
ARMv8 EL3 is that it has its own MMU and it can only be entered via SMC
and exit via ERET (you can no longer switch from/to secure SVC by
writing to CPSR). So apart from a different instruction set, the new
exception model requires a rewrite of the secure monitor logic used to
handle SMCs, switch worlds, pass arguments between worlds.

> As such, the same SMC IDs, same structures, etc. would be used. The
> only source difference would be to perhaps change some 32-bit
> registers/struct-fields up to 64-bit. Naively that sounds like the
> lowest-effort way to get an AArch64 secure world, so I'm purely
> guessing that that's what vendors will do.

It looks simpler in theory until you hit the new exception model and
realise the clear separation between EL3 (previously secure monitor) and
secure EL1 (previously secure SVC). I'm not referring to the whole
secure stack here, just the things I mentioned above.

> > You can
> > still keep the secure services at S-EL1 in AArch32, only that the SMCs
> > are handled by EL3 (and that's another aspect the SMC calling convention
> > spec is trying to address, mixed register-width secure/non-secure OSes).
> 
> I'm not sure of the implications of that statement. Since you mention
> SMCs being handled by EL3, I think the quick-and-dirty conversion I
> mention above is still likely to be used.

What I meant is that a secure OS (providing cryptography, banking etc.
services) can run in secure EL1 in AArch32 mode, it does not need to be
converted (though it helps from a performance perspective, new
instructions). But the world switching (which is pretty tightly coupled
with secure SVC on ARMv7) and SMC handling need to be rewritten.

And it's usually EL3 where you would place power management firmware on
ARMv8 (cache/TLB maintenance, power controller access). This is usually
done by the SoC vendor and not the secure OS provider (the latter may do
the final link).

-- 
Catalin
