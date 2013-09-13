Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab3IMOkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:40:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54411 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470Ab3IMOkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:40:23 -0400
Date: Fri, 13 Sep 2013 16:40:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
Message-ID: <20130913144008.GF21832@twins.programming.kicks-ass.net>
References: <20130912141625.GA23357@somewhere>
 <00000141128d759a-44dcacb6-8f48-4f9b-8381-d14003bd6da1-000000@email.amazonses.com>
 <20130912143137.GA23839@somewhere>
 <0000014112a921ae-51d171bf-e8d4-4569-bd20-94dabda2d5ba-000000@email.amazonses.com>
 <20130912151102.GB23839@somewhere>
 <alpine.DEB.2.02.1309121030390.21473@gentwo.org>
 <0000014112d66287-d0abaeb1-71ff-48a0-8740-f984d47400a7-000000@email.amazonses.com>
 <20130912183023.GA25386@somewhere>
 <20130913092553.GL31370@twins.programming.kicks-ass.net>
 <00000141179a5b1f-b94a8394-9e98-400c-ae7f-59cdcfce60a6-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000141179a5b1f-b94a8394-9e98-400c-ae7f-59cdcfce60a6-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 01:54:53PM +0000, Christoph Lameter wrote:
> 
> > > If we really want to solve that race, then may be we can think of a kernel_parameter
> >
> > No bloody kernel params. I'd much rather create a pointless kthread to
> > act as usermodehelper parent that people can set context on (move it
> > into cgroups, set affinity, whatever) so it automagically propagates to
> > all userspace helper thingies.
> >
> > Is there anything other than usermodehelper we need to be concerned
> > with? One that comes to mind would be unbound workqueue threads. Do we
> > want to share the parent with usermodehelpers or have these two classes
> > have different parents?
> 
> So you want to keep those silly racy move-all-threads-to-some-cpus scripts
> around? 

No, creating a parent for them closes the race. It should also makes it
lots easier to find the kids by using ppid.

> A kernel parameter would allow a clean bootup with threads
> starting out on the specific processors we want them to.

Blergh, no. A kernel should boot, a kernel should allow you to configure
things, a kernel should not be limited to boot time settings.

> Also there is even more work ahead to deal with things like kswapd,
> writeback threads, compaction and various other scanners that should also
> be restricted. Mostly one thread per node is sufficient. This is not
> simple to do from user space.

IIRC we have one kswapd per node, not sure about the others. And why is
this not simple from userspace? All these are long-running threads and
from a quick look they can have their affinity changed.


