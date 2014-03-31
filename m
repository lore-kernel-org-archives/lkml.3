Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbaCaNkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:40:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35700 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbaCaNYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lukasz Dorau <lukasz.dorau@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 38/71] [SCSI] isci: correct erroneous for_each_isci_host macro
Date: Mon, 31 Mar 2014 14:22:44 +0100
Message-Id: <1396272197-13394-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Dorau <lukasz.dorau@intel.com>

commit c59053a23d586675c25d789a7494adfdc02fba57 upstream.

In the first place, the loop 'for' in the macro 'for_each_isci_host'
(drivers/scsi/isci/host.h:314) is incorrect, because it accesses
the 3rd element of 2 element array. After the 2nd iteration it executes
the instruction:
        ihost = to_pci_info(pdev)->hosts[2]
(while the size of the 'hosts' array equals 2) and reads an
out of range element.

In the second place, this loop is incorrectly optimized by GCC v4.8
(see http://marc.info/?l=linux-kernel&m=138998871911336&w=2).
As a result, on platforms with two SCU controllers,
the loop is executed more times than it can be (for i=0,1 and 2).
It causes kernel panic during entering the S3 state
and the following oops after 'rmmod isci':

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff8131360b>] __list_add+0x1b/0xc0
Oops: 0000 [#1] SMP
RIP: 0010:[<ffffffff8131360b>]  [<ffffffff8131360b>] __list_add+0x1b/0xc0
Call Trace:
  [<ffffffff81661b84>] __mutex_lock_slowpath+0x114/0x1b0
  [<ffffffff81661c3f>] mutex_lock+0x1f/0x30
  [<ffffffffa03e97cb>] sas_disable_events+0x1b/0x50 [libsas]
  [<ffffffffa03e9818>] sas_unregister_ha+0x18/0x60 [libsas]
  [<ffffffffa040316e>] isci_unregister+0x1e/0x40 [isci]
  [<ffffffffa0403efd>] isci_pci_remove+0x5d/0x100 [isci]
  [<ffffffff813391cb>] pci_device_remove+0x3b/0xb0
  [<ffffffff813fbf7f>] __device_release_driver+0x7f/0xf0
  [<ffffffff813fc8f8>] driver_detach+0xa8/0xb0
  [<ffffffff813fbb8b>] bus_remove_driver+0x9b/0x120
  [<ffffffff813fcf2c>] driver_unregister+0x2c/0x50
  [<ffffffff813381f3>] pci_unregister_driver+0x23/0x80
  [<ffffffffa04152f8>] isci_exit+0x10/0x1e [isci]
  [<ffffffff810d199b>] SyS_delete_module+0x16b/0x2d0
  [<ffffffff81012a21>] ? do_notify_resume+0x61/0xa0
  [<ffffffff8166ce29>] system_call_fastpath+0x16/0x1b

The loop has been corrected.
This patch fixes kernel panic during entering the S3 state
and the above oops.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
Reviewed-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
Tested-by: Lukasz Dorau <lukasz.dorau@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/isci/host.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 9ab58e0..35de7e6 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -311,9 +311,8 @@ static inline struct Scsi_Host *to_shost(struct isci_host *ihost)
 }
 
 #define for_each_isci_host(id, ihost, pdev) \
-	for (id = 0, ihost = to_pci_info(pdev)->hosts[id]; \
-	     id < ARRAY_SIZE(to_pci_info(pdev)->hosts) && ihost; \
-	     ihost = to_pci_info(pdev)->hosts[++id])
+	for (id = 0; id < SCI_MAX_CONTROLLERS && \
+	     (ihost = to_pci_info(pdev)->hosts[id]); id++)
 
 static inline void wait_for_start(struct isci_host *ihost)
 {
-- 
1.9.1

