Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaKGTwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:52:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaKGTwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:52:40 -0500
Date: Fri, 7 Nov 2014 13:52:33 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
Message-ID: <20141107195233.GF2057@cerebellum.variantweb.net>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <545D2036.9080205@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545D2036.9080205@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 11:40:38AM -0800, Andy Lutomirski wrote:
> On 11/06/2014 06:39 AM, Seth Jennings wrote:
> > This commit introduces code for the live patching core.  It implements
> > an ftrace-based mechanism and kernel interface for doing live patching
> > of kernel and kernel module functions.
> > 
> > It represents the greatest common functionality set between kpatch and
> > kgraft and can accept patches built using either method.
> > 
> > This first version does not implement any consistency mechanism that
> > ensures that old and new code do not run together.  In practice, ~90% of
> > CVEs are safe to apply in this way, since they simply add a conditional
> > check.  However, any function change that can not execute safely with
> > the old version of the function can _not_ be safely applied in this
> > version.
> > 
> 
> [...]
> 
> > +/********************************************
> > + * Sysfs Interface
> > + *******************************************/
> > +/*
> > + * /sys/kernel/livepatch
> > + * /sys/kernel/livepatch/<patch>
> > + * /sys/kernel/livepatch/<patch>/enabled
> > + * /sys/kernel/livepatch/<patch>/<object>
> > + * /sys/kernel/livepatch/<patch>/<object>/<func>
> > + * /sys/kernel/livepatch/<patch>/<object>/<func>/new_addr
> > + * /sys/kernel/livepatch/<patch>/<object>/<func>/old_addr
> > + */
> 
> Letting anyone read new_addr and old_addr is a kASLR leak, and I would
> argue that showing this information to non-root at all is probably a bad
> idea.

Also worth noting that this live patching implementation currently
doesn't support kASLR, as there is a method for the patch module to
supply the old_addr, determined at generation time by pulling from
vmlinux/System.map/etc, for a particular function to resolve symbol
ambiguity in a kallsyms lookup.  Obviously, this old_addr would be wrong
for a kernel using kASLR.

Thanks,
Seth

> 
> Can you make new_addr and old_addr have mode 0600 and
> /sys/kernel/livepatch itself have mode 0500?  For the latter, an admin
> who wants unprivileged users to be able to see it can easily chmod it.
> 
> --Andy
> --
> To unsubscribe from this list: send the line "unsubscribe live-patching" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
