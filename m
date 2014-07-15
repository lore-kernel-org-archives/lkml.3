Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbaGOHBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 03:01:43 -0400
Received: from moi001.1and1.com ([212.227.126.208]:59293 "EHLO moi.1and1.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757279AbaGOHBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 03:01:39 -0400
Message-ID: <53C4D1D0.9010105@1und1.de>
Date: Tue, 15 Jul 2014 09:01:36 +0200
From: =?ISO-8859-1?Q?Thomas_Sch=F6bel-Theuer?= <tst@1und1.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Potential solution for MARS symlink problem
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi together,

it would be optionally possible to split MARS Light into two different
kernel modules:

1) the "block device driver" module.

2) the "control module" (strategy level in IOP speak).

This could be even a preparation for the planned MARS Full, where an
even deeper separation of concerns is planned anyway. The current MARS
Light should be easily splittable this way, because the internal
structure already anticipates it.

Essentially, it is all just a matter of linking (I was eager keeping the
dependencies non-cylic all the time; even the originally submitted
patchset had no forward references at all despite it was submitted
file-by-file in a very particular order). Originally, my first MARS
prototype had a separate *.ko for each brick type as well as for the
generic brick infrastructure, but I abandoned that because it led to an
_orgy_ when rmmod'ing an extremely long list in the right order, which
is not very sysadmin-friendly. However, parts of that could potentially
be re-established at any time when needed.

In order to resolve any complaints about the potential future module 1)
ASAP, we could do some of the following:

1a) just replace xio_aio by xio_sio.

This way, we will immediately get rid of all sys_io_*() syscalls, and of
fake_mmu() and friends. With almost no effort.

SIO stands for "Synchronous IO" using a bunch of parallel threads
submitting ordinary blocking IO requests. It was my first prototype
implementation, functionally equivalent to the later *_aio, when I
didn't want to fiddle with userspace-like AIO at first.
[BTW as Andi may have noticed, I really wasn't delighted re-using
userspace AIO concepts, but I felt being forced by the "POC ASAP" demand
as well as by the "backwards compatibility forever" demand from my
industrial setup where other limiting conditions apply than in upstream
kernel development]

The sio brick is not in the submitted patchset, but on
github.com/schoebel/mars in the WIP-PORTABLE branch (for those who want
to take a look at it). It has passed the fully automatic test suite as a
replacement for xio_aio.

After replacing aio by sio, the device driver module / part 1) will no
longer need any new sys_*() or any other new symbols (AFAICS).

Sio has a little bit worse performance than its aio sibling, because the
resulting IO parallelism is limited by the (potentially configurable)
number of threads running in parallel.

Of course, this would be only a transient solution. It would give us
more time for the next steps:

1b) rename the current xio_aio to xio_aio_user or similar (only for
backwards compatibility of the out-of-tree version to very _old_
kernels) and implement a new functionally equivalent xio_aio_kernel (or
a similar name) brick for the in-tree version.

Of course, this would be the best solution. But it would take a longer time.

My problem is that I work for the industry, so the demands from here
have priority. I got the official permission for also working for the
kernel upstream of MARS during my working hours, but that's 2nd priority.

Hence, there is another potential alternative for overcoming this:

1c) leave the implementation of the new xio_aio_kernel brick to a
volunteer (of course with some help from me).

This would have another advantage: the volunteer would start gaining
experience with the brick framework. I would be generally very glad if
people would become familiar with both the framework, and also with MARS
Light in general.

In order to do that, I would have to complete the developer
documentation first (which is planned anyway). I was already planning to
somewhen write an automatic extraction tool for creating Documentation/
compatible ASCII text format out of the _relevant_ parts of the LyX /
LaTeX source of my current out-of-tree documentation.

Finding a volunteer would have many other advantages. In particular,
somebody willing to do that could start training me in better
understanding of upstream practices, similar to a coach.

Conversely, expertise on MARS would flow back. Best would be if that
person would be an experienced upstream hacker. I am sure we both will
profit much from each other.

We could do this via email, or we could use a tiny mailing list so
others could watch us.

Of course, this all depends on finding a volunteer.

I am currently reasoning on viable solutions for the future module /
part 2); this will take some more time until I will come up again
(probably also with some more questions).

In theory, there would be at least two solutions for module 2):

2a) the future control module 2) has nothing to do with IO paths at all
and is therefore not a device driver module; therefore I hope you could
allow me using symlinks, at least transiently for migration /
interoperability. This would be the quickest solution.

2b) the abstract concept of a hierarchical key->value store is mapped to
a new sysfs or /proc subtree.

One important question in advance: is it allowed to map a new sysfs (or
/proc) subtree to my own _persistent_ storage?

[BTW not only persistence is important, but also _consistency_ between
the device / backlog state and the metadata state -- it's not as trivial
as it might look like at first glance -- storing the symlinks in the
same journalled /mars/ filesystem solved most of it without additional
effort]

Of course, this solution would take a rather long time, because the
userspace interface has also to be adapted / migrated, and all
regression tests have to be passed in order to remain fully functionally
compatible.

AFAIK all current uses of sysfs or /proc had no persistence in mind. So
the following question arises:

2c) if neither 2a) nor 2b) is permitted, which other userspace
representation / interface would be appropriate for a persistent
key->value store with a hierarchical key space?

[BTW it must be easily updateable in a fine-granular way, so XML or JSON
is not an option at kernel level]

Cheers,

Thomas



