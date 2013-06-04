Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab3FDWoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:44:08 -0400
Received: from 1wt.eu ([62.212.114.60]:35839 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096Ab3FDWoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:03 -0400
Message-Id: <20130604172136.766345256@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 156/184] net: fix info leak in compat dev_ifconf()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 43da5f2e0d0c69ded3d51907d9552310a6b545e8 upstream.

The implementation of dev_ifconf() for the compat ioctl interface uses
an intermediate ifc structure allocated in userland for the duration of
the syscall. Though, it fails to initialize the padding bytes inserted
for alignment and that for leaks four bytes of kernel stack. Add an
explicit memset(0) before filling the structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 2.6.32: adjust filename, context]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/compat_ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 0dd21a4..98d3c58 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -352,6 +352,7 @@ static int dev_ifconf(unsigned int fd, unsigned int cmd, unsigned long arg)
 	if (copy_from_user(&ifc32, compat_ptr(arg), sizeof(struct ifconf32)))
 		return -EFAULT;
 
+	memset(&ifc, 0, sizeof(ifc));
 	if (ifc32.ifcbuf == 0) {
 		ifc32.ifc_len = 0;
 		ifc.ifc_len = 0;
-- 
1.7.12.2.21.g234cd45.dirty



