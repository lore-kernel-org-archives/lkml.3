Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965025Ab3BMR55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:57:57 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49088 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964964Ab3BMR5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:51 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>
Date: Wed, 13 Feb 2013 09:51:04 -0800
Message-Id: <1360777934-5663-15-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+TwnYXh082oWnrayu8yorwTZM9l0I0l6k=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 15/85] afs: Only allow mounting afs in the intial network namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

rxrpc sockets only work in the initial network namespace so it isn't
possible to support afs in any other network namespace.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/afs/super.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/afs/super.c b/fs/afs/super.c
index 4316500..7c31ec3 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -24,6 +24,8 @@
 #include <linux/parser.h>
 #include <linux/statfs.h>
 #include <linux/sched.h>
+#include <linux/nsproxy.h>
+#include <net/net_namespace.h>
 #include "internal.h"
 
 #define AFS_FS_MAGIC 0x6B414653 /* 'kAFS' */
@@ -363,6 +365,10 @@ static struct dentry *afs_mount(struct file_system_type *fs_type,
 
 	memset(&params, 0, sizeof(params));
 
+	ret = -EINVAL;
+	if (current->nsproxy->net_ns != &init_net)
+		goto error;
+
 	/* parse the options and device name */
 	if (options) {
 		ret = afs_parse_options(&params, options, &dev_name);
-- 
1.7.5.4

