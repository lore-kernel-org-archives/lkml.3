Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965658Ab3CZQWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:22:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52081 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934715Ab3CZQWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:22:20 -0400
Message-ID: <5151CB36.1050404@wwwdotorg.org>
Date: Tue, 26 Mar 2013 10:22:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Graeme Gregory <gg@slimlogic.co.uk>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, "balbi@ti.com" <balbi@ti.com>,
        Rajendra Nayak <rnayak@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "s-guiriec@ti.com" <s-guiriec@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Ian Lartey <ian@slimlogic.co.uk>
Subject: Re: [PATCH v3] USB: PHY: Palmas USB Transceiver Driver
References: <1362662506-14823-4-git-send-email-kishon@ti.com> <1364203926-24488-1-git-send-email-kishon@ti.com> <51501CFB.4020905@nvidia.com> <51513A40.7080905@ti.com> <515163F6.3010400@slimlogic.co.uk> <51516695.8020808@nvidia.com> <51516A10.40704@slimlogic.co.uk>
In-Reply-To: <51516A10.40704@slimlogic.co.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 03:27 AM, Graeme Gregory wrote:
...
> If we are tightly coupling as above then using platform_irq is an extra
> inefficiency. You both have to populate this then parse it afterwards.
> Why not just use the regmap helper? Ill admit this code is like this as
> there was a period where platform irqs in DT just was not working right!
> 
> We should really agree now if we are going for loose or tight coupling
> now rather than keep switching?

Yes, this is something that I think needs to be fully resolved before
any more Palmas patches are discussed.

So you can have the MFD components fully coupled or completely
standalone. We should fully pick one or the other, not some mish-mash of
the two.

In practical terms, this means that:

a) Tightly coupled

The top-level MFD device knows exactly which child devices are present.
It has an internal table to defined the set of child devices, and
instantiate them. It provides them with IRQs, I2C addresses and register
base addresses (or regmaps), etc. etc., using purely Palmas-internal
APIs. If using device tree, the DT won't include any representation of
which child devices are present, nor their I2C addresses, nor their
register addresses, nor their IRQs, etc. That's all inside the driver.

b) Completely decoupled.

The top-level MFD device knows nothing about its children. It simply
provides a bus into which they can be instantiated, and a generic IRQ
controller into which they can hook.

Platform data or device tree is solely used to define which children
exist, which of the top-level MFD's I2C addresses is used for each
child, the base register address for each child device, the IRQs used by
each child device, etc.


Which of those two models are different people expecting?

(b) appears to be the most flexible, and since you have defined the DT
bindings to contain a separate node for each MFD child device, each with
its own compatible value, seems to be what you're aiming for. In this
scenario, there should be no private APIs between the top-level MFD
device and the children though; everything should be using standard bus
APIs.
