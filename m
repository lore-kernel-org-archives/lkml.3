Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbaEEVLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 17:11:36 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:54533
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756127AbaEEVLe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 17:11:34 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dIc89bh936eI148cI1432I4015Izz1f42h2148h1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25f6h2605h268bh26d3h27e2h906i2673i)
Date: Mon, 5 May 2014 14:10:23 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: David Miller <davem@davemloft.net>
CC: <michal.simek@xilinx.com>, <nicolas.ferre@atmel.com>, <git@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH 5/5] net: macb: Fix race between HW and driver
References: <1399243382-12528-6-git-send-email-soren.brinkmann@xilinx.com>
 <20140505.165653.1184059074645793091.davem@davemloft.net>
 <7c62baab-5f60-4f04-87f7-6b53fecc4746@CH1EHSMHS038.ehs.local>
 <20140505.170959.2172440110209805460.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140505.170959.2172440110209805460.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <433e19f4-93b3-458e-842e-33c511fdee74@CO9EHSMHS005.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-05 at 05:09PM -0400, David Miller wrote:
> From: Sören Brinkmann <soren.brinkmann@xilinx.com>
> Date: Mon, 5 May 2014 14:05:19 -0700
> 
> > On Mon, 2014-05-05 at 04:56PM -0400, David Miller wrote:
> >> From: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >> Date: Sun,  4 May 2014 15:43:02 -0700
> >> 
> >> > Under "heavy" RX load, the driver cannot handle the descriptors fast
> >> > enough. In detail, when a descriptor is consumed, its used flag is
> >> > cleared and once the RX budget is consumed all descriptors with a
> >> > cleared used flag are prepared to receive more data. Under load though,
> >> > the HW may constantly receive more data and use those descriptors with a
> >> > cleared used flag before they are actually prepared for next usage.
> >> > 
> >> > The head and tail pointers into the RX-ring should always be valid and
> >> > we can omit clearing and checking of the used flag.
> >> > 
> >> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >> 
> >> Isn't the RX_USED bit the only thing that controls what RX entries
> >> the chip will try to use?
> >> 
> >> I can't see how you can just remove the RX_USED bit handling
> >> altogether.
> >> 
> >> The problem actually seems to be that in the current code we clear the
> >> RX_USED bit before we actually reallocate the buffer and set it up.
> >> 
> >> It should be a bug to see the RX_USED bit set in gem_rx_refill(), and
> >> the only reason why it can happen is exactly because you're clearing it
> >> too early in gem_rx().
> > 
> > I don't follow. The HW uses the descriptor and the driver handles the
> > received data. So, in gem_rx_refill we should actually only replace
> > descriptor which have the RX_USED _set_, not? Currently the test tests
> > for the opposite, since SW clears RX_USED in gem_rx. This patch just
> > removes those two parts. The RX_USED is left as is (HW should have set
> > it). And in gem_rx_refill we simply rely on the head and tail pointers
> > to refill the used descriptors. I didn't see a reason to do the additional
> > checking of the RX_USED bit.
> > After the refill the RX_USED flags are of course cleared for all
> > refilled descriptors.
> 
> Aha, that makes sense, I didn't notice that RX_USED is cleared as a side
> effect of gem_rx_refill()'s work.
> 
> I'll apply this series, thanks for explaining.

Thanks, but we probably wanna wait for Nicolas to test on his platforms
using macb?

	Sören


