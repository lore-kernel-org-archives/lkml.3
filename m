Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab3F1VOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:14:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab3F1VOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:14:24 -0400
From: Lenny Szubowicz <lszubowi@redhat.com>
To: tony.luck@intel.com, cbouatmailru@gmail.com, matt.fleming@intel.com,
        linux-kernel@vger.kernel.org
Cc: n.hamaguchi@jp.fujitsu.com, dzickus@redhat.com
Subject: [PATCH V2 1/3] pstore: Return unique error if backend registration excluded by kernel param
Date: Fri, 28 Jun 2013 17:11:33 -0400
Message-Id: <1372453893-16494-1-git-send-email-lszubowi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch 1/3 of a patch set that avoids what misleadingly appears
to be a error during boot:

ERST: Could not register with persistent store

This message is displayed if the system has a valid ACPI ERST table and the
pstore.backend kernel parameter has been used to disable use of ERST by
pstore. But this same message is used for errors that preclude registration.

As part of fixing this, return a unique error status from pstore_register
if the pstore.backend kernel parameter selects a specific facility other
than the requesting facility and check for this condition before any others.
This allows the caller to distinquish this benign case from the other failure
cases.

Also, print an informational console message about which facility
successfully registered as the pstore backend. Since there are various
kernel parameters, config build options, and boot-time errors that can
influence which facility registers with pstore, it's useful to have a
positive indication.

Signed-off-by: Lenny Szubowicz <lszubowi@redhat.com>
Reported-by: Naotaka Hamaguchi <n.hamaguchi@jp.fujitsu.com>
---
 fs/pstore/platform.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 86d1038..84f3ca7 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -239,17 +239,15 @@ int pstore_register(struct pstore_info *psi)
 {
 	struct module *owner = psi->owner;
 
+	if (backend && strcmp(backend, psi->name))
+		return -EPERM;
+
 	spin_lock(&pstore_lock);
 	if (psinfo) {
 		spin_unlock(&pstore_lock);
 		return -EBUSY;
 	}
 
-	if (backend && strcmp(backend, psi->name)) {
-		spin_unlock(&pstore_lock);
-		return -EINVAL;
-	}
-
 	if (!psi->write)
 		psi->write = pstore_write_compat;
 	psinfo = psi;
@@ -274,6 +272,9 @@ int pstore_register(struct pstore_info *psi)
 		add_timer(&pstore_timer);
 	}
 
+	pr_info("pstore: Registered %s as persistent store backend\n",
+		psi->name);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pstore_register);
-- 
1.8.2.1

