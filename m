Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbaBEUMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:12:05 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48658 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbaBEUIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:08:23 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Sasha Levin <levinsasha928@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 210/213] phonet: Check input from user before allocating
Date: Wed, 5 Feb 2014 15:02:45 -0500
Message-ID: <1391630568-49251-211-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <levinsasha928@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit bcf1b70ac6eb0ed8286c66e6bf37cb747cbaa04c upstream.

A phonet packet is limited to USHRT_MAX bytes, this is never checked during
tx which means that the user can specify any size he wishes, and the kernel
will attempt to allocate that size.

In the good case, it'll lead to the following warning, but it may also cause
the kernel to kick in the OOM and kill a random task on the server.

[ 8921.744094] WARNING: at mm/page_alloc.c:2255 __alloc_pages_slowpath+0x65/0x730()
[ 8921.749770] Pid: 5081, comm: trinity Tainted: G        W    3.4.0-rc1-next-20120402-sasha #46
[ 8921.756672] Call Trace:
[ 8921.758185]  [<ffffffff810b2ba7>] warn_slowpath_common+0x87/0xb0
[ 8921.762868]  [<ffffffff810b2be5>] warn_slowpath_null+0x15/0x20
[ 8921.765399]  [<ffffffff8117eae5>] __alloc_pages_slowpath+0x65/0x730
[ 8921.769226]  [<ffffffff81179c8a>] ? zone_watermark_ok+0x1a/0x20
[ 8921.771686]  [<ffffffff8117d045>] ? get_page_from_freelist+0x625/0x660
[ 8921.773919]  [<ffffffff8117f3a8>] __alloc_pages_nodemask+0x1f8/0x240
[ 8921.776248]  [<ffffffff811c03e0>] kmalloc_large_node+0x70/0xc0
[ 8921.778294]  [<ffffffff811c4bd4>] __kmalloc_node_track_caller+0x34/0x1c0
[ 8921.780847]  [<ffffffff821b0e3c>] ? sock_alloc_send_pskb+0xbc/0x260
[ 8921.783179]  [<ffffffff821b3c65>] __alloc_skb+0x75/0x170
[ 8921.784971]  [<ffffffff821b0e3c>] sock_alloc_send_pskb+0xbc/0x260
[ 8921.787111]  [<ffffffff821b002e>] ? release_sock+0x7e/0x90
[ 8921.788973]  [<ffffffff821b0ff0>] sock_alloc_send_skb+0x10/0x20
[ 8921.791052]  [<ffffffff824cfc20>] pep_sendmsg+0x60/0x380
[ 8921.792931]  [<ffffffff824cb4a6>] ? pn_socket_bind+0x156/0x180
[ 8921.794917]  [<ffffffff824cb50f>] ? pn_socket_autobind+0x3f/0x90
[ 8921.797053]  [<ffffffff824cb63f>] pn_socket_sendmsg+0x4f/0x70
[ 8921.798992]  [<ffffffff821ab8e7>] sock_aio_write+0x187/0x1b0
[ 8921.801395]  [<ffffffff810e325e>] ? sub_preempt_count+0xae/0xf0
[ 8921.803501]  [<ffffffff8111842c>] ? __lock_acquire+0x42c/0x4b0
[ 8921.805505]  [<ffffffff821ab760>] ? __sock_recv_ts_and_drops+0x140/0x140
[ 8921.807860]  [<ffffffff811e07cc>] do_sync_readv_writev+0xbc/0x110
[ 8921.809986]  [<ffffffff811958e7>] ? might_fault+0x97/0xa0
[ 8921.811998]  [<ffffffff817bd99e>] ? security_file_permission+0x1e/0x90
[ 8921.814595]  [<ffffffff811e17e2>] do_readv_writev+0xe2/0x1e0
[ 8921.816702]  [<ffffffff810b8dac>] ? do_setitimer+0x1ac/0x200
[ 8921.818819]  [<ffffffff810e2ec1>] ? get_parent_ip+0x11/0x50
[ 8921.820863]  [<ffffffff810e325e>] ? sub_preempt_count+0xae/0xf0
[ 8921.823318]  [<ffffffff811e1926>] vfs_writev+0x46/0x60
[ 8921.825219]  [<ffffffff811e1a3f>] sys_writev+0x4f/0xb0
[ 8921.827127]  [<ffffffff82658039>] system_call_fastpath+0x16/0x1b
[ 8921.829384] ---[ end trace dffe390f30db9eb7 ]---

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Acked-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/phonet/pep.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index dc1e8ae81781..ca21189392fe 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -862,6 +862,9 @@ static int pep_sendmsg(struct kiocb *iocb, struct sock *sk,
 	int flags = msg->msg_flags;
 	int err, done;
 
+	if (len > USHORT_MAX)
+		return -EMSGSIZE;
+
 	if ((msg->msg_flags & ~(MSG_DONTWAIT|MSG_EOR|MSG_NOSIGNAL|
 				MSG_CMSG_COMPAT)) ||
 			!(msg->msg_flags & MSG_EOR))
-- 
1.8.5.2

