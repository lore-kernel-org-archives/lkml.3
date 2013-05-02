Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab3EBRaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:30:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51369 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753432Ab3EBRaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:30:19 -0400
Date: Thu, 2 May 2013 13:30:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-kernel@vger.kernel.org, <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH, RFC 16/22] USB: UHCI: clarify Kconfig dependencies
In-Reply-To: <1367507786-505303-17-git-send-email-arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1305021304500.1436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Arnd Bergmann wrote:

> The UHCI driver currently gives a build error if the base driver is
> enabled but none of the three bus glues are turned on:
> 
> drivers/usb/host/uhci-hcd.c:857:2: error: #error "missing bus glue for uhci-hcd"
> 
> A better solution for this is to change the Kconfig statements to
> prevent getting into this situation. This adds a new USB_UHCI_CORE
> symbol in Kconfig, which is selected by each of the three bus glues.
> This way, the driver never gets built if all three of them are disabled.

I had already worked out a patch on my own for this (below).  It is
different from yours in several ways:

	It relies more on "depends" than "select".  I don't know how 
	important this is in the end.

	It doesn't add a new USB_UHCI_GRLIB symbol; instead it uses
	SPARC_LEON in several places.  I tend to think the new symbol
	is nicer.

	It doesn't add a new USB_UHCI_PCI symbol.

	It improves the dependency list for USB_UHCI_HCD.

	It removes the help text for USB_UHCI_PLATFORM, thereby making
	that symbol not user-configurable.  I don't see any reason why
	the user should need to worry about this -- the choice should
	be a very simple one: build UHCI support or don't build it.  If
	the user chooses to build it then it should include support for
	all the compatible bus glues.  (This last decision may need to 
	be changed if more bus glues get added.)

	It prevents situations where USB_UHCI_HCD is enabled but the
	driver doesn't get built.

	It creates a bunch of USB_UHCI_* symbols even when USB_UHCI_HCD
	is disabled.  This is a disadvantage, but I don't see any way
	around it.  Basically, we have to consider two separate but
	related questions:

		Does the supported hardware configuration allow for 
		UHCI?

		Which types of UHCI bus glue support should be included 
		in the kernel?

	If the answer to the first is Yes then creating these symbols
	seems unavoidable, even when the answer to the second is None.

Maybe the ideal solution is some sort of combination of the two
patches.

What do you think of my patch as compared to yours?  And what do you
think of the "depends" vs. "select" issue?

Alan Stern



Index: usb-3.9/drivers/usb/host/Kconfig
===================================================================
--- usb-3.9.orig/drivers/usb/host/Kconfig
+++ usb-3.9/drivers/usb/host/Kconfig
@@ -507,7 +507,7 @@ endif # USB_OHCI_HCD
 
 config USB_UHCI_HCD
 	tristate "UHCI HCD (most Intel and VIA) support"
-	depends on PCI || SPARC_LEON || ARCH_VT8500
+	depends on PCI || USB_UHCI_SUPPORT_NON_PCI_HC
 	---help---
 	  The Universal Host Controller Interface is a standard by Intel for
 	  accessing the USB hardware in the PC (which is also called the USB
@@ -524,26 +524,19 @@ config USB_UHCI_HCD
 
 config USB_UHCI_SUPPORT_NON_PCI_HC
 	bool
-	depends on USB_UHCI_HCD
-	default y if (SPARC_LEON || ARCH_VT8500)
+	default y if (SPARC_LEON || USB_UHCI_PLATFORM)
 
 config USB_UHCI_PLATFORM
-	bool "Generic UHCI Platform Driver support"
-	depends on USB_UHCI_SUPPORT_NON_PCI_HC
+	bool
 	default y if ARCH_VT8500
-	---help---
-	  Enable support for generic UHCI platform devices that require no
-	  additional configuration.
 
 config USB_UHCI_BIG_ENDIAN_MMIO
 	bool
-	depends on USB_UHCI_SUPPORT_NON_PCI_HC && SPARC_LEON
-	default y
+	default y if SPARC_LEON
 
 config USB_UHCI_BIG_ENDIAN_DESC
 	bool
-	depends on USB_UHCI_SUPPORT_NON_PCI_HC && SPARC_LEON
-	default y
+	default y if SPARC_LEON
 
 config USB_FHCI_HCD
 	tristate "Freescale QE USB Host Controller support"


