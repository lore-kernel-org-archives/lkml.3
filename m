Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab3EVTRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:17:11 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:48966 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754882Ab3EVTRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:17:08 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1155h)
X-WSS-ID: 0MN7S6W-01-FL0-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <ddutile@redhat.com>, <alex.williamson@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 0/3] iommu/amd: IOMMU Error Reporting/Handling/Filtering
Date: Wed, 22 May 2013 14:15:52 -0500
Message-ID: <1369250155-12226-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

This patch set implements framework for handling errors reported via IOMMU 
event log. It also implements mechanism to filter/suppress error messages when 
IOMMU hardware generates large amount event logs, which is often caused by 
devices performing invalid operations or from misconfiguring IOMMU hardware 
(e.g. IO_PAGE_FAULT and INVALID_DEVICE_QEQUEST").

DEVICE vs IOMMU ERRORS:
=======================
Event types in AMD IOMMU event log can be categorized as:
    - IOMMU error : An error which is specific to IOMMU hardware
    - Device error: An error which is specific to a device
    - Non-error   : Miscelleneous events which are not classified as errors.
This patch set implements frameworks for handling "IOMMU error" and "device error".
For IOMMU error, the driver will log the event in dmesg and panic since the IOMMU 
hardware is no longer functioning. For device error, the driver will decode and 
log the error in dmesg based on the error logging level specified at boot time.

ERROR LOGGING LEVEL:
====================
The filtering framework introduce 3 levels of event logging, 
"AMD_IOMMU_LOG_[DEFAULT|VERBOSE|DEBUG]".  Users can specify the level 
via a new boot option "amd_iommu_log=[default|verbose|debug]".
    - default: Each error message is truncated. Filtering is enabled.
    - verbose: Output detail error message. Filtering is enabled.
    - debug  : Output detail error message. Filtering is disabled.

ERROR THRESHOLD LEVEL:
======================
Error threshold is used by the log filtering logic to determine when to suppress 
the errors from a particular device. The threshold is defined as "the number of errors
(X) over a specified period (Y sec)". When the threshold is reached, IOMMU driver will
suppress subsequent error messages from the device for a predefined period (Z sec). 
X, Y, and Z is currently hard-coded to 10 errors, 5 sec, and 30 sec.

DATA STRUCTURE:
===============
A new structure "struct dte_err_info" is added. It contains error information
specific to each device table entry (DTE). The structure is allocated dynamically 
per DTE when IOMMU driver handle device error for the first time.

ERROR STATES and LOG FILTERING:
============================================
The filtering framework define 3 device error states "NONE", "PROBATION" and "SUPPRESS". 
 1. From IOMMU driver intialization, all devices are in DEV_ERR_NONE state.  
 2. During interupt handling, IOMMU driver processes each entry in the event log.
 3. If an entry is device error, the driver tags DTE with DEV_ERR_PROBATION and
    report error via via dmesg. 
 4. For non-debug mode, if the device threshold is reached, the device is moved into 
    DEV_ERR_SUPPRESS state in which all error messages are suppressed.
 5. After the suppress period has passed, the driver put the device in probation state,
    and errors are reported once again. If the device continues to generate errors, 
    it will be re-suppress once the next threshold is reached.

EXAMPLE OUTPUT:
===============
AMD-Vi: Event=IO_PAGE_FAULT dev=3:0.0 dom=0x1b addr=0x97040 flg=N Ex Sup M P W Pm Ill Ta
AMD-Vi: Event=IO_PAGE_FAULT dev=3:0.0 dom=0x1b addr=0x97070 flg=N Ex Sup M P W Pm Ill Ta
AMD-Vi: Event=IO_PAGE_FAULT dev=3:0.0 dom=0x1b addr=0x97060 flg=N Ex Sup M P W Pm Ill Ta
AMD-Vi: Event=IO_PAGE_FAULT dev=3:0.0 dom=0x1b addr=0x4970 flg=N Ex Sup M P W Pm Ill Ta
AMD-Vi: Event=IO_PAGE_FAULT dev=3:0.0 dom=0x1b addr=0x98840 flg=N Ex Sup M P W Pm Ill Ta
AMD-Vi: Event=IO_PAGE_FAULT dev=3:0.0 dom=0x1b addr=0x98870 flg=N Ex Sup M P W Pm Ill Ta
AMD-Vi: Event=IO_PAGE_FAULT dev=3:0.0 dom=0x1b addr=0x98860 flg=N Ex Sup M P W Pm Ill Ta
AMD-Vi: Event=IO_PAGE_FAULT dev=3:0.0 dom=0x1b addr=0x4980 flg=N Ex Sup M P W Pm Ill Ta
AMD-Vi: Event=IO_PAGE_FAULT dev=3:0.0 dom=0x1b addr=0x99040 flg=N Ex Sup M P W Pm Ill Ta
AMD-Vi: Event=IO_PAGE_FAULT dev=3:0.0 dom=0x1b addr=0x99060 flg=N Ex Sup M P W Pm Ill Ta
AMD-Vi: Warning: IOMMU error threshold (10) reached for device=3:0.0. Suppress for 30 secs.!!!

Suravee Suthikulpanit (3):
  iommu/amd: Adding amd_iommu_log cmdline option
  iommu/amd: Add error handling/reporting/filtering logic
  iommu/amd: Remove old event printing logic

 Documentation/kernel-parameters.txt |   10 +
 drivers/iommu/Makefile              |    2 +-
 drivers/iommu/amd_iommu.c           |   85 +-------
 drivers/iommu/amd_iommu_fault.c     |  368 +++++++++++++++++++++++++++++++++++
 drivers/iommu/amd_iommu_init.c      |   19 ++
 drivers/iommu/amd_iommu_proto.h     |    6 +
 drivers/iommu/amd_iommu_types.h     |   16 ++
 7 files changed, 426 insertions(+), 80 deletions(-)
 create mode 100644 drivers/iommu/amd_iommu_fault.c

-- 
1.7.10.4


