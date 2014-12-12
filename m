Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030363AbaLLPGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:06:18 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45115 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbaLLPGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:06:16 -0500
Date: Fri, 12 Dec 2014 15:06:08 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: psci: Fix build breakage without PM_SLEEP
Message-ID: <20141212150608.GA4853@e102568-lin.cambridge.arm.com>
References: <1418125716-18528-1-git-send-email-k.kozlowski@samsung.com>
 <2290734.BRljGaICu4@wuerfel>
 <1418128689.19339.3.camel@AMDC1943>
 <20141209161511.GI31129@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
In-Reply-To: <20141209161511.GI31129@e104818-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 12 Dec 2014 15:06:12.0328 (UTC) FILETIME=[2AE55680:01D0161D]
X-MC-Unique: 114121215061411701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 04:15:11PM +0000, Catalin Marinas wrote:
> On Tue, Dec 09, 2014 at 12:38:09PM +0000, Krzysztof Kozlowski wrote:
> > On wto, 2014-12-09 at 13:29 +0100, Arnd Bergmann wrote:
> > > On Tuesday 09 December 2014 12:48:36 Krzysztof Kozlowski wrote:
> > > > Fix build failure of defconfig when PM_SLEEP is disabled (e.g. by
> > > > disabling SUSPEND) and CPU_IDLE enabled:
> > > > 
> > > > arch/arm64/kernel/psci.c:543:2: error: unknown field 'cpu_suspend' specified in initializer
> > > >   .cpu_suspend = cpu_psci_cpu_suspend,
> > > >   ^
> > > > arch/arm64/kernel/psci.c:543:2: warning: initialization from incompatible pointer type [enabled by default]
> > > > arch/arm64/kernel/psci.c:543:2: warning: (near initialization for 'cpu_psci_ops.cpu_prepare') [enabled by default]
> > > > make[1]: *** [arch/arm64/kernel/psci.o] Error 1
> > > > 
> > > > The cpu_operations.cpu_suspend field exists only if ARM64_CPU_SUSPEND is
> > > > defined, not CPU_IDLE.
> > > > 
> > > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > > 
> > > 
> > > No objection to fixing this obvious build bug, but why do we even have
> > > an ARM64_CPU_SUSPEND option? On ARM32 we only have the respective option
> > > because we have a random collection of platform specific drivers that
> > > use the symbols, but that's not the case on ARM64.
> > 
> > I believe because of cpuidle. It's the same as on ARM32: the cpu_suspend
> > is used by both PM_SLEEP and CPU_IDLE.
> 
> I guess at some point we can replace (as a separate patch)
> ARM64_CPU_SUSPEND with PM_SLEEP.
> 
> But what I don't fully understand, we can enable CPU_IDLE without
> ARM64_CPU_SUSPEND. However, the cpuidle-arm64.c driver will fail to
> link since it calls cpu_suspend(). Wouldn't it be better if
> ARM64_CPU_SUSPEND depends on CPU_PM (or replaced by it) rather than
> PM_SLEEP?

I think that ARM64_CPU_SUSPEND should depend on PM_SLEEP || CPU_IDLE,
if CPU_IDLE is enabled it is certainly because some idle states are
expected to be present, true, not all of them lose context (which is
why ARM64_CPU_SUSPEND is needed, to save/restore context and clean
it to RAM), but I think that's too fine grain, making it depend on
CPU_IDLE should be ok.

Having CPU_IDLE enabled without arm64 cpuidle driver enabled (which
selects ARM64_CPU_SUSPEND) is useless at the moment.

As to cpu_ops, I think that the suspend hook should ifdef on CPU_IDLE,
but I have to wait and see how we implement S2R to make it a final
decision.

> Can we allow deeper idle states when CONFIG_SUSPEND is disabled? I see
> CONFIG_SUSPEND related to suspend-to-RAM (system standby) rather than
> CPU idle, in which case we may want to allow cpu_suspend when only
> CPU_IDLE is enabled (which implies CONFIG_CPU_PM).

Yes, deep idle states are enabled even when suspend is disabled, but
both S2R and CPU_IDLE should turn on ARM64_CPU_SUSPEND to save/restore
context, unless we remove ARM64_CPU_SUSPEND entirely and we always
compile that code in.

I will put together a patch first thing next week to clarify this
thread.

Thanks,
Lorenzo

