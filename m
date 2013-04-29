Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab3D2Wba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:31:30 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:8228
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932104Ab3D2WbN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:31:13 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VPS-6(zzbb2dI98dI9371I542I1432Id799h4015Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1155h)
X-WSS-ID: 0MM1FVS-02-89K-02
X-M-MSG: 
From: "Duran, Leo" <leo.duran@amd.com>
To: Don Dutile <ddutile@redhat.com>
CC: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: RFC: IOMMU/AMD: Error Handling
Thread-Topic: RFC: IOMMU/AMD: Error Handling
Thread-Index: AQHORRWeuhKC5XGAWkuVUXDfWnc9a5jtpxpwgABnawD//7GiIA==
Date: Mon, 29 Apr 2013 22:31:05 +0000
Message-ID: <BA42942F2D0DED45AFB0A6216D1E951D44CBE463@sausexdag01.amd.com>
References: <517ECDDA.3000606@amd.com> <517ED3A9.2050508@redhat.com>
 <BA42942F2D0DED45AFB0A6216D1E951D44CBE1F9@sausexdag01.amd.com>
 <517EE940.8010005@redhat.com>
In-Reply-To: <517EE940.8010005@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.236.49.48]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see... I suppose the trick is going to be how to 'filter' this non intended behavior (once, during OS boot).
Thanks,
Leo.

> -----Original Message-----
> From: Don Dutile [mailto:ddutile@redhat.com]
> Sent: Monday, April 29, 2013 4:42 PM
> To: Duran, Leo
> Cc: Suthikulpanit, Suravee; iommu@lists.linux-foundation.org; linux-
> kernel@vger.kernel.org
> Subject: Re: RFC: IOMMU/AMD: Error Handling
> 
> On 04/29/2013 04:34 PM, Duran, Leo wrote:
> > I'm wondering if resetting the IOMMU at init-time (once) would clear any
> BIOS induced noise.
> > Leo
> >
> Well, depends what you mean by 'reset'....
> (a) setting it up for OS use is effectively a reset, but doesn't quiesce a device
>       doing dma reads of a (bios-setup) queue.  then the noisy messages begin
> (b) disable the iommu, and then the dma just occurs... and bad for writes,
> potentially.
> 
> Similar issue is being reported & worked for kdump, where device are still
> doing DMA while the system is trying to 'reset' to the kexec'd kernel, and
> take a crash dump.
> 
> Solution: stop devices from doing dma... but some you _want_ enabled
> throughout...
>            like keyboard & mouse via usb controller, so you get to pick os from
>            grub...  not so for kexec...
> 
> so, again, for isolation faults.... let the hw do its job -- isolate and
> throttle/silence the fault messages on a per-device, time-duration heuristic
> so the system can get through boot-up where enough OS is init'd (drivers
> started) to stop the temporary noise.
> 
> >> -----Original Message-----
> >> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> >> bounces@lists.linux-foundation.org] On Behalf Of Don Dutile
> >> Sent: Monday, April 29, 2013 3:10 PM
> >> To: Suthikulpanit, Suravee
> >> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> >> Subject: Re: RFC: IOMMU/AMD: Error Handling
> >>
> >> On 04/29/2013 03:45 PM, Suravee Suthikulanit wrote:
> >>> Joerg,
> >>>
> >>> We are in the process of implementing AMD IOMMU error handling, and
> >>> I
> >> would like some comments from you and the community.
> >>>
> >>> Currently, the AMD IOMMU driver only reports events from the event
> >>> log
> >> in the dmesg, and does not try to handle them in case of errors. AMD
> >> IOMMU errors can be categorized as device-specific errors and IOMMU
> >> errors.
> >>>
> >>> 1. For IOMMU errors such as:
> >>> - DEV_TAB_HADWARE_ERROR
> >>> - PAGE_TAB_ERROR
> >>> - COMMAND_HARDWARE_ERROR
> >>> If the error is detected during IOMMU initialization, we could
> >>> disable
> >> IOMMU and proceed. If the error occurs after IOMMU is initialized, we
> >> won't be able to recover from this, and might need to result in panic.
> >>>
> >>> 2. For device-specific errors such as:
> >>> - ILLEGAL_DEV_TABLE_ENTRY
> >>> - IO_PAGE_FAULT
> >>> - INVALDE_DEVICE_REQUEST
> >>> We think the AMD IOMMU driver should try to isolate the device. This
> >> involves blocking device transactions at IOMMU DTE and tries to
> >> disable the device (e.g. calling the remove(struct pci_dev *pdev)
> >> interface generally provides by device drivers). This could prevents
> >> the device from continuing to fail and to risk of system instability.
> >>>
> >> disabling the device is not an option.
> >> We've seen mis-configured ACPI tables generate storms of invalide dte
> >> messages after iommu setup but before they are cleared up when the OS
> >> driver is started&  resets the device. The original storm is from
> >> bios-use of IOMMU with a device.
> >> I'd recommend creating a filter that prevents further logging from a
> >> device for 5 mins at a time if a storm of DTE-related errors are seen.
> >> by definition, the DMA is blocked from corrupting/changing memory, so
> >> isolation has been established; keeping the failure log from
> >> consuming the system is the needed fix.
> >>
> >>> 3. In case of posted memory write transaction, device driver might
> >>> not be
> >> aware that the transaction has failed and blocked at IOMMU. If there
> >> is no HW IOMMU, I believe this is handled by PCI error handling code.
> >> If the IOMMU hardware reporth such case, could this potentially
> >> leverage the Linux IOMMU fault handling interface,
> >> iommu_set_fault_handler() and report_iommu_fault(), to communicate
> to device driver or PCI driver?
> >>>
> >> Wondering if you could use AER-like callback mechanism so a driver
> >> can be invoked when IOMMU error occurs, so the device driver can
> >> quiesce or reset the device if it deems it transient.
> >>
> >>
> >>> Any feedback or comments are appreciated.
> >>>
> >>> Thank you,
> >>> Suravee
> >>>
> >>>
> >>>
> >>>
> >>> _______________________________________________
> >>> iommu mailing list
> >>> iommu@lists.linux-foundation.org
> >>> https://lists.linuxfoundation.org/mailman/listinfo/iommu
> >>
> >> _______________________________________________
> >> iommu mailing list
> >> iommu@lists.linux-foundation.org
> >> https://lists.linuxfoundation.org/mailman/listinfo/iommu
> >
> >
> 


