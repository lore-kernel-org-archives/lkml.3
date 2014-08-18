Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750957AbaHREgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 00:36:20 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59156 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750762AbaHREgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 00:36:18 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Darren Hart <dvhart@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/9] Driver core: Unified device properties interface for platform firmware
Date: Mon, 18 Aug 2014 06:55:03 +0200
Message-ID: <1838298.HBQHpiQkeW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <D016480B.A1AC8%dvhart@linux.intel.com>
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com> <20140817124913.A597FC40F4B@trevor.secretlab.ca> <D016480B.A1AC8%dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 17, 2014 12:31:27 PM Darren Hart wrote:
> On 8/17/14, 5:49, "Grant Likely" <grant.likely@secretlab.ca> wrote:
> 
> >
> >Hi Mika and Rafael,
> >
> >Comments below...

[cut]

> ...
> 
> >> @@ -701,6 +702,7 @@ struct acpi_dev_node {
> >>   * @archdata:	For arch-specific additions.
> >>   * @of_node:	Associated device tree node.
> >>   * @acpi_node:	Associated ACPI device node.
> >> + * @property_ops: Firmware interface for device properties
> >>   * @devt:	For creating the sysfs "dev".
> >>   * @id:		device instance
> >>   * @devres_lock: Spinlock to protect the resource of the device.
> >> @@ -777,6 +779,7 @@ struct device {
> >>  
> >>  	struct device_node	*of_node; /* associated device tree node */
> >>  	struct acpi_dev_node	acpi_node; /* associated ACPI device node */
> >> +	struct dev_prop_ops	*property_ops;
> >
> >There are only 2 users of this interface. I don't think adding an ops
> >pointer to each and every struct device is warrented when the wrapper
> >function can check if of_node or acpi_node is set and call the
> >appropriate helper. It is unlikely anything else will use this hook. It
> >will result in smaller memory footprint. Also smaller code when only one
> >of
> >CONFIG_OF and CONFIG_ACPI are selected, which is almost always. :-)
> >
> >It can be refactored later if that ever changes.
> 
> 
> Our intent was to eliminate the #ifdefery in every one of the accessors.
> It was my understanding the ops structures were preferable in such
> situations. For a 64-bit machine with 1000 devices (all of which use
> device properties) with one or the other of ACPI/OF enabled, the
> additional memory requirement here is what... Something like (8*1000 + 4)
> ~= 8KB ? That seems worth the arguably more maintainable code to me. Is
> there more to it than this, am I missing some more significant impact?

Also we wanted to avoid going throug the same sequence of checks every time
a property is accessed for a given device as the result those checks would
lead to every time was already known when the device was registered.

Arguably, if we decide that using DTs and ACPI on the same system at the same
time is a total no-go, then we'll need just one global ops pointer either to
the ACPI or to the DT set of callbacks, but I'm not sure whether or not that
is the way to go.

Rafael

