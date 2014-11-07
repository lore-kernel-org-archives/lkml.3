Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaKGPpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 10:45:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbaKGPpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 10:45:32 -0500
Date: Fri, 7 Nov 2014 09:45:00 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141107154500.GF4071@treble.redhat.com>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <20141106184446.GA12779@infradead.org>
 <20141106185157.GB29272@suse.cz>
 <20141106185857.GA7106@infradead.org>
 <20141106202423.GB2266@suse.cz>
 <20141107074745.GC22703@infradead.org>
 <20141107131153.GD4071@treble.redhat.com>
 <20141107140458.GA21774@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141107140458.GA21774@suse.cz>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 03:04:58PM +0100, Vojtech Pavlik wrote:
> On Fri, Nov 07, 2014 at 07:11:53AM -0600, Josh Poimboeuf wrote:
> 
> > 2. Add consistency model(s) (e.g. kpatch stop_machine, kGraft per-task
> >    consistency, Masami's per task ref counting)
> 
> I have given some thought to the consistency models and how they differ
> and how they potentially could be unified.
> 
> I have to thank Masami, because his rewrite of the kpatch model based on
> refcounting is what brought it closer to the kGraft model and thus
> allowed me to find the parallels.
> 
> Let me start by defining the properties of the patching consistency
> model. First, what entity the execution must be outside of to be able to
> make the switch, ordered from weakest to strongest:
> 
> 	LEAVE_FUNCTION
> 		- execution has to leave a patched function to switch
> 		  to the new implementation
> 
> 	LEAVE_PATCHED_SET
> 		- execution has to leave the set of patched functions
> 		  to switch to the new implementation
> 
> 	LEAVE_KERNEL
> 		- execution has to leave the entire kernel to switch
> 		  to the new implementation
> 
> Then, what entity the switch happens for. Again, from weakest to strongest:
> 
> 	SWITCH_FUNCTION
> 		- the switch to the new implementation happens on a per-function
> 		   basis
> 
> 	SWITCH_THREAD
> 		- the switch to the new implementation is per-thread.
> 
> 	SWITCH_KERNEL
> 		- the switch to the new implementation happens at once for
> 		  the whole kernel
> 
> Now with those definitions:
> 
> 	livepatch (null model), as is, is LEAVE_FUNCTION and SWITCH_FUNCTION
> 
> 	kpatch, masami-refcounting and Ksplice are LEAVE_PATCHED_SET and SWITCH_KERNEL
> 
> 	kGraft is LEAVE_KERNEL and SWITCH_THREAD
> 
> 	CRIU/kexec is LEAVE_KERNEL and SWITCH_KERNEL

Thanks, nice analysis!

> By blending kGraft and masami-refcounting, we could create a consistency
> engine capable of almost any combination of these properties and thus
> all the consistency models.

Can you elaborate on what this would look like?

> However, I'm currently thinking that the most interesting model is
> LEAVE_PATCHED_SET and SWITCH_THREAD, as it is reliable, fast converging,
> doesn't require annotating kernel threads nor fails with frequent
> sleepers like futexes. 
> 
> It provides the least consistency that is required to be able to change
> the calling convention of functions and still allows for semantic
> dependencies.
> 	
> What do you think?
> 

The big problem with SWITCH_THREAD is that it adds the possibility that
old functions can run simultaneously with new ones.  When you change
data or data semantics, which is roughly 10% of security patches, it
creates some serious headaches:

- It makes patch safety analysis much harder by doubling the number of
  permutations of scenarios you have to consider.  In addition to
  considering newfunc/olddata and newfunc/newdata, you also have to
  consider oldfunc/olddata and oldfunc/newdata.

- It requires two patches instead of one.  The first patch is needed to
  modify the old functions to be able to deal with new data.  After the
  first patch has been fully applied, then you apply the second patch
  which can start creating new versions of data.

On the other hand, SWITCH_KERNEL doesn't have those problems.  It does
have the problem you mentioned, roughly 2% of the time, where it can't
patch functions which are always in use.  But in that case we can skip
the backtrace check ~90% of the time.  So it's really maybe something
like 0.2% of patches which can't be patched with SWITCH_KERNEL.  But
even then I think we could overcome that by getting creative, e.g. using
the multiple patch approach.

So my perspective is that SWITCH_THREAD causes big headaches 10% of the
time, whereas SWITCH_KERNEL causes small headaches 1.8% of the time, and
big headaches 0.2% of the time :-)

> ----------------------------------------------------------------------------
> 
> PS.: Livepatch's null model isn't in fact the weakest possible, as it still
> guarantees executing complete intact functions, this thanks to ftrace.
> That is much more than what would direct overwriting of the function in
> memory achieve.
> 
> This is also the reason why Ksplice is locked to a very specific
> consistency model. Ksplice can patch only when the kernel is stopped and
> the model is built from that.
> 
> masami-refcounting, kpatch, kGraft, livepatch have a lot more freedom,
> thanks to ftrace, into what the consistency model should look like.
> 
> PPS.: I haven't included any handling of changed data structures in
> this, that's another set of properties.
> 
> -- 
> Vojtech Pavlik
> Director SUSE Labs

-- 
Josh
