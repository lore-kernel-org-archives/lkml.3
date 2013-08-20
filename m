Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3HTDkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:40:31 -0400
Received: from intranet.asianux.com ([58.214.24.6]:5115 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3HTDka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:40:30 -0400
X-Spam-Score: -101.1
Message-ID: <5212E4F2.5010001@asianux.com>
Date: Tue, 20 Aug 2013 11:39:30 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        Mel Gorman <mgorman@suse.de>, riel@redhat.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] kernel/sysctl.c: simplify code for C code readers
References: <5212E481.9080204@asianux.com> <5212E4B2.5020708@asianux.com>
In-Reply-To: <5212E4B2.5020708@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In related functions, they have already had tag 'free', so use 'goto'
instead of 'break' to keep one (not multiple) style in each function.

Also remove useless checking 'err' code or move it to related 'if' code
block.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/sysctl.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ee00986..c05e2cd 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1958,27 +1958,28 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 					     proc_wspace_sep,
 					     sizeof(proc_wspace_sep), NULL);
 			if (err)
-				break;
+				goto free;
 			if (conv(&neg, &lval, i, 1, data)) {
 				err = -EINVAL;
-				break;
+				goto free;
 			}
 		} else {
 			if (conv(&neg, &lval, i, 0, data)) {
 				err = -EINVAL;
-				break;
+				goto free;
 			}
-			if (!first)
+			if (!first) {
 				err = proc_put_char(&buffer, &left, '\t');
-			if (err)
-				break;
+				if (err)
+					goto free;
+			}
 			err = proc_put_long(&buffer, &left, lval, neg);
 			if (err)
-				break;
+				goto free;
 		}
 	}
 
-	if (!write && !first && left && !err)
+	if (!write && !first && left)
 		err = proc_put_char(&buffer, &left, '\n');
 	if (write && !err && left)
 		left -= proc_skip_spaces(&kbuf);
@@ -2206,7 +2207,7 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 					     proc_wspace_sep,
 					     sizeof(proc_wspace_sep), NULL);
 			if (err)
-				break;
+				goto free;
 			if (neg)
 				continue;
 			if ((min && val < *min) || (max && val > *max))
@@ -2221,11 +2222,11 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 			}
 			err = proc_put_long(&buffer, &left, val, false);
 			if (err)
-				break;
+				goto free;
 		}
 	}
 
-	if (!write && !first && left && !err)
+	if (!write && !first && left)
 		err = proc_put_char(&buffer, &left, '\n');
 	if (write && !err)
 		left -= proc_skip_spaces(&kbuf);
@@ -2515,7 +2516,7 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
 			return -ENOMEM;
 		}
 		proc_skip_char(&kbuf, &left, '\n');
-		while (!err && left) {
+		while (left) {
 			unsigned long val_a, val_b;
 			bool neg;
 
-- 
1.7.7.6
