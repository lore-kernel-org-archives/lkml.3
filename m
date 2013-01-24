Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab3AXVOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:14:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:39869 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284Ab3AXVNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:13:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 02/46] Ensure that kernel_init_freeable() is not inlined into non __init code
Date: Thu, 24 Jan 2013 13:12:40 -0800
Message-Id: <20130124211136.709577169@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <Vineet.Gupta1@synopsys.com>

commit f80b0c904da93b9ad7db2fd9823dd701932df779 upstream.

Commit d6b2123802d "make sure that we always have a return path from
kernel_execve()" reshuffled kernel_init()/init_post() to ensure that
kernel_execve() has a caller to return to.

It removed __init annotation for kernel_init() and introduced/calls a
new routine kernel_init_freeable(). Latter however is inlined by any
reasonable compiler (ARC gcc 4.4 in this case), causing slight code
bloat.

This patch forces kernel_init_freeable() as noinline reducing the .text

bloat-o-meter vmlinux vmlinux_new
add/remove: 1/0 grow/shrink: 0/1 up/down: 374/-334 (40)
function                        old     new   delta
kernel_init_freeable              -     374    +374 (.init.text)
kernel_init                     628     294    -334 (.text)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 init/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/init/main.c
+++ b/init/main.c
@@ -800,7 +800,7 @@ static int run_init_process(const char *
 	return kernel_execve(init_filename, argv_init, envp_init);
 }
 
-static void __init kernel_init_freeable(void);
+static noinline void __init kernel_init_freeable(void);
 
 static int __ref kernel_init(void *unused)
 {
@@ -844,7 +844,7 @@ static int __ref kernel_init(void *unuse
 	      "See Linux Documentation/init.txt for guidance.");
 }
 
-static void __init kernel_init_freeable(void)
+static noinline void __init kernel_init_freeable(void)
 {
 	/*
 	 * Wait until kthreadd is all set-up.


