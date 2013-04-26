Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab3DZJWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:22:47 -0400
Received: from multi.imgtec.com ([194.200.65.239]:17557 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932427Ab3DZJWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:22:41 -0400
Message-ID: <517A475D.8060606@imgtec.com>
Date: Fri, 26 Apr 2013 10:22:37 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 6/8] gpio-tz1090: add TZ1090 gpio driver
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com> <1366727607-27444-7-git-send-email-james.hogan@imgtec.com> <CACRpkdbzYpQqe4yabAwFSAG2rPstT8jM_--LssHi=ttUYtu1ug@mail.gmail.com>
In-Reply-To: <CACRpkdbzYpQqe4yabAwFSAG2rPstT8jM_--LssHi=ttUYtu1ug@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_04_26_10_22_38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Thanks for reviewing these patches.

On 26/04/13 00:01, Linus Walleij wrote:
> On Tue, Apr 23, 2013 at 4:33 PM, James Hogan <james.hogan@imgtec.com> wrote:
> 
>> Add a GPIO driver for the main GPIOs found in the TZ1090 (Comet) SoC.
>> This doesn't include low-power GPIOs as they're controlled separately
>> via the Powerdown Controller (PDC) registers.
>>
>> The driver is instantiated by device tree and supports interrupts for
>> all GPIOs.
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Rob Landley <rob@landley.net>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: linux-doc@vger.kernel.org
> 
> (...)
>> +  - #gpio-cells: Should be 2. The syntax of the gpio specifier used by client
>> +    nodes should have the following values.
>> +       <[phandle of the gpio controller node]
>> +        [gpio number within the gpio bank]
>> +        [standard Linux gpio flags]>
> 
> So when someone using this device tree for Symbian or Windows
> Mobile start to work, what does "standard Linux gpio flags" tell them?

well this is what of_gpio.h says:
> /*
>  * This is Linux-specific flags. By default controllers' and Linux' mapping
>  * match, but GPIO controllers are free to translate their own flags to
>  * Linux-specific in their .xlate callback. Though, 1:1 mapping is recommended.
>  */
> enum of_gpio_flags {
> 	OF_GPIO_ACTIVE_LOW = 0x1,
> };

So do you mean that the bindings docs should just explicitly state those
flag values rather than referring to Linux?

>> +  Bank subnode optional properties:
>> +  - gpio-ranges: Mapping to pin controller pins
> 
> Here you seem to use DT GPIO ranges, yet the pinctrl driver registers
> some GPIO range, care to explain how that fits together?

I'll look into this a bit deeper. I suspect the one in the pinctrl
driver shouldn't be there.

> +#include <asm/global_lock.h>
> 
> What on earth is that. I can only fear it. I don't like the
> looks of that thing.

Yes, it's not particularly pleasant.

The TZ1090 is designed for digital radios. It has a 2-threaded Meta HTP
as the CPU (which might typically run Linux on one thread and an RTOS
doing audio decode and driving the audio hardware on the other), and 2
UCCPs (these are Radio Processing Units each containing a small Meta
MTX, which will typically interface to a tuner chip and do things like
DAB/FM radio or WiFi).

So basically a bunch of global registers (e.g. pinctrl and gpio) are
shared between all 3 cores (up to 4 OSes). The __global_lock2 should do
all that is required to ensure exclusive access to the register (as long
as the other OSes do something similar when they access the same
registers). This is one of the reasons why there are 3 gpio banks with
separate interrupts, and each bank's interrupt is optional in this driver.

> 
> (...)
>> +/* Convenience register accessors */
>> +static void tz1090_gpio_write(struct tz1090_gpio_bank *bank,
>> +                             unsigned int reg_offs, u32 data)
>> +{
>> +       iowrite32(data, bank->reg + reg_offs);
>> +}
>> +
>> +static u32 tz1090_gpio_read(struct tz1090_gpio_bank *bank,
>> +                           unsigned int reg_offs)
>> +{
>> +       return ioread32(bank->reg + reg_offs);
>> +}
> 
> The pinctrl driver included the keyword "inline" for these so
> this should be consistent and do that too.

Okay

> +static inline void _tz1090_gpio_clear_bit(struct tz1090_gpio_bank *bank,
> +                                         unsigned int reg_offs,
> +                                         unsigned int offset)
> +{
> +       u32 value;
> +
> +       value = tz1090_gpio_read(bank, reg_offs);
> +       value &= ~(0x1 << offset);
> 
> I usually do this:
> 
> #include <linux/bitops.h>
> 
> value &= ~BIT(offset);

Good idea.

>> +/* caller must hold LOCK2 */
>> +static inline void _tz1090_gpio_mod_bit(struct tz1090_gpio_bank *bank,
>> +                                       unsigned int reg_offs,
>> +                                       unsigned int offset,
>> +                                       int val)
> 
> If val is used as it is, make it a bool.
> 
>> +{
>> +       u32 value;
>> +
>> +       value = tz1090_gpio_read(bank, reg_offs);
>> +       value &= ~(0x1 << offset);
>> +       value |= !!val << offset;
> 
> You're claming val to [0,1] obviously it's a bool.

It's often simply passing on things like the int output_value from the
direction_output and set callbacks. Is it necessary to confuse things by
making it a bool and then turning it back into an int to write into the
register?

> This is also very nice and handling the toggling edge in
> a working way.

Credit goes to some engineers from PURE for the toggling magic :-)

> Overall looking very nice, just needs som polishing, and I'm way
> scared about that global lock.

Thanks again for taking the time to review.

Cheers
James

