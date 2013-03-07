Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065Ab3CGX04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 18:26:56 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:16546
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758218Ab3CGX0y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 18:26:54 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zzbb2dI98dI9371Ic89bh936eI1102I1432I168aJzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah906i1155h)
Date: Thu, 7 Mar 2013 15:25:25 -0800
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
 <2a91857c-473f-4f92-b2b1-e7ac4679b72a@AM1EHSMHS007.ehs.local>
 <51390E92.2080806@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <51390E92.2080806@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 07 Mar 2013 23:25:27.0379 (UTC) FILETIME=[0D0EA230:01CE1B8B]
X-RCIS-Action: ALLOW
Message-ID: <a6c711bf-7722-4eb0-bb72-0e5c00e4ba9d@CO9EHSMHS016.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 11:02:58PM +0100, Lars-Peter Clausen wrote:
> On 03/07/2013 08:11 PM, Sören Brinkmann wrote:
> > On Thu, Mar 07, 2013 at 10:36:35AM +0100, Lars-Peter Clausen wrote:
> >> On 03/06/2013 06:27 PM, Sören Brinkmann wrote:
> >>> Hi Jan,
> >>>  
> >>> what a small world. Good to hear from you.
> >>>
> >>> On Wed, Mar 06, 2013 at 12:51:21PM +0100, Jan Lübbe wrote:
> >>>> Hi Sören,
> >>>>
> >>>> On Tue, 2013-03-05 at 12:04 -0800, Sören Brinkmann wrote:
> >>>>> For this reasons, I'd like to propose moving Zynq into the same
> >>>>> direction. I.e. adding a clock controller with the following DT
> >>>>> description (details may change but the general idea should become
> >>>>> clear):
> >>>>> 	clkc: clkc {
> >>>>>                 #clock-cells = <1>;
> >>>>>                 compatible = "xlnx,ps7-clkc";
> >>>>>                 ps_clk_frequency = <33333333>;	# board x-tal
> >>>>>                 # optional props
> >>>>>                 gem0_emio_clk_freq = <125000000>;
> >>>>>                 gem1_emio_clk_freq = <50000000>;
> >>>>>                 can_mio_clk_freq_xx = <1234>; # this is possible 54 times with xx = 00..53
> >>>>>         };
> >>
> >> I definitely prefer the way it is right now in upstream, where we have one
> >> dt node per clock. It is more descriptive and also more extensible. And you
> >> also don't have to remember the clock index, and can use the phandle
> >> directly instead.
> > The problems I see with that are:
> >  - with the clock controller we can model the clock tree as we need without changing the DT all the time
> 
> When do we need to change the clock tree? The clock tree is pretty much fixed
> in hardware. And the DT describes the hardware, so I don't so a problem there.
> 
> >  - w/o a clock controller there is no block which has knowledge of the whole clock tree (unless we parse the DT), and could conduct reparent operations and similar
> 
> The clk framework builds a representation of the clock tree. Each clock should
> be able to handle re-parenting on it's own, without knowing about the other
> clocks in the tree, the parent is selected by a field in the clocks register.
> It doesn't even have to know who the parents are, the clk framework will take
> care of all of this and just say, ok, switch your input clock to X, where X is
> a simple integer number The clk framework will also take care of re-calculating
> all the updates frequencies after re-parenting.
Nope, clk_set_parent() takes two 'struct *clk' as argument. So, you have to have those of the clock to change and all its parents. A device driver for example, which gets a clock through clk_get() does not have that information and should not, since it should not have to be aware of the SOC's clock hierarchy, IMHO.

> 
> >  - once the clock controller is properly defined the clock connection should be contained in a dtsi which never changes. So, regarding remembering outputs, I don't see a problem. I rather see issues with having a pile of clocks described in the DT. I have currently 44 outputs proposed, and to model the whole tree a lot of more clocks are used (I started modeling everything with the clock primitives and removed custom clock implementations, except for the PLLs). Having all those in the DT does not really help, IMHO.
> 
> Well, except if you want to use external clocks for ethernet or CAN. Also you
> don't need to change the dtsi either if you have a separate node for each clock.
> 
> To avoid misunderstandings let me clarify that I don't want to have one node
> per clock, but rather one node per clock block (or whatever they are called).
> The combination of input select + divider + output gate. E.g. the UART clock
> block with it's 3 inputs and two outputs.
> 
> Also the APER clocks should probably be one node with 24 outputs.
Okay, so instead of having one block encapsulating all clocks, you want it on a finer granularity. I don't see huge differences why that should be advantageous? It would just mean to create several blocks with their custom DT bindings instead of a single one. Just the abstraction level would be a little different.

	Sören


