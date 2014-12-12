Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968145AbaLLOew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 09:34:52 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49281 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S967727AbaLLOeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 09:34:50 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [GIT PULL] ACPI and power management updates for 3.19-rc1
Date: Fri, 12 Dec 2014 15:56:27 +0100
Message-ID: <2077616.2azHLLCLOp@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1589257.Va5eEYbcUY@vostro.rjw.lan>
References: <CAJZ5v0i3UhvaAu9JV_BuB0fPFmHAa_NdX+eXYBnAHcsiaVOw9g@mail.gmail.com> <CA+55aFx+8gKsDSDKSAxB4+JuL_M22uuHDmzSfsv1qJ=dSZ3-ww@mail.gmail.com> <1589257.Va5eEYbcUY@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 12, 2014 03:42:07 PM Rafael J. Wysocki wrote:
> On Thursday, December 11, 2014 07:59:20 PM Linus Torvalds wrote:
> > On Mon, Dec 8, 2014 at 4:21 PM, Rafael J. Wysocki <rafael@kernel.org> wrote:
> > >
> > > Also the ACPI core is now going to support the _DEP configuration
> > > information in a limited way.
> > 
> > Hmm. That seems to be the cause of this annoying new message:
> > 
> >     ...
> >     ACPI: Using IOAPIC for interrupt routing
> >     PCI: Using host bridge windows from ACPI; if necessary, use
> > "pci=nocrs" and report a bug
> >     ACPI: [Package] has zero elements (ffff88040ccdb200)
> >     acpi LNXCPU:00: Failed to evaluate _DEP.
> >     ACPI: [Package] has zero elements (ffff88040ccdb200)
> >     acpi LNXCPU:01: Failed to evaluate _DEP.
> >     ACPI: [Package] has zero elements (ffff88040ccdb200)
> >     acpi LNXCPU:02: Failed to evaluate _DEP.
> >     ACPI: [Package] has zero elements (ffff88040ccdb200)
> >     acpi LNXCPU:03: Failed to evaluate _DEP.
> >     ACPI: [Package] has zero elements (ffff88040ccdb200)
> >     acpi LNXCPU:04: Failed to evaluate _DEP.
> >     ACPI: [Package] has zero elements (ffff88040ccdb200)
> >     acpi LNXCPU:05: Failed to evaluate _DEP.
> >     ACPI: [Package] has zero elements (ffff88040ccdb200)
> >     acpi LNXCPU:06: Failed to evaluate _DEP.
> >     ACPI: [Package] has zero elements (ffff88040ccdb200)
> >     acpi LNXCPU:07: Failed to evaluate _DEP.
> >     ACPI: [Package] has zero elements (ffff88040ccdb840)
> >     acpi device:27: Failed to evaluate _DEP.
> >     ACPI: [Package] has zero elements (ffff88040ccdb840)
> >     acpi device:3f: Failed to evaluate _DEP.
> >     ACPI: [Package] has zero elements (ffff88040ccdb8c0)
> >     acpi LNXVIDEO:00: Failed to evaluate _DEP.
> >     ACPI: Power Resource [FN00] (off)
> >     ...
> > 
> > which doesn't seem to hinder anything from working, but is extremely
> > annoying because it's printed out as some super-important "KERN_ERR
> > message of Doom!"
> > 
> > I don't see why incomplete ACPI tables would *ever* be "KERN_ERR"
> > level messages, but I particularly don't see it when it seems to be
> > our own meaningless fake entries.
> 
> Right the KERN_ERR level in there is silly.  Overlooked in review, sorry
> about that.  The patch below should take care of it.
> 
> Some of the messages you're seeing are from acpi_evaluate_reference(),
> though, and are not really useful too.  I'll cut a separate patch for
> these.

This:

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / utils: Drop error messages from acpi_evaluate_reference()

Some of the error messages printed by acpi_evaluate_reference()
with the KERN_ERR priority should really be debug messages, but then
they would be redundant, because acpi_util_eval_error() is called
too at the same spots (except for one).

Drop the kernel messages from there entirely and leave the
acpi_util_eval_error() to take care of the debug printing.  In one case,
replace the kernel message with a call to acpi_util_eval_error().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/utils.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

Index: linux-pm/drivers/acpi/utils.c
===================================================================
--- linux-pm.orig/drivers/acpi/utils.c
+++ linux-pm/drivers/acpi/utils.c
@@ -346,22 +346,16 @@ acpi_evaluate_reference(acpi_handle hand
 	package = buffer.pointer;
 
 	if ((buffer.length == 0) || !package) {
-		printk(KERN_ERR PREFIX "No return object (len %X ptr %p)\n",
-			    (unsigned)buffer.length, package);
 		status = AE_BAD_DATA;
 		acpi_util_eval_error(handle, pathname, status);
 		goto end;
 	}
 	if (package->type != ACPI_TYPE_PACKAGE) {
-		printk(KERN_ERR PREFIX "Expecting a [Package], found type %X\n",
-			    package->type);
 		status = AE_BAD_DATA;
 		acpi_util_eval_error(handle, pathname, status);
 		goto end;
 	}
 	if (!package->package.count) {
-		printk(KERN_ERR PREFIX "[Package] has zero elements (%p)\n",
-			    package);
 		status = AE_BAD_DATA;
 		acpi_util_eval_error(handle, pathname, status);
 		goto end;
@@ -380,17 +374,13 @@ acpi_evaluate_reference(acpi_handle hand
 
 		if (element->type != ACPI_TYPE_LOCAL_REFERENCE) {
 			status = AE_BAD_DATA;
-			printk(KERN_ERR PREFIX
-				    "Expecting a [Reference] package element, found type %X\n",
-				    element->type);
 			acpi_util_eval_error(handle, pathname, status);
 			break;
 		}
 
 		if (!element->reference.handle) {
-			printk(KERN_WARNING PREFIX "Invalid reference in"
-			       " package %s\n", pathname);
 			status = AE_NULL_ENTRY;
+			acpi_util_eval_error(handle, pathname, status);
 			break;
 		}
 		/* Get the  acpi_handle. */

