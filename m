Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964961Ab3BMR5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:57:50 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59208 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964917Ab3BMR5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:46 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>
Date: Wed, 13 Feb 2013 09:51:06 -0800
Message-Id: <1360777934-5663-17-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/mcdZaj7PicQE9acoj7Depv/mrPTIxob0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0042]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 17/85] coda: Restrict coda messages to the initial pid namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Remove the slight chance that pids in coda messages will be
interpreted in the wrong pid namespace.

- Explicitly send all pids in coda messages in the initial pid
  namespace.
- Only allow mounts from processes in the initial pid namespace.
- Only allow processes in the initial pid namespace to open the coda
  character device to communicate with coda.

Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/coda/inode.c  |    4 ++++
 fs/coda/psdev.c  |    4 ++++
 fs/coda/upcall.c |    4 ++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index be2aa49..77bbaf4 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -20,6 +20,7 @@
 #include <linux/file.h>
 #include <linux/vfs.h>
 #include <linux/slab.h>
+#include <linux/pid_namespace.h>
 
 #include <asm/uaccess.h>
 
@@ -157,6 +158,9 @@ static int coda_fill_super(struct super_block *sb, void *data, int silent)
 	int error;
 	int idx;
 
+	if (task_active_pid_ns(current) != &init_pid_ns)
+		return -EINVAL;
+
 	idx = get_device_index((struct coda_mount_data *) data);
 
 	/* Ignore errors in data, for backward compatibility */
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index 761d5b3..dd60f90 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -37,6 +37,7 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/device.h>
+#include <linux/pid_namespace.h>
 #include <asm/io.h>
 #include <asm/poll.h>
 #include <asm/uaccess.h>
@@ -266,6 +267,9 @@ static int coda_psdev_open(struct inode * inode, struct file * file)
 	struct venus_comm *vcp;
 	int idx, err;
 
+	if (task_active_pid_ns(current) != &init_pid_ns)
+		return -EINVAL;
+
 	idx = iminor(inode);
 	if (idx < 0 || idx >= MAX_CODADEVS)
 		return -ENODEV;
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index 0c68fd3..5c6d2cd 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -50,8 +50,8 @@ static void *alloc_upcall(int opcode, int size)
 		return ERR_PTR(-ENOMEM);
 
         inp->ih.opcode = opcode;
-	inp->ih.pid = current->pid;
-	inp->ih.pgid = task_pgrp_nr(current);
+	inp->ih.pid = task_pid_nr_ns(current, &init_pid_ns);
+	inp->ih.pgid = task_pgrp_nr_ns(current, &init_pid_ns);
 	inp->ih.uid = current_fsuid();
 
 	return (void*)inp;
-- 
1.7.5.4

