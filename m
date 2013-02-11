Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab3BKPvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:51:55 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:27691 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757688Ab3BKPvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:51:54 -0500
From: Andrey Vagin <avagin@openvz.org>
To: netdev@vger.kernel.org
Cc: criu@openvz.org, linux-kernel@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: [PATCH 2/3] tcp: set and get per-socket timestamp
Date: Mon, 11 Feb 2013 19:50:18 +0400
Message-Id: <1360597819-23783-3-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1360597819-23783-1-git-send-email-avagin@openvz.org>
References: <1360597819-23783-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A timestamp can be set, only if a socket is in the repair mode.

This patch adds a new socket option TCP_TIMESTAMP, which allows to
get and set current tcp times stamp.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 include/uapi/linux/tcp.h | 1 +
 net/ipv4/tcp.c           | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index e962faa..6b1ead0 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -111,6 +111,7 @@ enum {
 #define TCP_QUEUE_SEQ		21
 #define TCP_REPAIR_OPTIONS	22
 #define TCP_FASTOPEN		23	/* Enable FastOpen on listeners */
+#define TCP_TIMESTAMP		24
 
 struct tcp_repair_opt {
 	__u32	opt_code;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 60fab09..9e484fc 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2706,6 +2706,12 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		else
 			err = -EINVAL;
 		break;
+	case TCP_TIMESTAMP:
+		if (!tp->repair)
+			err = -EPERM;
+		else
+			tp->tsoffset = val - tcp_time_stamp;
+		break;
 	default:
 		err = -ENOPROTOOPT;
 		break;
@@ -2954,6 +2960,9 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 	case TCP_USER_TIMEOUT:
 		val = jiffies_to_msecs(icsk->icsk_user_timeout);
 		break;
+	case TCP_TIMESTAMP:
+		val = tcp_time_stamp + tp->tsoffset;
+		break;
 	default:
 		return -ENOPROTOOPT;
 	}
-- 
1.7.11.7

