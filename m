Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbaA0TuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:50:24 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:39979 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbaA0TuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:50:22 -0500
From: "Network Nut" <sillystack@gmail.com>
To: "'Clemens Ladisch'" <clemens@ladisch.de>
Cc: <linux-kernel@vger.kernel.org>
References: <00d901cf1a19$0ea62db0$2bf28910$@gmail.com> <52E554EC.3090900@ladisch.de> <012d01cf1ae3$6543e340$2fcba9c0$@gmail.com> <52E6219A.3020405@ladisch.de>
In-Reply-To: <52E6219A.3020405@ladisch.de>
Subject: RE: WaitForMultipleObjects/etc. In Kernel
Date: Mon, 27 Jan 2014 13:50:19 -0600
Message-ID: <00d001cf1b99$026407d0$072c1770$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQNT3acP/4y+UoGLob+8VizidhBl0AFz54/xAX6FO6UBfOQBmZdr389A
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Unrelated processes cannot directly open objects created by another
> process (with the exception of sockets and pipes, which can be created in
> the file system).  However, sharing of any file descriptor is possible by
> sending it in a control message through a Unix domain socket.

I just spent a bit more time snooping around the Internet to see what is
possible and what is not.

My gut feeling, before trying to port my application from Windows to Linux,
was that I have been using (enjoying) synchronization primitives on Windows
that are fundamental to generalized-synchronization. Most importantly, as I
mentioned initially, I do not believe that I am victim of tunnel-vision,
where my familiarity with a particular OS has biased my perception of how
synchronization should be done. On the contrary, knowing what I know about
synchronization now, if it were left to me to design a Generalized
Synchronization Model for an OS kernel from scratch, without regard for
pre-existing OS's, the model that I would devise would probably look very
similar to what the Windows engineers  did. I feel a bit bad saying this, as
my intent here is not to take a stab at Linux's synchronization model. It's
to say...I feel that I am struggling to synthesize what I regard as a
"regular model" from bits and pieces on Linux. I am convinced that, if I
were going in the other direction, from Linux to Windows, I would not have
any problem recreating, under Windows, whatever model I had been using under
Linux.

That said, I really do need to have multiple threads, each within their
respective processes, P1:T1, P2:T2, ...Pn:Tn; all blocking on what are
effectively potentially globally-named synchronization primitives
(semaphore, mutex event)...and...ideally...as each thread blocks against
multiple, potentially-named primitives, there is an option for the master
blocking function [epoll_wait, in this case], to time-out, with the
expiration for time-out being specified as an argument to the function. And
to make matters worse, sometimes, while blocking on {semaphore + event +
event +....}, I need to block, simultaneously, on asynchronous I/O.

So what I know so far is that, if my problem is to be solved:

1. epoll/epoll_wait/etc. will definitely be part of it (Thanks!)
2. I am OK with timerfd and eventfd (Thanks!)
3. Other synchronization primitives will have to be accessible vial
file-descriptor.
4. If epoll_wait is to block on asynchronous I/O, use io_set_eventfd  to
bind completion of asynchronous I/O to signaling of an eventfd
5. I can simulate system-global named mutex using shared-memory for
underlying state of mutex (POCO NamedMutex)
6. I can get named semaphore using POSIX sem_create 

It seems that the remaining problem is to get named mutex and named
semaphore to be accessible by file-descriptor.

> > BTW, the man page for epoll_wait seems to be incorrect.
> 
> <https://www.kernel.org/doc/man-pages/reporting_bugs.html>
> 
> > "The timeout argument specifies the minimum number of milliseconds
> >        that epoll_wait() will block."
> >
> > I think the word "minimum" should be "maximum".
> 
> This sentence was copied from the poll(2) man page, where the previous
> sentence says "poll() blocks until one of the events occurs".  So the word
> "block" implies that no event has occured.

So that means that it is a bug, right? Or?

Regards,

-Nut

