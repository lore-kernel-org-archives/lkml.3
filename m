Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbaGOTvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:51:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933003AbaGOTvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:51:10 -0400
Date: Tue, 15 Jul 2014 14:50:56 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Xypron <xypron.debian@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Seth Jennings <sjenning@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, kpatch@redhat.com
Subject: Re: [PATCH v2 0/2] kpatch: dynamic kernel patching
Message-ID: <20140715195056.GB3788@treble.redhat.com>
References: <cover.1405374204.git.jpoimboe@redhat.com>
 <53C5653E.8060102@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53C5653E.8060102@gmx.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 07:30:38PM +0200, Xypron wrote:
> Hello Josh,
> 
> being able to patch a live kernel is very interesting feature. I looked
> through you patch and some questions remained:
> 
> In Documentation/kpatch.txt I found no description on how an out of kernel
> program uses the new code.
> See https://lkml.org/lkml/2014/7/14/862

You're right, these interfaces aren't documented very well.  Currently
the only user of these interfaces is the kpatch-build tool in our github
repository.  It builds kernel patch modules which call kpatch_register()
and kpatch_unregister().

The interfaces are quite complex.  They require an intelligent
generation tool to create a kernel module which uses them.  This is by
necessity, in order to allow dynamic relocations so that patched
functions can access unexported kernel symbols.

So I really wonder if it even makes sense to document them.  Instead
maybe we should also try to put the kpatch-build tool in the Linux
kernel tree in tools/kpatch.  Then we would just need to document the
use of the kpatch-build tool.

> Please, create man pages for kpatch_register and kpatch_unregister before
> moving kpatch into the kernel (if these are the relevant API calls).

I don't think kernel man pages would be appropriate because these
interfaces aren't system calls.  They're meant to be called by kernel
modules.

> I saw some x86 specific code in
> https://github.com/dynup/kpatch/tree/master/kpatch-build/insn/asm
> How does your code apply to other architectures?

Right now only x86_64 is supported, as it's the only architecture which
has the ftrace features we need.  But we do hope to add support for more
architectures, probably at least powerpc and s390.

> For me the man pages on
> https://github.com/dynup/kpatch/
> do not yet include all information that a novice user of kpatch would like
> to receive.

The end user just needs to know how to use the kpatch-build and kpatch
tools.  We already have man pages for those.  

> The man pages do not match the format of the other kernel man pages.

Hm, why do they need to match the format of kernel man pages?  They're
user space tools.

> The man pages are not linked to each other nor to Documentation/kpatch.txt.

True, but it hasn't been merged yet :-)  But yes, the kpatch-build and
kpatch man pages should probably refer to each other (and to any future
kernel documentation).

> What is the overall status of the complete kpatch solution? Is is still
> beta?

I would say it's still in an experimental phase.  But very close to
being used more extensively by real users.

> Should the kpatch and kpatch-build scripts be distributed with the kernel?
> Or what are your plans?

The more I think about it, the more it makes sense to put kpatch-build
in the kernel tree, because of the tight dependencies between it and the
kpatch core module.

I'm not quite sure whether the kpatch script, which manages the patch
modules after they have been built (e.g. loading/unloading, replacing,
installing to initramfs), belongs in the kernel tree because it's much
less loosely coupled to the kernel interfaces.

> 
> Best regards
> 
> Heinrich Schuchardt

-- 
Josh
