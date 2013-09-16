Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3IPHqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 03:46:03 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60965 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab3IPHqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 03:46:00 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, George Spelvin <linux@horizon.com>,
        dan.carpenter@oracle.com, viro@zeniv.linux.org.uk,
        Jan Beulich <JBeulich@suse.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        akpm@linux-foundation.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/2] remove all uses of printf's %n
Date: Mon, 16 Sep 2013 00:43:56 -0700
Message-Id: <1379317437-28329-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379317437-28329-1-git-send-email-keescook@chromium.org>
References: <1379317437-28329-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users of %n are calculating padding size when using seq_file, so
instead use the new last_len member for discovering the length of the
written strings.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/proc/consoles.c   |    5 +++--
 fs/proc/nommu.c      |    6 ++++--
 fs/proc/task_mmu.c   |    6 ++++--
 fs/proc/task_nommu.c |    6 ++++--
 net/ipv4/fib_trie.c  |   10 ++++++----
 net/ipv4/ping.c      |   10 ++++++----
 net/ipv4/tcp_ipv4.c  |   28 ++++++++++++++--------------
 net/ipv4/udp.c       |   10 ++++++----
 net/phonet/socket.c  |   18 +++++++++++-------
 net/sctp/objcnt.c    |    6 ++++--
 10 files changed, 62 insertions(+), 43 deletions(-)

diff --git a/fs/proc/consoles.c b/fs/proc/consoles.c
index b701eaa..08cd2ee 100644
--- a/fs/proc/consoles.c
+++ b/fs/proc/consoles.c
@@ -47,8 +47,9 @@ static int show_console_dev(struct seq_file *m, void *v)
 			con_flags[a].name : ' ';
 	flags[a] = 0;
 
-	seq_printf(m, "%s%d%n", con->name, con->index, &len);
-	len = 21 - len;
+	len = m->count;
+	seq_printf(m, "%s%d", con->name, con->index);
+	len = 21 - (m->count - len);
 	if (len < 1)
 		len = 1;
 	seq_printf(m, "%*c%c%c%c (%s)", len, ' ', con->read ? 'R' : '-',
diff --git a/fs/proc/nommu.c b/fs/proc/nommu.c
index ccfd99b..db0700d 100644
--- a/fs/proc/nommu.c
+++ b/fs/proc/nommu.c
@@ -50,8 +50,9 @@ static int nommu_region_show(struct seq_file *m, struct vm_region *region)
 		ino = inode->i_ino;
 	}
 
