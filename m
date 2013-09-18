Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab3IRC4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 22:56:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab3IRC4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 22:56:01 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>,
        Justin Stephenson <jstephen@redhat.com>,
        LC Bruzenak <lenny@magitekltd.com>
Subject: [PATCH] audit: format user messages to size of MAX_AUDIT_MESSAGE_LENGTH
Date: Tue, 17 Sep 2013 22:55:16 -0400
Message-Id: <7e230309c0814b0d79ab6bcff51ed3dfd23703e1.1379472716.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Messages of type AUDIT_USER_TTY were being formatted to 1024 octets,
truncating messages approaching MAX_AUDIT_MESSAGE_LENGTH (8970 octets).

Set the formatting to 8560 characters, given maximum estimates for prefix and
suffix budgets.

See the problem discussion:
https://www.redhat.com/archives/linux-audit/2009-January/msg00030.html

And the new size rationale:
https://www.redhat.com/archives/linux-audit/2013-September/msg00016.html

Test ~8k messages with:
auditctl -m "$(for i in $(seq -w 001 820);do echo -n "${i}0______";done)"

Reported-by: LC Bruzenak <lenny@magitekltd.com>
Reported-by: Justin Stephenson <jstephen@redhat.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 91e53d0..939cff1 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -715,7 +715,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			}
 			audit_log_common_recv_msg(&ab, msg_type);
 			if (msg_type != AUDIT_USER_TTY)
-				audit_log_format(ab, " msg='%.1024s'",
+				audit_log_format(ab, " msg='%.8560s'",
 						 (char *)data);
 			else {
 				int size;
-- 
1.7.1

