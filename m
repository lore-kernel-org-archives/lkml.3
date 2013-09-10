Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab3IJVrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:47:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab3IJVpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:45:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, ebiederm@xmission.com, hpa@zytor.com,
        matthew.garrett@nebula.com, vgoyal@redhat.com
Subject: [PATCH 13/16] kexec: Allow only signed processes to call sys_kexec() in secureboot mode
Date: Tue, 10 Sep 2013 17:44:28 -0400
Message-Id: <1378849471-10521-14-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify sys_kexec() so that it allows only signed processes to execute
sys_kexec() when secureboot is enabled.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 kernel/kexec.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 59f7b55..478566e 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -907,6 +907,31 @@ static int kimage_load_segment(struct kimage *image,
 	return result;
 }
 
+static int check_task_signature(void)
+{
+	int ret = 0;
+	const struct cred *cred;
+
+	/* If secureboot is enabled, There are extra checks required */
+	/* TODO: Change it once secure_level patches stablize */
+/*
+	if (!secure_modules())
+		return ret;
+*/
+	/*
+	 * Calling process should be signed, memlocked.
+	 */
+
+	if (!test_bit(MMF_VM_LOCKED, &current->mm->flags))
+		return -EPERM;
+
+	cred = current_cred();
+	if (!cred->proc_signed)
+		return -EPERM;
+
+	return ret;
+}
+
 /*
  * Exec Kernel system call: for obvious reasons only root may call it.
  *
@@ -942,6 +967,10 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 	if (!capable(CAP_SYS_BOOT))
 		return -EPERM;
 
+	result = check_task_signature();
+	if (result)
+		return result;
+
 	/*
 	 * Verify we have a legal set of flags
 	 * This leaves us room for future extensions.
-- 
1.8.3.1

