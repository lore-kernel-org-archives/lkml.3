Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab3CRVdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:33:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35926 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933343Ab3CRVcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:32:54 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        kexec@lists.infradead.org, linux-pci@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Date: Mon, 18 Mar 2013 17:32:22 -0400
Message-Id: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.2
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:e0f4:3a1:9c35:d688
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caring about protecting the kernel from UID 0 was previously relatively
uninteresting, since an attacker could simply modify the kernel, a module
or an earlier part of the boot chain in order to insert new code. However,
there are now a range of widely-deployed mechanisms for ensuring the
authenticity of the early boot process and kernel. The addition of module
signing makes most of these attacks infeasible.

This means we can return our focus to the kernel. There's currently a number
of kernel interfaces that permit privileged userspace to modify the running
kernel. These are currently protected by CAP_SYS_RAWIO, but unfortunately
the semantics of this capability are poorly defined and it now covers a large
superset of the desired behaviour.

This patch introduces CAP_COMPROMISE_KERNEL. Holding this capability
indicates that a process is empowered to perform tasks that may result in
modification of the running kernel. While aimed at handling the specific
use-case of Secure Boot, it is generalisable to any other environment where
permitting userspace to modify the kernel is undesirable.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 include/uapi/linux/capability.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index ba478fa..7109e650 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -343,7 +343,11 @@ struct vfs_cap_data {
 
 #define CAP_BLOCK_SUSPEND    36
 
-#define CAP_LAST_CAP         CAP_BLOCK_SUSPEND
+/* Allow things that trivially permit root to modify the running kernel */
+
+#define CAP_COMPROMISE_KERNEL  37
+
+#define CAP_LAST_CAP         CAP_COMPROMISE_KERNEL
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
-- 
1.8.1.2

