Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350Ab3ETVer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 17:34:47 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:35051 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036Ab3ETVep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 17:34:45 -0400
Message-ID: <519A96F0.3010905@gmail.com>
Date: Mon, 20 May 2013 23:34:40 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Simon Baatz <gmbnomis@gmail.com>
CC: Florian Fainelli <florian@openwrt.org>, David Miller <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/7] net: mv643xx_eth: add Device Tree bindings
References: <1365071235-11611-1-git-send-email-florian@openwrt.org> <1367854420-8006-1-git-send-email-sebastian.hesselbarth@gmail.com> <1367854420-8006-2-git-send-email-sebastian.hesselbarth@gmail.com> <20130520211930.GA25725@schnuecks.de>
In-Reply-To: <20130520211930.GA25725@schnuecks.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 11:19 PM, Simon Baatz wrote:
> On Mon, May 06, 2013 at 05:33:34PM +0200, Sebastian Hesselbarth wrote:
>> From: Florian Fainelli<florian@openwrt.org>
>>
...
>> @@ -2485,13 +2499,21 @@ static int mv643xx_eth_shared_probe(struct platform_device *pdev)
>>   	if (dram)
>>   		mv643xx_eth_conf_mbus_windows(msp, dram);
>>
>> -	msp->tx_csum_limit = (pd != NULL&&  pd->tx_csum_limit) ?
>> -					pd->tx_csum_limit : 9 * 1024;
>> +	if (np)
>> +		of_property_read_u32(np, "tx-csum-limit",&tx_csum_limit);
>> +	else
>> +		tx_csum_limit = pd->tx_csum_limit;
>> +
>> +	msp->tx_csum_limit = tx_csum_limit ? tx_csum_limit : 9 * 1024;
>>   	infer_hw_params(msp);
>>
>>   	platform_set_drvdata(pdev, msp);
>>
>> +#ifdef CONFIG_OF
>> +	return of_platform_bus_probe(np, mv643xx_eth_match,&pdev->dev);
>
> I have tested this on Kirkwood (Sheevaplug eSATA). When using
> mv643xx_eth as a module with a built-in mvmdio the GbE port works.
> However, when unloading the mv643xx_eth module and loading it again,
> the second call to of_platform_bus_probe() results in a warning:
>
> [  190.542992] WARNING: at fs/sysfs/dir.c:530 sysfs_add_one+0x7c/0xa4()
> [  190.549372] sysfs: cannot create duplicate filename '/devices/ocp.0/f1072000.
> ethernet-controller/0.ethernet-port'
>
> (Looks more like a problem of of_platform_bus_probe() than a problem
> in the driver?)

Hi Simon,

thanks for the review. I am right now working on a v4 of the DT support
patches for mv643xx_eth and the above will not be there anymore. I will
test v4 for rmmod/modprobe issues before posting.

>> @@ -2677,6 +2769,10 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
>>   	struct resource *res;
>>   	int err;
>>
>> +	err = mv643xx_eth_of_probe(pdev);
>> +	if (err)
>> +		return err;
>> +
>>   	pd = pdev->dev.platform_data;
>>   	if (pd == NULL) {
>>   		dev_err(&pdev->dev, "no mv643xx_eth_platform_data\n");
>
> If the clock isn't already enabled (mvmdio and mv643xx_eth both built
> as modules), a delay seems to be necessary in mv643xx_eth_probe()
> after enabling the clock on my hardware.  Otherwise the device hangs.
> Andrew found the same in the past (see [1]).  udelay(50) seems to be
> sufficient in my case.

Hmm, I am wondering if that delay shouldn't be in the clock provider
then. I test it on Dove also and look for a way to insert the delay
if neccessary. Maybe Andrew can also comment on this.

>> @@ -2717,7 +2813,12 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
>>   	netif_set_real_num_rx_queues(dev, mp->rxq_count);
>>
>>   	if (pd->phy_addr != MV643XX_ETH_PHY_NONE) {
>> -		mp->phy = phy_scan(mp, pd->phy_addr);
>> +		if (pd->phy_node)
>> +			mp->phy = of_phy_connect(mp->dev, pd->phy_node,
>> +						mv643xx_eth_adjust_link, 0,
>> +						PHY_INTERFACE_MODE_GMII);
>
> of_phy_connect() returns NULL in case of an error and no ERR_PTR.

True, will take care of that.

Sebastian
