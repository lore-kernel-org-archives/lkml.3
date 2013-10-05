Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3JEPso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 11:48:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51669 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3JEPsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 11:48:42 -0400
Date: Sat, 5 Oct 2013 16:48:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chen Gang <gang.chen@asianux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/exit.c: call read_unlock() when failure occurs
 after already called read_lock() in do_wait().
Message-ID: <20131005154831.GV13318@ZenIV.linux.org.uk>
References: <524FA956.9080100@asianux.com>
 <20131005063431.GU13318@ZenIV.linux.org.uk>
 <524FC0D4.9070407@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524FC0D4.9070407@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 03:33:40PM +0800, Chen Gang wrote:

> Oh, it is my fault, this is incorrect patch. Hmm... I realize a mistake
> of me: I have said "when finding issues, I need consider about LTP in q4
> 2013, need let it can be tested by LTP".

Not really.  The mistake was different.

> And you feel "this is getting too frequent...", can you provide my
> failure/succeed ratio?
> 
> Or for a short proof: next, I will try to find 2 patches by reading code
> within "./kernel" sub-directory, if all of them are incorrect, I will
> *never* send patches again by reading code. Is it OK?

Hell, no.  It is exactly the wrong outcome.  Reading code *does* catch
bugs and assuming that testing would've found all of them is absolutely
wrong.  Let me describe what I would've done when running into a place
like that (and yes, it's certainly calling for investigation - the
fact that you've noticed it is a Good Thing(tm)).

OK, so we have a loop entered with rwlock held, with read_unlock() done
on a normal exit from the loop and several exits via goto not doing
read_unlock().  That certainly deserves a closer look - if the functions
called there are locking-neutral, we are missing read_unlock on these
exits.  Might be a bug.  So far, so good.  OTOH, the functions called
there might do read_unlock() themselves, so what we need is to find
out if it really can happen.

The loop in question is
        do {
                retval = do_wait_thread(wo, tsk);
                if (retval)
                        goto end;

                retval = ptrace_do_wait(wo, tsk);
                if (retval)
                        goto end;

                if (wo->wo_flags & __WNOTHREAD)
                        break;
        } while_each_thread(current, tsk);

If we can show a scenario with goto end; happening without read_unlock,
we are done.  How would that happen?  do_wait_thread() or ptrace_do_wait()
returning non-zero with tasklist_lock held.  Let's look at them:

/*
 * Do the work of do_wait() for one thread in the group, @tsk.
 *
 * -ECHILD should be in ->notask_error before the first call.
 * Returns nonzero for a final return, when we have unlocked tasklist_lock.
 * Returns zero if the search for a child should continue; then
 * ->notask_error is 0 if there were any eligible children,
 * or another error from security_task_wait(), or still -ECHILD.
 */
static int do_wait_thread(struct wait_opts *wo, struct task_struct *tsk)
{
        struct task_struct *p;

        list_for_each_entry(p, &tsk->children, sibling) {
                int ret = wait_consider_task(wo, 0, p);
                if (ret)
                        return ret;
        }

        return 0;
}

Hmm...  it calls wait_consider_task() a bunch of times, returns the first
non-zero it gets or returns 0 if all of them have done so.  So the same
question arises for wait_consider_task() - when can *that* return non-zero
with tasklist_lock still held?  The comment above it says "returns nonzero
for a final return when we have unlocked tasklist_lock", which would seem
to imply that nonzero returns are supposed to happen with tasklist_lock
dropped; still, the comment might not match the code, so we need to dig
on.  The second function (ptrace_do_wait()) is just like that, only with
wait_consider_task() getting 1 as the second argument instead of 0.

Next target: wait_consider_task().  Any place where it returns non-zero
with lock held would be a bug; so would any place where it returns zero
without a lock.  What returns do we have there?  Well, there's a bunch
of explicit return 0.  There's also
        if (!ret)
                return ret;
in the beginning, which is also returning 0.  On three exits we have
something different returned:
1)		return wait_task_zombie(wo, p);
2)	ret = wait_task_stopped(wo, ptrace, p);
        if (ret)
                return ret;
3)
        return wait_task_continued(wo, p);

So we have 3 targets now - wait_task_{zombie,stopped,continued} (plus
verifying that everything else called there is locking-neutral, but that
can wait).

wait_task_zombie() has a bunch of return 0,
return wait_noreap_copyout(wo, p, pid, uid, why, status); (that's another
function to review) *and* this:
        /*
         * Now we are sure this task is interesting, and no other
         * thread can reap it because we set its state to EXIT_DEAD.
         */
        read_unlock(&tasklist_lock);
no manipulations of tasklist_lock on the path to that, but here we definitely
unlock it.  After that point we do a bunch of put_user() (which is obviously
a good reason for read_unlock()) and return retval.  Without any attempts
to relock.  Hmm...  Can retval be zero here?  The last place touching it
is
        if (!retval)
                retval = pid;
