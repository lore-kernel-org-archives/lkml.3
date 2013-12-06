Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3LFWrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:47:49 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:41867
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753418Ab3LFWrr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 17:47:47 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIc89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2149h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h906i1155h)
Date: Fri, 6 Dec 2013 14:47:32 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 4/9] clocksource/cadence_ttc: Use enable/disable_irq
References: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com>
 <1385514296-26702-5-git-send-email-soren.brinkmann@xilinx.com>
 <52972F3A.9090103@linaro.org>
 <alpine.DEB.2.02.1311281507280.30673@ionos.tec.linutronix.de>
 <b2ed3cbc-c9df-4235-8137-93514c05bffa@DB8EHSMHS031.ehs.local>
 <alpine.DEB.2.02.1311281939000.30673@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311281939000.30673@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <f6d25456-8e30-4792-b184-21eb02dfaa1c@AM1EHSMHS001.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

sorry for the delay, but I couldn't find time any earlier.

On Thu, Nov 28, 2013 at 08:07:10PM +0100, Thomas Gleixner wrote:
> On Thu, 28 Nov 2013, Sören Brinkmann wrote:
> > On Thu, Nov 28, 2013 at 03:18:50PM +0100, Thomas Gleixner wrote:
> > > Now the problem with this device is that it is not a per cpu
> > > device. It's a global device, so this update can conflict with a
> > > parallel access on the other CPU. Now the disable_irq() only prevents
> > > that the other CPU can handle a device interrupt from that timer. But
> > > it does not prevent any parallel access from e.g. the idle code path
> > > which will try to reprogram it.
> >
> > Does that mean interrupts need to be disabled globally? Also, does the
> 
> Globally disabling interrupts is not going to work, except you want to
> use stomp_machine(). But that would be overkill.
> 
> > cpuidle path depend on interrupts or can it interfere no matter what?
> 
> It can interfere no matter what. The broadcast is modified for the cpu
> which loses its per cpu timer due to the idle state via
> 
>       clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, ...);
>  
> > > Soren, is that timer used as the broadcast device ?
> >
> > Yes, this is the only broadcast capable timer on Zynq, AFAIK. Other than
> > the TTC we only have the arm_global_timer and smp_twd timers, which both
> > are per_cpu devices and thus not broadcast capable.
> 
> There is a solution to this. We can identify the broadcast device in
> the core and serialize all callers including interrupts on a different
> cpu against the update. So no need for the disable/enable_irq() dance.

IIUC, and please correct me if I'm wrong, with the patch I'd simply call
'clockevents_update_freq() without having to disable IRQs. But I'm not
sure whether periodic mode is covered. I found, that I had to reprogram
the timer interval in my clock notifier callback when the timer
frequency changes. I think 'clockevents_update_freq()' only handles
oneshot mode. For that reason I call 'ttc_set_interval()' in the clock
notifier in case the timer is in periodic mode. For that call we'd still
have possible races. I guess the best solution would be to move that
functionality into 'clockevents_update_freq()'?

	Sören


