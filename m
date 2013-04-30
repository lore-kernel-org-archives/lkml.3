Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab3D3Ot0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:49:26 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:47411
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932195Ab3D3OtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:49:22 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Id799hzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1155h)
X-WSS-ID: 0MM2P60-01-3V2-02
X-M-MSG: 
Message-ID: <517FD9E8.8070802@amd.com>
Date: Tue, 30 Apr 2013 09:49:12 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Don Dutile <ddutile@redhat.com>
CC: =?ISO-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: IOMMU/AMD: Error Handling
References: <517ECDDA.3000606@amd.com> <517ED3A9.2050508@redhat.com>
In-Reply-To: <517ED3A9.2050508@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/2013 3:10 PM, Don Dutile wrote:
> On 04/29/2013 03:45 PM, Suravee Suthikulanit wrote:
>> Joerg,
>>
>> We are in the process of implementing AMD IOMMU error handling, and I 
>> would like some comments from you and the community.
>>
>> Currently, the AMD IOMMU driver only reports events from the event 
>> log in the dmesg, and does not try to handle them in case of errors. 
>> AMD IOMMU errors can be categorized as device-specific errors and 
>> IOMMU errors.
>>
>> 1. For IOMMU errors such as:
>> - DEV_TAB_HADWARE_ERROR
>> - PAGE_TAB_ERROR
>> - COMMAND_HARDWARE_ERROR
>> If the error is detected during IOMMU initialization, we could 
>> disable IOMMU and proceed. If the error occurs after IOMMU is 
>> initialized, we won't be able to recover from this, and might need to 
>> result in panic.
>>
>> 2. For device-specific errors such as:
>> - ILLEGAL_DEV_TABLE_ENTRY
>> - IO_PAGE_FAULT
>> - INVALDE_DEVICE_REQUEST
>> We think the AMD IOMMU driver should try to isolate the device. This 
>> involves blocking device transactions at IOMMU DTE and tries to 
>> disable the device (e.g. calling the remove(struct pci_dev *pdev) 
>> interface generally provides by device drivers). This could prevents 
>> the device from continuing to fail and to risk of system instability.
>>
> disabling the device is not an option.
> We've seen mis-configured ACPI tables generate storms
> of invalide dte messages after iommu setup but before they are cleared 
> up when
> the OS driver is started & resets the device. The original storm is 
> from bios-use
> of IOMMU with a device.
Would some sorts of threshold to help determine the badness of errors 
might be sufficient? For instance, if the device has generated N errors, 
it is then be removed (where N is tunable through sysfs or kernel boot 
options).

> I'd recommend creating a filter that prevents further logging from a 
> device
> for 5 mins at a time if a storm of DTE-related errors are seen.
> by definition, the DMA is blocked from corrupting/changing memory, so 
> isolation has been established;
> keeping the failure log from consuming the system is the needed fix.

I believe the IOMMU hardware can be configured to suppress logging of subsequent I/O page fault errors until
the device table cache is cleared.  This should help avoiding storm of interrupts you are seeing.

>
>> 3. In case of posted memory write transaction, device driver might 
>> not be aware that the transaction has failed and blocked at IOMMU. If 
>> there is no HW IOMMU, I believe this is handled by PCI error handling 
>> code. If the IOMMU hardware reporth such case, could this potentially 
>> leverage the Linux IOMMU fault handling interface, 
>> iommu_set_fault_handler() and report_iommu_fault(), to communicate to 
>> device driver or PCI driver?
>>
> Wondering if you could use AER-like callback mechanism so a driver can 
> be invoked when IOMMU error occurs,
> so the device driver can quiesce or reset the device if it deems it 
> transient.
That might also be possible. I might need to look into it more.

Suravee
>
>> Any feedback or comments are appreciated.
>>
>> Thank you,
>> Suravee
>>
>>
>>
>>
>> _______________________________________________
>> iommu mailing list
>> iommu@lists.linux-foundation.org
>> https://lists.linuxfoundation.org/mailman/listinfo/iommu
>
>


