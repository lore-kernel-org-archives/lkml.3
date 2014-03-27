Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaC0BBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 21:01:37 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:52382 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbaC0BBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 21:01:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140327004225.GA20247@sergelap>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
 <20140327004225.GA20247@sergelap>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 26 Mar 2014 18:01:14 -0700
Message-ID: <CALCETrUtRzViEYUNev1JNFZMms56uiw47YZezak0Z0PKgFneQA@mail.gmail.com>
Subject: Re: Thoughts on credential switching
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Jim Lieb <jlieb@panasas.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com, Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 5:42 PM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> Quoting Andy Lutomirski (luto@amacapital.net):
>> Hi various people who care about user-space NFS servers and/or
>> security-relevant APIs.
>>
>> I propose the following set of new syscalls:
>>
>> int credfd_create(unsigned int flags): returns a new credfd that
>> corresponds to current's creds.
>>
>> int credfd_activate(int fd, unsigned int flags): Change current's
>> creds to match the creds stored in fd.  To be clear, this changes both
>> the "subjective" and "objective" (aka real_cred and cred) because
>> there aren't any real semantics for what happens when userspace code
>> runs with real_cred != cred.
>
> Is there a URL where I can find the motivation, and why the existing
> features can't be used?

It was an LSF talk.  There's this, though:

http://thread.gmane.org/gmane.linux.file-systems/79234

Essentially, it's a performance problem.  knfsd has override_creds,
and it can cache struct cred.  But userspace doing the same thing
(i.e. impersonating a user) has to do setresuid, setresgid, and
setgroups, which kills performance, since it results in something like
five RCU callbacks per impersonation round-trip.

Windows has something called an "impersonation token" that more or
less solves this problem.

>
> My guess would be, uid 100000 is root in a container, and you want
> him to be able to send a request to a root daemon on the host, on
> behalf of uid 100005 in the container, over which 100000 has
> privilege.  (Which is sort of what we need for the cgmanager proxy;
> there we do it by checking checking that 100000 is mapped to 0 in
> the requestor's uid_map, and that 100005 is mapped in that uid_map)
> The credfd would be useful there, especially combined with a
> credfd_access(credfd, fd, perms) call.

This requires uid 100005 to send 100000 a credfd, right?

In general, making this same probably requires a way to make it safe
to call credfd_activate on an untrusted credfd.  You don't want to
expose yourself to ptrace or proc attacks from the credential
provider.  Nor do you want to suddenly get hit by rlimits, perhaps.
So maybe there really does need to be a separate subjective and
objective state.  Ugh.

Ganesha can avoid this because the caller of credfd_create is trusted.

>
> But I'd like to hear exactly how nfs and ganesha would use these.

knfsd will presumably not use it.  Ganesha will, and Jim can probably
comment further.  Samba might want to use it, too.

>
> What all would be assiciated with the credfd?  Everything that is
> in the kernel cred?

I assume so.

--Andy

>
>> Rules:
>>
>>  - credfd_activate fails (-EINVAL) if fd is not a credfd.
>>  - credfd_activate fails (-EPERM) if the fd's userns doesn't match
>> current's userns.  credfd_activate is not intended to be a substitute
>> for setns.
>>  - credfd_activate will fail (-EPERM) if LSM does not allow the
>> switch.  This probably needs to be a new selinux action --
>> dyntransition is too restrictive.
>>
>>
>> Optional:
>>  - credfd_create always sets cloexec, because the alternative is silly.
>>  - credfd_activate fails (-EINVAL) if dumpable.  This is because we
>> don't want a privileged daemon to be ptraced while impersonating
>> someone else.
>>  - optional: both credfd_create and credfd_activate fail if
>> !ns_capable(CAP_SYS_ADMIN) or perhaps !capable(CAP_SETUID).
>>
>> The first question: does this solve Ganesha's problem?
>>
>> The second question: is this safe?  I can see two major concerns.  The
>> bigger concern is that having these syscalls available will allow
>> users to exploit things that were previously secure.  For example,
>> maybe some configuration assumes that a task running as uid==1 can't
>> switch to uid==2, even with uid 2's consent.  Similar issues happen
>> with capabilities.  If CAP_SYS_ADMIN is not required, then this is no
>> longer really true.
>>
>> Alternatively, something running as uid == 0 with heavy capability
>> restrictions in a mount namespace (but not a uid namespace) could pass
>> a credfd out of the namespace.  This could break things like Docker
>> pretty badly.  CAP_SYS_ADMIN guards against this to some extent.  But
>> I think that Docker is already totally screwed if a Docker root task
>> can receive an O_DIRECTORY or O_PATH fd out of the container, so it's
>> not entirely clear that the situation is any worse, even without
>> requiring CAP_SYS_ADMIN.
>>
>> The second concern is that it may be difficult to use this correctly.
>> There's a reason that real_cred and cred exist, but it's not really
>> well set up for being used.
>>
>> As a simple way to stay safe, Ganesha could only use credfds that have
>> real_uid == 0.
>>
>> --Andy



-- 
Andy Lutomirski
AMA Capital Management, LLC
