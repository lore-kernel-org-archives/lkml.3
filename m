Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaBNLNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:13:18 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48207 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaBNLNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:13:16 -0500
Message-ID: <52FDFA2D.7090406@ti.com>
Date: Fri, 14 Feb 2014 13:12:45 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <tony@atomide.com>, <bcousson@baylibre.com>, <balbi@ti.com>, <nm@ti.com>,
        <khilman@linaro.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v7 02/12] mfd: omap-usb-host: Get clocks based on hardware
 revision
References: <1392200333-28397-1-git-send-email-rogerq@ti.com> <1392200333-28397-3-git-send-email-rogerq@ti.com> <20140214100701.GC7380@lee--X1>
In-Reply-To: <20140214100701.GC7380@lee--X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 12:07 PM, Lee Jones wrote:
>> Not all revisions have all the clocks so get the necessary clocks
>> based on hardware revision.
>>
>> This should avoid un-necessary clk_get failure messages that were
>> observed earlier.
>>
>> Be more strict and always fail on clk_get() error.
> 
> It might have been clearer if you'd broken these two pieces of
> functionality changes into two different patches. In future it would
> be preferred.

OK.

> 
>> CC: Lee Jones <lee.jones@linaro.org>
>> CC: Samuel Ortiz <sameo@linux.intel.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  drivers/mfd/omap-usb-host.c | 92 +++++++++++++++++++++++++++++++--------------
>>  1 file changed, 64 insertions(+), 28 deletions(-)
>>
>> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
>> index 0c3c9a0..60a3bed 100644
>> --- a/drivers/mfd/omap-usb-host.c
>> +++ b/drivers/mfd/omap-usb-host.c
>> @@ -665,22 +665,41 @@ static int usbhs_omap_probe(struct platform_device *pdev)
>>  		goto err_mem;
>>  	}
>>  
>> -	need_logic_fck = false;
>> +	/* Set all clocks as invalid to begin with */
>> +	omap->ehci_logic_fck = omap->init_60m_fclk = ERR_PTR(-ENODEV);
>> +	omap->utmi_p1_gfclk = omap->utmi_p2_gfclk = ERR_PTR(-ENODEV);
>> +	omap->xclk60mhsp1_ck = omap->xclk60mhsp2_ck = ERR_PTR(-ENODEV);
>> +
> 
> For readability you should probably do these one per line.

OK.

> 
>>  	for (i = 0; i < omap->nports; i++) {
>> -		if (is_ehci_phy_mode(i) || is_ehci_tll_mode(i) ||
>> -			is_ehci_hsic_mode(i))
>> -				need_logic_fck |= true;
>> +		omap->utmi_clk[i] = ERR_PTR(-ENODEV);
>> +		omap->hsic480m_clk[i] = ERR_PTR(-ENODEV);
>> +		omap->hsic60m_clk[i] = ERR_PTR(-ENODEV);
>>  	}
>>  
>> -	omap->ehci_logic_fck = ERR_PTR(-EINVAL);
>> -	if (need_logic_fck) {
>> -		omap->ehci_logic_fck = devm_clk_get(dev, "ehci_logic_fck");
> 
> Has this clock been renamed, or is it no longer required?

It is only for OMAP3 and it's actual name is "usbhost_120m_fck".
"ehci_logic_fck" is just an alias.

> 
> Perhaps you should be explicit in the commit log as to which clocks
> you're removing.
> 
>> -		if (IS_ERR(omap->ehci_logic_fck)) {
>> -			ret = PTR_ERR(omap->ehci_logic_fck);
>> -			dev_dbg(dev, "ehci_logic_fck failed:%d\n", ret);
>> +	/* for OMAP3 i.e. USBHS REV1 */
>> +	if (omap->usbhs_rev == OMAP_USBHS_REV1) {
>> +		need_logic_fck = false;
>> +		for (i = 0; i < omap->nports; i++) {
>> +			if (is_ehci_phy_mode(pdata->port_mode[i]) ||
>> +			    is_ehci_tll_mode(pdata->port_mode[i]) ||
>> +			    is_ehci_hsic_mode(pdata->port_mode[i]))
>> +
>> +				need_logic_fck |= true;
>> +		}
>> +
>> +		if (need_logic_fck) {
>> +			omap->ehci_logic_fck = clk_get(dev, "usbhost_120m_fck");
> 
> devm_clk_get()?

Indeed.

cheers,
-roger
