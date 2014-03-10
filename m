Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaCJTYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:24:24 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:22394 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbaCJTYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:24:22 -0400
X-Greylist: delayed 775 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2014 15:24:22 EDT
From: "Sumner, William" <bill.sumner@hp.com>
To: Joerg Roedel <joro@8bytes.org>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "indou.takao@jp.fujitsu.com" <indou.takao@jp.fujitsu.com>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ddutile@redhat.com" <ddutile@redhat.com>,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "Hatch, Douglas B (HPS Linux PM)" <doug.hatch@hp.com>,
        "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: RE: [PATCHv3 3/6] Crashdump-Accepting-Active-IOMMU-Domain-Interfaces
Thread-Topic: [PATCHv3 3/6]
 Crashdump-Accepting-Active-IOMMU-Domain-Interfaces
Thread-Index: AQHPDlBlLtoZEP4Xx0itQZhvrRED4JrRV/2AgAm0MjA=
Date: Mon, 10 Mar 2014 19:23:11 +0000
Message-ID: <875D89B79D1D86448A583A7302C022A066E08B1B@G4W3212.americas.hpqcorp.net>
References: <1389391652-52422-1-git-send-email-bill.sumner@hp.com>
 <1389391652-52422-4-git-send-email-bill.sumner@hp.com>
 <20140304145911.GD2799@8bytes.org>
In-Reply-To: <20140304145911.GD2799@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.21]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 3/4/2014 8:59 AM, Joerg Roedel wrote
>On Fri, Jan 10, 2014 at 03:07:29PM -0700, Bill Sumner wrote:
>> +context_get_entry(struct context_entry *context_addr,
>> +			struct intel_iommu *iommu, u32 bus, int devfn) {
>> +	unsigned long long q;		/* quadword scratch */
>> +	struct root_entry *root_phys;	/* Phys adr (root table entry) */
>> +	struct root_entry  root_temp;	/* Local copy of root_entry */
>> +	struct context_entry *context_phys;	/* Phys adr */
>> +
>> +	if (pr_dbg.domain_get)
>> +		pr_debug("ENTER %s B:D:F=%2.2x:%2.2x:%1.1x &context_entry:0x%llx &intel_iommu:0x%llx\n",
>> +			__func__, bus, devfn>>3, devfn&7,
>> +			(u64)context_addr, (u64)iommu);
>> +
>> +	if (bus > 255)				/* Sanity check */
>> +		return -5;
>> +	if (devfn > 255 || devfn < 0)		/* Sanity check */
>> +		return -6;
>> +
>> +	q = readq(iommu->reg + DMAR_RTADDR_REG);
>> +	pr_debug("IOMMU %d: DMAR_RTADDR_REG:0x%16.16llx\n", iommu->seq_id, q);
>> +	if (!q)
>> +		return -1;
>> +
>> +	root_phys = (struct root_entry *) q;	/* Adr(base of vector) */
>> +	root_phys += bus;			/* Adr(entry we want) */
>> +
>> +	oldcopy(&root_temp, root_phys, sizeof(root_temp));
>> +
>> +	pr_debug("root_temp.val:0x%llx .rsvd1:0x%llx root_phys:0x%llx\n",
>> +		root_temp.val, root_temp.rsvd1, (u64)root_phys);
>> +
>> +	if (!root_present(&root_temp))
>> +		return -2;
>> +
>> +	pr_debug("B:D:F=%2.2x:%2.2x:%1.1x root_temp.val: %llx .rsvd1: %llx\n",
>> +		bus, devfn >> 3, devfn & 7, root_temp.val, root_temp.rsvd1);
>> +
>> +	if (root_temp.rsvd1)			/* If (root_entry is bad) */
>> +		return -3;
>> +
>> +	context_phys = get_context_phys_from_root(&root_temp);
>> +	if (!context_phys)
>> +		return -4;
>
>What do all these magic return values mean? 

They all mean "No value to return".  The different negative values are an artifact of the development where I wanted to make it easy not only to tell that something went wrong, but also to have enough detail to figure-out what happened without having to add code and repeat the test.  I will clean-up these in the next submission -- along with a few additional places where there are similar "leftovers".  

Bill


