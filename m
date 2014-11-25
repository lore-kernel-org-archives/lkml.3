Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaKYKnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:43:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58953 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaKYKnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 190/254] param: fix crash on bad kernel arguments
Date: Tue, 25 Nov 2014 10:39:00 +0000
Message-Id: <1416912004-5928-191-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 init/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index e8ae1fef0908..ed5f48edc7a8 100644
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
2.1.0

