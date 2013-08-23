Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3HWA7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 20:59:48 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:18520
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753760Ab3HWA7r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 20:59:47 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432I1418Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h906i1155h192ch)
Date: Thu, 22 Aug 2013 17:59:36 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <michal.simek@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 17/17] clk: zynq: remove call to of_clk_init
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376964271-22715-18-git-send-email-sebastian.hesselbarth@gmail.com>
 <d17acba9-85f9-40cd-a176-2005e3e924f8@CO1EHSMHS002.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <d17acba9-85f9-40cd-a176-2005e3e924f8@CO1EHSMHS002.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <c4d10bdf-6506-4edc-92cc-2acc67b86602@VA3EHSMHS032.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 05:26:47PM -0700, Sören Brinkmann wrote:
> Hi Sebastian,
> 
> On Tue, Aug 20, 2013 at 04:04:31AM +0200, Sebastian Hesselbarth wrote:
> > With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> > remove it from corresponding drivers/clk code.
> 
> I think that would break Zynq.
> If I see this correctly you call of_clk_init() from common code,
> _before_ the SOC specific time init function is called.
> The problem is, that we have code setting up a global pointer which is
> required by zynq_clk_setup() which is triggered when of_clk_init() is
> called.
> 
> Let me try to illustrate the current call graph:
> 
> time_init()
> 	zynq_timer_init()		// this machines init_time()
> 		zynq_slcr_init()	// setup System Level Control Registers including a global pointer
> 			zynq_clock_init()
> 				of_clk_init()
> 					zynq_clk_setup()   // requires pointer setup in zynq_slcr_init()
> 					...
> 
> IIUC, your series would change this to:
> time_init()
> 	of_clk_init()
> 		zynq_clk_setup()	// SLCR pointer is not setup/NULL
> 		...
> 	zynq_timer_init()
> 		zynq_slcr_init()	// now the pointer becomes valid

I guess we could move zynq_slcr_init() into init_irq(). I'll give that a
shot tomorrow.

	Sören


