Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbaC0AXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:23:47 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:48373 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaC0AXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:23:45 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 26 Mar 2014 17:23:24 -0700
Message-ID: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
Subject: Thoughts on credential switching
To: Jim Lieb <jlieb@panasas.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
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

Hi various people who care about user-space NFS servers and/or
security-relevant APIs.

I propose the following set of new syscalls:

int credfd_create(unsigned int flags): returns a new credfd that
corresponds to current's creds.

int credfd_activate(int fd, unsigned int flags): Change current's
creds to match the creds stored in fd.  To be clear, this changes both
the "subjective" and "objective" (aka real_cred and cred) because
there aren't any real semantics for what happens when userspace code
runs with real_cred != cred.

Rules:

 - credfd_activate fails (-EINVAL) if fd is not a credfd.
 - credfd_activate fails (-EPERM) if the fd's userns doesn't match
current's userns.  credfd_activate is not intended to be a substitute
for setns.
 - credfd_activate will fail (-EPERM) if LSM does not allow the
switch.  This probably needs to be a new selinux action --
dyntransition is too restrictive.


Optional:
 - credfd_create always sets cloexec, because the alternative is silly.
 - credfd_activate fails (-EINVAL) if dumpable.  This is because we
don't want a privileged daemon to be ptraced while impersonating
someone else.
 - optional: both credfd_create and credfd_activate fail if
!ns_capable(CAP_SYS_ADMIN) or perhaps !capable(CAP_SETUID).

The first question: does this solve Ganesha's problem?

The second question: is this safe?  I can see two major concerns.  The
bigger concern is that having these syscalls available will allow
users to exploit things that were previously secure.  For example,
maybe some configuration assumes that a task running as uid==1 can't
switch to uid==2, even with uid 2's consent.  Similar issues happen
with capabilities.  If CAP_SYS_ADMIN is not required, then this is no
longer really true.

Alternatively, something running as uid == 0 with heavy capability
restrictions in a mount namespace (but not a uid namespace) could pass
a credfd out of the namespace.  This could break things like Docker
pretty badly.  CAP_SYS_ADMIN guards against this to some extent.  But
I think that Docker is already totally screwed if a Docker root task
can receive an O_DIRECTORY or O_PATH fd out of the container, so it's
not entirely clear that the situation is any worse, even without
requiring CAP_SYS_ADMIN.

The second concern is that it may be difficult to use this correctly.
There's a reason that real_cred and cred exist, but it's not really
well set up for being used.

As a simple way to stay safe, Ganesha could only use credfds that have
real_uid == 0.

--Andy
