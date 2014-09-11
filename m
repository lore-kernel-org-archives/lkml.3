Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbaIKQUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:20:08 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42304 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaIKQUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:20:06 -0400
Date: Thu, 11 Sep 2014 09:19:31 -0700
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH] x86, kaslr: avoid setup_data when picking location
Message-ID: <20140911161931.GA12001@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The KASLR location-choosing logic needs to avoid the setup_data list
memory areas as well. Without this, it would be possible to have the
ASLR position stomp on the memory, ultimately causing the boot to fail.

Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Baoquan He <bhe@redhat.com>
Cc: stable@vger.kernel.org
---
 arch/x86/boot/compressed/aslr.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index fc6091abedb7..d39189ba7f8e 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -183,12 +183,27 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 static bool mem_avoid_overlap(struct mem_vector *img)
 {
 	int i;
+	struct setup_data *ptr;
 
 	for (i = 0; i < MEM_AVOID_MAX; i++) {
 		if (mem_overlaps(img, &mem_avoid[i]))
 			return true;
 	}
 
+	/* Avoid all entries in the setup_data linked list. */
+	ptr = (struct setup_data *)(unsigned long)real_mode->hdr.setup_data;
+	while (ptr) {
+		struct mem_vector avoid;
+
+		avoid.start = (u64)ptr;
+		avoid.size = sizeof(*ptr) + ptr->len;
+
+		if (mem_overlaps(img, &avoid))
+			return true;
+
+		ptr = (struct setup_data *)(unsigned long)ptr->next;
+	}
+
 	return false;
 }
 
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
