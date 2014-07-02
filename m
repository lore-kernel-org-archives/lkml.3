Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbaGBQ3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:29:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbaGBQ3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:29:11 -0400
Date: Wed, 2 Jul 2014 11:28:35 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: kGraft to -next [was: 00/21 kGraft]
Message-ID: <20140702162835.GA11702@treble.redhat.com>
References: <1403694329-3064-1-git-send-email-jslaby@suse.cz>
 <53B3F556.7050002@suse.cz>
 <20140702123002.GA20071@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140702123002.GA20071@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 08:30:02AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jul 02, 2014 at 02:04:38PM +0200, Jiri Slaby wrote:
> > On 06/25/2014 01:05 PM, Jiri Slaby wrote:
> ...
> > > https://git.kernel.org/cgit/linux/kernel/git/jirislaby/kgraft.git/log/?h=kgraft
> > 
> > Stephen,
> > 
> > may I ask you to add the kGraft tree to -next?
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jirislaby/kgraft.git#kgraft
> 
> Do we have consensus on the approach?  I personally really don't like
> the fact that it's adding another aspect to kthread management which
> is difficult to get right and nearly impossible to verify
> automatically.
> 
> IIUC, there are three similar solutions.  What are the pros and cons
> of each?  Can we combine the different approaches?

Please don't forget about kpatch.  The most recent version was posted
here:

  https://lkml.org/lkml/2014/5/1/273

We've made a ton of improvements since then, so I'll probably post a new
patch set soon.

kpatch advantages:

* 100% self-contained in its own module [1]

* Doesn't rely on changing all the kthreads

* Patch is applied atomically using stop_machine(), so it's safer with
  respect to data semantic changes

* Patching atomically also makes it much easier to analyze a patch to
  determine whether it's safe for live patching

* Already supports many advanced features which kGraft is lacking:
  - patched functions can access non-exported symbols, e.g. static
    variables
  - safe unpatching
  - module patching (and deferred module patching)
  - atomic patch replacement
  - supports atomic load/unload user hook functions
  - proper duplicate symbol handling
  - address verification sanity checks
  - sophisticated user space tools for analyzing and converting source
    patches to binary patch modules
  - ability to properly deal with many special sections (__bug_table,
    .data..percpu, etc)

kpatch disadvantages:

* Can't yet patch functions which are always active (schedule(),
  sys_poll(), etc).  We're currently working on ways to overcome this
  limitation.  One way is to allow the user to skip the backtrace check
  for those patches which don't change data semantics (which, for
  security fixes, should be most patches).  We also have some other
  ideas brewing...

* stop_machine() latency.  We've found that stop_machine() is still
  pretty fast.  IIRC, we measured ~1ms on an idle system and ~40ms on a
  heavily loaded 16 CPU system.

* Currently we don't freeze kernel threads.  Instead we just put them to
  sleep.  We _could_ freeze them, but I think it needs more discussion.
  It's definitely not a cure-all because you still have to worry about
  user threads.

  With our current approach, when analyzing whether patches are safe to
  apply live, we assume that all kernel and user threads will be asleep.
  We make no assumptions that kernel threads will be frozen.  In general
  we avoid changing data and data semantics as much as possible, so it
  shouldn't matter in most cases.  Personally I haven't yet run into a
  case where freezing kernel threads would have made a patch become
  "safe".


[1] https://github.com/dynup/kpatch/blob/master/kmod/core/core.c

-- 
Josh
