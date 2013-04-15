Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3DODu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 23:50:26 -0400
Received: from ozlabs.org ([203.10.76.45]:59181 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933Ab3DODuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 23:50:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, bhelgaas@google.com
Subject: Re: [PATCH] module: add kset_obj_exists() and use it
In-Reply-To: <20130411095537.GC21320@redhat.com>
References: <1365506529-8396-1-git-send-email-vfalico@redhat.com> <87y5cq6ei9.fsf@rustcorp.com.au> <20130411095537.GC21320@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 15 Apr 2013 11:56:03 +0930
Message-ID: <87vc7o8r7o.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Veaceslav Falico <vfalico@redhat.com> writes:
> On Wed, Apr 10, 2013 at 04:47:34PM +0930, Rusty Russell wrote:
>>That's a bug.  We should be cleaning up sysfs before we unlike the
>>removed module from the list.
>>
>>Because the same thing applies to ddebug info, which is also keyed by
>>module name.
>>
>>Something like this (untested!):
>
> Sorry for the late response - I wanted to test it for a longer time.
>
> Your patch works flawlessly and fixes this race, with just a small
> addition, cause otherwise we could BUG() in show_initstate().
>
> Can you apply this patch or should I (re-)send it somehow?
>
> Thank you!
>
> diff --git a/kernel/module.c b/kernel/module.c
> index d0afe23..8be6e97 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1063,6 +1063,9 @@ static ssize_t show_initstate(struct module_attribute *mattr,
>   	case MODULE_STATE_GOING:
>   		state = "going";
>   		break;
> +	case MODULE_STATE_UNFORMED:
> +		state = "unformed";
> +		break;
>   	default:
>   		BUG();
>   	}

Prefer to remove from sysfs before marking it unformed, like so:

diff --git a/kernel/module.c b/kernel/module.c
index 2468fda..2e7189f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1862,12 +1862,12 @@ static void free_module(struct module *mod)
 {
 	trace_module_free(mod);
 
-	/* We leave it in list to prevent duplicate loads while we clean
-	 * up sysfs, ddebug and any other external exposure. */
-	mod->state = MODULE_STATE_UNFORMED;
-
 	mod_sysfs_teardown(mod);
 
+	/* We leave it in list to prevent duplicate loads, but make sure
+	 * that noone uses it while it's being deconstructed. */
+	mod->state = MODULE_STATE_UNFORMED;
+
 	/* Remove dynamic debug info */
 	ddebug_remove_module(mod->name);
 
Here's the updated total patch:

diff --git a/kernel/module.c b/kernel/module.c
index 69d2600..2e7189f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1862,12 +1862,12 @@ static void free_module(struct module *mod)
 {
 	trace_module_free(mod);
 
-	/* Delete from various lists */
-	mutex_lock(&module_mutex);
-	stop_machine(__unlink_module, mod, NULL);
-	mutex_unlock(&module_mutex);
 	mod_sysfs_teardown(mod);
 
+	/* We leave it in list to prevent duplicate loads, but make sure
+	 * that noone uses it while it's being deconstructed. */
+	mod->state = MODULE_STATE_UNFORMED;
+
 	/* Remove dynamic debug info */
 	ddebug_remove_module(mod->name);
 
@@ -1880,6 +1880,11 @@ static void free_module(struct module *mod)
 	/* Free any allocated parameters. */
 	destroy_params(mod->kp, mod->num_kp);
 
+	/* Now we can delete it from the lists */
+	mutex_lock(&module_mutex);
+	stop_machine(__unlink_module, mod, NULL);
+	mutex_unlock(&module_mutex);
+
 	/* This may be NULL, but that's OK */
 	unset_module_init_ro_nx(mod);
 	module_free(mod, mod->module_init);

Thanks,
Rusty.
