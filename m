Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaJAHsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:48:00 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:58933 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaJAHr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:47:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 02/15] Driver core: Unified device properties interface for platform firmware
Date: Wed, 01 Oct 2014 09:47:40 +0200
Message-ID: <7365448.TlsV4zB2It@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <7184313.9OdTqVa2eQ@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1852462.V1jlbi8OPt@vostro.rjw.lan> <7184313.9OdTqVa2eQ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:4X+nia8jy7Rz6alB3lGy0pZ06oSziNUB15Oib2A1oWb
 6A7CZ+vubOtijgxfG3STntPEPm42LwIJmwiomzWOQmMO0dJGxF
 grhGTK3F1XJaMvaDtgCStLNIkR6aDd6sGPcOZG0EMZ4V6pOmVH
 UvEJstrV7NLffOyzicMw+cXfOdSgtd1a+8qRTS4TQwOJMqINfs
 6A9AW7U7WxPRja+vXSDw8R5ZHddwKkaVd/CHhALO83SZTKcMSa
 KpucJPvQ0/lekXYVayCInjwk0duqj5lUYU70l1b+IU+f+7EDdd
 +yExsAF99l6nyXdI/JNZYQPFFHpUcEAk4/ybn7tb8GM5R/m8nt
 TxvTYkZHE2vXEq1+AVCc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 04:10:03 Rafael J. Wysocki wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> 
> Add a uniform interface by which device drivers can request device
> properties from the platform firmware by providing a property name
> and the corresponding data type.  The purpose of it is to help to
> write portable code that won't depend on any particular platform
> firmware interface.
> 
> Three general helper functions, device_get_property(),
> device_read_property() and device_read_property_array() are provided.
> The first one allows the raw value of a given device property to be
> accessed.  The remaining two allow the value of a numeric or string
> property and multiple numeric or string values of one array
> property to be acquired, respectively.  Static inline wrappers are also
> provided for the various property data types that can be passed to
> device_read_property() or device_read_property_array() for extra type
> checking.

These look great!

> In addition to that, new generic routines are provided for retrieving
> properties from device description objects in the platform firmware
> in case a device driver needs/wants to access properties of a child
> object of a given device object.  There are cases in which there is
> no struct device representation of such child objects and this
> additional API is useful then.  Again, three functions are provided,
> device_get_child_property(), device_read_child_property(),
> device_read_child_property_array(), in analogy with device_get_property(),
> device_read_property() and device_read_property_array() described above,
> respectively, along with static inline wrappers for all of the propery
> data types that can be used.  For all of them, the first argument is
> a struct device pointer to the parent device object and the second
> argument is a (void *) pointer to the child description provided by
> the platform firmware (either ACPI or FDT).

I still have my reservations against the child accessors, and would
like to hear what other people think. Passing a void pointer rather
than struct fw_dev_node has both advantages and disadvantages, and
I won't complain about either one if enough other people on the DT
side would like to see the addition of the child functions.

> Finally, device_for_each_child_node() is added for iterating over
> the children of the device description object associated with a
> given device.
> 
> The interface covers both ACPI and Device Trees.
> 
> This change set includes material from Mika Westerberg and Aaron Lu.
> 

Regarding device_for_each_child_node(), the syntax is inconsistent
with what we normally use, which can probably be changed. All of the
DT for_each_* helpers are macros that are used like

	struct device *dev = ...;
	void *child; /* iterator */

	device_for_each_child_node(dev, child) {
		u32 something;
		device_child_property_read_u32(dev, child, "propname", &something);

		do_something(dev, something);
	}

If we get a consensus on having the child interfaces, I'd rather see
them done this way than with a callback pointer, for consistency
reasons.

	Arnd
