Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab3AVRPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:15:08 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:37220 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512Ab3AVRPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:15:05 -0500
Date: Tue, 22 Jan 2013 09:15:04 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: pv-drivers@vmware.com, linux-kernel@vger.kernel.org
Message-ID: <940336333.33838650.1358874904756.JavaMail.root@vmware.com>
In-Reply-To: <476743160.33828710.1358874246294.JavaMail.root@vmware.com>
Subject: [PATCH] VMCI: Fix broken context ID retrieval
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC24 (Mac)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm an idiot.  The context ID can be a really large unsigned number, which
means it'll appear negative as an int.  So actually the right fix here is just
to set it regardless of the returned value (but only for this particular
hypercall; normally we would check it).

Acked-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Andy King <acking@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_guest.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
index de1a90b..60c0199 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -81,16 +81,13 @@ bool vmci_guest_code_active(void)
 u32 vmci_get_vm_context_id(void)
 {
 	if (vm_context_id == VMCI_INVALID_ID) {
-		int result;
 		struct vmci_datagram get_cid_msg;
 		get_cid_msg.dst =
 		    vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
 				     VMCI_GET_CONTEXT_ID);
 		get_cid_msg.src = VMCI_ANON_SRC_HANDLE;
 		get_cid_msg.payload_size = 0;
-		result = vmci_send_datagram(&get_cid_msg);
-		if (result >= 0)
-			vm_context_id = result;
+		vm_context_id = vmci_send_datagram(&get_cid_msg);
 	}
 	return vm_context_id;
 }
-- 
1.7.4.1
