Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab3CKVUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:20:09 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:64924 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab3CKVUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:20:05 -0400
From: "Raphael S. Carvalho" <raphael.scarv@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
        "Raphael S.Carvalho" <raphael.scarv@gmail.com>
Subject: [PATCH 1/1] kernel/pid.c: Improve flow of a loop inside alloc_pidmap.
Date: Mon, 11 Mar 2013 18:18:56 -0300
Message-Id: <1363036736-14209-1-git-send-email-raphael.scarv@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raphael S.Carvalho <raphael.scarv@gmail.com>

Notes: find_next_offset searches for an available "cleaned bit"
in the respective pid bitmap (page), so returns the offset if found,
otherwise it returns a value equals to BITS_PER_PAGE.

For example, suppose find_next_offset didn't find any available
bit, so there's no purpose to call mk_pid (Wasteful Cpu Cycles).

Therefore, I found it could be better to call mk_pid after
the checking (offset < BITS_PER_PAGE) returned sucessfully!
Another point: If (offset < BITS_PER_PAGE) results in a "failure",
then mk_pid would be called again afterwards.

Signed-off-by: Raphael S. Carvalho <raphael.scarv@gmail.com>
---
 kernel/pid.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 047dc62..7ecb09a 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -190,8 +190,8 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 					return pid;
 				}
 				offset = find_next_offset(map, offset);
-				pid = mk_pid(pid_ns, map, offset);
-			} while (offset < BITS_PER_PAGE && pid < pid_max);
+			} while (offset < BITS_PER_PAGE && 
+				(pid = mk_pid(pid_ns, map, offset)) < pid_max);
 		}
 		if (map < &pid_ns->pidmap[(pid_max-1)/BITS_PER_PAGE]) {
 			++map;
-- 
1.7.2.5

