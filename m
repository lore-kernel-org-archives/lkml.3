Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbaLBEfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:35:31 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:46793 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaLBEfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:35:30 -0500
From: Alex Dubov <alex.dubov@gmail.com>
X-Google-Original-From: Alex Dubov <oakad@yahoo.com>
To: linux-kernel@vger.kernel.org
Cc: alex.dubov@gmail.com
Subject: Minimal effort/low overhead file descriptor duplication over Posix.1b s
Date: Tue,  2 Dec 2014 15:35:17 +1100
Message-Id: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A common requirement in parallel processing applications (relied upon by
popular network servers, databases and various other applications) is to
pass open file descriptors between processes. Historically, several mechanisms
existed to support this requirement, such as those provided by "cmsg" facility
of unix domain sockets or special operations on named pipes (on Android this
can also be achieved using "binder" facility).

Unfortunately, using facilities like Unix domain sockets to merely pass file
descriptors between "worker" processes is unnecessarily difficult, due to
the following common consideration:

1. Domain sockets and named pipes are persistent objects. Applications must
manage their lifetime and devise unambiguous access schemes in case multiple
application instances are to be run within the same OS instance. Usually, they
would also require a writable file system to be mounted.

2. Interaction with domain sockets and named pipes requires a sizable,
non-trivial and error-prone code on the application side, especially in
cases where multiple worker types started by multiple application instances
must coexist within the same OS instance.

3. Domain sockets and pipes require creation of complex kernel-side set-ups,
whereupon, in many cases, the only information ever passed by the application
over those channels are file descriptors (it is usual for the major part of the
application's shared state to be established through other mechanisms,
like shared memory). In some cases, applications are forced to send meaningless
rubbish over the domain socket merely to "push" the associated "cmsg" carrying
the file descriptor through.

Present patch introduces exceptionally easy to use, low latency and low
overhead mechanism for transferring file descriptors between cooperating
processes:

    int sendfd(pid_t pid, int sig, int fd)

Given a target process pid, the sendfd() syscall will create a duplicate
file descriptor in a target task's (referred by pid) file table pointing to
the file references by descriptor fd. Then, it will attempt to notify the
target task by issuing a Posix.1b real-time signal (sig), carrying the new
file descriptor as integer payload. If real-time signal can not be enqueued
at the destination signal queue, the newly created file descriptor will be
promptly closed.

It is believed, that proposed sendfd() syscall, together with recently
accepted "memfd" facility may greatly simplify development of parallel
processing applications, by eliminating the need to rely on tricky and
possibly insecure approaches involving domain sockets and such.

