Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbaJCVo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:44:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbaJCVnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.16 216/357] x86/kaslr: Avoid the setup_data area when picking location
Date: Fri,  3 Oct 2014 14:30:02 -0700
Message-Id: <20141003212940.013998664@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 0cacbfbeb5077b63d5d3cf6df88b14ac12ad584b upstream.

The KASLR location-choosing logic needs to avoid the setup_data
list memory areas as well. Without this, it would be possible to
have the ASLR position stomp on the memory, ultimately causing
the boot to fail.

Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140911161931.GA12001@www.outflux.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/aslr.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -183,12 +183,27 @@ static void mem_avoid_init(unsigned long
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
 


