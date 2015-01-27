Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbbA0NAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 08:00:40 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41571 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbbA0NAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 08:00:36 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-bc-54c78b60e1d1
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: David Laight <David.Laight@ACULAB.COM>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH] net/9p: use memcpy() instead of snprintf() in
 p9_mount_tag_show()
Date: Tue, 27 Jan 2015 16:00:19 +0300
Message-id: <1422363619-21931-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.2
In-reply-to: <1422290896-25042-1-git-send-email-a.ryabinin@samsung.com>
References: <1422290896-25042-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t/xq7oJ3cdDDA7sU7PY9usRm8Xj1/NY
	LOacb2Gx2LF0M5PF3Fmb2C0u75rDZnFv+m1Wi2MLxCy2/d7IbPHx7yo2By6P/tlT2Dy2rLzJ
	5LFz1l12j2n3NjF5PDi0mcVj94LPTB59W1YxevRuXcjm8XmTXABnFJdNSmpOZllqkb5dAlfG
	6tU7WArOsFd0HdzO2MC4jK2LkYNDQsBE4u992S5GTiBTTOLCvfVsILaQwFJGiecLTSDsPiaJ
	GS/VQGw2AT2Jf7O2g9WICChIbO59xtrFyMXBLPCaSWLukc2sIAlhgRCJ5tPHmEFsFgFVif9/
	T7OA2LwCbhKPnqxhh9grJ3HhYzxImFPAXeLD4tlQe90kHs/YwzyBkXcBI8MqRtHU0uSC4qT0
	XEO94sTc4tK8dL3k/NxNjJCg/LKDcfExq0OMAhyMSjy8HEXHQ4RYE8uKK3MPMUpwMCuJ8HpF
	AIV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwir7y0tj1neW0AtPub+tyn/j803VaL/C1SsX/lDNf
	54ajmyVrDq/uaOMQeKH3s96pIG7HrdczDq++8VxwLvebaL+yU933GC2sDWtEn/19Pmv/rQXO
	fUYOgn66L3VsPocnbXKbvKbKcMrnUzmHlWbO7X01Nd6+YP/hj5u/8gRn2hy6/ax0beCW+0os
	xRmJhlrMRcWJAE4R1KQoAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

p9_mount_tag_show() uses '%s' format string to print
non-NULL terminated chan->tag string. This leads
to out of bounds memory read, because format '%s'
implies that string is NULL-terminated.

The length of string is know here, so its simpler and safer
to use memcpy instead of snprintf().

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 net/9p/trans_virtio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index daa749c..9d64145 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -504,7 +504,10 @@ static ssize_t p9_mount_tag_show(struct device *dev,
 	vdev = dev_to_virtio(dev);
 	chan = vdev->priv;
 
-	return snprintf(buf, chan->tag_len + 1, "%s", chan->tag);
+	memcpy(buf, chan->tag, chan->tag_len);
+	buf[chan->tag_len] = 0;
+
+	return chan->tag_len + 1;
 }
 
 static DEVICE_ATTR(mount_tag, 0444, p9_mount_tag_show, NULL);
-- 
2.2.2

