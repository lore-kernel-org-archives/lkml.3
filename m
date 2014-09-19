Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbaISLti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:49:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56351 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050AbaISLtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:49:35 -0400
Date: Fri, 19 Sep 2014 04:49:07 -0700
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-0cacbfbeb5077b63d5d3cf6df88b14ac12ad584b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, bhe@redhat.com,
        rafael.j.wysocki@intel.com, vgoyal@redhat.com, pavel@ucw.cz,
        keescook@chromium.org, yongjun_wei@trendmicro.com.cn,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bhe@redhat.com, torvalds@linux-foundation.org,
        rafael.j.wysocki@intel.com, vgoyal@redhat.com, pavel@ucw.cz,
        keescook@chromium.org, yongjun_wei@trendmicro.com.cn,
        tglx@linutronix.de
In-Reply-To: <20140911161931.GA12001@www.outflux.net>
References: <20140911161931.GA12001@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/kaslr:
  Avoid the setup_data area when picking location
Git-Commit-ID: 0cacbfbeb5077b63d5d3cf6df88b14ac12ad584b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0cacbfbeb5077b63d5d3cf6df88b14ac12ad584b
Gitweb:     http://git.kernel.org/tip/0cacbfbeb5077b63d5d3cf6df88b14ac12ad584b
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Thu, 11 Sep 2014 09:19:31 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 13:04:29 +0200

x86/kaslr: Avoid the setup_data area when picking location

The KASLR location-choosing logic needs to avoid the setup_data
list memory areas as well. Without this, it would be possible to
have the ASLR position stomp on the memory, ultimately causing
the boot to fail.

Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Baoquan He <bhe@redhat.com>
Cc: stable@vger.kernel.org
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140911161931.GA12001@www.outflux.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/boot/compressed/aslr.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index fc6091a..d39189b 100644
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
 
