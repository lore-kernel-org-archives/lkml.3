Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaILOe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:34:26 -0400
Received: from mail.neotion.com ([5.39.84.84]:38173 "EHLO mail.neotion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbaILOeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:34:22 -0400
Message-ID: <541303B2.7050802@neotion.com>
Date: Fri, 12 Sep 2014 16:31:14 +0200
From: =?UTF-8?B?R3LDqWdvcnkgU291dGFkw6k=?= <gsoutade@neotion.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 0000/0003] mmc: EXT_CSD_PARTITION_SETTING_COMPLETED bit
 not checked
References: <53C7E45E.2060102@neotion.com>	<CAPDyKFoRpQBHGGCMPvEKdeVGjTO-rnyYVostLZGCV3dudD1rmA@mail.gmail.com>	<53EB2DC3.2080002@neotion.com>	<CAPDyKFpjYqVUZ8GHB76gD8pOx_eMg9ecvbWrMEfbhEd5ffk7mw@mail.gmail.com>	<53ECB95F.2030207@neotion.com> <CAPDyKFp2ekmucHVzMWxeKfyTmuFKTXAYwUEpL5QxvEh8AjFopg@mail.gmail.com> <53F1FBA3.6060108@neotion.com> <5411435C.3080905@neotion.com>
In-Reply-To: <5411435C.3080905@neotion.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JEDEC standard requires that EXT_CSD_PARTITION_SETTING_COMPLETED bit
must be set in order to take in account enhanced area and general purpose
partitions (gp) values.

Current code doesn't checks this bit and blindly trust enhanced area and
gp values. Moreover, "enhanced_area_en" attribute was set according to gp values
but not necessary enhanced area one. It's then used to switch
EXT_CSD_ERASE_GROUP_DEF bit which requires EXT_CSD_PARTITION_SETTING_COMPLETED.
This attribute has been replaced by "partition_setting_completed" that
match the expected behavior.

User is now warned in case of misconfiguration.

Plus, some code has been moved into functions for two reasons :
* functional reason (one behavior per function)
* Deep indentation result

Grégory Soutadé (3):
  mmc: Move code that manages user area and gp partitions into functions
  mmc: Replace "enhanced_area_en" attribute by "partition_setting_completed"
  mmc: Checks EXT_CSD_PARTITION_SETTING_COMPLETED before partitions computation

 drivers/mmc/core/mmc.c   |  171 +++++++++++++++++++++++++++-------------------
 include/linux/mmc/card.h |    2 +-
 include/linux/mmc/mmc.h  |    2 +
 3 files changed, 102 insertions(+), 73 deletions(-)

>From commit 480cadc2b7e0fa2bbab20141efb547dfe0c3707c in master linux tree.

Changelog v4:
	Second patch in v3 doesn't compile
Changelog v3:
	Move code BEFORE fixing bugs.
Changelog v2:
	Move code for user area and general purpose partitions
	into functions.
-- 
1.7.9.5

