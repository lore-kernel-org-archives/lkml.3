Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbaHESqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:46:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbaHESOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH 3.15 38/42] x86/xen: no need to explicitly register an NMI callback
Date: Tue,  5 Aug 2014 11:13:52 -0700
Message-Id: <20140805181322.151731665@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181321.018370988@linuxfoundation.org>
References: <20140805181321.018370988@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit ea9f9274bf4337ba7cbab241c780487651642d63 upstream.

Remove xen_enable_nmi() to fix a 64-bit guest crash when registering
the NMI callback on Xen 3.1 and earlier.

It's not needed since the NMI callback is set by a set_trap_table
hypercall (in xen_load_idt() or xen_write_idt_entry()).

It's also broken since it only set the current VCPU's callback.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Steven Noonan <steven@uplinklabs.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/setup.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -574,13 +574,7 @@ void xen_enable_syscall(void)
 	}
 #endif /* CONFIG_X86_64 */
 }
-void xen_enable_nmi(void)
-{
-#ifdef CONFIG_X86_64
-	if (register_callback(CALLBACKTYPE_nmi, (char *)nmi))
-		BUG();
-#endif
-}
+
 void __init xen_pvmmu_arch_setup(void)
 {
 	HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_4gb_segments);
@@ -595,7 +589,6 @@ void __init xen_pvmmu_arch_setup(void)
 
 	xen_enable_sysenter();
 	xen_enable_syscall();
-	xen_enable_nmi();
 }
 
 /* This function is not called for HVM domains */


