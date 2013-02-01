Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3BARp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 12:45:26 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:2277 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754891Ab3BARpW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 12:45:22 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371I542Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h1155h)
X-WSS-ID: 0MHJYND-01-55K-02
X-M-MSG: 
From: "Kinney, Steven" <Steven.Kinney@amd.com>
To: Joerg Roedel <joro@8bytes.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Myron Stowe <myron.stowe@redhat.com>, Hiroshi DOYU <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Kosina <jkosina@suse.cz>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: RE: [PATCH 1/3] AMD x86 quirks: Quirk for enabling IOMMUv2 PC
 feature
Thread-Topic: [PATCH 1/3] AMD x86 quirks: Quirk for enabling IOMMUv2 PC
 feature
Thread-Index: Ac4Ao8jpDhiTFc0LRdaI5w72cWF/hQ==
Date: Fri, 1 Feb 2013 17:45:12 +0000
Message-ID: <57D41218901B4442B4AFF404D21591163C83B2@sausexdag02.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.236.70.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

                    Sorry for the delay regarding the response.  I can describe the invocation and the results, pertaining to static counts.  Also, I would imagine that driver writers or individuals wanting to measure IOMMU translation performance would be the consumers regarding this perf capability.  Of course, this is my understanding and why I am very interested in the kernel communities comments and advice.  First, to invoke the use of the IOMMUv2 PMU the following command will suffice:

	./perf stat -e iommuv2/config=0x8000000000000005,config1=0x0/u <command>  /* I have the RAW bit explicitly set (MSb) */

	The <config> will set the following:

		CSource [7:0] - Identifies the IOMMUv2 performance metric that will be counted.  In this case 0x05 which is the total peripheral memory operations translated.
		DeviceID [23:8] - The PCI BDF identifying the specific device that will be considered.  In this case 0x0000 is the IOMMU itself.
		PASID [39:24] - Filter based on PASID, optional.  0x0000, no filtering
		Domain [55:40] - Filter based on Domain, optional, 0x0000 no filtering.
		en_deviceid_filter[56] - Explicit enabling of DeviceID filtering, implicitly set if DeviceID is not 0x0000.
		en_pasid_filter[57] - Must be set to enable optional PASID filtering.
		en_domain_filter [58] - Must be set to enable optional Domain filtering.

	The <config1> will set the following (more obscure settings)

		deviceid_mask [15:0] - Apply a bit mask, regarding the associated filter, or match register, for refining purposes.
		pasid_mask [31:16] - Same as device_mask pertaining to PASID.
		domain_mask [47:32] - Same as device_mask, pertaining to Domain.

When the IOMMUv2 PMU is invoked, the first task is to verify there is a PC resource available.  The IOMMUv2 PMU uses a soft register and bit mask, linearized from bank/counter information populated within the amd_iommu struct during initialization, to allocate a free bank/counter to assign to the perf IOMMU event.  The bank/counter information is used, among other values, to calculate an offset into the IOMMU MMIO region to access registers; for example ICounter, CSource, etc.  So from an IOMMUv2 driver perspective, pertaining to the additional functionality written into amd_iommu_init.c, once the IOMMUv2 PMU has assigned the counter resource it needs to configure the physical IOMMUv2 PC registers.  For example,:

		1) Allocate IOMMUv2 Bank/Counter index, first go-around the assignment is bank=0, counter=0.
		2) At the moment, the code is only populating the DevID (PCI BDF) into DeviceID; PASID and Domain will be added later.   The devid is held to 0x0000.
		3) The Fxn is the functional register within the counter set and is used to calculate the counter register offset within the MMIO Region.  For example CSource is +08h; see Table 70: Counter Bank Addressing (MMIO) in IOMMUv2 2.0 specification.
		4) The value to be written, in the case of the above example, is 0x05, pertaining to the CSource register.
		5) Since this is a write operation is_write is true.
		6) Now there is enough information to access the IOMMUv2 PC register(s) and the perf IOMMUv2 calls into the IOMMU core driver (exported function)

			Int amd_iommu_v2_get_set_pc_reg_val( u16 devid, u8 bank, u8 cntr, u8 fxn, long long *value, bool is_write);

		Most of the IOMMUv2 driver functionality is self-explanatory, and the function, above, will verify IOMMUv2 PC capability, calculate the counter set offset within the IOMMU MMIO region and verify that the offset is within the MMIO region aperture.  After this is completed, the function simply writes to the selected register.  Since the number of banks and counters are dynamic, dependent upon future design, the limits for MMIO region offset values are calculated based on reported maximum bank/counter.

After the CSource register has been written to, other than a zero(0), the ICounter will start counting the relative IOMMU events described by the CSource value.

To stop the counter (ICounter), the CSource register is set to zero(0); so a perf event accessing the IOMMUv2 PC will write a defined value to the CSource register, execute a command, write a zero(0) to the CSource register then read the ICounter value.  The count, for the specific IOMMU perf event, is the previous count minus the current ICounter value; the ICounter cannot be reset other than overflow.

So, when the perf command example is executed, for example with a ls or some other trivial executable, the result will be a count of all IOMMU peripheral memory operations translated (total).  I choose this simply to assure count increment.  

Sorry for the long winded explanation, but we can look at any detail you would like to explore regarding the above description.

BR,

Steve


-----Original Message-----
From: Joerg Roedel [mailto:joro@8bytes.org] 
Sent: Monday, January 28, 2013 9:37 AM
To: Kinney, Steven
Cc: Thomas Gleixner; Ingo Molnar; H. Peter Anvin; x86@kernel.org; Bjorn Helgaas; Greg Kroah-Hartman; Sebastian Andrzej Siewior; Myron Stowe; Hiroshi DOYU; Stephen Warren; Jiri Kosina; Kukjin Kim; linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org; Peter Zijlstra; Paul Mackerras; Arnaldo Carvalho de Melo; Thomas Renninger; Andi Kleen; Cyrill Gorcunov
Subject: Re: [PATCH 1/3] AMD x86 quirks: Quirk for enabling IOMMUv2 PC feature

On Mon, Jan 28, 2013 at 02:59:25PM +0000, Kinney, Steven wrote:
> Testing with perf shows expected results.

Can you give me an impression on how the results look like when perf is used? Since the hardware is widely available yet I can't try this myself.


	Joerg




