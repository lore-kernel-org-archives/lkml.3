Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab3JKKrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:47:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58819 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab3JKKoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:44:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Passion,Zhao" <passion.zhao@intel.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 093/100] Smack: Fix the bug smackcipso can't set CIPSO correctly
Date: Fri, 11 Oct 2013 11:42:03 +0100
Message-Id: <1381488130-30235-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Passion,Zhao" <passion.zhao@intel.com>

commit 0fcfee61d63b82c1eefb5b1a914240480f17d63f upstream.

Bug report: https://tizendev.org/bugs/browse/TDIS-3891

The reason is userspace libsmack only use "smackfs/cipso2" long-label interface,
but the code's logical is still for orginal fixed length label. Now update
smack_cipso_apply() to support flexible label (<=256 including tailing '\0')

There is also a bug in kernel/security/smack/smackfs.c:
When smk_set_cipso() parsing the CIPSO setting from userspace, the offset of
CIPSO level should be "strlen(label)+1" instead of "strlen(label)"

Signed-off-by: Passion,Zhao <passion.zhao@intel.com>
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 security/smack/smackfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index cb6d904..fccf04f 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -819,7 +819,7 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 	if (format == SMK_FIXED24_FMT)
 		rule += SMK_LABELLEN;
 	else
-		rule += strlen(skp->smk_known);
+		rule += strlen(skp->smk_known) + 1;
 
 	ret = sscanf(rule, "%d", &maplevel);
 	if (ret != 1 || maplevel > SMACK_CIPSO_MAXLEVEL)
-- 
1.8.3.2

