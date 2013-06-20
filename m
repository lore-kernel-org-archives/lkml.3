Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965234Ab3FTL0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:26:52 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:63954 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965123Ab3FTL0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:26:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130620090042.GC20594@balto.lan>
References: <1371713084-19098-1-git-send-email-patrice.chotard.st@gmail.com>
	<1371713084-19098-3-git-send-email-patrice.chotard.st@gmail.com>
	<20130620090042.GC20594@balto.lan>
Date: Thu, 20 Jun 2013 13:26:49 +0200
Message-ID: <CAHK0JfiMd2tyEZdkacE9ns1vamXurxn0mhx49FWFRvo2KSeFiQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: abx500: fix abx500_gpio_get()
From: Patrice Chotard <patrice.chotard.st@gmail.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 11:00 AM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:
> Hi Patrice,
>
> On Thu, Jun 20, 2013 at 09:24:44AM +0200, patrice.chotard.st@gmail.com wrote:
>> From: Patrice Chotard <patrice.chotard@st.com>
>>
>> _ allow to get output GPIO value.
>> _ as there is no GPIO0 on ABX500, use correct offset with
>>   abx500_gpio_get_bit().
>>
>> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
>> ---
>>  drivers/pinctrl/pinctrl-abx500.c |   16 ++++++++++++++--
>>  1 file changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
>> index 4307b0f..070442d 100644
>> --- a/drivers/pinctrl/pinctrl-abx500.c
>> +++ b/drivers/pinctrl/pinctrl-abx500.c
>> @@ -162,10 +162,22 @@ static int abx500_gpio_get(struct gpio_chip *chip, unsigned offset)
>>  {
>>       struct abx500_pinctrl *pct = to_abx500_pinctrl(chip);
>>       bool bit;
>> +     bool is_out;
>> +     u8 gpio_offset = offset - 1;
>>       int ret;
>>
>> -     ret = abx500_gpio_get_bit(chip, AB8500_GPIO_IN1_REG,
>> -                               offset, &bit);
>> +     ret = abx500_gpio_get_bit(chip, AB8500_GPIO_DIR1_REG, gpio_offset, &is_out);
>> +     if (ret < 0) {
>> +             dev_err(pct->dev, "%s failed\n", __func__);
>> +             return ret;
>> +     }
>> +
>> +     if (is_out)
>> +             ret = abx500_gpio_get_bit(chip, AB8500_GPIO_OUT1_REG,
>> +                             gpio_offset, &bit);
>> +     else
>> +             ret = abx500_gpio_get_bit(chip, AB8500_GPIO_IN1_REG,
>> +                             gpio_offset, &bit);
>
> Why would you want to read the pin state from the output register?  The
> input one should be the one that reflect the real electrical value of
> the pin, and I think it may be useful to detect some fault condition
> too...  Is there a specific reasion to use the output register instead?
>
Hi Fabio

I want to read the pin state from the output register for debugfs print out.
In abx500_gpio_dbg_show_one(), chip->get() is used to retrieve the output
pin's level.

Patrice

> Thanks,
> Fabio
>
>>       if (ret < 0) {
>>               dev_err(pct->dev, "%s failed\n", __func__);
>>               return ret;
>> --
>> 1.7.10
>>
>
> --
> Fabio Baltieri
