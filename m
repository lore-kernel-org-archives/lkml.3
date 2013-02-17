Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3BQWz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:55:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45681 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755176Ab3BQWzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:22 -0500
Message-Id: <20130217225007.335330435@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:50 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 49/66] pktgen: correctly handle failures when adding a device
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <amwang@redhat.com>

[ Upstream commit 604dfd6efc9b79bce432f2394791708d8e8f6efc ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/pktgen.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 7bc9991..2ef7da0 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1803,10 +1803,13 @@ static ssize_t pktgen_thread_write(struct file *file,
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
 


