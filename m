Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab3LCNmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:42:15 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48419 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485Ab3LCNmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:42:14 -0500
Date: Tue, 3 Dec 2013 13:41:13 +0000
From: Will Deacon <will.deacon@arm.com>
To: Vinayak Kale <vkale@apm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "patches@apm.com" <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Tuan Phan <tphan@apm.com>
Subject: Re: [PATCH V6 2/2] arm64: perf: add support for percpu pmu interrupt
Message-ID: <20131203134113.GI1169@mudshark.cambridge.arm.com>
References: <1385976843-13280-1-git-send-email-vkale@apm.com>
 <1385976843-13280-3-git-send-email-vkale@apm.com>
 <20131203113052.GE1169@mudshark.cambridge.arm.com>
 <CAPrCYke4P2V47iG=1b_f3YHiTqC2hOG5yiKTUWuWG+pX8JauMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPrCYke4P2V47iG=1b_f3YHiTqC2hOG5yiKTUWuWG+pX8JauMQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 11:49:11AM +0000, Vinayak Kale wrote:
> On Tue, Dec 3, 2013 at 5:00 PM, Will Deacon <will.deacon@arm.com> wrote:
> > On Mon, Dec 02, 2013 at 09:34:03AM +0000, Vinayak Kale wrote:
> >> Add support for irq registration when pmu interrupt is percpu.
> >>
> >> Signed-off-by: Vinayak Kale <vkale@apm.com>
> >> Signed-off-by: Tuan Phan <tphan@apm.com>
> >> ---
> >>  arch/arm64/kernel/perf_event.c |  116 +++++++++++++++++++++++++++++-----------
> >>  1 file changed, 86 insertions(+), 30 deletions(-)
> >>
> >> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> >> index cea1594..d2d562f 100644
> >> --- a/arch/arm64/kernel/perf_event.c
> >> +++ b/arch/arm64/kernel/perf_event.c
> >> @@ -22,6 +22,7 @@
> >>
> >>  #include <linux/bitmap.h>
> >>  #include <linux/interrupt.h>
> >> +#include <linux/irq.h>
> >>  #include <linux/kernel.h>
> >>  #include <linux/export.h>
> >>  #include <linux/perf_event.h>
> >> @@ -363,26 +364,61 @@ validate_group(struct perf_event *event)
> >>  }
> >>
> >>  static void
> >> +armpmu_disable_percpu_irq(void *data)
> >> +{
> >> +     struct arm_pmu *armpmu = data;
> >> +     struct platform_device *pmu_device = armpmu->plat_device;
> >> +     int irq = platform_get_irq(pmu_device, 0);
> >> +
> >> +     cpumask_test_and_clear_cpu(smp_processor_id(), &armpmu->active_irqs);
> >> +     disable_percpu_irq(irq);
> >> +}
> >> +
> >> +static void
> >>  armpmu_release_hardware(struct arm_pmu *armpmu)
> >>  {
> >> -     int i, irq, irqs;
> >> +     int irq;
> >
> > Why did you not make this unsigned, like I suggested?
> 
> Suggestion was to make 'irqs' variable unsigned and modify the check
> for 'irqs' to if (!irqs).
> This patch incorporates that suggestion.
> 
> We have to keep 'irq' signed only. 'platform_get_irq()' can return error value.

Damn, yes, I see the issue there. Ok, I'll go back and take another look at
your patch...

Will
