Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760449Ab3BMRwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:52:34 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:53410 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760178Ab3BMRwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:52:33 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sage Weil <sage@inktank.com>
Date: Wed, 13 Feb 2013 09:50:50 -0800
Message-Id: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <87621w14vs.fsf@xmission.com>
References: <87621w14vs.fsf@xmission.com>
X-XM-AID: U2FsdGVkX1+CeHPpcJWpNmLpxhLRMQLl9M1jlhNlcGE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0081]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 01/85] ceph: Only allow mounts in the initial network namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Today ceph opens tcp sockets from a delayed work callback.  Delayed
work happens from kernel threads which are always in the initial
network namespace.   Therefore fail early if someone attempts
to mount a ceph filesystem from something other than the initial
network namespace.

Cc: Sage Weil <sage@inktank.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 net/ceph/ceph_common.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index ee71ea2..1deb29a 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -15,6 +15,8 @@
 #include <linux/slab.h>
 #include <linux/statfs.h>
 #include <linux/string.h>
+#include <linux/nsproxy.h>
+#include <net/net_namespace.h>
 
 
 #include <linux/ceph/ceph_features.h>
@@ -292,6 +294,9 @@ ceph_parse_options(char *options, const char *dev_name,
 	int err = -ENOMEM;
 	substring_t argstr[MAX_OPT_ARGS];
 
+	if (current->nsproxy->net_ns != &init_net)
+		return ERR_PTR(-EINVAL);
+
 	opt = kzalloc(sizeof(*opt), GFP_KERNEL);
 	if (!opt)
 		return ERR_PTR(-ENOMEM);
-- 
1.7.5.4

