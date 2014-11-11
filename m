Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaKKTkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:40:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbaKKTkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:40:16 -0500
Date: Tue, 11 Nov 2014 13:40:08 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: module notifier: was Re: [PATCH 2/2] kernel: add support for
 live patching
Message-ID: <20141111194008.GA9066@cerebellum.variantweb.net>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <20141107171307.GC1136@dhcp128.suse.cz>
 <20141107180711.GC2057@cerebellum.variantweb.net>
 <20141107184011.GF1136@dhcp128.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107184011.GF1136@dhcp128.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 07:40:11PM +0100, Petr Mladek wrote:
> On Fri 2014-11-07 12:07:11, Seth Jennings wrote:
> > On Fri, Nov 07, 2014 at 06:13:07PM +0100, Petr Mladek wrote:
> > > On Thu 2014-11-06 08:39:08, Seth Jennings wrote:
[...]
> > > > +	up(&lpc_mutex);
> > > > +	WARN("failed to apply patch '%s' to module '%s'\n",
> > > > +		patch->mod->name, mod->name);
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static struct notifier_block lp_module_nb = {
> > > > +	.notifier_call = lp_module_notify,
> > > > +	.priority = INT_MIN, /* called last */
> > > 
> > > The handler for MODULE_STATE_COMMING would need have higger priority,
> > > if we want to cleanly unregister the ftrace handlers.
> > 
> > Yes, we might need two handlers at different priorities if we decide to
> > go that direction: one for MODULE_STATE_GOING at high/max and one for
> > MODULE_STATE_COMING at low/min.
> 
> kGraft has notifier only for the going state. The initialization is
> called directly from load_module() after ftrace_module_init()
> and complete_formation() before it is executed by parse_args().
> 
> I need to investigate if the notifier is more elegant and safe or not.

I looked it up and having a COMING notifier with priority INT_MIN is
effectively the same as having a call between complete_formation() and
parse_args() since the notifiers are called as the last thing in
complete_formation().

I think I've found a clean way to avoid the ref taking on the patched
modules using only the notifier and lpc_mutex. It will be in v2
(hopefully out in the next couple of days).

Thanks,
Seth

> 
> Best Regards,
> Petr
