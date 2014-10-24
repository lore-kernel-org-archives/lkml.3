Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbaJXUft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 16:35:49 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:44884 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbaJXUfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 16:35:47 -0400
Message-ID: <544AB81E.4060900@gmail.com>
Date: Fri, 24 Oct 2014 22:35:42 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
To: balbi@ti.com
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        =?windows-1252?Q?Antoine_T=E9?= =?windows-1252?Q?nart?= 
	<antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] phy: berlin-sata: Move PHY_BASE into private data
 struct
References: <1413882477-27922-1-git-send-email-sebastian.hesselbarth@gmail.com> <1413882477-27922-2-git-send-email-sebastian.hesselbarth@gmail.com> <54462865.6000205@ti.com> <544629F0.3090505@gmail.com> <544AB33F.9030701@gmail.com> <20141024202510.GK11455@saruman>
In-Reply-To: <20141024202510.GK11455@saruman>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.10.2014 22:25, Felipe Balbi wrote:
> Hi,
>
> On Fri, Oct 24, 2014 at 10:14:55PM +0200, Sebastian Hesselbarth wrote:
>> On 21.10.2014 11:40, Sebastian Hesselbarth wrote:
>>> On 10/21/2014 11:33 AM, Kishon Vijay Abraham I wrote:
>>>> On Tuesday 21 October 2014 02:37 PM, Sebastian Hesselbarth wrote:
>>>>> Currently, Berlin SATA PHY driver assumes PHY_BASE address being
>>>>> constant. While this PHY_BASE is correct for BG2Q, older BG2 PHY_BASE
>>>>> is different. Prepare the driver for BG2 support by moving the phy_base
>>>>> into private driver data.
>>>>>
>>>>> Acked-by: Antoine Ténart <antoine.tenart@free-electrons.com>
>>>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>> ...
>>>>> ---
>>>>>   drivers/phy/phy-berlin-sata.c | 42
>>>>> ++++++++++++++++++++++++++++--------------
>>>>>   1 file changed, 28 insertions(+), 14 deletions(-)
>>>>>
>>>>> diff --git a/drivers/phy/phy-berlin-sata.c
>>>>> b/drivers/phy/phy-berlin-sata.c
>>>>> index 69ced52d72aa..9682b0f66177 100644
>>>>> --- a/drivers/phy/phy-berlin-sata.c
>>>>> +++ b/drivers/phy/phy-berlin-sata.c
>>>>> @@ -30,7 +30,7 @@
>>>>>   #define MBUS_WRITE_REQUEST_SIZE_128    (BIT(2) << 16)
>>>>>   #define MBUS_READ_REQUEST_SIZE_128    (BIT(2) << 19)
>>>>>
>>>>> -#define PHY_BASE        0x200
>>>>> +#define BG2Q_PHY_BASE        0x200
>>> [...]
>>>>> +static u32 bg2q_sata_phy_base = BG2Q_PHY_BASE;
>>>>> +
>>>>> +static const struct of_device_id phy_berlin_sata_of_match[] = {
>>>>> +    {
>>>>> +        .compatible = "marvell,berlin2q-sata-phy",
>>>>> +        .data = &bg2q_sata_phy_base,
>>>>
>>>> Can't the base directly come from dt?
>>>
>>> You are suggesting a "marvell,phy-base-address" property, right?
>>> I have no strong opinion about it, I accept your call (or DT maintainer
>>> ones).
>>
>> Kishon,
>>
>> I still have the DT patches for BG2Q queued up for v3.19 (I missed the
>> arm-soc merge window for v3.18). That means, there has been no release
>> with the phy binding used and I can rework a little more.
>>
>> Can you please confirm that you want a DT property for the phy base address,
>> e.g. marvell,phy-base-address = <{0x200,0x80}> ?
>>
>> If so, I'd also rename the compatible from berlin2q-sata-phy to more
>> generic berlin-sata-phy.
>
> I think what Kishon is asking, is why this 0x200 offset isn't already on
> reg. so that instead of, e.g.:
>
> 	reg = <0x40000000 0x1000>;
>
> you would have:
>
> 	reg = <0x40000200 0x1000>;

Because it is the PHY_BASE offset within the _indirect_ register
access trough AHCI registers.

> then everybody's happy. It's unfortunate, however, that we already
> shipped DT sources with the bogus (?) reg property and now we have to
> support that broken binding. My suggestion would be to add a new
> compatible which comes with proper reg property and still add that weird
> phy_base for the old compatible, so that:

Nope, the reg property is correct and describes the (vendor-specific)
AHCI registers that are used for indirect access to PHY registers. When
writing to PHY registers, BG2 and BG2Q are different with respect to
the PHY_BASE address offset that has to be passed to indirect address
register.

> 	if (of_device_is_compatible(node, "marvell,berlin2q-sata-phy"))
> 		phy->phy_base = PHY_BASE;
>
> then, if new compatible comes with proper 'reg', phy->phy_base would be
> zero and everything should still work. How does this sound ?

The above is basically equivalent to the node match that I added with
this patch series. I can, of course, use above compatible match instead
of passing the phy_base in the of_device_id's .data.

Sebastian

