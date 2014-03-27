Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbaC0VUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 17:20:17 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38943 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166AbaC0VUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 17:20:11 -0400
MIME-Version: 1.0
In-Reply-To: <4001272.s8O7Wrizcc@jlieb-e6410>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
 <2487921.a0QJrtikX0@jlieb-e6410> <CALCETrU1g6Dzx=vWUcqkxcfOsb9duCJFPDuah8mrShWe4uEEgw@mail.gmail.com>
 <4001272.s8O7Wrizcc@jlieb-e6410>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 27 Mar 2014 14:19:50 -0700
Message-ID: <CALCETrWW=gAu57VVD34ec68r+hCnMvTCXkc+pPeZW5yNtzy+1Q@mail.gmail.com>
Subject: Re: Re: Re: Thoughts on credential switching
To: Jim Lieb <jlieb@panasas.com>
Cc: Jeremy Allison <jra@samba.org>, Jeff Layton <jlayton@redhat.com>,
        Florian Weimer <fweimer@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 1:47 PM, Jim Lieb <jlieb@panasas.com> wrote:
> On Thursday, March 27, 2014 12:45:30 Andy Lutomirski wrote:
>> On Thu, Mar 27, 2014 at 12:30 PM, Jim Lieb <jlieb@panasas.com> wrote:
>> > Rather than inline, I'm responding in the context of Jeremy's comments but
>> > I have to answer others as well.  It is Jeremy after all who said my baby
>> > was ugly ;).
>> >
>> > Jeremy is right about overloading "fd".  Maybe I can call it something
>> > else
>> > but an fd (in implementation) has merit because a creds struct hangs off
>> > of
>> > either/or/both task_struct and file but nothing else.  Coming up with a
>> > creds token struct adds/intros another struct to the kernel that has to
>> > justify its existence.  This fd points to an anon inode so the resource
>> > consumption is pretty low and all the paths for managing it are well
>> > known and *work*.  I'm trying to get across the swamp, not build a new
>> > Golden Gate bridge...
>> >
>> > As for POSIX, all of the pthreads API was based on CDE threads whose
>> > initial implementation was on Ultrix (BSD 4.2).  Process wide was assumed
>> > because utheeads was a user space hack and setuid was process wide
>> > because a proc was a just that.  Good grief, that kernel was UP...  When
>> > OSF/1 appeared, the Mach 2.5 kernel just carried that forward with its
>> > proc + thread(s) model to be compatible with the old world.  In other
>> > words, we incrementally backed ourselves into a corner.  Declaring POSIX
>> > now avoids admitting that we didn't see all that far into the future.
>> > Enough said.  These calls are *outside* POSIX.  Pthreads in 2014 is
>> > broken/obsolete.
>> >
>> > For the interface, I changed it from what is in the cited lkml below.   It
>> > is>
>> > now:
>> >    int switch_creds(struct user_creds *creds);
>>
>> What is struct user_creds?  And why is this called switch_creds?  It
>> doesn't switch anything.
>
> Sorry, it was in the cited lkml... It is:
>
> struct user_creds {
>         uid_t fsuid;
>         gid_t fsgid;
>         int ngroups;
>         gid_t altgroups[];
> };
>
> ngroups is limited by NGROUPS.
>
> It is called switch_creds because it does switch them to the contents of
> creds.  When you return from switch_creds "bob" your fsuid is "Bob".  The
> return value is a handle to those creds so the next time you need to be "Bob"
> you can just:
>
>      use_creds(bob_creds);
>
>>
>> > Behavior is the same except the mux'd syscall idea is gone.  Adding a
>> > flags arg to this is a useful idea both for current use and future
>> > proofing the API.  But this requires a second call
>> >
>> >    int use_creds(int fd);
>> >
>> > This call does the "use an fd" case but adds -1 to revert to real creds.
>> > Its guts are either an override_creds(fd->file->creds) or a
>> > revert_creds().  Nice and quick.  Note that use_creds(fd) is used if I
>> > have cached the fd/token from switch_creds().  Also nice and quick.
>> >
>> > Given that I've done the checking in switch_creds and I don't pass
>> > anything
>> > back other than the token/fd and this token/fd is/will be confined to the
>> > thread group, use_creds(fd) only needs to validate that it is a
>> > switch_creds one, not from an arbitrary open().  I do this.
>>
>> Not so fast...  what if you start privileged, create a cred fd, call
>> unshare, do a dyntransition, chroot, drop privileges, and call
>> use_creds?  I don't immediately see why this is insecure, but having
>> it be secure seems to be more or less the same condition as having my
>> credfd_activate be secure.
>>
>> And I still don't see why you need revert at all.  Just create a
>> second token/fd/whatever representing your initial creds and switch to
>> that.
>
> The creds you get have also had the capabilities reduced.  You can't do a
> chroot because it will EPERM.  Same with a lot of others.  This is a
> restricted file access jail in itself.  We *reduce* privs+caps here.

