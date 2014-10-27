Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaJ0D40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 23:56:26 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:58736 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaJ0D4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 23:56:25 -0400
Message-ID: <544DC264.9020600@roeck-us.net>
Date: Sun, 26 Oct 2014 20:56:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/15] net: dsa: Add support for switch EEPROM access
References: <1414342365-27191-1-git-send-email-linux@roeck-us.net> <1414342365-27191-10-git-send-email-linux@roeck-us.net> <20141027024121.GA16998@lunn.ch>
In-Reply-To: <20141027024121.GA16998@lunn.ch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.544DC268.00DC,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2014 07:41 PM, Andrew Lunn wrote:
> On Sun, Oct 26, 2014 at 09:52:39AM -0700, Guenter Roeck wrote:
>> On some chips it is possible to access the switch eeprom.
>> Add infrastructure support for it.
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> v2:
>> - Add support for configuring switch EEPROM size through platform data
>>    or devicetree data
>> - Do not compare new pointers against NULL
>> - Check if get_eeprom pointer is set before calling it
>>
>>   include/net/dsa.h | 10 ++++++++++
>>   net/dsa/dsa.c     |  4 ++++
>>   net/dsa/slave.c   | 41 +++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 55 insertions(+)
>>
>> diff --git a/include/net/dsa.h b/include/net/dsa.h
>> index 55e75e7..37856a2 100644
>> --- a/include/net/dsa.h
>> +++ b/include/net/dsa.h
>> @@ -38,6 +38,9 @@ struct dsa_chip_data {
>>   	struct device	*host_dev;
>>   	int		sw_addr;
>>
>> +	/* set to size of eeprom if supported by the switch */
>> +	int		eeprom_len;
>> +
>>   	/* Device tree node pointer for this specific switch chip
>>   	 * used during switch setup in case additional properties
>>   	 * and resources needs to be used
>> @@ -258,6 +261,13 @@ struct dsa_switch_driver {
>>   	int	(*set_temp_limit)(struct dsa_switch *ds, int temp);
>>   	int	(*get_temp_alarm)(struct dsa_switch *ds, bool *alarm);
>>   #endif
>> +
>> +	/* EEPROM access */
>> +	int	(*get_eeprom_len)(struct dsa_switch *ds);
>> +	int	(*get_eeprom)(struct dsa_switch *ds,
>> +			      struct ethtool_eeprom *eeprom, u8 *data);
>> +	int	(*set_eeprom)(struct dsa_switch *ds,
>> +			      struct ethtool_eeprom *eeprom, u8 *data);
>>   };
>>
>>   void register_switch_driver(struct dsa_switch_driver *type);
>> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
>> index 5edbbca..1c1b925 100644
>> --- a/net/dsa/dsa.c
>> +++ b/net/dsa/dsa.c
>> @@ -575,6 +575,7 @@ static int dsa_of_probe(struct platform_device *pdev)
>>   	const char *port_name;
>>   	int chip_index, port_index;
>>   	const unsigned int *sw_addr, *port_reg;
>> +	u32 eeprom_length;
>>   	int ret;
>>
>>   	mdio = of_parse_phandle(np, "dsa,mii-bus", 0);
>> @@ -603,6 +604,9 @@ static int dsa_of_probe(struct platform_device *pdev)
>>   	if (pd->nr_chips > DSA_MAX_SWITCHES)
>>   		pd->nr_chips = DSA_MAX_SWITCHES;
>>
>> +	if (!of_property_read_u32(np, "eeprom-length", &eeprom_length))
>> +		pd->eeprom_length = eeprom_length;
>> +
>
> Hi Guenter
>
> I would of expected a property to indicate the eeprom is present, not
> a length value. The switch determines the length, or at least the
> minimum length. So the switch driver can return the length, if the
> eeprom is indicated to be present.
>
MV88E6352 and compatible chips can neither provide presence nor
length information, so both have to come from platform data or
devicetree.

> Also, all device tree properties need to be documented. I've not
> looked through all the patches, so maybe it is in a separate patch?
>
The documentation is in the next patch.

I merged both presence and length into one optional property, following
the logic that providing a length implies presence and that presence
without length doesn't really provide the required information.

I also wanted to give drivers a chance to indicate presence and length
without the need of devicetree properties or platform data, if a chip
can provide that information.

