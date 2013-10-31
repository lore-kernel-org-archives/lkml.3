Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3JaTtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 15:49:17 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:57295 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3JaTtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 15:49:15 -0400
MIME-Version: 1.0
In-Reply-To: <3154208.hemKm7CgkG@jlieb-e6410>
References: <1381960919-4542-1-git-send-email-jlieb@panasas.com>
 <5068709.xK6KPeP0iH@jlieb-e6410> <CALCETrUWo_HrPp-OME16iXGdBWaFT-Ch+tdc-wFjns=sdRfW1g@mail.gmail.com>
 <3154208.hemKm7CgkG@jlieb-e6410>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 31 Oct 2013 12:48:54 -0700
Message-ID: <CALCETrVaT7EaPOs7w=i_WJQS9mNEXK1-GvPni2jJ29Ne+2X8gA@mail.gmail.com>
Subject: Re: Re: Re: [PATCH 1/3] switch_creds: Syscall to switch creds for
 file server ops
To: Jim Lieb <jlieb@panasas.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com, Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 12:43 PM, Jim Lieb <jlieb@panasas.com> wrote:
> On Thursday, October 31, 2013 12:09:08 Andy Lutomirski wrote:
>> On Thu, Oct 24, 2013 at 1:24 PM, Jim Lieb <jlieb@panasas.com> wrote:
>> > On Thursday, October 24, 2013 12:28:15 Andy Lutomirski wrote:
>> >> On Wed, Oct 23, 2013 at 10:59 PM, Eric W. Biederman
>> >>
>> >> <ebiederm@xmission.com> wrote:
>> >> > Andy Lutomirski <luto@amacapital.net> writes:
>> >> >> On 10/16/2013 08:52 PM, Eric W. Biederman wrote:
>> >> >>> Al Viro <viro@ZenIV.linux.org.uk> writes:
>> >> >>>> On Wed, Oct 16, 2013 at 06:18:16PM -0700, Eric W. Biederman wrote:
>> >> >>>>> That doesn't look bad but it does need capable(CAP_SETUID) &&
>> >> >>>>> capable(CAP_SETGID) or possibly something a little more refined.
>> >> >>>>
>> >> >>>> D'oh
>> >> >>>>
>> >> >>>>> I don't think we want file descriptor passing to all of a sudden
>> >> >>>>> become
>> >> >>>>> a grant of privilege, beyond what the passed fd can do.
>> >> >>>>
>> >> >>>> Definitely.  And an extra ) to make it compile wouldn't hurt
>> >> >>>> either...
>> >> >>>
>> >> >>> There also appears to need to be a check that we don't gain any
>> >> >>> capabilities.
>> >> >>>
>> >> >>> We also need a check so that you don't gain any capabilities, and
>> >> >>> possibly a few other things.
>> >> >>
>> >> >> Why?  I like the user_ns part, but I'm not immediately seeing the
>> >> >> issue
>> >> >> with capabilities.
>> >> >
>> >> > My reasoning was instead of making this syscall as generic as possible
>> >> > start it out by only allowing the cases Jim cares about and working
>> >> > with
>> >> > a model where you can't gain any permissions you couldn't gain
>> >> > otherwise.
>> >> >
>> >> > Although the fd -1 trick to revert to your other existing cred seems
>> >> > reasonable.
>> >> >
>> >> >>> So I suspect we want a check something like:
>> >> >>>
>> >> >>> if ((new_cred->securebits != current_cred->securebits)  ||
>> >> >>>
>> >> >>>     (new_cred->cap_inheritable != current_cred->cap_inheritable) ||
>> >> >>>     (new_cred->cap_permitted != current_cred->cap_permitted) ||
>> >> >>>     (new_cred->cap_effective != current_cred->cap_effective) ||
>> >> >>>     (new_cred->cap_bset != current_cred->cap_bset) ||
>> >> >>>     (new_cred->jit_keyring != current_cred->jit_keyring) ||
>> >> >>>     (new_cred->session_keyring != current_cred->session_keyring) ||
>> >> >>>     (new_cred->process_keyring != current_cred->process_keyring) ||
>> >> >>>     (new_cred->thread_keyring != current_cred->thread_keyring) ||
>> >> >>>     (new_cred->request_keyring != current_cred->request_keyring) ||
>> >> >>>     (new_cred->security != current_cred->security) ||
>> >> >>>     (new_cred->user_ns != current_cred->user_ns)) {
>> >> >>>
>> >> >>>      return -EPERM;
>> >> >>>
>> >> >>> }
>> >> >>
>> >> >> I *really* don't like the idea of being able to use any old file
>> >> >> descriptor.  I barely care what rights the caller needs to have to
>> >> >> invoke this -- if you're going to pass an fd that grants a capability
>> >> >> (in the non-Linux sense of the work), please make sure that the sender
>> >> >> actually wants that behavior.
>> >> >>
>> >> >> IOW, have a syscall to generate a special fd for this purpose.  It's
>> >> >> only a couple lines of code, and I think we'll really regret it if we
>> >> >> fsck this up.
>> >> >>
>> >> >> (I will take it as a personal challenge to find at least one
>> >> >> exploitable
>> >> >> privilege escalation in this if an arbitrary fd works.)
>> >> >
>> >> > If you can't switch to a uid or a gid you couldn't switch to otherwise
>> >> > then the worst that can happen is an information leak.  And information
>> >> > leaks are rarely directly exploitable.
>> >>
>> >> Here's the attack:
>> >>
>> >> Suppose there's a daemon that uses this in conjunction with
>> >> SCM_RIGHTS.  The daemon is effectively root (under the current
>> >> proposal, it has to be).  So a client connects, sends a credential fd,
>> >> and the daemon impersonates those credentials.
>> >>
>> >> Now a malicious user obtains *any* fd opened by root.  It sends that
>> >> fd to the daemon.  The daemon then impersonates root.  We lose.  (It
>> >> can't possibly be hard to obtain an fd with highly privileged f_cred
>> >> -- I bet that most console programs have stdin like that, for example.
>> >>
>> >>  There are probably many setuid programs that will happily open
>> >>
>> >> /dev/null for you, too.)
>> >
>> > In my reply to Eric, I note that I need to add a check that the fd passed
>> > is one from switch_creds. With that test, not any fd will do and the one
>> > that does has only been able to set fsuid, fsgid, altgroups, and reduced
>> > (the nfsd set) caps.  They can do no more damage than what the original
>> > switch_creds allowed.  The any fd by root no longer applies so use
>> > doesn't get much (no escalation).
>> >
>> >> >> Also... real_cred looks confusing.  AFAICS it is used *only* for knfsd
>> >> >> and faccessat.  That is, current userspace can't see it.  But now
>> >> >> you'll
>> >> >> expose various oddities.  For example, AFAICS a capability-less
>> >> >> process
>> >> >> that's a userns owner can always use setuid.  This will *overwrite*
>> >> >> real_cred.  Then you're screwed, especially if this happens by
>> >> >> accident.
>> >> >
>> >> > And doing in userland what faccessat, and knfsd do in the kernel is
>> >> > exactly what is desired here.  But maybe there are issues with that.
>> >> >
>> >> >> That being said, Windows has had functions like this for a long time.
>> >> >> Processes have a primary token and possibly an impersonation token.
>> >> >> Any
>> >> >> process can call ImpersonateLoggedOnUser (no privilege required) to
>> >> >> impersonate the credentials of a token (which is special kind of fd).
>> >> >> Similarly, any process can call RevertToSelf to undo it.
>> >> >>
>> >> >> Is there any actual problem with allowing completely unprivileged
>> >> >> tasks
>> >> >> to switch to one of these magic cred fds?  That would avoid needing a
>> >> >> "revert" operation.
>> >> >
>> >> > If the permission model is this switching of credentials doesn't get
>> >> > you
>> >> > anything you couldn't get some other way.  That would seem to totally
>> >> > rules out unprivileged processes switching these things.
>> >>
>> >> IMO, there are two reasonable models that involve fds carrying some
>> >> kind of credential.
>> >>
>> >> 1. The fd actually carries the ability to use the credentials.  You
>> >> need to be very careful whom you send these to.  The security
>> >> implications are obvious (which is good) and the receiver doesn't need
>> >> privilege (which is good, as long as the receiver is careful).
>> >
>> > I test for caps.  I think using switch_creds in all forms should require
>> > privs.  I thought of the revert case and although it does simply return to
>> > "real" creds, you still need CAP_SETUID and CAP_SETGID to do it.  This
>> > means, of course, if you have really messed up things, you may not be
>> > able to get back home which, although a bad thing for the process, is a
>> > good thing for the system as a whole.
>> >
>> >> 2. The fd is for identification only.  But this means that the fd
>> >> carries the ability to identify as a user.  So you *still* have to be
>> >> very careful about whom you send it to.  What you need is an operation
>> >> that allows you to identify using the fd without transitively granting
>> >> the recipient the same ability.  On networks, this is done by signing
>> >> some kind of challenge.  The kernel could work the same way, or there
>> >> could be a new CMSG_IDENTITY that you need an identity fd to send but
>> >> that does not copy that fd to the recipient.
>> >
>> > I am not sure I understand this.  CMSG only applies to UNIX_DOMAIN sockets
>> > which means that the switch_creds fd test still applies here.  It is
>> > identification but only for within the same kernel.  As for namespaces,
>> > the
>> > translation was done when the creds fd was created.  I suppose if it was
>> > passed across namespace boundaries there could be a problem but what is in
>> > the creds structure is the translated fduid,fsgid etc., not the
>> > untranslated one. We are still doing access checks and quota stuff with
>> > the translated creds.  If one namespace has "fred" as uid 52 and another
>> > has "mary" as 52, the quota will only be credited to whoever "fred"
>> > really is only if "fred" gets to be "mary" in the second alternate
>> > universe...
>>
>> I'm not talking about namespaces here -- I think we're not really on
>> the same page.  Can you describe what you're envisioning doing with
>> these fds?
>
> I have a new version that is now two syscalls and no multiplexing has more
> testing etc. to mirror exactly the tests in setfsuid().  I still am testing
> but plan to send this new patchset next week for review.
>
> Ok,  I may have missed something.  What I meant to say is that I'm using the
> same namespace functions for switch_creds as all the set*uid syscalls use so
> what I have should work as well.  If one were to pass this fd via CMSG, it
> could cross a namespace boundary.  The changed mappings of this fd would be
> the same as for any other fd passed across now.  Maybe that is irrelevant in
> this case.
>
> The purpose of the fd is to create a handle to a creds set that a server can
> then efficiently switch to prior to filesystem syscalls where fsuid etc. are
> relevant (mkdir, creat, write, etc.).  This is exposing the override_creds()
> and revert_creds() to these servers.  I do not intend in our server to hand
> these fds to anyone else.  After all, they are useless for anything other than
> switch_creds/use_creds.
>
> The server keeps a cache of its known, currently active client creds along
> with this fd.  The fast path is to lookup the creds and use the fd.  On cache
> misses, it does a switch_creds() and saves the fd in the cache.

