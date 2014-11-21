Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbaKUPBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:01:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758628AbaKUPB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:01:29 -0500
Date: Fri, 21 Nov 2014 09:00:41 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
Message-ID: <20141121150041.GA26264@treble.redhat.com>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com>
 <1416522580-5593-3-git-send-email-sjenning@redhat.com>
 <alpine.LNX.2.00.1411210102280.23174@pobox.suse.cz>
 <alpine.LNX.2.00.1411211542180.27891@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1411211542180.27891@pobox.suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 03:44:35PM +0100, Miroslav Benes wrote:
> On Fri, 21 Nov 2014, Jiri Kosina wrote:
> 
> [...]
> 
> > [ ... snip ... ]
> > > +static int klp_init_patch(struct klp_patch *patch)
> > > +{
> > > +	int ret;
> > > +
> > > +	mutex_lock(&klp_mutex);
> > > +
> > > +	/* init */
> > > +	patch->state = LPC_DISABLED;
> > > +
> > > +	/* sysfs */
> > > +	ret = kobject_init_and_add(&patch->kobj, &klp_ktype_patch,
> > > +				   klp_root_kobj, patch->mod->name);
> > > +	if (ret)
> > > +		return ret;
> > 
> > klp_mutex is leaked locked here.
> > 
> > > +
> > > +	/* create objects */
> > > +	ret = klp_init_objects(patch);
> > > +	if (ret) {
> > > +		kobject_put(&patch->kobj);
> > > +		return ret;
> > 
> > And here as well.
> > 
> > All in all, this is looking very good to me. I think we are really close 
> > to having a code that all the parties would agree with. Thanks everybody,
> 
> The leaking is my fault. I missed that somehow during rebasing.
> 
> Seth, could you please fix it in v4? 

Is it necessary to grab the mutex at the beginning of klp_init_patch?  I
think we only need it when adding it to the global list at the end of
the function.

-- 
Josh
