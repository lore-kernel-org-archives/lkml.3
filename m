Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3FCICe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:02:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:41184 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab3FCICS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:02:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,791,1363158000"; 
   d="scan'208";a="343917987"
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH v8 net-next 5/7] net: simple poll/select low latency socket
 poll
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Mon, 03 Jun 2013 11:02:00 +0300
Message-ID: <20130603080200.18273.52073.stgit@ladj378.jer.intel.com>
In-Reply-To: <20130603080107.18273.34279.stgit@ladj378.jer.intel.com>
References: <20130603080107.18273.34279.stgit@ladj378.jer.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A very naive select/poll busy-poll support.
Add busy-polling to sock_poll().
When poll/select have nothing to report, call the low-level
sock_poll() again untill we are out of time or we find something.
Rigth now we poll every socket once, this is subpotimal
but impoves latency when the number of sockets polled is not large.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
---

 fs/select.c  |    7 +++++++
 net/socket.c |   10 +++++++++-
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 8c1c96c..f116bf0 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -27,6 +27,7 @@
 #include <linux/rcupdate.h>
 #include <linux/hrtimer.h>
 #include <linux/sched/rt.h>
+#include <net/ll_poll.h>
 
 #include <asm/uaccess.h>
 
@@ -400,6 +401,7 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 	poll_table *wait;
 	int retval, i, timed_out = 0;
 	unsigned long slack = 0;
+	cycles_t ll_time = ll_end_time();
 
 	rcu_read_lock();
 	retval = max_select_fd(n, fds);
@@ -486,6 +488,8 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 			break;
 		}
 
+		if (can_poll_ll(ll_time))
+			continue;
 		/*
 		 * If this is the first loop and we have a timeout
 		 * given, then we convert to ktime_t and set the to
@@ -750,6 +754,7 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 	ktime_t expire, *to = NULL;
 	int timed_out = 0, count = 0;
 	unsigned long slack = 0;
+	cycles_t ll_time = ll_end_time();
 
 	/* Optimise the no-wait case */
 	if (end_time && !end_time->tv_sec && !end_time->tv_nsec) {
@@ -795,6 +800,8 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 		if (count || timed_out)
 			break;
 
+		if (can_poll_ll(ll_time))
+			continue;
 		/*
 		 * If this is the first loop and we have a timeout
 		 * given, then we convert to ktime_t and set the to
diff --git a/net/socket.c b/net/socket.c
index 721f4e7..02d0e15 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1148,13 +1148,21 @@ EXPORT_SYMBOL(sock_create_lite);
 /* No kernel lock held - perfect */
 static unsigned int sock_poll(struct file *file, poll_table *wait)
 {
+	unsigned int poll_result;
 	struct socket *sock;
 
 	/*
 	 *      We can't return errors to poll, so it's either yes or no.
 	 */
 	sock = file->private_data;
-	return sock->ops->poll(file, sock, wait);
+
+	poll_result = sock->ops->poll(file, sock, wait);
+
+	if (!(poll_result & (POLLRDNORM | POLLERR | POLLRDHUP | POLLHUP)) &&
+		sk_valid_ll(sock->sk) && sk_poll_ll(sock->sk, 1))
+			poll_result = sock->ops->poll(file, sock, NULL);
+
+	return poll_result;
 }
 
 static int sock_mmap(struct file *file, struct vm_area_struct *vma)

