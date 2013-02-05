Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab3BERSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:18:45 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54126 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3BERSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:18:41 -0500
MIME-Version: 1.0
In-Reply-To: <20130205142446.1998e92d@infradead.org>
References: <1357127630-8167-1-git-send-email-prabhakar.lad@ti.com>
 <1357127630-8167-2-git-send-email-prabhakar.lad@ti.com> <20130205142446.1998e92d@infradead.org>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 5 Feb 2013 22:48:13 +0530
Message-ID: <CA+V-a8v3_+sg579F6FG3BkuJzzdZVKGWWSK76X4-6rdn0jYpeg@mail.gmail.com>
Subject: Re: [PATCH] davinci: dm644x: fix enum ccdc_gama_width and enum
 ccdc_data_size comparision warning
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Tue, Feb 5, 2013 at 9:54 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Em Wed,  2 Jan 2013 17:23:50 +0530
> "Lad, Prabhakar" <prabhakar.csengg@gmail.com> escreveu:
>
>> while the effect is harmless this patch
>
> I disagree that this is a harmless warning. It is here for a reason:
> you should not be relying on the enum "magic" value, since the main
> reason to use an enum is to fill/compare the enum fields only by their
> names, and not by their number.
>
OK

>> fixes following build warning,
>>
>> drivers/media/platform/davinci/dm644x_ccdc.c: In function ‘validate_ccdc_param’:
>> drivers/media/platform/davinci/dm644x_ccdc.c:233:32: warning: comparison between
>> ‘enum ccdc_gama_width’ and ‘enum ccdc_data_size’ [-Wenum-compare]
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> ---
>>  drivers/media/platform/davinci/dm644x_ccdc.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
>> index ee7942b..42b473a 100644
>> --- a/drivers/media/platform/davinci/dm644x_ccdc.c
>> +++ b/drivers/media/platform/davinci/dm644x_ccdc.c
>> @@ -228,9 +228,12 @@ static void ccdc_readregs(void)
>>  static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
>>  {
>>       if (ccdcparam->alaw.enable) {
>> +             u32 gama_wd = ccdcparam->alaw.gama_wd;
>> +             u32 data_sz = ccdcparam->data_sz;
>> +
>>               if ((ccdcparam->alaw.gama_wd > CCDC_GAMMA_BITS_09_0) ||
>>                   (ccdcparam->alaw.gama_wd < CCDC_GAMMA_BITS_15_6) ||
>> -                 (ccdcparam->alaw.gama_wd < ccdcparam->data_sz)) {
>> +                 (gama_wd < data_sz)) {
>
> hmm... from include/media/davinci/dm644x_ccdc.h:
> enum ccdc_gama_width {
>         CCDC_GAMMA_BITS_15_6,   // 0
>         CCDC_GAMMA_BITS_14_5,   // 1
>         CCDC_GAMMA_BITS_13_4,   // 2
>         CCDC_GAMMA_BITS_12_3,   // 3
>         CCDC_GAMMA_BITS_11_2,   // 4
>         CCDC_GAMMA_BITS_10_1,   // 5
>         CCDC_GAMMA_BITS_09_0    // 6
> };
>
> enum ccdc_data_size {
>         CCDC_DATA_16BITS,       // 0
>         CCDC_DATA_15BITS,       // 1
>         CCDC_DATA_14BITS,       // 2
>         CCDC_DATA_13BITS,       // 3
>         CCDC_DATA_12BITS,       // 4
>         CCDC_DATA_11BITS,       // 5
>         CCDC_DATA_10BITS,       // 6
>         CCDC_DATA_8BITS         // 7
> };
>
> That doesn't seem right, as comparing the enum integer value won't
> warrant that the number of bits of gamma. For example, gamma == 6
> means 9 bits, while ccdc == 6 means 10 bits.
>
> In any case, the code is just crappy, as one could anytime add more
> values at the enum or reorder.
>
yes

> So, a better fix would be to have an array that would convert from the
> enum "magic" number into the number of bits.
>
> Hmm... wait a moment: why are you using an enum here at the first place???
>
> It seems that it would be a way better to just use 2 unsigned integers:
> ccdc_data_num_bits and ccdc_gama_num_bits, and just fill it with the
> number of bits, instead of declaring an enum for it.
>
I will pick this option :)


Regards,
--Prabhakar

> Another alternative would be to merge them into just one enum, like:
>
> enum ccdc_bits {
>         CCDC_8_BITS = 8,
>         CCDC_9_BITS = 9,
>         CCDC_10_BITS = 10,
>         CCDC_11_BITS = 11,
>         CCDC_12_BITS = 12,
>         CCDC_13_BITS = 13,
>         CCDC_14_BITS = 14,
>         CCDC_15_BITS = 15,
>         CCDC_16_BITS = 16,
> };
>
> and replace all occurrences of ccdc_data_size and ccdc_gama_width by
> the new enum.
>
> This way, you could trust on compare one field with the other.
>
>>                       dev_dbg(ccdc_cfg.dev, "\nInvalid data line select");
>>                       return -1;
>>               }
>
> Regards,
> Mauro
