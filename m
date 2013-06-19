Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789Ab3FSSjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:39:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40036 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935093Ab3FSSjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:39:12 -0400
Date: Wed, 19 Jun 2013 11:38:40 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-e712209a9e0b70e78b13847738eb66fe37412515@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, pmatouse@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, pmatouse@redhat.com,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20130606090204.GA3725@quad>
References: <20130606090204.GA3725@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Fix hypervisor branch sampling permission check
Git-Commit-ID: e712209a9e0b70e78b13847738eb66fe37412515
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:38:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e712209a9e0b70e78b13847738eb66fe37412515
Gitweb:     http://git.kernel.org/tip/e712209a9e0b70e78b13847738eb66fe37412515
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 6 Jun 2013 11:02:04 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:50:21 +0200

perf: Fix hypervisor branch sampling permission check

Commit 2b923c8 perf/x86: Check branch sampling priv level in generic code
was missing the check for the hypervisor (HV) priv level, so add it back.

With this patch, we get the following correct behavior:

  # echo 2 >/proc/sys/kernel/perf_event_paranoid

  $ perf record -j any,k noploop 1
  Error:
  You may not have permission to collect stats.
  Consider tweaking /proc/sys/kernel/perf_event_paranoid:
   -1 - Not paranoid at all
    0 - Disallow raw tracepoint access for unpriv
    1 - Disallow cpu events for unpriv
    2 - Disallow kernel profiling for unpriv

   $ perf record -j any,hv noploop 1
   Error:
   You may not have permission to collect stats.
   Consider tweaking /proc/sys/kernel/perf_event_paranoid:
    -1 - Not paranoid at all
     0 - Disallow raw tracepoint access for unpriv
     1 - Disallow cpu events for unpriv
     2 - Disallow kernel profiling for unpriv

Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Petr Matousek <pmatouse@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130606090204.GA3725@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d0e0d0d..aca95bc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6573,8 +6573,8 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 			 */
 			attr->branch_sample_type = mask;
 		}
-		/* kernel level capture: check permissions */
-		if ((mask & PERF_SAMPLE_BRANCH_KERNEL)
+		/* privileged levels capture (kernel, hv): check permissions */
+		if ((mask & PERF_SAMPLE_BRANCH_PERM_PLM)
 		    && perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
 			return -EACCES;
 	}