+	len = m->count;
 	seq_printf(m,
-		   "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
+		   "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu ",
 		   region->vm_start,
 		   region->vm_end,
 		   flags & VM_READ ? 'r' : '-',
@@ -59,7 +60,8 @@ static int nommu_region_show(struct seq_file *m, struct vm_region *region)
 		   flags & VM_EXEC ? 'x' : '-',
 		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
 		   ((loff_t)region->vm_pgoff) << PAGE_SHIFT,
-		   MAJOR(dev), MINOR(dev), ino, &len);
+		   MAJOR(dev), MINOR(dev), ino);
+	len = m->count - len;
 
 	if (file) {
 		len = 25 + sizeof(void *) * 6 - len;
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 7366e9d..eaca69c 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -286,7 +286,8 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 	if (stack_guard_page_end(vma, end))
 		end -= PAGE_SIZE;
 
-	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
+	len = m->count;
+	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu ",
 			start,
 			end,
 			flags & VM_READ ? 'r' : '-',
@@ -294,7 +295,8 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 			flags & VM_EXEC ? 'x' : '-',
 			flags & VM_MAYSHARE ? 's' : 'p',
 			pgoff,
-			MAJOR(dev), MINOR(dev), ino, &len);
+			MAJOR(dev), MINOR(dev), ino);
+	len = m->count - len;
 
 	/*
 	 * Print the dentry name for named mappings, and a
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 56123a6..04c8246 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -155,8 +155,9 @@ static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma,
 		pgoff = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
 	}
 
+	len = m->count;
 	seq_printf(m,
-		   "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
+		   "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu ",
 		   vma->vm_start,
 		   vma->vm_end,
 		   flags & VM_READ ? 'r' : '-',
@@ -164,7 +165,8 @@ static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma,
 		   flags & VM_EXEC ? 'x' : '-',
 		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
 		   pgoff,
-		   MAJOR(dev), MINOR(dev), ino, &len);
+		   MAJOR(dev), MINOR(dev), ino);
+	len = m->count - len;
 
 	if (file) {
 		pad_len_spaces(m, len);
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 3df6d3e..9537a95 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2536,10 +2536,11 @@ static int fib_route_seq_show(struct seq_file *seq, void *v)
 			    || fa->fa_type == RTN_MULTICAST)
 				continue;
 
+			len = seq->count;
 			if (fi)
 				seq_printf(seq,
 					 "%s\t%08X\t%08X\t%04X\t%d\t%u\t"
-					 "%d\t%08X\t%d\t%u\t%u%n",
+					 "%d\t%08X\t%d\t%u\t%u",
 					 fi->fib_dev ? fi->fib_dev->name : "*",
 					 prefix,
 					 fi->fib_nh->nh_gw, flags, 0, 0,
@@ -2548,13 +2549,14 @@ static int fib_route_seq_show(struct seq_file *seq, void *v)
 					 (fi->fib_advmss ?
 					  fi->fib_advmss + 40 : 0),
 					 fi->fib_window,
-					 fi->fib_rtt >> 3, &len);
+					 fi->fib_rtt >> 3);
 			else
 				seq_printf(seq,
 					 "*\t%08X\t%08X\t%04X\t%d\t%u\t"
-					 "%d\t%08X\t%d\t%u\t%u%n",
+					 "%d\t%08X\t%d\t%u\t%u",
 					 prefix, 0, flags, 0, 0, 0,
-					 mask, 0, 0, 0, &len);
+					 mask, 0, 0, 0);
+			len = seq->count - len;
 
 			seq_printf(seq, "%*s\n", 127 - len, "");
 		}
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index d7d9882..c87d062 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -1073,7 +1073,7 @@ void ping_seq_stop(struct seq_file *seq, void *v)
 EXPORT_SYMBOL_GPL(ping_seq_stop);
 
 static void ping_v4_format_sock(struct sock *sp, struct seq_file *f,
-		int bucket, int *len)
+		int bucket)
 {
 	struct inet_sock *inet = inet_sk(sp);
 	__be32 dest = inet->inet_daddr;
@@ -1082,7 +1082,7 @@ static void ping_v4_format_sock(struct sock *sp, struct seq_file *f,
 	__u16 srcp = ntohs(inet->inet_sport);
 
 	seq_printf(f, "%5d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d%n",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d",
 		bucket, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		sk_rmem_alloc_get(sp),
@@ -1090,7 +1090,7 @@ static void ping_v4_format_sock(struct sock *sp, struct seq_file *f,
 		from_kuid_munged(seq_user_ns(f), sock_i_uid(sp)),
 		0, sock_i_ino(sp),
 		atomic_read(&sp->sk_refcnt), sp,
-		atomic_read(&sp->sk_drops), len);
+		atomic_read(&sp->sk_drops));
 }
 
 static int ping_v4_seq_show(struct seq_file *seq, void *v)
@@ -1104,7 +1104,9 @@ static int ping_v4_seq_show(struct seq_file *seq, void *v)
 		struct ping_iter_state *state = seq->private;
 		int len;
 
-		ping_v4_format_sock(v, seq, state->bucket, &len);
+		len = seq->count;
+		ping_v4_format_sock(v, seq, state->bucket);
+		len = seq->count - len;
 		seq_printf(seq, "%*s\n", 127 - len, "");
 	}
 	return 0;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b14266b..cdded47 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2598,13 +2598,13 @@ void tcp_proc_unregister(struct net *net, struct tcp_seq_afinfo *afinfo)
 EXPORT_SYMBOL(tcp_proc_unregister);
 
 static void get_openreq4(const struct sock *sk, const struct request_sock *req,
-			 struct seq_file *f, int i, kuid_t uid, int *len)
+			 struct seq_file *f, int i, kuid_t uid)
 {
 	const struct inet_request_sock *ireq = inet_rsk(req);
 	long delta = req->expires - jiffies;
 
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %u %d %pK%n",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %u %d %pK",
 		i,
 		ireq->loc_addr,
 		ntohs(inet_sk(sk)->inet_sport),
@@ -2619,11 +2619,10 @@ static void get_openreq4(const struct sock *sk, const struct request_sock *req,
 		0,  /* non standard timer */
 		0, /* open_requests have no inode */
 		atomic_read(&sk->sk_refcnt),
