Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab3KVSGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:06:50 -0500
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:15193
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932137Ab3KVSGp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:06:45 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z579ehzbb2dI98dI9371Ic89bh1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2149h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h906i1155h)
Date: Fri, 22 Nov 2013 10:06:34 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/7] clocksource/cadence_ttc: Adjust interval in clock
 notifier
References: <1383945677-29674-1-git-send-email-soren.brinkmann@xilinx.com>
 <1383945677-29674-5-git-send-email-soren.brinkmann@xilinx.com>
 <52825779.2050106@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <52825779.2050106@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <e1bb716e-96dc-4da0-ba92-3a5492b5ba59@CO1EHSMHS007.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Tue, Nov 12, 2013 at 05:29:45PM +0100, Daniel Lezcano wrote:
> On 11/08/2013 10:21 PM, Soren Brinkmann wrote:
> >The clockevent has to be reprogrammed if the timer's input
> >clock frequency changes and the timer is in periodic mode, in order to
> >maintain the correct timer interval.
> >
> >Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >---
> >  drivers/clocksource/cadence_ttc_timer.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> >diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
> >index a92350b55d32..68a336038d8f 100644
> >--- a/drivers/clocksource/cadence_ttc_timer.c
> >+++ b/drivers/clocksource/cadence_ttc_timer.c
> >@@ -338,6 +338,10 @@ static int ttc_rate_change_clockevent_cb(struct notifier_block *nb,
> >  		/* update cached frequency */
> >  		ttc->freq = ndata->new_rate;
> >
> >+		if (ttcce->ce.mode == CLOCK_EVT_MODE_PERIODIC)
> >+			ttc_set_interval(ttc, DIV_ROUND_CLOSEST(ttc->freq,
> >+						PRESCALE * HZ));
> >+
> 
> Couldn't be racy ?
I guess you're right. What would be the proper way to resolve it? If we
look at a little more code things look like this:

	local_irq_save(flags);                                           
	clockevents_update_freq(&ttcce->ce,                              
	                ndata->new_rate / PRESCALE);                     
	local_irq_restore(flags);                                        
	                                                                 
	/* update cached frequency */                                    
	ttc->freq = ndata->new_rate;                                     
	                                                                 
	if (ttcce->ce.mode == CLOCK_EVT_MODE_PERIODIC)                   
	        ttc_set_interval(ttc, DIV_ROUND_CLOSEST(ttc->freq,       
	                                PRESCALE * HZ));

Would it be enough to move the ttc_set_interval() call within the
section where local IRQs are disabled? I have the feeling for this timer
the local_irq_save() may in general not be the right option since the
timer is not CPU local.
Should we probably change this do irq_disable(ttcce->ce.irq)?

	Thanks,
	Sören


