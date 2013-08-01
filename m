Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab3HAPwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:52:34 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56130 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab3HAPwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:52:33 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <51FA8440.7050507@roeck-us.net>
Date: Thu, 01 Aug 2013 08:52:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Simon Guinot <simon.guinot@sequanux.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH v3] gpio: add GPIO support for F71882FG and F71889F
References: <1374486633-9737-1-git-send-email-simon.guinot@sequanux.org> <CACRpkda2bH_TkFR6c0cXvjye4SmFWN5xuzQSO=NqBq8mNDgV0g@mail.gmail.com> <20130801134632.GY9916@kw.sim.vm.gnt>
In-Reply-To: <20130801134632.GY9916@kw.sim.vm.gnt>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 06:46 AM, Simon Guinot wrote:
> On Mon, Jul 29, 2013 at 05:59:08PM +0200, Linus Walleij wrote:
>> On Mon, Jul 22, 2013 at 11:50 AM, Simon Guinot
>> <simon.guinot@sequanux.org> wrote:
>>
>>> This patch adds support for the GPIOs found on the Fintek super-I/O
>>> chips F71882FG and F71889F.
>>>
>>> A super-I/O is a legacy I/O controller embedded on x86 motherboards. It
>>> is used to connect the low-bandwidth devices. Among others functions the
>>> F71882FG/F71889F provides: a parallel port, two serial ports, a keyboard
>>> controller, an hardware monitoring controller and some GPIO pins.
>>>
>>> Note that this super-I/Os are embedded on some Atom-based LaCie NASes.
>>> The GPIOs are used to control the LEDs and the hard drive power.
>>>
>>> Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
>>> ---
>>> Changes since v2:
>>> - Remove useless NULL setters for driver data.
>
> Hi Linus,
>
>>
>> Given the recent discussion with Rafael I want to have an
>> extended discussion of this patch.
>>
>> It is my current understanding that:
>>
>> - It is possible to define the whereabouts of the SuperIO
>>    chips using ACPI
>
> Agreed.
>
>> - It is possible for developers to influence the source
>>    AML for the DSDT tables of these systems.
>
> I am not sure about that. Let's consider the LaCie x86-based boards.
> LaCie only adds a few devices on the top of a motherboard provided by
> an another manufacturer. In turns, this last gets a Super-I/O from an
> another manufacturer. In my understanding, the Super-I/O manufacturer is
> responsible for registering the PNP IDs (one per device functionality).
>
> LaCie may have enough leverage to obtain some modifications on the ACPI
> DSDT tables but about the PNP IDs registration, let's say it is less
> that certain. The problem is that LaCie don't have any contacts with the
> Super-I/O manufacturer.
>
> I have to say that all this process is not as easy as adding a node in
> a dts file.
>
>> - It is the proper thing to do.
>
> Yes, it may be.
>
>> - So we should atleast support ACPI probing with the
>>    port-based detection as a final fallback if all else fails.
>>
>> Why can I not get something like:
>>
>> #include <linux/acpi.h>
>> (...)
>> static const struct acpi_device_id gpio_acpi_match[] = {
>>          { "FOOBAR", 0 },
>
> After some checks on my boards, it appears that there is no PNP ID
> available for the Super-I/O GPIO functionality (or any others). Moreover
> I think this IDs don't have been registered to Microsoft by Fintech
> (the super-I/O manufacturer).
>
> How do you envisage the follow-up ?
>
>>          { }
>> };
>> MODULE_DEVICE_TABLE(acpi, gpio_acpi_match);
>>
>> static struct platform_driver gpio_driver = {
>>          (...)
>>          .driver         = {
>>                   (...)
>>                  .acpi_match_table = ACPI_PTR(gpio_acpi_match),
>>          },
>> };
>
> It seems to me that the ACPI probing is the easiest part. How do you see
> the ioport probing fallback ?
>
> I can only figure out broken solutions:
>
> 1. From the init function, we could check that the PNP IDs are well
>     available in the ACPI DSDT tables before registering the platform
>     driver. If not, we could fall back on the ioport probing method.
>     I don't know if checking the DSDT tables is even possible. It is at
>     least weird and it defeats completely the purpos of acpi_match_table.
> 2. In a late initcall, we could check that the driver is well
>     registered else fall back on the ioport detection.
>     As GPIOs may be needed early, I don't think this method is suitable.
>
> And I have no more ideas...
>
3. Implement Super-IO detection in the the ACPI platform driver.
    If there is no ACPI device entry for a detected Super-IO chip's sub-function(s),
    fake it and create the respective platform device(s).

Just as kludgy as your proposed solutions, but at least it would move Super-IO detection
to one file and let all Super-IO drivers use the ACPI match table.

Drawbacks:
- Only works for x86 (ie it would limit SuperIO drivers to x86). Not sure if that is
   a real limitation - are SuperIO chips used on other platforms ?
- It would require us to define fake PNP IDs for the various SuperIO functions.
- It may fail if a firmware / chip vendor ever adds real PNP IDs for the various
   sub-functions and those start showing up in ACPI tables (maybe that doesn't matter
   as much as the drivers would have to be updated anyway to match the real IDs).

Guenter