Also, the only indication to the calling code (ethtool) that there
is not eeprom is through the length field, so I figured that a separate
"presence" field would, for all practical purpose, be just noise
and not be of practical value.

>> +static int dsa_slave_get_eeprom_len(struct net_device *dev)
>> +{
>> +	struct dsa_slave_priv *p = netdev_priv(dev);
>> +	struct dsa_switch *ds = p->parent;
>> +
>> +	if (ds->pd->eeprom_len)
>> +		return ds->pd->eeprom_len;
>> +
>> +	if (ds->drv->get_eeprom_len)
>> +		return ds->drv->get_eeprom_len(ds);
>> +
>> +	return 0;
>> +}
>
> This also does not look right. The default is that there is no
> property in DT, meaning the EEPROM is not present. So
> ds->pd->eeprom_len is zero. So the first if is not taken. It then
> calls into the driver which is return a length, independent of if it
> is populated or not.
>

No property was supposed to mean that the information about presence
and length is not provided through devicetree or platform data,
but must be provided by the driver. Devicetree and platform data were
meant to augment auto-detection of presence and length, not to replace
it.

> If we are going with your suggested binding, no value in DT, or a
> value of 0 mean no EEPROM. If there is a value in DT
> dsa_slave_get_eeprom_len() should return that value. Asking the driver
> is redundant, you can remove the get_eeprom_len() call.
>
Again, the MV chips can not provide length or presence information.
That was the whole point of having platform / devicetree data.

> However, if DT just indicates the eeprom is populated or not, you
> should call the driver get_eeprom_len() is the eeprom property is
> present.
>
Guess I was trying to be too intelligent.

So lets take a step back: For the Marvell chips, I have to provide both length
and presence in devicetree or platform data. Presence seemed to be implied by
length, so I used only a single property and variable to indicate both.

Are you asking me to make that mandatory, ie to have presence and length
_always_ be provided by devicetree or platform data ? Sure, I can do that
and simply drop the get_length dsa callback function.

Also, it seems that you request two separate properties, one for presence
and another for length. Is that correct ? Again, I thought that would not
provide any value since presence is indicated by length != 0 in the ethtool
callback function. No problem, though, I'll be happy to create two separate
properties and platform data variables if you think that would be better.

>> +static int dsa_slave_get_eeprom(struct net_device *dev,
>> +				struct ethtool_eeprom *eeprom, u8 *data)
>> +{
>> +	struct dsa_slave_priv *p = netdev_priv(dev);
>> +	struct dsa_switch *ds = p->parent;
>> +
>> +	if (ds->drv->get_eeprom)
>> +		return ds->drv->get_eeprom(ds, eeprom, data);
>
> This should be conditional on the length/present.
>
>> +
>> +	return -EOPNOTSUPP;
>> +}
>> +
>> +static int dsa_slave_set_eeprom(struct net_device *dev,
>> +				struct ethtool_eeprom *eeprom, u8 *data)
>> +{
>> +	struct dsa_slave_priv *p = netdev_priv(dev);
>> +	struct dsa_switch *ds = p->parent;
>> +
>> +	if (ds->drv->set_eeprom)
>> +		return ds->drv->set_eeprom(ds, eeprom, data);
>
> Same again.
>
>       Andrew
>
Sure, no problem.

Thanks,
Guenter
>
>> +	return -EOPNOTSUPP;
>> +}
>> +
>>   static void dsa_slave_get_strings(struct net_device *dev,
>>   				  uint32_t stringset, uint8_t *data)
>>   {
>> @@ -387,6 +425,9 @@ static const struct ethtool_ops dsa_slave_ethtool_ops = {
>>   	.get_drvinfo		= dsa_slave_get_drvinfo,
>>   	.nway_reset		= dsa_slave_nway_reset,
>>   	.get_link		= dsa_slave_get_link,
>> +	.get_eeprom_len		= dsa_slave_get_eeprom_len,
>> +	.get_eeprom		= dsa_slave_get_eeprom,
>> +	.set_eeprom		= dsa_slave_set_eeprom,
>>   	.get_strings		= dsa_slave_get_strings,
>>   	.get_ethtool_stats	= dsa_slave_get_ethtool_stats,
>>   	.get_sset_count		= dsa_slave_get_sset_count,
>> --
>> 1.9.1
>>
>

