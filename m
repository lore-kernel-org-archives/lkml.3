Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591AbaGXQ2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:28:04 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60771 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397AbaGXQ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:28:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        patrice.chotard@st.com, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, srinivas.kandagatla@gmail.com,
        lee.jones@linaro.org, maxime.coquelin@st.com
Subject: Re: [PATCH v2 1/3] usb: host: st-hcd: Add USB HCD support for STi SoCs
Date: Thu, 24 Jul 2014 18:26:48 +0200
Message-ID: <5840432.YNRZREIYz5@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140724141412.GA21823@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1406199616-10533-1-git-send-email-peter.griffin@linaro.org> <5967609.vndF2bDyS1@wuerfel> <20140724141412.GA21823@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2juFTmmwEvvEFbmSegm8mZKq6THnv/BTZEuY/r4rYlC
 QWrTbYlLbAXdgJKFe56a67GhaKjgzoOvFmPL/wLIxXq3SiZTaQ
 nTDlQ5woVbNIE03qRVTclpwQCVJXaFmNVA3aCsiY183vmnwwIm
 G/2OvjBqdwvqV9v58vwTUoEUDuVzW9jEt7gyaQyylYKkwdGVsF
 0JtUGh9OWtnePOLKiWS9jCi9iLgK1WcHDR0Owz3uoO1p7mL8wG
 LHSYJ1L7wrlErHTd2epCPCVuRFNZXlAnAtosdoxHBKdiMT3/ui
 CC3kEADjOu5kZeJxk+gwWmyy6YhDZcky7kTHAF9UPzqDX1DBny
 i37Oe34vaHvHJ0FctbkQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2014 15:14:12 Peter Griffin wrote:

> > > > Depending on what kind of special requirements the ST version has,
> > > > this can be done either by using the generic ohci/ehci bindings
> > > > with extensions where necessary, or by creating a new binding and
> > > > new driver files that use 'ohci_init_driver'/'ehci_init_driver'
> > > > to inherit from the common code.
> > > > 
> > > > The first of the two approaches is preferred.
> > > 
> > > We don't have anything particularly special, just a couple of reset lines,
> > > clock, phy, etc.
> > 
> > Ok, good. Please see Documentation/devicetree/bindings/usb/usb-?hci.txt
> > then. You might actually be able to just use the existing drivers
> > without new code by just adding the proper DT nodes that follow these
> > bindings.
> 
> The only issues I can see with the generic versions are: -
> 1) We also have a powerdown line in addition to the reset line both of which are 
> exposed via reset controller API, so I would need to add that into ehci-platform
> and ohci-platform.

Ok, adding this would not be too hard.

> 2) We have a magic poke in st_ehci_configure_bus of the current driver to configure
> the AHB to ST bus protocol convertor IP. I'm not quite sure where I could hook that
> in (sorry... slightly pulling back on my "nothing special comment" a bit ;-).

Hmm, doing this would require adding some form of quirk, either by compatible
string or using an extra DT property for detection.

> 3) We also set the rate of the ohci clock, which the generic driver doesn't do.

Hmm, I guess this is the reason why sometimes it's nice to have names associated
with the clocks. The generic driver assumes that all clocks just need to be
turned on, and we decided not to use any naming when that binding was introduced.

Each of these seems solvable, but the combination of these sounds like it
would be better to create a new pair of drivers. I'd suggest you start by making
a copy of ohci-platform and removing everything you don't need, then add support
for the three things above. Give the clock a name, in case we want to merge the
drivers again later.

	Arnd
