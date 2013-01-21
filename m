Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3AUD4J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 22:56:09 -0500
Received: from ozlabs.org ([203.10.76.45]:42590 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab3AUD4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 22:56:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, Prarit Bhargava <prarit@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [patch] module: potential deadlock in error path
In-Reply-To: <CA+55aFzEkSOWL13cX2xaYttPF5=Qpvya9Yapk-RC8KQ5=QJk+w@mail.gmail.com>
References: <20130118074309.GB31793@elgon.mountain> <87ip6rwcvz.fsf@rustcorp.com.au> <CA+55aFzEkSOWL13cX2xaYttPF5=Qpvya9Yapk-RC8KQ5=QJk+w@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 21 Jan 2013 14:22:56 +1030
Message-ID: <87vcarur8n.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sun, Jan 20, 2013 at 5:20 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> Dan Carpenter <dan.carpenter@oracle.com> writes:
>>> We take the lock twice if we hit this goto.
>>>
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>
>> Damn, just pushed that to Linus: should have read mail first.
>>
>> I've added this, thanks.
>
> I'm not pulling this. It seems stupid.
>
> Why isn't the fix just this (whitespace-damaged, cut-and-pasted)
> one-liner instead? I may be blind, but as far as I cal tell, there's
> exactly one single place we do that "giti ddebug_cleanup", and it
> wants to unlock the mutex, so we should just move the unlock down one
> line instead.
>
> Hmm? Is there some hidden magic going on that I can't see?

TBH, I find your change marginally less clear.

You've now conflated two completely different lock paths into a single
unlock.  mutex_bug_cleanup() should really lock internally, but doesn't
so we wrap it.  And that mutex_unlock of yours has nothing to do with
cleaning up ddebug, so the labels misnamed, at best.

> diff --git a/kernel/module.c b/kernel/module.c
> index d25e359279ae..eab08274ec9b 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3274,8 +3274,8 @@ again:
>         /* module_bug_cleanup needs module_mutex protection */
>         mutex_lock(&module_mutex);
>         module_bug_cleanup(mod);
> -       mutex_unlock(&module_mutex);
>   ddebug_cleanup:
> +       mutex_unlock(&module_mutex);
>         dynamic_debug_remove(info->debug);
>         synchronize_sched();
>         kfree(mod->args);

Not that it matters much: this is going to change for next merge window.
See below for freshly-minted patch (compiled, untested).

Nice to make module_bug_cleanup() lock internally but it's in bug.c,
and I've avoided making the module mutex non-static due to a history of
abuse...

Thanks,
Rusty.

module: clean up load_module a little more.

1fb9341ac34825aa40354e74d9a2c69df7d2c304 made our locking in
load_module more complicated: we grab the mutex once to insert the
module in the list, then again to upgrade it once it's formed.

Since the locking is self-contained, it's neater to do this in
separate functions.

diff --git a/kernel/module.c b/kernel/module.c
index 2b1d517..c0bc9b9 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3145,12 +3145,72 @@ static int may_init_module(void)
 	return 0;
 }
 
+/*
+ * We try to place it in the list now to make sure it's unique before
+ * we dedicate too many resources.  In particular, temporary percpu
+ * memory exhaustion.
+ */
+static int add_unformed_module(struct module *mod)
+{
+	int err;
+	struct module *old;
+
+	mod->state = MODULE_STATE_UNFORMED;
+
+again:
+	mutex_lock(&module_mutex);
+	if ((old = find_module_all(mod->name, true)) != NULL) {
+		if (old->state == MODULE_STATE_COMING
+		    || old->state == MODULE_STATE_UNFORMED) {
+			/* Wait in case it fails to load. */
+			mutex_unlock(&module_mutex);
+			err = wait_event_interruptible(module_wq,
+					       finished_loading(mod->name));
+			if (err)
+				goto out_unlocked;
+			goto again;
+		}
+		err = -EEXIST;
+		goto out;
+	}
+	list_add_rcu(&mod->list, &modules);
+	err = 0;
+
+out:
+	mutex_unlock(&module_mutex);
+out_unlocked:
+	return err;
+}
+
+static int complete_formation(struct module *mod, struct load_info *info)
+{
+	int err;
+
+	mutex_lock(&module_mutex);
+
+	/* Find duplicate symbols (must be called under lock). */
+	err = verify_export_symbols(mod);
+	if (err < 0)
+		goto out;
+
+	/* This relies on module_mutex for list integrity. */
+	module_bug_finalize(info->hdr, info->sechdrs, mod);
+
+	/* Mark state as coming so strong_try_module_get() ignores us,
+	 * but kallsyms etc. can see us. */
+	mod->state = MODULE_STATE_COMING;
+
+out:
+	mutex_unlock(&module_mutex);
+	return err;
+}
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static int load_module(struct load_info *info, const char __user *uargs,
 		       int flags)
 {
-	struct module *mod, *old;
+	struct module *mod;
 	long err;
 
 	err = module_sig_check(info);
@@ -3168,31 +3228,10 @@ static int load_module(struct load_info *info, const char __user *uargs,
 		goto free_copy;
 	}
 
-	/*
-	 * We try to place it in the list now to make sure it's unique
-	 * before we dedicate too many resources.  In particular,
-	 * temporary percpu memory exhaustion.
-	 */
-	mod->state = MODULE_STATE_UNFORMED;
-again:
-	mutex_lock(&module_mutex);
-	if ((old = find_module_all(mod->name, true)) != NULL) {
-		if (old->state == MODULE_STATE_COMING
-		    || old->state == MODULE_STATE_UNFORMED) {
-			/* Wait in case it fails to load. */
-			mutex_unlock(&module_mutex);
-			err = wait_event_interruptible(module_wq,
-					       finished_loading(mod->name));
-			if (err)
-				goto free_module;
-			goto again;
-		}
-		err = -EEXIST;
-		mutex_unlock(&module_mutex);
+	/* Reserve our place in the list. */
+	err = add_unformed_module(mod);
+	if (err)
 		goto free_module;
-	}
-	list_add_rcu(&mod->list, &modules);
-	mutex_unlock(&module_mutex);
 
 #ifdef CONFIG_MODULE_SIG
 	mod->sig_ok = info->sig_ok;
@@ -3245,22 +3284,10 @@ again:
 
 	dynamic_debug_setup(info->debug, info->num_debug);
 
-	mutex_lock(&module_mutex);
-	/* Find duplicate symbols (must be called under lock). */
-	err = verify_export_symbols(mod);
-	if (err < 0) {
-		mutex_unlock(&module_mutex);
+	/* Finally it's fully formed, ready to start executing. */
+	err = complete_formation(mod, info);
+	if (err)
 		goto ddebug_cleanup;
-	}
-
-	/* This relies on module_mutex for list integrity. */
-	module_bug_finalize(info->hdr, info->sechdrs, mod);
-
-	/* Mark state as coming so strong_try_module_get() ignores us,
-	 * but kallsyms etc. can see us. */
-	mod->state = MODULE_STATE_COMING;
-
-	mutex_unlock(&module_mutex);
 
 	/* Module is ready to execute: parsing args may do that. */
 	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp,
