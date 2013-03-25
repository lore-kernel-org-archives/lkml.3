Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729Ab3CZAAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:00:03 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:14044
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759105Ab3CZAAA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:00:00 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI9371Ic89bh1432Idb82hzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah906i1155h)
Date: Mon, 25 Mar 2013 16:59:46 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Mike Turquette <mturquette@linaro.org>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <git@xilinx.com>,
        Jan =?utf-8?B?TMO8YmJl?= <jlu@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: RFC v2: Zynq Clock Controller
References: <27dae808-1d3a-4001-8eb2-b0a6e2a34b8f@AM1EHSMHS013.ehs.local>
 <514B5254.50101@metafoo.de>
 <128fc723-ace7-4f4c-95d9-971b42a52080@CH1EHSMHS028.ehs.local>
 <5150DDDD.9010904@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5150DDDD.9010904@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <e906143d-3c04-4df4-95aa-0c6410b97ffe@VA3EHSMHS024.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 05:29:33PM -0600, Stephen Warren wrote:
> On 03/22/2013 04:41 PM, Sören Brinkmann wrote:
> > Hi Lars,
> > 
> > On Thu, Mar 21, 2013 at 07:32:52PM +0100, Lars-Peter Clausen wrote:
> >> On 03/21/2013 12:56 AM, Sören Brinkmann wrote:
> >>> Hi,
> >>>
> >>> I spent some time working on this and incorporating feedback. Here's an updated proposal for a clock controller for Zynq:
> >>>
> >>> Required properties:
> >>>  - #clock-cells : Must be 1
> >>>  - compatible : "xlnx,ps7-clkc"  (this may become 'xlnx,zynq-clkc' terminology differs a bit between Xilinx internal and mainline)
> >>>  - ps-clk-frequency : Frequency of the oscillator providing ps_clk in HZ
> >>>                      (usually 33 MHz oscillators are used for Zynq platforms)
> >>>  - clock-output-names : List of strings used to name the clock outputs. Shall be a list of the outputs given below.
> >>>
> >>> Optional properties:
> >>>  - clocks : as described in the clock bindings
> >>>  - clock-names : as described in the clock bindings
> >>>
> >>> Clock inputs:
> >>> The following strings are optional parameters to the 'clock-names' property in
> >>> order to provide optional (E)MIO clock sources.
> >>>  - swdt_ext_clk
> >>>  - gem0_emio_clk
> >>>  - gem1_emio_clk
> >>>  - mio_clk_XX          # with XX = 00..53
> >>>
> >>> Example:
> >>>         clkc: clkc {
> >>>                 #clock-cells = <1>;
> >>>                 compatible = "xlnx,ps7-clkc";
> >>>                 ps-clk-frequency = <33333333>;
> >>
> >> The input frequency should be a clock as well.
> >
> > Again, monolithic vs split. I don't see a reason not to just internally
> > call clk_register_fixed_rate(). That way its children do not have to
> > cope with a variable name for the xtal.
> > Also, with my proposal 'clocks' and 'clock-names' would be purely
> > optional properties, only required if optional external inputs are
> > present. Having the xtal defined externally would add mandatory entries for
> > those props.
> 
> But isn't the clock source board-specific? It's a completely separate
> object from Zynq's own clock controller HW, and as such should be
> represented by a separate DT node, right?
Well, the ps-clk-frequency property would be board specific right. But
the same would apply for a fixed-rate clock. This is how it's currently
done in mainline. The zynq dtsi file defines the fixed-rate clock and
every board dts file overrides the fixed rate clock's frequency
property.
In my approach the fixed rate clock is within the clkc block and every
board dts has to provide this property accordingly.


> 
> The issue with parent clock names is simply a red herring. A solution is
> needed to registered clock with a parent clock object, rather than a
> parent clock name. Then, the parent names are completely irrelevant.
But we'd trade the naming problems with issues regarding the order of
how clocks are probed.
And it may not be as easy as just probe from the root towards the leafs
of the clock tree.
In Zynq I can route clocks generated in the processor part into the FPGA
and back using them as an input for the clock-controller. Ant the IP in
the FPGA could add another layer of clock providers in that loop.
With such circular dependencies a clock object based
registration/probing does not seem too easy to me.

	Sören


