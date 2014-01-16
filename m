Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaAPXpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:45:50 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41110 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaAPXpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:45:47 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Date: Thu, 16 Jan 2014 15:45:38 -0800
Message-ID: <871u07wkwt.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/pEX4MHxqYgSOoiRFPWaccKdNz4tBGFtU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0047]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH] vfs: Don't leak a path when get_empty_filp in dentry_open
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Normally in dentry_open the passed in path is placed on the new filp
removing the caller from needing to worry about it.  In the rare case
that we can not allocate a filp the path is not consumed.  None of the
callers of dentry_open call path_put in their error handling when
dentry_open fails so call path_put for them on error and keep everyone's
error handling simple.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/open.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 4b3e1edf2fe4..0afa243941da 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -843,6 +843,8 @@ struct file *dentry_open(const struct path *path, int flags,
 			put_filp(f);
 			f = ERR_PTR(error);
 		}
+	} else {
+		path_put(path);
 	}
 	return f;
 }
-- 
1.7.5.4

