Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaKGOFC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:05:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbaKGOFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:05:01 -0500
Date: Fri, 7 Nov 2014 15:04:58 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141107140458.GA21774@suse.cz>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <20141106184446.GA12779@infradead.org>
 <20141106185157.GB29272@suse.cz>
 <20141106185857.GA7106@infradead.org>
 <20141106202423.GB2266@suse.cz>
 <20141107074745.GC22703@infradead.org>
 <20141107131153.GD4071@treble.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107131153.GD4071@treble.redhat.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 07:11:53AM -0600, Josh Poimboeuf wrote:

> 2. Add consistency model(s) (e.g. kpatch stop_machine, kGraft per-task
>    consistency, Masami's per task ref counting)

I have given some thought to the consistency models and how they differ
and how they potentially could be unified.

I have to thank Masami, because his rewrite of the kpatch model based on
refcounting is what brought it closer to the kGraft model and thus
allowed me to find the parallels.

Let me start by defining the properties of the patching consistency
model. First, what entity the execution must be outside of to be able to
make the switch, ordered from weakest to strongest:

	LEAVE_FUNCTION
		- execution has to leave a patched function to switch
		  to the new implementation

	LEAVE_PATCHED_SET
		- execution has to leave the set of patched functions
		  to switch to the new implementation

	LEAVE_KERNEL
		- execution has to leave the entire kernel to switch
		  to the new implementation

Then, what entity the switch happens for. Again, from weakest to strongest:

	SWITCH_FUNCTION
		- the switch to the new implementation happens on a per-function
		   basis

	SWITCH_THREAD
		- the switch to the new implementation is per-thread.

	SWITCH_KERNEL
		- the switch to the new implementation happens at once for
		  the whole kernel

Now with those definitions:

	livepatch (null model), as is, is LEAVE_FUNCTION and SWITCH_FUNCTION

	kpatch, masami-refcounting and Ksplice are LEAVE_PATCHED_SET and SWITCH_KERNEL

	kGraft is LEAVE_KERNEL and SWITCH_THREAD

	CRIU/kexec is LEAVE_KERNEL and SWITCH_KERNEL

By blending kGraft and masami-refcounting, we could create a consistency
engine capable of almost any combination of these properties and thus
all the consistency models.

However, I'm currently thinking that the most interesting model is
LEAVE_PATCHED_SET and SWITCH_THREAD, as it is reliable, fast converging,
doesn't require annotating kernel threads nor fails with frequent
sleepers like futexes. 

It provides the least consistency that is required to be able to change
the calling convention of functions and still allows for semantic
dependencies.
	
What do you think?

----------------------------------------------------------------------------

PS.: Livepatch's null model isn't in fact the weakest possible, as it still
guarantees executing complete intact functions, this thanks to ftrace.
That is much more than what would direct overwriting of the function in
memory achieve.

This is also the reason why Ksplice is locked to a very specific
consistency model. Ksplice can patch only when the kernel is stopped and
the model is built from that.

masami-refcounting, kpatch, kGraft, livepatch have a lot more freedom,
thanks to ftrace, into what the consistency model should look like.

PPS.: I haven't included any handling of changed data structures in
this, that's another set of properties.

-- 
Vojtech Pavlik
Director SUSE Labs
