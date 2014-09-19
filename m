Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbaISRTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:19:23 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:52948 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517AbaISRTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:19:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140919104204.3b0bb762@lwn.net>
References: <cover.1410810247.git.milosz@adfin.com>
	<cover.1410983998.git.milosz@adfin.com>
	<20140919104204.3b0bb762@lwn.net>
Date: Fri, 19 Sep 2014 13:19:19 -0400
Message-ID: <CANP1eJHA4igsobC2cSyikP3tiv=mV=ZjVYAtUM89jcBZBpxkzw@mail.gmail.com>
Subject: Re: [RFC v2 0/5] Non-blockling buffered fs read (page cache only)
From: Milosz Tanski <milosz@adfin.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon, this is a very long-winded response so my apologies in advance...
when I sat down to write this my collective unconscious produced a
brain dump of my though process. Hopefully it gives you an idea of the
problem, my motivation and how it influenced the solution (which I
think is rather simple).

I think the best place would be to start with the motivation. I've
been lurking/following various attempts and approaches to non-blocking
buffered I/O at least since 2007 (and if I do a search in the archives
the discussion go a decade beyond that). Over the years -- including
various jobs and projects -- I've keep running into similar problems
network services with 100s, 1000s and now 10ks of various processing
tasks (or requests). The story would be simple if I was building a
webserver where I could just use epoll and sendfile and be done.
However, most of the things I've built require a combination of
network-bound, cpu-bound and disk-bound work and the disk-bound part
was always the weak part of the story.

Some major projects where I ran into this:
- distributed storage/processing of email (for compliance reasons)
- ad-serving (many nodes, with local db databases of candidates but
also cpu bound work to build a cost effective model),
- now a VLDB columnar db where there's is overlapping CPU work
(typical query processes in the low-mid billions of rows) and IO work
(data on Cephfs via FSCache) and global re-aggregation of data
(network bound) on all on the same nodes in the cluster.

I always wanted to leverage buffered IO in the kernel because I agree
with Linus' sentiment that I should be working with the page cache not
against the page cache in OS. And the truth is, the man years of work
that went into the linux mm system I could not / nor want to replicate
in user-space. It's next-impossible to compete with it especially with
all that painful scalability work that went into so it runs well on
many core systems that power servers nowadays. Buffered writes were
never as big a problem for me since there already are a lot of
interfaces for that in the kernel already that work okay
(sync_file_range) and you just toss it thread pool.

Lets get to the root of my problem; it was always buffered reads.
Sometimes it's the network thread (the one multiplexing via. epoll)
and other times it's CPU bound thread. You end up with one or two
problems. One is blocking and wasting CPU resources (instead of
running something else. The second one is provisioning the number of
the threads, but there you can't predict how much to over provision by
and you end up with times that you get swamped with too much CPU bound
work (since data is cached due to recent use, or read-ahead)... and
it's hard to create proper back-pressure in that system.

To avoid that problem the almost universal solution is create a
separate thread pool dedicated to blocking work. Lots of projects end
up going down that route like samba, libuv (which is use in many
services), countless java frameworks, my projects.

This is a very common architecture (here's a visualization:
http://i.imgur.com/f8Pla7j.png it's not a picture of a cat but it's a
shitty hand drawing). And this works kind-of-okay, however generally
this approach introduces latency into the requests. This latency is
caused by:

1. Having to stop our CPU bound task to fetch more data and switch to
other work (working set cache effects). In many cases for commonly
access data / sequential this will be in the page cache and we could
avoid this.
2. Having the fast (small/cached) requests get blocked behind slower
(large/uncached) requests.
3. Other general context switching, synchronization, notification latency.

This has been bugging me for years and I've tried countless
workarounds and followed countless lkml threads on buffered AIO that
got nowhere (many of them were very complex). Then I had an eureka
moment, I could solve 90% of the problem for this common architecture
if we had a very simple read syscall that would return if the data was
not in the page cache. And now it seams so obvious if you look at the
chart and the latency sources. We avoid latency by doing "fast read"
in the submitter and avoiding all that machinery if the data is
cached.

Here's why (and some assumptions):
- A large chunk of data is cached because it's commonly used (zipf
distribution of access) or is read sequentially (read-ahead).
- If are able to avoid submitting many cached requests to this IO
queue, that removes a lot of contention on the queue. Only the large /
uncached requests will go there (or the next read-ahead boundary)
- We're able to keep processing the current context in the CPU bound
thread thanks to "fast read" and we avoid a lot of needless work
context switching.
- We can control "fast read" / queuing policy in our application.

The last point is easy to miss but it actually gives the application a
lot of power. The application can prioritize "fast requests" in the
queue if they have a high ratio "fast reads" and vice-versa it can
avoid increasing latency (double syscall) in the uncached workload by
not attempting to fast reads in cases of very low "fast read" hits.

The real proof is in the tests. Both our application and the FIO tests
pain a story of greatly improved overall request latencies for these
kinds of workloads that want to overlap CPU bound and IO bound work in
one application. Take a look at the cover letter for the patch.

In conclusion we can get to what I consider a 90% solution to
non-blocking buffered file reads with a very small / easy to read
patch (where the other proposals ran int problems). It solves a common
read-world problem in a very common user-space architecture (so high
potential for impact). Finally, the new syscalls pave a way for other
per single read/write flags that other folks have already suggested in
this and other threads.

I'm sorry if this contains any errors, but I took me longer to write
this then I wanted to and I had to hurry to wrap up this email.

Best,
- Milosz

On Fri, Sep 19, 2014 at 10:42 AM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Wed, 17 Sep 2014 22:20:45 +0000
> Milosz Tanski <milosz@adfin.com> wrote:
>
>> This patcheset introduces an ability to perform a non-blocking read from
>> regular files in buffered IO mode. This works by only for those filesystems
>> that have data in the page cache.
>>
>> It does this by introducing new syscalls new syscalls readv2/writev2 and
>> preadv2/pwritev2. These new syscalls behave like the network sendmsg, recvmsg
>> syscalls that accept an extra flag argument (O_NONBLOCK).
>
> So I'm trying to understand the reasoning behind this approach so I can
> explain it to others.  When you decided to add these syscalls, you
> ruled out some other approaches that have been out there for a while.
> I assume that, before these syscalls can be merged, people will want to
> understand why you did that.  So I'll ask the dumb questions:
>
>  - Non-blocking I/O has long been supported with a well-understood set
>    of operations - O_NONBLOCK and fcntl().  Why do we need a different
>    mechanism here - one that's only understood in the context of
>    buffered file I/O?  I assume you didn't want to implement support
>    for poll() and all that, but is that a good enough reason to add a
>    new Linux-specific non-blocking I/O technique?
>
>  - Patches adding fincore() have been around since at least 2010; see,
>    for example, https://lwn.net/Articles/371538/ or
>    https://lwn.net/Articles/604640/.  It seems this could be used in
>    favor of four new read() syscalls; is there a reason it's not
>    suitable for your use case?
>
>  - Patches adding buffered support for AIO have been around since at
>    least 2003 - https://lwn.net/Articles/24422/, for example.  I guess
>    I don't really have to ask why you don't want to take that
>    approach! :)
>
> Apologies for my ignorance here; that's what I get for hanging around
> with the MM folks at LSFMM, I guess.  Anyway, I suspect I'm not the
> only one who would appreciate any background you could give here.
>
> Thanks,
>
> jon



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
