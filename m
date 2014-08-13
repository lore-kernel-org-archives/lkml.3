Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaHMAI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 20:08:59 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40299 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaHMAI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 20:08:57 -0400
Message-ID: <53EAAC95.7080301@linaro.org>
Date: Tue, 12 Aug 2014 17:08:53 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: ksummit-discuss@lists.linuxfoundation.org
CC: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "Joseph S. Myers" <joseph@codesourcery.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: (Resend) 2038 Kernel Summit Discussion Fodder
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Forgive the resend, somehow despite being in plain-text mode, the gmail
compose interface somehow added some html-ism that caused lkml to bounce
this)

Next week at Kernel Summit, I'm hoping to have a discussion on 2038 during
one of the unconference slots, so I wanted to send out some background
information about the various proposed approaches (as well as send this out
for wider input, since apparently there won't be much libc representation
at KS).

So 2038 brings the end of time for 32bit architectures.  It being some
twenty four years ahead, it may seem like there is plenty of time for folks
to migrate to 64bit architectures that are (mostly) unaffected by this
issue. However, 32bit processors are still being produced today in
extremely high volumes, and many of those systems are being used in
commercial, industrial and medical environments, where these systems may be
quite literally embedded into the walls and machinery and are expected to
run for 25 years or more. As these small systems become more and more
pervasive, the risks of major trouble in 2038 grow. And that’s to say
nothing of the impact on future classic-car resale prices for fancy cars
like the Tesla when the high end in-dash display won’t work (gasp!).

Thus, the “just upgrade to 64bit” solution isn’t really sufficient, and we
need to find a transition plan soon, which will allow 32bit cpus being sold
today and in the future to function correctly past 2038.

Other OSes have already started rolling out solutions. NetBSD switched to
64bit time_t in 2012, providing a compatibility layer for old applications.
Then in 2013, OpenBSD switched its 32bit systems time_t to use long long.
You can read more about the OpenBSD transition here:
http://www.openbsd.org/papers/eurobsdcon_2013_time_t/. One item to note is
that NetBSD preserved compatibility with 2038 unsafe applications, while
OpenBSD did not (seeing the certainty of excluding unsafe applications as a
feature over compatibility). For Linux, we obviously want to maintain
compatibility, but I think its important we recognise we’re not the first
movers here, and many of the discussions we’ll be having have already been
had in those communities. I also think we should be sure to credit the
NetBSD and OpenBSD devs for jumping in on this early and working to ensure
issues in the userspace applications we share are already addressed.

Also, just to clarify, as time related discussions can bring out a laundry
list of issues, I would like to focus this discussion on providing a 2038
solution for existing interfaces and applications in a way that ideally
doesn't require modifying application source code.  While there will be
plenty of places where applications have cast or stored time_t values
explicitly as longs, and for those applications, deep modifications will be
necessary. But I’d like to avoid getting into new-interface discussions,
like exporting ktime_t like nanosecond interfaces instead of timepsecs,
unifying time-stamping formats, or methods for avoiding leapseconds. Those
are all interesting issues, and I’d be up for discussing them separately,
but those issue apply equally to 32bit and 64bit systems, and really aren't
2038 specific, so I think its best to separate them out.

I think any solution to the 2038 issue for Linux, from the kernel’s
perspective, will have a number of phases:

1) In-kernel correctness: Making sure the kernel itself handles the 2038
rollover correctly. As noted in LWN (https://lwn.net/Articles/607741/) this
work has begun and portions have been merged. Personally, I don’t really
see this as that interesting of a discussion topic, and with the exception
of dealing with external representations of time like on-disk filesystem
formats, etc, it is for the most part a matter of just going through,
finding and fixing things (with a few extra complications around ioctls).
Mostly this will revolve around adding explicitly sized 64bit time_t types
(and 32bit types for compatibility), and migrating in-kernel users over to
the explicitly sized implementations, allowing us to validate conversion by
eventually removing the in-kernel time_t type, of course finding non-time_t
custom storage uses will be a long tail of work.

2) Userspace ABI modifications: This includes how we expose the new 64bit
time_t and related structures to userland via syscalls and ioctls, and how
we preserve compatibility to older applications. This is probably the most
complex issue, as the different choices have large impacts to how the
transition in userspace is done.

3) Aiding in validating userspace correctness: While we want to preserve
compatibility, there is the very real aspect that 2038 unsafe applications
(ie: almost all 32bit applications today) are terminally broken in 2038.
While we can try to ensure that we don’t break those applications
prematurely, we do want to ensure folks using unsafe applications are aware
and motivated to upgrade to 2038-safe versions quickly. This might include
warnings when unsafe syscalls are used, or options to disable unsafe
syscalls, as well as maybe debug modes for testing where if you set the
date to past 2038, the kernel will be extra verbose if any truncated
absolute time_t values are observed (hinting that an application cast to a
long and back).

So what I’d like to cover in this mail, are some discussion starters around
ABI modifications that I think we should discuss at Kernel Summit, in order
to make sure we have a clear path forward, as what we decide for the ABI
modifications, has large impacts on how we help ensure userspace is correct
or not.


