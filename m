Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbaDOMuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:50:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56346 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754775AbaDOMuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:50:11 -0400
Date: Tue, 15 Apr 2014 13:49:53 +0100
From: Will Deacon <will.deacon@arm.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH v2] ARM: perf: save/restore pmu registers in pm notifier
Message-ID: <20140415124953.GL17408@arm.com>
References: <1397439742-28337-1-git-send-email-zhangwm@marvell.com>
 <20140415084749.GG17408@arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE55075F1873@SC-VEXCH4.marvell.com>
 <20140415124100.GK17408@arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE55075F1875@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE55075F1875@SC-VEXCH4.marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 01:46:08PM +0100, Neil Zhang wrote:
> > On Tue, Apr 15, 2014 at 01:37:17PM +0100, Neil Zhang wrote:
> > > > On Mon, Apr 14, 2014 at 02:42:22AM +0100, Neil Zhang wrote:
> > > > > From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> > > > >
> > > > > This adds core support for saving and restoring CPU PMU registers
> > > > > for suspend/resume support i.e. deeper C-states in cpuidle terms.
> > > > > This patch adds support only to ARMv7 PMU registers save/restore.
> > > > > It needs to be extended to xscale and ARMv6 if needed.
> > > > >
> > > > > [Neil] We found that DS-5 not work on our CA7 based SoCs.
> > > > > After debuging, found PMU registers were lost because of core power
> > down.
> > > > > Then i found Sudeep had a patch to fix it about two years ago but
> > > > > not in the mainline, just port it.
> > > >
> > > > What I don't like about this patch is that we're introducing
> > > > significant overhead for SoCs that don't require save/restore of the
> > > > PMU state. I'd much rather see core power down disabled whilst the
> > > > PMU is in use but, if that's not possible, then I think we need to:
> > > >
> > > >  (1) Make this conditional for cores that really need it
> > > >
> > > >  (2) Only save/restore if the PMU is in use (even better, just save/restore
> > > >      the live registers, but that's probably not worth the effort
> > > >      initially).
> > > >
> > >
> > > The patch has check the ARMV7_PMNC_E bit when save / restore, so
> > > suppose only the core's that use PMU will do the save / restore work.
> > 
> > Seems pretty fragile to base our save/restore decision on the value of one of
> > the registers, though. What happens if the control register is zeroed by the
> > core power down?
> > 
> It will check the saved control value when restore, so is should be OK
> while control register is zeroed. 

Ah yes, I mixed up and save and restore functions. It's still horrible that
we have to read the control register unconditionally during the save though
-- it might be nicer if we simply register/unregister the notifier during
perf runs (in the same way that we request/free the PMU IRQs).

Will
