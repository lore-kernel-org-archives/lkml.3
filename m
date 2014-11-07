Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaKGO5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:57:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbaKGO5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:57:14 -0500
Date: Fri, 7 Nov 2014 08:57:07 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
Message-ID: <20141107145707.GA2057@cerebellum.variantweb.net>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <alpine.LNX.2.00.1411061607250.29198@pobox.suse.cz>
 <20141106162049.GA14689@cerebellum.variantweb.net>
 <alpine.LNX.2.00.1411062312220.29198@pobox.suse.cz>
 <20141107125016.GB4071@treble.redhat.com>
 <alpine.LNX.2.00.1411071405170.29198@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1411071405170.29198@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 02:13:37PM +0100, Jiri Kosina wrote:
> On Fri, 7 Nov 2014, Josh Poimboeuf wrote:
> 
> > > Also, lpc_create_object(), lpc_create_func(), lpc_create_patch(), 
> > > lpc_create_objects(), lpc_create_funcs(), ... they all are pretty much 
> > > alike, and are asking for some kind of unification ... perhaps iterator 
> > > for generic structure initialization?
> > 
> > The allocation and initialization code is very simple and
> > straightforward.  I really don't see a problem there.
> 
> This really boils down to the question I had in previous mail, whether 
> three-level hierarchy (patch->object->funcs), which is why there is a lot 
> of very alike initialization code, is not a bit over-designed.

It might right now, but we coded ourselves into a corner a couple of
times in kpatch using optimal, but inflexible data structures and
sharing those data structures with the API.  This structure layout will
give us flexibility to make changes without having to gut everything.  I
see flexibility and modularity being important going forward as we are
both looking to extend the abilities.

Additionally it allows the sysfs directories to correlate to data
structures and we can use the kobject ref count to cleanly do object
cleanup (i.e.  kobject_put() with release handlers for each ktype).

As Josh said, we do have operations that apply to each level.  I think
your point is that we could do away with the object level, but we have
operations that happen on a per-object basis. lpc_enable_object() isn't
just a for loop for registering the functions with ftrace.  It also does
the dynamic relocations.  I'm sure we will find other things in the
future.  It is also nice to have a function that can be called from both
lpc_enable_patch() and lp_module_notify() to enable the object in a
common way.

Thanks,
Seth

> 
> > > I am not also really fully convinced that we need the 
> > > patch->object->funcs abstraction hierarchy (which also contributes to 
> > > the structure allocation being rather a spaghetti copy/paste code) ... 
> > > wouldn't patch->funcs be suffcient, with the "object" being made just 
> > > a property of the function, for example?
> > > 
> > > > Plus, I show that kernel/kgraft.c + kernel/kgraft_files.c is
> > > > 906+193=1099.  I'd say they are about the same size :)
> > > 
> > > Which is still seem to me to be a ratio worth thinking about improving 
> > > :)
> > 
> > Yes, this code doesn't have a consistency model, but it does have some
> > other non-kGraft things like dynamic relocations, 
> 
> BTW we need to put those into arch/x86/ as they are unfortunately not 
> generic. But more on this later independently.
> 
> > deferred module patching,
> 
> FWIW kgraft supports that as well.
> 
> > and a unified API.  There's really no point in comparing lines of code.
> 
> Oh, sure, I didn't mean that this is any kind of metrics that should be 
> taken too seriously at all. I was just expressing my surprise that 
> unification of the API would bring so much code that it makes the result 
> comparably sized to "the whole thing" :)
> 
> Thanks,
> 
> -- 
> Jiri Kosina
> SUSE Labs
