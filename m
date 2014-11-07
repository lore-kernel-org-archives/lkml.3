Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaKGRNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:13:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbaKGRNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:13:10 -0500
Date: Fri, 7 Nov 2014 18:13:07 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: module notifier: was Re: [PATCH 2/2] kernel: add support for live
 patching
Message-ID: <20141107171307.GC1136@dhcp128.suse.cz>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415284748-14648-3-git-send-email-sjenning@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-11-06 08:39:08, Seth Jennings wrote:
> This commit introduces code for the live patching core.  It implements
> an ftrace-based mechanism and kernel interface for doing live patching
> of kernel and kernel module functions.
> 
> It represents the greatest common functionality set between kpatch and
> kgraft and can accept patches built using either method.
> 
> This first version does not implement any consistency mechanism that
> ensures that old and new code do not run together.  In practice, ~90% of
> CVEs are safe to apply in this way, since they simply add a conditional
> check.  However, any function change that can not execute safely with
> the old version of the function can _not_ be safely applied in this
> version.

[...]
 
> +/******************************
> + * module notifier
> + *****************************/
> +
> +static int lp_module_notify(struct notifier_block *nb, unsigned long action,
> +			    void *data)
> +{
> +	struct module *mod = data;
> +	struct lpc_patch *patch;
> +	struct lpc_object *obj;
> +	int ret = 0;
> +
> +	if (action != MODULE_STATE_COMING)
> +		return 0;

IMHO, we should handle also MODULE_STATE_GOING. We should unregister
the ftrace handlers and update the state of the affected objects
(ENABLED -> DISABLED)

> +	down(&lpc_mutex);
> +
> +	list_for_each_entry(patch, &lpc_patches, list) {
> +		if (patch->state == DISABLED)
> +			continue;
> +		list_for_each_entry(obj, &patch->objs, list) {
> +			if (strcmp(obj->name, mod->name))
> +				continue;
> +			pr_notice("load of module '%s' detected, applying patch '%s'\n",
> +				  mod->name, patch->mod->name);
> +			obj->mod = mod;
> +			ret = lpc_enable_object(patch->mod, obj);
> +			if (ret)
> +				goto out;
> +			break;
> +		}
> +	}
> +
> +	up(&lpc_mutex);
> +	return 0;
> +out:

I would name this err_our or so to make it clear that it is used when
something fails.

> +	up(&lpc_mutex);
> +	WARN("failed to apply patch '%s' to module '%s'\n",
> +		patch->mod->name, mod->name);
> +	return 0;
> +}
> +
> +static struct notifier_block lp_module_nb = {
> +	.notifier_call = lp_module_notify,
> +	.priority = INT_MIN, /* called last */

The handler for MODULE_STATE_COMMING would need have higger priority,
if we want to cleanly unregister the ftrace handlers.

Best Regards,
Petr
