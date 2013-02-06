Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab3BFITu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:19:50 -0500
Received: from ozlabs.org ([203.10.76.45]:57939 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab3BFIT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:19:26 -0500
From: Michael Ellerman <michael@ellerman.id.au>
To: <penberg@kernel.org>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] kvm tools: More error handling in the ipc code
Date: Wed,  6 Feb 2013 19:19:12 +1100
Message-Id: <1360138756-1991-2-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360138756-1991-1-git-send-email-michael@ellerman.id.au>
References: <1360138756-1991-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add perror() calls to a couple of exit paths, to ease debugging.

There are also two places where we print "Failed starting IPC thread",
but one is really an epoll failure, so make that obvious.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/kvm-ipc.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/kvm/kvm-ipc.c b/tools/kvm/kvm-ipc.c
index bdcc0d1..7897519 100644
--- a/tools/kvm/kvm-ipc.c
+++ b/tools/kvm/kvm-ipc.c
@@ -49,18 +49,25 @@ static int kvm__create_socket(struct kvm *kvm)
 	}
 
 	s = socket(AF_UNIX, SOCK_STREAM, 0);
-	if (s < 0)
+	if (s < 0) {
+		perror("socket");
 		return s;
+	}
+
 	local.sun_family = AF_UNIX;
 	strlcpy(local.sun_path, full_name, sizeof(local.sun_path));
 	len = strlen(local.sun_path) + sizeof(local.sun_family);
 	r = bind(s, (struct sockaddr *)&local, len);
-	if (r < 0)
+	if (r < 0) {
+		perror("bind");
 		goto fail;
+	}
 
 	r = listen(s, 5);
-	if (r < 0)
+	if (r < 0) {
+		perror("listen");
 		goto fail;
+	}
 
 	return s;
 
@@ -430,6 +437,7 @@ int kvm_ipc__init(struct kvm *kvm)
 
 	epoll_fd = epoll_create(KVM_IPC_MAX_MSGS);
 	if (epoll_fd < 0) {
+		perror("epoll_create");
 		ret = epoll_fd;
 		goto err;
 	}
@@ -437,13 +445,14 @@ int kvm_ipc__init(struct kvm *kvm)
 	ev.events = EPOLLIN | EPOLLET;
 	ev.data.fd = sock;
 	if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, sock, &ev) < 0) {
-		pr_err("Failed starting IPC thread");
+		pr_err("Failed adding socket to epoll");
 		ret = -EFAULT;
 		goto err_epoll;
 	}
 
 	stop_fd = eventfd(0, 0);
 	if (stop_fd < 0) {
+		perror("eventfd");
 		ret = stop_fd;
 		goto err_epoll;
 	}
-- 
1.7.10.4

