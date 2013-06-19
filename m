Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab3FSMzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:55:35 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42359 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3FSMze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:55:34 -0400
Message-ID: <1371646530.3867.12.camel@hornet>
Subject: Re: [RFC PATCH v3 0/2] drivers: mfd: Versatile Express SPC support
From: Pawel Moll <pawel.moll@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <Achin.Gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Date: Wed, 19 Jun 2013 13:55:30 +0100
In-Reply-To: <201306191437.20759.arnd@arndb.de>
References: <1370512763-32200-1-git-send-email-lorenzo.pieralisi@arm.com>
	 <1371547782.16725.11.camel@hornet> <20130619093014.GX7161@zurbaran>
	 <201306191437.20759.arnd@arndb.de>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 19 Jun 2013 12:55:31.0453 (UTC) FILETIME=[47E402D0:01CE6CEC]
X-MC-Unique: 113061913553112001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 13:37 +0100, Arnd Bergmann wrote:
> I think when vexpress-sysreg was created, we didn't have the syscon driver
> yet, otherwise I think we should have used that, and put separate
> drivers on top.
> 
> Not sure if it's too late for changing it to that now, given that
> we already have a binding.

I will have a look try to use the syscon stuff for generic configuration
bits and pieces...

> That would end up eliminating the sysreg driver, aside from maybe
> a one-line change to the syscon driver to allow it to probe the
> right device.

... but sysreg does more than just that. In particular it provides a
pseudo-gpio controller (I don't think you want to hide this behind the
syscon) *and* it can act as a bridge to the configuration bus - see
below. In short - no, I don't think sysreg driver can disappear. It can
be reduced in size, yes.

> > > 3. Move vexpress-config into drivers/bus as it is (however I see no one
> > > in MAINTAINERS for this directory)
> > ISTR that Arnd originally created that directory, so he may help here.
> > Arnd also had some concerns about implementing this code as a bus,
> > mostly about it not being a discoverable bus. IMHO that's a valid
> > concern, and this is why you ended up putting it under MFD which can be
> > seen as some sort of platform devices bus. But I still believe the bus
> > API would make this code look cleaner and easier to maintain.
> 
> Sorry, I don't see why it would be a bus. I assume that there is code
> missing somewhere that is not yet merged, right?

Well, different VE components (configuration microcontrollers on
motherboard and daughterboards in particular) talk to each other over a
bus (an SPI derivative, in case you were wondering). So there is a bus.
A non-discoverable one, but it does 42 (approximately ;-) different
things. We already have: clk, hwmon, regulator and reset drivers using
it.

And, to make things more complicated, the SPC in question, can act as a
bridge to *some* of the functions as well. What's a difference? About
190ms, in at least one case - accessing the energy monitor data (hwmon)
can take up to 200ms going through sysreg and about 10ms going through
SPC. And there are people interesting in getting this numbers as often
as possible. But (obviously, to make things even more complex() only the
daughterboard's components can be accessed through it. Eg. the
motherboard clock generators must still be accessed through sysregs.
Hope you see why the problem is not trivial.

Paweł