> Replace ext_csd "enhanced_area_en" attribute by "partition_setting_completed".
>> It was used whether or not enhanced user area is defined and without checks of
>> EXT_CSD_PARTITION_SETTING_COMPLETED bit.
>> 
>> Signed-off-by: Grégory Soutadé <gsoutade@neotion.com>
>> ---
>>  drivers/mmc/core/mmc.c   |    8 +++++++-
>>  include/linux/mmc/card.h |    2 +-
>>  include/linux/mmc/mmc.h  |    2 ++
>>  3 files changed, 10 insertions(+), 2 deletions(-)
>> 
>>>From commit 33caee39925b887a99a2400dc5c980097c3573f9 in master linux tree.
>> 
>> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
>> index 793c6f7..ef25d91 100644
>> --- a/drivers/mmc/core/mmc.c
>> +++ b/drivers/mmc/core/mmc.c
>> @@ -403,6 +403,12 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
>>  		ext_csd[EXT_CSD_TRIM_MULT];
>>  	card->ext_csd.raw_partition_support = ext_csd[EXT_CSD_PARTITION_SUPPORT];
>>  	if (card->ext_csd.rev >= 4) {
>> +		if (ext_csd[EXT_CSD_PARTITION_SETTING_COMPLETED] &
>> +		    EXT_CSD_PART_SETTING_COMPLETED) {
>> +			card->ext_csd.partition_setting_completed = 1;
>> +		} else {
>> +			card->ext_csd.partition_setting_completed = 0;
>> +		}
>>  		/*
>>  		 * Enhanced area feature support -- check whether the eMMC
>>  		 * card has the Enhanced area enabled.  If so, export enhanced
>> @@ -1309,7 +1315,7 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>>  	 * If enhanced_area_en is TRUE, host needs to enable ERASE_GRP_DEF
>>  	 * bit.  This bit will be lost every time after a reset or power off.
>>  	 */
>> -	if (card->ext_csd.enhanced_area_en ||
>> +	if (card->ext_csd.partition_setting_completed ||
>>  	    (card->ext_csd.rev >= 3 && (host->caps2 & MMC_CAP2_HC_ERASE_SZ))) {
>>  		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>>  				 EXT_CSD_ERASE_GROUP_DEF, 1,
>> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
>> index d424b9d..38175be 100644
>> --- a/include/linux/mmc/card.h
>> +++ b/include/linux/mmc/card.h
>> @@ -74,7 +74,7 @@ struct mmc_ext_csd {
>>  	unsigned int		sec_trim_mult;	/* Secure trim multiplier  */
>>  	unsigned int		sec_erase_mult;	/* Secure erase multiplier */
>>  	unsigned int		trim_timeout;		/* In milliseconds */
>> -	bool			enhanced_area_en;	/* enable bit */
>> +	bool			partition_setting_completed;	/* enable bit */
>>  	unsigned long long	enhanced_area_offset;	/* Units: Byte */
>>  	unsigned int		enhanced_area_size;	/* Units: KB */
>>  	unsigned int		cache_size;		/* Units: KB */
>> diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
>> index 64ec963..78753bc 100644
>> --- a/include/linux/mmc/mmc.h
>> +++ b/include/linux/mmc/mmc.h
>> @@ -281,6 +281,7 @@ struct _mmc_csd {
>>  #define EXT_CSD_EXP_EVENTS_CTRL		56	/* R/W, 2 bytes */
>>  #define EXT_CSD_DATA_SECTOR_SIZE	61	/* R */
>>  #define EXT_CSD_GP_SIZE_MULT		143	/* R/W */
>> +#define EXT_CSD_PARTITION_SETTING_COMPLETED 155	/* R/W */
>>  #define EXT_CSD_PARTITION_ATTRIBUTE	156	/* R/W */
>>  #define EXT_CSD_PARTITION_SUPPORT	160	/* RO */
>>  #define EXT_CSD_HPI_MGMT		161	/* R/W */
>> @@ -349,6 +350,7 @@ struct _mmc_csd {
>>  #define EXT_CSD_PART_CONFIG_ACC_RPMB	(0x3)
>>  #define EXT_CSD_PART_CONFIG_ACC_GP0	(0x4)
>> 
>> +#define EXT_CSD_PART_SETTING_COMPLETED	(0x1)
>>  #define EXT_CSD_PART_SUPPORT_PART_EN	(0x1)
>> 
>>  #define EXT_CSD_CMD_SET_NORMAL		(1<<0)
>> --
>> 1.7.9.5
>> 
>> Le 15/08/2014 10:17, Ulf Hansson a écrit :
>> >> On 14 August 2014 15:27, Grégory Soutadé <gsoutade@neotion.com> wrote:
>>> >>> Le 14/08/2014 13:46, Ulf Hansson a écrit :
>>>> >>>> On 13 August 2014 11:20, Grégory Soutadé <gsoutade@neotion.com> wrote:
>>>>> >>>>> Le 13/08/2014 10:36, Ulf Hansson a écrit :
>>>>>> >>>>>> On 17 July 2014 16:57, Grégory Soutadé <gsoutade@neotion.com> wrote:
>>>>>>> >>>>>>> Create MMC general purpose partitions only if
>>>>>>> >>>>>>> EXT_CSD_PARTITION_SETTING_COMPLETED bit is set.
>>>>>>> >>>>>>> Some tools may set general purpose partition size(s) but fail or stop
>>>>>>> >>>>>>> without finalize.
>>>>>>> >>>>>>> Another case is to set invalid partition size(s).
>>>>>>> >>>>>>>
>>>>>>> >>>>>>> Signed-off-by: Grégory Soutadé <gsoutade@neotion.com>
>>>>>>> >>>>>>> ---
>>>>>>> >>>>>>>  drivers/mmc/core/mmc.c  |   15 +++++++++++----
>>>>>>> >>>>>>>  include/linux/mmc/mmc.h |    2 ++
>>>>>>> >>>>>>>  2 files changed, 13 insertions(+), 4 deletions(-)
>>>>>>> >>>>>>>
>>>>>>> >>>>>>> From commit b6603fe574af289dbe9eb9fb4c540bca04f5a053 in master linux tree.
>>>>>>> >>>>>>>
>>>>>>> >>>>>>> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
>>>>>>> >>>>>>> index 793c6f7..b9fe211 100644
>>>>>>> >>>>>>> --- a/drivers/mmc/core/mmc.c
>>>>>>> >>>>>>> +++ b/drivers/mmc/core/mmc.c
>>>>>>> >>>>>>> @@ -471,10 +471,17 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
>>>>>>> >>>>>>>                                 ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3];
>>>>>>> >>>>>>>                                 part_size *= (size_t)(hc_erase_grp_sz *
>>>>>>> >>>>>>>                                         hc_wp_grp_sz);
>>>>>>> >>>>>>> -                               mmc_part_add(card, part_size << 19,
>>>>>>> >>>>>>> -                                       EXT_CSD_PART_CONFIG_ACC_GP0 + idx,
>>>>>>> >>>>>>> -                                       "gp%d", idx, false,
>>>>>>> >>>>>>> -                                       MMC_BLK_DATA_AREA_GP);
>>>>>>> >>>>>>> +                               if (ext_csd[EXT_CSD_PARTITION_SETTING_COMPLETED] &
>>>>>>> >>>>>>> +                               EXT_CSD_PART_SETTING_COMPLETED) {
>>>>>> >>>>>>
>>>>>> >>>>>> Some minor comments here.
>>>>>> >>>>>>
>>>>>> >>>>>> I think you could move this if statement up and into the previous "if"
>>>>>> >>>>>> where we check for "ext_csd[EXT_CSD_PARTITION_SUPPORT] &
>>>>>> >>>>>> EXT_CSD_PART_SUPPORT_PART_EN".
>>>>>> >>>>>>
>>>>>> >>>>>> Additionally, please run checkpatch.
>>>>>> >>>>>>
>>>>>> >>>>>> Kind regards
>>>>>> >>>>>> Uffe
>>>>> >>>>>
>>>>> >>>>> Hello,
>>>>> >>>>>
>>>>> >>>>> I didn't put the if statement above to warn user in case of bad partitioning.
>>>>> >>>>> I don't want the kernel to silently ignore this error.
>>>> >>>>
>>>> >>>> Fair enough.
>>>> >>>>
>>>> >>>> Still I am wondering whether hc_erase_grp_sz, hc_wp_grp_sz and
>>>> >>>> enhanced_area_en should be updated if
>>>> >>>> EXT_CSD_PARTITION_SETTING_COMPLETED isn't set.  That's the case in
>>>> >>>> your patch.
>>> >>>
>>> >>> I was focused on partitions and I didn't pay attention on enhanced area.
>>> >>>
>>> >>> JEDEC says that partitioning implies :
>>> >>> * Configure general purpose partitions attributes and sizes
>>> >>> * Configure enhanced user area offset, attributes and size
>>> >>>
>>> >>> and finally set EXT_CSD_PARTITION_SETTING_COMPLETED.
>>> >>>
>>> >>> Thus these two parts must checks for setting completed before
>>> >>> computing values.
>>> >>>
>>> >>> Plus, "enhanced_area_en" attribute is set whether or not there is an
>>> >>> enhanced area defined. I looked at the code, and the only usage of it
>>> >>> is to set EXT_CSD_ERASE_GROUP_DEF and compute erase size again.
>>> >>> I suggest using "partition_setting_completed" identifier which is common
>>> >>> to the two functions and requires EXT_CSD_ERASE_GROUP_DEF to be set.
>>> >>>
>>> >>> If you're ok with that, I'll submit another patch.
>> >>
>> >> Seems reasonable. Please send a v2.
>> >>
>> >> Kind regards
>> >> Uffe
>> >>
>>> >>>
>>> >>>
>>> >>> Best regards
>>> >>> Grégory Soutadé
>>> >>>
>>>> >>>>
>>>>> >>>>>
>>>>> >>>>> checkpatch has been run before sending this patch, I know there are two lines
>>>>> >>>>> with two extra characters, but names used here are quite long. I hope it will
>>>>> >>>>> not block upstream inclusion.
>>>> >>>>
>>>> >>>> The mmc_read_ext_csd() is not one of the nicest piece of code, but for
>>>> >>>> sure we should not move on making it worse. If you need to move code
>>>> >>>> into separate function to prevent checkpatch warnings, please do so.
>>>> >>>>
>>>> >>>> Kind regards
>>>> >>>> Uffe
>>>> >>>>
>>> >>>
>> >>
