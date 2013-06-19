Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934417Ab3FSPDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:03:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54338 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab3FSPDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:03:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pawel Moll <pawel.moll@arm.com>
Subject: Re: [RFC PATCH v3 0/2] drivers: mfd: Versatile Express SPC support
Date: Wed, 19 Jun 2013 17:03:34 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
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
References: <1370512763-32200-1-git-send-email-lorenzo.pieralisi@arm.com> <201306191437.20759.arnd@arndb.de> <1371646530.3867.12.camel@hornet>
In-Reply-To: <1371646530.3867.12.camel@hornet>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306191703.35182.arnd@arndb.de>
X-Provags-ID: V02:K0:rZARiLEkhpDFvAj9m5EhrtUekNecg9Ju+KT3481I29o
 SGxiw/kJwhb2YxfoYVR+1Kt63eoTu2uD/qIeTgPYOil91n7/f3
 VOaKptdLHhxjdjh6WBNkd0st7zxLMaK/JuNas3SyTrKkNPlB/f
 gWxQfmgXlYXZFe76oQbl7lJSMiCNCoxpWoPCek7ekicPua/yID
 L/Wfl/PlnO59at/n04p2XCqxFOghDThXcdVQxGtHPRpS1vvrho
 I8/fAaJxG2tJXhZAtI/sVFK4yMmxx7KMLraxedo0YfRNoR9RQ/
 YwM8uqWPYYBeuDR2L8zJA5WTYlv2POw86FDmaufVhX8WFdPHbw
 6kTXwulk+2J1kdpDsO0M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 June 2013, Pawel Moll wrote:
> > That would end up eliminating the sysreg driver, aside from maybe
> > a one-line change to the syscon driver to allow it to probe the
> > right device.
> 
> ... but sysreg does more than just that. In particular it provides a
> pseudo-gpio controller (I don't think you want to hide this behind the
> syscon) and it can act as a bridge to the configuration bus - see
> below. In short - no, I don't think sysreg driver can disappear. It can
> be reduced in size, yes.

As I said, the gpio part can be a separate driver that just handles
gpio, and I think the configuration bridge can be part of the
vexpress-config driver, building on top of syscon. I'm not completely
sure about the latter part.

> > > > 3. Move vexpress-config into drivers/bus as it is (however I see no one
> > > > in MAINTAINERS for this directory)
> > > ISTR that Arnd originally created that directory, so he may help here.
> > > Arnd also had some concerns about implementing this code as a bus,
> > > mostly about it not being a discoverable bus. IMHO that's a valid
> > > concern, and this is why you ended up putting it under MFD which can be
> > > seen as some sort of platform devices bus. But I still believe the bus
> > > API would make this code look cleaner and easier to maintain.
> > 
> > Sorry, I don't see why it would be a bus. I assume that there is code
> > missing somewhere that is not yet merged, right?
> 
> Well, different VE components (configuration microcontrollers on
> motherboard and daughterboards in particular) talk to each other over a
> bus (an SPI derivative, in case you were wondering). So there is a bus.
> A non-discoverable one, but it does 42 (approximately ;-) different
> things. We already have: clk, hwmon, regulator and reset drivers using
> it.

Ah, got it. In this case I think what you are looking for is a custom
'regmap' interface that abstracts those devices. Regmap can already
cover i2c, spi and mmio based sets of registers (syscon is one example
for mmio), and IIRC there is a simple way of extending it to other
register-level interfaces like this one.

> And, to make things more complicated, the SPC in question, can act as a
> bridge to some of the functions as well. What's a difference? About
> 190ms, in at least one case - accessing the energy monitor data (hwmon)
> can take up to 200ms going through sysreg and about 10ms going through
> SPC. And there are people interesting in getting this numbers as often
> as possible. But (obviously, to make things even more complex() only the
> daughterboard's components can be accessed through it. Eg. the
> motherboard clock generators must still be accessed through sysregs.
> Hope you see why the problem is not trivial.

Yes, it definitely needs some detailed analysis, but I think regmap is
a good fit to simplify this code. Please have a look at that and tell
me if you see problems with it.

	Arnd
