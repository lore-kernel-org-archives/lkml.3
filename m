Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3LDVVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:21:50 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63811 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754439Ab3LDVVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:21:48 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "David E. Box" <david.e.box@linux.intel.com>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCHv2 2/2] ACPI/platform: Add ACPI ID for Intel MBI device
Date: Wed, 04 Dec 2013 22:34:45 +0100
Message-ID: <16922953.M8X8XT9eUD@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131204025407.GA26448@srcf.ucam.org>
References: <1385100357-5459-1-git-send-email-david.e.box@linux.intel.com> <20131204024452.GB8282@linux.intel.com> <20131204025407.GA26448@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 04, 2013 02:54:07 AM Matthew Garrett wrote:
> On Tue, Dec 03, 2013 at 06:44:52PM -0800, David E. Box wrote:
> > On Wed, Dec 04, 2013 at 02:21:30AM +0000, Matthew Garrett wrote:
> > > Well sure, but why do you need to be a platform device at all? This 
> > > functionality was intended for cases where we already have a driver for 
> > > the part that enumerated it via some other mechanism. If the driver's 
> > > only intended for ACPI systems then why not just be an ACPI device?

Because struct acpi_device things are firmawre objects that shouldn't be
treated as devices.

> > 
> > It was my understanding that with ACPI 5.0 it was becoming more common to use
> > ACPI ID's exclusively for device enumeration. I originally wrote this as an
> > acpi_bus driver but Rafeal advised me that the model is being phased out and
> > suggeted the platform model instead.
> 
> If you're not adding ACPI support to an existing platform driver, you 
> shouldn't be adding entries to acpi_platform.c. I'm not actually happy 
> that I merged the ideapad-laptop patch that did the same thing - I'm 
> inclined to revert it, because this really is an ugly way to do things.
> 
> Rafael, why did we convert the AC driver this way? It means we have to 
> keep track of ACPI IDs in multiple places,

Yes, in two places to be precise.

> which is worth it when it avoids having to write a pile of new code (such as
> the sdhci case) but doesn't seem to provide benefits otherwise.

Well, I thought we discussed that, but perhaps we didn't.

There's some confusion about what a struct acpi_device is, because sometimes it
is treated as a "companion" of a physical device and sometimes it is treated as
a physical device itself.  This leads to incorrect code as well sometimes,
because ACPI drivers may attempt to bind to things that already have physical
comapnions, for example.

The approach to this I thought we could use, and that we've been using to some
extent already, is to create "physical" companions for all struct acpi_device
objects.  In this particular this "physical companion" is a platform device, so
it needs to be added to the list in acpi_platform.c.  [Otherwise the ACPI PNP
core would create a PNP device for it (unless an ACPI driver is bound to that
struct acpi_device before, but that makes the correctness of the thing depend
on the ordering of driver probing, which is not awesome).]

In this approach device drivers bind to the "physical" devices (platform devices
etc.) instead of struct acpi_device themselves and at least everything is
consistent.

Thanks,
Rafael

