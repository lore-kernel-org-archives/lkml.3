Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab3HLQyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:54:08 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:12689
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756865Ab3HLQyG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:54:06 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI9371Ic89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h906i1155h192ch)
Date: Mon, 12 Aug 2013 09:53:49 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, <srinivas.kandagatla@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <1c83c081-60c6-49e3-a85c-f64dd5be0e60@CH1EHSMHS030.ehs.local>
 <51FA9F54.3060704@linaro.org>
 <c44e700d-64da-487b-a975-1263d7505371@CH1EHSMHS043.ehs.local>
 <5204C54A.9020105@st.com>
 <5204FA5D.3060908@linaro.org>
 <20130809172757.GD14845@codeaurora.org>
 <c1e112a3-cfed-4e53-951e-b1a9208d7dc8@TX2EHSMHS038.ehs.local>
 <52090B43.9090000@codeaurora.org>
 <d36fc2db-1189-4c6a-9bc4-0ac2e29eaa1b@AM1EHSMHS009.ehs.local>
 <5209120D.1010701@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5209120D.1010701@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <9b07d8a3-b650-4147-b952-9bcfc1172c51@VA3EHSMHS025.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 06:49:17PM +0200, Daniel Lezcano wrote:
> On 08/12/2013 06:32 PM, Sören Brinkmann wrote:
> > On Mon, Aug 12, 2013 at 09:20:19AM -0700, Stephen Boyd wrote:
> >> On 08/12/13 09:03, Sören Brinkmann wrote:
> >>> On Fri, Aug 09, 2013 at 10:27:57AM -0700, Stephen Boyd wrote:
> >>>> On 08/09, Daniel Lezcano wrote:
> >>>>> yes, but at least the broadcast mechanism should send an IPI to cpu0 to
> >>>>> wake it up, no ? As Stephen stated this kind of configuration should has
> >>>>> never been tested before so the tick broadcast code is not handling this
> >>>>> case properly IMHO.
> >>>>>
> >>>> If you have a per-cpu tick device that isn't suffering from
> >>>> FEAT_C3_STOP why wouldn't you use that for the tick versus a
> >>>> per-cpu tick device that has FEAT_C3_STOP? It sounds like there
> >>>> is a bug in the preference logic or you should boost the rating
> >>>> of the arm global timer above the twd. Does this patch help? It
> >>>> should make the arm global timer the tick device and whatever the
> >>>> cadence timer you have into the broadcast device.
> >>> I finally got to test your patch. Unfortunately, it makes the system
> >>> hang even earlier:
> >>
> >> Sorry it had a bug depending on the registration order. Can you try this
> >> one (tabs are probably spaces, sorry)? I will go read through this
> >> thread to see if we already covered the registration order.
> > 
> > That did it! Booted straight into the system. 
> 
> Good news :)
> 
> > The broadcast device is
> > the TTC instead of GT, now.
> > 
> > 	Tick Device: mode:     1
> > 	Broadcast device
> > 	Clock Event Device: ttc_clockevent
> > 	 max_delta_ns:   1207932479
> > 	 min_delta_ns:   18432
> > 	 mult:           233015
> > 	 shift:          32
> > 	 mode:           1
> > 	 next_event:     9223372036854775807 nsecs
> > 	 set_next_event: ttc_set_next_event
> > 	 set_mode:       ttc_set_mode
> > 	 event_handler:  tick_handle_oneshot_broadcast
> > 	 retries:        0
> > 	
> > 	tick_broadcast_mask: 00000000
> > 	tick_broadcast_oneshot_mask: 00000000
> 
> At the first glance, the timer broadcast usage is not set, right ? Can
> you try with the cpuidle flag even if it is not needed ?

It's actually present. I have a clean 3.11-rc3 and the only changes are
my patch to enable the GT and Stephen's fix.
The cpuidle stats show both idle states being used.

	Sören


