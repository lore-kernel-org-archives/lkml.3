Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbaFQDuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 23:50:25 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:52070
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754848AbaFQDuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 23:50:23 -0400
Date: Mon, 16 Jun 2014 20:50:17 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Jongsung Kim <neidhard.kim@lge.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hayun Hwang <hwang.hayun@lge.com>,
        Youngkyu Choi <youngkyu7.choi@lge.com>
Subject: Re: [PATCH] net/cadence/macb: clear interrupts simply and correctly
References: <1402563054-8546-1-git-send-email-neidhard.kim@lge.com>
 <9f5be687-d127-49a4-90ea-c1033505452d@BN1BFFO11FD019.protection.gbl>
 <539E79F1.1090006@lge.com>
 <ea57b37f-1f1c-40a0-84a6-46b0b78ec6b4@BY2FFO11FD034.protection.gbl>
 <539FAA34.9030002@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <539FAA34.9030002@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <0f1d404c-89a7-4bbd-99ff-973d4f26d2c6@BY2FFO11FD005.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(479174003)(164054003)(377454003)(377424004)(199002)(189002)(51704005)(24454002)(21056001)(46102001)(81542001)(4396001)(44976005)(6806004)(80022001)(83322001)(74662001)(74502001)(81342001)(70736001)(23676002)(102836001)(33646001)(92726001)(31696002)(86362001)(87936001)(85852003)(83072002)(99396002)(54356999)(76176999)(50986999)(85306003)(77096002)(104016002)(95666004)(74316001)(93886003)(1496007)(53416004)(50466002)(77982001)(76482001)(47776003)(20776003)(85202002)(79102001)(85182001)(64706001)(83506001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB036;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0245702D7B
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 11:38AM +0900, Jongsung Kim wrote:
> On 06/16/2014 11:56 PM, Sören Brinkmann wrote:
> > On Mon, 2014-06-16 at 02:00PM +0900, Jongsung Kim wrote:
> >> On 06/13/2014 12:44 AM, Sören Brinkmann wrote:
> >>> This is now clearing all IRQ flags which is probably not what we want
> >>> here. This is handling RX only. We still want the non-RX interrupts to go to
> >>> the actual interrupt service routing.
> >>
> >> The ISR(Interrupt Status Register) is read only in the interrupt service
> >> routine, macb_interrupt. But is partially cleared here and there. Further
> >> handler-functions decide jobs to be done by reading/checking other status
> >> registers. (e.g., TSR, RSR) So, clearing the ISR after reading looks not
> >> a bad idea.
> >
> > But you are clearing _all_ interrupt flags in the RX NAPI handler.
> > Doesn't that mean we might miss certain events?
> 
> Please inspect my patch again. What I did in the macb_poll is removing
> statements clearing the Rx-complete interrupt, not clearing all the
> interrupts.

Oh, you're right. I misread the patch, sorry. The call to macb_read_isr was
already a different hunk.
Why is clearing those bits removed? It's probably not a big hit, but it might
result in a pointless interrupt which could be avoided. But it should
probably clear all RX interrupts - MACB_RX_INT_FLAGS - instead of just RCOMP.
For clear-on-read implementations it shouldn't make a difference.

And in the if-condition in that new helper, I'd add '&& status' to
avoid writing back zeros.

	Thanks,
	Sören
