Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbaIRFvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 01:51:37 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:47056 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597AbaIRFve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 01:51:34 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8I5nwuh013013, This message is accepted by code: ctloc85258
Message-ID: <541A7286.1080008@realsil.com.cn>
Date: Thu, 18 Sep 2014 13:49:58 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <sameo@linux.intel.com>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>
Subject: Re: [PATCH] mfd: rtsx: fix PM suspend for 5227 & 5249
References: <1411004156-9057-1-git-send-email-micky_ching@realsil.com.cn> <20140918045316.GB8740@lee--X1>
In-Reply-To: <20140918045316.GB8740@lee--X1>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 12:53 PM, Lee Jones wrote:
> On Thu, 18 Sep 2014, micky_ching@realsil.com.cn wrote:
>
>> From: Micky Ching <micky_ching@realsil.com.cn>
>>
>> Fix rts5227&5249 failed send buffer cmd after suspend,
>> PM_CTRL3 should reset before send any buffer cmd after suspend.
>> Otherwise, buffer cmd will failed, this will lead resume fail.
>>
>> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
>> ---
>>   drivers/mfd/rts5227.c        |   19 +++++++++++++++++++
>>   drivers/mfd/rts5249.c        |    4 ++++
>>   drivers/mfd/rtsx_pcr.h       |    1 +
>>   include/linux/mfd/rtsx_pci.h |   12 ++++++++++++
>>   4 files changed, 36 insertions(+)
> I think you'll find you just broke the build.
>
> What happens when you compile these as modules?
I build as modules with no warning or error, did you find anything wrong?
>> diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
>> index 9c8eec8..8222a31 100644
>> --- a/drivers/mfd/rts5227.c
>> +++ b/drivers/mfd/rts5227.c
>> @@ -128,8 +128,27 @@ static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
>>   	return rtsx_pci_send_cmd(pcr, 100);
>>   }
>>   
>> +int rts5227_pm_reset(struct rtsx_pcr *pcr)
>> +{
>> +	int err;
>> +
>> +	/* init aspm */
>> +	err = rtsx_pci_update_cfg_byte(pcr, LCTLR, 0xFC, 0);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	/* reset PM_CTRL3 before send buffer cmd */
>> +	return rtsx_pci_write_register(pcr, PM_CTRL3, 0x10, 0x00);
>> +}
>> +
>>   static int rts5227_optimize_phy(struct rtsx_pcr *pcr)
>>   {
>> +	int err;
>> +
>> +	err = rts5227_pm_reset(pcr);
>> +	if (err < 0)
>> +		return err;
>> +
>>   	/* Optimize RX sensitivity */
>>   	return rtsx_pci_write_phy_register(pcr, 0x00, 0xBA42);
>>   }
>> diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
>> index 573de7b..0f1b0e6 100644
>> --- a/drivers/mfd/rts5249.c
>> +++ b/drivers/mfd/rts5249.c
>> @@ -130,6 +130,10 @@ static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
>>   {
>>   	int err;
>>   
>> +	err = rts5227_pm_reset(pcr);
>> +	if (err < 0)
>> +		return err;
> I don't like this.  Place rts52xx_pm_reset() somewhere more central.
> Perhaps an inline function in the header would be better?
Thanks, I will fix later.
>>   	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV,
>>   			PHY_REG_REV_RESV | PHY_REG_REV_RXIDLE_LATCHED |
>>   			PHY_REG_REV_P1_EN | PHY_REG_REV_RXIDLE_EN |
>> diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
>> index 07e4c2e..acc7a1e 100644
>> --- a/drivers/mfd/rtsx_pcr.h
>> +++ b/drivers/mfd/rtsx_pcr.h
>> @@ -72,4 +72,5 @@ do {									\
>>   	pcr->ms_pull_ctl_disable_tbl = __device##_ms_pull_ctl_disable_tbl; \
>>   } while (0)
>>   
>> +int rts5227_pm_reset(struct rtsx_pcr *pcr);
>>   #endif
>> diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
>> index 74346d5..b34fec8 100644
>> --- a/include/linux/mfd/rtsx_pci.h
>> +++ b/include/linux/mfd/rtsx_pci.h
>> @@ -967,4 +967,16 @@ static inline u8 *rtsx_pci_get_cmd_data(struct rtsx_pcr *pcr)
>>   	return (u8 *)(pcr->host_cmds_ptr);
>>   }
>>   
>> +static inline int rtsx_pci_update_cfg_byte(struct rtsx_pcr *pcr, int addr,
>> +		u8 mask, u8 append)
>> +{
>> +	int err;
>> +	u8 val;
>> +
>> +	err = pci_read_config_byte(pcr->pci, addr, &val);
>> +	if (err < 0)
>> +		return err;
>> +	return pci_write_config_byte(pcr->pci, addr, (val & mask) | append);
>> +}
>> +
>>   #endif

