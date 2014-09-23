Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbaIWQ00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:26:26 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:64281 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaIWQ0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:26:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [RFC PATCH v2 07/16] gpio: Add support for unified device properties interface
Date: Tue, 23 Sep 2014 18:26:07 +0200
Message-ID: <2809308.3y5s7TV5Ip@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2895905.coa5UvrkJk@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <12538216.vu4CbU01qP@wuerfel> <2895905.coa5UvrkJk@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ZV7MQ7FIl6ix1l2pjMFWPB4Ntuq6yAPlhJp771I77fq
 Pg8HlhLTDsNwuQFn40LZciz/jAPEuvHye+eLHH5pWh/JMZLnmp
 90k6Cc9cMmLPNVv62my7fhnuGw/PTRq0KwvzsilulchpSnDDk3
 1B8cMj13TYA86VumWLHZnGOhApyZSZ72lREMsV/jatVO9w/t3W
 AZWc0EkBT2r80D2I6uc2C51wkvbnaSgaGsEhUVQNn55R/meC0v
 QYuOSG79eLKLB4VMAjPpfXjbhVgx7LGmQLDZYO4Yg+mqV6S3uc
 fRvW3kQhrmqn2jn2PZ+HkCTQf9w43jy8dJhYOvmMG9doZZMHUQ
 lVPpqlJDv7OSEHWjTAdA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 18:25:01 Rafael J. Wysocki wrote:
> The problem is iteration over child nodes of a given one where there
> may not be struct device objects.
> 
> For example (from patch [2/16]):
> 
> +int acpi_for_each_child_node(struct acpi_device *adev,
> +                             int (*fn)(struct fw_dev_node *fdn, void *data),
> +                             void *data)
> +{
> +       struct acpi_device *child;
> +       int ret = 0;
> +
> +       list_for_each_entry(child, &adev->children, node) {
> +               struct fw_dev_node fdn = { .acpi_node = child, };
> +
> +               ret = fn(&fdn, data);
> +               if (ret)
> +                       break;
> +       }
> +       return ret;
> +}
> 
> and then fn() can be made work for both DTs and ACPI.  Without this we'd
> need to have two versions of fn(), one for DTs and one for ACPI (and possibly
> more for some other FW protocols), which isn't necessary in general (and
> duplicates code etc.). 
> 
> That actually is used by some patches down in the series (eg. [10/16]).
> 

Ok, I understand what you are doing now.

Looking at the example you point to (http://www.spinics.net/lists/devicetree/msg49502.html), I still feel
that this is adding more abstraction than what is good for us, and
I'd be happier with an implementation of gpio_leds_create() that
has a bit more duplication and less abstraction.

The important part should be that the driver-side interface is
sensible, other than that an implementation like

static struct gpio_leds_priv *gpio_leds_create(struct platform_device *pdev)
{
	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node)
		return gpio_leds_create_of(pdev);
	else if (IS_ENABLED(CONFIG_ACPI))
		return gpio_leds_create_of(acpi);
	return ERR_PTR(-ENXIO);
}

would keep either side of it relatively simple, by leaving out the
indirect function calls and new for_each_available_child_of_node()
macro.

How many other users of fw_dev_node do you have at the moment?

	Arnd
