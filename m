Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbaJUUTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:19:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529AbaJUUTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:19:35 -0400
Date: Tue, 21 Oct 2014 22:19:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, Seth Jennings <sjenning@redhat.com>
Subject: Re: [PATCH] kprobes: add kprobe_is_function_probed()
In-Reply-To: <20141021164328.GG3978@treble.redhat.com>
Message-ID: <alpine.LNX.2.00.1410212209560.22681@pobox.suse.cz>
References: <alpine.LNX.2.00.1410211744550.24255@pobox.suse.cz> <20141021164328.GG3978@treble.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014, Josh Poimboeuf wrote:

> > Add a function that allows external users (such as live patching 
> > mechanisms) to check whether a given function (identified by symbol name) 
> > has a kprobe installed in it.
> 
> Functions aren't uniquely identifiable by name.  Perhaps it should be
> something like kprobe_is_addr_range_probed()?

Hi Josh,

first, thanks a lot for the review.

This is a rather difficult call actually. I am of course aware of the fact 
that kernel fucntions can't be uniquely identified by name, but when 
thinking about this, one has to consider:

- ftrace primary userspace interface (set_ftrace_filter) is based on 
  function names
- kprobe tracer and uprobe trace primary userspace interface 
  (/sys/kernel/debug/tracing/kprobe_events and uprobe_events respectively)
  are primarily based on function names
- the number of conflicts is probably zero, or very close to zero. Try to 
  run this 

	cut -f3 -d' ' /proc/kallsyms | sort  | uniq -c

  So it's questionable whether all the back and forth name->address->name 
  translations all over the place are worth all the trouble.

  I do agree though that we should make it obvious that the lookup 
  interface works on symbol names only ... perhaps by adding '_by_name()' 
  or so?

> Should we refuse to patch a function which has a kprobe installed inside 
> it?  

I think warning about it is a good thing to do.

> Is there a race-free way to do that?

Do we need to be race-free here? If userspace is both instantiating new 
krpobe and initiating live kernel patching at the "same time", I don't 
think kernel should try to solve such race ... it's simply there by 
definition, depending on, for example, scheduling decisions.

Thanks,

-- 
Jiri Kosina
SUSE Labs
