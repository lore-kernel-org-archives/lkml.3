Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab3DWQKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:10:34 -0400
Received: from nm21.access.bullet.mail.mud.yahoo.com ([66.94.237.222]:41510
	"EHLO nm21.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756714Ab3DWQKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:10:32 -0400
X-Yahoo-Newman-Id: 50915.6749.bm@smtp104.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7B2qjuUVM1mXh2A4_7X.aOXwkrzPoG5ZEm5pCgVnIKSFGDR
 iUhNIxKepVrWC32kf045x1IrAY.9GvG_iapgadMZ4I2ekAAj.rzy0XRK90O5
 DcNoucRyTmqd5jvU0x_aLltukzLcYAU2VqbpCjCrnnUGuWREPYgDCYRB8mSY
 wZOSx.XJOZNk7SkHdSYE.txHHo8HtwOzvbegZ.0rlAet40MT3vI6Jy_sYDAZ
 Z_nMf_gc0Mt4fMUNWNuySyJYEYGPYtcj6Svm9hyz5GLQXWTU5KqNxvKj3eQA
 jTqPq52n9RgGNHIoma9aMyBH2cvDkMKhysXFmlFwYbwOiEEwTCBjNi28LIp0
 tgL5Eo6GRY.yxmnc8vhCkDtM8o5xTeyXv9Qz1PVugm1MFgmFuaY2L_3wsNDx
 WG2x_.e85Xqr7.JNaTjYFZB3M6LVF8TjX7hV2TI14j827sP31QZwcKJKcEhv
 y7g--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp104.biz.mail.ne1.yahoo.com with SMTP; 23 Apr 2013 09:04:40 -0700 PDT
Message-ID: <5176B119.5090308@schaufler-ca.com>
Date: Tue, 23 Apr 2013 09:04:41 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>
CC: John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH v13 6/9] LSM: Additional interfaces in /proc/pid/attr
References: <5176ABB7.5080300@schaufler-ca.com>
In-Reply-To: <5176ABB7.5080300@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v13 6/9] LSM: Additional interfaces in /proc/pid/attr

SELinux, Smack and AppArmor share the files to /proc/<pid>/attr.
This is fine when only one LSM is allowed, but not so good
when there is more than one of those LSMs active. For backward
compatability the old interfaces are left as is. New interfaces
specific to the LSMs have been added. There is also a new entry
"context", which is the combined security context.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 fs/proc/base.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 69078c7..51435ba 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2217,12 +2217,29 @@ static const struct file_operations proc_pid_attr_operations = {
 };
 
 static const struct pid_entry attr_dir_stuff[] = {
-	REG("current",    S_IRUGO|S_IWUGO, proc_pid_attr_operations),
-	REG("prev",       S_IRUGO,	   proc_pid_attr_operations),
-	REG("exec",       S_IRUGO|S_IWUGO, proc_pid_attr_operations),
-	REG("fscreate",   S_IRUGO|S_IWUGO, proc_pid_attr_operations),
-	REG("keycreate",  S_IRUGO|S_IWUGO, proc_pid_attr_operations),
-	REG("sockcreate", S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("current",            S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("prev",               S_IRUGO,	   proc_pid_attr_operations),
+	REG("exec",               S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("fscreate",           S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("keycreate",          S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("sockcreate",         S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("context",            S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+#ifdef CONFIG_SECURITY_SELINUX
+	REG("selinux.current",    S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("selinux.prev",       S_IRUGO,	   proc_pid_attr_operations),
+	REG("selinux.exec",       S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("selinux.fscreate",   S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("selinux.keycreate",  S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("selinux.sockcreate", S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+#endif
+#ifdef CONFIG_SECURITY_SMACK
+	REG("smack.current",      S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+#endif
+#ifdef CONFIG_SECURITY_APPARMOR
+	REG("apparmor.current",   S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("apparmor.prev",      S_IRUGO,	   proc_pid_attr_operations),
+	REG("apparmor.exec",      S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+#endif
 };
 
 static int proc_attr_dir_readdir(struct file * filp,

