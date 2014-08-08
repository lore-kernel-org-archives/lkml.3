Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaHHU2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:28:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8944 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbaHHU2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:28:37 -0400
From: Josef Bacik <jbacik@fb.com>
To: <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace-cmd: make sure we have a pending pid in trace-hist
Date: Fri, 8 Aug 2014 16:26:17 -0400
Message-ID: <1407529577-15548-1-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-08_05:2014-08-08,2014-08-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=9.44799793956008e-13 kscore.compositescore=0
 circleOfTrustscore=22.6900859407804 compositescore=0.997695897463551
 urlsuspect_oldscore=0.997695897463551 suspectscore=2
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408080242
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a trace.dat file where we lost some events and so we didn't have the
corresponding event to go with the stack trace.  This made trace-cmd hist
segfault because it unconditionally pushes the pending_pid's function onto the
stack trace.  In this case pending_pid < 0, which means we didn't have a pending
stack trace, so we got garbage in the call chain and hilarity ensued.  Fix this
by only pushing the pending call chain if there actually is one, and also don't
reset the current call chain if there isn't actually one there either.  This
fixed my segfault.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 trace-hist.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/trace-hist.c b/trace-hist.c
index 73820de..574549e 100644
--- a/trace-hist.c
+++ b/trace-hist.c
@@ -453,9 +453,11 @@ process_kernel_stack(struct pevent *pevent, struct pevent_record *record)
 		}
 	} else {
 		/* function stack trace? */
-		copy_stack_to_pending(current_pid);
-		free(ips);
-		reset_stack();
+		if (current_pid >= 0) {
+			copy_stack_to_pending(current_pid);
+			free(ips);
+			reset_stack();
+		}
 	}
 
 	current_pid = pid;
@@ -482,8 +484,10 @@ process_kernel_stack(struct pevent *pevent, struct pevent_record *record)
 			push_stack_func(func);
 	}
 
-	push_stack_func(pending_ips[pending_ips_idx - 1]);
-	reset_pending_stack();
+	if (pending_pid >= 0) {
+		push_stack_func(pending_ips[pending_ips_idx - 1]);
+		reset_pending_stack();
+	}
 	save_call_chain(current_pid, ips, ips_idx, 1);
 	if (do_restore)
 		restore_stack(current_pid);
-- 
2.0.0

