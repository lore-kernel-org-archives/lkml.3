Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaARQci (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 11:32:38 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:48428 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaARQcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 11:32:36 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Jan 2014 17:32:20 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH v2] firewire: Enable remote DMA above 4 GB
Message-ID: <20140118173220.0a6f7c3f@stein>
In-Reply-To: <20140118170509.1181a887@stein>
References: <20140118163315.2757ce26@stein>
	<20140118170509.1181a887@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes all of a machine's memory accessible to remote debugging via
FireWire, using the physical response unit (i.e. RDMA) of OHCI-1394 link
layer controllers.

This requires actual support by the controller.  The only ones currently
known to support it are Agere/LSI FW643.  Most if not all other OHCI-1394
controllers do not implement the optional Physical Upper Bound register.
With them, RDMA will continue to be limited to the lowermost 4 GB.

firewire-ohci's startup message in the kernel log is augmented to tell
whether the controller does expose more than 4 GB to RDMA.

While OHCI-1394 allows for a maximum Physical Upper Bound of
0xffff'0000'0000 (near 256 TB), this implementation sets it to
0x8000'0000'0000 (128 TB) in order to avoid interference with applications
that require interrupt-served asynchronous request reception at
respectively low addresses.

Note, this change does not switch remote DMA on.  It only increases the
range of remote access to all memory (instead of just 4 GB) whenever
remote DMA was switched on by other means.  The latter is achieved by
setting firewire-ohci's remote_dma parameter, or if the physical DMA
filter is opened through firewire-sbp2.

Derived from patch "firewire: Enable physical DMA above 4GB" by
Peter Hurley <peter@hurleysoftware.com> from March 27, 2013.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
v2: updated documentation, extended changelog

 Documentation/debugging-via-ohci1394.txt |   13 +++++++++----
 drivers/firewire/core-transaction.c      |    6 +++---
 drivers/firewire/core.h                  |    3 +++
 drivers/firewire/ohci.c                  |    8 +++++---
 4 files changed, 20 insertions(+), 10 deletions(-)

--- a/Documentation/debugging-via-ohci1394.txt
+++ b/Documentation/debugging-via-ohci1394.txt
@@ -22,10 +22,12 @@ locations such as buffers like the print
 Retrieving a full system memory dump is also possible over the FireWire,
 using data transfer rates in the order of 10MB/s or more.
 
-Memory access is currently limited to the low 4G of physical address
-space which can be a problem on IA64 machines where memory is located
-mostly above that limit, but it is rarely a problem on more common
-hardware such as hardware based on x86, x86-64 and PowerPC.
+With most FireWire controllers, memory access is limited to the low 4 GB
+of physical address space.  This can be a problem on IA64 machines where
+memory is located mostly above that limit, but it is rarely a problem on
+more common hardware such as x86, x86-64 and PowerPC.  However, at least
+Agere/LSI FW643e and FW643e2 controllers are known to support access to
+physical addresses above 4 GB.
 
 Together with a early initialization of the OHCI-1394 controller for debugging,
 this facility proved most useful for examining long debugs logs in the printk
@@ -99,6 +101,9 @@ Step-by-step instructions for using fire
    compliant, they are based on TI PCILynx chips and require drivers for Win-
    dows operating systems.
 
+   The mentioned kernel log message contains ">4 GB phys DMA" in case of
+   OHCI-1394 controllers which support accesses above this limit.
+
 2) Establish a working FireWire cable connection:
 
    Any FireWire cable, as long at it provides electrically and mechanically
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -523,11 +523,11 @@ static DEFINE_SPINLOCK(address_handler_l
 static LIST_HEAD(address_handler_list);
 
 const struct fw_address_region fw_high_memory_region =
-	{ .start = 0x000100000000ULL, .end = 0xffffe0000000ULL,  };
+	{ .start = FW_MAX_PHYSICAL_RANGE, .end = 0xffffe0000000ULL, };
 EXPORT_SYMBOL(fw_high_memory_region);
 
 static const struct fw_address_region low_memory_region =
-	{ .start = 0x000000000000ULL, .end = 0x000100000000ULL,  };
+	{ .start = 0x000000000000ULL, .end = FW_MAX_PHYSICAL_RANGE, };
 
 #if 0
 const struct fw_address_region fw_private_region =
@@ -1217,7 +1217,7 @@ static void handle_low_memory(struct fw_
 }
 
 static struct fw_address_handler low_memory = {
-	.length			= 0x000100000000ULL,
+	.length			= FW_MAX_PHYSICAL_RANGE,
 	.address_callback	= handle_low_memory,
 };
 
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -237,6 +237,9 @@ static inline bool is_next_generation(in
 
 #define LOCAL_BUS 0xffc0
 
+/* arbitrarily chosen maximum range for physical DMA: 128 TB */
+#define FW_MAX_PHYSICAL_RANGE		(128ULL << 40)
+
 void fw_core_handle_request(struct fw_card *card, struct fw_packet *request);
 void fw_core_handle_response(struct fw_card *card, struct fw_packet *packet);
 int fw_get_response_length(struct fw_request *request);
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2367,7 +2367,7 @@ static int ohci_enable(struct fw_card *c
 	reg_write(ohci, OHCI1394_FairnessControl, 0);
 	card->priority_budget_implemented = ohci->pri_req_max != 0;
 
-	reg_write(ohci, OHCI1394_PhyUpperBound, 0x00010000);
+	reg_write(ohci, OHCI1394_PhyUpperBound, FW_MAX_PHYSICAL_RANGE >> 16);
 	reg_write(ohci, OHCI1394_IntEventClear, ~0);
 	reg_write(ohci, OHCI1394_IntMaskClear, ~0);
 
@@ -3723,9 +3723,11 @@ static int pci_probe(struct pci_dev *dev
 	version = reg_read(ohci, OHCI1394_Version) & 0x00ff00ff;
 	ohci_notice(ohci,
 		    "added OHCI v%x.%x device as card %d, "
-		    "%d IR + %d IT contexts, quirks 0x%x\n",
+		    "%d IR + %d IT contexts, quirks 0x%x%s\n",
 		    version >> 16, version & 0xff, ohci->card.index,
-		    ohci->n_ir, ohci->n_it, ohci->quirks);
+		    ohci->n_ir, ohci->n_it, ohci->quirks,
+		    reg_read(ohci, OHCI1394_PhyUpperBound) ?
+			", >4 GB phys DMA" : "");
 
 	return 0;
 


-- 
Stefan Richter
-=====-====- ---= =--=-
http://arcgraph.de/sr/
