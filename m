Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbaHHVNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:13:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41098 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658AbaHHUwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:52:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Schmidt <mschmidt@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 209/259] netlink: rate-limit leftover bytes warning and print process name
Date: Fri,  8 Aug 2014 13:40:32 -0700
Message-Id: <1407530482-4483-210-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit bfc5184b69cf9eeb286137640351c650c27f118a ]

Any process is able to send netlink messages with leftover bytes.
Make the warning rate-limited to prevent too much log spam.

The warning is supposed to help find userspace bugs, so print the
triggering command name to implicate the buggy program.

[v2: Use pr_warn_ratelimited instead of printk_ratelimited.]

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 lib/nlattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index fc67547..10ad042d 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -201,8 +201,8 @@ int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
 	}
 
 	if (unlikely(rem > 0))
-		printk(KERN_WARNING "netlink: %d bytes leftover after parsing "
-		       "attributes.\n", rem);
+		pr_warn_ratelimited("netlink: %d bytes leftover after parsing attributes in process `%s'.\n",
+				    rem, current->comm);
 
 	err = 0;
 errout:
-- 
1.9.1

