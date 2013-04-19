Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3DSJJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:09:40 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:34918 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab3DSJJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:09:37 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 1/6] drivers: phy: add generic PHY framework
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-usb@vger.kernel.org, mchehab@redhat.com, linux-doc@vger.kernel.org,
        tony@atomide.com, linux@arm.linux.org.uk, javier@dowhile0.org,
        cesarb@cesarb.net, arnd@arndb.de, eballetbo@gmail.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        swarren@nvidia.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, b-cousson@ti.com,
        gregkh@linuxfoundation.org, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, balbi@ti.com, santosh.shilimkar@ti.com,
        rob@landley.net, akpm@linux-foundation.org, davem@davemloft.net
In-Reply-To: <516D255F.40604@ti.com>
References: <1363770725-13717-1-git-send-email-kishon@ti.com> <1363770725-13717-2-git-send-email-kishon@ti.com> <20130415113416.7C3943E0AA8@localhost> <516BF1E2.3020104@ti.com> <20130415195030.9F7E93E0AA8@localhost> <516D255F.40604@ti.com>
Date: Fri, 19 Apr 2013 10:09:33 +0100
Message-Id: <20130419090933.AB4253E116D@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013 15:48:07 +0530, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> On Tuesday 16 April 2013 01:20 AM, Grant Likely wrote:
> > On Mon, 15 Apr 2013 17:56:10 +0530, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> >> On Monday 15 April 2013 05:04 PM, Grant Likely wrote:
> >>> On Wed, 20 Mar 2013 14:42:00 +0530, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> >> We have decided not to implement the PHY layer as a separate bus layer.
> >> The PHY provider can be part of any other bus. Making the PHY layer as a
> >> bus will make the PHY provider to be part of multiple buses which will
> >> lead to bad design. All we are trying to do here is keep the pool of PHY
> >> devices under PHY class in this layer and help any controller that wants
> >> to use the PHY to get it.
> >
> > If you're using a class, then you already have your list of registered
> > phy devices! :-) No need to create another global list that you need to
> > manage.
> 
> right. We already use _class_dev_iter_ for finding the phy device.
> .
> .
> +static struct phy *of_phy_lookup(struct device *dev, struct device_node 
> *node)
> +{
> +	struct phy *phy;
> +	struct class_dev_iter iter;
> +
> +	class_dev_iter_init(&iter, phy_class, NULL, NULL);
> +	while ((dev = class_dev_iter_next(&iter))) {
> +		phy = container_of(dev, struct phy, dev);
> +		if (node != phy->of_node)
> +			continue;
> +
> +		class_dev_iter_exit(&iter);
> +		return phy;
> +	}
> +
> +	class_dev_iter_exit(&iter);
> +	return ERR_PTR(-EPROBE_DEFER);
> +}
> .
> .
> 
> however we can't get rid of the other list (phy_bind_list) where we 
> maintain the phy binding information. It's used for the non-dt boot case.

Why? If you're using a class, then it is always there. Why would non-DT
and DT be different in this regard? (more below)

> >>> Since there is at most a 1:N relationship between host controllers and
> >>> PHYs, there shouldn't be any need for a separate structure to describe
> >>> binding. Put the inding data into the struct phy itself. Each host
> >>> controller can have a list of phys that it is bound to.
> >>
> >> No. Having the host controller to have a list of phys wont be a good
> >> idea IMHO. The host controller is just an IP and the PHY to which it
> >> will be connected can vary from board to board, platform to platform. So
> >> ideally this binding should come from platform initialization code/dt data.
> >
> > That is not what I mean. I mean the host controller instance should
> > contain a list of all the PHYs that are attached to it. There should not
> 
> Doesn't sound correct IMO. The host controller instance need not know 
> anything about the PHY instances that is connected to it. Think of it 
> similar to regulator, the controller wouldn't know which regulator it is 
> connected to, all it has to know is it just has a regulator connected to 
> it. It's up-to the regulator framework to give the controller the 
> correct regulator. It's similar here. It makes sense for me to keep a 
> list in the PHY framework in order for it to return the correct PHY (but 
> note that this list is not needed for dt boot).

With regulators and clocks it makes sense to have a global
registration place becase both implement an interconnected network
independent of the device that use them. (clocks depend on other clocks;
regulators depend on other regulators).

Phys are different. There is a 1:N relationship between host controllers
and phys, and you don't get a interconnected network of PHYs. Its a bad
idea to keep the binding data separate from the actual host controller
when there is nothing else that actually needs to use the data. It
creates a new set of data structures that need housekeeping to keep them
in sync with the actual device structures. It really is just a bad idea
and it becomes more difficult (in the non-DT case) to determine what
data is associated with a given host controller. You can't tell by
looking at the struct device.

Instead, for the non-DT case, do what we've always done for describing
connections. Put the phy reference into the host controllers
platform_data structure. That is what it is there for. That completely
eliminates the need to housekeep a new set of data structures.

g.
