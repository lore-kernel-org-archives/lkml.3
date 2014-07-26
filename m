Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaGZVIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 17:08:19 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:48914 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaGZVIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 17:08:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Drysdale <drysdale@google.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
Date: Sat, 26 Jul 2014 14:04:23 -0700
In-Reply-To: <1406296033-32693-1-git-send-email-drysdale@google.com> (David
	Drysdale's message of "Fri, 25 Jul 2014 14:46:56 +0100")
Message-ID: <871tt796i0.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19/nr2FKQWgMhTwG04rD2rgVpA2zznq/ic=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;David Drysdale <drysdale@google.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCHv2 00/11] Adding FreeBSD's Capsicum security framework
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Drysdale <drysdale@google.com> writes:

> The last couple of versions of FreeBSD (9.x/10.x) have included the
> Capsicum security framework [1], which allows security-aware
> applications to sandbox themselves in a very fine-grained way.  For
> example, OpenSSH now (>= 6.5) uses Capsicum in its FreeBSD version to
> restrict sshd's credentials checking process, to reduce the chances of
> credential leakage.
>
> It would be good to have equivalent functionality in Linux, so I've been
> working on getting the Capsicum framework running in the kernel, and I'd
> appreciate some feedback/opinions on the general approach.
>
> I'm attaching a corresponding draft patchset for reference, but
> hopefully this cover email can cover the significant features to save
> everyone having to look through the code details.  (It does mean this is
> a long email though -- apologies for that.)
>
>
> 1) Capsicum Capabilities
> ------------------------
>
> The most significant aspect of Capsicum is associating *rights* with
> (some) file descriptors, so that the kernel only allows operations on an
> FD if the rights permit it.  This allows userspace applications to
> sandbox themselves by tightly constraining what's allowed with both
> input and outputs; for example, tcpdump might restrict itself so it can
> only read from the network FD, and only write to stdout.
>
> The kernel thus needs to police the rights checks for these file
> descriptors (referred to as 'Capsicum capabilities', completely
> different than POSIX.1e capabilities), and the best place to do this is
> at the points where a file descriptor from userspace is converted to a
> struct file * within the kernel.
>
>   [Policing the rights checks anywhere else, for example at the system
>   call boundary, isn't a good idea because it opens up the possibility
>   of time-of-check/time-of-use (TOCTOU) attacks [2] where FDs are
>   changed (as openat/close/dup2 are allowed in capability mode) between
>   the 'check' at syscall entry and the 'use' at fget() invocation.]
>
> However, this does lead to quite an invasive change to the kernel --
> every invocation of fget() or similar functions (fdget(),
> sockfd_lookup(), user_path_at(),...) needs to be annotated with the
> rights associated with the specific operations that will be performed on
> the struct file.  There are ~100 such invocations that need
> annotation.

And it is silly.  Roughly you just need a locking version of
fcntl(F_SETFL).

That is make the restriction in the struct file not in the fd to file
lookup.

Files in unix have been capabilities for more than 20 years.  That is
what file descriptor passing in unix domain sockets are all about.  We
don't need an additional ``capability rights'' layer on top of file
descriptors.

In fact internal to linux with FMODE_READ and friends we already have
restrictions on which methods are allowed on linux file descriptors.
So this whole entire abstraction layer you are adding seems just plain
broken.

Going farther one huge thing your work and the capsicum work in general
is missing is an implementation of revoke.  With a little care a good
implementation of bits reporting and controlling which methods are
available on which file descriptors should be a good start on
a revoke implementation for linux as well.

