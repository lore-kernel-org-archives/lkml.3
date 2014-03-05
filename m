Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbaCED6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:58:04 -0500
Received: from na3sys010aog107.obsmtp.com ([74.125.245.82]:37890 "HELO
	na3sys010aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757326AbaCED6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:58:01 -0500
From: Roland Dreier <roland@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH] Revert "driver core: synchronize device shutdown"
Date: Tue,  4 Mar 2014 19:57:51 -0800
Message-Id: <1393991871-1743-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

This reverts commit 401097ea4b89846d66ac78f7f108d49c2e922d9c.  The
original changelog said:

    A patch series to make .shutdown execute asynchronously.  Some drivers's
    shutdown can take a lot of time.  The patches can help save some shutdown
    time.  The patches use Arjan's async API.

    This patch:

    synchronize all tasks submitted by .shutdown

However, I'm not able to find any evidence that any other patches from
this series were applied, nor am I able to find any async tasks that are
scheduled in a .shutdown context.

On the other hand, we see occasional hangs on shutdown that appear to be
caused by the async_synchronize_full() in device_shutdown() waiting
forever for the async probing in sd if a SCSI disk shows up at just the
wrong time — the system starts the probe, but begins shutting down and
tears down too much of the SCSI driver to finish the probe.

If we had any async shutdown tasks, I guess the right fix would be to
create a "shutdown" async domain and have device_shutdown() only wait
for that domain.  But since there apparently are no async shutdown
tasks, we can just revert the waiting.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/base/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2b567177ef78..afea3697fa2e 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -23,7 +23,6 @@
 #include <linux/genhd.h>
 #include <linux/kallsyms.h>
 #include <linux/mutex.h>
-#include <linux/async.h>
 #include <linux/pm_runtime.h>
 #include <linux/netdevice.h>
 #include <linux/sysfs.h>
@@ -2003,7 +2002,6 @@ void device_shutdown(void)
 		spin_lock(&devices_kset->list_lock);
 	}
 	spin_unlock(&devices_kset->list_lock);
-	async_synchronize_full();
 }
 
 /*
-- 
1.9.0

