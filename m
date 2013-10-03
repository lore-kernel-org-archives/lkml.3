Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab3JCEVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:21:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab3JCEVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:21:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 46/57] drm/radeon/cik: Fix printing of client name on VM protection fault
Date: Wed,  2 Oct 2013 21:09:12 -0700
Message-Id: <20131003040639.742035263@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michel Dänzer <michel.daenzer@amd.com>

commit 328a50c7b09d313ab9278f972950da414d348eb1 upstream.

The string is encoded from the MSB to the LSB of the register.

Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -4506,12 +4506,13 @@ static void cik_vm_decode_fault(struct r
 	u32 mc_id = (status & MEMORY_CLIENT_ID_MASK) >> MEMORY_CLIENT_ID_SHIFT;
 	u32 vmid = (status & FAULT_VMID_MASK) >> FAULT_VMID_SHIFT;
 	u32 protections = (status & PROTECTIONS_MASK) >> PROTECTIONS_SHIFT;
-	char *block = (char *)&mc_client;
+	char block[5] = { mc_client >> 24, (mc_client >> 16) & 0xff,
+		(mc_client >> 8) & 0xff, mc_client & 0xff, 0 };
 
-	printk("VM fault (0x%02x, vmid %d) at page %u, %s from %s (%d)\n",
+	printk("VM fault (0x%02x, vmid %d) at page %u, %s from '%s' (0x%08x) (%d)\n",
 	       protections, vmid, addr,
 	       (status & MEMORY_CLIENT_RW_MASK) ? "write" : "read",
-	       block, mc_id);
+	       block, mc_client, mc_id);
 }
 
 /**


