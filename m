Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651Ab3HNJi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:38:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:24754 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759390Ab3HNJid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:38:33 -0400
X-IronPort-AV: E=Sophos;i="4.89,876,1367942400"; 
   d="scan'208";a="8200293"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, liwanp@linux.vnet.ibm.com, tj@kernel.org,
        zhangyanfei@cn.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] earlycpio.c: Fix the confusing comment of find_cpio_data().
Date: Wed, 14 Aug 2013 17:37:07 +0800
Message-Id: <1376473028-29380-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1376473028-29380-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1376473028-29380-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/14 17:36:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/14 17:36:58,
	Serialize complete at 2013/08/14 17:36:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comments of find_cpio_data() says:

  * @offset: When a matching file is found, this is the offset to the
  *          beginning of the cpio. ......

But according to the code,

  dptr = PTR_ALIGN(p + ch[C_NAMESIZE], 4);
  nptr = PTR_ALIGN(dptr + ch[C_FILESIZE], 4);
  ....
  *offset = (long)nptr - (long)data;	/* data is the cpio file */

@offset is the offset of the next file, not the matching file itself.
This is confused and may cause unnecessary waste of time to debug.
So fix it.

v1 -> v2:
As tj suggested, rename @offset to @nextoff which is more clear to
users. And also adjust the new comments.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
---
 lib/earlycpio.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/lib/earlycpio.c b/lib/earlycpio.c
index 7aa7ce2..c7ae5ed 100644
--- a/lib/earlycpio.c
+++ b/lib/earlycpio.c
@@ -49,22 +49,23 @@ enum cpio_fields {
 
 /**
  * cpio_data find_cpio_data - Search for files in an uncompressed cpio
- * @path:   The directory to search for, including a slash at the end
- * @data:   Pointer to the the cpio archive or a header inside
- * @len:    Remaining length of the cpio based on data pointer
- * @offset: When a matching file is found, this is the offset to the
- *          beginning of the cpio. It can be used to iterate through
- *          the cpio to find all files inside of a directory path
+ * @path:       The directory to search for, including a slash at the end
+ * @data:       Pointer to the the cpio archive or a header inside
+ * @len:        Remaining length of the cpio based on data pointer
+ * @nextoff:    When a matching file is found, this is the offset from the
+ *              beginning of the cpio to the beginning of the next file, not the
+ *              matching file itself. It can be used to iterate through the cpio
+ *              to find all files inside of a directory path 
  *
- * @return: struct cpio_data containing the address, length and
- *          filename (with the directory path cut off) of the found file.
- *          If you search for a filename and not for files in a directory,
- *          pass the absolute path of the filename in the cpio and make sure
- *          the match returned an empty filename string.
+ * @return:     struct cpio_data containing the address, length and
+ *              filename (with the directory path cut off) of the found file.
+ *              If you search for a filename and not for files in a directory,
+ *              pass the absolute path of the filename in the cpio and make sure
+ *              the match returned an empty filename string.
  */
 
 struct cpio_data find_cpio_data(const char *path, void *data,
-					  size_t len,  long *offset)
+				size_t len,  long *nextoff)
 {
 	const size_t cpio_header_len = 8*C_NFIELDS - 2;
 	struct cpio_data cd = { NULL, 0, "" };
@@ -124,7 +125,7 @@ struct cpio_data find_cpio_data(const char *path, void *data,
 		if ((ch[C_MODE] & 0170000) == 0100000 &&
 		    ch[C_NAMESIZE] >= mypathsize &&
 		    !memcmp(p, path, mypathsize)) {
-			*offset = (long)nptr - (long)data;
+			*nextoff = (long)nptr - (long)data;
 			if (ch[C_NAMESIZE] - mypathsize >= MAX_CPIO_FILE_NAME) {
 				pr_warn(
 				"File %s exceeding MAX_CPIO_FILE_NAME [%d]\n",
-- 
1.7.1

