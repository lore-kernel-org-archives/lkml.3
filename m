Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaIQJM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:12:57 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:38833 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbaIQJMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:12:54 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8H9BIhY023693, This message is accepted by code: ctloc85258
Message-ID: <54195036.2010409@realsil.com.cn>
Date: Wed, 17 Sep 2014 17:11:18 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Chris Ball <chris@printf.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Roger <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: Re: [PATCH] mmc: rtsx: add card power off during probe
References: <1410485999-10939-1-git-send-email-micky_ching@realsil.com.cn> <CAPDyKFqcbK9OuQXbegignwiS7rz3L8resQ7Jfc8WvqXEKTcWVA@mail.gmail.com>
In-Reply-To: <CAPDyKFqcbK9OuQXbegignwiS7rz3L8resQ7Jfc8WvqXEKTcWVA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 02:01 AM, Ulf Hansson wrote:
> On 12 September 2014 03:39,  <micky_ching@realsil.com.cn> wrote:
>> From: Roger Tseng <rogerable@realtek.com>
>>
>> Some platform have both UEFI driver and MFD/mmc driver, if entering
>> linux while card in the slot, the card power is already on, and rtsx-mmc
>> driver have no chance to make card power off. This will lead UHSI card
>> failed to enter UHSI mode.
>>
>> It is hard to control the UEFI driver leaving state, so we power off the
>> card power during probe.
>>
>> Signed-off-by: Roger Tseng <rogerable@realtek.com>
>> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
>> ---
>>   drivers/mmc/host/rtsx_pci_sdmmc.c |    7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
>> index dfde4a2..57b0796 100644
>> --- a/drivers/mmc/host/rtsx_pci_sdmmc.c
>> +++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
>> @@ -1341,8 +1341,13 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
>>          host->pcr = pcr;
>>          host->mmc = mmc;
>>          host->pdev = pdev;
>> -       host->power_state = SDMMC_POWER_OFF;
>>          INIT_WORK(&host->work, sd_request);
>> +       sd_power_off(host);
>> +       /*
>> +        * ref: SD spec 3.01: 6.4.1.2 Power On or Power Cycle
>> +        */
>> +       usleep_range(1000, 2000);
>> +
> This won't work in cases were you power off eMMC cards, unless you can
> do a full power cycle - cut both VCC and VCCQ. Can you?
Hi Uffe,

VCCQ will poweroff at the same time.

if MMC_CAP2_NO_PRESCAN_POWERUP enable, will call mmc_power_off() at start,
then it will check ios.power_mode, but the state is MMC_POWER_OFF and just return.

Best Regards.
micky.

> There are also another option you might want to use,
> MMC_CAP2_NO_PRESCAN_POWERUP. But again, it must only be used for those
> hosts that you are able to do a full power cycle for.
>
> Kind regards
> Uffe
>
>>          platform_set_drvdata(pdev, host);
>>          pcr->slots[RTSX_SD_CARD].p_dev = pdev;
>>          pcr->slots[RTSX_SD_CARD].card_event = rtsx_pci_sdmmc_card_event;
>> --
>> 1.7.9.5
>>
> .
>

