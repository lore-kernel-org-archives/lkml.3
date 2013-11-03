Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3KCOYo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 09:24:44 -0500
Received: from intranet.asianux.com ([58.214.24.6]:51123 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab3KCOYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 09:24:43 -0500
X-Spam-Score: -100.9
Message-ID: <52765C6B.7080608@asianux.com>
Date: Sun, 03 Nov 2013 22:23:39 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: trace: blktrace: remove redundent memcpy() in compat_blk_trace_setup()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_blk_trace_setup() will fully initialize 'buts.name', so can remove
the related memcpy(). And also use BLKTRACE_BDEV_SIZE and ARRAY_SIZE
instead of hard code number '32'.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/linux/blktrace_api.h |    2 +-
 kernel/trace/blktrace.c      |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index a12f6ed..afc1343 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -89,7 +89,7 @@ static inline int blk_trace_init_sysfs(struct device *dev)
 #ifdef CONFIG_COMPAT
 
 struct compat_blk_user_trace_setup {
-	char name[32];
+	char name[BLKTRACE_BDEV_SIZE];
 	u16 act_mask;
 	u32 buf_size;
 	u32 buf_nr;
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 7f727b3..f785aef 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -579,13 +579,12 @@ static int compat_blk_trace_setup(struct request_queue *q, char *name,
 		.end_lba = cbuts.end_lba,
 		.pid = cbuts.pid,
 	};
-	memcpy(&buts.name, &cbuts.name, 32);
 
 	ret = do_blk_trace_setup(q, name, dev, bdev, &buts);
 	if (ret)
 		return ret;
 
-	if (copy_to_user(arg, &buts.name, 32)) {
+	if (copy_to_user(arg, &buts.name, ARRAY_SIZE(buts.name))) {
 		blk_trace_remove(q);
 		return -EFAULT;
 	}
-- 
1.7.7.6
