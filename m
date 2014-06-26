Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbaFZQWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:22:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43299 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754498AbaFZQWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:22:36 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-kernel@vger.kernel.org>, <rostedt@goodmis.org>
Subject: [PATCH] trace-cmd: handle NULL comm name in .dat file
Date: Thu, 26 Jun 2014 09:22:12 -0700
Message-ID: <1403799732-30308-1-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-26_06:2014-06-26,2014-06-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=22.4078557653337
 compositescore=0.997695897463551 urlsuspect_oldscore=0.997695897463551
 suspectscore=2 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406260166
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes the comm field in the trace.dat file can be empty which means that the
event parsing stuff can pass a NULL into pevent_register_comm.  To fix this just
check if we are NULL and generate a bogus comm name for that PID.  This keeps us
from segfaulting.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 event-parse.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/event-parse.c b/event-parse.c
index 18b3587..00304fe 100644
--- a/event-parse.c
+++ b/event-parse.c
@@ -303,7 +303,10 @@ int pevent_register_comm(struct pevent *pevent, const char *comm, int pid)
 	if (!item)
 		return -1;
 
-	item->comm = strdup(comm);
+	if (comm)
+		item->comm = strdup(comm);
+	else
+		item->comm = strdup("<...>");
 	if (!item->comm) {
 		free(item);
 		return -1;
-- 
2.0.0

