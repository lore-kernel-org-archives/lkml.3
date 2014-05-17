Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030332AbaEQRUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:20:15 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:48273 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964842AbaEQRUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:20:13 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] macintosh: windfarm_pm121.c:  Fix for possible null pointer dereference
Date: Sat, 17 May 2014 19:20:57 +0200
Message-Id: <1400347257-25623-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/macintosh/windfarm_pm121.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/macintosh/windfarm_pm121.c b/drivers/macintosh/windfarm_pm121.c
index 7fe58b0..b350fb8 100644
--- a/drivers/macintosh/windfarm_pm121.c
+++ b/drivers/macintosh/windfarm_pm121.c
@@ -555,8 +555,18 @@ static void pm121_create_sys_fans(int loop_id)
 	pid_param.interval	= PM121_SYS_INTERVAL;
 	pid_param.history_len	= PM121_SYS_HISTORY_SIZE;
 	pid_param.itarget	= param->itarget;
-	pid_param.min		= control->ops->get_min(control);
-	pid_param.max		= control->ops->get_max(control);
+	if(control)
+	{
+		pid_param.min		= control->ops->get_min(control);
+		pid_param.max		= control->ops->get_max(control);
+	} else {
+		/*
+		 * This is probably not the right!?
+		 * Perhaps goto fail  if control == NULL  above?
+		 */
+		pid_param.min		= 0;
+		pid_param.max		= 0;
+	}
 
 	wf_pid_init(&pm121_sys_state[loop_id]->pid, &pid_param);
 
@@ -571,7 +581,7 @@ static void pm121_create_sys_fans(int loop_id)
 	   control the same control */
 	printk(KERN_WARNING "pm121: failed to set up %s loop "
 	       "setting \"%s\" to max speed.\n",
-	       loop_names[loop_id], control->name);
+	       loop_names[loop_id], control ? control->name : "uninitialized value");
 
 	if (control)
 		wf_control_set_max(control);
-- 
1.7.10.4

