Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbaKRUc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:32:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9162 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754214AbaKRUc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:32:27 -0500
Date: Tue, 18 Nov 2014 12:32:21 -0800
From: Calvin Owens <calvinowens@fb.com>
To: Eric Paris <eparis@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        <stable@vger.kernel.org>
Subject: [PATCH][RESEND] Revert "AUDIT: Allow login in non-init namespaces"
Message-ID: <20141118203221.GA1687992@mail.thefacebook.com>
References: <1415148371-11742-1-git-send-email-calvinowens@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1415148371-11742-1-git-send-email-calvinowens@fb.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-18_07:2014-11-15,2014-11-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411180157
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts 543bc6a1a987 "AUDIT: Allow login in non-init namespaces".

This commit incorrectly assumes that libpam treats -ECONNREFUSED as
an indicator that audit is disabled, and -EPERM or any other error
as a fatal error that prevents the login from continuing.

The opposite is in fact true: -EPERM allows the login to continue,
and -ECONNREFUSED causes it to refuse the login. This behavior has
been unchanged in upstream linux-pam since at least 2008.

Reverting this change allows libpam to again work as expected in
non-init user namespaces.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
Cc: stable@vger.kernel.org
---
Relevant code in linux-pam:
https://git.fedorahosted.org/cgit/linux-pam.git/tree/libpam/pam_audit.c#n56

 kernel/audit.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 80983df..656e8ce 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -640,18 +640,8 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 	int err = 0;
 
 	/* Only support initial user namespace for now. */
-	/*
-	 * We return ECONNREFUSED because it tricks userspace into thinking
-	 * that audit was not configured into the kernel.  Lots of users
-	 * configure their PAM stack (because that's what the distro does)
-	 * to reject login if unable to send messages to audit.  If we return
-	 * ECONNREFUSED the PAM stack thinks the kernel does not have audit
-	 * configured in and will let login proceed.  If we return EPERM
-	 * userspace will reject all logins.  This should be removed when we
-	 * support non init namespaces!!
-	 */
 	if (current_user_ns() != &init_user_ns)
-		return -ECONNREFUSED;
+		return -EPERM;
 
 	switch (msg_type) {
 	case AUDIT_LIST:
-- 
2.1.1
