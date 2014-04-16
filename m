Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaDPRyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:54:49 -0400
Received: from smtp.outflux.net ([198.145.64.163]:38195 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666AbaDPRyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:54:47 -0400
Date: Wed, 16 Apr 2014 10:54:34 -0700
From: Kees Cook <keescook@chromium.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: Daniel Borkmann <dborkman@redhat.com>, Kees Cook <keescook@chromium.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Josh Triplett <josh@joshtriplett.org>, Eric Paris <eparis@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Masami Ichikawa <masami256@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] seccomp: fix memory leak on filter attach
Message-ID: <20140416175434.GA13158@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This sets the correct error code when final filter memory is unavailable,
and frees the raw filter no matter what.

unreferenced object 0xffff8800d6ea4000 (size 512):
  comm "sshd", pid 278, jiffies 4294898315 (age 46.653s)
  hex dump (first 32 bytes):
    21 00 00 00 04 00 00 00 15 00 01 00 3e 00 00 c0  !...........>...
    06 00 00 00 00 00 00 00 21 00 00 00 00 00 00 00  ........!.......
  backtrace:
    [<ffffffff8151414e>] kmemleak_alloc+0x4e/0xb0
    [<ffffffff811a3a40>] __kmalloc+0x280/0x320
    [<ffffffff8110842e>] prctl_set_seccomp+0x11e/0x3b0
    [<ffffffff8107bb6b>] SyS_prctl+0x3bb/0x4a0
    [<ffffffff8152ef2d>] system_call_fastpath+0x1a/0x1f
    [<ffffffffffffffff>] 0xffffffffffffffff

Reported-by: Masami Ichikawa <masami256@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Masami Ichikawa <masami256@gmail.com>
Acked-by: Daniel Borkmann <dborkman@redhat.com>
---
David, since you just pushed the a0-a5 fix, can you push this fix as well?

v2:
 - drop stable cc, not needed.
 - added tested-by and acked-by.
---
 kernel/seccomp.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 590c37925084..b35c21503a36 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -255,6 +255,7 @@ static long seccomp_attach_filter(struct sock_fprog *fprog)
 		goto free_prog;
 
 	/* Allocate a new seccomp_filter */
+	ret = -ENOMEM;
 	filter = kzalloc(sizeof(struct seccomp_filter) +
 			 sizeof(struct sock_filter_int) * new_len,
 			 GFP_KERNEL|__GFP_NOWARN);
@@ -264,6 +265,7 @@ static long seccomp_attach_filter(struct sock_fprog *fprog)
 	ret = sk_convert_filter(fp, fprog->len, filter->insnsi, &new_len);
 	if (ret)
 		goto free_filter;
+	kfree(fp);
 
 	atomic_set(&filter->usage, 1);
 	filter->len = new_len;
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
