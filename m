Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106Ab3CMRtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:49:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932905Ab3CMRtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:49:08 -0400
Date: Wed, 13 Mar 2013 18:47:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH 1/1] poweroff: change orderly_poweroff() to use
	schedule_work()
Message-ID: <20130313174705.GB28083@redhat.com>
References: <1363058712.4534.12.camel@pasglop> <CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com> <CAKi4VALkUhOtP_8BOi3Mi8fTz8TUPwmwQq7WW27BEDue2wFNRw@mail.gmail.com> <20130312182210.GA15862@redhat.com> <CA+55aFz9M1RWOwyRuatxnyQ+_ON0+A032QcW9=oBOks1JPt13w@mail.gmail.com> <20130312191118.GA17439@redhat.com> <CA+55aFzmATkP-W0uX1a_gP7E1fwcp2Mh4537Ou2uwHDixNKPTg@mail.gmail.com> <20130312203514.GA23488@redhat.com> <20130313174641.GA28083@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130313174641.GA28083@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

orderly_poweroff() can be used from any context but UMH_WAIT_EXEC
is sleepable. Move the "force" logic into __orderly_poweroff() and
change orderly_poweroff() to use the global poweroff_work which
simply calls __orderly_poweroff().

While at it, remove the unneeded "int argc" and change argv_split()
to use GFP_KERNEL.

We use the global "bool poweroff_force" to pass the argument, this
can obviously affect the previous request if it is pending/running.
So we only allow the "false => true" transition assuming that the
pending "true" should succeed anyway. If schedule_work() fails after
that we know that work->func() was not called yet, it must see the
new value.

This means that orderly_poweroff() becomes async even if we do not
run the command and always succeeds, schedule_work() can only fail
if the work is already pending. We can export __orderly_poweroff()
and change the non-atomic callers which want the old semantics.

Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sys.c |   57 ++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index e02a036..7c9565f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2184,9 +2184,8 @@ SYSCALL_DEFINE3(getcpu, unsigned __user *, cpup, unsigned __user *, nodep,
 
 char poweroff_cmd[POWEROFF_CMD_PATH_LEN] = "/sbin/poweroff";
 
-static int __orderly_poweroff(void)
+static int __orderly_poweroff(bool force)
 {
-	int argc;
 	char **argv;
 	static char *envp[] = {
 		"HOME=/",
@@ -2195,20 +2194,40 @@ static int __orderly_poweroff(void)
 	};
 	int ret;
 
-	argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
-	if (argv == NULL) {
+	argv = argv_split(GFP_KERNEL, poweroff_cmd, NULL);
+	if (argv) {
+		ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+		argv_free(argv);
+	} else {
 		printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
-		       __func__, poweroff_cmd);
-		return -ENOMEM;
+					 __func__, poweroff_cmd);
+		ret = -ENOMEM;
 	}
 
-	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_WAIT_EXEC,
-				      NULL, NULL, NULL);
-	argv_free(argv);
+	if (ret && force) {
+		printk(KERN_WARNING "Failed to start orderly shutdown: "
+					"forcing the issue\n");
+		/*
+		 * I guess this should try to kick off some daemon to sync and
+		 * poweroff asap.  Or not even bother syncing if we're doing an
+		 * emergency shutdown?
+		 */
+		emergency_sync();
+		kernel_power_off();
+	}
 
 	return ret;
 }
 
+static bool poweroff_force;
+
+static void poweroff_work_func(struct work_struct *work)
+{
+	__orderly_poweroff(poweroff_force);
+}
+
+static DECLARE_WORK(poweroff_work, poweroff_work_func);
+
 /**
  * orderly_poweroff - Trigger an orderly system poweroff
  * @force: force poweroff if command execution fails
@@ -2218,21 +2237,9 @@ static int __orderly_poweroff(void)
  */
 int orderly_poweroff(bool force)
 {
-	int ret = __orderly_poweroff();
-
-	if (ret && force) {
-		printk(KERN_WARNING "Failed to start orderly shutdown: "
-		       "forcing the issue\n");
-
-		/*
-		 * I guess this should try to kick off some daemon to sync and
-		 * poweroff asap.  Or not even bother syncing if we're doing an
-		 * emergency shutdown?
-		 */
-		emergency_sync();
-		kernel_power_off();
-	}
-
-	return ret;
+	if (force) /* do not override the pending "true" */
+		poweroff_force = true;
+	schedule_work(&poweroff_work);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(orderly_poweroff);
-- 
1.5.5.1


