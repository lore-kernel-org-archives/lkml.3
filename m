Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494Ab3BLVCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:02:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab3BLUf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, Cong Wang <amwang@redhat.com>
Subject: [ 33/61] pktgen: correctly handle failures when adding a device
Date: Tue, 12 Feb 2013 12:34:53 -0800
Message-Id: <20130212203422.687530645@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/pktgen.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1795,10 +1795,13 @@ static ssize_t pktgen_thread_write(struc
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
 


