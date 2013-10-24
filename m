Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3JXUOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 16:14:19 -0400
Received: from static-209-166-131-148.expedient.com ([209.166.131.148]:59180
	"EHLO natasha.panasas.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755722Ab3JXUOC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 16:14:02 -0400
X-Greylist: delayed 4137 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Oct 2013 16:14:01 EDT
From: Jim Lieb <jlieb@panasas.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>,
        <tytso@mit.edu>, <viro@zeniv.linux.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bfields@redhat.com>, <jlayton@redhat.com>
Subject: Re: Re: [PATCH 1/3] switch_creds:  Syscall to switch creds for file server ops
Date: Thu, 24 Oct 2013 12:04:38 -0700
Message-ID: <2143620.4IRQt66LHH@jlieb-e6410>
Organization: Panasas Inc.
User-Agent: KMail/4.11.2 (Linux/3.11.4-201.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <8761snb44l.fsf@xmission.com>
References: <1381960919-4542-1-git-send-email-jlieb@panasas.com> <52687468.3060206@mit.edu> <8761snb44l.fsf@xmission.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 23, 2013 22:59:54 Eric W. Biederman wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
> > On 10/16/2013 08:52 PM, Eric W. Biederman wrote:
> >> Al Viro <viro@ZenIV.linux.org.uk> writes:
> >>> On Wed, Oct 16, 2013 at 06:18:16PM -0700, Eric W. Biederman wrote:
> >>>> That doesn't look bad but it does need capable(CAP_SETUID) &&
> >>>> capable(CAP_SETGID) or possibly something a little more refined.
> >>> 
> >>> D'oh
> >>> 
> >>>> I don't think we want file descriptor passing to all of a sudden become
> >>>> a grant of privilege, beyond what the passed fd can do.
> >>> 
> >>> Definitely.  And an extra ) to make it compile wouldn't hurt either...
> >> 
> >> There also appears to need to be a check that we don't gain any
> >> capabilities.
> >> 
> >> We also need a check so that you don't gain any capabilities, and
> >> possibly a few other things.

My original api does not pass any caps however, the code in setting up the new 
creds does mask off a number of them in the effective set, the same set that 
knfsd does.  So all I can do is reduce, not extend.  We need to reduce caps 
because without that, quotas and access get bypassed.  If I do the generic (4 
syscalls), this opens up lots of options for setting things which is not my 
need or intent.

> > 
> > Why?  I like the user_ns part, but I'm not immediately seeing the issue
> > with capabilities.

As for name spaces, we don't have much interest here for two reasons.

1. if the server does run under a different namespace, so be it. The syscall 
does make those translations.  If you want to firewall off the service and its 
exports, fine.

2. in our main use case, nfs-ganesha is running as a pNFS metadata server and 
its uid namespace comes from somewhere else (krb5 etc.) anyway.  The kernel 
etc. it is running on is completely separate, a black box with its own 
nsswitch options, probably local only with only a small set of admin entries.

Just to be clear, if there is any mapping between uids within the ganesha env 
and the local env (an nfs server that is also an app server), all of the above 
applies assuming the nsswitch/idmapper/ipa is set up properly.  The how that 
happens is outside scope at this level.
> 
> My reasoning was instead of making this syscall as generic as possible
> start it out by only allowing the cases Jim cares about and working with
> a model where you can't gain any permissions you couldn't gain
> otherwise.

Right.  That is my intent, to do the same as nfsd_setuser.  We need to 
impersonate the user at the client per the creds we get from the appropriate 
authentication service and to only do it for file access, nothing more.  The 
api I chose allows later extension but only supports what we need now.

I looked at the case of a setuid or seteuid with this and the use case is 
NFS/CIFS/9P/... user space file servers.  That is why I originally chose an 
evil multiplexed call.  I could split it into two or three syscalls but my 
intent in either api is to have a restricted set of creds.  There is a 
(potential) new use case in NFSv4.2 labels where we will also have to shove 
those down as well, adding another variant.  We've got to pass them in somehow 
and the set*uid mess is an example of the other way.  The setuid family used 
to be pretty simple (just two syscalls) but not anymore.  At least this is an 
extensible model that is consistent and returns useful things like EPERM 
rather than an "alternate" uid/gid that must be interpreted to find the error.

I could also restructure the api to have a typed argument.  One early pass had 
a struct that had everything in it, the op, the fd, and the creds but that has 
the pitfall of now freezing the whole api at the syscall entry point. If v4.2 
labels or CIFS SIDs must be passed in future, there would be no alternative 
but yet another syscall.   I do validate the arg.  The unsigned long does pass 
32/64.  The typedefs in the struct match what is used by the other syscalls.  
Our server uses the same typedefs internally so the usual porting issues look 
minimal (and the same as the setfsuid+setfsgid+setgroups it replaces).

I was also trying to cut down on the number of RCU cleanups here.  This is 
what nfsd_setuser already does.  Caching via using an fd as a handle to the 
kernel resource is good and lightweight  but our server under load will have 
to shed "creds" fds before I/O fds (for lock reasons) and that means the 
nfsd_setuser method of setting fsuid, fsgid, altgroups, and restricted caps 
could be the common path under load.  RCU is cheaper but it is not cheap and 
I'd really prefer to not have the fallback make matters worse.

Our use case is a meta-data server part of pNFS server, in particular, pNFS in 
a clustered env.  This means a higher metadata load where these switches have 
real cost.
> 
> Although the fd -1 trick to revert to your other existing cred seems
> reasonable.

In my revised api idea, I would still need the revert especially with multiple 
set* calls that have failure paths.  I may not know what was left so a full 
reset to real is the safest choice in the error path.  It is also cheap(er) in 
the post- file operation return path.

> 
> >> So I suspect we want a check something like:
> >> 
> >> if ((new_cred->securebits != current_cred->securebits)  ||
> >> 
> >>     (new_cred->cap_inheritable != current_cred->cap_inheritable) ||
> >>     (new_cred->cap_permitted != current_cred->cap_permitted) ||
> >>     (new_cred->cap_effective != current_cred->cap_effective) ||
> >>     (new_cred->cap_bset != current_cred->cap_bset) ||
> >>     (new_cred->jit_keyring != current_cred->jit_keyring) ||
> >>     (new_cred->session_keyring != current_cred->session_keyring) ||
> >>     (new_cred->process_keyring != current_cred->process_keyring) ||
> >>     (new_cred->thread_keyring != current_cred->thread_keyring) ||
> >>     (new_cred->request_keyring != current_cred->request_keyring) ||
> >>     (new_cred->security != current_cred->security) ||
> >>     (new_cred->user_ns != current_cred->user_ns)) {
> >> 	
> >> 	return -EPERM;
> >> 
> >> }
> > 
> > I *really* don't like the idea of being able to use any old file
> > descriptor.  I barely care what rights the caller needs to have to
> > invoke this -- if you're going to pass an fd that grants a capability
> > (in the non-Linux sense of the work), please make sure that the sender
> > actually wants that behavior.
> > 
> > IOW, have a syscall to generate a special fd for this purpose.  It's
> > only a couple lines of code, and I think we'll really regret it if we
> > fsck this up.
> > 
> > (I will take it as a personal challenge to find at least one exploitable
> > privilege escalation in this if an arbitrary fd works.)
> 
> If you can't switch to a uid or a gid you couldn't switch to otherwise
> then the worst that can happen is an information leak.  And information
> leaks are rarely directly exploitable.
> 
> > Also... real_cred looks confusing.  AFAICS it is used *only* for knfsd
> > and faccessat.  That is, current userspace can't see it.  But now you'll
> > expose various oddities.  For example, AFAICS a capability-less process
> > that's a userns owner can always use setuid.  This will *overwrite*
> > real_cred.  Then you're screwed, especially if this happens by
> > accident.
> 
> And doing in userland what faccessat, and knfsd do in the kernel is
> exactly what is desired here.  But maybe there are issues with that.
> 
> > That being said, Windows has had functions like this for a long time.
> > Processes have a primary token and possibly an impersonation token.  Any
> > process can call ImpersonateLoggedOnUser (no privilege required) to
> > impersonate the credentials of a token (which is special kind of fd).
> > Similarly, any process can call RevertToSelf to undo it.
> > 
> > Is there any actual problem with allowing completely unprivileged tasks
> > to switch to one of these magic cred fds?  That would avoid needing a
> > "revert" operation.
> 
> If the permission model is this switching of credentials doesn't get you
> anything you couldn't get some other way.  That would seem to totally
> rules out unprivileged processes switching these things.
> 
> > Another note: I think that there may be issues if the creator of a token
> > has no_new_privs set and the user doesn't.  Imagine a daemon that
> > accepts one of these fds, impersonates it, and calls exec.  This could
> > be used to escape from no_new_privs land.
> 
> Which is why I was suggesting that we don't allow changing any field in
> the cred except for uids and gids.

Yes.  Which is why in my original patch I pass a user_creds structure that 
only has the fsuid, fsgid, and altgroups.  This means that the caller can 
*only* impersonate these particular creds for purposes of file access, not priv 
escalation.

As for magic fds, I didn't have but should add to the perms check a test to 
validate that the passed fd is one of our "magic" ones.    The other users of 
anon fds do a similar test to verify that the fd is one that they gave you. 
This check would prevent the using of a random open of /dev/null with unknown 
caps/creds because it would throw an error, preventing an escalation.  This fd 
is also opened with O_CLOEXEC so children don't get it.   Our use case doesn't 
need to fork/exec and if we needed to, we wouldn't be using switch_creds for 
it anyway.  Adding Close-on-exec removes the exploit opportunity.

Jim

> 
> Eric

-- 
Jim Lieb
Linux Systems Engineer
Panasas Inc.

"If ease of use was the only requirement, we would all be riding tricycles"
- Douglas Engelbart 1925–2013
