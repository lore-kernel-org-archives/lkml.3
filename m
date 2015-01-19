Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbbASBMe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 20:12:34 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:37545 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbbASBMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 20:12:32 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0J1CC6P026185, This message is accepted by code: ctloc85258
From: =?utf-8?B?5pWs6ZSQ?= <micky_ching@realsil.com.cn>
To: Lee Jones <lee.jones@linaro.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rogerable@realtek.com" <rogerable@realtek.com>,
        =?utf-8?B?546L54Kc?= <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 07/10] mfd: rtsx: remove LCTLR defination
Thread-Topic: [PATCH 07/10] mfd: rtsx: remove LCTLR defination
Thread-Index: AQHQMxpFdFTodZXXV0OeYt+Q20nm3pzGHZcA
Date: Mon, 19 Jan 2015 01:12:12 +0000
Message-ID: <54BC59EC.8060205@realsil.com.cn>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
 <157a06b4ac167e755e109962caca526f69955acb.1421320541.git.micky_ching@realsil.com.cn>
 <20150118122821.GL3574@x1>
In-Reply-To: <20150118122821.GL3574@x1>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.29.41.103]
Content-Type: text/plain; charset="utf-8"
Content-ID: <951319E99C00E146B4931E72D713B5A3@realsil.com.cn>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0J1ChR3032540


