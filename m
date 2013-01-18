Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab3ARPF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:05:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33966 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab3ARPFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:05:13 -0500
Message-ID: <50F96495.6070502@ti.com>
Date: Fri, 18 Jan 2013 17:04:53 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <sameo@linux.intel.com>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 05/22] mfd: omap-usb-tll: Clean up clock handling
References: <1358511445-26656-1-git-send-email-rogerq@ti.com> <1358511445-26656-6-git-send-email-rogerq@ti.com> <20130118145906.GE23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130118145906.GE23505@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 04:59 PM, Russell King - ARM Linux wrote:
> On Fri, Jan 18, 2013 at 02:17:08PM +0200, Roger Quadros wrote:
>> +	tll->ch_clk = devm_kzalloc(dev, sizeof(struct clk * [tll->nch]),
>> +						GFP_KERNEL);
>> +	if (!tll->ch_clk) {
>> +		ret = -ENOMEM;
>> +		dev_err(dev, "Couldn't allocate memory for channel clocks\n");
>> +		goto err_clk_alloc;
>> +	}
>> +
>> +	for (i = 0; i < tll->nch; i++) {
>> +		char clkname[] = "usb_tll_hs_usb_chx_clk";
>> +		struct clk *fck;
>> +
>> +		snprintf(clkname, sizeof(clkname),
>> +					"usb_tll_hs_usb_ch%d_clk", i);
>> +		fck = clk_get(dev, clkname);
>> +
>> +		if (IS_ERR(fck))
>> +			dev_dbg(dev, "can't get clock : %s\n", clkname);
>> +		else
>> +			tll->ch_clk[i] = fck;
> 
> Hmm.  I'd actually suggest that this becomes:
> 
> 		tll->ch_clk[i] = fck;
> 		if (IS_ERR(fck)
> 			dev_dbg(dev, "can't get clock: %s\n", clkname);
> 
> so that tll->ch_clk is always written to.

Yes, I'll fix this.

> 
>>  static int usbtll_omap_remove(struct platform_device *pdev)
>>  {
>>  	struct usbtll_omap *tll = platform_get_drvdata(pdev);
>> +	int i;
>> +
>> +	for (i = 0; i < tll->nch; i++)
>> +		clk_put(tll->ch_clk[i]);
> 
> And change this to:
> 
> 	for (i = 0; i < tll->nch; i++)
> 		if (!IS_ERR(tll->ch_clk[i]))
> 			clk_put(tll->ch_clk[i]);
> 
> so that you're not passing a NULL pointer in.
>
ok.

>> +	for (i = 0; i < tll->nch; i++) {
>> +		if (is_ehci_tll_mode(pdata->port_mode[i])) {
>> +			int r;
>>  
>> -	if (is_ehci_tll_mode(pdata->port_mode[1]))
>> -		clk_enable(tll->usbtll_p2_fck);
>> +			if (!tll->ch_clk[i])
> 
> 			if (IS_ERR(tll->ch_clk[i]))
ok.
> 
>> +				continue;
>> +
>> +			r = clk_enable(tll->ch_clk[i]);
>> +			if (r) {
>> +				dev_err(dev,
>> +				 "Error enabling ch %d clock: %d\n", i, r);
>> +			}
>> +		}
>> +	}
> 
>> @@ -387,11 +409,12 @@ static int usbtll_runtime_suspend(struct device *dev)
>>  
>>  	spin_lock_irqsave(&tll->lock, flags);
>>  
>> -	if (is_ehci_tll_mode(pdata->port_mode[0]))
>> -		clk_disable(tll->usbtll_p1_fck);
>> -
>> -	if (is_ehci_tll_mode(pdata->port_mode[1]))
>> -		clk_disable(tll->usbtll_p2_fck);
>> +	for (i = 0; i < tll->nch; i++) {
>> +		if (is_ehci_tll_mode(pdata->port_mode[i])) {
>> +			if (tll->ch_clk[i])
> 
> 			if (!IS_ERR(tll->ch_clk[i]))
ok.

> 
>> +				clk_disable(tll->ch_clk[i]);
>> +		}
>> +	}
>>  
>>  	spin_unlock_irqrestore(&tll->lock, flags);
>>  

--
cheers,
-roger

