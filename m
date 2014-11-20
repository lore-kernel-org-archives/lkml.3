Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbaKTQsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:48:53 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:56745 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358AbaKTQsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:48:52 -0500
Date: Thu, 20 Nov 2014 16:48:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Lucas Stach <l.stach@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC PATCH] arm: imx: Workaround i.MX6 PMU interrupts muxed to
 one SPI
Message-ID: <20141120164835.GQ4042@n2100.arm.linux.org.uk>
References: <1416483757-24165-1-git-send-email-daniel.thompson@linaro.org>
 <1416484332.2769.1.camel@pengutronix.de>
 <546DF9AB.3080300@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546DF9AB.3080300@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 02:24:43PM +0000, Daniel Thompson wrote:
> On 20/11/14 11:52, Lucas Stach wrote:
> > I've sent almost the same patch a while ago. At this time it was shot
> > down due to fears of the measurements being too flaky to be useful with
> > all that IRQ dance. While I don't think this is true (I did some
> > measurements on a SOLO and a QUAD variants of the i.MX6 with the same
> > workload, that were only minimally apart), I believe the IRQ affinity
> > dance isn't the best way to handle this.
> 
> Cumulative statistics and time based sampling profilers should be fine
> either way since a delay before the interrupt the asserted on the
> affected core should have a low impact here.

One thing you're missing is that the interrupt latency for this can be
horrific.

Firstly, remember that Linux processes one interrupt (per core) at a time.
What this means is that if we have two cores running interrupts (eg, CPU 2
and CPU 3), and we raise a PMU interrupt on CPU 1 which is supposed to be
for CPU 0, then we'll process the interrupt on CPU 1, and forward it to
CPU 2.  CPU 2 will then have it pending, but has to wait for the interrupt
handler to complete before it can service it, where upon it forwards it to
CPU 3.  CPU 3 then goes through the same before forwarding it to CPU 0.

I also wonder how this works when you use perf record -a (from all CPUs.)
If the sampling rate is high enough, will the interrupt be forwarded to
the other CPUs?  Has perf record -a been tested?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