On 01/18/2015 08:28 PM, Lee Jones wrote:
> On Thu, 15 Jan 2015, micky_ching@realsil.com.cn wrote:
>
>> From: Micky Ching <micky_ching@realsil.com.cn>
>>
>> To enable/disable ASPM we should find LINK CONTROL register
>> in PCI config space. All old chip use 0x80 address, but new
>> chip may use another address, so we using pci_find_capability()
>> to get LINK CONTROL address.
>>
>> rtsx_gops.c was removed, we consider to put some common operations
>> to this file, but the actual thing is, only a group of chips
>> are in common ops1, and another group of chips in common ops2,
>> it is hard to decide put which ops into generic ops file.
>>
>> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
>> ---
>>   drivers/mfd/Makefile         |  2 +-
>>   drivers/mfd/rts5227.c        |  2 +-
>>   drivers/mfd/rts5249.c        |  3 +--
>>   drivers/mfd/rtsx_gops.c      | 37 -------------------------------------
>>   drivers/mfd/rtsx_pcr.c       | 25 ++++++++++++++++++++-----
>>   include/linux/mfd/rtsx_pci.h |  9 ---------
>>   6 files changed, 23 insertions(+), 55 deletions(-)
>>   delete mode 100644 drivers/mfd/rtsx_gops.c
>>
>> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
>> index 53467e2..2cd7e74 100644
>> --- a/drivers/mfd/Makefile
>> +++ b/drivers/mfd/Makefile
>> @@ -13,7 +13,7 @@ obj-$(CONFIG_MFD_CROS_EC)	+= cros_ec.o
>>   obj-$(CONFIG_MFD_CROS_EC_I2C)	+= cros_ec_i2c.o
>>   obj-$(CONFIG_MFD_CROS_EC_SPI)	+= cros_ec_spi.o
>>   
>> -rtsx_pci-objs			:= rtsx_pcr.o rtsx_gops.o rts5209.o rts5229.o rtl8411.o rts5227.o rts5249.o
>> +rtsx_pci-objs			:= rtsx_pcr.o rts5209.o rts5229.o rtl8411.o rts5227.o rts5249.o
>>   obj-$(CONFIG_MFD_RTSX_PCI)	+= rtsx_pci.o
>>   obj-$(CONFIG_MFD_RTSX_USB)	+= rtsx_usb.o
>>   
>> diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
>> index 1f387d4..0c02831 100644
>> --- a/drivers/mfd/rts5227.c
>> +++ b/drivers/mfd/rts5227.c
>> @@ -130,7 +130,7 @@ static int rts5227_optimize_phy(struct rtsx_pcr *pcr)
>>   {
>>   	int err;
>>   
>> -	err = rtsx_gops_pm_reset(pcr);
>> +	err = rtsx_pci_write_register(pcr, PM_CTRL3, D3_DELINK_MODE_EN, 0x00);
>>   	if (err < 0)
>>   		return err;
>>   
>> diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
>> index 00208d1..5eb9819 100644
>> --- a/drivers/mfd/rts5249.c
>> +++ b/drivers/mfd/rts5249.c
>> @@ -119,7 +119,6 @@ static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
>>   		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0xB0, 0xB0);
>>   	else
>>   		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0xB0, 0x80);
>> -	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PM_CTRL3, 0x10, 0x00);
> What's this doing?  Why is it not required anymore?
PM_CTRL3 have been set in rts5249_optimize_phy, this function
rts5249_extra_init will be call for rts524A/rts525A, but their PM_CTRL3
address is redefined to RTS524A_PM_CTRL3, using a different address.
if we set PM_CTRL3 here, the rts524A/rts525A will also set,
but it's not a right address.
>
>>   	return rtsx_pci_send_cmd(pcr, 100);
>>   }
>> @@ -128,7 +127,7 @@ static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
>>   {
>>   	int err;
>>   
>> -	err = rtsx_gops_pm_reset(pcr);
>> +	err = rtsx_pci_write_register(pcr, PM_CTRL3, D3_DELINK_MODE_EN, 0x00);
>>   	if (err < 0)
>>   		return err;
>>   
>> diff --git a/drivers/mfd/rtsx_gops.c b/drivers/mfd/rtsx_gops.c
>> deleted file mode 100644
>> index b1a98c6..0000000
>> --- a/drivers/mfd/rtsx_gops.c
>> +++ /dev/null
>> @@ -1,37 +0,0 @@
>> -/* Driver for Realtek PCI-Express card reader
>> - *
>> - * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
>> - *
>> - * This program is free software; you can redistribute it and/or modify it
>> - * under the terms of the GNU General Public License as published by the
>> - * Free Software Foundation; either version 2, or (at your option) any
>> - * later version.
>> - *
>> - * This program is distributed in the hope that it will be useful, but
>> - * WITHOUT ANY WARRANTY; without even the implied warranty of
>> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> - * General Public License for more details.
>> - *
>> - * You should have received a copy of the GNU General Public License along
>> - * with this program; if not, see <http://www.gnu.org/licenses/>.
>> - *
>> - * Author:
>> - *   Micky Ching <micky_ching@realsil.com.cn>
>> - */
>> -
>> -#include <linux/mfd/rtsx_pci.h>
>> -#include "rtsx_pcr.h"
>> -
>> -int rtsx_gops_pm_reset(struct rtsx_pcr *pcr)
>> -{
>> -	int err;
>> -
>> -	/* init aspm */
>> -	rtsx_pci_write_register(pcr, ASPM_FORCE_CTL, 0xFF, 0x00);
>> -	err = rtsx_pci_update_cfg_byte(pcr, LCTLR, ~LCTLR_ASPM_CTL_MASK, 0x00);
>> -	if (err < 0)
>> -		return err;
>> -
>> -	/* reset PM_CTRL3 before send buffer cmd */
>> -	return rtsx_pci_write_register(pcr, PM_CTRL3, D3_DELINK_MODE_EN, 0x00);
>> -}
>> diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
>> index 92f5a41..3065edc 100644
>> --- a/drivers/mfd/rtsx_pcr.c
>> +++ b/drivers/mfd/rtsx_pcr.c
>> @@ -63,6 +63,20 @@ static const struct pci_device_id rtsx_pci_ids[] = {
>>   
>>   MODULE_DEVICE_TABLE(pci, rtsx_pci_ids);
>>   
>> +static inline void rtsx_pci_enable_aspm(struct rtsx_pcr *pcr)
>> +{
>> +	int exp = pci_find_capability(pcr->pci, PCI_CAP_ID_EXP);
>> +
>> +	rtsx_pci_update_cfg_byte(pcr, exp + PCI_EXP_LNKCTL, 0xFC, pcr->aspm_en);
>> +}
>> +
>> +static inline void rtsx_pci_disable_aspm(struct rtsx_pcr *pcr)
>> +{
>> +	int exp = pci_find_capability(pcr->pci, PCI_CAP_ID_EXP);
>> +
>> +	rtsx_pci_update_cfg_byte(pcr, exp + PCI_EXP_LNKCTL, 0xFC, 0);
>> +}
>> +
>>   void rtsx_pci_start_run(struct rtsx_pcr *pcr)
>>   {
>>   	/* If pci device removed, don't queue idle work any more */
>> @@ -75,7 +89,8 @@ void rtsx_pci_start_run(struct rtsx_pcr *pcr)
>>   			pcr->ops->enable_auto_blink(pcr);
>>   
>>   		if (pcr->aspm_en)
>> -			rtsx_pci_write_config_byte(pcr, LCTLR, 0);
>> +			rtsx_pci_disable_aspm(pcr);
>> +
> ?
We set LCTLR to disable aspm, all old chip using 0x80 address,
but new chip will not use this address, the best way to find
this address is using pci_find_capability().
>
>>   	}
>>   
>>   	mod_delayed_work(system_wq, &pcr->idle_work, msecs_to_jiffies(200));
>> @@ -954,7 +969,7 @@ static void rtsx_pci_idle_work(struct work_struct *work)
>>   		pcr->ops->turn_off_led(pcr);
>>   
>>   	if (pcr->aspm_en)
>> -		rtsx_pci_write_config_byte(pcr, LCTLR, pcr->aspm_en);
>> +		rtsx_pci_enable_aspm(pcr);
>>   
>>   	mutex_unlock(&pcr->pcr_mutex);
>>   }
>> @@ -979,6 +994,7 @@ static void rtsx_pci_power_off(struct rtsx_pcr *pcr, u8 pm_state)
>>   static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
>>   {
>>   	int err;
>> +	int exp = pci_find_capability(pcr->pci, PCI_CAP_ID_EXP);
>>   
>>   	rtsx_pci_writel(pcr, RTSX_HCBAR, pcr->host_cmds_addr);
>>   
>> @@ -992,6 +1008,7 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
>>   	/* Wait SSC power stable */
>>   	udelay(200);
>>   
>> +	rtsx_pci_disable_aspm(pcr);
>>   	if (pcr->ops->optimize_phy) {
>>   		err = pcr->ops->optimize_phy(pcr);
>>   		if (err < 0)
>> @@ -1040,10 +1057,8 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
>>   	if (err < 0)
>>   		return err;
>>   
>> -	rtsx_pci_write_config_byte(pcr, LCTLR, 0);
>> -
>>   	/* Enable clk_request_n to enable clock power management */
>> -	rtsx_pci_write_config_byte(pcr, 0x81, 1);
>> +	rtsx_pci_write_config_byte(pcr, exp + PCI_EXP_LNKCTL + 1, 1);
>>   	/* Enter L1 when host tx idle */
>>   	rtsx_pci_write_config_byte(pcr, 0x70F, 0x5B);
>>   
>> diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
>> index 80baa10..f7cebdb 100644
>> --- a/include/linux/mfd/rtsx_pci.h
>> +++ b/include/linux/mfd/rtsx_pci.h
>> @@ -662,15 +662,6 @@
>>   #define PHY_FLD4			0x1E
>>   #define PHY_DUM_REG			0x1F
>>   
>> -#define LCTLR				0x80
>> -#define   LCTLR_EXT_SYNC		0x80
>> -#define   LCTLR_COMMON_CLOCK_CFG	0x40
>> -#define   LCTLR_RETRAIN_LINK		0x20
>> -#define   LCTLR_LINK_DISABLE		0x10
>> -#define   LCTLR_RCB			0x08
>> -#define   LCTLR_RESERVED		0x04
>> -#define   LCTLR_ASPM_CTL_MASK		0x03
>> -
>>   #define PCR_SETTING_REG1		0x724
>>   #define PCR_SETTING_REG2		0x814
>>   #define PCR_SETTING_REG3		0x747
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
