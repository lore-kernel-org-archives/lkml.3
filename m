Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaIDKx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:53:58 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:62080 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbaIDKxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:53:47 -0400
MIME-Version: 1.0
In-Reply-To: <5407F364.9030303@samsung.com>
References: <1409752622-7564-1-git-send-email-sboyd@codeaurora.org>
	<5407F364.9030303@samsung.com>
Date: Thu, 4 Sep 2014 12:53:45 +0200
Message-ID: <CAPDyKFp0LwK=DABHaP-Ke=QZFP8bY5MO9RnYmUBqeEdDKp63BA@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-msm: Make tuning block table endian agnostic
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        Georgi Djakov <gdjakov@mm-sol.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 September 2014 07:06, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> Hi, Stephen.
>
> On 09/03/2014 10:57 PM, Stephen Boyd wrote:
>> If we're tuning on a big-endian CPU we'll never determine we properly
>> tuned the device because we compare the data we received from the
>> controller with a table that assumes the CPU is little-endian.
>> Change the table to be an array of bytes instead of 32-bit words
>> so we can use memcmp() without needing to byte-swap every word
>> depending on the endianess of the CPU.
>>
>> Cc: Asutosh Das <asutoshd@codeaurora.org>
>> Cc: Venkat Gopalakrishnan <venkatg@codeaurora.org>
>> Reviewed-by: Georgi Djakov <gdjakov@mm-sol.com>
>> Fixes: 415b5a75da43 "mmc: sdhci-msm: Add platform_execute_tuning implementation"
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  drivers/mmc/host/sdhci-msm.c | 42 +++++++++++++++++++++++++++---------------
>>  1 file changed, 27 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
>> index 40573a58486a..5aabffc15ae8 100644
>> --- a/drivers/mmc/host/sdhci-msm.c
>> +++ b/drivers/mmc/host/sdhci-msm.c
>> @@ -47,22 +47,34 @@
>>  #define CMUX_SHIFT_PHASE_SHIFT       24
>>  #define CMUX_SHIFT_PHASE_MASK        (7 << CMUX_SHIFT_PHASE_SHIFT)
>>
>> -static const u32 tuning_block_64[] = {
>> -     0x00ff0fff, 0xccc3ccff, 0xffcc3cc3, 0xeffefffe,
>> -     0xddffdfff, 0xfbfffbff, 0xff7fffbf, 0xefbdf777,
>> -     0xf0fff0ff, 0x3cccfc0f, 0xcfcc33cc, 0xeeffefff,
>> -     0xfdfffdff, 0xffbfffdf, 0xfff7ffbb, 0xde7b7ff7
>> +static const u8 tuning_block_64[] = {
>> +     0xff, 0x0f, 0xff, 0x00, 0xff, 0xcc, 0xc3, 0xcc,
>> +     0xc3, 0x3c, 0xcc, 0xff, 0xfe, 0xff, 0xfe, 0xef,
>> +     0xff, 0xdf, 0xff, 0xdd, 0xff, 0xfb, 0xff, 0xfb,
>> +     0xbf, 0xff, 0x7f, 0xff, 0x77, 0xf7, 0xbd, 0xef,
>> +     0xff, 0xf0, 0xff, 0xf0, 0x0f, 0xfc, 0xcc, 0x3c,
>> +     0xcc, 0x33, 0xcc, 0xcf, 0xff, 0xef, 0xff, 0xee,
>> +     0xff, 0xfd, 0xff, 0xfd, 0xdf, 0xff, 0xbf, 0xff,
>> +     0xbb, 0xff, 0xf7, 0xff, 0xf7, 0x7f, 0x7b, 0xde,
>>  };
>>
>> -static const u32 tuning_block_128[] = {
>> -     0xff00ffff, 0x0000ffff, 0xccccffff, 0xcccc33cc,
>> -     0xcc3333cc, 0xffffcccc, 0xffffeeff, 0xffeeeeff,
>> -     0xffddffff, 0xddddffff, 0xbbffffff, 0xbbffffff,
>> -     0xffffffbb, 0xffffff77, 0x77ff7777, 0xffeeddbb,
>> -     0x00ffffff, 0x00ffffff, 0xccffff00, 0xcc33cccc,
>> -     0x3333cccc, 0xffcccccc, 0xffeeffff, 0xeeeeffff,
>> -     0xddffffff, 0xddffffff, 0xffffffdd, 0xffffffbb,
>> -     0xffffbbbb, 0xffff77ff, 0xff7777ff, 0xeeddbb77
>> +static const u8 tuning_block_128[] = {
>> +     0xff, 0xff, 0x00, 0xff, 0xff, 0xff, 0x00, 0x00,
>> +     0xff, 0xff, 0xcc, 0xcc, 0xcc, 0x33, 0xcc, 0xcc,
>> +     0xcc, 0x33, 0x33, 0xcc, 0xcc, 0xcc, 0xff, 0xff,
>> +     0xff, 0xee, 0xff, 0xff, 0xff, 0xee, 0xee, 0xff,
>> +     0xff, 0xff, 0xdd, 0xff, 0xff, 0xff, 0xdd, 0xdd,
>> +     0xff, 0xff, 0xff, 0xbb, 0xff, 0xff, 0xff, 0xbb,
>> +     0xbb, 0xff, 0xff, 0xff, 0x77, 0xff, 0xff, 0xff,
>> +     0x77, 0x77, 0xff, 0x77, 0xbb, 0xdd, 0xee, 0xff,
>> +     0xff, 0xff, 0xff, 0x00, 0xff, 0xff, 0xff, 0x00,
>> +     0x00, 0xff, 0xff, 0xcc, 0xcc, 0xcc, 0x33, 0xcc,
>> +     0xcc, 0xcc, 0x33, 0x33, 0xcc, 0xcc, 0xcc, 0xff,
>> +     0xff, 0xff, 0xee, 0xff, 0xff, 0xff, 0xee, 0xee,
>> +     0xff, 0xff, 0xff, 0xdd, 0xff, 0xff, 0xff, 0xdd,
>> +     0xdd, 0xff, 0xff, 0xff, 0xbb, 0xff, 0xff, 0xff,
>> +     0xbb, 0xbb, 0xff, 0xff, 0xff, 0x77, 0xff, 0xff,
>> +     0xff, 0x77, 0x77, 0xff, 0x77, 0xbb, 0xdd, 0xee,
>>  };
> In dw-mmc.c, tuning_block values are same.
> So I think we can move these value into generic header. how about?

Actually, I believe these values comes from the eMMC specification?
Shouldn't they be moved to the mmc core instead?

Kind regards
Uffe

>
> Best Regards,
> Jaehoon Chung
>
>>
>>  struct sdhci_msm_host {
>> @@ -359,7 +371,7 @@ static int sdhci_msm_execute_tuning(struct sdhci_host *host, u32 opcode)
>>  {
>>       int tuning_seq_cnt = 3;
>>       u8 phase, *data_buf, tuned_phases[16], tuned_phase_cnt = 0;
>> -     const u32 *tuning_block_pattern = tuning_block_64;
>> +     const u8 *tuning_block_pattern = tuning_block_64;
>>       int size = sizeof(tuning_block_64);     /* Pattern size in bytes */
>>       int rc;
>>       struct mmc_host *mmc = host->mmc;
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
