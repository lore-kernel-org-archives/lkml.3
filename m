Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab3CSCbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:31:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46267 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978Ab3CSCbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:31:13 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v3 13/21] kexec: allocate vmcoreinfo note buffer on page-size
 boundary
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Date: Sat, 16 Mar 2013 13:02:00 +0900
Message-ID: <20130316040200.15064.86851.stgit@localhost6.localdomain6>
In-Reply-To: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To satisfy mmap()'s page-size boundary requirement, specify aligned
attribute to vmcoreinfo_note objects to allocate it on page-size
boundary.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 include/linux/kexec.h |    6 ++++--
 kernel/kexec.c        |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index d2e6927..5113570 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -185,8 +185,10 @@ extern struct kimage *kexec_crash_image;
 #define VMCOREINFO_BYTES           (4096)
 #define VMCOREINFO_NOTE_NAME       "VMCOREINFO"
 #define VMCOREINFO_NOTE_NAME_BYTES ALIGN(sizeof(VMCOREINFO_NOTE_NAME), 4)
-#define VMCOREINFO_NOTE_SIZE       (KEXEC_NOTE_HEAD_BYTES*2 + VMCOREINFO_BYTES \
-				    + VMCOREINFO_NOTE_NAME_BYTES)
+#define VMCOREINFO_NOTE_SIZE       ALIGN(KEXEC_NOTE_HEAD_BYTES*2	\
+					 +VMCOREINFO_BYTES		\
+					 +VMCOREINFO_NOTE_NAME_BYTES,	\
+					 PAGE_SIZE)
 
 /* Location of a reserved region to hold the crash kernel.
  */
diff --git a/kernel/kexec.c b/kernel/kexec.c
index d1f365e..195de6d 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -43,7 +43,7 @@ note_buf_t __percpu *crash_notes;
 
 /* vmcoreinfo stuff */
 static unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
-u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
+u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4] __aligned(PAGE_SIZE);
 size_t vmcoreinfo_size;
 size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
 

