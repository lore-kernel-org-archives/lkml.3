Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbaGYCgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 22:36:36 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:59629 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022AbaGYCge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 22:36:34 -0400
MIME-Version: 1.0
Date: Thu, 24 Jul 2014 22:36:33 -0400
Message-ID: <CANP1eJGE=vQBdLnMBFPcTWrvh+dUA-UCK=ugO-tc2KN4LWLPSA@mail.gmail.com>
Subject: read()/readv() only from page cache
From: Milosz Tanski <milosz@adfin.com>
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel,

I've been following your recent work with the postgres folks to
improve the kernel for postgres like workloads (which can really help
all database like loads).

After spending some time of my own fighting similar problems I figured
I'd reach out to see if there's something that can be done that can
make my use case easier. I was wondering if there is a read family
syscall that allows me to read from a file descriptor only if the data
is in the page cache (or only the portion of the data is in the page
cache).

The way my userspace application (database like system) is divided is
three kinds of threads. There's threads for dealing with processing of
data and IO threads (mostly for reading data). There's also threads
for dealing with networking (epoll) but that's not interesting.

What I would like to be able to do is a issue a read call in the
processing thread to get more data ... if it exists in the page cache.
If it doesn't then I would end up queuing that work to the IO threads.
Today as it stands I always have to queue up the work to the IO
threads and I end up paying for the message passing (and
synchronization) for case where it's a simple page cache to userspace
buffer memcpy. Add kernel readahead to my example and it's a pretty
big win.

I'm not the only person who laments this kind of facility. Other folks
have also been frustrated by lack of being able to tell if this read
will block or not.
http://www.1024cores.net/home/scalable-architecture/parallel-disk-io/the-solution

The sad part is that we do have similar syscall that handles none-file
fds like recvmsg() where you can specify O_NOBLOCK and have it return
if there's no data in the buffer. Sadly it doesn't work for regular
files.

I understand that there is a mincore() syscall but in this case it's
not useful since it requires an extra syscall and

Is there any kind of facility / solution for my problem that I can
leverage in the Linux kernel? Linus is always adamant about working
with the page cache versus working against the page cache and in this
case that's exactly what I'm trying to do here.

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
