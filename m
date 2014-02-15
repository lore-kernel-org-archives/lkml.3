Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaBOTj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 14:39:26 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:48080 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbaBOTjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 14:39:24 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>, <stable@vger.kernel.org>
Subject: [PATCH] workqueue: Document exceptions to work item non-reentrancy guarantee
Date: Sat, 15 Feb 2014 14:38:39 -0500
Message-Id: <1392493119-9277-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit a2c1c57be8d9fd5b716113c8991d3d702eeacf77,
  workqueue: consider work function when searching for busy work items
work items whose work functions are re-assigned are no longer guaranteed
non-reentrancy with the previously assigned work function. For example,

        PREPARE_WORK(&work, funcA)
        schedule_work(&work)
          .
        < funcA starts >
          .
        PREPARE_WORK(&work, funcB)
        schedule_work(&work)

funcA() may run concurrently with funcB().

The work item non-reentrancy guarantee is a crucial design guarantee
which, if violated, may not have obvious consequences. For example,
the entire firewire subsystem expects the as-documented per-work item
non-reentrancy guarantee, which was the behavior prior to the above
commit, not the per-work function + per-work item behavior since.

Document the known exceptions to this guarantee.

Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 Documentation/workqueue.txt | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/Documentation/workqueue.txt b/Documentation/workqueue.txt
index f81a65b..5b49491 100644
--- a/Documentation/workqueue.txt
+++ b/Documentation/workqueue.txt
@@ -223,9 +223,17 @@ resources, scheduled and executed.
 
 	This flag is meaningless for unbound wq.
 
-Note that the flag WQ_NON_REENTRANT no longer exists as all workqueues
-are now non-reentrant - any work item is guaranteed to be executed by
-at most one worker system-wide at any given time.
+Note that the flag WQ_NON_REENTRANT no longer exists.
+Generally, workqueues are non-reentrant -- a work item will be executed
+by at most one worker system-wide at any given time. However, this
+non-reentrancy guarantee does not extend to work items whose function
+is re-assigned (for example, via PREPARE_WORK/PREPARE_DELAYED_WORK)
+and re-queued for execution; the newly scheduled work may run concurrently
+with the previous work item function.
+
+Note that WQ_UNBOUND workqueues, such as system_unbound_wq, have no
+non-reentrancy guarantees as these workqueues do not provide concurrency
+management.
 
 @max_active:
 
-- 
1.8.1.2

