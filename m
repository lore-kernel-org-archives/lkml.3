Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaHGG0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:26:09 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:51046 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbaHGG0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:26:05 -0400
MIME-Version: 1.0
In-Reply-To: <53D0A8B7.2010005@roeck-us.net>
References: <1406139132-5404-1-git-send-email-linux@roeck-us.net>
 <CAAVeFuKsJpSYo2DMyTdYE2J5Cu_ZD=b9o-=S0DLDccyNmwniNg@mail.gmail.com> <53D0A8B7.2010005@roeck-us.net>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 7 Aug 2014 15:25:44 +0900
Message-ID: <CAAVeFuK5uKhpkpEnoRFGKU4G4Fey0+giz5wwmtr+OCLJHPvnLQ@mail.gmail.com>
Subject: Re: [RFC PATCH] gpiolib: Provide and export gpiod_export_name
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delayed reply...

On Thu, Jul 24, 2014 at 3:33 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> As I explained on the other thread, I still encourage you to have
>> these GPIOs under device nodes that give a hint of who is provided the
>> GPIO (effectively exporting the (dev, function) tuple to user-space)
>> instead of having them popping out under /sys/class/gpio where nobody
>> knows where they come from and name collisions are much more likely.
>>
>> Your message sounds like you have no choice but have the named GPIO
>> link under the gpiochip's device node, but this is not the case -
>> gpio_export_link() let's you specify the device under which the link
>> should appear. Make that device be your "scu" device and you can have
>> a consistent sysfs path to access your GPIOs.
>>
> Yes, I understand, but that is not acceptable for the users - see below.
>
>
>> Allowing GPIOs to pop up in the same directory with an arbitrary name
>> is just a recipe for a mess. But that's a recipe that is already
>> allowed thanks to that 'names' array. So I'm really confused about
>> what to do with this patch. If you can do with gpio_export_link() (and
>> I have not seen evidence of the contrary), please go that way instead.
>>
>
> I personally don't think it is that much of a mess. Sure, once has to be
> careful when selecting names, but I don't see a problem with that.
>
> I have two users for this. Interestingly the problem is pretty
> much the same, though the applications are completely different.
>
> One is the company using the scu.c file. They are currently using the
> pca953x driver approach (using the names array), but they also have
> a new version of their product which also uses gpio pins from gpio-ich.
> For consistency, they want all gpio pins in the same directory, meaning
> /sys/class/gpio.
>
> The currently implemented solution is to have a weak pointer to the names
> array in gpio-ch.c and override it with a pointer from scu.c.
>
> /* SCU specific gpio pin names. Only works if module is built into kernel.
> */
> static const char * const scu_ichx_gpiolib_names[128] = {
>         [0] = "switch_interrupt",       /* GPI0 */
>         [3] = "ac_loss_detect",         /* GPI3 */
>         [16] = "debug_out",             /* GPO0 */
>         [20] = "switch_reset",          /* GPO3 */
> };
>
> [ switch_interrupt and switch_reset will ultimately make it into the kernel,
>   to be used by a dsa driver, but that is besides the point. ]
>
> const char * const (* const ichx_gpiolib_names)[] = &scu_ichx_gpiolib_names;
>
> and ichx_gpiolib_names is declared as
>
> /* Allow overriding default gpio pin names */
> const char * const (* const __weak ichx_gpiolib_names)[];
>
> in gpio-ich.c. Pretty hackish, but at least it works. Slim chance though
> to get this accepted upstream. Since the ultimate idea is to submit all
> this code upstream, I would prefer to find a solution which is
> acceptable for both the user and for upstream integration.
>
> The second user is my employer. Same thing here, though even more complex
> as there are several different platforms to support with different platform
> drivers. Each platform exports a number of gpio pins to user space, often
> with
> the same functionality across platforms. The request here is to have all
> those pins in the same directory, for all platforms, which again suggests
> using /sys/class/gpio.
>
> Current approach is to use the "export" file to request pin exports,
> which has its own challenges such as having to search for the pin numbers.
> Well defined names and pins exported from the kernel would be much cleaner
> and be easier to handle.
>
> Of course, I could try to come up with a new class named "gpios" or similar,
> put everything there, and start selling that idea. Somehow that doesn't
> sound like a good idea to me.

Or you could have a platform device which sole purpose is to request
the GPIOs to export and export them using gpio_export() and
gpio_export_link() using itself as the device parameters. All your
links would then appear under the same sysfs directory, and that
directory name would be consistent across platforms. What is wrong
with this approach?

As for the patch itself, as I said before I am not a huge fan of
putting randomly-named exports under /sys/class/gpio, but since there
is a precedent with the driver GPIO names array I don't think this
makes the situation much worse. Still I'd like you to explain me what
I missed and why you cannot use the technique described above to
achieve your goal with the currently existing interfaces.
