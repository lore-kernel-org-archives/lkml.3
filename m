Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaDWML4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:11:56 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:57207 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaDWMLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:11:48 -0400
Message-ID: <5357AE20.70808@linaro.org>
Date: Wed, 23 Apr 2014 20:12:16 +0800
From: "kefeng.wang" <kefeng.wang@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
CC: wangkefeng.wang@huawei.com
Subject: Re: [PATCH v4 2/3] libahci_platform: add host_flags parameter in
 ahci_platform_init_host()
References: <1398253008-17059-1-git-send-email-kefeng.wang@linaro.org> <1398253008-17059-3-git-send-email-kefeng.wang@linaro.org> <5357A86C.1070709@redhat.com>
In-Reply-To: <5357A86C.1070709@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-4-23 19:47, Hans de Goede wrote:
> Hi,
> 
> On 04/23/2014 01:36 PM, Kefeng Wang wrote:
>> Add a dynamic host flags argument to make ahci_platform_init_host more flexible,
>> then remove the AHCI_HFLAGS(...) argument from some driver's ata_port_info,
>> and pass that in as the new arguments.
>>
>> Cc: Hans de Geode <hdegoede@redhat.com>
>> Signed-off-by: Kefeng Wang <kefeng.wang@linaro.org>
> 
> Thanks for working on this, review comments inline.
> 
[...]
>> diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
>> index 77c89bf..8022b5a 100644
>> --- a/drivers/ata/ahci_xgene.c
>> +++ b/drivers/ata/ahci_xgene.c
>> @@ -382,6 +382,7 @@ static int xgene_ahci_probe(struct platform_device *pdev)
>>  	struct ahci_host_priv *hpriv;
>>  	struct xgene_ahci_context *ctx;
>>  	struct resource *res;
>> +	unsigned int hflags;
>>  	int rc;
>>  
>>  	hpriv = ahci_platform_get_resources(pdev);
>> @@ -450,7 +451,10 @@ static int xgene_ahci_probe(struct platform_device *pdev)
>>  		goto disable_resources;
>>  	}
>>  
>> -	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info, 0, 0);
>> +	hflags = AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ,
>> +
>> +	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info,
>> +				     hflags, 0, 0);
>>  	if (rc)
>>  		goto disable_resources;
>>  
> 
> You should remove the AHCI_HFLAGS(AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ),
> part from xgene_ahci_port_info here, like you do for ahci_sunxi.c

yes.

> 
>> diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
>> index 7cb3a85..ebd880e 100644
>> --- a/drivers/ata/libahci_platform.c
>> +++ b/drivers/ata/libahci_platform.c
>> @@ -283,6 +283,7 @@ EXPORT_SYMBOL_GPL(ahci_platform_get_resources);
>>   * @pdev: platform device pointer for the host
>>   * @hpriv: ahci-host private data for the host
>>   * @pi_template: template for the ata_port_info to use
>> + * @host_flags: ahci host flags used in ahci_host_priv
>>   * @force_port_map: param passed to ahci_save_initial_config
>>   * @mask_port_map: param passed to ahci_save_initial_config
>>   *
>> @@ -296,6 +297,7 @@ EXPORT_SYMBOL_GPL(ahci_platform_get_resources);
>>  int ahci_platform_init_host(struct platform_device *pdev,
>>  			    struct ahci_host_priv *hpriv,
>>  			    const struct ata_port_info *pi_template,
>> +			    unsigned int host_flags,
>>  			    unsigned int force_port_map,
>>  			    unsigned int mask_port_map)
>>  {
> 
> And here you should actually do something with hflags, not just throw
> them away. Something like:
> 
> pi.private_data = (void *)host_flags;

:( it's my mistake, will update, thanks for you reminder.

> 
>> diff --git a/include/linux/ahci_platform.h b/include/linux/ahci_platform.h
>> index 1f16d50..45897f6 100644
>> --- a/include/linux/ahci_platform.h
>> +++ b/include/linux/ahci_platform.h
>> @@ -44,6 +44,7 @@ struct ahci_host_priv *ahci_platform_get_resources(
>>  int ahci_platform_init_host(struct platform_device *pdev,
>>  			    struct ahci_host_priv *hpriv,
>>  			    const struct ata_port_info *pi_template,
>> +			    unsigned int host_flags,
>>  			    unsigned int force_port_map,
>>  			    unsigned int mask_port_map);
>>  
>>
> 
> Regards,
> 
> Hans
> 