Why not just leave the capabilities as-is?  The caller will have to
remove CAP_DAC_OVERRIDE and CAP_DAC_READ_SEARCH from the effective set
first, but that's okay.

>
> The use_creds has a shortcut of -1 to revert to real creds.  So if you do a
> series of these, how do you get back to your priv'd state?  You can either
> keep track of that yourself or just pass in -1 to use_creds() and know you
> are...

int fully_privileged_cred_fd;

>>
>> > I have focused this down to "fsuid" because I intend this for ops that
>> > file
>> > perms.  Other stuff is out of scope unless someone can come up with a use
>> > case and add flag defs...  The other variations on the theme uid, euid,
>> > and that other one I don't understand the use for, are for long lasting
>> > creds change, i.e. become user "bob" and go off an fork a shell...  I am
>> > wrapping I/O.
>> Isn't there euid for that?
>
> Right.  A crappy interface given that creds are really more than just euid or
> even egid but it does that deed just fine.  It is for long term as in "become
> Dave and run this program..."  I don't change that.  I'm dealing with "As Bob,
> do a pwrite(s)+fstat" across N cores and M ops per core...

But euid can do that just fine.  And I think it would be unfortunate
to add these new syscalls in a way that's so narrowly tailored to
userspace file serving.  Someone might want to use it for login: have
an unprivileged task that accepts connections, forward the username
and password to a privileged helper, have that helper send back creds,
then switch to those creds and call exec.

>>
>> Eek!  You want this for I/O.  What if someone else wants it for
>> something else?  Any where does the actual list of what syscalls get
>> blocked come from?
>
> The "blocked" list is twofold.  First, any syscall that needs privs that I
> have explicitly given up here (see the nfs_setuser caps that knfsd masks)
> The second is, with the new patches, any syscall that ends up doing a
> commit_creds().  That is, in general, all the set*id/groups calls, anything
> messing with keys, execve, fork, and security twiddling code.  The more I
> think about this, it is a good thing.  They would return EPERM which for my
> use case wouldn't happen but for exploit attempts it slams the door with a
> clean error.
>
>>
>> I think that your patches will get a *lot* simpler if you get rid of
>> this override_creds and revert stuff and just switch the entire set of
>> creds.  No setuid blocking, no BUG, and no need to audit the whole
>> tree for odd real_creds uses.
>
> I really do want override.  Otherwise, it is an RCU and I can get into a
> position where I can't revert leaving me with the even worse situation of
> doing a thread exit because it is no good for anything else anymore.

No RCU -- as long as you have anything else that references the
original creds, the refcount won't drop to zero, and no RCU free will
be needed.  And, if you keep an fd referencing the old creds, you can
go back.

>
> As for someone else coming up with a new use case, sure, we can think about
> this.  One idea has been proposed to have a flags arg to spec the "type" of uid
> etc.  If there is motivation for that, I could add a flags arg with only one
> "do fsuid" as its first and, for now, only defined bit.
>
> As for the BUG(task->creds != task->real_creds), this should really be handled
> much earlier and more friendly (EPERM) than oops'ing the task.  That is what
> the promised additional patch does.  I did audit the commit_creds calls to
> come up with the patch and the list above.

I'm still scared of this.  Someone will add something in the future
that breaks this.  It could be an LSM fiddling with security.  It
could be keys.  And regardless of what it is, I don't see why it
should be illegal, other than the fact that no one knows what the
semantics are.


The tl;dr version might be that you're proposing adding a way to
separate real_creds and creds in a way that's visible to userspace.
I'm suggesting a way to have a kernel object that grants permission to
switch both of them.  I think that mine is less of a departure from
the way things work now, and is therefore less scary.

If you're afraid of my approach, then make credfd_activate require
CAP_SYS_ADMIN, and it'll all be safe.

--Andy

>
>>
>> --Andy
>
> --
> Jim Lieb
> Linux Systems Engineer
> Panasas Inc.
>
> "If ease of use was the only requirement, we would all be riding tricycles"
> - Douglas Engelbart 1925-2013



-- 
Andy Lutomirski
AMA Capital Management, LLC
