Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab3LFKLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 05:11:45 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:58074 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab3LFKLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 05:11:42 -0500
Message-ID: <1386324655.18074.75.camel@localhost.localdomain>
Subject: Re: [PATCH v2] net: handle error more gracefully in socketpair()
From: Yann Droneaud <ydroneaud@opteya.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Yann Droneaud <ydroneaud@opteya.com>
Date: Fri, 06 Dec 2013 11:10:55 +0100
In-Reply-To: <20131205.194355.1677309681391704143.davem@davemloft.net>
References: <1385979146-13825-1-git-send-email-ydroneaud@opteya.com>
	 <20131205.162333.1525865133149454763.davem@davemloft.net>
	 <1386285331.18074.47.camel@localhost.localdomain>
	 <20131205.194355.1677309681391704143.davem@davemloft.net>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 (3.10.2-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

Le jeudi 05 décembre 2013 à 19:43 -0500, David Miller a écrit :
> From: Yann Droneaud <ydroneaud@opteya.com>
> Date: Fri, 06 Dec 2013 00:15:31 +0100
> 
> > AFAIK, using sys_close() seems to be the exception, and writing the file
> > descriptor before installing it is the more or less the norm.
> 
> What other system call in the kernel writes a file descriptor's value
> into the address space of a user process before the file descriptor
> is actually usable?
> 

Some carefully chosen examples:

- recvmsg() through
  - netlink_recvmsg() / unix_dgram_recvmsg() / unix_stream_recvmsg()
  - scm_recv()
  - scm_detach_fds(), scm.c:280
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/net/core/scm.c?id=v3.13-rc2#n280
  - scm_detach_fds_compat(), compat.c:296
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/net/compat.c?id=v3.13-rc2#n296

- pipe() / pipe2(), pipe.c:969, through
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/pipe.c?id=v3.13-rc2#n969
  - __do_pipe_flags, pipe.c:919
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/pipe.c?id=v3.13-rc2#n919


> That's really terrible semantically.

In fact, it's better:

1) get_unused_fd_flags() mark a file descriptor as 'reserved',
   so no other syscall would be able to allocate it.

   At this point, even if another userspace thread guess the correct
   file descriptor number, trying to use it will give it -EBADFD,
   since the file descriptor is not tied to a file (see __close_fd(), 
   open.c:589 for example)

2) file descriptor is wrote in userspace memory, using 
   put_user()/copy_to_user().

   At this point, the userspace (another thread) could potentially
   read the memory location and use the file descriptor, but here
   again, it will give -EBADFD for the very same reason.

3) fd_install() link the file descriptor to the file.

   Now, the userspace (another thread) could read the memory location
   and use the file descriptor even if the syscall which create it 
   haven't return to the userspace caller yet.

If we arrange to put the call to fd_install() in the very last step
of the syscall, the window where the file descriptor is usable by
userspace but not yet validly returned to userspace is very tiny.

In the other hand, when writing the file descriptor in the last step,
eg. doing 1), 3) and 2), it makes possible for userspace to guess and
manipulate the file descriptor while the syscall is not near completion,
eg. kernel could have some things to do on the file, device, socket, ...
before returning to userspace.
In such case, bad things might happen if another userspace thread is
trying to play a bad game with the file descriptor.
BTW I'm not aware of any security implication of this issue, but I think
it's better (safer) to have fd_install() being the very last step of a
syscall. It should be the default good habit when dealing with file
descriptor creation.

Regards.

-- 
Yann Droneaud
OPTEYA


