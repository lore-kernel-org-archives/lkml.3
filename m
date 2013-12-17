Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab3LQSeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:34:03 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:4551 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab3LQSdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:33:49 -0500
Message-ID: <1387305222.8071.40.camel@ejdallLaptop>
Subject: Re: [PATCH] PCI AER: handle
 pci_cleanup_aer_uncorrect_error_status() in firmware first mode
From: Betty Dall <betty.dall@hp.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Tue, 17 Dec 2013 11:33:42 -0700
In-Reply-To: <CAErSpo5s7euqGvqg=W=_j=98eyPp1uk=Zw8gD1gif6A9h_BNpQ@mail.gmail.com>
References: <1386949306-30601-1-git-send-email-betty.dall@hp.com>
	 <CAErSpo4tswv8PHGOQDviFj6Rc7QMYkWQ5rhMCFmHZFL9jM6oBQ@mail.gmail.com>
	 <1386976612.10497.80.camel@ejdallLaptop>
	 <CAErSpo5s7euqGvqg=W=_j=98eyPp1uk=Zw8gD1gif6A9h_BNpQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-16 at 12:51 -0700, Bjorn Helgaas wrote:
> On Fri, Dec 13, 2013 at 4:16 PM, Betty Dall <betty.dall@hp.com> wrote:
> > On Fri, 2013-12-13 at 15:35 -0700, Bjorn Helgaas wrote:
> >> On Fri, Dec 13, 2013 at 8:41 AM, Betty Dall <betty.dall@hp.com> wrote:
> >> > There are three functions exported from aerdrv_core.c that could be
> >> > called when the system is in firmware first mode:
> >> > pci_enable_pcie_error_reporting(), pci_disable_pcie_error_reporting, and
> >> > pci_cleanup_aer_uncorrect_error_status(). The first two functions check if
> >> > we are in firmware first mode and return immediately.
> >> > pci_cleanup_aer_uncorrect_error_status() does not check firmware first
> >> > mode. The problem is that all of these functions should not access the AER
> >> > registers in firmware first mode because the firmware has not granted OS
> >> > control of the AER registers through the _OSC.
> >>
> >> This looks like a good fix to me.  If I read aer_acpi_firmware_first()
> >> correctly, we don't even *ask* for control of AER if
> >> ACPI_HEST_FIRMWARE_FIRST appears anywhere in the HEST.  Does that
> >> match your understanding?
> >
> > Yes, when the system is in firmware first mode the code setting the _OSC
> > control register does not ask for AER control.
> >
> >>
> >> > Many drivers call this
> >> > function in their pci_error_handlers in firmware first mode.
> >>
> >> Drivers don't have any idea whether their device is in firmware-first
> >> mode, do they?
> >
> > Right. And I think we want to keep it that way. Having this function is
> > a good thing so that the firmware first can be abstracted from the
> > drivers.
> >
> >>
> >> > The fix is to change pci_cleanup_aer_uncorrect_error_status() to check
> >> > firmware first mode before accessing the AER registers. If it is in firmware
> >> > first mode, return 0. I considered returning -EIO, but decided the status
> >> > has been cleaned up appropriately for firmware first. Returning 0 also avoids
> >> > an error message. Not many places check the return of this function, and the
> >> > ones that do, print an error message and continue such as:
> >> >    err = pci_cleanup_aer_uncorrect_error_status(pdev);
> >> >    if (err) {
> >> >        dev_err(&pdev->dev,
> >> >            "pci_cleanup_aer_uncorrect_error_status failed 0x%0x\n",
> >> >             err); /* non-fatal, continue */
> >> >    }
> >> > That error message is how I found this problem, and it is not applicable
> >> > for the firmware first recovery path.
> >>
> >> I'm curious -- did you find this problem because you saw a message
> >> when pci_cleanup_aer_uncorrect_error_status() returned failure?  The
> >> only way it can return failure is if there is no AER capability, and
> >> that should be completely independent of whether we're in
> >> firmware-first mode.
> >
> > Yes, I saw the error message during error injection testing and using a
> > firmware that denies access to AER control because it is firmware first.
> > You are right that it would only print out when there is no AER
> > capability. I was reading code looking for places that might access the
> > AER registers in firmware first mode. This is the only one I found.
> 
> I see why you added a pcie_aer_get_firmware_first() test, because
> that's what pci_enable_pcie_error_reporting() and
> pci_disable_pcie_error_reporting() do.
> 
> But I think we implemented the firmware-first stuff wrong by elevating
> the firmware-first concept to the arch-independent level.  The
> connection between this and the _OSC negotiation is pretty convoluted,
> even on x86.  It's hard to verify by reading the code that we avoid
> touching AER if we haven't asked for control or the BIOS declined to
> grant it.
> 
> I think it would be better if the pci_dev.__aer_firmware_first stuff
> were replaced by a more generic "can we use AER?" flag.  That flag
> should be set at device enumeration time, so we wouldn't need anything
> like the __aer_firmware_first_valid flag.
> 
> Bjorn

Hi Bjorn,

I see what you are saying about the interaction of firmware first and
_OSC AER control being convoluted. I will work on some patches to
address this. 

I am thinking about a new flag __aer_control_granted that would be set
if _OSC control is granted to the OS for AER. We already account for
firmware first in negotiate_os_control(). An new function
aer_control_granted(struct pci_dev) could be used instead of
pcie_aer_get_firmware_first() in functions like
pci_enable_pcie_error_reporting(), pci_disable_pcie_error_reporting(),
and pci_cleanup_aer_uncorrect_error_status(). 

Another idea is to put a check for aer_control_granted() in
pci_find_ext_capability() so that any driver requesting the AER extended
capability would not even get the capability pointer if AER control has
not been granted. 

-Betty

