Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbaKUQNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:13:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473AbaKUQNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:13:45 -0500
Date: Fri, 21 Nov 2014 10:13:08 -0600
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
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
Message-ID: <20141121161308.GA11339@cerebellum.variantweb.net>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com>
 <1416522580-5593-3-git-send-email-sjenning@redhat.com>
 <alpine.LNX.2.00.1411210102280.23174@pobox.suse.cz>
 <alpine.LNX.2.00.1411211542180.27891@pobox.suse.cz>
 <20141121150041.GA26264@treble.redhat.com>
 <alpine.LNX.2.00.1411211637020.27891@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1411211637020.27891@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 04:46:32PM +0100, Miroslav Benes wrote:
> On Fri, 21 Nov 2014, Josh Poimboeuf wrote:
> 
> > On Fri, Nov 21, 2014 at 03:44:35PM +0100, Miroslav Benes wrote:
> > > On Fri, 21 Nov 2014, Jiri Kosina wrote:
> > > 
> > > [...]
> > > 
> > > > [ ... snip ... ]
> > > > > +static int klp_init_patch(struct klp_patch *patch)
> > > > > +{
> > > > > +	int ret;
> > > > > +
> > > > > +	mutex_lock(&klp_mutex);
> > > > > +
> > > > > +	/* init */
> > > > > +	patch->state = LPC_DISABLED;
> > > > > +
> > > > > +	/* sysfs */
> > > > > +	ret = kobject_init_and_add(&patch->kobj, &klp_ktype_patch,
> > > > > +				   klp_root_kobj, patch->mod->name);
> > > > > +	if (ret)
> > > > > +		return ret;
> > > > 
> > > > klp_mutex is leaked locked here.
> > > > 
> > > > > +
> > > > > +	/* create objects */
> > > > > +	ret = klp_init_objects(patch);
> > > > > +	if (ret) {
> > > > > +		kobject_put(&patch->kobj);
> > > > > +		return ret;
> > > > 
> > > > And here as well.
> > > > 
> > > > All in all, this is looking very good to me. I think we are really close 
> > > > to having a code that all the parties would agree with. Thanks everybody,
> > > 
> > > The leaking is my fault. I missed that somehow during rebasing.
> > > 
> > > Seth, could you please fix it in v4? 
> > 
> > Is it necessary to grab the mutex at the beginning of klp_init_patch?  I
> > think we only need it when adding it to the global list at the end of
> > the function.
> 
> I think it's not necessary now after thinking about that. It could happen 
> that init values could be written twice to some patch structure if 
> klp_register_patch would be called twice. But it should not corrupt 
> anything and adding to the global list is protected. However I think we 
> should define what is protected by klp_mutex and comment it somewhere near 
> the mutex definition (if only the klp_patches list is protected or 
> something more (in the future)).

I'll fix it up for v4, moving the mutex just around the list_add() and
adding a comment about what is protected by the mutex.

Seth

> 
> Mira
> --
> To unsubscribe from this list: send the line "unsubscribe live-patching" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
