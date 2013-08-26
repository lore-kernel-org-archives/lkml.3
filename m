Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab3HZSlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 14:41:37 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:9995 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3HZSlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 14:41:35 -0400
From: "Sumner, William" <bill.sumner@hp.com>
To: "bhelgaas@google.com" <bhelgaas@google.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "ddutile@redhat.com" <ddutile@redhat.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>
Subject: "crashdump accepting active iommu" prototype successful
Thread-Topic: "crashdump accepting active iommu" prototype successful
Thread-Index: Ac6ii9EWxcY4SZkSR8WjvyJL9q1Skg==
Date: Mon, 26 Aug 2013 18:41:07 +0000
Message-ID: <875D89B79D1D86448A583A7302C022A055A3BA47@G4W3299.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A while ago we discussed the concept of the crashdump kernel dealing with the legacy DMA from the (old) panic'd kernel by allowing the (new) crashdump kernel: to accept the iommu hardware in an active state, to leave the current translations in-place so that legacy DMA will continue using its current buffers until the device drivers in the crashdump kernel initialize, and to use different portions of the iova address ranges for the device drivers in the crashdump kernel.   

As time permitted I have created prototype code to explore this concept.

The "crashdump accepting active iommu" prototype/proof-of-concept code has successfully completed its first crashdump and rebooted the machine.  The latest version of the 'crash' utility reads the vmcore dump file that was created.


At a high-level, here are the changes I made:
The code is entirely within intel-iommu.c 
A key concept is that the active translation tables are mapped into kernel virtual addresses in the new kernel. This allows most of the existing iommu code to operate without change.

Hardware initialization:
------------------------
In intel_iommu_init(void)
* If (This is the crash kernel)
  .  Set flag: crashdump_accepting_active_iommu (all changes below check this)
  .  Skip disabling the iommu hardware translations

In init_dmars()
* Copy the intel iommu translation tables from the old kernel into the new kernel
  . The root-entry table, all context-entry tables, and all page-translation-entry tables
  . The copied tables contain updated physical addresses to link them together.
  . The copied tables are also mapped into kernel virtual addresses in the new kernel 
    which allows most of the existing iommu code to operate without change.
  . Do some minimal sanity-checks during the copy
  . Place the address of the new root-entry structure into "struct intel_iommu"

* Skip setting-up new domains for 'si', 'rmrr', 'isa' 
  . Translations for 'rmrr' and 'isa' ranges have been copied from the old kernel
  . This prototype does not yet handle pass-through

* Existing (unchanged) code near the end of dmar_init:
  . Loads the address of the (now new) root-entry structure from "struct intel_iommu"
    into the iommu hardware and does the proper iommu hardware flushes. This changes the 
    active translation tables from the ones in the old kernel to the copies in the new kernel.
  . This is legal because the translations in the two sets of tables are currently identical:
    - Intel(r) Virtualization Technology for Directed I/O. Architecture Specification,
      February 2011, Rev. 1.3  (section 11.2, paragraph 2) 

In iommu_init_domains()
* Mark as in-use all domain-id's from the old kernel
  . In case the new kernel contains a device that was not in the old kernel
    and a new, unused domain-id is actually needed, the bitmap will give us one.


When a new domain is created for a device:
------------------------------------------
* If (this device has a context in the old kernel)
  . Get domain-id, address-width, and IOVA ranges from the old kernel context;
  . Get adr(page-entry-tables) from the copy in the new kernel;
  . And apply all of the above values to the new domain structure.
* Else
  . Create a new domain as normal

Most of the code to implement the new functionality was added at the end of intel-iommu.c
Bill


