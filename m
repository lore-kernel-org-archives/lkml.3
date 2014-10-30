Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbaJ3CXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 22:23:48 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:63210 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924AbaJ3CXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 22:23:46 -0400
Date: Thu, 30 Oct 2014 10:23:31 +0800 (CST)
From: Xiong Zhou <jencce.kernel@gmail.com>
X-X-Sender: zx@dhcp12-144.nay.redhat.com
To: linux-kernel@vger.kernel.org
cc: kernel-team@android.com, nnk@google.com, john.stultz@linaro.org,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        jencce.kernel@gmail.com, arnd@arndb.de
Subject: [PATCH] staging: android: logger: fix kuid/uid in logger_entry
Message-ID: <alpine.LFD.2.11.1410301007090.3316@dhcp12-144.nay.redhat.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiong Zhou <jencce.kernel@gmail.com>

struct logger_entry can be returned to userspace via ioctl,
so it is wrong to have a kuid_t member, fixing it to uid_t.
This was introduced by commit bd471258f2, to pass uidguid
type checks : UIDGID_STRICT_TYPE_CHECKS, which has been
removed from kernel in commit 261000a56b6.

Fixes: bd471258f2 (logger: use kuid_t instead of uid_t)
Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
---
  drivers/staging/android/logger.c | 4 ++--
  drivers/staging/android/logger.h | 2 +-
  2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 28b93d3..fb06bf2 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -252,7 +252,7 @@ static size_t get_next_entry_by_uid(struct logger_log *log,

  		entry = get_entry_header(log, off, &scratch);

-		if (uid_eq(entry->euid, euid))
+		if (entry->euid == __kuid_val(euid))
  			return off;

  		next_len = sizeof(struct logger_entry) + entry->len;
@@ -430,7 +430,7 @@ static ssize_t logger_write_iter(struct kiocb *iocb, struct iov_iter *from)
  	header.tid = current->pid;
  	header.sec = now.tv_sec;
  	header.nsec = now.tv_nsec;
-	header.euid = current_euid();
+	header.euid = __kuid_val(current_euid());
  	header.len = count;
  	header.hdr_size = sizeof(struct logger_entry);

diff --git a/drivers/staging/android/logger.h b/drivers/staging/android/logger.h
index 70af7d8..cc6bbd9 100644
--- a/drivers/staging/android/logger.h
+++ b/drivers/staging/android/logger.h
@@ -66,7 +66,7 @@ struct logger_entry {
  	__s32		tid;
  	__s32		sec;
  	__s32		nsec;
-	kuid_t		euid;
+	uid_t		euid;
  	char		msg[0];
  };

-- 
1.9.3

