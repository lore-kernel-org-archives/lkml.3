Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbaHRMDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:03:51 -0400
Received: from lifc.univ-fcomte.fr ([194.57.88.66]:55226 "EHLO
	lifc-proxy.univ-fcomte.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaHRMDu (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:03:50 -0400
X-Greylist: delayed 840 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2014 08:03:49 EDT
Date: Mon, 18 Aug 2014 13:49:03 +0200
From: "gwenhael.goavec" <gwen@trabucayre.com>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: Shawn Guo <Shawn.Guo@freescale.com>, Philippe Reynes <tremyfr@gmail.com>,
        "Linux-kernel@vger.kernel.org" <Linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "gwenhael.goavec-merou@trabucayre.com" 
	<gwenhael.goavec-merou@trabucayre.com>
Subject: Re: [RFC] usb issue on imx27: 3 clocks are needed
Message-ID: <20140818134903.5b6e6c27@x230.trabucayre.com>
In-Reply-To: <782c806acb464f5781deb32e94548882@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <53EF7AF6.2000405@gmail.com>
	<20140818090056.GA29393@peterchendt>
	<20140818092635.GI2114@dragon>
	<782c806acb464f5781deb32e94548882@BN1PR0301MB0772.namprd03.prod.outlook.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2014 10:35:53 +0000
Peter Chen <Peter.Chen@freescale.com> wrote:

>  
> > On Mon, Aug 18, 2014 at 05:00:59PM +0800, Peter Chen wrote:
> > > On Sat, Aug 16, 2014 at 05:38:30PM +0200, Philippe Reynes wrote:
> > > > Hi all,
> > > >
> > > > i.MX27's usb needs three clocks (usb_ipg_gate, usb_ahb_gate and
> > > > usb_div) but the current chipidea driver implementation, and
> > > > devicetree, provides only ipg and ahb. Consequently, if the
> > > > bootloader don't enable the last one, the kernel will crash.
> > > >
> > > > Our approach/idea is to add a second, optionnal, clock in
> > > > ci_hdrc_imx.c with 'per' name in devicetree  and to add  clock name
> > 'main_clk' for mandatory clock.
> > > > This approach it correct? Or an other approach seems better?
> > > > Thank you very much for your point of view.
> > > >
> > >
> > > It is ok for me to have ipg, ahb and per clocks at driver, but how can
> > > you maintain DT consistent?
> > 
> > Adding new clock as optional one will just maintain the DT compatibility.
> > 
> 
> How to handle node_usb_soc1's clock which is without clk name to consistent with three
> clocks for node_usb_soc2 at driver? Except for adding some platform judge code at
> driver, do you have other solutions?
> 
> node_usb_soc1: {
> 	clocks = <&clks IMX6_CLK_USBOH3>;
> };
> 
> node_usb_soc2: {
> 	clocks = <&clks IMX27_CLK_USBIPG>, <&clks IMX27_CLK_USBOH3>, <&clks IMX27_CLK_USBPER>;
> 	clock-names = "ipg", "ahb", "per";
> };
> 
> Peter
> --

Our idea is something like this :
node_usb_soc: {
	clocks = <&clks IMX27_CLK_USBxxx>;
	clock-names = "main_clk";
};
for all CPUs

and 
node_usb_imx27: {
	clocks = <&clks IMX27_CLK_USB_IPG_GATE>,
		<&clks IMX27_CLK_USB_DIV>;
	clock-names = "main_clk", "per";
};

For imx27 and CPUs with the need of more than one clock.

The last clock (ie ahb) is handled by usbmisc.c and if "per" clock is not
present in the dtsi chipidea will not fails, just setting data->per_clk = NULL
for prepare/unprepare.

Gwenhael
