Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbaJ3MPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:15:37 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:50606 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059AbaJ3MPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:15:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: I2C OF IRQ parsing issue due to probe ordering
Date: Thu, 30 Oct 2014 14:15:43 +0200
Message-ID: <15051800.BQpGCgk7GR@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <545227E4.5070507@vanguardiasur.com.ar>
References: <2287003.09eTeKUr1V@avalon> <545227E4.5070507@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ezequiel,

On Thursday 30 October 2014 08:58:28 Ezequiel Garcia wrote:
> On 10/25/2014 07:13 PM, Laurent Pinchart wrote:
> > Hello,
> > 
> > I recently ran into an issue with the OF IRQ parsing code in the I2C core
> > (of_i2c_register_devices in drivers/i2c/i2c-core.c).
> > 
> > My DT contains the following nodes.
> > 
> >         gpio1: gpio@e6051000 {
> >                 ...
> >                 #interrupt-cells = <2>;
> >                 interrupt-controller;
> >                 clocks = <&mstp9_clks R8A7790_CLK_GPIO1>;
> >         };
> >         
> >         iic2: i2c@e6520000 {
> >                 #address-cells = <1>;
> >                 #size-cells = <0>;
> >                 ...
> >                 hdmi@39 {
> >                         compatible = "adi,adv7511w";
> >                         reg = <0x39>;
> >                         interrupt-parent = <&gpio1>;
> >                         interrupts = <15 IRQ_TYPE_EDGE_FALLING>;
> >                         ...
> >                 };
> >         };
> >         
> >         mstp9_clks: mstp9_clks@e6150994 {
> >                 ...
> >         };
> > 
> > The i2c@e6520000 node is probed before the gpio@e6051000 node. The
> > of_i2c_register_devices() function tries to register all children,
> > including hdmi@39. It tries to parse and map the I2C client IRQ by
> > calling irq_of_parse_and_map(), which returns 0 as the interrupt
> > controller isn't probed yet. The adv7511 driver later probes the hdmi@39
> > device and gets client->irq set to 0.
> > 
> > We can't control the probe order.
> 
> Maybe I'm missing something, but I think your i2c adapter is probed with
> a subsys_initcall (as many other adapters). Otherwise, I can't see why
> it would be probed before the the gpio controller.
> 
> I think this initcall is your problem. Have you tried just using
> platform_driver's probe?

My I2C controller driver uses module_platform_driver(). The reason why the 
GPIO controller is probed later is because the GPIO requires a clock, and the 
clock device is probed after the I2C controller, resulting in a deferred 
probing the first time the GPIO controller is probed.

In the general case probe ordering can't be controlled, especially with DT. I 
believe we thus need a generic solution.

-- 
Regards,

Laurent Pinchart

