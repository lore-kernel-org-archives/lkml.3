Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3FGQOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:14:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56382 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab3FGQOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:14:05 -0400
Date: Fri, 7 Jun 2013 17:13:59 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: James King <james.king@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "nico@linaro.org" <nico@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm/dt: Don't add disabled CPUs to system topology
Message-ID: <20130607161359.GE3111@e102568-lin.cambridge.arm.com>
References: <1370538685-22386-1-git-send-email-james.king@linaro.org>
 <20130607102326.GA3111@e102568-lin.cambridge.arm.com>
 <51B1EC24.3010909@gmail.com>
MIME-Version: 1.0
In-Reply-To: <51B1EC24.3010909@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 07 Jun 2013 16:14:00.0862 (UTC) FILETIME=[057E9BE0:01CE639A]
X-MC-Unique: 113060717140200401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 03:20:20PM +0100, Rob Herring wrote:
> On 06/07/2013 05:23 AM, Lorenzo Pieralisi wrote:
> > Hi James,
> > 
> > On Thu, Jun 06, 2013 at 06:11:25PM +0100, James King wrote:
> >> If CPUs are marked as disabled in the devicetree, make sure they do
> >> not exist in the system CPU information and CPU topology information.
> >> In this case these CPUs will not be able to be added to the system later
> >> using hot-plug. This allows a single chip with many CPUs to be easily
> >> used in a variety of hardware devices where they may have different
> >> actual processing requirements (eg for thermal/cost reasons).
> >>
> >> - Change devicetree.c to ignore any cpu nodes marked as disabled,
> >>   this effectively limits the number of active cpu cores so no need
> >>   for the max_cpus=x in the chosen node.
> >> - Change topology.c to ignore any cpu nodes marked as disabled, this
> >>   is where the scheduler would learn about big/LITTLE cores so this
> >>   effectively keeps the scheduler in sync.
> >>
> > 
> > I have two questions:
> > 
> > 1) Since with this approach the DT should change anyway if on different
> >    hardware devices based on the same chip you want to allow booting a
> >    different number of CPUs, why do not we remove the cpu nodes instead of
> >    disabling them ? Put it another way: cpu nodes define a cpu as
> >    possible (currently), we can simply remove the node if we do not want
> >    that cpu to be seen by the kernel.
> > 2) If we go for the "status" property, why do not we use it to set present
> >    mask ? That way the cpu is possible but not present, you cannot
> >    hotplug it in. It is a bit of a stretch, granted, the cpu _is_ present,
> >    we just want to disable it, do not know how this is handled in x86
> >    and other archs though.
> 
> The meaning of disabled for cpus in ePAPR is that the cpu is offline
> (i.e. in a spinloop or wfi), not that the cpu is unavailable. This is a
> bit of a departure and inconsistency from how status for devices are
> used. That would imply that we should be setting status to disabled for
> all secondary cores and that possibly the status value should get
> updated to reflect the state of the cpu.

Yes, that's what I understood from the ePAPR as well. According to
the ePAPR, as you say, a cpu with its status property == "disabled" is a
possible CPU, since it can be enabled (through a specific enable-method).

I am not sure "status" can be reused for the purpose this patch was developed
for without changing the bindings in the ePAPR (ie if DT parsing skips
cpu nodes with status == "disabled", this is a significant departure
from what ePAPR defines, and it would force us to define an enable-method
to enable/online those CPUs which is not what this patch was developed for).

How was PowerPC tackling the problem James set about solving ?

Lorenzo

