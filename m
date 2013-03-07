Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab3CGTMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 14:12:00 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:15751
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932724Ab3CGTL6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 14:11:58 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371Ic89bh936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah906i1155h)
Date: Thu, 7 Mar 2013 11:11:44 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Jan =?utf-8?B?TMO8YmJl?= <jlu@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <git@xilinx.com>
Subject: Re: RFC: Zynq Clock Controller
References: <37032699-343e-485c-80e0-9b23e3706c58@VA3EHSMHS013.ehs.local>
 <1362570681.5269.98.camel@coredoba.hi.pengutronix.de>
 <f288874c-d0ae-4581-8d0f-2b9abe4d3117@CO9EHSMHS002.ehs.local>
 <51385FA3.8080105@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <51385FA3.8080105@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 07 Mar 2013 19:11:46.0163 (UTC) FILETIME=[9C816430:01CE1B67]
X-RCIS-Action: ALLOW
Message-ID: <2a91857c-473f-4f92-b2b1-e7ac4679b72a@AM1EHSMHS007.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 10:36:35AM +0100, Lars-Peter Clausen wrote:
> On 03/06/2013 06:27 PM, Sören Brinkmann wrote:
> > Hi Jan,
> >  
> > what a small world. Good to hear from you.
> > 
> > On Wed, Mar 06, 2013 at 12:51:21PM +0100, Jan Lübbe wrote:
> >> Hi Sören,
> >>
> >> On Tue, 2013-03-05 at 12:04 -0800, Sören Brinkmann wrote:
> >>> For this reasons, I'd like to propose moving Zynq into the same
> >>> direction. I.e. adding a clock controller with the following DT
> >>> description (details may change but the general idea should become
> >>> clear):
> >>> 	clkc: clkc {
> >>>                 #clock-cells = <1>;
> >>>                 compatible = "xlnx,ps7-clkc";
> >>>                 ps_clk_frequency = <33333333>;	# board x-tal
> >>>                 # optional props
> >>>                 gem0_emio_clk_freq = <125000000>;
> >>>                 gem1_emio_clk_freq = <50000000>;
> >>>                 can_mio_clk_freq_xx = <1234>; # this is possible 54 times with xx = 00..53
> >>>         };
> 
> I definitely prefer the way it is right now in upstream, where we have one
> dt node per clock. It is more descriptive and also more extensible. And you
> also don't have to remember the clock index, and can use the phandle
> directly instead.
The problems I see with that are:
 - with the clock controller we can model the clock tree as we need without changing the DT all the time
 - w/o a clock controller there is no block which has knowledge of the whole clock tree (unless we parse the DT), and could conduct reparent operations and similar
 - once the clock controller is properly defined the clock connection should be contained in a dtsi which never changes. So, regarding remembering outputs, I don't see a problem. I rather see issues with having a pile of clocks described in the DT. I have currently 44 outputs proposed, and to model the whole tree a lot of more clocks are used (I started modeling everything with the clock primitives and removed custom clock implementations, except for the PLLs). Having all those in the DT does not really help, IMHO.

> 
> >>
> >> The clock controller should only contain properties for input frequency
> >> (which can obviously not be calculated at run-time).
> >>
> >> Are the gem*, can* properties inputs? If they are actually outputs, the
> >> corresponding frequencies should be requested by the clock consumers and
> >> not hard-coded in DT.
> > They are inputs. GEM and CAN have the option to be clocked through (E)MIO pins, i.e. some external clock input which cannot be derived from ps_clk like all other clocks. I plan to register a fixed rate, root clock for each of those properties, if present.
> 
> If it is a static external input clock use a "fixed-clock" dt node to
> describe it. This also has the advantage that is is also possible to use a
> non-static clock.
I thought about this too, and it's probably a valid use-case.

What comes to my mind to support this would be:
 - clocks and clock-names properties to the controller
 - those two properties hold a list of available external clock sources

 e.g:
 	clocks = <&foo>, <&bar 2>, <&foobar 0>;
	clock-names = "can_emio_clk_44", "gem1_emio_clk", "can_emio_clk_00";

 Then the clock controller would go through the possible clock names trying a 'clk_get(NULL, "gem0_emio_clk"', etc. making available connections.

 	Sören


