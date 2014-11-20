Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbaKTQta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:49:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757723AbaKTQt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:49:29 -0500
Date: Thu, 20 Nov 2014 10:48:51 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/3] kernel: add support for live patching
Message-ID: <20141120164851.GB13785@cerebellum.variantweb.net>
References: <1416187764-3341-1-git-send-email-sjenning@redhat.com>
 <1416187764-3341-3-git-send-email-sjenning@redhat.com>
 <20141120151954.GB3370@treble.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120151954.GB3370@treble.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 09:19:54AM -0600, Josh Poimboeuf wrote:
> On Sun, Nov 16, 2014 at 07:29:23PM -0600, Seth Jennings wrote:
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
> 
> I think we can get the mutex here instead of above so it doesn't block
> other module actions (and then you can also get rid of the "out" label).

Sure.

Thanks,
Seth

> 
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
> -- 
> Josh
> --
> To unsubscribe from this list: send the line "unsubscribe live-patching" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
