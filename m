Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964878AbaICXbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:31:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933552AbaICWIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:08:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.14 21/88] sched: Fix sched_setparam() policy == -1 logic
Date: Wed,  3 Sep 2014 15:04:55 -0700
Message-Id: <20140903220516.590374192@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Bristot de Oliveira <bristot@redhat.com>

commit d8d28c8f00e84a72e8bee39a85835635417bee49 upstream.

The scheduler uses policy == -1 to preserve the current policy state to
implement sched_setparam(). But, as (int) -1 is equals to 0xffffffff,
it's matching the if (policy & SCHED_RESET_ON_FORK) on
_sched_setscheduler(). This match changes the policy value to an
invalid value, breaking the sched_setparam() syscall.

This patch checks policy == -1 before check the SCHED_RESET_ON_FORK flag.

The following program shows the bug:

int main(void)
{
	struct sched_param param = {
		.sched_priority = 5,
	};

	sched_setscheduler(0, SCHED_FIFO, &param);
	param.sched_priority = 1;
	sched_setparam(0, &param);
	param.sched_priority = 0;
	sched_getparam(0, &param);
	if (param.sched_priority != 1)
		printf("failed priority setting (found %d instead of 1)\n",
			param.sched_priority);
	else
		printf("priority setting fine\n");
}

Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Fixes: 7479f3c9cf67 "sched: Move SCHED_RESET_ON_FORK into attr::sched_flags"
Link: http://lkml.kernel.org/r/9ebe0566a08dbbb3999759d3f20d6004bb2dbcfa.1406079891.git.bristot@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3511,9 +3511,10 @@ static int _sched_setscheduler(struct ta
 	};
 
 	/*
-	 * Fixup the legacy SCHED_RESET_ON_FORK hack
+	 * Fixup the legacy SCHED_RESET_ON_FORK hack, except if
+	 * the policy=-1 was passed by sched_setparam().
 	 */
-	if (policy & SCHED_RESET_ON_FORK) {
+	if ((policy != -1) && (policy & SCHED_RESET_ON_FORK)) {
 		attr.sched_flags |= SCHED_FLAG_RESET_ON_FORK;
 		policy &= ~SCHED_RESET_ON_FORK;
 		attr.sched_policy = policy;


