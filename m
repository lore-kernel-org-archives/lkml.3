Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab3DBVvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 17:51:35 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:35198 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab3DBVvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 17:51:33 -0400
Message-ID: <515B52D5.5090709@gmail.com>
Date: Tue, 02 Apr 2013 23:51:17 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, arnd@arndb.de, akpm@linux-foundation.org,
        rob@landley.net, davem@davemloft.net, cesarb@cesarb.net,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, b-cousson@ti.com,
        linux@arm.linux.org.uk, eballetbo@gmail.com, javier@dowhile0.org,
        mchehab@redhat.com, santosh.shilimkar@ti.com,
        broonie@opensource.wolfsonmicro.com, swarren@nvidia.com,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/6] drivers: phy: add generic PHY framework
References: <1364449408-9510-1-git-send-email-kishon@ti.com> <1364449408-9510-2-git-send-email-kishon@ti.com> <515A09D8.7040703@gmail.com> <515A0C70.90201@wwwdotorg.org>
In-Reply-To: <515A0C70.90201@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 12:38 AM, Stephen Warren wrote:
> On 04/01/2013 04:27 PM, Sylwester Nawrocki wrote:
>> On 03/28/2013 06:43 AM, Kishon Vijay Abraham I wrote:
>>> diff --git a/Documentation/devicetree/bindings/phy/phy-bindings.txt
>
>>> +example2:
>>> +phys: phy {
>>> +    compatible = "xxx";
>>> +    reg =<...>;
>>> +    .
>>> +    .
>>> +    phys =<&phys 1>;
>>> +    .
>>> +    .
>>> +};
>>> +
>>> +This node represents a controller that uses one of the PHYs which is defined
>>> +previously. Note that the phy handle has an additional specifier "1" to
>>> +differentiate between the three PHYs. For this case, the controller driver
>>> +should use of_phy_get_with_args/devm_of_phy_get_with_args.
>>
>> This means a PHY user needs to know indexes at the PHY driver ?
>
> The client node's DT has to specify which of the provider's PHYs it
> references, yes. Presumably the device driver for the client node knows
> absolutely nothing about this.

Ah, right. The device driver for the client node not necessarily need to be
aware about this. I think I got misled by the 'index' argument of
of_phy_get_with_args() which the PHY consumer need to supply. However it is
only an index pointing to a PHY specifier in its 'phys' property, hence it
would be normally 0 if the client needs only one PHY. Hopefully I got it
right this time.

>> I have been thinking of using this for an IP which has 4 video PHYs: 2 MIPI
>> CSI-2 and 2 MIPI DSI. The IP has just 2 registers, each of which is shared
>> between one MIPI CSI-2 DPHY and one MIPI DSI DPHY. So I thought about creating
>> a single device node for this IP and using 4 indexes for the PHYs, e.g. 0...3.
>
> That sounds right.
>
>> Then users of each PHY type would use only indexes 0..1 (to select their
>> corresponding port).
>
> I don't follow that. If the provider exports PHYs 0..3, then the client
> nodes would refer to PHYS 0..3 not 0..1.

Indeed, it seems I just wanted to preserve the CSI/DSI "channel" information
(0, 1), but that is not really needed anywhere.

>> However I fail to see how this could now be represented in the bindings.
>
> Exactly like the example you gave below, I would expect.
>
>> I assume struct phy::type could be used to differentiate between CSI-2 and DSI.
>> And struct phy::port could be used to select specific CSI-2 or DSI channel
>> (0, 1). Ideally the phy users should not care about index of a PHY at the PHY
>> device tree node. E.g. there are 2 MIPI CSI-2 receivers and each has only
>> one PHY assigned to it. I'm just wondering how the binding should look like,
>> so a PHY could be associated with a receiver automatically by the phy-core,
>> e.g.
>
> Details such as phy::type and phy::port sounds like internal driver
> implementation details which would have no effect on the bindings.

Yes, I seem to have mixed the phy-core implementation and the bindings a 
bit.
My intention was to have the PHYs registered with phy::port that would 
reflect
data channel id, as specified in the SoC's datasheet. However I can't 
think of
any use of it at the moment, except for debugging purpose.

>> /* DPHY IP node */
>> video-phy {
>>        reg =<0x10000000 8>;
>> };
>>
>> /* MIPI DSI nodes */
>> dsi_0 {
>>       phys =<&video-phy 0>;
>> };
>>
>> dsi_1 {
>>       phys =<&video-phy 1>;
>> };
>>
>> /* MIPI CSI-2 nodes */
>> csi_0 {
>>       phys =<&video-phy 2>;
>> };
>>
>> csi_1 {
>>       phys =<&video-phy 3>;
>> };
>
> That looks correct to me.
>
>> I'm not sure if it is not an overkill to use this the PHY framework with
>> a device which has only 2 registers. Perhaps something less heavy could
>> be designed for it. However, if the PHY framework is commonly used there
>> should be no issue wrt enabling the whole big infrastructure for a simple
>> device like this.
>
> I don't think the number of registers should really makes any
> difference; the whole point of the PHY framework is to decouple to
> providers and consumers, so doing anything custom for special cases
> would completely destroy the ability of the PHY framework to do that.

Ok, that's a very good argument. Something I have not been focused on
that much, given the architecture of hardware I used to work with.

I'll git it a try and I'll see if any any further questions jump out.
