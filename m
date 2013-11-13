Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3KMBc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 20:32:29 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:39596 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3KMBcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 20:32:22 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID rAD1SeTW003916, This message is accepted by code: ctloc85258
Message-ID: <5282D636.60609@realsil.com.cn>
Date: Wed, 13 Nov 2013 09:30:30 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <sameo@linux.intel.com>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <wei_wang@realsil.com.cn>, <rogerable@realtek.com>
Subject: Re: [PATCH] mfd: rtsx: add card reader rtl8402
References: <1383295053-21061-1-git-send-email-micky_ching@realsil.com.cn> <20131108095641.GU30901@lee--X1>
In-Reply-To: <20131108095641.GU30901@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee

I'm trying to merge the common code into a single function
rtl8411_init_params(), but different chips may use a different
rtlxxx_pcr_ops even they have much the same.  This is because the
ops may be called frequently.

Yet I'm trying to use Regulator Framework, it will make a
somewhat big change , and I will add it in a later time.

So, I wanna to send the merged patch first, is that ok?

On 11/08/2013 05:56 PM, Lee Jones wrote:
> On Fri, 01 Nov 2013, micky_ching@realsil.com.cn wrote:
>
>> From: Micky Ching <micky_ching@realsil.com.cn>
>>
>> Add card reader rtl8042, rtl8402 is much like rtl8411, so just add it to
>> rtl8411.c
>>
>> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
>> ---
>>   drivers/mfd/rtl8411.c  |   62 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   drivers/mfd/rtsx_pcr.c |    5 ++++
>>   drivers/mfd/rtsx_pcr.h |    1 +
>>   3 files changed, 68 insertions(+)
> Sorry Micky, but I'm not accepting this.
>
> This patch adds 62 lines of duplicated code, with only a few
> variations. Please find a way to generify the driver. Also I think we
> should consider doing the voltage stuff using the Regulator Framework.
>
>> diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
>> index 5280135..9d37dd6 100644
>> --- a/drivers/mfd/rtl8411.c
>> +++ b/drivers/mfd/rtl8411.c
>> @@ -498,3 +498,65 @@ void rtl8411b_init_params(struct rtsx_pcr *pcr)
>>   			rtl8411b_qfn64_ms_pull_ctl_disable_tbl;
>>   	}
>>   }
>> +
>> +static int rtl8402_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
>> +{
>> +	u8 mask, val;
>> +	int err;
>> +
>> +	mask = (BPP_REG_TUNED18 << BPP_TUNED18_SHIFT_8402) | BPP_PAD_MASK;
>> +	if (voltage == OUTPUT_3V3) {
>> +		err = rtsx_pci_write_register(pcr,
>> +				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_3v3);
>> +		if (err < 0)
>> +			return err;
>> +		val = (BPP_ASIC_3V3 << BPP_TUNED18_SHIFT_8402) | BPP_PAD_3V3;
>> +	} else if (voltage == OUTPUT_1V8) {
>> +		err = rtsx_pci_write_register(pcr,
>> +				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_1v8);
>> +		if (err < 0)
>> +			return err;
>> +		val = (BPP_ASIC_2V0 << BPP_TUNED18_SHIFT_8402) | BPP_PAD_1V8;
>> +	} else {
>> +		return -EINVAL;
>> +	}
>> +
>> +	return rtsx_pci_write_register(pcr, LDO_CTL, mask, val);
>> +}
>> +
>> +static const struct pcr_ops rtl8402_pcr_ops = {
>> +	.fetch_vendor_settings = rtl8411_fetch_vendor_settings,
>> +	.extra_init_hw = rtl8411_extra_init_hw,
>> +	.optimize_phy = NULL,
>> +	.turn_on_led = rtl8411_turn_on_led,
>> +	.turn_off_led = rtl8411_turn_off_led,
>> +	.enable_auto_blink = rtl8411_enable_auto_blink,
>> +	.disable_auto_blink = rtl8411_disable_auto_blink,
>> +	.card_power_on = rtl8411_card_power_on,
>> +	.card_power_off = rtl8411_card_power_off,
>> +	.switch_output_voltage = rtl8402_switch_output_voltage,
>> +	.cd_deglitch = rtl8411_cd_deglitch,
>> +	.conv_clk_and_div_n = rtl8411_conv_clk_and_div_n,
>> +	.force_power_down = rtl8411_force_power_down,
>> +};
>> +
>> +void rtl8402_init_params(struct rtsx_pcr *pcr)
>> +{
>> +	pcr->extra_caps = EXTRA_CAPS_SD_SDR50 | EXTRA_CAPS_SD_SDR104;
>> +	pcr->num_slots = 2;
>> +	pcr->ops = &rtl8402_pcr_ops;
>> +
>> +	pcr->flags = 0;
>> +	pcr->card_drive_sel = RTL8411_CARD_DRIVE_DEFAULT;
>> +	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
>> +	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
>> +	pcr->aspm_en = ASPM_L1_EN;
>> +	pcr->tx_initial_phase = SET_CLOCK_PHASE(23, 7, 14);
>> +	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);
>> +
>> +	pcr->ic_version = rtl8411_get_ic_version(pcr);
>> +	pcr->sd_pull_ctl_enable_tbl = rtl8411_sd_pull_ctl_enable_tbl;
>> +	pcr->sd_pull_ctl_disable_tbl = rtl8411_sd_pull_ctl_disable_tbl;
>> +	pcr->ms_pull_ctl_enable_tbl = rtl8411_ms_pull_ctl_enable_tbl;
>> +	pcr->ms_pull_ctl_disable_tbl = rtl8411_ms_pull_ctl_disable_tbl;
>> +}
>> diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
>> index 11e20af..93fabc7 100644
>> --- a/drivers/mfd/rtsx_pcr.c
>> +++ b/drivers/mfd/rtsx_pcr.c
>> @@ -56,6 +56,7 @@ static DEFINE_PCI_DEVICE_TABLE(rtsx_pci_ids) = {
>>   	{ PCI_DEVICE(0x10EC, 0x5289), PCI_CLASS_OTHERS << 16, 0xFF0000 },
>>   	{ PCI_DEVICE(0x10EC, 0x5227), PCI_CLASS_OTHERS << 16, 0xFF0000 },
>>   	{ PCI_DEVICE(0x10EC, 0x5249), PCI_CLASS_OTHERS << 16, 0xFF0000 },
>> +	{ PCI_DEVICE(0x10EC, 0x5286), PCI_CLASS_OTHERS << 16, 0xFF0000 },
>>   	{ PCI_DEVICE(0x10EC, 0x5287), PCI_CLASS_OTHERS << 16, 0xFF0000 },
>>   	{ 0, }
>>   };
>> @@ -1046,6 +1047,10 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
>>   		rts5229_init_params(pcr);
>>   		break;
>>   
>> +	case 0x5286:
>> +		rtl8402_init_params(pcr);
>> +		break;
>> +
>>   	case 0x5289:
>>   		rtl8411_init_params(pcr);
>>   		break;
>> diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
>> index 947e79b..8cac8db 100644
>> --- a/drivers/mfd/rtsx_pcr.h
>> +++ b/drivers/mfd/rtsx_pcr.h
>> @@ -29,6 +29,7 @@
>>   
>>   void rts5209_init_params(struct rtsx_pcr *pcr);
>>   void rts5229_init_params(struct rtsx_pcr *pcr);
>> +void rtl8402_init_params(struct rtsx_pcr *pcr);
>>   void rtl8411_init_params(struct rtsx_pcr *pcr);
>>   void rts5227_init_params(struct rtsx_pcr *pcr);
>>   void rts5249_init_params(struct rtsx_pcr *pcr);


-- 
Best Regards
Micky.

