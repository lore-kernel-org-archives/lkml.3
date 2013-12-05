Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab3LECrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:47:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756451Ab3LECrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:47:00 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
        Richard Guy Briggs <rgb@tricolour.ca>
Subject: [PATCH 3/3] audit: drop audit_cmd_lock in AUDIT_USER family of cases
Date: Wed,  4 Dec 2013 21:45:56 -0500
Message-Id: <53733434b27dc65bd16b2e73211b823da1fa64cf.1386206544.git.rgb@redhat.com>
In-Reply-To: <1382713941.2954.19.camel@flatline.rdu.redhat.com>
References: <1382713941.2954.19.camel@flatline.rdu.redhat.com>
In-Reply-To: <cover.1386206544.git.rgb@redhat.com>
References: <cover.1386206544.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not need to hold the audit_cmd_mutex for this family of cases.  The
possible exception to this is the call to audit_filter_user(), so drop the lock
immediately after.  To help in fixing the race we are trying to avoid, make
sure that nothing called by audit_filter_user() calls audit_log_start().  In
particular, watch out for *_audit_rule_match().

This fix will take care of systemd and anything USING audit.  It still means
that we could race with something configuring audit and auditd shutting down.

Signed-off-by: Richard Guy Briggs <rgb@tricolour.ca>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 4689012..4cbc945 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -713,6 +713,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				if (err)
 					break;
 			}
+			mutex_unlock(&audit_cmd_mutex);
 			audit_log_common_recv_msg(&ab, msg_type);
 			if (msg_type != AUDIT_USER_TTY)
 				audit_log_format(ab, " msg='%.1024s'",
@@ -729,6 +730,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			}
 			audit_set_pid(ab, NETLINK_CB(skb).portid);
 			audit_log_end(ab);
+			mutex_lock(&audit_cmd_mutex);
 		}
 		break;
 	case AUDIT_ADD_RULE:
-- 
1.7.1

