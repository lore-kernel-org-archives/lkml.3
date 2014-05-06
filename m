Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbaEFMRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:17:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999AbaEFMR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:17:29 -0400
Date: Tue, 6 May 2014 07:17:14 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: David Lang <david@lang.hm>
Cc: Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140506121714.GB4125@treble.redhat.com>
References: <cover.1398958771.git.jpoimboe@redhat.com>
 <alpine.LRH.2.00.1405021504320.22053@twin.jikos.cz>
 <alpine.DEB.2.02.1405051633080.14881@nftneq.ynat.uz>
 <alpine.LNX.2.00.1405060147190.3969@pobox.suse.cz>
 <alpine.DEB.2.02.1405051856340.14881@nftneq.ynat.uz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405051856340.14881@nftneq.ynat.uz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 06:59:29PM -0700, David Lang wrote:
> On Tue, 6 May 2014, Jiri Kosina wrote:
> 
> >On Mon, 5 May 2014, David Lang wrote:
> >
> >>how would you know that all instances of the datastructure in memory
> >>have= been touched? just because all tasks have run and are outside the
> >>function in question doesn't tell you data structures have been
> >>converted. You have n= o way of knowing when (or if) the next call to
> >>the modified function will take place on any potential in-memory
> >>structure.
> >
> >The problem you are trying to avoid here is functions expecting to read
> >"v2" format of the data from memory, while there are still tasks that are
> >unpredictably writing "v1" format of the data to the memory.
> >
> >There are several ways to attack this problem:
> >
> >- stop the whole system, convert all the existing data structures to new
> > format (which might potentially be non-trivial, mostly because you
> > have to *know* where all the data structures have been allocated), apply
> > patch, resume operation [ksplice, probably kpatch in future]
> >- restrict the data format to be backwards compatible [to be done
> > manually during patch creation, currently what kGraft needs to do in
> > such case]
> >- have a proxy code which can read both "v1" and "v2" formats, and writes
> > back in the same format it has seen the data structure on input
> 
> doesn't this have the same problem of finding all the data?
> 
> >- once all the *code* has been converted, it still has to understand "v1"
> > and "v2", but it can now start writing out "v2" format only [possible
> > with kGraft, not implemented in automated fashion]
> 
> which is a varient of the second one in that all the data needs to be tagged
> with a version so that it can be converted.
> 
> I don't see that 'stop the world' ends up being much better for this.
> 
> it does avoid any possibility of v1 code reading v2 data, but it doesn't
> help in avoiding v2 code reading v1 data some time (potentially much) later.

In general we would avoid this type of situation, where data semantics
change.  If it's absolutely necessary, then it's up to the user to write
a hook function that will find all the data structures and convert them
at patch loading time.  If they can't write a function which does that
sufficiently and safely, then live patching isn't a good option.

-- 
Josh
