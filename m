Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbaEFMXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:23:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbaEFMXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:23:16 -0400
Date: Tue, 6 May 2014 07:23:02 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, David Lang <david@lang.hm>,
        Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140506122302.GC4125@treble.redhat.com>
References: <cover.1398958771.git.jpoimboe@redhat.com>
 <alpine.LRH.2.00.1405021504320.22053@twin.jikos.cz>
 <alpine.DEB.2.02.1405051633080.14881@nftneq.ynat.uz>
 <alpine.LNX.2.00.1405060147190.3969@pobox.suse.cz>
 <20140506073228.GA26271@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140506073228.GA26271@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 09:32:28AM +0200, Ingo Molnar wrote:
> 
> * Jiri Kosina <jkosina@suse.cz> wrote:
> 
> > On Mon, 5 May 2014, David Lang wrote:
> > 
> > > how would you know that all instances of the datastructure in memory 
> > > have= been touched? just because all tasks have run and are outside the 
> > > function in question doesn't tell you data structures have been 
> > > converted. You have n= o way of knowing when (or if) the next call to 
> > > the modified function will take place on any potential in-memory 
> > > structure.
> > 
> > The problem you are trying to avoid here is functions expecting to read 
> > "v2" format of the data from memory, while there are still tasks that are 
> > unpredictably writing "v1" format of the data to the memory.
> > 
> > There are several ways to attack this problem:
> > 
> > - stop the whole system, convert all the existing data structures to new 
> >   format (which might potentially be non-trivial, mostly because you 
> >   have to *know* where all the data structures have been allocated), apply 
> >   patch, resume operation [ksplice, probably kpatch in future]
> > - restrict the data format to be backwards compatible [to be done 
> >   manually during patch creation, currently what kGraft needs to do in 
> >   such case]
> > - have a proxy code which can read both "v1" and "v2" formats, and writes 
> >   back in the same format it has seen the data structure on input
> > - once all the *code* has been converted, it still has to understand "v1" 
> >   and "v2", but it can now start writing out "v2" format only [possible 
> >   with kGraft, not implemented in automated fashion]
> > 
> > Ideas are of course more than welcome.
> 
> So what I'm curious about, what is the actual 'in the field' distro 
> experience, about the type of live-patches that get pushed with 
> urgency?
> 
> My guess would be that the overwhelming majority of live-patches don't 
> change data structures - and hence the right initial model would be to 
> ensure (via tooling, and via review) that 'v1' and 'v2' data is 
> exactly the same.

Yes, in general we want to avoid data changes.  In practice, we expect
most patches to be small, localized security fixes, so it shouldn't be
an issue in most cases.

Currently the kpatch tooling detects any compile-time changes to static
data and refuses to build the patch module in that case.

But there's no way to programmatically detect changes to dynamic data.
Which is why the user always has to be very careful when selecting a
patch.

-- 
Josh
