Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab3LTJmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:42:35 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58707 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269Ab3LTJln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:41:43 -0500
X-AuditID: 85900ec0-d1328b9000001514-c2-52b410d4e5f7
Subject: [PATCH 2/2] printk: Delete LOG_NEWLINE flag for structured printk
To: linux-kernel@vger.kernel.org
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Tejun Heo <tj@kernel.org>, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Date: Fri, 20 Dec 2013 18:41:39 +0900
Message-ID: <20131220094139.24233.9630.stgit@yunodevel>
In-Reply-To: <20131220094134.24233.2969.stgit@yunodevel>
References: <20131220094134.24233.2969.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete LOG_NEWLINE flag for structured printk.
When structured printk is used, the next printk message is output in a new line
from patch c313af145b9bc4fb8e8e0c83b8cfc10e1b894a50. However, in a following
pseudo SCSI error test, the device information and the detail information are
divided:

-- Pseudo SCSI error test for current kernel
  # modprobe scsi_debug
  # cd /sys/bus/pseudo/drivers/scsi_debug
  # echo 2 > opts
  # dd if=/dev/sdb of=/dev/null 2> /dev/null

-- Result for current kernel
  # dmesg

[   17.842110] sd 2:0:0:0: [sdb] Attached SCSI disk
[   18.859098] sd 2:0:0:0: [sdb] Unhandled sense code
[   18.859103] sd 2:0:0:0: [sdb]
[   18.859106] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   18.859108] sd 2:0:0:0: [sdb]
[   18.859110] Sense Key : Medium Error [current]
[   18.859114] Info fld=0x1234
[   18.859116] sd 2:0:0:0: [sdb]
[   18.859119] Add. Sense: Unrecovered read error
[   18.859122] sd 2:0:0:0: [sdb] CDB:
[   18.859124] Read(10): 28 00 00 00 11 e0 00 01 00 00

This is because the virtual scsi device outputs the error message as follows:
   scmd_printk(KERN_INFO, scmd, "DEVICE INFORMATION");
   printk("DETAIL INFORMATION");
   printk("\n");
Here, "DETAIL INFORMATION" expects scmd_printk() does not include "\n".
So, by applying this patch, the detail information is continued as follows:

  # dmesg

[   17.145085]  sdb: unknown partition table
[   17.149096] sd 2:0:0:0: [sdb] Attached SCSI disk
[   18.166090] sd 2:0:0:0: [sdb] Unhandled sense code
[   18.166095] sd 2:0:0:0: [sdb]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   18.166099] sd 2:0:0:0: [sdb]  Sense Key : Medium Error [current]
[   18.166104] Info fld=0x1234
[   18.166106] sd 2:0:0:0: [sdb]  Add. Sense: Unrecovered read error
[   18.166111] sd 2:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 11 e0 00 01 00 00

-- Multiple dictionary information

This patch combines multiple dictionary information.
We can read the combined dictionary information from /dev/kmsg.
<For example>
   printk("===========================================\n");
   printk("---- printk + printk_emit ----\n");
   printk("foo");
   printk_emit(0, -1, "dictdict",  8, "bar\n");

   printk("---- printk_emit + printk ----\n");
   printk_emit(0, -1, "DICTDICT",  8, "foo");
   printk("bar\n");

   printk("---- printk_emit + printk_emit ----\n");
   printk_emit(0, -1, "DICTDICT",  8, "foo");
   printk_emit(0, -1, "dictdict",  8, "bar\n");
   printk("===========================================\n");

<Result>
  4,248194,2045485319,-;===========================================
  4,248195,2045485321,-;---- printk + printk_emit ----
  4,248196,2045485322,-;foobar
   dictdict
  4,248197,2045485324,-;---- printk_emit + printk ----
  4,248198,2045485324,-;foobar
   DICTDICT
  4,248199,2045485325,-;---- printk_emit + printk_emit ----
  4,248200,2045485328,-;foobar
   DICTDICTdictdict
  4,248201,2045485329,-;===========================================

-- Dictionary information in a competition state

