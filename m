Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab3HLKZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:25:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48196 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899Ab3HLKYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:24:44 -0400
Date: Mon, 12 Aug 2013 03:24:11 -0700
From: tip-bot for Jason Wessel <tipbot@zytor.com>
Message-ID: <tip-8f76fcd902e3b3a7d6f6c695cc8bc053579eb179@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jason.wessel@windriver.com,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        jason.wessel@windriver.com, peterz@infradead.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1373920073-4874-1-git-send-email-jason.wessel@windriver.com>
References: <1373920073-4874-1-git-send-email-jason.wessel@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine: Do not require /lib/modules/
 * on a guest
Git-Commit-ID: 8f76fcd902e3b3a7d6f6c695cc8bc053579eb179
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:24:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f76fcd902e3b3a7d6f6c695cc8bc053579eb179
Gitweb:     http://git.kernel.org/tip/8f76fcd902e3b3a7d6f6c695cc8bc053579eb179
Author:     Jason Wessel <jason.wessel@windriver.com>
AuthorDate: Mon, 15 Jul 2013 15:27:53 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:41 -0300

perf machine: Do not require /lib/modules/* on a guest

For some types of work loads and special guest environments, you might
have a kernel that has no kernel modules.  The perf kvm record tool
fails instantiate vmlinux maps when the kernel modules directory cannot
be opened, even though the kallsyms has been properly processed.  This
leads to a perf kvm report that has no guest symbols resolved.

This patch changes the failure to locate kernel modules to be non-fatal.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1373920073-4874-1-git-send-email-jason.wessel@windriver.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ef3b49c..6fcc358 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -806,7 +806,10 @@ static int machine__create_modules(struct machine *machine)
 	free(line);
 	fclose(file);
 
-	return machine__set_modules_path(machine);
+	if (machine__set_modules_path(machine) < 0) {
+		pr_debug("Problems setting modules path maps, continuing anyway...\n");
+	}
+	return 0;
 
 out_delete_line:
 	free(line);
