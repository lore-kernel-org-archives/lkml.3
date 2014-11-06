Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaKFQVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:21:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbaKFQU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:20:58 -0500
Date: Thu, 6 Nov 2014 10:20:49 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
Message-ID: <20141106162049.GA14689@cerebellum.variantweb.net>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <alpine.LNX.2.00.1411061607250.29198@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1411061607250.29198@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 04:11:37PM +0100, Jiri Kosina wrote:
> On Thu, 6 Nov 2014, Seth Jennings wrote:
> 
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
> 
> Thanks a lot for having started the work on this!
> 
> We will be reviewing it carefully in the coming days and will getting back 
> to you (I was surprised to see that that diffstat indicates that it's 
> actually more code than our whole kgraft implementation including the 
> consistency model :) ).

The structure allocation and sysfs stuff is a lot of (mundane) code.
Lots of boring error path handling too.

Plus, I show that kernel/kgraft.c + kernel/kgraft_files.c is
906+193=1099.  I'd say they are about the same size :)

> 
> I have one questions right away though.
> 
> > +/****************************************
> > + * dynamic relocations (load-time linker)
> > + ****************************************/
> > +
> > +/*
> > + * external symbols are located outside the parent object (where the parent
> > + * object is either vmlinux or the kmod being patched).
> > + */
> 
> I have no ideas what dynrela is, and quickly reading the source doesn't 
> really help too much.
> 
> Could you please provide some explanation / pointer to some documentation, 
> explaining what exactly it is, and why should it be part of the common 
> infrastructure?

Yes, I should explain it.

This is something that is currently only used in the kpatch approach.
It allows the patching core to do dynamic relocations on the new
function code, similar to what the kernel module linker does, but this
works for non-exported symbols as well.

This is so the patch module doesn't have to do a kallsyms lookup on
every non-exported symbol that the new functions use.

The fields of the dynrela structure are those of a normal ELF rela
entry, except for the "external" field, which conveys information about
where the core module should go looking for the symbol referenced in the
dynrela entry.

Josh was under the impression that Vojtech was ok with putting the
dynrela stuff in the core.  Is that not correct (misunderstanding)?

Thanks,
Seth

> 
> Thanks,
> 
> -- 
> Jiri Kosina
> SUSE Labs
