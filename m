Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab3HPIJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:09:10 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31815 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3HPIJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 04:09:00 -0400
From: Vaughan Cao <vaughan.cao@oracle.com>
To: konrad.wilk@oracle.com, jeremy@goop.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: vaughan.cao@oracle.com
Subject: [PATCH] xen: initialize xen panic handler for PVHVM
Date: Fri, 16 Aug 2013 16:10:56 +0800
Message-Id: <1376640656-32381-1-git-send-email-vaughan.cao@oracle.com>
X-Mailer: git-send-email 1.7.11.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel use callback linked in panic_notifier_list to notice others when panic
happens.
NORET_TYPE void panic(const char * fmt, ...){
    ...
    atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
}
When xen aware this, it will call xen_reboot(SHUTDOWN_crash) to send out an
event with reason code - SHUTDOWN_crash.
xen_panic_handler_init() is defined to register on panic_notifier_list but
we only call it in xen_arch_setup which only be called by pvm, this patch is
 necessary for pvhvm.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 arch/x86/xen/enlighten.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 4aec5ed..53e5726 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1713,6 +1713,8 @@ static void __init xen_hvm_guest_init(void)
 
 	xen_hvm_init_shared_info();
 
+	xen_panic_handler_init();
+
 	if (xen_feature(XENFEAT_hvm_callback_vector))
 		xen_have_vector_callback = 1;
 	xen_hvm_smp_init();
-- 
1.7.11.7