So if I understand you correctly, you're not planning on sending this
fd between process at all.  In that case, adding a new API that seems
designed for interprocess use and having exactly zero usecases to
think about makes me nervous.  Why is it going to use fds again?

Or maybe I should wait to see the updated API before complaining :)

>
>>
>> >> >> Another note: I think that there may be issues if the creator of a
>> >> >> token
>> >> >> has no_new_privs set and the user doesn't.  Imagine a daemon that
>> >> >> accepts one of these fds, impersonates it, and calls exec.  This could
>> >> >> be used to escape from no_new_privs land.
>> >> >
>> >> > Which is why I was suggesting that we don't allow changing any field in
>> >> > the cred except for uids and gids.
>> >>
>> >> If the daemon impersonates and execs, we still lose.
>> >
>> > I answered this.  You only get to impersonate for purposes of file access
>> > with reduced caps to prevent you from being root as well.  Also, since
>> > these are O_CLOEXEC and switch_creds "magic" fds, this can't happen
>> > because the fd is gone post-exec.
>>
>> If a no_new_privs process authenticates to a daemon and that daemon
>> execs, then there's now a dumpable, ptraceable, non-no-new-privs
>> process running as the uid/gid of the no_new_privs process.  This may
>> be dangerous.
>
> Two things.  My new patch set now throws an error if the fd is not one
> returned by switch_creds().  The new syscall here is use_creds() btw.  That fd
> is opened O_CLOEXEC so the syscall has two guards.  First, it can only be one
> that switch_creds() returned and second, it gets closed on an exec so the
> no_new_privs process doesn't get it.  In addition, switch_creds() reduces the
> effective caps set to the same minimal set that nfsd_setuser() has.
>
> If someone else chooses to pass this fd via CMSG, whoever gets it has reduced
> privs and in order to use it for anything, i.e. use_creds(), it still needs to
> inherit SETUID and SETGID caps from its parent or it will get an EPERM error.
> Passing this in "friendly" code defeats the purpose of the cache above in that
> we could get fd leaks.  If there is another flag that could prevent its being
> passed along via CMSG, I can add that too because using CMSG is well outside
> the use case.

I still don't see the point of lowering effective caps, but this is
IMO minor.  Are you checking the permitted set on revert?

--Andy
