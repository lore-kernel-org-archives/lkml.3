Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaDOQoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:44:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35717 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaDOQoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:44:21 -0400
Message-ID: <534D61DF.9090203@ti.com>
Date: Tue, 15 Apr 2014 11:44:15 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Joel Fernandes <joelf@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Joachim Eastwood <manabian@gmail.com>
Subject: Re: [PATCH] crypto: omap-des - handle error of pm_runtime_get_sync
References: <1397575982-24866-1-git-send-email-nm@ti.com> <20140415155031.GA14623@saruman.home>
In-Reply-To: <20140415155031.GA14623@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 10:50 AM, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Apr 15, 2014 at 10:33:02AM -0500, Nishanth Menon wrote:
>> pm_runtime_get_sync may not always succeed depending on SoC involved. So
>> handle the error appropriately.
>>
>> Reported-by: Joachim Eastwood <manabian@gmail.com>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> ---
>>
>> based on v3.15-rc1
>>
>> Report-thread: http://marc.info/?t=139750330400002&r=1&w=2
>>
>> omap2plus_defconfig + CONFIG_CRYPTO_DEV_OMAP_DES=y
>>
>> pandaboard-es-before: http://slexy.org/raw/s21rGPFnKl
>> pandaboard-es-after:  http://slexy.org/raw/s2A4UFQVna
>>
>>  drivers/crypto/omap-des.c |   18 ++++++++++++++----
>>  1 file changed, 14 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
>> index ec5f131..c2d362f 100644
>> --- a/drivers/crypto/omap-des.c
>> +++ b/drivers/crypto/omap-des.c
>> @@ -223,12 +223,18 @@ static void omap_des_write_n(struct omap_des_dev *dd, u32 offset,
>>  
>>  static int omap_des_hw_init(struct omap_des_dev *dd)
>>  {
>> +	int err;
>> +
>>  	/*
>>  	 * clocks are enabled when request starts and disabled when finished.
>>  	 * It may be long delays between requests.
>>  	 * Device might go to off mode to save power.
>>  	 */
>> -	pm_runtime_get_sync(dd->dev);
>> +	err = pm_runtime_get_sync(dd->dev);
>> +	if (err < 0) {
>> +		dev_err(dd->dev, "failed to get_sync(%d)\n", err);
>> +		return err;
> 
> even when get() fails, you must put().

> 
>> +	}
>>  
>>  	if (!(dd->flags & FLAGS_INIT)) {
>>  		dd->flags |= FLAGS_INIT;
>> @@ -1083,7 +1089,11 @@ static int omap_des_probe(struct platform_device *pdev)
>>  	dd->phys_base = res->start;
>>  
>>  	pm_runtime_enable(dev);
>> -	pm_runtime_get_sync(dev);
>> +	err = pm_runtime_get_sync(dev);
>> +	if (err < 0) {
>> +		dev_err(dd->dev, "failed to get_sync(%d)\n", err);
>> +		goto err_get;
> 
> this leaves usage_count incremented, needs a put() here too.
> 

Yeah, I see the code in runtime.c, and pm_runtime_put_noidle is the
right invocation in the case of error.

Wish we had a coccinelle script for this.

-- 
Regards,
Nishanth Menon