>From discussions so far, it seems the preferred change to the userspace
interface is what I’ll call the “Large File” method, as it follows the
approach used for large file support:

Create new 64bit time_t/timespec/timeval/etc variants for syscalls, while
preserving existing interfaces. This has some complexity around IOCTLs, but
that can mostly be handled by creating new ioctl numbers while preserving
the old ones. Since we’re only modifying time types, we’ll also need to add
compat versions for many of these syscalls for 64bit native systems.

Libc then introduces versioned symbols, and a new compile options to allow
applications to be built for “large time”. New and old applications could
then share the same libc.

The benefits of this approach is is simply and minimally extends the
current 32 bit environment, without any effect on existing applications
which continue to work. Most of the complexity is in the libc library and
its build environment.

The downsides to this approach is that as it follows the large-file
approach, it has many of the same problems as large-file support, in that
the transition to large-file has been slow and is still ongoing. Also,
since this solution focuses on libc, there is also the problem of existing
3rd party libraries, which have no way of knowing which sized time is being
used, will break. So all libraries that do anything with time will then
have to implement their own versioned interfaces. This approach also makes
it a little more difficult to audit that a system is 2038 safe, without
running it and looking for issues.


A potential alternative I’d like to also propose is the “Libc Version Bump”
approach.

Basically this is the same as the above, where the kernel provides both
legacy and new time_t related interfaces. However, the libc would make a
version break, migrating to using 64bit time_t types and syscalls. Legacy
applications would still work using the old glibc version, but this would
provide a stronger line in the sand between 2038 safe and unsafe
applications and libraries, making it easier to avoid mixing the two.
NetBSD developers discussed this same approach back in 2008 here:
https://mail-index.netbsd.org/tech-userlevel/2008/03/22/msg000231.html

The downsides here is, for legacy application support, one would have to
have all the requisite legacy libraries also installed, which will add a
burden to distro vendors. However, this extra storage overhead would likely
be a positive motivator to get applications rebuilt and migrated to new
version. Additionally, for 3rd party libraries built against the new libc
version, the libraries may need to do a version bump themselves, in order
to be able to co-exist with versions built against the previous libc. This
approach also assumes that libraries that use time_t related values would
have a libc dependency.

A more aggressive version of the previous proposal is what I’m calling the
“New Virtual-Architecture” approach, basically extending the versioning
control from the linker down into the kernel as well.  It would be adding a
new “virtual-architecture” to the kernel, not entirely unlike how x32 is
supported on x86_64 systems.  We would create entirely new ABI and
architecture name in the kernel (think something like “armllt” or
“i386llt”). We would preserve compatibility for legacy applications via
personalities, similar mechanism as the compat_ interface used to support
32bit applications on 64bit kernels. In this case, we wouldn’t introduce
new 64 bit syscalls in the kernel, as the existing interfaces would just be
typed correctly for our new virtual architecture, but we would have
duplicate syscall interfaces via the compat interfaces. The extra
complexity would also be that we would have to support new 32bit compat
environment on 64bit systems. Userspace would be completely rebuilt to
support the new -llt architecture, and compatibility for legacy
applications would be done via the same multiarch packaging as is done now
for running 32bit applications on 64bit systems.

The pros for this case is that it would be very easy to audit that
applications have migrated to the new 64bit time_t ABI. Additionally since
we know which type the application is in the kernel, it would make
problematic compatability areas like IOCTLS easier to deal with utilizing a
flag in the task structure.

The downsides here are many. The distros will probably hate this idea, as
it requires rebuilding the world, and maintaining another legacy
architecture support. I’m also not completely sure how robust multi-arch
packaging is in the face of having to handle 3-4 architectures on one
system. On the kernel side, it also adds more complexity, where we have to
add even more complex compat support for 64bit systems to handle all the
various 32bit applications possible.

That said the practical reality isn't much further from the the “Libc
Version Bump” approach, since legacy support will need legacy versions of
all dependent libraries there a well. Similarly the additional storage
required to support legacy applications is a positive motivator to get
folks to move away from unsafe legacy applications. I also personally like
the clarity the new virtual architecture brings, and that it would allow a
kernel option to disable 2038-unsafe legacy support.

With any of these approaches, we still have quite a bit of work to just get
the kernel in-shape internally. And with the exception of the “virtual
arch” approach, the changes on the kernel side are basically the same. The
big thing we probably want to avoid is requiring any sort of flagday for
distros, and instead allowing them each to migrate to the new solution
individually (but hopefully not taking too long). Even so, I think having a
clear vision for how userspace will make this transition is important, so
hopefully during the Kernel Summit discussion we can come to consensus on
what approach to take moving forward.

Anyway, this is probably more then enough to read and think about in the
next week. I’d be very interested in further thoughts or alternative
proposals to discuss.

Thanks to Thomas Gleixner, Arnd Bergmann, Mark Brown, Joseph Myers and
others for their thoughts and proposals which I used to create this summary.

Also, Arnd has been keeping 2038 related details (most usefully on the
non-time_t 2038 concerns) on the kenrelnewbies wiki here:
http://kernelnewbies.org/y2038

thanks
-john

