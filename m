Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaHNLqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 07:46:37 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:50188 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbaHNLqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 07:46:35 -0400
MIME-Version: 1.0
In-Reply-To: <53EB2DC3.2080002@neotion.com>
References: <53C7E45E.2060102@neotion.com>
	<CAPDyKFoRpQBHGGCMPvEKdeVGjTO-rnyYVostLZGCV3dudD1rmA@mail.gmail.com>
	<53EB2DC3.2080002@neotion.com>
Date: Thu, 14 Aug 2014 13:46:34 +0200
Message-ID: <CAPDyKFpjYqVUZ8GHB76gD8pOx_eMg9ecvbWrMEfbhEd5ffk7mw@mail.gmail.com>
Subject: Re: [PATCH] mmc: check EXT_CSD_PARTITION_SETTING_COMPLETED before
 creating partitions
From: Ulf Hansson <ulf.hansson@linaro.org>
To: =?UTF-8?B?R3LDqWdvcnkgU291dGFkw6k=?= <gsoutade@neotion.com>
Cc: Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 August 2014 11:20, Grégory Soutadé <gsoutade@neotion.com> wrote:
> Le 13/08/2014 10:36, Ulf Hansson a écrit :
>> On 17 July 2014 16:57, Grégory Soutadé <gsoutade@neotion.com> wrote:
>>> Create MMC general purpose partitions only if
>>> EXT_CSD_PARTITION_SETTING_COMPLETED bit is set.
>>> Some tools may set general purpose partition size(s) but fail or stop
>>> without finalize.
>>> Another case is to set invalid partition size(s).
>>>
>>> Signed-off-by: Grégory Soutadé <gsoutade@neotion.com>
>>> ---
>>>  drivers/mmc/core/mmc.c  |   15 +++++++++++----
>>>  include/linux/mmc/mmc.h |    2 ++
>>>  2 files changed, 13 insertions(+), 4 deletions(-)
>>>
>>> From commit b6603fe574af289dbe9eb9fb4c540bca04f5a053 in master linux tree.
>>>
>>> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
>>> index 793c6f7..b9fe211 100644
>>> --- a/drivers/mmc/core/mmc.c
>>> +++ b/drivers/mmc/core/mmc.c
>>> @@ -471,10 +471,17 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
>>>                                 ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3];
>>>                                 part_size *= (size_t)(hc_erase_grp_sz *
>>>                                         hc_wp_grp_sz);
>>> -                               mmc_part_add(card, part_size << 19,
>>> -                                       EXT_CSD_PART_CONFIG_ACC_GP0 + idx,
>>> -                                       "gp%d", idx, false,
>>> -                                       MMC_BLK_DATA_AREA_GP);
>>> +                               if (ext_csd[EXT_CSD_PARTITION_SETTING_COMPLETED] &
>>> +                               EXT_CSD_PART_SETTING_COMPLETED) {
>>
>> Some minor comments here.
>>
>> I think you could move this if statement up and into the previous "if"
>> where we check for "ext_csd[EXT_CSD_PARTITION_SUPPORT] &
>> EXT_CSD_PART_SUPPORT_PART_EN".
>>
>> Additionally, please run checkpatch.
>>
>> Kind regards
>> Uffe
>
> Hello,
>
> I didn't put the if statement above to warn user in case of bad partitioning.
> I don't want the kernel to silently ignore this error.

Fair enough.

Still I am wondering whether hc_erase_grp_sz, hc_wp_grp_sz and
enhanced_area_en should be updated if
EXT_CSD_PARTITION_SETTING_COMPLETED isn't set.  That's the case in
your patch.

>
> checkpatch has been run before sending this patch, I know there are two lines
> with two extra characters, but names used here are quite long. I hope it will
> not block upstream inclusion.

The mmc_read_ext_csd() is not one of the nicest piece of code, but for
sure we should not move on making it worse. If you need to move code
into separate function to prevent checkpatch warnings, please do so.

Kind regards
Uffe
