Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbaHHGkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 02:40:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:50213 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbaHHGkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 02:40:36 -0400
Date: Fri, 8 Aug 2014 08:40:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140808064020.GZ9918@twins.programming.kicks-ass.net>
References: <20140806224518.GA8101@linux.vnet.ibm.com>
 <20140807084544.GJ19379@twins.programming.kicks-ass.net>
 <20140807150031.GB5821@linux.vnet.ibm.com>
 <20140807152600.GW9918@twins.programming.kicks-ass.net>
 <20140807172753.GG3588@twins.programming.kicks-ass.net>
 <20140807184635.GI3588@twins.programming.kicks-ass.net>
 <20140807154907.6f59cf6e@gandalf.local.home>
 <20140807155326.18481e66@gandalf.local.home>
 <20140807200813.GB3935@laptop>
 <20140807171823.1a481290@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QnlujARF9SsTF3UX"
Content-Disposition: inline
In-Reply-To: <20140807171823.1a481290@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QnlujARF9SsTF3UX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 05:18:23PM -0400, Steven Rostedt wrote:
> On Thu, 7 Aug 2014 22:08:13 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> > OK, you've got to start over and start at the beginning, because I'm
> > really not understanding this..
> >=20
> > What is a 'trampoline' and what are you going to use them for.
>=20
> Great question! :-)
>=20
> The trampoline is some code that is used to jump to and then jump
> someplace else. Currently, we use this for kprobes and ftrace. For
> ftrace we have the ftrace_caller trampoline, which is static. When
> booting, most functions in the kernel call the mcount code which
> simply returns without doing anything. This too is a "trampoline". At
> boot, we convert these calls to nops (as you already know). When we
> enable callbacks from functions, we convert those calls to call
> "ftrace_caller" which is a small assembly trampoline that will call
> some function that registered with ftrace.
>=20
> Now why do we need the call_rcu_task() routine?
>=20
> Right now, if you register multiple callbacks to ftrace, even if they
> are not tracing the same routine, ftrace has to change ftrace_caller to
> call another trampoline (in C), that does a loop of all ops registered
> with ftrace, and compares the function to the ops hash tables to see if
> the ops function should be called for that function.
>=20
> What we want to do is to create a dynamic trampoline that is a copy of
> the ftrace_caller code, but instead of calling this list trampoline, it
> calls the ops function directly. This way, each ops registered with
> ftrace can have its own custom trampoline that when called will only
> call the ops function and not have to iterate over a list. This only
> happens if the function being traced only has this one ops registered.
> For functions with multiple ops attached to it, we need to call the
> list anyway. But for the majority of the cases, this is not the case.
>=20
> The one caveat for this is, how do we free this custom trampoline when
> the ops is done with it? Especially for users of ftrace that
> dynamically create their own ops (like perf, and ftrace instances).
>=20
> We need to find a way to free it, but unfortunately, there's no way to
> know when it is safe to free it. There's no way to disable preemption
> or have some other notifier to let us know if a task has jumped to this
> trampoline and has been preempted (sleeping). The only safe way to know
> that no task is on the trampoline is to remove the calls to it,
> synchronize the CPUS (so the trampolines are not even in the caches),
> and then wait for all tasks to go through some quiescent state. This
> state happens to be either not running, in userspace, or when it
> voluntarily calls schedule. Because nothing that uses this trampoline
> should do that, and if the task voluntarily calls schedule, we know
> it's not on the trampoline.
>=20
> Make sense?

Ok, so they're purely used in the function prologue/epilogue callchain.
And you don't want to use synchronize_tasks() because registering a trace
functions is atomic ?

But why would you use dynamic memory allocation for these trampolines at
all? Why not use the one default trampoline for this?

Suppose that thing looks like:

ftrace_mcount_handler()
{
	for_each_hlist_rcu(entry,..)
		entry->func();
}

so why not make it look like:

ftrace_mcount_handler()
{
	asm_volatile_goto("jmp %l[label]" ::: &do_list);
	return;

do_list:
	for_each_hlist_rcu(entry,...)
		entry->func();
}

Then, for:
	no entries -> NOP,=20
	one entry -> "CALL $func",=20
	more entries -> "JMP &do_list.

No need for extra allocations and fancy means of getting rid of them,
and only a few bytes extra wrt the existing function.

--QnlujARF9SsTF3UX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5HDPAAoJEHZH4aRLwOS6bgwP+wfxJkTBhi/1Vqw7M5b02c7o
+jcc3Brxv9j1ZiLphfUX7pI0oz1NMIPWe0yZVFkgjF9y0EvO20p/lLPZtke+Y16H
z/mw1kFxIsJ0+xBmDGgE6SM2/GpHVsgcFEmnfYiHi+jSFQRxwv/YQfnp/YF2MnGm
5EzlzGqldY4/gmlbcrKQSOy2mGPWNjePFXXPdb62SMqUH5QrP3DW433joWQ216pL
WDrsEEjbQKGjUGQI3dH85A1is67s56IrXId2vNz0g+y3eLsgIU5Dk1KKe3q4Sd7G
RLjPDfhtX7jj9awYLOemufPrdGyOCqsMbZhVB6XzXwJAKNOAdPVZBUvJj6gHvWZF
RKVRHTWHlG8oGKCVaGP/y8+/vxFUeUOVdcZd+ITouAEqgwbOIFpuWsZ2MiHhnyn9
HljFRXuUtNlQlj3V6Wi4OxoEbJqw4iw9ABXW4upHVW3PO1yK+Pkte+RzvW8BxRXJ
bgiVBEVSO9FK5uBMxVZWh8eyxxwb0Qgoqbx8+SrikDYIsxsKPGrpTwceptBRTf00
OW7IZ4Fmuq+ntLIMmrE18LdJhpDJVtDEJVZd38haO5R91BSiNaRe08MgA4WGqU6E
uv3DQBBWrgy8QbWau2KY3Hnta3skoGeZthh/ugJTjyxwMpoDuRx6T7a8mQ4jCEpU
P0tQv0Ap8txqP8dS1kNn
=YQeM
-----END PGP SIGNATURE-----

--QnlujARF9SsTF3UX--
