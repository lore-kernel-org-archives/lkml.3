Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab3FCJxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:53:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:6349 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab3FCJw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:52:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,791,1363158000"; 
   d="scan'208";a="347208254"
Message-ID: <51AC683C.9010909@linux.intel.com>
Date: Mon, 03 Jun 2013 12:56:12 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: add Intel BayTrail gpio driver
References: <1369814513-24967-1-git-send-email-mathias.nyman@linux.intel.com> <CACRpkdZbeUUuxDNWvv2pdNTcbHtTgdLNT5si1seA8As_2t2yEg@mail.gmail.com>
In-Reply-To: <CACRpkdZbeUUuxDNWvv2pdNTcbHtTgdLNT5si1seA8As_2t2yEg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 10:26 PM, Linus Walleij wrote:
> On Wed, May 29, 2013 at 10:01 AM, Mathias Nyman
> <mathias.nyman@linux.intel.com>  wrote:
>
>> Add support for gpio on Intel BayTrail platforms. BayTrail supports 3 banks
>> of gpios called SCORE, NCORE ans SUS with 102, 28 and 43 gpio pins.
>> Supports gpio interrupts
>>
>> Pins may be muxed to alternate function instead of gpio by firmware.
>> This driver does not touch the pin muxing and expect firmare
>> to set pin muxing and pullup/down properties properly.
>>
>> Signed-off-by: Mathias Nyman<mathias.nyman@linux.intel.com>
>
> Even though it is not talking to the firmware about changing the state
> of pins etc, can we expect it to do so at a later point? Some
> comments in the code make me pretty sure that this is the case.
>
> I think there may be a good incentive to put this driver into
> drivers/pinctrl/* instead and implement parts of the pinctrl
> interfaces.
>
> Pls consult Documentation/pinctrl.txt.
>

I'll have a look at pinctrl and see if it fits.

My understanding at the moment is that this driver shouldn't need to 
modify pin muxing. BIOS is responsible for adding GPIO resource entries 
to ACPI tables for devices that use gpios, and BIOS should also set all 
muxings correctly for those pins(also pull-ups/downs etc.)

>> +/*
>> + * Baytrail gpio controller consist of three separate sub-controllers called
>> + * SCORE, NCORE and SUS. The sub-controllers are identified by their acpi UID.
>> + *
>> + * GPIO numbering is _not_ ordered meaning that gpio # 0 in ACPI namespace does
>> + * _not_ correspond to the first gpio register at controller's gpio base.
>> + * There is no logic or pattern in mapping gpio numbers to registers (pads) so
>> + * each sub-controller needs to have its own mapping table
>> + */
>> +
>> +static unsigned score_gpio_to_pad[BYT_NGPIO_SCORE] = {
>> +       85, 89, 93, 96, 99, 102, 98, 101, 34, 37,
>> +       36, 38, 39, 35, 40, 84, 62, 61, 64, 59,
>> +       54, 56, 60, 55, 63, 57, 51, 50, 53, 47,
>> +       52, 49, 48, 43, 46, 41, 45, 42, 58, 44,
>> +       95, 105, 70, 68, 67, 66, 69, 71, 65, 72,
>> +       86, 90, 88, 92, 103, 77, 79, 83, 78, 81,
>> +       80, 82, 13, 12, 15, 14, 17, 18, 19, 16,
>> +       2, 1, 0, 4, 6, 7, 9, 8, 33, 32,
>> +       31, 30, 29, 27, 25, 28, 26, 23, 21, 20,
>> +       24, 22, 5, 3, 10, 11, 106, 87, 91, 104,
>> +       97, 100,
>> +};
>> +
>> +static unsigned ncore_gpio_to_pad[BYT_NGPIO_NCORE] = {
>> +       19, 18, 17, 20, 21, 22, 24, 25, 23, 16,
>> +       14, 15, 12, 26, 27, 1, 4, 8, 11, 0,
>> +       3, 6, 10, 13, 2, 5, 9, 7,
>> +};
>> +
>> +static unsigned sus_gpio_to_pad[BYT_NGPIO_SUS] = {
>> +       29, 33, 30, 31, 32, 34, 36, 35, 38, 37,
>> +       18, 11, 20, 17, 1, 8, 10, 19, 12, 0,
>> +       2, 23, 39, 28, 27, 22, 21, 24, 25, 26,
>> +       51, 56, 54, 49, 55, 48, 57, 50, 58, 52,
>> +       53, 59, 40,
>> +};
>
> This is duplicating the functionality of mapping pins to GPIO ranges
> which already exist in the pinctrl subsystem.
>
> gpiochip_add_pin_range(chip, "foo", offset, pin_base, N);
>
> This can be reused by instatiating a shallow pinctrl driver which only
> populates the .name, .pins, .owner, .get_groups_count(),
> .get_group_name(), and . get_group_pins() of a struct pinctrl_desc
> (we can discuss about making the group functions optional)
> and then using the GPIO ranges to cross reference pins to
> GPIOs.
>
> Then you could use from<linux/pinctrl/pinctrl.h>
> pinctrl_find_gpio_range_from_pin(struct pinctrl_dev *pctldev,
>                                   unsigned int pin);
>
> And other helpers to cross-reference pins and GPIOs.
>
> (...)

The pin-to-gpio mapping is quite random here, there are no long 
consecutive ranges, I tried to find some pattern but it seems to be
just random.

I haven't yet looked into pinctrl yet and see what it offers


>> +static void __iomem *byt_gpio_reg(struct gpio_chip *chip, unsigned offset,
>> +                                int reg)
>> +{
>> +       struct byt_gpio *vg = container_of(chip, struct byt_gpio, chip);
>> +       u32 reg_offset;
>> +       void __iomem *ptr;
>> +
>> +       if (reg == BYT_INT_STAT_REG)
>> +               reg_offset = (offset / 32) * 4;
>> +       else
>> +               reg_offset = vg->gpio_to_pad[offset] * 16;
>> +       ptr = (void __iomem *) (vg->reg_base + reg_offset + reg);
>> +       return ptr;
>> +}
>> +
>> +static int byt_gpio_request(struct gpio_chip *chip, unsigned offset)
>> +{
>> +       struct byt_gpio *vg = container_of(chip, struct byt_gpio, chip);
>> +
>
>
>> +/* Policy about what should be done when requesting a gpio is unclear.
>> + * In most cases PIN MUX 000 means gpio function, with the exception of SUS
>> + * core pins 11-21 where gpio is mux 001.
>
> This also looks suspicious. If it is "unclear" I am reading here:
> "we will sooner or later have to deal with pin control somekindof".
>

It should evolve in the other direction with BIOS configuring the pins, 
but while writing the driver the BIOSes were not mature enough and could 
not be trusted.

So I think I'll either remove the muxing options and keep it as gpio 
driver, or then if it turns out we need to do do pinmuxing I'll use pinctrl.

Thanks for reviewing and for the pinctrl explanations

-Mathias
