Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3I2WfN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 18:35:13 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39673 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3I2WfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 18:35:11 -0400
Message-ID: <5248AB37.7000100@gmail.com>
Date: Mon, 30 Sep 2013 08:35:35 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux@horizon.com,
        Jiri Kosina <jkosina@suse.cz>, eldad@fogrefinery.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] printk: Check real user/group id for %pK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some setuid binaries will allow reading of files which have read permission by the real user id. This is problematic with files which use %pK because the contents of the file is different when opened as root, and displaying the contents may leak kernel pointer values.
    
This happens for example with the setuid pppd application on Ubuntu 12.04:
    
  $ head -1 /proc/kallsyms
  00000000 T startup_32
    
  $ pppd file /proc/kallsyms
  pppd: In file /proc/kallsyms: unrecognized option 'c1000000'
    
This will only leak the pointer value from the first line, but other setuid binaries may leak more information.
    
Fix this by adding a check that in addition to the current process having CAP_SYSLOG, that effective user and group ids are equal to the real ids. If a setuid binary reads the contents of a file which uses %pK then the pointer values will be printed as NULL if the real user is unprivileged.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 26559bd..b1cd14d 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1312,10 +1312,24 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 				spec.field_width = default_width;
 			return string(buf, end, "pK-error", spec);
 		}
-		if (!((kptr_restrict == 0) ||
-		      (kptr_restrict == 1 &&
-		       has_capability_noaudit(current, CAP_SYSLOG))))
-			ptr = NULL;
+
+		/*
+		 * If kptr_restrict is set to 2, then %pK always prints as
+		 * NULL. If it is set to 1, then only print the real pointer
+		 * value if the current proccess has CAP_SYSLOG and is running
+		 * with the same credentials it started with. We don't want
+		 * badly written setuid binaries being able to read the real
+		 * pointers on behalf of unprivileged users.
+		 */
+		{
+			const struct cred *cred = current_cred();
+
+			if (kptr_restrict == 2 || (kptr_restrict == 1 &&
+			     (!has_capability_noaudit(current, CAP_SYSLOG) ||
+			      !uid_eq(cred->euid, cred->uid) ||
+			      !gid_eq(cred->egid, cred->gid))))
+				ptr = NULL;
+		}
 		break;
 	case 'N':
 		switch (fmt[1]) {

