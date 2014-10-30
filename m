Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934364AbaJ3KQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:16:00 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:50746 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936AbaJ3KP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:15:56 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.172.182]
In-Reply-To: <87bnourxx4.fsf@x220.int.ebiederm.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrWrxc8foPYbRPtxwNX0sHK_=vLFLDXXyXu+2U2=B+=qCQ@mail.gmail.com>
 <20141029222729.GB8129@kroah.com> <CALCETrVxvF2ie=vVgpjeqikn+nci_9jyKfU4s3t=4cjyNZNaNQ@mail.gmail.com>
 <87bnourxx4.fsf@x220.int.ebiederm.org>
From: Tom Gundersen <teg@jklm.no>
Date: Thu, 30 Oct 2014 11:15:35 +0100
Message-ID: <CAG-2HqUChohNrRSdXzckSiv8ZUYwFLMvRTc41Uo7-b-qmkSFMQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] Add kdbus implementation
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>,
        Daniel Mack <daniel@zonque.org>, alban.crequy@collabora.co.uk,
        javier.martinez@collabora.co.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Thu, Oct 30, 2014 at 5:20 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> The userspace API breaks userspace in an unfixable way.
>
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Problem the first.
> - Using global names for containers makes it impossible to create
>   unprivileged containers.

I don't follow.

Just so we are on the same page:
  - creating a domain per container is only a convention, and has to
be done manually. I.e., the worst case scenario is that you are able
to create some container which cannot get a corresponding kdbus
domain.
  - domain names are only unique per parent-domain, and domains are
fully recursive. We explicitly tested recursive domains by running
kdbus-enabled containers within kdbus-enabled containers, a number of
iterations deep.

Could you explain the problem you see in more detail? This might just
be a documenation issue, after all.

>   This is a back to the drawing board problem, and makes device
>   nodes fundamentally unsuited to what you are doing.
>
>   There is no way that I can see to make it safe for an unprivileged
>   user to create arbitrary named busses.  Especially in the presence
>   of allowing unprivileged checkpoint/restart.

Note that unprivileged users cannot create arbitrary named busses, the
names must have the format $PID-<arbitrary name>. Do you see a problem
with this?

>   This is particularly bad as kdbus explicitly allows unprivielged
>   creation of new kdbus instances.

What do you mean by kdbus instance? A new domain? This is not allowed
by unprivileged processes. Or do you mean a new bus, in which case see
above.

>   This problem is a userspace regression.

This is all new functionality, how does it affect current code?

> Problem the second.
> - The security checks in the code are not based on who opens the
>   file descriptors but instead based on who is used the file
>   descriptors at any give moment.
>
>   That pattern has been shown to be exploitable.
>
>   I expect the policy database makes this poor choice of permission
>   checks even worse.  Pass a more privileged user a kdbus file
>   descriptor and all of sudden things that were not possible on
>   that file descriptor become possible.

Djalal already commented on this point in another thread. But just to
recap: Please note that we do not do read()/write() at all, only
ioctl's, so the most common exploits do not apply. Moreover, we are
following the same API pattern as used by other similar APIs in the
kernel. With that in mind, could you give some more specific
information about what kind of exploits you imagine?

> Problem the third.
> - You are using device numbers for things created by unprivileged
>   users.  That breaks checkpoint/restart.  Aka CRIU.
>
>   We can not migrate a container to a new machine and preserve the
>   device numbers.

I must admit to not being too familiar with checkpoint/restart. What
precisely is the problem with unprivileged users?

>   We can not migrate a container to a new machine and have any hope
>   of preserving the container patsh under /dev/kdbus/...

You may not be able to preserve the full path, no, but the container
should not know/care about the parent paths anyway.  Note that the
containers only see their own domain subtree mounted to /dev/kdbus,
they see nothing from the parent. Hence when you migrate containers
you can change the naming of the parent freely, but the processes
inside the containers won't see that, they'll have stable paths.   I'm
not seeing the problem here, care to elaborate?

> I think a kdbusfs modeled on devpts with newinstance at
> mount time would solve the naming problems.

Effectively, what we have in place in the current patch set delivers
similar semantics, however without introducing a new file system. You
just create a new domain and get a new subdir in /dev/kdbus/ for it,
and then inside the container you mount that subdir of /dev/kdbus onto
/dev/kdbus itself.

Do I understand you correctly that what you want is unnamed/anonymous
domains? Considering that domain creation is anyway privileged, why is
this necessary?

> That would break one of the current kdbus use cases that allows an
> unprivileged user to create a bus.

That is a fundamental usecase, so I don't think it makes much sense to
do anything that precludes that.

Cheers,

Tom
