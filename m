Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab3JRA0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 20:26:52 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:48342 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab3JRA0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 20:26:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>
Date: Thu, 17 Oct 2013 17:26:43 -0700
Message-ID: <87bo2n4e64.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/qIlZmTggYuqfTm9sKJxbmp4NBLdYfLlU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.5 TooManyTo_002 Multiple "To" Header Recipients 3x (uncommon)
	*  0.3 TooManyTo_001 Multiple "To" Header Recipients 2x (uncommon)
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0122]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Linux Containers <containers@lists.linux-foundation.org> ,
	<linux-kernel@vger.kernel.org> , "Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH] userns: Remove UIDGID_STRICT_TYPE_CHECKS
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Removing UIDGID_STRICT_TYPE_CHECKS simplifies the code and always
generates a compile error if the uids and kuids or gids and kgids are
mixed by accident.  Now that the appropriate conversions have been
placed throughout the kernel there is no longer a need for a mode where
we don't detect them as compile errors.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/posix_acl.h |    3 ---
 include/linux/projid.h    |   15 ---------------
 include/linux/uidgid.h    |   22 ----------------------
 init/Kconfig              |   11 -----------
 4 files changed, 0 insertions(+), 51 deletions(-)

diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 7931efe71175..f0f7746b2359 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -39,9 +39,6 @@ struct posix_acl_entry {
 	union {
 		kuid_t		e_uid;
 		kgid_t		e_gid;
-#ifndef CONFIG_UIDGID_STRICT_TYPE_CHECKS
-		unsigned int	e_id;
-#endif
 	};
 };
 
diff --git a/include/linux/projid.h b/include/linux/projid.h
index 36517b95be5c..8c1f2c55226d 100644
--- a/include/linux/projid.h
+++ b/include/linux/projid.h
@@ -18,8 +18,6 @@ extern struct user_namespace init_user_ns;
 
 typedef __kernel_uid32_t projid_t;
 
-#ifdef CONFIG_UIDGID_STRICT_TYPE_CHECKS
-
 typedef struct {
 	projid_t val;
 } kprojid_t;
@@ -31,19 +29,6 @@ static inline projid_t __kprojid_val(kprojid_t projid)
 
 #define KPROJIDT_INIT(value) (kprojid_t){ value }
 
-#else
-
-typedef projid_t kprojid_t;
-
-static inline projid_t __kprojid_val(kprojid_t projid)
-{
-	return projid;
-}
-
-#define KPROJIDT_INIT(value) ((kprojid_t) value )
-
-#endif
-
 #define INVALID_PROJID KPROJIDT_INIT(-1)
 #define OVERFLOW_PROJID 65534
 
diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
index 8e522cbcef29..2d1f9b627f91 100644
--- a/include/linux/uidgid.h
+++ b/include/linux/uidgid.h
@@ -17,8 +17,6 @@
 struct user_namespace;
 extern struct user_namespace init_user_ns;
 
-#ifdef CONFIG_UIDGID_STRICT_TYPE_CHECKS
-
 typedef struct {
 	uid_t val;
 } kuid_t;
@@ -41,26 +39,6 @@ static inline gid_t __kgid_val(kgid_t gid)
 	return gid.val;
 }
 
-#else
-
-typedef uid_t kuid_t;
-typedef gid_t kgid_t;
-
-static inline uid_t __kuid_val(kuid_t uid)
-{
-	return uid;
-}
-
-static inline gid_t __kgid_val(kgid_t gid)
-{
-	return gid;
-}
-
-#define KUIDT_INIT(value) ((kuid_t) value )
-#define KGIDT_INIT(value) ((kgid_t) value )
-
-#endif
-
 #define GLOBAL_ROOT_UID KUIDT_INIT(0)
 #define GLOBAL_ROOT_GID KGIDT_INIT(0)
 
diff --git a/init/Kconfig b/init/Kconfig
index 3ecd8a1178f1..b40280b640cc 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1123,8 +1123,6 @@ config IPC_NS
 
 config USER_NS
 	bool "User namespace"
-	select UIDGID_STRICT_TYPE_CHECKS
-
 	default n
 	help
 	  This allows containers, i.e. vservers, to use user namespaces
@@ -1156,15 +1154,6 @@ config NET_NS
 
 endif # NAMESPACES
 
-config UIDGID_STRICT_TYPE_CHECKS
-	bool "Require conversions between uid/gids and their internal representation"
-	default n
-	help
-	 While the nececessary conversions are being added to all subsystems this option allows
-	 the code to continue to build for unconverted subsystems.
-
-	 Say Y here if you want the strict type checking enabled
-
 config SCHED_AUTOGROUP
 	bool "Automatic process group scheduling"
 	select EVENTFD
-- 
1.7.5.4