> 2) Capsicum Capabilities Data Structure
> ---------------------------------------
>
> Internally, the rights associated with a Capsicum capability FD are
> stored in a special struct file wrapper.  For a normal file, the rights
> check inside fget() falls through, but for a capability wrapper the
> rights in the wrapper are checked and (if capable) the underlying
> wrapped struct file is returned.
>
>   [This is approximately the implementation that was present in FreeBSD
>   9.x.  For FreeBSD 10.x, the wrapper file was removed and the rights
>   associated with a file descriptor are now stored in the fdtable. As
>   that impacts memory use for all processes, whether Capsicum users or
>   not, I've stuck with the FreeBSD 9.x approach.]

I have already mentioned that this is an insane choice of semantics
right?  Adding an extra layer on top of a data structure that is a
perfectly good restrictor of rights.

If you can't add the restriction on struct file itself I would argue
that the semantics of capsicum are fundamentally broken.

I can not imagine why in the world you would want and extra layer of
indirection, complication, and maintenance.

> 3) Allowing Capability Mode
> ---------------------------
>
> Capsicum also includes 'capability mode', which locks down the available
> syscalls so the rights restrictions can't just be bypassed by opening
> new file descriptors.  More precisely, capability mode prevents access
> to syscalls that access global namespaces, such as the filesystem or the
> IP:port space.
>
> The existing seccomp-bpf functionality of the kernel is a good mechanism
> for implementing capability mode, but there are a few additional details
> that also need to be addressed.
>
>  a) The capability mode filter program needs to apply process-wide, not
>     just to the current thread.
>
>  b) In capability mode, new files can still be opened with openat(2) but
>     only if they are beneath an existing directory file descriptor.

Which raises the question is that worth it?  

>  c) In capability mode it should still be possible for a process to send
>     signals to itself with kill(2)/tgkill(2).

Again is it worth it?

I would think you would want capability mode to default to the minium
set of system calls you could get away with (to keep kernel code
auditing to a minium) and only add things if the performance gain of
using the syscall exceeds the pain.

If you look at a kernel like sel4 it succeeds in with an object
capability model with many fewer system calls than you are proposing
to export.  Roughly just read, write and close.

Consider the fact if you really want a kernel layer you can completely
trust and rely on someone needs to write a formal proof of that layer.
Short of that someone certainly needs to audit the kernel code very
closely so simplicity of semantics and simplicity of implementation are
very important.

> This v2 patchset copes with these as follows:
>
>  a) Kees Cook's incoming seccomp(2) patchset covers thread
>     synchronization of filters.
>
>  b) A new prctl(PR_SET_OPENAT_BENEATH) operation implicitly sets the
>     O_BENEATH flag (see below) for all file-open operations for all
>     threads of the current process, by adding a new openat_beneath
>     flag in task_struct.
>
>  c) An extension to the seccomp_data structure that includes the current
>     task's tid and tgid values allows for BPF programs that check a
>     kill(2)/tgkill(2) argument against the current thread, in a manner
>     that is robust against fork(2)/clone(2).
>
> The combination of these features with the existing seccomp-bpf
> functionality gives the tools needed to implement capability mode.
>
>
> 4) New System Calls
> -------------------
>
> To allow userspace applications to access the Capsicum capability
> functionality, I'm proposing two new system calls: cap_rights_limit(2)
> and cap_rights_get(2).  I guess these could potentially be implemented
> elsewhere (e.g. as fcntl(2) operations?) but the changes seem
> significant enough that new syscalls are warranted.
>
>   [FreeBSD 10.x actually includes six new syscalls for manipulating the
>   rights associated with a Capsicum capability -- the capability rights
>   can police that only specific fcntl(2) or ioctl(2) commands are
>   allowed, and FreeBSD sets these with distinct syscalls.]

ioctls?  In a sandbox?  Ick.

> 5) New openat(2) O_BENEATH Flag
> -------------------------------
>
> For Capsicum capabilities that are directory file descriptors, the
> Capsicum framework only allows openat(cap_dfd, path, ...) operations to
> work for files that are beneath the specified directory (and even that
> only when the directory FD has the CAP_LOOKUP right), rejecting paths
> that start with "/" or include "..".  The same restriction applies
> process-wide for a process in capability mode.
>
> As this seemed like functionality that might be more generally useful,
> I've implemented it independently as a new O_BENEATH flag for openat(2).
> The Capsicum code then always triggers the use of that flag when the dfd
> is a Capsicum capability, or when the prctl(2) command described above
> is in play.
>
>   [FreeBSD has the openat(2) relative-only behaviour for capability DFDs
>   and processes in capability mode, but does not include the O_BENEATH
>   flag.]

If you are going to allow open I would think the simple solution here is
to just create a mount namespace that only has available the files you
would like to export to the process, and force all of the file
descriptors into that mount namespace.

Eric
