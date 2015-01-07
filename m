Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbbAGXtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:49:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436AbbAGXtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:49:52 -0500
Date: Thu, 8 Jan 2015 00:49:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-next@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: livepatching tree for linux-next
In-Reply-To: <20150107153006.60ed354e3458f402e6819b9e@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1501080037030.15299@pobox.suse.cz>
References: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz> <20141223094607.GA16445@infradead.org> <20141223151056.GA4789@treble.redhat.com> <20141226155613.36dd95b9@canb.auug.org.au> <20150107144317.61ab2080877a4d8227990551@linux-foundation.org>
 <alpine.LNX.2.00.1501072346400.15299@pobox.suse.cz> <20150107153006.60ed354e3458f402e6819b9e@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, Andrew Morton wrote:

> Please find a way to fix it.  Copying CONFIG_CC_STACKPROTECTOR is one way.

Hmm ... is that actually really a good example? 

I think it will warn (explicitly from the top-level Makefile so that you 
are aware why the things that will follow are happening), and then let gcc 
fail the build due to unsupported option anyway ... because it will 
(deliberately, so that the build fails) keep the 'stackp-flag' set even 
for unsupported compiler options. No?

If we really don't want to be causing this though, how about the below 
instead?



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] livepatching: handle ancient compilers with more grace

We are aborting a build in case when gcc doesn't support fentry on x86_64 
(regs->ip modification can't really reliably work with mcount).

This however breaks allmodconfig for people with older gccs that don't 
support -mfentry.

Turn the build-time failure into runtime failure, resulting in the whole 
infrastructure not being initialized if CC_USING_FENTRY is unset.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 arch/x86/include/asm/livepatch.h | 6 +++++-
 kernel/livepatch/core.c          | 6 ++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
index b5608d7..fa7f448 100644
--- a/arch/x86/include/asm/livepatch.h
+++ b/arch/x86/include/asm/livepatch.h
@@ -25,9 +25,13 @@
 #include <linux/ftrace.h>
 
 #ifdef CONFIG_LIVE_PATCHING
+static inline int klp_check_compiler_support(void)
+{
 #ifndef CC_USING_FENTRY
-#error Your compiler must support -mfentry for live patching to work
+	        return 1;
 #endif
+	        return 0;
+}
 extern int klp_write_module_reloc(struct module *mod, unsigned long type,
 				  unsigned long loc, unsigned long value);
 
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 6f63879..ce42d3b 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -911,6 +911,12 @@ static int klp_init(void)
 {
 	int ret;
 
+	ret = klp_check_compiler_support();
+	if (ret) {
+		pr_info("Your compiler is too old; turning off.\n");
+		return -EINVAL;
+	}
+
 	ret = register_module_notifier(&klp_module_nb);
 	if (ret)
 		return ret;

-- 
Jiri Kosina
SUSE Labs
