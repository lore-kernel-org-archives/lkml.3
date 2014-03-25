Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbaCYTAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:00:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:45549 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaCYTAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:00:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, gnomes@lxorguk.ukuu.org.uk,
        riel@redhat.com, snorcht@gmail.com, dhowells@redhat.com,
        luto@amacapital.net, daeseok.youn@gmail.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
	<1395767870-28053-1-git-send-email-khalid.aziz@oracle.com>
Date: Tue, 25 Mar 2014 11:59:43 -0700
In-Reply-To: <1395767870-28053-1-git-send-email-khalid.aziz@oracle.com>
	(Khalid Aziz's message of "Tue, 25 Mar 2014 11:17:50 -0600")
Message-ID: <8761n25ckg.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1//ZIjpJbKwByIYKYhPehiAeHMDH1U3OFc=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4994]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Khalid Aziz <khalid.aziz@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] Pre-emption control for userspace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Khalid Aziz <khalid.aziz@oracle.com> writes:

> This patch adds a way for a thread to request additional timeslice from
> the scheduler if it is about to be preempted, so it could complete any
> critical task it is in the middle of. This functionality helps with
> performance on databases and has been used for many years on other OSs
> by the databases. This functionality helps in situation where a thread
> acquires a lock before performing a critical operation on the database,
> happens to get preempted before it completes its task and releases the
> lock.  This lock causes all other threads that also acquire the same
> lock to perform their critical operation on the database to start
> queueing up and causing large number of context switches. This queueing
> problem can be avoided if the thread that acquires lock first could
> request scheduler to grant it an additional timeslice once it enters its
> critical section and hence allow it to complete its critical sectiona
> without causing queueing problem. If critical section completes before
> the thread is due for preemption, the thread can simply desassert its
> request. A thread sends the scheduler this request by setting a flag in
> a memory location it has shared with the kernel.  Kernel uses bytes in
> the same memory location to let the thread know when its request for
> amnesty from preemption has been granted. Thread should yield the
> processor at the end of its critical section if it was granted amnesty
> to play nice with other threads. If thread fails to yield processor, it
> gets penalized by having its next amnesty request turned down by
> scheduler.  Documentation file included in this patch contains further
> details on how to use this functionality and conditions associated with
> its use. This patch also adds a new field in scheduler statistics which
> keeps track of how many times was a thread granted amnesty from
> preemption. This feature and its usage are documented in
> Documentation/scheduler/sched-preempt-delay.txt and this patch includes
> a test for this feature under tools/testing/selftests/preempt-delay


Let me see if I understand the problem.  Your simulated application has
a ridiculous number of threads (1000) all contending for a single lock
with fairly long lock hold times between 600 and 20000 clocks assuming
no cache line misses.  So 1000 threads contending for about 10usec or
1/100 of a tick when HZ=1000.  Giving  you something like 1 chance in
100 of being preempted while holding the lock.  With 1000 threads
those sound like pretty bad odds.

Either your test program is a serious exageration of what your userspace
is doing or this looks like an application design problem.

I am sorry no number of kernel patches can fix a stupid userspace
application, and what is worse it looks like this approach will make
the situation worse for applications that aren't stupid.  Because they
will now suffer from much less predictability in how long they have to
wait for the cpu.

Maybe if this was limited to a cooperating set of userspace
tasks/threads this might not be too bad.  As this exists I have users
who would hunt me down with malicious intent if this code ever showed up
on our servers, because it would make life for every other application
on the server worse.

The only two sane versions of this I can see are (a) having the
scheduler write the predicted next preemption time into the vdso page so
your thread can yield preemptively before taking the lock if it doesn't
look like it has enough time, or (b) limiting this to just a small
cooperating set of threads in a single cgroup.

As you have not limited the effects of this patch and as this will make
latencies worse for every other program on a system I think this is a
horrible approach.  This really is not something you can do unless all
of the threads that could be affected are in the same code base, which
is definitely not the case here.

So for the general horrible idea.
Nacked-With-Extreme-Prejudice-by: "Eric W. Biederman" <ebiederm@xmission.com>

Cooperative multitasking sucked in Windows 3.1 and it would be much
worse now.  Please stop the crazy.  Linux is challenging enough to
comprehend as it is, and I can't possibly see this patch makes anything
more predictable.

Eric
