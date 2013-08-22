Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3HVDlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 23:41:05 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41237 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab3HVDlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 23:41:03 -0400
MIME-Version: 1.0
X-Originating-IP: [218.164.101.24]
In-Reply-To: <CACRpkdauvk4Gw_k6TaYSH32nA66M_MHHksx6ESrqYx1PetWdug@mail.gmail.com>
References: <1376877989.10251.2.camel@phoenix>
	<1376878066.10251.4.camel@phoenix>
	<CACRpkdauvk4Gw_k6TaYSH32nA66M_MHHksx6ESrqYx1PetWdug@mail.gmail.com>
Date: Thu, 22 Aug 2013 11:41:02 +0800
Message-ID: <CAFRkauCc4jnsEhdX_MrS39xO4Nuh6m7eaaMPzYCf2OyZstNaOQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: core: Add proper mutex lock in pinctrl_request_gpio
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Patrice Chotard <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/22 Linus Walleij <linus.walleij@linaro.org>:
> On Mon, Aug 19, 2013 at 4:07 AM, Axel Lin <axel.lin@ingics.com> wrote:
>
>> This one is missed in commit 42fed7ba "pinctrl: move subsystem mutex to
>> pinctrl_dev struct".
>
> I think this was never there.

I think it was protected by the global pinctrl_mutex in v3.9, you can check the
source code here:
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/drivers/pinctrl/core.c?id=refs/tags/v3.9.11

However, commit 42fed7ba44 "pinctrl: move subsystem mutex to
pinctrl_dev struct" then
adds mutex_lock(&pinctrldev_list_mutex); but forgot to add
mutex_lock(&pctldev->mutex);
here although it adds mutex_lock(&pctldev->mutex) in pinctrl_free_gpio().
The mutex_lock(&pinctrldev_list_mutex) is then moved into
pinctrl_get_device_gpio_range()
and pinctrl_ready_for_gpio_range() by commit 44d5f7b "pinctrl: sink
pinctrldev_list_mutex".

>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>> ---
>>  drivers/pinctrl/core.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
>> index 53c40d9..92f86ab 100644
>> --- a/drivers/pinctrl/core.c
>> +++ b/drivers/pinctrl/core.c
>> @@ -562,11 +562,15 @@ int pinctrl_request_gpio(unsigned gpio)
>>                 return ret;
>>         }
>>
>> +       mutex_lock(&pctldev->mutex);
>> +
>>         /* Convert to the pin controllers number space */
>>         pin = gpio_to_pin(range, gpio);
>>
>>         ret = pinmux_request_gpio(pctldev, range, pin, gpio);
>>
>> +       mutex_unlock(&pctldev->mutex);
>> +
>>         return ret;
>
> What is this protecting against?
>
> I'm not sure I follow this so better ask.

I think this fixes the race between pin_free() and pin_request() calls.
(Well, I don't have a h/w to test at this moment.)
It protects accessing the members of pctldev->desc.
(e.g. update desc->mux_usecount, desc->gpio_owner, desc->mux_owner, etc)
Current code grabs pctldev->mutex before calling pinmux_free_gpio(),
but did not grab the mutex while calling pinmux_request_gpio().

Regards,
Axel
