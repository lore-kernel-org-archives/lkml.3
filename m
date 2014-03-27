Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbaC0Ur6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 16:47:58 -0400
Received: from static-209-166-131-148.expedient.com ([209.166.131.148]:37132
	"EHLO natasha.panasas.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757242AbaC0Urw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 16:47:52 -0400
From: Jim Lieb <jlieb@panasas.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Jeremy Allison <jra@samba.org>, Jeff Layton <jlayton@redhat.com>,
        Florian Weimer <fweimer@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <bfields@redhat.com>
Subject: Re: Re: Re: Thoughts on credential switching
Date: Thu, 27 Mar 2014 13:47:37 -0700
Message-ID: <4001272.s8O7Wrizcc@jlieb-e6410>
Organization: Panasas Inc.
User-Agent: KMail/4.11.5 (Linux/3.13.6-100.fc19.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CALCETrU1g6Dzx=vWUcqkxcfOsb9duCJFPDuah8mrShWe4uEEgw@mail.gmail.com>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com> <2487921.a0QJrtikX0@jlieb-e6410> <CALCETrU1g6Dzx=vWUcqkxcfOsb9duCJFPDuah8mrShWe4uEEgw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 27, 2014 12:45:30 Andy Lutomirski wrote:
> On Thu, Mar 27, 2014 at 12:30 PM, Jim Lieb <jlieb@panasas.com> wrote:
> > Rather than inline, I'm responding in the context of Jeremy's comments but
> > I have to answer others as well.  It is Jeremy after all who said my baby
> > was ugly ;).
> > 
> > Jeremy is right about overloading "fd".  Maybe I can call it something
> > else
> > but an fd (in implementation) has merit because a creds struct hangs off
> > of
> > either/or/both task_struct and file but nothing else.  Coming up with a
> > creds token struct adds/intros another struct to the kernel that has to
> > justify its existence.  This fd points to an anon inode so the resource
> > consumption is pretty low and all the paths for managing it are well
> > known and *work*.  I'm trying to get across the swamp, not build a new
> > Golden Gate bridge...
> > 
> > As for POSIX, all of the pthreads API was based on CDE threads whose
> > initial implementation was on Ultrix (BSD 4.2).  Process wide was assumed
> > because utheeads was a user space hack and setuid was process wide
> > because a proc was a just that.  Good grief, that kernel was UP...  When
> > OSF/1 appeared, the Mach 2.5 kernel just carried that forward with its
> > proc + thread(s) model to be compatible with the old world.  In other
> > words, we incrementally backed ourselves into a corner.  Declaring POSIX
> > now avoids admitting that we didn't see all that far into the future. 
> > Enough said.  These calls are *outside* POSIX.  Pthreads in 2014 is
> > broken/obsolete.
> > 
> > For the interface, I changed it from what is in the cited lkml below.   It
> > is> 
> > now:
> >    int switch_creds(struct user_creds *creds);
> 
> What is struct user_creds?  And why is this called switch_creds?  It
> doesn't switch anything.

Sorry, it was in the cited lkml... It is:

struct user_creds {
	uid_t fsuid;
	gid_t fsgid;
	int ngroups;
	gid_t altgroups[];
};

ngroups is limited by NGROUPS.

It is called switch_creds because it does switch them to the contents of 
creds.  When you return from switch_creds "bob" your fsuid is "Bob".  The 
return value is a handle to those creds so the next time you need to be "Bob" 
you can just:

     use_creds(bob_creds);

> 
> > Behavior is the same except the mux'd syscall idea is gone.  Adding a
> > flags arg to this is a useful idea both for current use and future
> > proofing the API.  But this requires a second call
> > 
> >    int use_creds(int fd);
> > 
> > This call does the "use an fd" case but adds -1 to revert to real creds. 
> > Its guts are either an override_creds(fd->file->creds) or a
> > revert_creds().  Nice and quick.  Note that use_creds(fd) is used if I
> > have cached the fd/token from switch_creds().  Also nice and quick.
> > 
> > Given that I've done the checking in switch_creds and I don't pass
> > anything
> > back other than the token/fd and this token/fd is/will be confined to the
> > thread group, use_creds(fd) only needs to validate that it is a
> > switch_creds one, not from an arbitrary open().  I do this.
> 
> Not so fast...  what if you start privileged, create a cred fd, call
> unshare, do a dyntransition, chroot, drop privileges, and call
> use_creds?  I don't immediately see why this is insecure, but having
> it be secure seems to be more or less the same condition as having my
> credfd_activate be secure.
> 
> And I still don't see why you need revert at all.  Just create a
> second token/fd/whatever representing your initial creds and switch to
> that.

The creds you get have also had the capabilities reduced.  You can't do a 
chroot because it will EPERM.  Same with a lot of others.  This is a 
restricted file access jail in itself.  We *reduce* privs+caps here.

The use_creds has a shortcut of -1 to revert to real creds.  So if you do a 
series of these, how do you get back to your priv'd state?  You can either 
keep track of that yourself or just pass in -1 to use_creds() and know you 
are...
> 
> > I have focused this down to "fsuid" because I intend this for ops that
> > file
> > perms.  Other stuff is out of scope unless someone can come up with a use
> > case and add flag defs...  The other variations on the theme uid, euid,
> > and that other one I don't understand the use for, are for long lasting
> > creds change, i.e. become user "bob" and go off an fork a shell...  I am
> > wrapping I/O.
> Isn't there euid for that?

Right.  A crappy interface given that creds are really more than just euid or 
even egid but it does that deed just fine.  It is for long term as in "become 
Dave and run this program..."  I don't change that.  I'm dealing with "As Bob, 
do a pwrite(s)+fstat" across N cores and M ops per core...

> 
> > I do not like the idea of spinning off a separate proc to do creds work. 
> > It doesn't buy anything in performance (everybody is a task to the
> > kernel) but it does open a door to scary places.  Jeremy and I agree that
> > this token/fd must stay within the thread group, aka, process.  I have
> > already (in the newer patchset) tied off inheritance by opening the anon
> > fd with close-on-exec.  I think I tied off passing the fd thru a unix
> > socket but if not, I will in my next submission.  This fd/token should
> > stay within the thread group, period.
> Maybe I'm uniquely not scared of adding sane interfaces.  setuid(2) is
> insane.  Impersonating a token is quite sane and even has lots of
> prior art.
> 
> > As to the "get an fd and then do set*id", you have to do this twice
> > because
> > that fd gets the creds at the time of open, not after fooling around.  I
> > am
> > trying to avoid multiple RCU cycles, not add more.  Second, the above path
> > makes the creds switch atomic because I use the creds swapping
> > infrastructure. Popping back up to user space before that *all* happens
> > opens all kinds of ptrace+signal+??? holes.
> 
> I assume you're planning on caching these things.  So spending some
> cycles setting this thing up shouldn't matter much.

