Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298AbaKSW2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:28:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744AbaKSUyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3.17 048/141] param: fix crash on bad kernel arguments
Date: Wed, 19 Nov 2014 12:51:11 -0800
Message-Id: <20141119205152.258357286@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Thompson <daniel.thompson@linaro.org>

commit 3438cf549d2f3ee8e52c82acc8e2a9710ac21a5b upstream.

Currently if the user passes an invalid value on the kernel command line
then the kernel will crash during argument parsing. On most systems this
is very hard to debug because the console hasn't been initialized yet.

This is a regression due to commit 51e158c12aca ("param: hand arguments
after -- straight to init") which, in response to the systemd debug
controversy, made it possible to explicitly pass arguments to init. To
achieve this parse_args() was extended from simply returning an error
code to returning a pointer. Regretably the new init args logic does not
perform a proper validity check on the pointer resulting in a crash.

This patch fixes the validity check. Should the check fail then no arguments
will be passed to init. This is reasonable and matches how the kernel treats
its own arguments (i.e. no error recovery).

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c
+++ b/init/main.c
@@ -544,7 +544,7 @@ asmlinkage __visible void __init start_k
 				  static_command_line, __start___param,
 				  __stop___param - __start___param,
 				  -1, -1, &unknown_bootoption);
-	if (after_dashes)
+	if (!IS_ERR_OR_NULL(after_dashes))
 		parse_args("Setting init args", after_dashes, NULL, 0, -1, -1,
 			   set_init_arg);
 


