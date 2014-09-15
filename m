Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbaIOUMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:12:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbaIOTrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <ilya.dryomov@inktank.com>
Subject: [PATCH 3.14 112/114] libceph: gracefully handle large reply messages from the mon
Date: Mon, 15 Sep 2014 12:26:52 -0700
Message-Id: <20140915192644.914183820@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@redhat.com>

commit 73c3d4812b4c755efeca0140f606f83772a39ce4 upstream.

We preallocate a few of the message types we get back from the mon.  If we
get a larger message than we are expecting, fall back to trying to allocate
a new one instead of blindly using the one we have.

Signed-off-by: Sage Weil <sage@redhat.com>
Reviewed-by: Ilya Dryomov <ilya.dryomov@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/mon_client.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1041,7 +1041,15 @@ static struct ceph_msg *mon_alloc_msg(st
 	if (!m) {
 		pr_info("alloc_msg unknown type %d\n", type);
 		*skip = 1;
+	} else if (front_len > m->front_alloc_len) {
+		pr_warning("mon_alloc_msg front %d > prealloc %d (%u#%llu)\n",
+			   front_len, m->front_alloc_len,
+			   (unsigned int)con->peer_name.type,
+			   le64_to_cpu(con->peer_name.num));
+		ceph_msg_put(m);
+		m = ceph_msg_new(type, front_len, GFP_NOFS, false);
 	}
+
 	return m;
 }
 


