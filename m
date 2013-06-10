Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3FJV6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:58:37 -0400
Received: from mail-ye0-f175.google.com ([209.85.213.175]:38649 "EHLO
	mail-ye0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3FJV6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:58:36 -0400
From: "Raphael S. Carvalho" <raphael.scarv@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Raphael S.Carvalho" <raphael.scarv@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "Raphael S. Carvalho" <raphael.scarv@gmail.com>
Subject: [PATCH 1/1] kernel/pid.c: Masking the flag out to get the actual value.
Date: Mon, 10 Jun 2013 18:56:38 -0300
Message-Id: <1370901398-8989-1-git-send-email-raphael.scarv@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch shouldn't be applied if those branches must only be taken when
the pid_allocation(PIDNS_HASH_ADDING) flag was turned off.
Otherwise, we must turn the PIDNS_HASH_ADDING flag (1U << 31) off
before getting into the switch-cases.

Signed-off-by: Raphael S. Carvalho <raphael.scarv@gmail.com>
---
 kernel/pid.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 0db3e79..6bda527 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -263,7 +263,10 @@ void free_pid(struct pid *pid)
 		struct upid *upid = pid->numbers + i;
 		struct pid_namespace *ns = upid->ns;
 		hlist_del_rcu(&upid->pid_chain);
-		switch(--ns->nr_hashed) {
+
+		/* We must turn the PIDNS_HASH_ADDING flag off to
+		   get the actual value of nr_hashed */
+		switch ((--ns->nr_hashed) & ~(PIDNS_HASH_ADDING)) {
 		case 1:
 			/* When all that is left in the pid namespace
 			 * is the reaper wake up the reaper.  The reaper
-- 
1.7.2.5

