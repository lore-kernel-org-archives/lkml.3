Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbaJHMt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 08:49:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42031 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753787AbaJHMt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:49:57 -0400
Date: Wed, 8 Oct 2014 13:49:28 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] ARM: vfp: fix VFPv3 hwcap detection on non-ARM vfp
 implementations
Message-ID: <20141008124927.GK26140@arm.com>
References: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org>
 <1411076592-6157-3-git-send-email-sboyd@codeaurora.org>
 <20140918224625.GF5182@n2100.arm.linux.org.uk>
 <541C74C1.9060504@codeaurora.org>
 <542C3FCA.2010006@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542C3FCA.2010006@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Wed, Oct 01, 2014 at 06:54:18PM +0100, Stephen Boyd wrote:
> On 09/19/14 11:24, Stephen Boyd wrote:
> > On 09/18/14 15:46, Russell King - ARM Linux wrote:
> >> I know that you're changing this to conform with the ARM ARM, but we
> >> have to consider that before VFP was subsumed into the ARM ARM, this
> >> register had the format described as per this file, and these other
> >> bits may be set for an ARM part.  Including these bits in the mask
> >> means that we will mis-identify these older parts as VFPv3.
> >>
> > Do you, or anyone else, know of other implementations? I *hope* that
> > this same exercise was done by the VFP architects before they
> > re-purposed bits but who knows. If nobody is actually setting these
> > higher bits then is there any problem widening the mask (besides it
> > being slightly confusing)?
> >
> 
> Any thoughts?

I've spoken to the architects about this, and it seems that you need to
parse FPSID differently depending upon whether you are a v7 CPU or not.

However, as you are well aware, detecting whether or not you are v7 isn't as
simple as it sounds. cpu_architecture() checks the VMSA/PMSA fields in
MMFR0, but that's not quite right for 11MPcore (and 1176 iirc), which are
v6 implementations.

So, it sounds like the scheme is:

  if (revised_cpuid_format()) // i.e. MIDR.Architecture == 0xF
	determine_vfp_arch_using_mvfr_regs();
  else
        determine_vfp_arch_using_fpsid();

which in turn means that we probably need to rethink how we want to
advertise floating point hardware features in the future. ARMv8, for
example, adds an additional MVFR2 register, which advertises additional
floating point instructions without explicitly creating something akin to
VFPv5.

Will
