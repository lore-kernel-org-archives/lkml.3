Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaGJEjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 00:39:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43679 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaGJEjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 00:39:07 -0400
X-AuditID: cbfee61b-f79f86d00000144c-f8-53be18e9e9be
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/2 v2] f2fs: check name_len of dir entry to prevent
 from deadloop
Date: Thu, 10 Jul 2014 12:37:46 +0800
Message-id: <001d01cf9bf8$df92faa0$9eb8efe0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+b9nm0GCymw5xQS+y8/IkzzaTL5Q==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jAd2XEvuCDaZcMLG4tq+RyeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqwem1Z1snnsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	Dr7vZC44xF2x9OsBtgbG2ZxdjBwcEgImEnc6sroYOYFMMYkL99azdTFycQgJLGKUmLB/GwtI
	QkjgB6PEmeXWIDabgIrE8o7/TCC2iICXxKT9J8BqmAUyJe41zWAGsYUF4iTeP7rMCDKfRUBV
	om1ZIUiYV8BSYtHmhcwQtqDEj8n3oFq1JNbvPM4EYctLbF7zlhniHgWJHWdfg40REdCTeHEj
	F6JEXGLjkVssExgFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4m
	RnBYP5PewbiqweIQowAHoxIPb0PP3mAh1sSy4srcQ4wSHMxKIrwe/4FCvCmJlVWpRfnxRaU5
	qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGM3+K8Tv+x3AU5LQ/F5XUWreop3G
	htsCRIrf1+TN22rNOFd+bnbmVQUJl9cCdzVnTngZGquQxCyaK8CauaTVairTvSMqb5X7mO8Y
	zA973p7TnNGVfGqxsyn74n8fz3pnpQnpHNlx5dfZ7JJb0gm2b6+z/rv+/6Bx4Xs2Nad/mU23
	jnqoiZQfVWIpzkg01GIuKk4EADr4FRxnAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We assume that modification of some special application could result in zeroed
name_len, or it is consciously made by somebody. We will deadloop in
find_in_block when name_len of dir entry is zero.

This patch is added for preventing deadloop in above scenario.

change log from v1:
 o use f2fs_bug_on rather than break out from searching dir entry suggested by
Jaegeuk Kim.

Jaegeuk describe:
"Well, IMO, it would be good to add f2fs_bug_on() here with a specific comment.
In the current phase of f2fs, it is more important to investigate the file
system bugs, rather than workarounds for any corrupted images.
And, definitely it needs to stop the kernel if any corrupted image was mounted,
so that we can figure out where the bugs are occurred."

Suggested-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/dir.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index e84e880..bcf893c 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -121,6 +121,13 @@ static struct f2fs_dir_entry *find_in_block(struct page *dentry_page,
 			*max_slots = max_len;
 			max_len = 0;
 		}
+
+		/*
+		 * For the most part, it should be a bug when name_len is zero.
+		 * We stop here for figuring out where the bugs are occurred.
+		 */
+		f2fs_bug_on(!de->name_len);
+
 		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 	}
 
-- 
2.0.1.474.g72c7794


