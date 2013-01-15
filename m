Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab3AOTJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:09:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab3AOTJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:09:20 -0500
Date: Tue, 15 Jan 2013 14:09:12 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com
Subject: [PATCH] MODSIGN: Add TAINT_NOKEY_MODULE
Message-ID: <20130115190911.GA6964@hansolo.jdub.homelinux.org>
References: <20130104191205.GD27554@hansolo.jdub.homelinux.org>
 <87bod14x44.fsf@rustcorp.com.au>
 <20130107145832.GA12363@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107145832.GA12363@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With module signing enabled but not in enforcing mode, we don't consider
unsigned modules to be an error.  However, if we encounter an unsigned
module we currently taint the module and kernel with TAINT_FORCED_MODULE.
That also disables lockdep within the kernel.

Given that we aren't in enforcing mode in this case, and we aren't
actually forcing the module to be loaded, that seems to be an incorrect
representation of what happened on module load.  This adds a new
TAINT_NOKEY_MODULE flag to be used in this case instead.  We also allow
lockdep to continue to work in this case, similar to the TAINT_OOT_MODULE
and TAINT_WARN cases.

Reported-by: Frank Ch. Eigler <fche@redhat.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 include/linux/kernel.h | 1 +
 kernel/module.c        | 4 +++-
 kernel/panic.c         | 3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index c566927..a2bbddb 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -427,6 +427,7 @@ extern enum system_states {
 #define TAINT_CRAP			10
 #define TAINT_FIRMWARE_WORKAROUND	11
 #define TAINT_OOT_MODULE		12
+#define TAINT_NOKEY_MODULE		13
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
diff --git a/kernel/module.c b/kernel/module.c
index 250092c..5dc9263 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1025,6 +1025,8 @@ static size_t module_flags_taint(struct module *mod, char *buf)
 		buf[l++] = 'F';
 	if (mod->taints & (1 << TAINT_CRAP))
 		buf[l++] = 'C';
+	if (mod->taints & (1 << TAINT_NOKEY_MODULE))
+		buf[l++] = 'K';
 	/*
 	 * TAINT_FORCED_RMMOD: could be added.
 	 * TAINT_UNSAFE_SMP, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
@@ -3116,7 +3118,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 #ifdef CONFIG_MODULE_SIG
 	mod->sig_ok = info->sig_ok;
 	if (!mod->sig_ok)
-		add_taint_module(mod, TAINT_FORCED_MODULE);
+		add_taint_module(mod, TAINT_NOKEY_MODULE);
 #endif
 
 	/* Now module is in final location, initialize linked lists, etc. */
diff --git a/kernel/panic.c b/kernel/panic.c
index e1b2822..e909abb 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -206,6 +206,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_CRAP,			'C', ' ' },
 	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
 	{ TAINT_OOT_MODULE,		'O', ' ' },
+	{ TAINT_NOKEY_MODULE,		'K', ' ' },
 };
 
 /**
@@ -224,6 +225,7 @@ static const struct tnt tnts[] = {
  *  'C' - modules from drivers/staging are loaded.
  *  'I' - Working around severe firmware bug.
  *  'O' - Out-of-tree module has been loaded.
+ *  'K' - Module with missing or unknown signature key has been loaded.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
@@ -273,6 +275,7 @@ void add_taint(unsigned flag)
 	case TAINT_OOT_MODULE:
 	case TAINT_WARN:
 	case TAINT_FIRMWARE_WORKAROUND:
+	case TAINT_NOKEY_MODULE:
 		break;
 
 	default:
-- 
1.8.0.2

