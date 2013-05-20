Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab3ETOiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:38:25 -0400
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:14927 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab3ETOiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:38:23 -0400
From: "Liu, Joseph" <Joseph.Liu@Emulex.Com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        "Zhang, LongX" <longx.zhang@intel.com>
CC: "linasvepstas@gmail.com" <linasvepstas@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: RE: Subject : [ PATCH ]
 pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
Thread-Topic: Subject : [ PATCH ]
 pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
Thread-Index: Ac5CQUdmhbSX64FbRraxMqZGOLGlLwABCDYwBFNm5oAAc1aO8A==
Date: Mon, 20 May 2013 14:38:21 +0000
Message-ID: <CF6E51640088844D9CADE5541A7C2FEB33EBC11D@CMEXMB1.ad.emulex.com>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
 <CAErSpo7+AbHi_TwxwHTJunpFb=CMhwMdCni6+NjbhdA=35XhvA@mail.gmail.com>
In-Reply-To: <CAErSpo7+AbHi_TwxwHTJunpFb=CMhwMdCni6+NjbhdA=35XhvA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [138.239.74.55]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn,

I have been working with the low level device drivers for supporting both EEH and AER and were involved in working with Yanmin for verifying this AER patch. Please see some of my responses to your questions inline, prefixed with [jzl]. 


Thanks,
Joe Liu, Ph.D.
Senior Principal Engineer
Emulex Corporation

-----Original Message-----
From: Bjorn Helgaas [mailto:bhelgaas@google.com] 
Sent: Friday, May 17, 2013 7:44 PM
To: Zhang, LongX
Cc: linasvepstas@gmail.com; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; yanmin_zhang@linux.intel.com; Liu, Joseph; Rafael J. Wysocki
Subject: Re: Subject : [ PATCH ] pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset

[+cc Rafael because he knows about dev->state_saved]

Sorry, I'm not very familiar with AER, so please excuse some naive
questions below.

On Fri, Apr 26, 2013 at 12:28 AM, Zhang, LongX <longx.zhang@intel.com> wrote:
> From: Zhang Long <longx.zhang@intel.com>
>
> Specific pci device drivers might have many functions to call
> pci_channel_offline to check device states. When slot_reset happens,
> drivers' slot_reset callback might call such functions and eventually
> abort the reset.

|Where does this happen?  I looked at all the references to
|dev->error_state and all the callers of pci_channel_offline(), and I
|didn't see any in .slot_reset() methods.
|
|(There are *assignments* to dev->error_state in qlcnic_attach_func(),
|qlge_io_slot_reset(), and qla2xxx_pci_slot_reset().  You might be able
|to remove those assignments after this patch, but this patch wouldn't
|really change anything for those paths.)

[jzl] Although low level driver might not call pci_channel_offline() directly in .slot_reset() method itself, it does not mean it will not call it during the device error recovery execution of .slot_reset() method. The .slot_reset() method needs to call some of its bottom layer routines interfacing with device PCI interface for preparing the PCI device from recovery of PCI error (EEH or AER). As a matter of fact, it seems that qla2xxx_pci_slot_reset() routine's assignments to dev->error was an attempt to work around this AER driver issue that this patch is trying to resolve. From upstream kernel 3.9.2's qla2xxx_pci_slot_reset(), it has the assignment and comment below:

