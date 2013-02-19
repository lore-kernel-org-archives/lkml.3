Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351Ab3BSSxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:53:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54427 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531Ab3BSSx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:53:29 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>, Cong Wang <amwang@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 55/81] pktgen: correctly handle failures when adding a device
Date: Tue, 19 Feb 2013 15:49:18 -0300
Message-Id: <1361299784-8830-56-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <amwang@redhat.com>

commit 604dfd6efc9b79bce432f2394791708d8e8f6efc upstream.

The return value of pktgen_add_device() is not checked, so
even if we fail to add some device, for example, non-exist one,
we still see "OK:...". This patch fixes it.

After this patch, I got:

	# echo "add_device non-exist" > /proc/net/pktgen/kpktgend_0
	-bash: echo: write error: No such device
	# cat /proc/net/pktgen/kpktgend_0
	Running:
	Stopped:
	Result: ERROR: can not add device non-exist
	# echo "add_device eth0" > /proc/net/pktgen/kpktgend_0
	# cat /proc/net/pktgen/kpktgend_0
	Running:
	Stopped: eth0
	Result: OK: add_device=eth0

(Candidate for -stable)

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/core/pktgen.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index aa278cd..2a42802 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1797,10 +1797,13 @@ static ssize_t pktgen_thread_write(struct file *file,
 			return -EFAULT;
 		i += len;
 		mutex_lock(&pktgen_thread_lock);
-		pktgen_add_device(t, f);
+		ret = pktgen_add_device(t, f);
 		mutex_unlock(&pktgen_thread_lock);
-		ret = count;
-		sprintf(pg_result, "OK: add_device=%s", f);
+		if (!ret) {
+			ret = count;
+			sprintf(pg_result, "OK: add_device=%s", f);
+		} else
+			sprintf(pg_result, "ERROR: can not add device %s", f);
 		goto out;
 	}
 
-- 
1.7.9.5

