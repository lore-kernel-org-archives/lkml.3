Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3HLQsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:48:01 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:10035
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755433Ab3HLQsA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:48:00 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dIc89bh1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h906i1155h192ch)
Date: Mon, 12 Aug 2013 09:32:49 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>, <srinivas.kandagatla@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <a48f159a-e88c-42fa-b76b-662302d3a585@AM1EHSMHS003.ehs.local>
 <51FA9AE8.1060004@linaro.org>
 <1c83c081-60c6-49e3-a85c-f64dd5be0e60@CH1EHSMHS030.ehs.local>
 <51FA9F54.3060704@linaro.org>
 <c44e700d-64da-487b-a975-1263d7505371@CH1EHSMHS043.ehs.local>
 <5204C54A.9020105@st.com>
 <5204FA5D.3060908@linaro.org>
 <20130809172757.GD14845@codeaurora.org>
 <c1e112a3-cfed-4e53-951e-b1a9208d7dc8@TX2EHSMHS038.ehs.local>
 <52090B43.9090000@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <52090B43.9090000@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <d36fc2db-1189-4c6a-9bc4-0ac2e29eaa1b@AM1EHSMHS009.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 09:20:19AM -0700, Stephen Boyd wrote:
> On 08/12/13 09:03, Sören Brinkmann wrote:
> > On Fri, Aug 09, 2013 at 10:27:57AM -0700, Stephen Boyd wrote:
> >> On 08/09, Daniel Lezcano wrote:
> >>> yes, but at least the broadcast mechanism should send an IPI to cpu0 to
> >>> wake it up, no ? As Stephen stated this kind of configuration should has
> >>> never been tested before so the tick broadcast code is not handling this
> >>> case properly IMHO.
> >>>
> >> If you have a per-cpu tick device that isn't suffering from
> >> FEAT_C3_STOP why wouldn't you use that for the tick versus a
> >> per-cpu tick device that has FEAT_C3_STOP? It sounds like there
> >> is a bug in the preference logic or you should boost the rating
> >> of the arm global timer above the twd. Does this patch help? It
> >> should make the arm global timer the tick device and whatever the
> >> cadence timer you have into the broadcast device.
> > I finally got to test your patch. Unfortunately, it makes the system
> > hang even earlier:
> 
> Sorry it had a bug depending on the registration order. Can you try this
> one (tabs are probably spaces, sorry)? I will go read through this
> thread to see if we already covered the registration order.

That did it! Booted straight into the system. The broadcast device is
the TTC instead of GT, now.

	Tick Device: mode:     1
	Broadcast device
	Clock Event Device: ttc_clockevent
	 max_delta_ns:   1207932479
	 min_delta_ns:   18432
	 mult:           233015
	 shift:          32
	 mode:           1
	 next_event:     9223372036854775807 nsecs
	 set_next_event: ttc_set_next_event
	 set_mode:       ttc_set_mode
	 event_handler:  tick_handle_oneshot_broadcast
	 retries:        0
	
	tick_broadcast_mask: 00000000
	tick_broadcast_oneshot_mask: 00000000
	
	Tick Device: mode:     1
	Per CPU device: 0
	Clock Event Device: arm_global_timer
	 max_delta_ns:   12884902005
	 min_delta_ns:   1000
	 mult:           715827876
	 shift:          31
	 mode:           3
	 next_event:     24216749370 nsecs
	 set_next_event: gt_clockevent_set_next_event
	 set_mode:       gt_clockevent_set_mode
	 event_handler:  hrtimer_interrupt
	 retries:        0
	
	Tick Device: mode:     1
	Per CPU device: 1
	Clock Event Device: arm_global_timer
	 max_delta_ns:   12884902005
	 min_delta_ns:   1000
	 mult:           715827876
	 shift:          31
	 mode:           3
	 next_event:     24220000000 nsecs
	 set_next_event: gt_clockevent_set_next_event
	 set_mode:       gt_clockevent_set_mode
	 event_handler:  hrtimer_interrupt
	 retries:        0


	# cat /proc/interrupts 
	           CPU0       CPU1       
	 27:       1668       1640       GIC  27  gt
	 29:          0          0       GIC  29  twd
	 43:          0          0       GIC  43  ttc_clockevent
	 82:        536          0       GIC  82  xuartps
	IPI0:          0          0  CPU wakeup interrupts
	IPI1:          0          0  Timer broadcast interrupts
	IPI2:       1264       1322  Rescheduling interrupts
	IPI3:          0          0  Function call interrupts
	IPI4:         24         70  Single function call interrupts
	IPI5:          0          0  CPU stop interrupts
	Err:          0


	Thanks,
	Sören