Indeed.  NFS usage patterns as such that the RCU overhead (1 instead of 6) is 
more than fine given that the "untar" the user is doing first LOOKUP, LOOKUP, 
OPEN followed by a boatload of WRITEs.

> 
> If you want to add a totally separate syscall
> setresfsuidgidgroupscaps, be my guest :)  It would actually be
> generally useful.
> 
> > Note also that I mask caps as well in the override creds including the
> > caps to do things like set*id.  That is intentional.  This whole idea is
> > to constrain the thread, not open a door *but* still provide a way to get
> > back home (safely).  That is via use_creds(-1).
> > 
> > Some have proposed that we personalize a worker thread (the rpc op
> > processor) to the creds of the client user right off.  Ganesha only needs
> > to do this user creds work for VFS (kernel local) filesystems.  Most of
> > our cluster filesystems have apis that allow us to pass creds directly on
> > calls.  We only need this for that local mounted namespace.  The server
> > core owns rpc and ops, the backend (FSAL) owns the shim layer.  User
> > creds are backend...  Having a personalized thread complicates the core.
> > 
> > As I mentioned at LSF, I have another set pending that needs a bit more
> > polish to answer issues from the last cycle.  I need to fix the issue of
> > handling syscalls that would do their own creds swapping inside the
> > switch_creds ... use_creds(-1) region.  The patch causes these syscalls,
> > e.g. setuid() to EPERM.  Again, I like this because I want the client
> > creds impersonating thread to only be able to do I/O, not escape into the
> > wild.
> 
> Eek!  You want this for I/O.  What if someone else wants it for
> something else?  Any where does the actual list of what syscalls get
> blocked come from?

The "blocked" list is twofold.  First, any syscall that needs privs that I 
have explicitly given up here (see the nfs_setuser caps that knfsd masks)
The second is, with the new patches, any syscall that ends up doing a 
commit_creds().  That is, in general, all the set*id/groups calls, anything 
messing with keys, execve, fork, and security twiddling code.  The more I 
think about this, it is a good thing.  They would return EPERM which for my 
use case wouldn't happen but for exploit attempts it slams the door with a 
clean error.

> 
> I think that your patches will get a *lot* simpler if you get rid of
> this override_creds and revert stuff and just switch the entire set of
> creds.  No setuid blocking, no BUG, and no need to audit the whole
> tree for odd real_creds uses.

I really do want override.  Otherwise, it is an RCU and I can get into a 
position where I can't revert leaving me with the even worse situation of 
doing a thread exit because it is no good for anything else anymore.

As for someone else coming up with a new use case, sure, we can think about 
this.  One idea has been proposed to have a flags arg to spec the "type" of uid 
etc.  If there is motivation for that, I could add a flags arg with only one 
"do fsuid" as its first and, for now, only defined bit.

As for the BUG(task->creds != task->real_creds), this should really be handled 
much earlier and more friendly (EPERM) than oops'ing the task.  That is what 
the promised additional patch does.  I did audit the commit_creds calls to 
come up with the patch and the list above.

> 
> --Andy

-- 
Jim Lieb
Linux Systems Engineer
Panasas Inc.

"If ease of use was the only requirement, we would all be riding tricycles"
- Douglas Engelbart 1925–2013
