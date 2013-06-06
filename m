Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab3FFJCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:02:12 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47148 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab3FFJCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:02:09 -0400
Date: Thu, 6 Jun 2013 11:02:04 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, pmatouse@redhat.com, meissner@suse.de,
        security@kernel.org, oss-security@lists.openwall.com,
        ak@linux.intel.com
Subject: [PATCH] perf: fix hypervisor branch sampling permission check
Message-ID: <20130606090204.GA3725@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 95edd5a..f0880fb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6501,8 +6501,8 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
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
