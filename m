Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab3LMXQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 18:16:59 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:25762 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab3LMXQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 18:16:58 -0500
Message-ID: <1386976612.10497.80.camel@ejdallLaptop>
Subject: Re: [PATCH] PCI AER: handle
 pci_cleanup_aer_uncorrect_error_status() in firmware first mode
From: Betty Dall <betty.dall@hp.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Fri, 13 Dec 2013 16:16:52 -0700
In-Reply-To: <CAErSpo4tswv8PHGOQDviFj6Rc7QMYkWQ5rhMCFmHZFL9jM6oBQ@mail.gmail.com>
References: <1386949306-30601-1-git-send-email-betty.dall@hp.com>
	 <CAErSpo4tswv8PHGOQDviFj6Rc7QMYkWQ5rhMCFmHZFL9jM6oBQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-13 at 15:35 -0700, Bjorn Helgaas wrote:
> On Fri, Dec 13, 2013 at 8:41 AM, Betty Dall <betty.dall@hp.com> wrote:
> > There are three functions exported from aerdrv_core.c that could be
> > called when the system is in firmware first mode:
> > pci_enable_pcie_error_reporting(), pci_disable_pcie_error_reporting, and
> > pci_cleanup_aer_uncorrect_error_status(). The first two functions check if
> > we are in firmware first mode and return immediately.
> > pci_cleanup_aer_uncorrect_error_status() does not check firmware first
> > mode. The problem is that all of these functions should not access the AER
> > registers in firmware first mode because the firmware has not granted OS
> > control of the AER registers through the _OSC.
> 
> This looks like a good fix to me.  If I read aer_acpi_firmware_first()
> correctly, we don't even *ask* for control of AER if
> ACPI_HEST_FIRMWARE_FIRST appears anywhere in the HEST.  Does that
> match your understanding?

Yes, when the system is in firmware first mode the code setting the _OSC
control register does not ask for AER control. 

> 
> > Many drivers call this
> > function in their pci_error_handlers in firmware first mode.
> 
> Drivers don't have any idea whether their device is in firmware-first
> mode, do they?

Right. And I think we want to keep it that way. Having this function is
a good thing so that the firmware first can be abstracted from the
drivers.

> 
> > The fix is to change pci_cleanup_aer_uncorrect_error_status() to check
> > firmware first mode before accessing the AER registers. If it is in firmware
> > first mode, return 0. I considered returning -EIO, but decided the status
> > has been cleaned up appropriately for firmware first. Returning 0 also avoids
> > an error message. Not many places check the return of this function, and the
> > ones that do, print an error message and continue such as:
> >    err = pci_cleanup_aer_uncorrect_error_status(pdev);
> >    if (err) {
> >        dev_err(&pdev->dev,
> >            "pci_cleanup_aer_uncorrect_error_status failed 0x%0x\n",
> >             err); /* non-fatal, continue */
> >    }
> > That error message is how I found this problem, and it is not applicable
> > for the firmware first recovery path.
> 
> I'm curious -- did you find this problem because you saw a message
> when pci_cleanup_aer_uncorrect_error_status() returned failure?  The
> only way it can return failure is if there is no AER capability, and
> that should be completely independent of whether we're in
> firmware-first mode.

Yes, I saw the error message during error injection testing and using a
firmware that denies access to AER control because it is firmware first.
You are right that it would only print out when there is no AER
capability. I was reading code looking for places that might access the
AER registers in firmware first mode. This is the only one I found.

-Betty

> 
> > Signed-off-by: Betty Dall <betty.dall@hp.com>
> > ---
> >
> >  drivers/pci/pcie/aer/aerdrv_core.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> >
> >
> > diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
> > index b2c8881..1f60408 100644
> > --- a/drivers/pci/pcie/aer/aerdrv_core.c
> > +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> > @@ -62,6 +62,9 @@ int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
> >         int pos;
> >         u32 status;
> >
> > +       if (pcie_aer_get_firmware_first(dev))
> > +               return 0;
> > +
> >         pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
> >         if (!pos)
> >                 return -EIO;


