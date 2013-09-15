Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab3IORdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 13:33:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932517Ab3IORdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 13:33:03 -0400
Date: Sun, 15 Sep 2013 19:26:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] pidns: fix free_pid() to handle the first fork
	failure
Message-ID: <20130915172648.GA16131@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"case 0" in free_pid() assumes that disable_pid_allocation() should
clear PIDNS_HASH_ADDING before the last pid goes away. However this
doesn't happen if the 1st fork() fails to create the child reaper
which should call disable_pid_allocation().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/pid.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 66505c1..606a212 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -272,6 +272,11 @@ void free_pid(struct pid *pid)
 			 */
 			wake_up_process(ns->child_reaper);
 			break;
+		case PIDNS_HASH_ADDING:
+			/* Handle a fork failure of the first process */
+			WARN_ON(ns->child_reaper);
+			ns->nr_hashed = 0;
+			/* fall through */
 		case 0:
 			schedule_work(&ns->proc_work);
 			break;
-- 
1.5.5.1


