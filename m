Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965035Ab3HHNdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:33:33 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:47076 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab3HHNdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:33:32 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: getarunks@gmail.com
Date: Thu, 8 Aug 2013 19:03:31 +0530
X-Google-Sender-Auth: Yn3cSxJxXLUHCsMGO6phTvUd_R4
Message-ID: <CAKZGPANjwYxoAtO068UN1iMuMZPtkbjACz8C3yHjZMr5BkM63A@mail.gmail.com>
Subject: Seq File: Return error if d_path fails
From: Arun KS <arunks.linux@gmail.com>
To: viro@zeniv.linux.org.uk, matthew@wil.cx, bfields@fieldses.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: vinayak menon <vinayakm.list@gmail.com>,
        Nagachandra P <nagachandra@gmail.com>, Vikram MP <mp.vikram@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2558382c8a030f7261e47977ac62412cd78e6d38 Mon Sep 17 00:00:00 2001
From: Arun KS <arun.ks@broadcom.com>
Date: Thu, 8 Aug 2013 18:23:04 +0530
Subject: Seq File: Return error if d_path fails

Return error if d_path fails in seq_path funciton. If we do not return
from here,
seq_commit sets seq_file state as overflow. And this continues in a
loop utill we
increase the size of seq buf beyond KMALLOC_MAX_SIZE.

[  363.192565] ------------[ cut here ]------------
[  363.199462] WARNING: at mm/slab_common.c:377 kmalloc_slab+0x34/0x9c()
[  363.208557] Modules linked in:
[  363.212219] CPU: 1 PID: 1742 Comm: Binder_2 Tainted: G        W
3.10.0+ #17
[  363.222930] [<c00151c4>] (unwind_backtrace+0x0/0x11c) from
[<c0011a24>] (show_stack+0x10/0x14)
[  363.235229] [<c0011a24>] (show_stack+0x10/0x14) from [<c0059fb0>]
(warn_slowpath_common+0x4c/0x68)
[  363.247253] [<c0059fb0>] (warn_slowpath_common+0x4c/0x68) from
[<c0059fe4>] (warn_slowpath_null+0x18/0x1c)
[  363.259307] [<c0059fe4>] (warn_slowpath_null+0x18/0x1c) from
[<c00fa400>] (kmalloc_slab+0x34/0x9c)
[  363.270812] [<c00fa400>] (kmalloc_slab+0x34/0x9c) from [<c010ec20>]
(__kmalloc+0x14/0x1fc)
[  363.281433] [<c010ec20>] (__kmalloc+0x14/0x1fc) from [<c012ef70>]
(seq_read+0x24c/0x438)
[  363.291992] [<c012ef70>] (seq_read+0x24c/0x438) from [<c011389c>]
(vfs_read+0xac/0x124)
[  363.302398] [<c011389c>] (vfs_read+0xac/0x124) from [<c0113a38>]
(SyS_read+0x3c/0x60)
[  363.312591] [<c0113a38>] (SyS_read+0x3c/0x60) from [<c000e180>]
(ret_fast_syscall+0x0/0x48)
[  363.323303] ---[ end trace 46c6467e2db7bcd4 ]---

Change-Id: If6b97a0f83aa3293c09d5b2e9aca5d0ac5fd0774

Signed-off-by: Arun KS <arun.ks@broadcom.com>
---
 fs/seq_file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 774c1eb..3d08377 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -471,7 +471,8 @@ int seq_path(struct seq_file *m, const struct path
*path, const char *esc)
                        char *end = mangle_path(buf, p, esc);
                        if (end)
                                res = end - buf;
-               }
+               } else
+                       return PTR_ERR(p);
        }
        seq_commit(m, res);

--
1.8.2