This patch does not delete or duplicate the dictionary information in a
competition state in SMP.
<For example>
 - Thread1
   printk("(AAAA");
   printk_emit(0, -1, "aaaaaaaa", 8, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
   printk("AAAA)\n");

 - Thread2
   printk("(BBBB");
   printk_emit(0, -1, "bbbbbbbb", 8, "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
   printk("BBBB)\n");

 - Thread3
   printk("(CCCC");
   printk_emit(0, -1, "cccccccc", 8, "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
   printk("CCCC)");

<Result>
4,229312,1819040124,-;(BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB)
 bbbbbbbb
4,229313,1819042116,-;(AAAA
4,229314,1819042118,-;(BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
 bbbbbbbb
4,229315,1819042123,-;AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
 aaaaaaaa
4,229316,1819042126,-;BBBB)
4,229317,1819042129,-;(CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC)
 cccccccc
4,229318,1819044105,-;(AAAA
4,229319,1819044108,-;(CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
 cccccccc
4,229320,1819044112,-;AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
 aaaaaaaa
4,229321,1819044115,-;CCCC)
4,229322,1819044118,-;(BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB)
 bbbbbbbb
4,229323,1819046113,-;(BBBB
4,229324,1819046117,-;(AAAA
4,229325,1819046118,-;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB)
 bbbbbbbb

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/printk/printk.c |   38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index c3662e6..a28516b 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1418,7 +1418,8 @@ static void cont_flush(enum log_flags flags)
 		 * line. LOG_NOCONS suppresses a duplicated output.
 		 */
 		log_store(cont.facility, cont.level, flags | LOG_NOCONS,
-			  cont.ts_nsec, NULL, 0, cont.text, cont.text_len);
+			  cont.ts_nsec, cont.dict, cont.dict_len,
+			  cont.text, cont.text_len);
 		cont.flags = flags;
 		cont.flushed = true;
 	} else {
@@ -1427,9 +1428,10 @@ static void cont_flush(enum log_flags flags)
 		 * just submit it to the store and free the buffer.
 		 */
 		log_store(cont.facility, cont.level, flags, 0,
-			  NULL, 0, cont.text, cont.text_len);
-		cont.text_len = 0;
+			  cont.dict, cont.dict_len, cont.text, cont.text_len);
 	}
+	cont.text_len = 0;
+	cont.dict_len = 0;
 }
 
 static void cont_dict_add(const char *dict, size_t dict_len)
@@ -1441,7 +1443,8 @@ static void cont_dict_add(const char *dict, size_t dict_len)
 	cont.dict_len += dict_len;
 }
 
-static bool cont_add(int facility, int level, const char *text, size_t text_len)
+static bool cont_add(int facility, int level, const char *dict, size_t dict_len,
+		     const char *text, size_t text_len)
 {
 	if (cont.text_len && cont.flushed)
 		return false;
@@ -1464,6 +1467,7 @@ static bool cont_add(int facility, int level, const char *text, size_t text_len)
 
 	memcpy(cont.text + cont.text_len, text, text_len);
 	cont.text_len += text_len;
+	cont_dict_add(dict, dict_len);
 
 	if (cont.text_len > (sizeof(cont.text) * 80) / 100)
 		cont_flush(LOG_CONT);
@@ -1587,14 +1591,10 @@ asmlinkage int vprintk_emit(int facility, int level,
 	if (level == -1)
 		level = default_message_loglevel;
 
-	if (dict) {
-		lflags |= LOG_PREFIX|LOG_NEWLINE;
-
-		/* Another task is trying to output a message */
-		if (cont.text_len && cont.owner != current)
-			cont_flush(LOG_NEWLINE);
-
-		cont_dict_add(dict, dictlen);
+	if (!dict) {
+		/* Discard dictionary information except for KERN_CONT */
+		if (lflags & LOG_PREFIX)
+			cont.dict_len = 0;
 	}
 
 	if (!(lflags & LOG_NEWLINE)) {
@@ -1607,9 +1607,9 @@ asmlinkage int vprintk_emit(int facility, int level,
 			cont_flush(LOG_NEWLINE);
 
 		/* buffer line if possible, otherwise store it right away */
-		if (!cont_add(facility, level, text, text_len))
+		if (!cont_add(facility, level, dict, dictlen, text, text_len))
 			log_store(facility, level, lflags | LOG_CONT, 0,
-				  NULL, 0, text, text_len);
+				  cont.dict, cont.dict_len, text, text_len);
 	} else {
 		bool stored = false;
 
@@ -1621,18 +1621,14 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 */
 		if (cont.text_len && cont.owner == current) {
 			if (!(lflags & LOG_PREFIX))
-				stored = cont_add(facility, level, text, text_len);
+				stored = cont_add(facility, level, dict,
+						  dictlen, text, text_len);
 			cont_flush(LOG_NEWLINE);
 		}
 
 		if (!stored)
 			log_store(facility, level, lflags, 0,
-				  cont.dict, cont.dict_len, text, text_len);
-		/*
-		 * Structured printk always starts a new line now, so clear
-		 * current dictionary information for next structured printk.
-		 */
-		cont.dict_len = 0;
+				  dict, dictlen, text, text_len);
 	}
 	printed_len += text_len;
 

