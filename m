Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaD0Khk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 06:37:40 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:38089 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaD0Khj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 06:37:39 -0400
MIME-Version: 1.0
Date: Sun, 27 Apr 2014 13:37:38 +0300
Message-ID: <CALkh-HgA3rPpgTGrBDrY4v5w4xXgmtA=-PKbWGBG-eB_0sWoVw@mail.gmail.com>
Subject: [PATCH] do_mounts: fix not all available filesystems get tried during boot
From: =?UTF-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?= 
	<plamen.sisi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While debugging a kernel panic with 3.14.1 it became clear that some
changes made some filesystems mount routines return error codes other
than 0, EACCES and EINVAL. Such return codes result in the kernel
panicking without trying to mount root with all of the available
filesystems, as can be seen in bugzilla entries 74901 and 74261.

Make mount_block_root continue trying other available filesystems by
default, not only when the last tried returned EACCES or EINVAL.

Signed-off-by: Plamen Petrov <plamen.sisi@gmail.com>
---
 init/do_mounts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 09ded58..a4abbdf 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -403,7 +403,7 @@ retry:
                        case -EACCES:
                                flags |= MS_RDONLY;
                                goto retry;
-                       case -EINVAL:
+                       default:
                                continue;
                }
                /*
--
1.9.0
