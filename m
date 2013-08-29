Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab3H2Xzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:55:46 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60763 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab3H2Xzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:55:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, <linux-kernel@vger.kernel.org>
References: <87ob8gys0d.fsf@xmission.com>
Date: Thu, 29 Aug 2013 16:55:35 -0700
In-Reply-To: <87ob8gys0d.fsf@xmission.com> (Eric W. Biederman's message of
	"Thu, 29 Aug 2013 16:52:18 -0700")
Message-ID: <8761uoyruw.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18OI0+fljzR/Q69MwearwFVZwsOSYo+ojI=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0009]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 4/5] capabilities: allow nice if we are privileged
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We allow task A to change B's nice level if it has a supserset of
B's privileges, or of it has CAP_SYS_NICE.  Also allow it if A has
CAP_SYS_NICE with respect to B - meaning it is root in the same
namespace, or it created B's namespace.

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 security/commoncap.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 9fccf71..b9d613e 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -768,16 +768,16 @@ int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags)
  */
 static int cap_safe_nice(struct task_struct *p)
 {
-	int is_subset;
+	int is_subset, ret = 0;
 
 	rcu_read_lock();
 	is_subset = cap_issubset(__task_cred(p)->cap_permitted,
 				 current_cred()->cap_permitted);
+	if (!is_subset && !ns_capable(__task_cred(p)->user_ns, CAP_SYS_NICE))
+		ret = -EPERM;
 	rcu_read_unlock();
 
-	if (!is_subset && !capable(CAP_SYS_NICE))
-		return -EPERM;
-	return 0;
+	return ret;
 }
 
 /**
-- 
1.7.5.4

