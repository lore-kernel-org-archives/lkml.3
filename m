Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab3HZPUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:20:49 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:8801 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664Ab3HZPUs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:20:48 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dIc89bh148cI1432I1418Idb82hzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h906i1155h192ch)
Date: Mon, 26 Aug 2013 08:20:41 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <michal.simek@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 17/17] clk: zynq: remove call to of_clk_init
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376964271-22715-18-git-send-email-sebastian.hesselbarth@gmail.com>
 <d17acba9-85f9-40cd-a176-2005e3e924f8@CO1EHSMHS002.ehs.local>
 <c4d10bdf-6506-4edc-92cc-2acc67b86602@VA3EHSMHS032.ehs.local>
 <52172BAA.7020009@gmail.com>
 <bfd173dc-3be5-421c-b7f7-af181bfb7032@DB8EHSMHS026.ehs.local>
 <52179F63.4060008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <52179F63.4060008@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <d010f3ec-51d6-4d79-a754-095b89b77ae6@VA3EHSMHS029.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 07:44:03PM +0200, Sebastian Hesselbarth wrote:
> On 08/23/13 19:19, Sören Brinkmann wrote:
> >On Fri, Aug 23, 2013 at 11:30:18AM +0200, Sebastian Hesselbarth wrote:
> >>On 08/23/13 02:59, Sören Brinkmann wrote:
> >>>On Thu, Aug 22, 2013 at 05:26:47PM -0700, Sören Brinkmann wrote:
> >>>>On Tue, Aug 20, 2013 at 04:04:31AM +0200, Sebastian Hesselbarth wrote:
> >>>>>With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> >>>>>remove it from corresponding drivers/clk code.
> >>>>
> >>>>I think that would break Zynq.
> >>>>If I see this correctly you call of_clk_init() from common code,
> >>>>_before_ the SOC specific time init function is called.
> >>>>The problem is, that we have code setting up a global pointer which is
> >>>>required by zynq_clk_setup() which is triggered when of_clk_init() is
> >>>>called.
> >[ ... ]
> >>thanks for looking into this. I also had a look at the files in
> >>question. Based on Steffen's proposal, I prepared a diff that should do
> >>the trick. It moves zynq_slcr_init() to early_init, instead of reusing
> >>another hook that has magic cow powers (it calls irqchip_init that zynq
> >>also wants sooner or later).
> >>
> >>Also, it removes zynq_clock_init() and let zynq_clk_setup() map the
> >>register itself by finding the node and use of_iomap(). I realized that
> >>clock registers are quite separated within slcr, so you can consider
> >>to have your own node for the clk-provider. As Steffen is proposing
> >>this but mentioned incompatible DT changes, I chose that intermediate
> >>step above.
> >>
> >>It would be great, if you test the diff and prepare a patch out of
> >>it, that I pick-up in the patch set. That way, we also have your
> >>Signed-off on it.
> >
> >I looked into this. Looks like init_early() happens to early. I suspect
> >slab is missing to make zynq_slcr_init() work. So, I moved it into
> >init_irq(). Is there any init_call() type which is called at the correct
> >time?
> 
> Sören,
> 
> I mistakenly assumed init_early is after mm, so of course my proposal
> does not work as it should. I am fine with moving it to init_irq() until
> you find the best solution (or until we have the same "mess" with
> default init_irq hook).

Looking at these two hooks. If the SOC provides init_irq(), the common
code does nothing, but calling it. Ergo, the SOC is now responsible for
otherwise commonly called code like of_irq_init().

It's probably an idea to design the common init_time() function the same
way. That way SOCs that don't need any custom init at that stage get
everything for free. And SOCs like Zynq have to still call of_clk_init()
manually, but can ensure that dependencies like our SLCR init are
satisfied before calling it.

Just an idea, not sure if it makes sense since I didn't look beyond Zynq
too much on this.

	Sören


