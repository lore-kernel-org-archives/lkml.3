Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaDRASc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:18:32 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48717 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbaDRAS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:18:28 -0400
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        David Howells <dhowells@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Li Zefan <lizefan@huawei.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Aaron Tomlin <atomlin@redhat.com>, Dario Faggioli <raistlin@linux.it>,
        Andrew Shewmaker <agshew@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Jens Axboe <axboe@fb.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH v2 2/4] sysctl: refactor sysctl string writing logic
Date: Thu, 17 Apr 2014 17:16:21 -0700
Message-Id: <1397780183-24633-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397780183-24633-1-git-send-email-keescook@chromium.org>
References: <1397780183-24633-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate buffer length checking with new-line/end-of-line checking.
Additionally, instead of reading user memory twice, just do the assignment
during the loop.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/sysctl.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index e7ff80a73c44..0e08103a69c8 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1712,21 +1712,18 @@ static int _proc_do_string(char *data, int maxlen, int write,
 	}
 
 	if (write) {
+		/* Start writing from beginning of buffer. */
 		len = 0;
+		*ppos += *lenp;
 		p = buffer;
-		while (len < *lenp) {
+		while ((p - buffer) < *lenp && len < maxlen - 1) {
 			if (get_user(c, p++))
 				return -EFAULT;
 			if (c == 0 || c == '\n')
 				break;
-			len++;
+			data[len++] = c;
 		}
-		if (len >= maxlen)
-			len = maxlen-1;
-		if(copy_from_user(data, buffer, len))
-			return -EFAULT;
 		data[len] = 0;
-		*ppos += *lenp;
 	} else {
 		len = strlen(data);
 		if (len > maxlen)
-- 
1.7.9.5

