Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab3IJOHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 10:07:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab3IJOHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 10:07:51 -0400
Date: Tue, 10 Sep 2013 16:01:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] pidns: fix free_pid() to handle the first fork failure
Message-ID: <20130910140140.GB30152@redhat.com>
References: <20130829211114.GA20726@sergelap> <87mwo0xb9p.fsf@xmission.com> <20130830144232.GA18281@mail.hallyn.com> <87hae6vh0w.fsf_-_@xmission.com> <20130908175602.GA3172@redhat.com> <20130908180137.GA4915@redhat.com> <87bo43gg4h.fsf@xmission.com> <20130909151530.GA6755@redhat.com> <87bo41j2x9.fsf@tw-ebiederman.twitter.com> <20130910140123.GA30152@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910140123.GA30152@redhat.com>
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


