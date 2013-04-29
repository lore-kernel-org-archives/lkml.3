Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab3D2Tpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:45:51 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:25530
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761078Ab3D2Tpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:45:49 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzd799hzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1155h)
X-WSS-ID: 0MM187T-02-00U-02
X-M-MSG: 
Message-ID: <517ECDDA.3000606@amd.com>
Date: Mon, 29 Apr 2013 14:45:30 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RFC: IOMMU/AMD: Error Handling
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg,

We are in the process of implementing AMD IOMMU error handling, and I 
would like some comments from you and the community.

Currently, the AMD IOMMU driver only reports events from the event log 
in the dmesg, and does not try to handle them in case of errors.  AMD 
IOMMU errors can be categorized as device-specific errors and IOMMU errors.

1. For IOMMU errors such as:
     - DEV_TAB_HADWARE_ERROR
     - PAGE_TAB_ERROR
     - COMMAND_HARDWARE_ERROR
If the error is detected during IOMMU initialization, we could disable 
IOMMU and proceed.  If the error occurs after IOMMU is initialized, we 
won't be able to recover from this, and might need to result in panic.

2. For device-specific errors such as:
     - ILLEGAL_DEV_TABLE_ENTRY
     - IO_PAGE_FAULT
     - INVALDE_DEVICE_REQUEST
We think the AMD IOMMU driver should try to isolate the device. This 
involves blocking device transactions at IOMMU DTE and tries to disable 
the device (e.g. calling the remove(struct pci_dev *pdev) interface 
generally provides by device drivers).  This could prevents the device 
from continuing to fail and to risk of system instability.

3. In case of posted memory write transaction, device driver might not 
be aware that the transaction has failed and blocked at IOMMU. If there 
is no HW IOMMU, I believe this is handled by PCI error handling code.  
If the IOMMU hardware reporth such case, could this potentially leverage 
the Linux IOMMU fault handling interface, iommu_set_fault_handler() and 
report_iommu_fault(),  to communicate to device driver or PCI driver?

Any feedback or comments are appreciated.

Thank you,
Suravee