static pci_ers_result_t
qla2xxx_pci_slot_reset(struct pci_dev *pdev)
{
        pci_ers_result_t ret = PCI_ERS_RESULT_DISCONNECT;
        scsi_qla_host_t *base_vha = pci_get_drvdata(pdev);
        struct qla_hw_data *ha = base_vha->hw;
        struct rsp_que *rsp;
        int rc, retries = 10;

        ql_dbg(ql_dbg_aer, base_vha, 0x9004,
            "Slot Reset.\n");

        /* Workaround: qla2xxx driver which access hardware earlier
         * needs error state to be pci_channel_io_online.
         * Otherwise mailbox command timesout.
         */
        pdev->error_state = pci_channel_io_normal;



> The patch resets pdev->error_state to pci_channel_io_normal at
> the begining of report_slot_reset.

> Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> Signed-off-by: Zhang Long <longx.zhang@intel.com>
> ---
>  drivers/pci/pcie/aer/aerdrv_core.c |    1 +
>  drivers/pci/pcie/portdrv_pci.c     |   12 +++++-------
>  2 files changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
> index 564d97f..c61fd44 100644
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -286,6 +286,7 @@ static int report_slot_reset(struct pci_dev *dev, void *data)
>         result_data = (struct aer_broadcast_data *) data;
>
>         device_lock(&dev->dev);
> +       dev->error_state = pci_channel_io_normal;

|The device's error_state might be pci_channel_io_frozen when we get
|here.  We haven't touched anything in the hardware yet.  What makes
|the device unfrozen now?  Did anything actually change as far as the
|hardware device is concerned?

[jzl] When the AER driver gets to invoking report_slot_reset(), it has already performed PCI slot reset. Currently, with PCIe, it is the PCIe link reset it has been performed. But with proper AER driver implementation, it should be either PCI slot hot reset or even fundamental reset that has already been performed. As such, after platform performing the PCI slot reset, it should move the device's error_state out of pci_channel_io_fronzen before calling report_slot_reset() to low level device drivers allows them to access the corresponding device's PCI function in preparation for recovery.


|I agree it looks like report_slot_reset() should be made more like
|eeh_report_reset().  I'm just wondering if the error_state should be
|changed *after* calling the .slot_reset() method instead of before.

[jzl] No, you should not set the error_state after calling the .slot_reset() method because the AER driver calling the low level driver's .slot_reset() method is to "report" that the platform PCI slot reset has been done and "inform" the low level driver to prepare the PCI device for recovering, with which the low level driver might need to, for example, further perform reset on PCI functions with the deivice. The .slot_reset() is call by function, changing the error_state *after* calling the .slot_reset() method will be too late for the low level device to access PCI device from within the  .slot_reset() function call...

[jzl] Also, this is not just the eeh_report_reset() behavior, it is PCI error recovery behavior. In the pci-error-recovery.txt, it stated the following under "STEP 4 Slot Reset":

"...
This call gives drivers the chance to re-initialize the hardware
(re-download firmware, etc.).  At this point, the driver may assume
that the card is in a fresh state and is fully functional. The slot
is unfrozen and the driver has full access to PCI config space,
memory mapped I/O space and DMA. Interrupts (Legacy, MSI, or MSI-X)
will also be available.
..."


>         if (!dev->driver ||
>                 !dev->driver->err_handler ||
>                 !dev->driver->err_handler->slot_reset)
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index ed4d094..7abefd9 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -332,13 +332,11 @@ static pci_ers_result_t pcie_portdrv_slot_reset(struct pci_dev *dev)
>         pci_ers_result_t status = PCI_ERS_RESULT_RECOVERED;
>         int retval;
>
> -       /* If fatal, restore cfg space for possible link reset at upstream */
> -       if (dev->error_state == pci_channel_io_frozen) {
> -               dev->state_saved = true;
> -               pci_restore_state(dev);
> -               pcie_portdrv_restore_config(dev);
> -               pci_enable_pcie_error_reporting(dev);
> -       }

Previously we only restored state for the pci_channel_io_frozen state,
i.e., when handling an AER_FATAL error.  Now we restore it always.
Why?

> +       /* restore cfg space for possible link reset at upstream */
> +       dev->state_saved = true;

"dev->state_saved == true" means that the dev->saved_config_space
contains valid data.  Why do we know that's the case here?  I see that
pcie_portdrv_probe() calls pci_save_state() when we first claim the
port, and I guess we're assuming the state saved then is still valid.
But why do we need to actually set dev->state_saved here?  Shouldn't
it be already set to true anyway?

> +       pci_restore_state(dev);
> +       pcie_portdrv_restore_config(dev);
> +       pci_enable_pcie_error_reporting(dev);
>
>         /* get true return value from &status */
>         retval = device_for_each_child(&dev->dev, &status, slot_reset_iter);
> --
> 1.7.4.1
>
>
>
