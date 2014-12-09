Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbaLIQPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:15:39 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:47126 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296AbaLIQPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:15:37 -0500
Date: Tue, 9 Dec 2014 16:15:11 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: psci: Fix build breakage without PM_SLEEP
Message-ID: <20141209161511.GI31129@e104818-lin.cambridge.arm.com>
References: <1418125716-18528-1-git-send-email-k.kozlowski@samsung.com>
 <2290734.BRljGaICu4@wuerfel>
 <1418128689.19339.3.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1418128689.19339.3.camel@AMDC1943>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 12:38:09PM +0000, Krzysztof Kozlowski wrote:
> On wto, 2014-12-09 at 13:29 +0100, Arnd Bergmann wrote:
> > On Tuesday 09 December 2014 12:48:36 Krzysztof Kozlowski wrote:
> > > Fix build failure of defconfig when PM_SLEEP is disabled (e.g. by
> > > disabling SUSPEND) and CPU_IDLE enabled:
> > > 
> > > arch/arm64/kernel/psci.c:543:2: error: unknown field ‘cpu_suspend’ specified in initializer
> > >   .cpu_suspend = cpu_psci_cpu_suspend,
> > >   ^
> > > arch/arm64/kernel/psci.c:543:2: warning: initialization from incompatible pointer type [enabled by default]
> > > arch/arm64/kernel/psci.c:543:2: warning: (near initialization for ‘cpu_psci_ops.cpu_prepare’) [enabled by default]
> > > make[1]: *** [arch/arm64/kernel/psci.o] Error 1
> > > 
> > > The cpu_operations.cpu_suspend field exists only if ARM64_CPU_SUSPEND is
> > > defined, not CPU_IDLE.
> > > 
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > 
> > 
> > No objection to fixing this obvious build bug, but why do we even have
> > an ARM64_CPU_SUSPEND option? On ARM32 we only have the respective option
> > because we have a random collection of platform specific drivers that
> > use the symbols, but that's not the case on ARM64.
> 
> I believe because of cpuidle. It's the same as on ARM32: the cpu_suspend
> is used by both PM_SLEEP and CPU_IDLE.

I guess at some point we can replace (as a separate patch)
ARM64_CPU_SUSPEND with PM_SLEEP.

But what I don't fully understand, we can enable CPU_IDLE without
ARM64_CPU_SUSPEND. However, the cpuidle-arm64.c driver will fail to
link since it calls cpu_suspend(). Wouldn't it be better if
ARM64_CPU_SUSPEND depends on CPU_PM (or replaced by it) rather than
PM_SLEEP?

Can we allow deeper idle states when CONFIG_SUSPEND is disabled? I see
CONFIG_SUSPEND related to suspend-to-RAM (system standby) rather than
CPU idle, in which case we may want to allow cpu_suspend when only
CPU_IDLE is enabled (which implies CONFIG_CPU_PM).

-- 
Catalin
