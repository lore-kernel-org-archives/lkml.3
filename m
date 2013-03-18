Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3CRIkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:40:16 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:59517 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3CRIkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:40:13 -0400
Date: Mon, 18 Mar 2013 09:40:08 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@suse.de>,
        Robert Richter <rric@kernel.org>
Subject: Re: [RFC PATCH 0/3] Perf persistent events
Message-ID: <20130318084008.GA17959@gmail.com>
References: <1363352789-17991-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363352789-17991-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> From: Borislav Petkov <bp@suse.de>
> 
> Yeah,
> 
> here's a refresh of the persistent events deal, accessing those is much
> cleaner now. Here's how:
> 
> So kernel code initializes and enables the event at its convenience
> (during boot, whenever) and userspace goes and says:
> 
> 	sys_perf_event_open(pattr,...)
> 
> with pattr.persistent = 1. Userspace gets the persistent buffer file
> descriptor to read from. Without that, we get a normal perf file
> descriptor for the duration of the tracing.
> 
> This saves all the diddling of trying to hand down file descriptors
> through debugfs or whatever. Instead, current perf code simply can use
> it.
> 
> This is still RFC but things are starting to fall into place slowly. As 
> always, any and all comments/suggestions are welcome.

That definitely looks interesting and desirable. It would be nice to have 
more generic/flexible semantics by using the VFS for tracing context 
discovery.

That would allow 'stateful tracing', and not just in a kernel initiated 
fashion: we could basically do ftrace-alike tracing, into persistent, 
VFS-named buffers.

The question is, how are the individual buffers identified when and after 
they have been created? An option would be to use cgroups for that - 
cgroups already has its own VFS and syscall interfaces. But maybe some 
other, explicit interface is needed (eventfs).

All the usecases we talked about in the past would work fine that way:

 - the MCE events would show up as an already created set of buffers, 
   discoverable via the VFS interface.

 - user-space could generate more 'tracing/profiling contexts' runtime.

 - a boot tracer would activate via a boot option, and it would create a 
   tracing context - visible via the VFS interface.

 - modern RAS daemon replacing mcelog

If you make that work, via a new perf tool side as well that allows the 
creation of a tracing context (and a separate extraction as well), via 
modified 'perf trace' or a new subcommand, that would be an major, 
upstream-worthy perf feature IMO which would go way beyond the RAS usecase 
...

Such a feature would become a popular instrumentation tool pretty quickly.

Thanks,
	
	Ingo
