Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbaLBP0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:26:47 -0500
Received: from tex.lwn.net ([70.33.254.29]:60217 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbaLBP0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:26:34 -0500
Date: Tue, 2 Dec 2014 10:26:32 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Alex Dubov <alex.dubov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: Minimal effort/low overhead file descriptor duplication over
 Posix.1b s
Message-ID: <20141202102632.6ae37b88@lwn.net>
In-Reply-To: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Dec 2014 15:35:17 +1100
Alex Dubov <alex.dubov@gmail.com> wrote:

>     int sendfd(pid_t pid, int sig, int fd)
> 
> Given a target process pid, the sendfd() syscall will create a duplicate
> file descriptor in a target task's (referred by pid) file table pointing to
> the file references by descriptor fd. Then, it will attempt to notify the
> target task by issuing a Posix.1b real-time signal (sig), carrying the new
> file descriptor as integer payload. If real-time signal can not be enqueued
> at the destination signal queue, the newly created file descriptor will be
> promptly closed.

[ CC += linux-api ]

So I'm not a syscall API design expert, but this one raises a few
questions with me.

 - Messing with another process's file descriptor table without its
   knowledge looks like a possible source of all kinds problems.  Might
   there be race conditions with close()/dup() code, for example?  And
   remember that users can be root in a user namespace; maybe there's no
   potential for mischief there, but it needs to be considered.

 - Forcing the use of realtime signals seems strange; this isn't a
   realtime operation by any stretch.

 - How might the sending process communicate to the recipient what the fd
   is for?  Even if a process only expects one type of file descriptor,
   the ability to communicate information other than its number seems
   like it would often be useful.

Some of these concerns might be addressable by requiring the recipient to
call acceptfd() (or some such) with the ability to use poll().  As an
alternative, I believe kdbus has fd-passing abilities; if kdbus goes in,
would you still need this feature?

Thanks,

jon
