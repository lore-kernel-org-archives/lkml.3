Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab3AaSdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:33:38 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:4489 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3AaSde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:33:34 -0500
Message-ID: <1359657210.6061.3.camel@lorien2>
Subject: IO_PAGE_FAULTs on unity mapped regions during amd_iommu_init() in
 Linux 3.4
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Joerg Roedel <joro@8bytes.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Date: Thu, 31 Jan 2013 11:33:30 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg,

I am seeing IO_PAGE_FAULTs on AMD system running releases prior to 3.7.
I focused my debug and testing on 3.4. I am hoping to find a solution
for this problem in 3.4. I don't see any IO_PAGE_FAULTs with 3.7 and
later releases on this system.

On this system BIOS specifies Unity mapped (direct mapped) exclusion
ranges in IVMDs for several devices. These regions are in use during
BIOS hand-off to kernel and continue to be used during kernel boot and
run-time.

Access to these ranges continues to work with no errors until AMD IOMMU
driver disables and re-enables IOMMU in enable_iommus(). These faults
don't persist and appear between the enable_iommus() call and before
amd_iommu_init() gets done printing "AMD-Vi: Lazy IO/TLB flushing
enabled" message.

Read requests from device 02:00.2 and write request from device 03:00.0
to these unity mapped regions fail. The reason appears to be because
domain id is 0.

Domain gets assigned in amd_iommu_init_dma_ops() and unity maps are
handled. I don't see enable_iommus() doing anything to these unity
mapped exclusion ranges. So I am assuming that is not the issue,
however, could domain ids get flushed? More like, why do these faults
show up in this window? These are direct mapped, so there is no need for
any translations.

Please see below for IVMD dump and IO_PAGE_FAULT analysis.

Dump of these ranges from dmesg:

[    5.322280] AMD-Vi: IVMD_TYPE_ALL             devid_start: 00:00.0
devid_end: 04:00.3 range_start: 00000000000f0000 range_end:
0000000000100000 flags: 7
[    5.322367] AMD-Vi: IVMD_TYPE_ALL             devid_start: 00:00.0
devid_end: 04:00.3 range_start: 00000000bff70000 range_end:
00000000bfff0000 flags: 7
[    5.322454] AMD-Vi: IVMD_TYPE_ALL             devid_start: 00:00.0
devid_end: 04:00.3 range_start: 00000000000e8000 range_end:
00000000000e9000 flags: 7
[    5.322540] AMD-Vi: IVMD_TYPE_ALL             devid_start: 00:00.0
devid_end: 04:00.3 range_start: 00000000bdffe000 range_end:
00000000be000000 flags: 7
[    5.322627] AMD-Vi: IVMD_TYPE_ALL             devid_start: 00:00.0
devid_end: 04:00.3 range_start: 00000000bdff9000 range_end:
00000000bdffd000 flags: 7
[    5.322714] AMD-Vi: IVMD_TYPE_ALL             devid_start: 00:00.0
devid_end: 04:00.3 range_start: 00000000bdfe9000 range_end:
00000000bdff9000 flags: 7


Now to IO_PAGE_FAULT analysis: My observations in ""

[   15.281594] AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.2
domain=0x0000 address=0x00000000bdffe000 flags=0x0050]
[   15.281861] AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.2
domain=0x0000 address=0x00000000bdff9080 flags=0x0050]
[   15.281990] AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.2
domain=0x0000 address=0x00000000bdff9100 flags=0x0050]

Domain ID is zero - "PASID not valid"
flags=0x0050 - "Bits PE and PR are set in the Event."
TR: translation TR=0
  "TR is 0 that means it is a transaction request"
RZ: reserved bit RZ=0
  "Since PR is set RZ is meaningful, I/O page fault is due to an invalid
   level encoding"
PE: permission indicator PE=1
  "Device doesn't have permission for this transaction"
RW: read-write RW=0
  "RW is meaningful since PR=1, TR=0, and I=0. It is a Read transaction"
PR: Present PR=1
  "PR = 1 means transaction is to a page marked present"
I: interrupt I=0
  "transaction is a memory request"
US: user-supervisor US=0
  "Supervisor privileges were asserted."
NX: no execute NX=0
  "0 upstream transaction lacks a PASID TLP prefix. Domain ID is zero."
GN: guest/nested GN=0
  "Transaction used a nested address (GPA)."

[   15.281733] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0
domain=0x0000 address=0x00000000bdff9160 flags=0x0070]

Domain ID is zero - "PASID is not valid"
flags=0x0070 - "Bits PE, RW, and PR are set in the Event."
TR: translation TR=0
  "TR is 0 that means it is a transaction request"
RZ: reserved bit RZ=0
  "Since PR is set RZ is meaningful, I/O page fault is due to an invalid
   level encoding"
PE: permission indicator PE=1
  "Device doesn't have permission for this transaction"
RW: read-write RW=1
  "RW is meaningful since PR=1, TR=0, and I=0. It is a Write
transaction"
PR: Present PR=1
  "PR = 1 means transaction is to a page marked present"
I: interrupt I=0
  "transaction is a memory request"
US: user-supervisor US=0
  "Supervisor privileges were asserted."
NX: no execute NX=0
  "0 upstream transaction lacks a PASID TLP prefix. Domain ID is zero."
GN: guest/nested GN=0
  "Transaction used a nested address (GPA)."

Thanks,
-- Shuah

