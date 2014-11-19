Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaKSP1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:27:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbaKSP1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:27:35 -0500
Date: Wed, 19 Nov 2014 16:27:39 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/3] kernel: add support for live patching
In-Reply-To: <1416187764-3341-3-git-send-email-sjenning@redhat.com>
Message-ID: <alpine.LNX.2.00.1411191615000.5471@pobox.suse.cz>
References: <1416187764-3341-1-git-send-email-sjenning@redhat.com> <1416187764-3341-3-git-send-email-sjenning@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

during rewriting our code I came across few more things. See below.

On Sun, 16 Nov 2014, Seth Jennings wrote:

[...]

> +/******************************
> + * module notifier
> + *****************************/
> +
> +static void lpc_module_notify_coming(struct module *pmod,
> +				     struct lpc_object *obj)
> +{
> +	struct module *mod = obj->mod;
> +	int ret;
> +
> +	pr_notice("applying patch '%s' to loading module '%s'\n",
> +		  mod->name, pmod->name);

This looks strange. I guess the arguments should be swapped.

> +	obj->mod = mod;

And this is redundant.

> +	ret = lpc_enable_object(pmod, obj);
> +	if (ret)
> +		pr_warn("failed to apply patch '%s' to module '%s' (%d)\n",
> +			pmod->name, mod->name, ret);
> +}
> +
> +static void lpc_module_notify_going(struct module *pmod,
> +				    struct lpc_object *obj)
> +{
> +	struct module *mod = obj->mod;
> +	int ret;
> +
> +	pr_notice("reverting patch '%s' on unloading module '%s'\n",
> +		  pmod->name, mod->name);
> +	ret = lpc_disable_object(obj);
> +	if (ret)
> +		pr_warn("failed to revert patch '%s' on module '%s' (%d)\n",
> +			pmod->name, mod->name, ret);
> +	obj->mod = NULL;
> +}
> +
> +static int lpc_module_notify(struct notifier_block *nb, unsigned long action,
> +			    void *data)
> +{
> +	struct module *mod = data;
> +	struct lpc_patch *patch;
> +	struct lpc_object *obj;
> +
> +	mutex_lock(&lpc_mutex);
> +
> +	if (action != MODULE_STATE_COMING && action != MODULE_STATE_GOING)
> +		goto out;
> +
> +	list_for_each_entry(patch, &lpc_patches, list) {
> +		if (patch->state == LPC_DISABLED)
> +			continue;
> +		list_for_each_entry(obj, &patch->objs, list) {
> +			if (strcmp(obj->name, mod->name))
> +				continue;
> +			if (action == MODULE_STATE_COMING) {
> +				obj->mod = mod;
> +				lpc_module_notify_coming(patch->mod, obj);
> +			} else /* MODULE_STATE_GOING */
> +				lpc_module_notify_going(patch->mod, obj);
> +			break;
> +		}
> +	}
> +out:
> +	mutex_unlock(&lpc_mutex);
> +	return 0;
> +}

[...]

> +static struct lpc_object *lpc_create_object(struct kobject *root,
> +					    struct lp_object *userobj)
> +{
> +	struct lpc_object *obj;
> +	int ret;
> +
> +	/* alloc */
> +	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
> +	if (!obj)
> +		return NULL;
> +
> +	/* init */
> +	INIT_LIST_HEAD(&obj->list);
> +	obj->name = userobj->name;
> +	obj->relocs = userobj->relocs;
> +	obj->state = LPC_DISABLED;
> +	/* obj->mod set by lpc_object_module_get() */
> +	INIT_LIST_HEAD(&obj->funcs);

There is nothing like lpc_object_module_get() in the code. Did you mean 
lpc_find_object_module()?

Thank you,
--
Miroslav Benes
SUSE Labs
