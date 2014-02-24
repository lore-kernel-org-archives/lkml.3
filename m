Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaBXBoP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 20:44:15 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44491 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaBXBoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 20:44:10 -0500
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Subject: [RFC PATCH for-next 4/4] epoll: epoll() syscall definition
Date: Sun, 23 Feb 2014 17:42:42 -0800
Message-Id: <1393206162-18151-5-git-send-email-n1ght.4nd.d4y@gmail.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
References: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new system call combines eventpoll entry addition, modification,
deletion, and retrieval into a single call, much like the BSDs' kevent().
Eventpoll entries are described using struct epoll, whose definition
and implementation can be found in prior patches. Its operation is fairly
straightforward: for every input eventpoll entry, add/modify it if the
I/O events bitmask is nonzero (otherwise remove the untriggerable entry),
updating the final event mask in userspace, then retrieve as many ready
eventpoll entries as will fit into the output buffer. It returns the
number of successfully

Signed-off-by: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
---
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index af90312..13451a2 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1816,6 +1981,66 @@ SYSCALL_DEFINE1(epoll_create, int, size)
 }
 
 /*
+ * This behaves like sys_epoll_ctl() and sys_epoll_wait() combined into one;
+ * it creates, modifies, or deletes eventpoll entries from the 'in' array and
+ * stores triggered eventpoll entries in the 'out' array. The input array is
+ * _not_ read-only, because the resulting event mask gets written back to each
+ * entry's ->ep_events field. When successful, this will be the same as before
+ * (plus EPOLLERR & EPOLLHUP). If ->ep_events gets cleared, then it is reasonable
+ * to infer that the entry's ->ep_fildes was a bad file descriptor.
+ */
+SYSCALL_DEFINE6(epoll, int, ep, struct epoll __user *, in,
+		unsigned int, inc, struct epoll __user *, out,
+		unsigned int, outc, int, timeout)
+{
+	struct file *file = fget(ep);
+	unsigned int i;
+	int ret;
+
+	ret = -EBADF;
+	if (!file || !is_file_epoll(file))
+		goto out;
+
+input:
+	/* process input eventpoll entries */
+	if (!in || !inc)
+		goto output;
+
+	ret = -EFAULT;
+	if (!access_ok(VERIFY_WRITE, in, inc * sizeof(struct epoll)))
+		goto out;
+	for (i = 0; i < inc; ++i) {
+		int fd, io;
+		long long id;
+
+		ret = -EFAULT;
+		if (__get_user(fd, &in[i].ep_fildes) ||
+		    __get_user(io, &in[i].ep_events) ||
+		    __get_user(id, &in[i].ep_ident))
+			goto out;
+
+		ep_control(file->private_data, fd, &io, id, 0);
+		ret = -EFAULT;
+		if (__put_user(io, &in[i].ep_events))
+			goto out;
+	}
+
+output:
+	/* produce output eventpoll entries */
+	if (!out || !outc)
+		goto out;
+
+	ret = -EFAULT;
+	if (!access_ok(VERIFY_WRITE, out, outc * sizeof(struct epoll)))
+		goto out;
+	ret = ep_poll(file->private_data, out, outc * sizeof(struct epoll),
+		      timeout, ep_send_entries);
+out:
+	fput(file);
+	return ret;
+}
+
+/*
  * The following function implements the controller interface for
  * the eventpoll file that enables the insertion/removal/change of
  * file descriptors inside the interest set.
