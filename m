Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab3LKUJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 15:09:20 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:42843 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751030Ab3LKUJM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 15:09:12 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(z579ehzbb2dI98dI9371Ic89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h906i1155h)
Date: Wed, 11 Dec 2013 12:09:04 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2] time: Serialize calls to 'clockevents_update_freq'
 in the timing core
References: <alpine.DEB.2.02.1312071151340.30673@ionos.tec.linutronix.de>
 <1386635686-15686-1-git-send-email-soren.brinkmann@xilinx.com>
 <1386635686-15686-2-git-send-email-soren.brinkmann@xilinx.com>
 <52A87799.8010300@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <52A87799.8010300@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <ba4dce4a-1332-4fd8-80de-41347bb5b7b2@TX2EHSMHS005.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Wed, Dec 11, 2013 at 03:32:57PM +0100, Daniel Lezcano wrote:
> On 12/10/2013 01:34 AM, Soren Brinkmann wrote:
> >From: Thomas Gleixner <tglx@linutronix.de>
> >
> >We can identify the broadcast device in the core and serialize all
> >callers including interrupts on a different CPU against the update.
> >Also, disabling interrupts is moved into the core allowing callers to
> >leave interrutps enabled when calling clockevents_update_freq().
> >
> >Cc: Thomas Gleixner <tglx@linutronix.de>
> >Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >---
> >  kernel/time/clockevents.c    | 29 ++++++++++++++++++++++-------
> >  kernel/time/tick-broadcast.c | 25 +++++++++++++++++++------
> >  kernel/time/tick-internal.h  |  4 ++++
> >  3 files changed, 45 insertions(+), 13 deletions(-)
> >
> >diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> >index 086ad6043bcb..641d91003a45 100644
> >--- a/kernel/time/clockevents.c
> >+++ b/kernel/time/clockevents.c
> >@@ -439,6 +439,16 @@ void clockevents_config_and_register(struct clock_event_device *dev,
> >  }
> >  EXPORT_SYMBOL_GPL(clockevents_config_and_register);
> >
> >+int __clockevents_update_freq(struct clock_event_device *dev, u32 freq)
> >+{
> >+	clockevents_config(dev, freq);
> >+
> >+	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
> >+		return 0;
> >+
> >+	return clockevents_program_event(dev, dev->next_event, false);
> >+}
> >+
> 
> ./arch/arm/kernel/smp_twd.c should be modified to call
> __clockevents_update_freq instead of clockevents_update_freq, no ?

IIUC, the __-version is only for timer core internal usage and not an
exported interface. Doesn't the non-__ version work for the twd?
I don't see issues on my Zynq platform with these patches.

Another side note regarding the twd: Shouldn't we set the
CLOCK_EVT_FEAT_PERCPU flag we introduced recently for that timer?

	Sören


