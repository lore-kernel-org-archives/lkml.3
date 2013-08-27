Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab3H0XUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:20:16 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:25387
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520Ab3H0XUO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:20:14 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z551bizbb2dI98dIc89bh154dI1102I1432I1453Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h906i1155h192ch)
Date: Tue, 27 Aug 2013 16:20:02 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        <linux-tegra@vger.kernel.org>, <kernel@stlinux.com>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v2 01/16] ARM: call clk_of_init from time_init
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1377638890-371-2-git-send-email-sebastian.hesselbarth@gmail.com>
 <3837b119-baad-4e68-8805-2bc52c0135f9@DB9EHSMHS031.ehs.local>
 <521D2F1F.1070103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <521D2F1F.1070103@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <2caa20c0-cfa8-497d-8aef-fb99f2a0d821@DB9EHSMHS015.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 12:58:39AM +0200, Sebastian Hesselbarth wrote:
> On 08/28/13 00:19, Sören Brinkmann wrote:
> >On Tue, Aug 27, 2013 at 11:27:55PM +0200, Sebastian Hesselbarth wrote:
> >>Most DT ARM machs require common clock providers initialized before timers.
> >>Currently, arch/arm machs use .init_time to call clk_of_init right before
> >>clocksource_of_init. This prevents to remove that hook and use the default
> >>hook instead. clk_of_init is safe to call for non-DT platforms, so add
> >>the call to ARM arch time_init by default. While at it, also reorder includes
> >>alphabetically.
> >>
> >>Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> >>---
> >>Changelog:
> >>v1->v2:
> >>- reorder includes alphabetically
> >>
> >>Cc: Russell King <linux@arm.linux.org.uk>
> >>Cc: Arnd Bergmann <arnd@arndb.de>
> >>Cc: linux-tegra@vger.kernel.org
> >>Cc: kernel@stlinux.com
> >>Cc: linux-samsung-soc@vger.kernel.org
> >>Cc: linux-arm-kernel@lists.infradead.org
> >>Cc: linux-kernel@vger.kernel.org
> >>---
> >>  arch/arm/kernel/time.c |   24 ++++++++++++++----------
> >>  1 files changed, 14 insertions(+), 10 deletions(-)
> >>
> >>diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
> >>index 98aee32..dd1028e 100644
> >>--- a/arch/arm/kernel/time.c
> >>+++ b/arch/arm/kernel/time.c
> >>@@ -11,25 +11,26 @@
> >[ ... ]
> >>  void __init time_init(void)
> >>  {
> >>+	/* initalize common clocks before timers */
> >>+	of_clk_init(NULL);
> >>+
> >>  	if (machine_desc->init_time)
> >>  		machine_desc->init_time();
> >>  	else
> >
> >This forces zynq to move some initialization our clock code relies on to
> >init_irq(). Also, the current code already takes an approach of
> >doing either common init or machine specific init.
> 
> Soeren,
> 
> you know that patch 16/16 takes care of zynq's clock init?
> 
> It's your own patch you provided from the last RFC. Looking at it, it
> moves  zynq_sclr_init() to .init_irq and removes the call to
> of_clk_init() from zynq_clock_init() which is called by
> zynq_sclr_init().
> 
> Isn't that solving the above issues for mach-zynq?

Yes, I know. This alternative approach came to me after I sent my patch
and took a closer look at init_irq(). As you said, we move our problem
just to an earlier boot stage. Which wouldn't be true if a strict
if-else would allow us to explicitly call everything in the right order
- which init_irq by the way does.
I mentioned it in an email in the original thread yesterday. But since
there is a v2 now, I just thought to bring it up here now.

> 
> >I think it might be better to move the call to of_clk_init() down into
> >the else branch of the if-else.
> 
> Possibly, yes. But we could also unconditionally call of_clk_init() at
> the beginning of time_init() and call clocksource_of_init() at the end.
> That will make .init_time() to some fixup hook between
> initialization of clocks and timers.

Right, the question is what is the common case? What do SOCs use the
custom init_time() hook for?

If SOCs use it for things additionally to clock init where 
execution order doesn't matter, your patch works perfectly well and is
the preferred solution.

If they use it just to call of_clk_init() and of_clocksource_init(),
those hooks can go away and it would work in the else branch or outside,
equally well.

If they use it like Zynq, to do some required SOC specific init which must
be done before clock init, it would make more sense to have it in the
else branch. That way the SOC intentionally replaces init_time()
with its own implementation and has to take care of calling everything in the
right order.

Another approach might be to move the custom init_time() hook before the
call to of_clk_init().

As I said, it depends on how this hook is used.

	Sören


