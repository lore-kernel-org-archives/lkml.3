Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaEAV2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:28:37 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40203 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbaEAV2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:28:19 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Aaron Tomlin <atomlin@redhat.com>,
        Li Zefan <lizefan@huawei.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ryan Mallon <rmallon@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Dario Faggioli <raistlin@linux.it>, Jens Axboe <axboe@fb.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Ellerman <michael@ellerman.id.au>, linux-doc@vger.kernel.org
Subject: [PATCH 2/4] sysctl: refactor sysctl string writing logic
Date: Thu,  1 May 2014 14:26:35 -0700
Message-Id: <1398979597-3589-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398979597-3589-1-git-send-email-keescook@chromium.org>
References: <1398979597-3589-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate buffer length checking with new-line/end-of-line checking.
Additionally, instead of reading user memory twice, just do the assignment
during the loop.

This change doesn't affect the potential races here. It was already
possible to read a sysctl that was in the middle of a write. In both
cases, the string will always be NULL terminated. The pre-existing race
remains a problem to be solved.

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

