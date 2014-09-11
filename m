Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbaIKNG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:06:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755633AbaIKNEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:04:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "Andrey Ryabinin" <a.ryabinin@samsung.com>,
        "Sasha Levin" <sasha.levin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Andrey Ryabinin" <ryabinin.a.a@gmail.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.144115765@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 026/131] net: sendmsg: fix NULL pointer dereference
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Ryabinin <ryabinin.a.a@gmail.com>

commit 40eea803c6b2cfaab092f053248cbeab3f368412 upstream.

Sasha's report:
	> While fuzzing with trinity inside a KVM tools guest running the latest -next
	> kernel with the KASAN patchset, I've stumbled on the following spew:
	>
	> [ 4448.949424] ==================================================================
	> [ 4448.951737] AddressSanitizer: user-memory-access on address 0
	> [ 4448.952988] Read of size 2 by thread T19638:
	> [ 4448.954510] CPU: 28 PID: 19638 Comm: trinity-c76 Not tainted 3.16.0-rc4-next-20140711-sasha-00046-g07d3099-dirty #813
	> [ 4448.956823]  ffff88046d86ca40 0000000000000000 ffff880082f37e78 ffff880082f37a40
	> [ 4448.958233]  ffffffffb6e47068 ffff880082f37a68 ffff880082f37a58 ffffffffb242708d
	> [ 4448.959552]  0000000000000000 ffff880082f37a88 ffffffffb24255b1 0000000000000000
	> [ 4448.961266] Call Trace:
	> [ 4448.963158] dump_stack (lib/dump_stack.c:52)
	> [ 4448.964244] kasan_report_user_access (mm/kasan/report.c:184)
	> [ 4448.965507] __asan_load2 (mm/kasan/kasan.c:352)
	> [ 4448.966482] ? netlink_sendmsg (net/netlink/af_netlink.c:2339)
	> [ 4448.967541] netlink_sendmsg (net/netlink/af_netlink.c:2339)
	> [ 4448.968537] ? get_parent_ip (kernel/sched/core.c:2555)
	> [ 4448.970103] sock_sendmsg (net/socket.c:654)
	> [ 4448.971584] ? might_fault (mm/memory.c:3741)
	> [ 4448.972526] ? might_fault (./arch/x86/include/asm/current.h:14 mm/memory.c:3740)
	> [ 4448.973596] ? verify_iovec (net/core/iovec.c:64)
	> [ 4448.974522] ___sys_sendmsg (net/socket.c:2096)
	> [ 4448.975797] ? put_lock_stats.isra.13 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
	> [ 4448.977030] ? lock_release_holdtime (kernel/locking/lockdep.c:273)
	> [ 4448.978197] ? lock_release_non_nested (kernel/locking/lockdep.c:3434 (discriminator 1))
	> [ 4448.979346] ? check_chain_key (kernel/locking/lockdep.c:2188)
	> [ 4448.980535] __sys_sendmmsg (net/socket.c:2181)
	> [ 4448.981592] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2600)
	> [ 4448.982773] ? trace_hardirqs_on (kernel/locking/lockdep.c:2607)
	> [ 4448.984458] ? syscall_trace_enter (arch/x86/kernel/ptrace.c:1500 (discriminator 2))
	> [ 4448.985621] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2600)
	> [ 4448.986754] SyS_sendmmsg (net/socket.c:2201)
	> [ 4448.987708] tracesys (arch/x86/kernel/entry_64.S:542)
	> [ 4448.988929] ==================================================================

This reports means that we've come to netlink_sendmsg() with msg->msg_name == NULL and msg->msg_namelen > 0.

After this report there was no usual "Unable to handle kernel NULL pointer dereference"
and this gave me a clue that address 0 is mapped and contains valid socket address structure in it.

This bug was introduced in f3d3342602f8bcbf37d7c46641cb9bca7618eb1c
(net: rework recvmsg handler msg_name and msg_namelen logic).
Commit message states that:
	"Set msg->msg_name = NULL if user specified a NULL in msg_name but had a
	 non-null msg_namelen in verify_iovec/verify_compat_iovec. This doesn't
	 affect sendto as it would bail out earlier while trying to copy-in the
	 address."
But in fact this affects sendto when address 0 is mapped and contains
socket address structure in it. In such case copy-in address will succeed,
verify_iovec() function will successfully exit with msg->msg_namelen > 0
and msg->msg_name == NULL.

This patch fixes it by setting msg_namelen to 0 if msg_name == NULL.

Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Eric Dumazet <edumazet@google.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/compat.c     | 9 +++++----
 net/core/iovec.c | 6 +++---
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/net/compat.c
+++ b/net/compat.c
@@ -85,7 +85,7 @@ int verify_compat_iovec(struct msghdr *k
 {
 	int tot_len;
 
-	if (kern_msg->msg_namelen) {
+	if (kern_msg->msg_name && kern_msg->msg_namelen) {
 		if (mode == VERIFY_READ) {
 			int err = move_addr_to_kernel(kern_msg->msg_name,
 						      kern_msg->msg_namelen,
@@ -93,10 +93,11 @@ int verify_compat_iovec(struct msghdr *k
 			if (err < 0)
 				return err;
 		}
-		if (kern_msg->msg_name)
-			kern_msg->msg_name = kern_address;
-	} else
+		kern_msg->msg_name = kern_address;
+	} else {
 		kern_msg->msg_name = NULL;
+		kern_msg->msg_namelen = 0;
+	}
 
 	tot_len = iov_from_user_compat_to_kern(kern_iov,
 					  (struct compat_iovec __user *)kern_msg->msg_iov,
--- a/net/core/iovec.c
+++ b/net/core/iovec.c
@@ -39,7 +39,7 @@ int verify_iovec(struct msghdr *m, struc
 {
 	int size, ct, err;
 
-	if (m->msg_namelen) {
+	if (m->msg_name && m->msg_namelen) {
 		if (mode == VERIFY_READ) {
 			void __user *namep;
 			namep = (void __user __force *) m->msg_name;
@@ -48,10 +48,10 @@ int verify_iovec(struct msghdr *m, struc
 			if (err < 0)
 				return err;
 		}
-		if (m->msg_name)
-			m->msg_name = address;
+		m->msg_name = address;
 	} else {
 		m->msg_name = NULL;
+		m->msg_namelen = 0;
 	}
 
 	size = m->msg_iovlen * sizeof(struct iovec);

