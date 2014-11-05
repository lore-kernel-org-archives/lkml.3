Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbaKEPFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:05:01 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:46439 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbaKEPE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:04:58 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, stable@vger.kernel.org
Subject: [PATCH v3.18-rc3] param: fix crash on bad kernel arguments
Date: Wed,  5 Nov 2014 15:04:50 +0000
Message-Id: <1415199890-32413-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@vger.kernel.org
---
 init/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index 800a0da..321d0ce 100644
--- a/init/main.c
+++ b/init/main.c
@@ -544,7 +544,7 @@ asmlinkage __visible void __init start_kernel(void)
 				  static_command_line, __start___param,
 				  __stop___param - __start___param,
 				  -1, -1, &unknown_bootoption);
-	if (after_dashes)
+	if (!IS_ERR_OR_NULL(after_dashes))
 		parse_args("Setting init args", after_dashes, NULL, 0, -1, -1,
 			   set_init_arg);

--
1.9.3

