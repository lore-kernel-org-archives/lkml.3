Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaJOGeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 02:34:04 -0400
Received: from ozlabs.org ([103.22.144.67]:53772 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbaJOGcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 02:32:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arjun Sreedharan <arjun024@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: krealloc in kernel/params.c
In-Reply-To: <87mw8y8jq7.fsf@rasmusvillemoes.dk>
References: <87mw8y8jq7.fsf@rasmusvillemoes.dk>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 15 Oct 2014 15:29:04 +1030
Message-ID: <87r3yaapyf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:
> It is likely that I'm just missing something trivial, but I have
> a hard time understanding 63662139e ("params: Fix potential
> memory leak in add_sysfs_param()").

Yes, it was a bad commit, and we've been discussing it, see:

[PATCH] params: fix potential memory leak in add_sysfs_param()

The only error case we are about is when add_sysfs_param()
is called from module_param_sysfs_setup(): the in-kernel cases
at boot time are assumed not to fail.

That call should invoke free_module_param_attrs() when it fails,
rather than relying on add_sysfs_param() to clean up.

Don't patch bad code - rewrite it.  (Kernigan and Plauger)

How's this?

params: cleanup sysfs allocation

commit 63662139e519ce06090b2759cf4a1d291b9cc0e2 attempted to patch a
leak (which would only happen on OOM, ie. never), but it didn't quite
work.

This rewrites the code to be as simple as possible.  add_sysfs_param()
adds a parameter.  If it fails, it's the caller's responsibility to
clean up the parameters which already exist.

The kzalloc-then-always-krealloc pattern is perhaps overly simplistic,
but this code has clearly confused people.  It worked on me...

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/params.c b/kernel/params.c
index db97b791390f..5b8005d01dfc 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -603,68 +603,58 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
 				     const struct kernel_param *kp,
 				     const char *name)
 {
-	struct module_param_attrs *new;
-	struct attribute **attrs;
-	int err, num;
+	struct module_param_attrs *new_mp;
+	struct attribute **new_attrs;
+	unsigned int i;
 
 	/* We don't bother calling this with invisible parameters. */
 	BUG_ON(!kp->perm);
 
 	if (!mk->mp) {
-		num = 0;
-		attrs = NULL;
-	} else {
-		num = mk->mp->num;
-		attrs = mk->mp->grp.attrs;
+		/* First allocation. */
+		mk->mp = kzalloc(sizeof(*mk->mp), GFP_KERNEL);
+		if (!mk->mp)
+			return -ENOMEM;
+		mk->mp->grp.name = "parameters";
+		/* NULL-terminated attribute array. */
+		mk->mp->grp.attrs = kzalloc(sizeof(mk->mp->grp.attrs[0]),
+					    GFP_KERNEL);
+		/* Caller will cleanup via free_module_param_attrs */
+		if (!mk->mp->grp.attrs)
+			return -ENOMEM;
 	}
 
-	/* Enlarge. */
-	new = krealloc(mk->mp,
-		       sizeof(*mk->mp) + sizeof(mk->mp->attrs[0]) * (num+1),
-		       GFP_KERNEL);
-	if (!new) {
-		kfree(attrs);
-		err = -ENOMEM;
-		goto fail;
-	}
-	/* Despite looking like the typical realloc() bug, this is safe.
-	 * We *want* the old 'attrs' to be freed either way, and we'll store
-	 * the new one in the success case. */
-	attrs = krealloc(attrs, sizeof(new->grp.attrs[0])*(num+2), GFP_KERNEL);
-	if (!attrs) {
-		err = -ENOMEM;
-		goto fail_free_new;
-	}
+	/* Enlarge allocations. */
+	new_mp = krealloc(mk->mp,
+			  sizeof(*mk->mp) +
+			  sizeof(mk->mp->attrs[0]) * (mk->mp->num + 1),
+			  GFP_KERNEL);
+	if (!new_mp)
+		return -ENOMEM;
+	mk->mp = new_mp;
 
-	/* Sysfs wants everything zeroed. */
-	memset(new, 0, sizeof(*new));
-	memset(&new->attrs[num], 0, sizeof(new->attrs[num]));
-	memset(&attrs[num], 0, sizeof(attrs[num]));
-	new->grp.name = "parameters";
-	new->grp.attrs = attrs;
+	/* Extra pointer for NULL terminator */
+	new_attrs = krealloc(mk->mp->grp.attrs,
+			     sizeof(mk->mp->grp.attrs[0]) * (mk->mp->num + 2),
+			     GFP_KERNEL);
+	if (!new_attrs)
+		return -ENOMEM;
+	mk->mp->grp.attrs = new_attrs;
 
 	/* Tack new one on the end. */
-	sysfs_attr_init(&new->attrs[num].mattr.attr);
-	new->attrs[num].param = kp;
-	new->attrs[num].mattr.show = param_attr_show;
-	new->attrs[num].mattr.store = param_attr_store;
-	new->attrs[num].mattr.attr.name = (char *)name;
-	new->attrs[num].mattr.attr.mode = kp->perm;
-	new->num = num+1;
+	sysfs_attr_init(&mk->mp->attrs[mk->mp->num].mattr.attr);
+	mk->mp->attrs[mk->mp->num].param = kp;
+	mk->mp->attrs[mk->mp->num].mattr.show = param_attr_show;
+	mk->mp->attrs[mk->mp->num].mattr.store = param_attr_store;
+	mk->mp->attrs[mk->mp->num].mattr.attr.name = (char *)name;
+	mk->mp->attrs[mk->mp->num].mattr.attr.mode = kp->perm;
+	mk->mp->num++;
 
 	/* Fix up all the pointers, since krealloc can move us */
-	for (num = 0; num < new->num; num++)
-		new->grp.attrs[num] = &new->attrs[num].mattr.attr;
-	new->grp.attrs[num] = NULL;
-
-	mk->mp = new;
+	for (i = 0; i < mk->mp->num; i++)
+		mk->mp->grp.attrs[i] = &mk->mp->attrs[i].mattr.attr;
+	mk->mp->grp.attrs[mk->mp->num] = NULL;
 	return 0;
-
-fail_free_new:
-	kfree(new);
-fail:
-	mk->mp = NULL;
-	return err;
 }
 
 #ifdef CONFIG_MODULES
@@ -695,8 +685,10 @@ int module_param_sysfs_setup(struct module *mod,
 		if (kparam[i].perm == 0)
 			continue;
 		err = add_sysfs_param(&mod->mkobj, &kparam[i], kparam[i].name);
-		if (err)
+		if (err) {
+			free_module_param_attrs(&mod->mkobj);
 			return err;
+		}
 		params = true;
 	}
 
