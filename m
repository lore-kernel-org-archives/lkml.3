Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab3DBPlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:41:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43208 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab3DBPlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:41:00 -0400
Message-ID: <515AFC06.8000502@wwwdotorg.org>
Date: Tue, 02 Apr 2013 09:40:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: linux-usb@vger.kernel.org, mchehab@redhat.com, linux-doc@vger.kernel.org,
        tony@atomide.com, grant.likely@secretlab.ca, linux@arm.linux.org.uk,
        javier@dowhile0.org, cesarb@cesarb.net, arnd@arndb.de,
        eballetbo@gmail.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, swarren@nvidia.com,
        sylvester.nawrocki@gmail.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, b-cousson@ti.com,
        gregkh@linuxfoundation.org, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, balbi@ti.com, santosh.shilimkar@ti.com,
        rob@landley.net, akpm@linux-foundation.org, davem@davemloft.net
Subject: Re: [PATCH v4 1/6] drivers: phy: add generic PHY framework
References: <1364449408-9510-1-git-send-email-kishon@ti.com> <1364449408-9510-2-git-send-email-kishon@ti.com> <5154658A.3080209@wwwdotorg.org> <515A98B3.7090405@ti.com>
In-Reply-To: <515A98B3.7090405@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 02:37 AM, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Thursday 28 March 2013 09:15 PM, Stephen Warren wrote:
>> On 03/27/2013 11:43 PM, Kishon Vijay Abraham I wrote:
>>> The PHY framework provides a set of APIs for the PHY drivers to
>>> create/destroy a PHY and APIs for the PHY users to obtain a reference
>>> to the
>>
>>> diff --git a/Documentation/devicetree/bindings/phy/phy-bindings.txt

>>> +PHY subsystem refer Documentation/phy.txt
>>> +
>>> +PHY device node
>>> +===============
>>> +
>>> +Optional Properties:
>>> +#phy-cells:    Number of cells in a PHY specifier;  The meaning of all those
>>> +        cells is defined by the binding for the phy node. However
>>> +        in-order to return the correct PHY, the PHY susbsystem
>>> +        requires the first cell always refers to the port.
>>
>> Why impose that restriction? Other DT bindings do not.
>>
>> This is typically implemented by having each provider driver implement a
>> .of_xlate() operation, which parses all of the specifier cells, and
>> returns the ID of the object it represents. This allows bindings to use
>> whatever arbitrary representation they want.
> 
> Do you mean something like this
> 
> struct phy *of_phy_get(struct device *dev, int index)
> {
>     struct phy *phy = NULL;
>     struct phy_bind *phy_map = NULL;
>     struct of_phandle_args args;
>     struct device_node *node;
> 
>     if (!dev->of_node) {
>         dev_dbg(dev, "device does not have a device node entry\n");
>         return ERR_PTR(-EINVAL);
>     }
> 
>     ret = of_parse_phandle_with_args(dev->of_node, "phys", "#phy-cells",
>         index, &args);
>     if (ret) {
>         dev_dbg(dev, "failed to get phy in %s node\n",
>             dev->of_node->full_name);
>         return ERR_PTR(-ENODEV);
>     }

Looks good.

> //Here we have to get a reference to the phy in order to call of_xlate
> which seems a little hacky to me. I'm not sure how else can we call the
> provider driver :-(
>     phy = of_phy_lookup(dev, node);
>     if (IS_ERR(phy) || !try_module_get(phy->ops->owner)) {
>         phy = ERR_PTR(-EPROBE_DEFER);
>         goto err0;
>     }

I think the concept of a "PHY provider" and a "PHY instance" are different.

of_xlate should be called on a "PHY provider", and return a "PHY
instance". Hence, above you want to only look up a "PHY provider", so
there's no hackiness involved.

> //here we are checking if the phy has additional specifiers and if so
> call of_xlate using the phy we just obtained. The provider driver should
> check the args and return the appropriate *phy in this case.
>     if (args.args_count > 0) {

It's probably simplest to always call of_xlate; that way, you're always
calling it on a "PHY provider" and getting back a "PHY instance". For
providers that only provide 1 instance, the implementation should be
simple:-)

>         phy = phy->of_xlate(&args);
>         if (IS_ERR(phy))
>             goto err0;
>     }
> 
>     phy_map = phy_bind(dev_name(dev), index, dev_name(&phy->dev));
>     if (!IS_ERR(phy_map)) {
>         phy_map->phy = phy;
>         phy_map->auto_bind = true;
>     }
> 
>     get_device(&phy->dev);
> 
> err0:
>     of_node_put(node);
> 
>     return phy;
> }
> EXPORT_SYMBOL_GPL(of_phy_get);

