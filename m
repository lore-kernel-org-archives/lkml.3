Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab3HBJQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:16:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20795 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755010Ab3HBJQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:16:09 -0400
X-IronPort-AV: E=Sophos;i="4.89,800,1367942400"; 
   d="scan'208";a="8098113"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH v2 RESEND 02/18] earlycpio.c: Fix the confusing comment of find_cpio_data().
Date: Fri, 2 Aug 2013 17:14:21 +0800
Message-Id: <1375434877-20704-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375434877-20704-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1375434877-20704-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/02 17:14:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/02 17:14:52,
	Serialize complete at 2013/08/02 17:14:52
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

