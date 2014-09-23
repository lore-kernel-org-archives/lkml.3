Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530AbaIWVQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:16:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:5877 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292AbaIWVP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:15:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,582,1406617200"; 
   d="scan'208";a="604270347"
User-Agent: Microsoft-MacOutlook/14.4.3.140616
Date: Tue, 23 Sep 2014 14:15:47 -0700
Subject: Re: [RFC PATCH v2 07/16] gpio: Add support for unified device
 properties interface
From: Darren Hart <dvhart@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <david.woodhouse@intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Aaron Lu <aaron.lu@intel.com>
Message-ID: <D04730D8.A9DB0%dvhart@linux.intel.com>
Thread-Topic: [RFC PATCH v2 07/16] gpio: Add support for unified device
 properties interface
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <12538216.vu4CbU01qP@wuerfel>
 <2895905.coa5UvrkJk@vostro.rjw.lan>
 <2809308.3y5s7TV5Ip@wuerfel>
In-Reply-To: <2809308.3y5s7TV5Ip@wuerfel>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/14, 9:26, "Arnd Bergmann" <arnd@arndb.de> wrote:

>On Tuesday 23 September 2014 18:25:01 Rafael J. Wysocki wrote:
>> The problem is iteration over child nodes of a given one where there
>> may not be struct device objects.
>> 
>> For example (from patch [2/16]):
>> 
>> +int acpi_for_each_child_node(struct acpi_device *adev,
>> +                             int (*fn)(struct fw_dev_node *fdn, void
>>*data),
>> +                             void *data)
>> +{
>> +       struct acpi_device *child;
>> +       int ret = 0;
>> +
>> +       list_for_each_entry(child, &adev->children, node) {
>> +               struct fw_dev_node fdn = { .acpi_node = child, };
>> +
>> +               ret = fn(&fdn, data);
>> +               if (ret)
>> +                       break;
>> +       }
>> +       return ret;
>> +}
>> 
>> and then fn() can be made work for both DTs and ACPI.  Without this we'd
>> need to have two versions of fn(), one for DTs and one for ACPI (and
>>possibly
>> more for some other FW protocols), which isn't necessary in general (and
>> duplicates code etc.).
>> 
>> That actually is used by some patches down in the series (eg. [10/16]).
>> 
>
>Ok, I understand what you are doing now.
>
>Looking at the example you point to
>(http://www.spinics.net/lists/devicetree/msg49502.html), I still feel
>that this is adding more abstraction than what is good for us, and
>I'd be happier with an implementation of gpio_leds_create() that
>has a bit more duplication and less abstraction.
>
>The important part should be that the driver-side interface is
>sensible, other than that an implementation like
>
>static struct gpio_leds_priv *gpio_leds_create(struct platform_device
>*pdev)
>{
>	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node)
>		return gpio_leds_create_of(pdev);
>	else if (IS_ENABLED(CONFIG_ACPI))
>		return gpio_leds_create_of(acpi);

Arnd, I think you meant:

	Return gpio_leds_create_acpi(pdev) ?

This is what we did early on to prototype this concept, but the problem
with this approach we duplicate all of the creation code, which leads to
maintenance errors, and is inconsistent with the goals of the _DSD which
is to reuse the same schemas for ACPI and FDT. If we have separate pdata
creation functions anyway, we are leaving much of the advantage of the
common schema on the table. Namely the ability to reuse drivers relatively
easily across firmware implementations. We don't want driver authors to
have to care if it's ACPI or FDT.

We would have preferred to have deprecated the of property interface in
favor of the new generic device_property interface, but Grant specifically
requested that we update drivers individually rather than all at once,
which means we can't just kill the OF interface.

We agreed to that, somewhat reluctantly as it adds more work in updating
the drivers over time which will slow adoption, but I understand the
desire not to make large sweeping changes due to the risk of breaking
things inadvertently as we cannot expect to be able to test all of them.
That said, I don't want to forget that the goal is to use the common
interface over time as we convert individual drivers, and using the common
interface means we need a common iterator function and that we not have fw
implementation specific pdata create functions.

--
Darren Hart
Intel Open Source Technology Center





