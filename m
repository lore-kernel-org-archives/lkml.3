Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab3CKLKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:10:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34704 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab3CKLKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:10:34 -0400
Message-ID: <513DBBA1.3090606@ti.com>
Date: Mon, 11 Mar 2013 16:40:25 +0530
From: Lokesh Vutla <lokeshvutla@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vitaly Chernooky <vitaly.chernooky@ti.com>,
        Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
Subject: Re: [PATCH 7/8] memory: emif: errata i743: Prohibit usage of Power-Down
 mode
References: <1362978365-5593-1-git-send-email-lokeshvutla@ti.com> <1362978365-5593-8-git-send-email-lokeshvutla@ti.com> <513D708D.1000501@ti.com>
In-Reply-To: <513D708D.1000501@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Monday 11 March 2013 11:20 AM, Santosh Shilimkar wrote:
> On Monday 11 March 2013 10:36 AM, Lokesh Vutla wrote:
>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>
>> ERRATA DESCRIPTION :
>> The EMIF supports power-down state for low power. The EMIF
>> automatically puts the SDRAM into power-down after the memory is
>> not accessed for a defined number of cycles and the
>> EMIF_PWR_MGMT_CTRL[10:8] REG_LP_MODE bit field is set to 0x4.
>> As the EMIF supports automatic output impedance calibration, a ZQ
>> calibration long command is issued every time it exits active
>> power-down and precharge power-down modes. The EMIF waits and
>> blocks any other command during this calibration.
>> The EMIF does not allow selective disabling of ZQ calibration upon
>> exit of power-down mode. Due to very short periods of power-down
>> cycles, ZQ calibration overhead creates bandwidth issues and
>> increases overall system power consumption. On the other hand,
>> issuing ZQ calibration long commands when exiting self-refresh is
>> still required.
>>
>> WORKAROUND :
>> Because there is no power consumption benefit of the power-down due
>> to the calibration and there is a performance risk, the guideline
>> is to not allow power-down state and, therefore, to not have set
>> the EMIF_PWR_MGMT_CTRL[10:8] REG_LP_MODE bit field to 0x4.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> Signed-off-by: Vitaly Chernooky <vitaly.chernooky@ti.com>
>> Signed-off-by: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
>> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
>> ---
> Nice changelog.
>
>>   drivers/memory/emif.c |   35 +++++++++++++++++++++++++++++++++++
>>   1 file changed, 35 insertions(+)
>>
>> diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
>> index f75806a..119503a 100644
>> --- a/drivers/memory/emif.c
>> +++ b/drivers/memory/emif.c
>> @@ -257,6 +257,41 @@ static void set_lpmode(struct emif_data *emif, u8 lpmode)
>>   	u32 temp;
>>   	void __iomem *base = emif->base;
>>
>> +	/*
>> +	 * Workaround for errata i743 - LPDDR2 Power-Down State is Not
>> +	 * Efficient
>> +	 *
>> +	 * i743 DESCRIPTION:
>> +	 * The EMIF supports power-down state for low power. The EMIF
>> +	 * automatically puts the SDRAM into power-down after the memory is
>> +	 * not accessed for a defined number of cycles and the
>> +	 * EMIF_PWR_MGMT_CTRL[10:8] REG_LP_MODE bit field is set to 0x4.
>> +	 * As the EMIF supports automatic output impedance calibration, a ZQ
>> +	 * calibration long command is issued every time it exits active
>> +	 * power-down and precharge power-down modes. The EMIF waits and
>> +	 * blocks any other command during this calibration.
>> +	 * The EMIF does not allow selective disabling of ZQ calibration upon
>> +	 * exit of power-down mode. Due to very short periods of power-down
>> +	 * cycles, ZQ calibration overhead creates bandwidth issues and
>> +	 * increases overall system power consumption. On the other hand,
>> +	 * issuing ZQ calibration long commands when exiting self-refresh is
>> +	 * still required.
>> +	 *
>> +	 * WORKAROUND
>> +	 * Because there is no power consumption benefit of the power-down due
>> +	 * to the calibration and there is a performance risk, the guideline
>> +	 * is to not allow power-down state and, therefore, to not have set
>> +	 * the EMIF_PWR_MGMT_CTRL[10:8] REG_LP_MODE bit field to 0x4.
>> +	 */
>> +	if ((emif->plat_data->ip_rev == EMIF_4D) &&
>> +	    (EMIF_LP_MODE_PWR_DN == lpmode)) {
> Ok. So the errata is limited to only 'EMIF_4D' version and not applicable
> for next EMIF version used in OMAP5 devices, right ? If yes, would be good
> to just mention that in already good changelog.
Yes, it is not applicable for EMIF_4D5 used in OMAP5 ES2.0 Soc's.
Ill update this in change log.

Thanks
Lokesh
>
>> +		WARN_ONCE(1,
>> +			  "REG_LP_MODE = LP_MODE_PWR_DN(4) is prohibited by"
>> +			  "erratum i743 switch to LP_MODE_SELF_REFRESH(2)\n");
>> +		/* rallback LP_MODE to Self-refresh mode */
> s/rallback/rollback ?
>
> With above updates,
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>

