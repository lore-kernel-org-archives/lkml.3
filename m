Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab3FJRZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:25:15 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:60177 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab3FJRZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:25:11 -0400
MIME-Version: 1.0
In-Reply-To: <1370500156.4432.32.camel@ymzhang.sh.intel.com>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
 <20130520224824.GA31740@google.com> <CF6E51640088844D9CADE5541A7C2FEB33EBE413@CMEXMB1.ad.emulex.com>
 <CAErSpo4kvEkUtYFXnoE8yDnHsUD8Z6EUrKaXaJ=yy4yMcJ0veA@mail.gmail.com>
 <CAErSpo5OMuW_fg4DYAqg=xcY8USDhC89Mgt66BwoSzss41UKMQ@mail.gmail.com>
 <1370392712.4432.27.camel@ymzhang.sh.intel.com> <CAErSpo743raREgO4zJL0pONZyOTDBy7qLX9UZzCyRsLjBD31gQ@mail.gmail.com>
 <1370500156.4432.32.camel@ymzhang.sh.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 10 Jun 2013 11:24:50 -0600
Message-ID: <CAErSpo7dS0OFrs1cWrOqz9M1z=6wC9h_+Js01cJC1An-Ae=Ztw@mail.gmail.com>
Subject: Re: Subject : [ PATCH ] pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
To: "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Cc: "Liu, Joseph" <Joseph.Liu@emulex.com>,
        "Zhang, LongX" <longx.zhang@intel.com>,
        "linasvepstas@gmail.com" <linasvepstas@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I opened https://bugzilla.kernel.org/show_bug.cgi?id=59531 for this issue.

Unfortunately, I don't have an army of minions to assign things like this to.

It's easy to change the dev state from frozen to normal before calling
the slot_reset() callback, but we first have to unravel what that
means for pcie_portdrv_slot_reset(), which restores the device state
if it is frozen.

Bjorn

On Thu, Jun 6, 2013 at 12:29 AM, Yanmin Zhang
<yanmin_zhang@linux.intel.com> wrote:
> On Wed, 2013-06-05 at 07:30 -0600, Bjorn Helgaas wrote:
>> On Tue, Jun 4, 2013 at 6:38 PM, Yanmin Zhang
>> <yanmin_zhang@linux.intel.com> wrote:
>> > On Tue, 2013-06-04 at 12:04 -0600, Bjorn Helgaas wrote:
>> >> I'm not sure where we are with this patch.  I think Joseph initially
>> >> reported a problem (though I haven't actually seen that), and this
>> >> patch fixed it, so it seems like there's something we want to do here.
>> > Yes, indeed. We checked Powerpc error handling and plan to use the
>> > similar method to deal with the issue.
>> >
>> > Sorry for replying very late. I move to Android smartphone area and am
>> > very busy on many top issues.
>>
>> OK.  Can you point us at a bugzilla or email archive of Joseph's
>> original problem report, or post it to this thread?  Then maybe
>> somebody else can pick it up and make progress on this.
>
> Joseph sent email to my outlook emailbox. I changed it a little to delete company
> sensitive product name.
>
> ===========================Joseph's original email to me================
> Hi Tom and Yanmin,
>
> Hope this email can reach you well. I am working on a driver's PCI error recovery with AER. I have a question with one of my observations from platform AER driver's behavior. As your names and emails are listed to the PCIe AER driver coming with the kernel, I send this question to you:
>
> During injecting AER Non-Correctable/Fatal error and PCIe error recovery process, I observed the following from our Low Level Driver (LLD):
>
> 1. The LLD's error_detected() callback got called and the PCI channel state passed in as "pci_channel_io_frozen", as expected;
>
> 2. The LLD's error_detected() callback function returned with PCI_ERS_RESULT_NEED_RESET, requesting a PCI slot reset;
>
> 3. The LLD's slot_reset() callback got called and it attempted to re-initialize the device hardware for the recovery. However, the PCI slot state was still in "pci_channel_io_frozen" and the pci_channel_offline() helper routine returned 1. This is not expected, and it actually prevented LLD in performing needed access to memory mapped I/O space for preparing the device for recovery;
>
> 4. Later, the LLD's resume() callback got called and the PCI slot state was set to "pci_channel_io_normal";
>
> In the upstream Linux kernel 3.7.0's pci-error-recovery.txt, "STEP 4 Slot Reset", it stated after platform has performed PCI slot reset and then calls LLD's slot_reset() callback:
>
> "This call gives drivers the chance to re-initialize the hardware (re-download firmware, etc.).  At this point, the driver may assume that the card is in a fresh state and is fully functional. The slot is unfrozen and the driver has full access to PCI config space, memory mapped I/O space and DMA. Interrupts (Legacy, MSI, or MSI-X) will also be available."
>
> I looked into the kernel 3.7.0's AER driver's aerdrv_core.c and see that the PCI slot state was set to "pci_channel_io_frozen" on AER_FATAL serverity, and only set back to "pci_channel_io_normal" in report_resume() function. The PCI slot state was not set to "pci_channel_io_normal" when invoking report_slot_reset().
>
> As a comparison, I also perform the EEH error recovery with the LLD driver on a PPC platform, which indeed set the PCI slot state to "pci_channel_io_normal" when calling LLD's slot_reset() callback function.
>
> Can you please verify this platform AER driver's behavior is intended and will stay with the AER platform support, or it should be changed to be consistent with the PCI error recovery procedure described in the pci-error-recovery.txt documentation? I also noticed that before invoking the broadcast_error_message() function with "slot_reset", there is a comment in the 3.7.0 kernel source:
>
> /*
>  * TODO: Should call platform-specific
>  * functions to reset slot before calling
>  * drivers' slot_reset callbacks?
>  */
> And I do see that only the PCIe Link_Reset was performed, no PCI fundamental reset was performed even the LLD set the PCIe device's "pdev->needs_freset = 1", is this the area that later will be added for performing needed PCI hot reset or fundamental reset at this stage?
>
> Your timely response is very appreciated. Thanks in advance and please let me know if you think I should redirect the question to someone else.
>
> Best Regards,
> Joseph Liu, Ph.D.
> Senior Principal Engineer
> Emulex Corporation
>
>
