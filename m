Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab3FJWqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:46:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41416 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3FJWqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:46:33 -0400
Message-ID: <51B65747.9030006@codeaurora.org>
Date: Mon, 10 Jun 2013 15:46:31 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCHv4 3/3] gpio: msm: Add device tree and irqdomain support
 for gpio-msm-v2
References: <1370046121-7835-1-git-send-email-rvaswani@codeaurora.org> <1370046121-7835-4-git-send-email-rvaswani@codeaurora.org> <CACxGe6tD253nb-5sOSBQu0Kj1JwYOeas2-WpR2isFO+Q+8ty2A@mail.gmail.com> <51AC0005.2020700@codeaurora.org> <20130605213813.2D9703E10E4@localhost>
In-Reply-To: <20130605213813.2D9703E10E4@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/2013 2:38 PM, Grant Likely wrote:
> On Sun, 02 Jun 2013 19:31:33 -0700, Rohit Vaswani <rvaswani@codeaurora.org> wrote:
>> On 6/1/2013 1:09 AM, Grant Likely wrote:
>>> On Sat, Jun 1, 2013 at 1:22 AM, Rohit Vaswani <rvaswani@codeaurora.org> wrote:
>>>> This cleans up the gpio-msm-v2 driver of all the global define usage.
>>>> The number of gpios are now defined in the device tree. This enables
>>>> adding irqdomain support as well.
>>>>
>>>> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
>>>> @@ -101,11 +96,27 @@ enum {
>>>>     */
>>>>    struct msm_gpio_dev {
>>>>           struct gpio_chip gpio_chip;
>>>> -       DECLARE_BITMAP(enabled_irqs, NR_GPIO_IRQS);
>>>> -       DECLARE_BITMAP(wake_irqs, NR_GPIO_IRQS);
>>>> -       DECLARE_BITMAP(dual_edge_irqs, NR_GPIO_IRQS);
>>>> +       unsigned long *enabled_irqs;
>>>> +       unsigned long *wake_irqs;
>>>> +       unsigned long *dual_edge_irqs;
>>> Was there a reason you ignored the comment to leave these bitmaps as
>>> statically allocated?
>>>
>>> [...]
>>>
>>>> +       msm_gpio.enabled_irqs = devm_kzalloc(&pdev->dev,
>>>> +                                               sizeof(unsigned long) *
>>>> +                                               BITS_TO_LONGS(ngpio) * 3,
>>>> +                                               GFP_KERNEL);
>>>> +       msm_gpio.wake_irqs = &msm_gpio.enabled_irqs[BITS_TO_LONGS(ngpio)];
>>>> +       msm_gpio.dual_edge_irqs =
>>>> +                       &msm_gpio.enabled_irqs[BITS_TO_LONGS(ngpio * 2)];
>>> I should have just deleted my comment about doing it this way. I was
>>> making the point that one allocation is better that three; but then I
>>> also said that it was better to not allocate at all. Go back to the
>>> statically allocated bitmap array. It is far better than this.
>>>
>>> g.
>> I agree that DECLARE_BITMAP is the most efficient way, but
>> DECLARE_BITMAP takes a statically defined number of gpios as an
>> argument. Since we get the ngpio from device tree, these had to go as
>> well. Under this scheme, 1 allocation was better than 3 and went ahead
>> with your suggestion.
> Think about it for a moment; You *know* all the devices that are going
> to use the driver. The largest size for ngpios that I see is 173 which
> is a mere 18 long words for 3 bitmaps. Even if you were to quadruple
> that amount the total for all the bitmasks is 72 long words. You're
> optimizing at the wrong place. Changing it to dynamic allocation makes
> the code slower, more complicated, and probably doesn't do anything to
> save on real memory consumption.
>
> The solution is simple; choose a maximum value of ngpios that the driver
> will likely need to work support. If a device appears with more GPIOs,
> then the driver should throw a warning and work with the maximum it can
> support. Part of enablement for the new device will be increasing the
> driver to handle more gpios.
>
> g.

Got it.

Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

