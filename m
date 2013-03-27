Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3C0CTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 22:19:10 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55690 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3C0CTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 22:19:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: =?utf-8?q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Stephen Warren <swarren@wwwdotorg.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <b810d127-dad8-447c-bf88-8ac715debbff@CO9EHSMHS026.ehs.local>
Cc: Josh Cartwright <josh.cartwright@ni.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <git@xilinx.com>,
        =?utf-8?q?Jan_L=C3=BCbbe?= <jlu@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
References: <27dae808-1d3a-4001-8eb2-b0a6e2a34b8f@AM1EHSMHS013.ehs.local>
 <515093B4.2090701@wwwdotorg.org>
 <8fd7278d-37c5-48ff-8d06-edc64d532a96@VA3EHSMHS037.ehs.local>
 <5150DEB6.7070208@wwwdotorg.org>
 <b810d127-dad8-447c-bf88-8ac715debbff@CO9EHSMHS026.ehs.local>
Message-ID: <20130327021844.4014.43809@quantum>
User-Agent: alot/0.3.3+
Subject: Re: RFC v2: Zynq Clock Controller
Date: Tue, 26 Mar 2013 19:18:44 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sören Brinkmann (2013-03-25 17:03:24)
> On Mon, Mar 25, 2013 at 05:33:10PM -0600, Stephen Warren wrote:
> > On 03/25/2013 12:27 PM, Sören Brinkmann wrote:
> > > Hi Stephen,
> > > 
> > > On Mon, Mar 25, 2013 at 12:13:08PM -0600, Stephen Warren wrote:
> > >> On 03/20/2013 05:56 PM, Sören Brinkmann wrote:
> > >>> Hi,
> > >>>
> > >>> I spent some time working on this and incorporating feedback. Here's an updated proposal for a clock controller for Zynq:
> > >>>
> > >>> Required properties:
> > >>>  - #clock-cells : Must be 1
> > >>>  - compatible : "xlnx,ps7-clkc"  (this may become 'xlnx,zynq-clkc' terminology differs a bit between Xilinx internal and mainline)
> > >>>  - ps-clk-frequency : Frequency of the oscillator providing ps_clk in HZ
> > >>>                      (usually 33 MHz oscillators are used for Zynq platforms)
> > >>
> > >> This may have been mentioned before, but shouldn't the input clock be
> > >> represented as an actual clock in DT, and hence as an entry in this
> > >> node's clocks property? The crystal/... itself can be represented in DT
> > >> as a fixed-clock.
> > > Lars-Peter brought that up, too. Please refer to my answer to him.
> > > 
> > >>
> > >>>  - clock-output-names : List of strings used to name the clock outputs. Shall be a list of the outputs given below.
> > >>
> > >> That shouldn't be required.
> > >
> > > When I want to support of_clk_get_parent_name() for my clocks, I think
> > > it is. And I'm inclined to not brake this functionality.
> > 
> > The solution here is to make clock parent names irrelevant.
> > 
> > Also note that device tree is supposed to describe HW. As such, this
> > kind of internal implementation detail of the Linux clock driver should
> > have basically zero effect on the DT binding definition.
> > 
> > >>> Optional properties:
> > >>>  - clocks : as described in the clock bindings
> > >>>  - clock-names : as described in the clock bindings
> > >>
> > >> I think clocks should be required, with at least the main crystal clock
> > >> input always present, but perhaps having some optional entries for the
> > >> (E)MIO feature you mention.
> > >
> > > This is why I have the xtal separate. This way these props are purely
> > > optional and the xtal frequency is obtained separately. It also makes it
> > > a little easier internally, because I don't have to cope with a variable
> > > name for the xtal this way.
> > > 
> > > Describing the xtal as fixed clock in DT means a mandatory entry for
> > > 'clocks' and 'clock-names' and a variable name for the xtal clock. I
> > > wanted to avoid this.
> > 
> > I don't see any benefit with some properties being purely optional.
> > Having optional entries in a property seems just fine to me.
> > 
> > The name of the crystal clock should be irrelevant; that issue simply
> > needs to be fixed. It's driving too much of this discussion, and it will
> > be irrelevant once it's fixed.
> > 
> > >>> Example:
> > >>>         clkc: clkc {
> > >>>                 #clock-cells = <1>;
> > >>>                 compatible = "xlnx,ps7-clkc";
> > >>>                 ps-clk-frequency = <33333333>;
> > >>>                 clock-output-names = "armpll", "ddrpll", "iopll", "cpu_6or4x", "cpu_3or2x", "cpu_2x", "cpu_1x", "ddr2x", "ddr3x", "dci", "lqspi", "smc", "pcap", "gem0", "gem1", "fclk0", "fclk1", "fclk2", "fclk3", "can0", "can1", "sdio0", "sdio1", "uart0", "uart1", "spi0", "spi1", "dma", "usb0_aper", "usb1_aper", "gem0_aper", "gem1_aper", "sdio0_aper", "sdio1_aper", "spi0_aper", "spi1_aper", "can0_aper", "can1_aper", "i2c0_aper", "i2c1_aper", "uart0_aper", "uart1_aper", "gpio_aper", "lqspi_aper", "smc_aper", "swdt", "dbg_trc", "dbg_apb";  /* long list... explanation below */
> > >>>                 /* optional props */
> > >>>                 clocks = <&clkc 16>, <&clk_foo>;
> > >>>                 clock-names = "gem1_emio_clk", "can_mio_clk_23";
> > >>>         };
> > >>>
> > >>> The downside of supporting this is, that I don't see a way around explicitly listing the clock output names in the DT.
> > >>
> > >> (Please wrap your emails to ~74 characters or so)
> > > I changed my settings.
> > > 
> > >>
> > >> As Mike mentioned off-list, one can create a new clk registration API
> > >> that takes a struct clk* as parent rather than a char *clk_name.
> > >
> > > Then we also have to make sure clocks are probed in a specific order. To
> > > obtain a 'struct clk *' through clk_get() the requested clock has to be
> > > already been probed. Currently clock probing relies purely on data present
> > > in DT. This makes this proposal not that trivial, IMHO.
> > 
> > Simply use deferred probe.
> This would require major changes to the whole clock probing mechanism.

Which mechanism are you referring to?

> Currently, clocks can not defer probing. And in case of circular
> dependencies in the clock tree, it would rather require a multiple steps
> probe. Simply deferring won't be enough.

Circular dependencies in the clock tree?

Anyways the clock core maintains an orphan list that was originally
designed for this problem: registering a clock before that clock's
parent is registered.  Just for kicks I have actually registered all of
OMAP4's clocks in exactly the opposite order and everything still works.
Of course this makes the clock registration parent-discovery code
O(n^2), but that is the same worst case for deferred probe.

As long as a key exists to link two clocks together then registration
order shouldn't matter.  Originally this key was an immutable clk name
string.

If clock parents are specified in DT then that should also suffice, in
place of doing string comparisons.

If no key to pair up clocks exists then yes we will have to rely purely
on the struct clk *opaque_cookie and register clocks in order.

Regards,
Mike

> 
>         Sören
