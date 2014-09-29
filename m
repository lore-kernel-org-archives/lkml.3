Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbaI2XJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:09:03 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59557 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755159AbaI2XIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:08:55 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Shreyas B Prabhu <shreyas@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Srivatsa S. Bhat" <srivatsa@mit.edu>,
        "Preeti U. Murthy" <preeti@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 0/9] powerpc/powernv: Support for fastsleep and winkle
Date: Tue, 30 Sep 2014 01:28:50 +0200
Message-ID: <128377046.aOTypBOIY8@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5429330A.7000103@linux.vnet.ibm.com>
References: <1408989673-14137-1-git-send-email-shreyas@linux.vnet.ibm.com> <541A4D4F.1090307@linux.vnet.ibm.com> <5429330A.7000103@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 29, 2014 03:53:06 PM Shreyas B Prabhu wrote:
> Hi,
> Any updates on this patch series?

I have a couple of patches from there in my tree it seems.  Please have a look
at linux-pm.git/linux-next and please let me know if that's the case.


> On Thursday 18 September 2014 08:41 AM, Shreyas B Prabhu wrote:
> > Hi,
> > 
> > In this patch series we use winkle for offlined cores. I successfully
> > tested the working of this with subcore functionality.
> > 
> > Test scenario was as follows:
> > 1. Set SMT mode to 1, Set subores-per-core to 1
> > 2. Offline a core, in this case cpu 32 (sending it to winkle)
> > 3. Set subcores-per-core to 4
> > 4. Online the core
> > 5. Start a guest (Topology 1 core 2 threads) on a subcore, in this case
> > on cpu 36
> > 
> > This works without any glitch.
> > 
> > Thanks,
> > Shreyas
> > 
> > On Monday 25 August 2014 11:31 PM, Shreyas B. Prabhu wrote:
> >> Fast sleep is an idle state, where the core and the L1 and L2
> >> caches are brought down to a threshold voltage. This also means that
> >> the communication between L2 and L3 caches have to be fenced. However
> >> the current P8 chips have a bug wherein this fencing between L2 and
> >> L3 caches get delayed by a cpu cycle. This can delay L3 response to
> >> the other cpus if they request for data during this time. Thus they
> >> would fetch the same data from the memory which could lead to data
> >> corruption if L3 cache is not flushed.
> >> Patch 4 adds support to work around this.
> >>
> >> 'Deep Winkle' is a deeper idle state where core and private L2 are powered
> >> off. While it offers higher power savings, it is at the cost of losing
> >> hypervisor register state and higher latency.
> >> Patch 5-9 adds support for winkle and uses it for offline cpus.
> >>
> >> Patch 1 - Moves parameters required discover idle states to a location 
> >> common to both cpuidle driver and powernv core code
> >> Patch 2 - Populates idle state details from device tree
> >> Patch 3 - Enables cpus to run guest after waking up from fastsleep/winkle
> >>
> >>
> >> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >> Cc: Paul Mackerras <paulus@samba.org>
> >> Cc: Michael Ellerman <mpe@ellerman.id.au>
> >> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> >> Cc: Srivatsa S. Bhat <srivatsa@MIT.EDU>
> >> Cc: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
> >> Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> >> Cc: Rob Herring <robh+dt@kernel.org>
> >> Cc: Grant Likely <grant.likely@linaro.org>
> >> Cc: devicetree@vger.kernel.org
> >> Cc: linux-pm@vger.kernel.org
> >> Cc: linuxppc-dev@lists.ozlabs.org
> >>
> >> Preeti U Murthy (2):
> >>   cpuidle/powernv: Populate cpuidle state details by querying the
> >>     device-tree
> >>   powerpc/powernv/cpuidle: Add workaround to enable fastsleep
> >>
> >> Shreyas B. Prabhu (6):
> >>   powerpc/kvm/book3s_hv: Enable CPUs to run guest after waking up from
> >>     fast-sleep
> >>   powerpc/powernv: Add OPAL call to save and restore
> >>   powerpc: Adding macro for accessing Thread Switch Control Register
> >>   powerpc/powernv: Add winkle infrastructure
> >>   powerpc/powernv: Discover and enable winkle
> >>   powerpc/powernv: Enter deepest supported idle state in offline
> >>
> >> Srivatsa S. Bhat (1):
> >>   powerpc/powernv: Enable Offline CPUs to enter deep idle states
> >>
> >>  arch/powerpc/include/asm/machdep.h             |   4 +
> >>  arch/powerpc/include/asm/opal.h                |  10 ++
> >>  arch/powerpc/include/asm/paca.h                |   3 +
> >>  arch/powerpc/include/asm/ppc-opcode.h          |   2 +
> >>  arch/powerpc/include/asm/processor.h           |   6 +-
> >>  arch/powerpc/include/asm/reg.h                 |   1 +
> >>  arch/powerpc/kernel/asm-offsets.c              |   1 +
> >>  arch/powerpc/kernel/exceptions-64s.S           |  37 ++---
> >>  arch/powerpc/kernel/idle.c                     |  30 ++++
> >>  arch/powerpc/kernel/idle_power7.S              |  83 +++++++++-
> >>  arch/powerpc/platforms/powernv/opal-wrappers.S |   2 +
> >>  arch/powerpc/platforms/powernv/powernv.h       |   8 +
> >>  arch/powerpc/platforms/powernv/setup.c         | 217 +++++++++++++++++++++++++
> >>  arch/powerpc/platforms/powernv/smp.c           |  13 +-
> >>  arch/powerpc/platforms/powernv/subcore.c       |  15 ++
> >>  drivers/cpuidle/cpuidle-powernv.c              |  40 ++++-
> >>  16 files changed, 439 insertions(+), 33 deletions(-)
> >>
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
