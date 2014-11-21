Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbaKUPq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:46:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758720AbaKUPq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:46:26 -0500
Date: Fri, 21 Nov 2014 16:46:32 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
In-Reply-To: <20141121150041.GA26264@treble.redhat.com>
Message-ID: <alpine.LNX.2.00.1411211637020.27891@pobox.suse.cz>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com> <1416522580-5593-3-git-send-email-sjenning@redhat.com> <alpine.LNX.2.00.1411210102280.23174@pobox.suse.cz> <alpine.LNX.2.00.1411211542180.27891@pobox.suse.cz>
 <20141121150041.GA26264@treble.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Josh Poimboeuf wrote:

> On Fri, Nov 21, 2014 at 03:44:35PM +0100, Miroslav Benes wrote:
> > On Fri, 21 Nov 2014, Jiri Kosina wrote:
> > 
> > [...]
> > 
> > > [ ... snip ... ]
> > > > +static int klp_init_patch(struct klp_patch *patch)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	mutex_lock(&klp_mutex);
> > > > +
> > > > +	/* init */
> > > > +	patch->state = LPC_DISABLED;
> > > > +
> > > > +	/* sysfs */
> > > > +	ret = kobject_init_and_add(&patch->kobj, &klp_ktype_patch,
> > > > +				   klp_root_kobj, patch->mod->name);
> > > > +	if (ret)
> > > > +		return ret;
> > > 
> > > klp_mutex is leaked locked here.
> > > 
> > > > +
> > > > +	/* create objects */
> > > > +	ret = klp_init_objects(patch);
> > > > +	if (ret) {
> > > > +		kobject_put(&patch->kobj);
> > > > +		return ret;
> > > 
> > > And here as well.
> > > 
> > > All in all, this is looking very good to me. I think we are really close 
> > > to having a code that all the parties would agree with. Thanks everybody,
> > 
> > The leaking is my fault. I missed that somehow during rebasing.
> > 
> > Seth, could you please fix it in v4? 
> 
> Is it necessary to grab the mutex at the beginning of klp_init_patch?  I
> think we only need it when adding it to the global list at the end of
> the function.

I think it's not necessary now after thinking about that. It could happen 
that init values could be written twice to some patch structure if 
klp_register_patch would be called twice. But it should not corrupt 
anything and adding to the global list is protected. However I think we 
should define what is protected by klp_mutex and comment it somewhere near 
the mutex definition (if only the klp_patches list is protected or 
something more (in the future)).

Mira
