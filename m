Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaK1RTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 12:19:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbaK1RTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 12:19:10 -0500
Date: Fri, 28 Nov 2014 18:19:07 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] livepatch: do relocation when initializing the patch: was:
 Re: [PATCHv4 2/3] kernel: add support for live patching
Message-ID: <20141128171906.GF32376@dhcp128.suse.cz>
References: <1416935709-404-1-git-send-email-sjenning@redhat.com>
 <1416935709-404-3-git-send-email-sjenning@redhat.com>
 <20141128170735.GD32376@dhcp128.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141128170735.GD32376@dhcp128.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-28 18:07:37, Petr Mladek wrote:
> On Tue 2014-11-25 11:15:08, Seth Jennings wrote:
> > This commit introduces code for the live patching core.  It implements
> > an ftrace-based mechanism and kernel interface for doing live patching
> > of kernel and kernel module functions.

[...]

> > +static int klp_enable_object(struct module *pmod, struct klp_object *obj)
> > +{
> > +	struct klp_func *func;
> > +	int ret;
> > +
> 	if (WARN_ON(obj->state != KLP_DISABLED))
> 		return -EINVAL;
> 
> > +	if (WARN_ON(!obj->mod && obj->name))
> > +		return -EINVAL;
> > +
> > +	if (obj->relocs) {
> > +		ret = klp_write_object_relocations(pmod, obj);
> 
> I was curious why the relocation is here. I think that the motivation
> was to safe the call when handling comming modules.
> 
> IMHO, more clean solution would be to do this in klp_init_object().
> It will also cause removing the "pmod" parameter and this function
> will be more symmetric with klp_disable_object();
> 
> I was curious how it would work, so I prepared a patch. I will send
> it in separate mail.

The patch is below. Again, merge it into the original patch if you
agree with the idea, please.


>From ba3b08938b6f6f1a041af645ff43825f2ec1222f Mon Sep 17 00:00:00 2001
From: Petr Mladek <pmladek@suse.cz>
Date: Fri, 28 Nov 2014 15:57:23 +0100
Subject: [PATCH 2/2] livepatch: do relocation when initializing the patch

I think that the relocation is done in klp_enable_object() because
it safes the duplication in klp_module_notify_coming().

But I think that the relocation logically belongs to the init phase.
It will remove duplicate relocation if we allow repeated enable/disable
calls for the same patch. Also it removes the extra "pmod" parameter
from klp_enable_object() and makes it more symmetric with klp_disable_object().

This patch moves also the klp_find_object_module() to the init phase
where it belongs.

Finally, it moves some checks from callers to klp_write_object_relocation().
They must be there in each case. It makes the code easier when calling
from more locations.

Signed-off-by: Petr Mladek <pmladek@suse.cz>

---
 kernel/livepatch/core.c | 41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 9b1601729014..688a6b66e72f 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -204,6 +204,14 @@ static int klp_write_object_relocations(struct module *pmod,
 	int ret;
 	struct klp_reloc *reloc;
 
+	/* nope when the patched module has not been loaded yet */
+	if (obj->name && !obj->mod)
+		return 0;
+
+	/* be happy when there is nothing to do */
+	if (!obj->relocs)
+		return 0;
+
 	for (reloc = obj->relocs; reloc->name; reloc++) {
 		if (!obj->name) {
 			ret = klp_verify_vmlinux_symbol(reloc->name,
@@ -313,7 +321,7 @@ static int klp_disable_object(struct klp_object *obj)
 	return 0;
 }
 
-static int klp_enable_object(struct module *pmod, struct klp_object *obj)
+static int klp_enable_object(struct klp_object *obj)
 {
 	struct klp_func *func;
 	int ret;
@@ -322,12 +330,6 @@ static int klp_enable_object(struct module *pmod, struct klp_object *obj)
 	if (obj->name && !obj->mod)
 		return 0;
 
-	if (obj->relocs) {
-		ret = klp_write_object_relocations(pmod, obj);
-		if (ret)
-			goto unregister;
-	}
-
 	for (func = obj->funcs; func->old_name; func++) {
 		ret = klp_find_verify_func_addr(func, obj->name);
 		if (ret)
@@ -402,8 +404,7 @@ static int __klp_enable_patch(struct klp_patch *patch)
 	pr_notice("enabling patch '%s'\n", patch->mod->name);
 
 	for (obj = patch->objs; obj->funcs; obj++) {
-		klp_find_object_module(obj);
-		ret = klp_enable_object(patch->mod, obj);
+		ret = klp_enable_object(obj);
 		if (ret)
 			goto unregister;
 	}
@@ -445,10 +446,17 @@ static void klp_module_notify_coming(struct module *pmod,
 	pr_notice("applying patch '%s' to loading module '%s'\n",
 		  pmod->name, mod->name);
 	obj->mod = mod;
-	ret = klp_enable_object(pmod, obj);
+	ret = klp_write_object_relocations(pmod, obj);
 	if (ret)
-		pr_warn("failed to apply patch '%s' to module '%s' (%d)\n",
-			pmod->name, mod->name, ret);
+		goto err;
+
+	ret = klp_enable_object(obj);
+	if (!ret)
+		return;
+
+err:
+	pr_warn("failed to apply patch '%s' to module '%s' (%d)\n",
+		pmod->name, mod->name, ret);
 }
 
 static void klp_module_notify_going(struct module *pmod,
@@ -674,15 +682,18 @@ static int klp_init_objects(struct klp_patch *patch)
 		return -EINVAL;
 
 	for (obj = patch->objs; obj->funcs; obj++) {
-		/* obj->mod set by klp_object_module_get() */
 		obj->state = KLP_DISABLED;
+		klp_find_object_module(obj);
 
-		/* sysfs */
+		ret = klp_write_object_relocations(patch->mod, obj);
+		if (ret)
+			goto free;
+
+		/* sysfs stuff */
 		obj->kobj = kobject_create_and_add(obj->name, &patch->kobj);
 		if (!obj->kobj)
 			goto free;
 
-		/* init functions */
 		ret = klp_init_funcs(obj);
 		if (ret) {
 			kobject_put(obj->kobj);
-- 
1.8.5.2