-		req,
-		len);
+		req);
 }
 
-static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i, int *len)
+static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
 {
 	int timer_active;
 	unsigned long timer_expires;
@@ -2662,7 +2661,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i, int *len)
 		rx_queue = max_t(int, tp->rcv_nxt - tp->copied_seq, 0);
 
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
-			"%08X %5u %8d %lu %d %pK %lu %lu %u %u %d%n",
+			"%08X %5u %8d %lu %d %pK %lu %lu %u %u %d",
 		i, src, srcp, dest, destp, sk->sk_state,
 		tp->write_seq - tp->snd_una,
 		rx_queue,
@@ -2679,12 +2678,11 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i, int *len)
 		tp->snd_cwnd,
 		sk->sk_state == TCP_LISTEN ?
 		    (fastopenq ? fastopenq->max_qlen : 0) :
-		    (tcp_in_initial_slowstart(tp) ? -1 : tp->snd_ssthresh),
-		len);
+		    (tcp_in_initial_slowstart(tp) ? -1 : tp->snd_ssthresh));
 }
 
 static void get_timewait4_sock(const struct inet_timewait_sock *tw,
-			       struct seq_file *f, int i, int *len)
+			       struct seq_file *f, int i)
 {
 	__be32 dest, src;
 	__u16 destp, srcp;
@@ -2696,10 +2694,10 @@ static void get_timewait4_sock(const struct inet_timewait_sock *tw,
 	srcp  = ntohs(tw->tw_sport);
 
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK%n",
+		" %02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK",
 		i, src, srcp, dest, destp, tw->tw_substate, 0, 0,
 		3, jiffies_delta_to_clock_t(delta), 0, 0, 0, 0,
-		atomic_read(&tw->tw_refcnt), tw, len);
+		atomic_read(&tw->tw_refcnt), tw);
 }
 
 #define TMPSZ 150
@@ -2718,18 +2716,20 @@ static int tcp4_seq_show(struct seq_file *seq, void *v)
 	}
 	st = seq->private;
 
+	len = seq->count;
 	switch (st->state) {
 	case TCP_SEQ_STATE_LISTENING:
 	case TCP_SEQ_STATE_ESTABLISHED:
-		get_tcp4_sock(v, seq, st->num, &len);
+		get_tcp4_sock(v, seq, st->num);
 		break;
 	case TCP_SEQ_STATE_OPENREQ:
-		get_openreq4(st->syn_wait_sk, v, seq, st->num, st->uid, &len);
+		get_openreq4(st->syn_wait_sk, v, seq, st->num, st->uid);
 		break;
 	case TCP_SEQ_STATE_TIME_WAIT:
-		get_timewait4_sock(v, seq, st->num, &len);
+		get_timewait4_sock(v, seq, st->num);
 		break;
 	}
