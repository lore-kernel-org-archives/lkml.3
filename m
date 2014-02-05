Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbaBEVHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:07:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:54453 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbaBEUEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:04:49 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 043/213] net: fix info leak in compat dev_ifconf()
Date: Wed, 5 Feb 2014 14:59:58 -0500
Message-ID: <1391630568-49251-44-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 43da5f2e0d0c69ded3d51907d9552310a6b545e8 upstream.

The implementation of dev_ifconf() for the compat ioctl interface uses
an intermediate ifc structure allocated in userland for the duration of
the syscall. Though, it fails to initialize the padding bytes inserted
for alignment and that for leaks four bytes of kernel stack. Add an
explicit memset(0) before filling the structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/socket.c b/net/socket.c
index c802797e3a4a..b0d3b6a025ea 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2508,6 +2508,7 @@ static int dev_ifconf(struct net *net, struct compat_ifconf __user *uifc32)
 	if (copy_from_user(&ifc32, uifc32, sizeof(struct compat_ifconf)))
 		return -EFAULT;
 
+	memset(&ifc, 0, sizeof(ifc));
 	if (ifc32.ifcbuf == 0) {
 		ifc32.ifc_len = 0;
 		ifc.ifc_len = 0;
-- 
1.8.5.2

