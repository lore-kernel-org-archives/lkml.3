Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762343AbbA1FQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:16:14 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55292 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762326AbbA1FQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 00:16:11 -0500
Date: Wed, 28 Jan 2015 10:46:06 +0530
From: Tina Ruchandani <ruchandani.tina@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v2] coredump: Use 64bit time for unix time of coredump
Message-ID: <20150128051606.GA4659@tinar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct timeval on 32-bit systems will have its tv_sec
value overflow in year 2038 and beyond.
Use a 64 bit value to print time of the coredump in seconds.
ktime_get_real_seconds is chosen here for efficiency reasons.

Suggested by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
---
Changes in v2:
	- use ktime_get_real_seconds instead of getnstimeofday64
	- fix printf format string:should work on 32-bit systems too.
---
 fs/coredump.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index b5c86ff..d118c1d 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -32,6 +32,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/compat.h>
+#include <linux/timekeeping.h>

 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -225,9 +226,10 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm)
 				break;
 			/* UNIX time of coredump */
 			case 't': {
-				struct timeval tv;
-				do_gettimeofday(&tv);
-				err = cn_printf(cn, "%lu", tv.tv_sec);
+				time64_t time;
+
+				time = ktime_get_real_seconds();
+				err = cn_printf(cn, "%lld", time);
 				break;
 			}
 			/* hostname */
--
2.2.0.rc0.207.ga3a616c

