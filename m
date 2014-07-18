Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050AbaGRJHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:07:42 -0400
Received: from mail1.sysgo.com ([176.9.26.183]:55767 "EHLO mail1.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180AbaGRJHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:07:40 -0400
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2014 05:07:40 EDT
Message-ID: <53C8E1D6.8020906@sysgo.com>
Date: Fri, 18 Jul 2014 10:59:02 +0200
From: David Engraf <david.engraf@sysgo.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        "Daniel M. Weeks" <dan@danweeks.net>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] add error checks to initramfs
Content-Type: multipart/mixed;
 boundary="------------030103000803080403090307"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030103000803080403090307
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On a system with low memory extracting the initramfs may fail. If this 
happens the user gets "Failed to execute /init" instead of an initramfs 
error.

Check return value of sys_write and call error() when the write was 
incomplete or failed.

Signed-off-by: David Engraf <david.engraf@sysgo.com>


--------------030103000803080403090307
Content-Type: text/x-diff;
 name="initramfs_error_check.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="initramfs_error_check.patch"

diff --git a/init/initramfs.c b/init/initramfs.c
index a8497fa..64013cc 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -346,7 +346,8 @@ static int __init do_name(void)
 static int __init do_copy(void)
 {
 	if (count >= body_len) {
-		sys_write(wfd, victim, body_len);
+		if (sys_write(wfd, victim, body_len) != body_len)
+			error("write error");
 		sys_close(wfd);
 		do_utime(vcollected, mtime);
 		kfree(vcollected);
@@ -354,7 +355,8 @@ static int __init do_copy(void)
 		state = SkipIt;
 		return 0;
 	} else {
-		sys_write(wfd, victim, count);
+		if (sys_write(wfd, victim, count) != count)
+			error("write error");
 		body_len -= count;
 		eat(count);
 		return 1;

--------------030103000803080403090307--
