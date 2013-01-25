Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab3AYKOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:14:46 -0500
Received: from multi.imgtec.com ([194.200.65.239]:8942 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415Ab3AYKOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:14:45 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Dan Williams <djbw@fb.com>,
        <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 1/1] async: initialise list heads to fix crash
Date: Fri, 25 Jan 2013 10:13:59 +0000
Message-ID: <1359108839-19232-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <20130125010112.GF2373@mtj.dyndns.org>
References: <20130125010112.GF2373@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_01_25_10_14_37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit "async: replace list of active domains with global list of
pending items" added a struct list_head global_list in struct
async_entry, which isn't initialised. This means that if
!domain->registered at __async_schedule(), then list_del_init() will be
called on the list head in async_run_entry_fn with both pointers NULL,
causing a crash. This is fixed by initialising both the global_list and
domain_list list_heads after kzalloc'ing the entry.

This was noticed due to dapm_power_widgets() which uses
ASYNC_DOMAIN_EXCLUSIVE, which initialises the domain->registered to 0.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 kernel/async.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 6958000..8ddee2c 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -172,6 +172,8 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct a
 		ptr(data, newcookie);
 		return newcookie;
 	}
+	INIT_LIST_HEAD(&entry->domain_list);
+	INIT_LIST_HEAD(&entry->global_list);
 	INIT_WORK(&entry->work, async_run_entry_fn);
 	entry->func = ptr;
 	entry->data = data;
-- 
1.7.7.6


