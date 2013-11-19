Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3KSM1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 07:27:47 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51337 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751563Ab3KSM1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 07:27:45 -0500
Date: Tue, 19 Nov 2013 12:26:56 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: move firmware_ops to drivers/firmware
Message-ID: <20131119122656.GF26487@arm.com>
References: <1384678169-28228-1-git-send-email-acourbot@nvidia.com>
 <CAHkRjk5LBOFx3ir49RgEsaFwvp5UCpTjYFWto+URXebAsOP0RA@mail.gmail.com>
 <52898417.80601@nvidia.com>
 <20131118115842.GE4050@arm.com>
 <528AD11F.7060009@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528AD11F.7060009@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 02:46:55AM +0000, Alex Courbot wrote:
> On 11/18/2013 08:58 PM, Catalin Marinas wrote:
> > On Mon, Nov 18, 2013 at 03:05:59AM +0000, Alex Courbot wrote:
> >> On 11/18/2013 12:59 AM, Catalin Marinas wrote:
> >>> On 17 November 2013 08:49, Alexandre Courbot <acourbot@nvidia.com> wrote:
> >>>> The ARM tree includes a firmware_ops interface that is designed to
> >>>> implement support for simple, TrustZone-based firmwares but could
> >>>> also cover other use-cases. It has been suggested that this
> >>>> interface might be useful to other architectures (e.g. arm64) and
> >>>> that it should be moved out of arch/arm.
> >>>
> >>> NAK. I'm for code sharing with arm via common locations but this API
> >>> goes against the ARMv8 firmware standardisation efforts like PSCI,
> >>> encouraging each platform to define there own non-standard interface.
> >>
> >> I have to say, I pretty much agree with your NAK.
> >>
> >> The reason for this patch is that the suggestion to move firmware_ops
> >> out of arch/arm is the last (I hope) thing that prevents my Trusted
> >> Foundation support series from being merged.
> >
> > Moving it into drivers shouldn't be a workaround. Nice try ;).
> 
> Hehe. I thought that just sending a patch would settle the issue one way 
> or the other and avoid a huge discussion. Woke up this morning to see 
> how wrong I was.

It's a sensitive topic ;).

> > BTW, is legacy code the reason for not converting the SMC # to PSCI?
> > It's already supported on ARMv7, so you may not have much code left to
> > merge in the kernel ;).
> 
> The problem here is twofold:
> 
> 1) we are just consumers of the TrustZone secure monitor who receive a 
> binary and do not have any control over its calling conventions. I agree 
> that it would be trivial to make it compatible with PSCI, but it's just 
> not something we can make by ourselves (TF does not even follow the SMC 
> calling convention). If this problem is to be addressed, it should be 
> done by forcing the TrustZone secure monitors providers to follow PSCI.

I agree and such discussions do happen ('forcing' is a bit harder, more
like 'strongly recommending'). On my side, I voice this message via the
Linux channels, so SoC vendors can also encourage their secure provider
in this direction. The benefit is that the Linux changes are minimal
afterwards, single image is easier.

But as I replied to Stephen, make sure you separate the secure OS (EL1)
from the secure firmware (EL3). The latter (or parts of it) are provided
by the SoC vendor (e.g. NVidia) and may be eventually linked into a big
blob by the secure OS provider. ARM is encouraging separation here and a
multi-stage firmware loading approach (and ARM started a public generic
firmware project, it's in the early days now).

> 2) devices have already shipped with this firmware. Are we going to just 
> renounce supporting them, even though the necessary support is 
> lightweight and fits within already existing interfaces?

I'm talking only about ARMv8 here. Please see my reply to Stephen for
the details of (not) reusing existing firmware.

> I certainly do hope that for ARMv8 things will be different and more 
> standardized. But that's not something that can be guaranteed unless ARM 
> strongly enforces it to firmware vendors. In case such a non-standard 
> firmware gets used again, I *do* hope that using cpu_ops will be 
> preferred over saying "this device cannot be supported in mainline, ever".

cpu_ops or firmware_ops is just a name and can be unified (TBD what
common functionality it contains). What I don't want to encourage is
each SoC registering its own firmware interface.

> The kernel already supports non-standard hardware, BIOS, ACPI through 
> hacks that are *way* more horrible than that. This should certainly not 
> be encouraged, but that's not a valid reason to forbid otherwise 
> perfectly fine devices to run mainline IMHO.

So you say we should just stop trying to standardise anything because
people don't care anyway. Why do we even bother with DT (or ACPI) since
board files were fine in the past (with a bit more code)?

> >> * that should a need to move it (for whatever reason) occur later, it
> >> will be easy to do (as this patch hopefully demonstrates).
> >
> > I agree, it's not hard to unify this but so far I haven't seen a good
> > reason.
> 
> Same here. arm64 has its own cpu_operations. Other archs have different 
> needs and if we move this to a common place it will just become a messy 
> placeholder for function pointers from which each arch will only use a 
> subset.

That was my initial point but it turned into a thread against PSCI
(again ;)).

-- 
Catalin
