Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbaHVI1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:27:42 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:57233 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752413AbaHVI1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:27:39 -0400
Date: Fri, 22 Aug 2014 09:27:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>,
        Fabio Estevam <festevam@gmail.com>
Cc: Fredrik Noring <fredrik.noring@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
Message-ID: <20140822082728.GN30401@n2100.arm.linux.org.uk>
References: <C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int> <20140806095012.GN30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043575172@ALVA-EXMB04.alv.autoliv.int> <20140806125550.GO30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int> <20140807121248.GY30282@n2100.arm.linux.org.uk> <20140808180900.GG30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043576356@ALVA-EXMB04.alv.autoliv.int> <CAOMZO5B8GR+ABBoJ=dJcFqw3Wagfaip7HM+C1FTz+aE4CmqiPw@mail.gmail.com> <C4A61A5CA4AD2246942F4BA6F20ACB80435776D3@ALVA-EXMB04.alv.autoliv.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4A61A5CA4AD2246942F4BA6F20ACB80435776D3@ALVA-EXMB04.alv.autoliv.int>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 02:43:56PM +0000, Mattis Lorentzon wrote:
> Fabio and Russell,
> 
> > A working theory is that the switch (3Com Switch 4400) triggers the
> > degeneration of the network stack from which Linux does not seem to
> > recover, even if we later bypass the switch and directly connect the board to
> > the server machine.
> 
> After a few more tests we have finally been able to trigger the exact
> same stalls on the Sabrelite board with a direct network connection
> (i.e. without the switch).

That's a setup which I can't reproduce, as all my MX6 hardware runs
root-NFS, so using a direct connection to a machine to test will
result in the MX6 losing its root filesystem.

That said, on SolidRun hardware, there is some investigation going on
at the moment concerning poor UDP performance - this is an on-going
problem that has been present for a long time.

What we find is that TCP performance achieves around the 600mbps mark,
but UDP performance can be extremely poor with high packet loss.
Adding a udelay(210) into the fec_enet_rx() can perversely (on
multi-core SoCs) increase UDP performance to around 500mbps at the
expense of a reduction in TCP performance.

This "solution" was tripped over while trying to debug this problem,
and it was found that adding printk()s to the driver increased UDP
performance - so subsituting udelay() for printk() was then tried.

I tried to run perf on the kernel yesterday to find out what's going
on, but for some reason, perf gave me impossible call traces, so I
gave up with that idea.  For example, perf told me that there was a
high hit rate in memcpy() being called from net_rx_action(), but
net_rx_action() doesn't call memcpy(), nor do any of the called
functions as a tail-call.

That said, I don't think perf could tell us what's going on - what
we need is a trace of the CPU's execution while iperf is running,
*without* affecting the CPU itself.  This is something I can't do
with the hardware I have.

My suspicion (unproven) is that a batch of packets get processed in
the softirq handler called during the FEC interrupt exit path.  Then,
because there's more work to be done, ksoftirqd is scheduled, but it
takes time for ksoftirqd to start running - during which time we drop
a lot of packets.  ksoftirqd processes some packets, but then finds
that it can't complete the NAPI "work budget", and so stops running,
resulting in the packet processing being triggered by the next FEC
interrupt, and the cycle repeats.

TCP notices this, and adjusts its sending rate to match, whereas UDP
just carries on regardless, resulting in lots of packets dropped each
time we switch from the tail of hardirq processing to ksoftirqd.

With the udelay() in place, processing takes enough time that it gets
bounced onto ksoftirqd, where it stays.

I'm adding this to this thread in case it has any bearing on the
problem(s) you're seeing - yes, it seems like a different problem, but
could it be related...

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
