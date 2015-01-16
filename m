Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbbAPQ4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:56:25 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36372 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687AbbAPQ4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:56:23 -0500
Date: Fri, 16 Jan 2015 16:56:00 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "leo.yan@linaro.org" <leo.yan@linaro.org>,
        "yexl@marvell.com" <yexl@marvell.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] arm64:  Emulate SETEND for AArch32 tasks
Message-ID: <20150116165600.GF32155@leverpostej>
References: <1421325366-13263-1-git-send-email-suzuki.poulose@arm.com>
 <1421325366-13263-4-git-send-email-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421325366-13263-4-git-send-email-suzuki.poulose@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 12:36:06PM +0000, Suzuki K. Poulose wrote:
> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
> 
> Emulate deprecated 'setend' instruction for AArch32 bit tasks.
> 
> 	setend [le/be] - Sets the endianness of EL0
> 
> On systems with CPUs which support mixed endian at EL0, the hardware
> support for the instruction can be enabled by setting the SCTLR_EL1.SED
> bit. Like the other emulated instructions it is controlled by an entry in
> /proc/sys/abi/. For more information see :
> 	Documentation/arm64/legacy_instructions.txt
> 
> The instruction is emulated by setting/clearing the SPSR_EL1.E bit, which
> will be reflected in the PSTATE.E in AArch32 context.
> 
> This patch also restores the native endianness for the execution of signal
> handlers, since the process could have changed the endianness.
> 
> Note: All CPUs on the system should support for mixed endian at EL0. Once the
> handler is registered a CPU which doesn't support mixed endian, cannot be
> hotplugged in.
> 
> Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
> ---
>  Documentation/arm64/legacy_instructions.txt |    9 +++
>  arch/arm64/Kconfig                          |   10 ++++
>  arch/arm64/include/asm/cpufeature.h         |    1 +
>  arch/arm64/include/asm/ptrace.h             |    7 +++
>  arch/arm64/kernel/armv8_deprecated.c        |   82 +++++++++++++++++++++++++++
>  arch/arm64/kernel/signal32.c                |    5 +-
>  6 files changed, 113 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/arm64/legacy_instructions.txt b/Documentation/arm64/legacy_instructions.txt
> index 0a4dc26..92b7945 100644
> --- a/Documentation/arm64/legacy_instructions.txt
> +++ b/Documentation/arm64/legacy_instructions.txt
> @@ -47,3 +47,12 @@ Default: Undef (0)
>  Node: /proc/sys/abi/cp15_barrier
>  Status: Deprecated
>  Default: Emulate (1)
> +
> +* SETEND
> +Node: /proc/sys/abi/setend
> +Status: Deprecated
> +Default: Emulate (1)*
> +Note: All the cpus on the system should support mixed endian at EL0
> +(ID_AA64MMFR0_EL1:BigEnd or BigEndEL0), for this feature to be enabled.

This might read a little better as:

  Note: all CPUs in the system must have mixed-endian support at EL0 for
  this feature to be enabled.

That matches the ARM ARM wording for ID_AA64MMFR0_EL1. We shouldn't need
to mention the particular register fields here.

Also, we should probably add a note at the top like:

  Note: instruction emulation may not be possible in all cases. See
  below for further information.

Thanks,
Mark.
