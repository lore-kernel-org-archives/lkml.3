Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab3BKPvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:51:46 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:32294 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757474Ab3BKPvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:51:45 -0500
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
Subject: [PATCH net-next] tcp: add ability to set a timestamp offset
Date: Mon, 11 Feb 2013 19:50:16 +0400
Message-Id: <1360597819-23783-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a TCP socket will get live-migrated from one box to another the
timestamps (which are typically ON) will get screwed up -- the new
kernel will generate TS values that has nothing to do with what they
were on dump. The solution is to yet again fix the kernel and put a
"timestamp offset" on a socket.

A socket offset is added in places where externally visible tcp
timestamp option is parsed/initialized.

Connections in the SYN_RECV state are not supported, global
tcp_time_stamp is used for them, because repair mode doesn't support
this state. In a future it can be implemented by the similar way as for
TIME_WAIT sockets.

For time-wait sockets offset is inhereted by a proper tcp_sock.

A per-socket offset can be set only for sockets in repair mode.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>

Andrey Vagin (3):
  tcp: adding a per-socket timestamp offset
  tcp: set and get per-socket timestamp
  tcp: send packets with a socket timestamp

 include/linux/tcp.h      |  3 +++
 include/uapi/linux/tcp.h |  1 +
 net/ipv4/tcp.c           | 11 +++++++++++
 net/ipv4/tcp_input.c     |  8 +++++++-
 net/ipv4/tcp_ipv4.c      | 12 +++++++-----
 net/ipv4/tcp_minisocks.c |  3 +++
 net/ipv4/tcp_output.c    |  4 ++--
 net/ipv6/tcp_ipv6.c      | 22 +++++++++++++---------
 8 files changed, 47 insertions(+), 17 deletions(-)
-- 
1.7.11.7
