Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbaKSQGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:06:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334AbaKSQGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:06:18 -0500
Date: Wed, 19 Nov 2014 10:05:40 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/3] kernel: add support for live patching
Message-ID: <20141119160540.GA2058@cerebellum.variantweb.net>
References: <1416187764-3341-1-git-send-email-sjenning@redhat.com>
 <1416187764-3341-3-git-send-email-sjenning@redhat.com>
 <alpine.LNX.2.00.1411191615000.5471@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1411191615000.5471@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 04:27:39PM +0100, Miroslav Benes wrote:
> 
> Hi,
> 
> during rewriting our code I came across few more things. See below.
> 
> On Sun, 16 Nov 2014, Seth Jennings wrote:
> 
> [...]
> 
> > +/******************************
> > + * module notifier
> > + *****************************/
> > +
> > +static void lpc_module_notify_coming(struct module *pmod,
> > +				     struct lpc_object *obj)
> > +{
> > +	struct module *mod = obj->mod;
> > +	int ret;
> > +
> > +	pr_notice("applying patch '%s' to loading module '%s'\n",
> > +		  mod->name, pmod->name);
> 
> This looks strange. I guess the arguments should be swapped.

Indeed, you are correct :)

> 
> > +	obj->mod = mod;
> 
> And this is redundant.

True again!

> 
> > +	ret = lpc_enable_object(pmod, obj);
> > +	if (ret)
> > +		pr_warn("failed to apply patch '%s' to module '%s' (%d)\n",
> > +			pmod->name, mod->name, ret);
> > +}
> > +
> > +static void lpc_module_notify_going(struct module *pmod,
> > +				    struct lpc_object *obj)
> > +{
> > +	struct module *mod = obj->mod;
> > +	int ret;
> > +
> > +	pr_notice("reverting patch '%s' on unloading module '%s'\n",
> > +		  pmod->name, mod->name);
> > +	ret = lpc_disable_object(obj);
> > +	if (ret)
> > +		pr_warn("failed to revert patch '%s' on module '%s' (%d)\n",
> > +			pmod->name, mod->name, ret);
> > +	obj->mod = NULL;
> > +}
> > +
> > +static int lpc_module_notify(struct notifier_block *nb, unsigned long action,
> > +			    void *data)
> > +{
> > +	struct module *mod = data;
> > +	struct lpc_patch *patch;
> > +	struct lpc_object *obj;
> > +
> > +	mutex_lock(&lpc_mutex);
> > +
> > +	if (action != MODULE_STATE_COMING && action != MODULE_STATE_GOING)
> > +		goto out;
> > +
> > +	list_for_each_entry(patch, &lpc_patches, list) {
> > +		if (patch->state == LPC_DISABLED)
> > +			continue;
> > +		list_for_each_entry(obj, &patch->objs, list) {
> > +			if (strcmp(obj->name, mod->name))
> > +				continue;
> > +			if (action == MODULE_STATE_COMING) {
> > +				obj->mod = mod;
> > +				lpc_module_notify_coming(patch->mod, obj);
> > +			} else /* MODULE_STATE_GOING */
> > +				lpc_module_notify_going(patch->mod, obj);
> > +			break;
> > +		}
> > +	}
> > +out:
> > +	mutex_unlock(&lpc_mutex);
> > +	return 0;
> > +}
> 
> [...]
> 
> > +static struct lpc_object *lpc_create_object(struct kobject *root,
> > +					    struct lp_object *userobj)
> > +{
> > +	struct lpc_object *obj;
> > +	int ret;
> > +
> > +	/* alloc */
> > +	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
> > +	if (!obj)
> > +		return NULL;
> > +
> > +	/* init */
> > +	INIT_LIST_HEAD(&obj->list);
> > +	obj->name = userobj->name;
> > +	obj->relocs = userobj->relocs;
> > +	obj->state = LPC_DISABLED;
> > +	/* obj->mod set by lpc_object_module_get() */
> > +	INIT_LIST_HEAD(&obj->funcs);
> 
> There is nothing like lpc_object_module_get() in the code. Did you mean 
> lpc_find_object_module()?

Yes, this comment should be removed or updated.

Thanks,
Seth

> 
> Thank you,
> --
> Miroslav Benes
> SUSE Labs
