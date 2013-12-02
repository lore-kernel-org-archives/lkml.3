Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab3LBU4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:56:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab3LBTNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Moore <pmoore@redhat.com>
Subject: [PATCH 3.10 089/173] selinux: correct locking in selinux_netlbl_socket_connect)
Date: Mon,  2 Dec 2013 11:11:12 -0800
Message-Id: <20131202191153.867099535@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

commit 42d64e1add3a1ce8a787116036163b8724362145 upstream.

The SELinux/NetLabel glue code has a locking bug that affects systems
with NetLabel enabled, see the kernel error message below.  This patch
corrects this problem by converting the bottom half socket lock to a
more conventional, and correct for this call-path, lock_sock() call.

 ===============================
 [ INFO: suspicious RCU usage. ]
 3.11.0-rc3+ #19 Not tainted
 -------------------------------
 net/ipv4/cipso_ipv4.c:1928 suspicious rcu_dereference_protected() usage!

 other info that might help us debug this:

 rcu_scheduler_active = 1, debug_locks = 0
 2 locks held by ping/731:
  #0:  (slock-AF_INET/1){+.-...}, at: [...] selinux_netlbl_socket_connect
  #1:  (rcu_read_lock){.+.+..}, at: [<...>] netlbl_conn_setattr

 stack backtrace:
 CPU: 1 PID: 731 Comm: ping Not tainted 3.11.0-rc3+ #19
 Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  0000000000000001 ffff88006f659d28 ffffffff81726b6a ffff88003732c500
  ffff88006f659d58 ffffffff810e4457 ffff88006b845a00 0000000000000000
  000000000000000c ffff880075aa2f50 ffff88006f659d90 ffffffff8169bec7
 Call Trace:
  [<ffffffff81726b6a>] dump_stack+0x54/0x74
  [<ffffffff810e4457>] lockdep_rcu_suspicious+0xe7/0x120
  [<ffffffff8169bec7>] cipso_v4_sock_setattr+0x187/0x1a0
  [<ffffffff8170f317>] netlbl_conn_setattr+0x187/0x190
  [<ffffffff8170f195>] ? netlbl_conn_setattr+0x5/0x190
  [<ffffffff8131ac9e>] selinux_netlbl_socket_connect+0xae/0xc0
  [<ffffffff81303025>] selinux_socket_connect+0x135/0x170
  [<ffffffff8119d127>] ? might_fault+0x57/0xb0
  [<ffffffff812fb146>] security_socket_connect+0x16/0x20
  [<ffffffff815d3ad3>] SYSC_connect+0x73/0x130
  [<ffffffff81739a85>] ? sysret_check+0x22/0x5d
  [<ffffffff810e5e2d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
  [<ffffffff81373d4e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff815d52be>] SyS_connect+0xe/0x10
  [<ffffffff81739a59>] system_call_fastpath+0x16/0x1b

Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/netlabel.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -442,8 +442,7 @@ int selinux_netlbl_socket_connect(struct
 	    sksec->nlbl_state != NLBL_CONNLABELED)
 		return 0;
 
-	local_bh_disable();
-	bh_lock_sock_nested(sk);
+	lock_sock(sk);
 
 	/* connected sockets are allowed to disconnect when the address family
 	 * is set to AF_UNSPEC, if that is what is happening we want to reset
@@ -464,7 +463,6 @@ int selinux_netlbl_socket_connect(struct
 		sksec->nlbl_state = NLBL_CONNLABELED;
 
 socket_connect_return:
-	bh_unlock_sock(sk);
-	local_bh_enable();
+	release_sock(sk);
 	return rc;
 }


