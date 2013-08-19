Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab3HSJo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:44:57 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36492 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab3HSJmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:42:09 -0400
X-AuditID: 85900ec0-d1328b9000001514-3d-5211e86fcbd3
Subject: [RFC PATCH 02/11] [BUGFIX] trace-cmd: Add waitpid() when recorders
 are destoried
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Mon, 19 Aug 2013 18:46:25 +0900
Message-ID: <20130819094625.26597.7049.stgit@yunodevel>
In-Reply-To: <20130819094620.26597.79499.stgit@yunodevel>
References: <20130819094620.26597.79499.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add waitpid() when recorders are destroyed for avoiding zombie processes.
When udp_port is inappropriate, a parent process will destroy all child recorder
processes. Currently, the process does not wait for the termination of the
children, so those recorders can become zombie processes if the parent process
cannot die at once due to any reasons.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 trace-listen.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/trace-listen.c b/trace-listen.c
index dec1c00..6c1bcac 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -446,6 +446,7 @@ static void process_client(const char *node, const char *port, int fd)
 	for (cpu = 0; cpu < cpus; cpu++) {
 		if (pid_array[cpu] > 0) {
 			kill(pid_array[cpu], SIGKILL);
+			waitpid(pid_array[cpu], NULL, 0);
 			delete_temp_file(node, port, cpu);
 			pid_array[cpu] = 0;
 		}