+	len = seq->count - len;
 	seq_printf(seq, "%*s\n", TMPSZ - 1 - len, "");
 out:
 	return 0;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 74d2c95..5460ab9 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2150,7 +2150,7 @@ EXPORT_SYMBOL(udp_proc_unregister);
 
 /* ------------------------------------------------------------------------ */
 static void udp4_format_sock(struct sock *sp, struct seq_file *f,
-		int bucket, int *len)
+		int bucket)
 {
 	struct inet_sock *inet = inet_sk(sp);
 	__be32 dest = inet->inet_daddr;
@@ -2159,7 +2159,7 @@ static void udp4_format_sock(struct sock *sp, struct seq_file *f,
 	__u16 srcp	  = ntohs(inet->inet_sport);
 
 	seq_printf(f, "%5d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d%n",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK %d",
 		bucket, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		sk_rmem_alloc_get(sp),
@@ -2167,7 +2167,7 @@ static void udp4_format_sock(struct sock *sp, struct seq_file *f,
 		from_kuid_munged(seq_user_ns(f), sock_i_uid(sp)),
 		0, sock_i_ino(sp),
 		atomic_read(&sp->sk_refcnt), sp,
-		atomic_read(&sp->sk_drops), len);
+		atomic_read(&sp->sk_drops));
 }
 
 int udp4_seq_show(struct seq_file *seq, void *v)
@@ -2181,7 +2181,9 @@ int udp4_seq_show(struct seq_file *seq, void *v)
 		struct udp_iter_state *state = seq->private;
 		int len;
 
-		udp4_format_sock(v, seq, state->bucket, &len);
+		len = seq->count;
+		udp4_format_sock(v, seq, state->bucket);
+		len = seq->count - len;
 		seq_printf(seq, "%*s\n", 127 - len, "");
 	}
 	return 0;
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 77e38f7..b8712ad 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -597,23 +597,25 @@ static int pn_sock_seq_show(struct seq_file *seq, void *v)
 {
 	int len;
 
+	len = seq->count;
 	if (v == SEQ_START_TOKEN)
-		seq_printf(seq, "%s%n", "pt  loc  rem rs st tx_queue rx_queue "
-			"  uid inode ref pointer drops", &len);
+		seq_puts(seq, "pt  loc  rem rs st tx_queue rx_queue "
+			"  uid inode ref pointer drops");
 	else {
 		struct sock *sk = v;
 		struct pn_sock *pn = pn_sk(sk);
 
 		seq_printf(seq, "%2d %04X:%04X:%02X %02X %08X:%08X %5d %lu "
-			"%d %pK %d%n",
+			"%d %pK %d",
 			sk->sk_protocol, pn->sobject, pn->dobject,
 			pn->resource, sk->sk_state,
 			sk_wmem_alloc_get(sk), sk_rmem_alloc_get(sk),
 			from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
 			sock_i_ino(sk),
 			atomic_read(&sk->sk_refcnt), sk,
-			atomic_read(&sk->sk_drops), &len);
+			atomic_read(&sk->sk_drops));
 	}
+	len = seq->count - len;
 	seq_printf(seq, "%*s\n", 127 - len, "");
 	return 0;
 }
@@ -787,17 +789,19 @@ static int pn_res_seq_show(struct seq_file *seq, void *v)
 {
 	int len;
 
+	len = seq->count;
 	if (v == SEQ_START_TOKEN)
-		seq_printf(seq, "%s%n", "rs   uid inode", &len);
+		seq_puts(seq, "rs   uid inode");
 	else {
 		struct sock **psk = v;
 		struct sock *sk = *psk;
 
-		seq_printf(seq, "%02X %5u %lu%n",
+		seq_printf(seq, "%02X %5u %lu",
 			   (int) (psk - pnres.sk),
 			   from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
-			   sock_i_ino(sk), &len);
+			   sock_i_ino(sk));
 	}
+	len = seq->count - len;
 	seq_printf(seq, "%*s\n", 63 - len, "");
 	return 0;
 }
diff --git a/net/sctp/objcnt.c b/net/sctp/objcnt.c
index 5ea573b..b3f4a3c 100644
--- a/net/sctp/objcnt.c
+++ b/net/sctp/objcnt.c
@@ -82,8 +82,10 @@ static int sctp_objcnt_seq_show(struct seq_file *seq, void *v)
 	int i, len;
 
 	i = (int)*(loff_t *)v;
-	seq_printf(seq, "%s: %d%n", sctp_dbg_objcnt[i].label,
-				atomic_read(sctp_dbg_objcnt[i].counter), &len);
+	len = seq->count;
+	seq_printf(seq, "%s: %d", sctp_dbg_objcnt[i].label,
+				atomic_read(sctp_dbg_objcnt[i].counter));
+	len = seq->count - len;
 	seq_printf(seq, "%*s\n", 127 - len, "");
 	return 0;
 }
-- 
1.7.9.5

