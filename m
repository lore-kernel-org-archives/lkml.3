Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598Ab3EBPVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:21:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60118 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab3EBPQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH, RFC 13/22] staging/logger: use kuid_t internally
Date: Thu,  2 May 2013 17:16:17 +0200
Message-Id: <1367507786-505303-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:IqbPbm99fHdl6tiswpaYgtm6k8I/PgVLopF1TX9/noj
 T2r+ACKeaGuMQzPkTREWbMx9fBclsBD39oJKiDq2mvFOhhR0bj
 xnq2Si/au7UMTcTpoC1kWjYW/Hi8JG87T8y+BGaDaBF5S4Irmx
 b/CL8z48dCqMosL3EAVRs2P4dwBivQmXDYWE2JyF8Xg0pJSnZw
 vE5LYT1z2wkq/2Klh4s1jRjGiGCjnvtRQlI7+VAz4+suFM4lDS
 gFJkRtd1woYe3LhfeX64EXL5hvD8ux4ZPfKxEw9EbTq+o1jQHz
 Jk3S67omGNilSiwRsz/W2JMt+8aTfKgbVZaDYRUL+JCrkJtuK4
 cnyGyhIuMrcQkZtqJRclDSFZiMe8LWmU5VxIFc95c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is probably wrong but lets us build the driver with
CONFIG_UIDGID_STRICT_TYPE_CHECKS enabled. Without it, we get
these errors:

drivers/staging/android/logger.c: In function 'logger_read':
drivers/staging/android/logger.c:316:4: error: incompatible type for argument 3 of 'get_next_entry_by_uid'
drivers/staging/android/logger.c:244:15: note: expected 'uid_t' but argument is of type 'kuid_t'
drivers/staging/android/logger.c: In function 'logger_aio_write':
drivers/staging/android/logger.c:483:14: error: incompatible types when assigning to type 'uid_t' from type 'kuid_t'

which tells us that the driver is not compatible with user namespaces.
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/android/logger.c | 4 ++--
 drivers/staging/android/logger.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index b040200..9bd8747 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -242,7 +242,7 @@ static ssize_t do_read_log_to_user(struct logger_log *log,
  * 'log->buffer' which contains the first entry readable by 'euid'
  */
 static size_t get_next_entry_by_uid(struct logger_log *log,
-		size_t off, uid_t euid)
+		size_t off, kuid_t euid)
 {
 	while (off != log->w_off) {
 		struct logger_entry *entry;
@@ -251,7 +251,7 @@ static size_t get_next_entry_by_uid(struct logger_log *log,
 
 		entry = get_entry_header(log, off, &scratch);
 
-		if (entry->euid == euid)
+		if (uid_eq(entry->euid, euid))
 			return off;
 
 		next_len = sizeof(struct logger_entry) + entry->len;
diff --git a/drivers/staging/android/logger.h b/drivers/staging/android/logger.h
index cc6bbd9..70af7d8 100644
--- a/drivers/staging/android/logger.h
+++ b/drivers/staging/android/logger.h
@@ -66,7 +66,7 @@ struct logger_entry {
 	__s32		tid;
 	__s32		sec;
 	__s32		nsec;
-	uid_t		euid;
+	kuid_t		euid;
 	char		msg[0];
 };
 
-- 
1.8.1.2

