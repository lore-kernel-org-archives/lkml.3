Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaFWIrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:47:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55530 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Schmidt <mschmidt@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 094/111] netlink: rate-limit leftover bytes warning and print process name
Date: Mon, 23 Jun 2014 10:32:09 +0200
Message-Id: <ec2ab4bc695981aac49a33317c9d8b541f2babd1.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Schmidt <mschmidt@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit bfc5184b69cf9eeb286137640351c650c27f118a ]

Any process is able to send netlink messages with leftover bytes.
Make the warning rate-limited to prevent too much log spam.

The warning is supposed to help find userspace bugs, so print the
triggering command name to implicate the buggy program.

[v2: Use pr_warn_ratelimited instead of printk_ratelimited.]

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 lib/nlattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index fc6754720ced..10ad042d01be 100644
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
2.0.0

