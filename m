Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbaIKPRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:17:34 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:47491 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbaIKPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:17:31 -0400
Message-ID: <5411BD03.3010206@linux.vnet.ibm.com>
Date: Thu, 11 Sep 2014 20:47:23 +0530
From: Shreyas B Prabhu <shreyas@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC: Paul Mackerras <paulus@samba.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Srivatsa S. Bhat" <srivatsa@MIT.EDU>,
        "Preeti U. Murthy" <preeti@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 0/9] powerpc/powernv: Support for fastsleep and winkle
References: <1408989673-14137-1-git-send-email-shreyas@linux.vnet.ibm.com>
In-Reply-To: <1408989673-14137-1-git-send-email-shreyas@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091115-0005-0000-0000-000000F57306
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Any updates on this patch series?

On Monday 25 August 2014 11:31 PM, Shreyas B. Prabhu wrote:
> Fast sleep is an idle state, where the core and the L1 and L2
> caches are brought down to a threshold voltage. This also means that
> the communication between L2 and L3 caches have to be fenced. However
> the current P8 chips have a bug wherein this fencing between L2 and
> L3 caches get delayed by a cpu cycle. This can delay L3 response to
> the other cpus if they request for data during this time. Thus they
> would fetch the same data from the memory which could lead to data
> corruption if L3 cache is not flushed.
> Patch 4 adds support to work around this.
> 
> 'Deep Winkle' is a deeper idle state where core and private L2 are powered
> off. While it offers higher power savings, it is at the cost of losing
> hypervisor register state and higher latency.
> Patch 5-9 adds support for winkle and uses it for offline cpus.
> 
> Patch 1 - Moves parameters required discover idle states to a location 
> common to both cpuidle driver and powernv core code
> Patch 2 - Populates idle state details from device tree
> Patch 3 - Enables cpus to run guest after waking up from fastsleep/winkle
> 
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Srivatsa S. Bhat <srivatsa@MIT.EDU>
> Cc: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
> Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: devicetree@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> 
> Preeti U Murthy (2):
>   cpuidle/powernv: Populate cpuidle state details by querying the
>     device-tree
>   powerpc/powernv/cpuidle: Add workaround to enable fastsleep
> 
> Shreyas B. Prabhu (6):
>   powerpc/kvm/book3s_hv: Enable CPUs to run guest after waking up from
>     fast-sleep
>   powerpc/powernv: Add OPAL call to save and restore
>   powerpc: Adding macro for accessing Thread Switch Control Register
>   powerpc/powernv: Add winkle infrastructure
>   powerpc/powernv: Discover and enable winkle
>   powerpc/powernv: Enter deepest supported idle state in offline
> 
> Srivatsa S. Bhat (1):
>   powerpc/powernv: Enable Offline CPUs to enter deep idle states
> 
>  arch/powerpc/include/asm/machdep.h             |   4 +
>  arch/powerpc/include/asm/opal.h                |  10 ++
>  arch/powerpc/include/asm/paca.h                |   3 +
>  arch/powerpc/include/asm/ppc-opcode.h          |   2 +
>  arch/powerpc/include/asm/processor.h           |   6 +-
>  arch/powerpc/include/asm/reg.h                 |   1 +
>  arch/powerpc/kernel/asm-offsets.c              |   1 +
>  arch/powerpc/kernel/exceptions-64s.S           |  37 ++---
>  arch/powerpc/kernel/idle.c                     |  30 ++++
>  arch/powerpc/kernel/idle_power7.S              |  83 +++++++++-
>  arch/powerpc/platforms/powernv/opal-wrappers.S |   2 +
>  arch/powerpc/platforms/powernv/powernv.h       |   8 +
>  arch/powerpc/platforms/powernv/setup.c         | 217 +++++++++++++++++++++++++
>  arch/powerpc/platforms/powernv/smp.c           |  13 +-
>  arch/powerpc/platforms/powernv/subcore.c       |  15 ++
>  drivers/cpuidle/cpuidle-powernv.c              |  40 ++++-
>  16 files changed, 439 insertions(+), 33 deletions(-)
> 

