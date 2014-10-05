Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbaJEKg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 06:36:28 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:65046 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaJEKgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 06:36:25 -0400
MIME-Version: 1.0
In-Reply-To: <5364540.jzXqjZX0yp@wuerfel>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <1852462.V1jlbi8OPt@vostro.rjw.lan> <4786851.38d7sjpzag@vostro.rjw.lan> <5364540.jzXqjZX0yp@wuerfel>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 5 Oct 2014 19:36:04 +0900
Message-ID: <CAAVeFuLH8mh_qo86Pyt+VqWwS16sqoPnYrpfmC4jMu-QdrfqtQ@mail.gmail.com>
Subject: Re: [PATCH v3 05/15] gpio / ACPI: Add support for _DSD device properties
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 5:03 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 01 October 2014 04:12:41 Rafael J. Wysocki wrote:
>> +       static const char * const suffixes[] = { "gpios", "gpio" };
>> +       struct acpi_device *adev = ACPI_COMPANION(dev);
>>         struct acpi_gpio_info info;
>>         struct gpio_desc *desc;
>> +       char propname[32];
>> +       int i;
>>
>> -       desc = acpi_get_gpiod_by_index(dev, idx, &info);
>> -       if (IS_ERR(desc))
>> -               return desc;
>> +       /* Try first from _DSD */
>> +       for (i = 0; i < ARRAY_SIZE(suffixes); i++) {
>> +               if (con_id && strcmp(con_id, "gpios")) {
>> +                       snprintf(propname, sizeof(propname), "%s-%s",
>> +                                con_id, suffixes[i]);
>> +               } else {
>> +                       snprintf(propname, sizeof(propname), "%s",
>> +                                suffixes[i]);
>> +               }
>
> The general interface seems fine, but I'd be happier if you didn't
> try to support all four of the possible syntaxes we have in DT.
> It would be much better to have only "gpios" and not "gpio", and
> the "foo-gpios" syntax should be replaced with whatever method you
> use to name other subsystem specific links. For most subsystems
> we now use something like "gpio-names", but unfortunately the GPIO
> binding goes back to the time before we had come to that agreement.
> The same applies to regulators.

Wouldn't restricting the naming scheme cause problems for ACPI drivers
that want to reuse existing DT bindings? Since DT bindings are set in
stone, this means we would have to use different properties for DT and
ACPI.

I agree that there are too much ways to define GPIOs, but I'm afraid
we will have to carry them over for the sake of consistency.
