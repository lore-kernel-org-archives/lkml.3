Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaH2Imz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:42:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46017 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbaH2Imv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:42:51 -0400
Date: Fri, 29 Aug 2014 11:42:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-kernel@vger.kernel.org, George Zhang <georgezhang@vmware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org
Subject: [patch] VMCI: integer overflow in vmci_datagram_dispatch()
Message-ID: <20140829084256.GA14780@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is untrusted user data from vmci_host_do_send_datagram() so the
VMCI_DG_SIZE() macro can have an integer overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/misc/vmw_vmci/vmci_datagram.c b/drivers/misc/vmw_vmci/vmci_datagram.c
index f3cdd90..8226652 100644
--- a/drivers/misc/vmw_vmci/vmci_datagram.c
+++ b/drivers/misc/vmw_vmci/vmci_datagram.c
@@ -328,7 +328,8 @@ int vmci_datagram_dispatch(u32 context_id,
 
 	BUILD_BUG_ON(sizeof(struct vmci_datagram) != 24);
 
-	if (VMCI_DG_SIZE(dg) > VMCI_MAX_DG_SIZE) {
+	if (dg->payload_size > VMCI_MAX_DG_SIZE ||
+	    VMCI_DG_SIZE(dg) > VMCI_MAX_DG_SIZE) {
 		pr_devel("Payload (size=%llu bytes) too big to send\n",
 			 (unsigned long long)dg->payload_size);
 		return VMCI_ERROR_INVALID_ARGS;