and if it's really a PID, this code is guaranteed to end up with non-zero
retval (PIDs can't be zero).  Looking for a place where pid had been
calculated seems to indicate that a PID it is - one belonging to p.
OK, so we still hadn't found that scenario yet - at least on this path
the thing unlock and returns non-zero.  Next target: wait_noreap_copyout().

On the path to it we have this:
                read_unlock(&tasklist_lock);
                if ((exit_code & 0x7f) == 0) {
                        why = CLD_EXITED;
                        status = exit_code >> 8;
                } else {
                        why = (exit_code & 0x80) ? CLD_DUMPED : CLD_KILLED;
                        status = exit_code & 0x7f;
                }
                return wait_noreap_copyout(wo, p, pid, uid, why, status);  
so again tasklist_lock is dropped and we'd better check if there's a way
for wait_noreap_copyout() to return 0 - that would be another locking
problem.  A look at that function shows that
	* it does a bunch of put_user()
	* it ends with the same if (!retval) retval = pid;, so no zero
returns from it
	* it seems to be locking-neutral
So we seem to be OK on that path as well.

No other manipulations of tasklist_lock is seen in wait_task_zombie(),
so provided that the rest of stuff called there is locking-neutral, we
ought to be OK.

Now what?  wait_task_stopped() is the next unreviewed here...  A big
comment in front of that one (we are in the core kernel, but don't
count on having those for everything and *definitely* don't count on
having those elsewhere).  Says, among other things,
 * CONTEXT:
 * read_lock(&tasklist_lock), which is released if return value is
 * non-zero.  Also, grabs and releases @p->sighand->siglock.
 *
 * RETURNS:
 * 0 if wait condition didn't exist and search for other wait conditions
 * should continue.  Non-zero return, -errno on failure and @p's pid on
 * success, implies that tasklist_lock is released and wait condition
 * search should terminate. 

So it looks like the intended rules are "return with lock held all along
if you are returning zero, return with lock dropped otherwise".  Again,
that doesn't spare us a read through the code - the comments might not
match it.  Again, we have a bunch of return 0, and then this:
        pid = task_pid_vnr(p);
        why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
        read_unlock(&tasklist_lock);
tasklist_lock not touched prior to that point.  Then either return
wait_noreap_copyout() (we'd already read that one, locking-neutral,
never returns 0) or a bunch of put_user(), followed by
        if (!retval)
                retval = pid;
...
        BUG_ON(!retval);
        return retval;

OK, modulo locking neutrality of the other stuff called there, we are done
with that case as well.

Next one?  Aha, wait_task_continued().  Smaller that wait_task_stopped(),
the same picture (with slightly less ornate comment along the same lines
in front ;-)  Again, the comments might not match the current code or be
there, so we still need to RTFS, but it's small and follows the same
layout.

Note that at *any* point during the above we might have found a bug.
Moreover, even though it's a core kernel, I honestly wasn't sure we
_won't_ find one.  We hadn't, but it was a useful reading, all the same.

Next question is "could these functions have more usual calling conventions?"
put_user(), of course, is blocking, so we can't hold an rwlock over that.
So if we do those put_user() there, we have to drop it.  Would it make
sense to retake it on such exits?  Probably not - we'd need to branch out
of that loop in those cases anyway, and the first thing done there would
be read_unlock() as in your patch.  Keeping the locking uniform makes
sense when codepaths converge...  A more interesting question is whether
we need those put_user() to be there.  We fills siginfo at wo->wo_infop,
an integer at wo->wo_status and rusage at wo->wo_rusage.  We might've
filled that information in kernelspace objects and copied it to userland
after return to do_wait().  That might be worth looking into, but it's
a separate story.

The functions involved definitely deserve comments about the calling
conventions being unusual wrt tasklist_lock.  They've got such comments,
though, and I'm not sure if I could improve those.  Might be worth
a couple of inline comments inside the do_wait() loop...

Note that if a bug had turned out to be real, commit message would definitely
needed either "... and the function called there do not touch tasklist_lock"
or "... and in the following case we get non-zero value returned with
tasklist_lock still held".  Said that, once we'd found paths returning
non-zero with tasklist_lock dropped, the fix would pretty much have to be
adding a read_unlock() on the path missing it, because there's no way
for caller to tell which of these paths had been taken.

And yes, the above is fairly typical code review work; one has to do that
kind of things on a regular basis in unfamiliar code without useful (or
truthful) comments, with real bugs getting caught in process.  _All_ of
the above had been by reading the code, BTW.  Being able to spot suspicious
places is a crucial part of such work, but you need to follow with reasoning
about the code you've spotted.

We all had been there, complete with much more embarrassing "I've found that
really obvious bug; who the hell writes that kind of idiotic code?" postings,
followed by "oops, I've completely misread it" kind of retractions.  Not fun,
especially for those of us who tend to make, er, pointed comments when
dealing with stupid bugs.  Yours was comparatively benign; such things
will happen now and then.  It's inevitable when one does read the code looking
for bugs, and we really, really need people doing that.  I can't stress that
hard enough - we need more people doing code review.  Moreover, IMO that's
the best way to learn the kernel.  I'm probably biased in that, since this
is how I begin working with unfamiliar areas in it (as the matter of fact,
that's how I started with Linux - RTFS through VFS, learning and looking
for bugs at the same time).  But we definitely need more people doing that
kind of stuff.

The thing you really don't want to happen would be perception that you
just look for local patterns and stop at that.  That's what I was refering
to - ISTR several threads where you seemed to go "this code looks suspicious,
let's fix it" without bothering to look at the stuff it calls, etc.

Again, spotting patterns is a very good thing - you can't do code review
without being able to do that.  However, it must be followed either with
reasoning about the code involved or with searching for somebody familiar
with that thing and asking to explain.  The latter might very well end up
with nobody showing up, in which case you have to do analysis yourself
anyway ;-/
