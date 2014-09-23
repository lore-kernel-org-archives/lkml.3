Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbaIWQFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:05:17 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51061 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751601AbaIWQFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:05:15 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Arnd Bergmann <arnd@arndb.de>
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
Date: Tue, 23 Sep 2014 18:25:01 +0200
Message-ID: <2895905.coa5UvrkJk@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <12538216.vu4CbU01qP@wuerfel>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <CACRpkdaZJt_6cd1vtDw-Ys+YqUhNb0aXazUxGCX8mk4=6EmdHw@mail.gmail.com> <12538216.vu4CbU01qP@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 23, 2014 05:45:57 PM Arnd Bergmann wrote:
> On Tuesday 23 September 2014 17:25:50 Linus Walleij wrote:
> > On Tue, Sep 16, 2014 at 1:52 PM, Mika Westerberg
> > <mika.westerberg@linux.intel.com> wrote:
> > 
> > > Some drivers need to deal with only firmware representation of its
> > > GPIOs. An example would be a GPIO button array driver where each button
> > > is described as a separate firmware node in device tree. Typically these
> > > child nodes do not have physical representation in the Linux device
> > > model.
> > >
> > > In order to help device drivers to handle such firmware child nodes we
> > > add dev[m]_node_get_named_gpiod() that takes a firmware node pointer as
> > > parameter, finds the GPIO using whatever is the underlying firmware
> > > method, and requests the GPIO properly.
> > >
> > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > 
> > I have a hard time figuring out if this is what we want for common
> > accessors between DT and ACPI.
> > 
> > Can I get some input from Grant, Arnd, Mark, Darren...?
> 
> I just took a brief look at this. My first impression is that the
> fw_dev_node structure is weird when all callers just do (in patch 2)
> 
> +	struct fw_dev_node fdn = {
> +		.of_node = dev->of_node,
> +		.acpi_node = ACPI_COMPANION(dev),
> +	};
> 
> I'd much rather see an interface that passes the 'struct device'
> pointer down to dev_get_named_gpiod() and all other exported
> functions, and then internally does the conversion at the point
> where the access is done.

The problem is iteration over child nodes of a given one where there
may not be struct device objects.

For example (from patch [2/16]):

+int acpi_for_each_child_node(struct acpi_device *adev,
+                             int (*fn)(struct fw_dev_node *fdn, void *data),
+                             void *data)
+{
+       struct acpi_device *child;
+       int ret = 0;
+
+       list_for_each_entry(child, &adev->children, node) {
+               struct fw_dev_node fdn = { .acpi_node = child, };
+
+               ret = fn(&fdn, data);
+               if (ret)
+                       break;
+       }
+       return ret;
+}

and then fn() can be made work for both DTs and ACPI.  Without this we'd
need to have two versions of fn(), one for DTs and one for ACPI (and possibly
more for some other FW protocols), which isn't necessary in general (and
duplicates code etc.). 

That actually is used by some patches down in the series (eg. [10/16]).

Rafael

