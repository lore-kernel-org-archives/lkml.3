Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab3BYRMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 12:12:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab3BYRMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:12:45 -0500
Date: Mon, 25 Feb 2013 18:11:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        hongfeng <hongfeng@marvell.com>
Subject: [PATCH 1/1] usermodehelper: cleanup/fix __orderly_poweroff() &&
	argv_free()
Message-ID: <20130225171114.GC1024@redhat.com>
References: <1361802350-9299-1-git-send-email-lucas.demarchi@profusion.mobi> <20130225171014.GB1024@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130225171014.GB1024@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__orderly_poweroff() does argv_free() if call_usermodehelper_fns()
returns -ENOMEM. As Lucas pointed out, this can be wrong if -ENOMEM
was not triggered by the failing call_usermodehelper_setup(), in this
case both __orderly_poweroff() and argv_cleanup() can do kfree().

Kill argv_cleanup() and change __orderly_poweroff() to call argv_free()
unconditionally like do_coredump() does. This info->cleanup() is not
needed (and wrong) since 6c0c0d4d "fix bug in orderly_poweroff() which
did the UMH_NO_WAIT => UMH_WAIT_EXEC change, we can rely on the fact
that CLONE_VFORK can't return until do_execve() succeeds/fails.

Reported-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- x/kernel/sys.c
+++ x/kernel/sys.c
@@ -2184,11 +2184,6 @@ SYSCALL_DEFINE3(getcpu, unsigned __user 
 
 char poweroff_cmd[POWEROFF_CMD_PATH_LEN] = "/sbin/poweroff";
 
-static void argv_cleanup(struct subprocess_info *info)
-{
-	argv_free(info->argv);
-}
-
 static int __orderly_poweroff(void)
 {
 	int argc;
@@ -2208,9 +2203,8 @@ static int __orderly_poweroff(void)
 	}
 
 	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_WAIT_EXEC,
-				      NULL, argv_cleanup, NULL);
-	if (ret == -ENOMEM)
-		argv_free(argv);
+				      NULL, NULL, NULL);
+	argv_free(argv);
 
 	return ret;
 }

