Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbaH0Sed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:34:33 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:47046 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839AbaH0Seb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:34:31 -0400
MIME-Version: 1.0
In-Reply-To: <53EAAC95.7080301@linaro.org>
References: <53EAAC95.7080301@linaro.org>
Date: Wed, 27 Aug 2014 11:34:30 -0700
Message-ID: <CALAqxLWvSn2_6dakGiQ4VEtYHH2Dt7BL0pn5XHgLWOV4ePqhBw@mail.gmail.com>
Subject: Re: (Resend) 2038 Kernel Summit Discussion Fodder
From: John Stultz <john.stultz@linaro.org>
To: ksummit-discuss@lists.linuxfoundation.org
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "Joseph S. Myers" <joseph@codesourcery.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 5:08 PM, John Stultz <john.stultz@linaro.org> wrote:
> So what I’d like to cover in this mail, are some discussion starters around
> ABI modifications that I think we should discuss at Kernel Summit, in order
> to make sure we have a clear path forward, as what we decide for the ABI
> modifications, has large impacts on how we help ensure userspace is correct
> or not.
>
>
> From discussions so far, it seems the preferred change to the userspace
> interface is what I’ll call the “Large File” method, as it follows the
> approach used for large file support:
>
> Create new 64bit time_t/timespec/timeval/etc variants for syscalls, while
> preserving existing interfaces. This has some complexity around IOCTLs, but
> that can mostly be handled by creating new ioctl numbers while preserving
> the old ones. Since we’re only modifying time types, we’ll also need to add
> compat versions for many of these syscalls for 64bit native systems.
>
> Libc then introduces versioned symbols, and a new compile options to allow
> applications to be built for “large time”. New and old applications could
> then share the same libc.
>
> The benefits of this approach is is simply and minimally extends the
> current 32 bit environment, without any effect on existing applications
> which continue to work. Most of the complexity is in the libc library and
> its build environment.
>
> The downsides to this approach is that as it follows the large-file
> approach, it has many of the same problems as large-file support, in that
> the transition to large-file has been slow and is still ongoing. Also,
> since this solution focuses on libc, there is also the problem of existing
> 3rd party libraries, which have no way of knowing which sized time is being
> used, will break. So all libraries that do anything with time will then
> have to implement their own versioned interfaces. This approach also makes
> it a little more difficult to audit that a system is 2038 safe, without
> running it and looking for issues.
>
>
> A potential alternative I’d like to also propose is the “Libc Version Bump”
> approach.
>
> Basically this is the same as the above, where the kernel provides both
> legacy and new time_t related interfaces. However, the libc would make a
> version break, migrating to using 64bit time_t types and syscalls. Legacy
> applications would still work using the old glibc version, but this would
> provide a stronger line in the sand between 2038 safe and unsafe
> applications and libraries, making it easier to avoid mixing the two.
> NetBSD developers discussed this same approach back in 2008 here:
> https://mail-index.netbsd.org/tech-userlevel/2008/03/22/msg000231.html
>
> The downsides here is, for legacy application support, one would have to
> have all the requisite legacy libraries also installed, which will add a
> burden to distro vendors. However, this extra storage overhead would likely
> be a positive motivator to get applications rebuilt and migrated to new
> version. Additionally, for 3rd party libraries built against the new libc
> version, the libraries may need to do a version bump themselves, in order
> to be able to co-exist with versions built against the previous libc. This
> approach also assumes that libraries that use time_t related values would
> have a libc dependency.
>
> A more aggressive version of the previous proposal is what I’m calling the
> “New Virtual-Architecture” approach, basically extending the versioning
> control from the linker down into the kernel as well.  It would be adding a
> new “virtual-architecture” to the kernel, not entirely unlike how x32 is
> supported on x86_64 systems.  We would create entirely new ABI and
> architecture name in the kernel (think something like “armllt” or
> “i386llt”). We would preserve compatibility for legacy applications via
> personalities, similar mechanism as the compat_ interface used to support
> 32bit applications on 64bit kernels. In this case, we wouldn’t introduce
> new 64 bit syscalls in the kernel, as the existing interfaces would just be
> typed correctly for our new virtual architecture, but we would have
> duplicate syscall interfaces via the compat interfaces. The extra
> complexity would also be that we would have to support new 32bit compat
> environment on 64bit systems. Userspace would be completely rebuilt to
> support the new -llt architecture, and compatibility for legacy
> applications would be done via the same multiarch packaging as is done now
> for running 32bit applications on 64bit systems.
>
> The pros for this case is that it would be very easy to audit that
> applications have migrated to the new 64bit time_t ABI. Additionally since
> we know which type the application is in the kernel, it would make
> problematic compatability areas like IOCTLS easier to deal with utilizing a
> flag in the task structure.
>
> The downsides here are many. The distros will probably hate this idea, as
> it requires rebuilding the world, and maintaining another legacy
> architecture support. I’m also not completely sure how robust multi-arch
> packaging is in the face of having to handle 3-4 architectures on one
> system. On the kernel side, it also adds more complexity, where we have to
> add even more complex compat support for 64bit systems to handle all the
> various 32bit applications possible.
>
> That said the practical reality isn't much further from the the “Libc
> Version Bump” approach, since legacy support will need legacy versions of
> all dependent libraries there a well. Similarly the additional storage
> required to support legacy applications is a positive motivator to get
> folks to move away from unsafe legacy applications. I also personally like
> the clarity the new virtual architecture brings, and that it would allow a
> kernel option to disable 2038-unsafe legacy support.
>
> With any of these approaches, we still have quite a bit of work to just get
> the kernel in-shape internally. And with the exception of the “virtual
> arch” approach, the changes on the kernel side are basically the same. The
> big thing we probably want to avoid is requiring any sort of flagday for
> distros, and instead allowing them each to migrate to the new solution
> individually (but hopefully not taking too long). Even so, I think having a
> clear vision for how userspace will make this transition is important, so
> hopefully during the Kernel Summit discussion we can come to consensus on
> what approach to take moving forward.

So I just wanted to send a (late) follow up here to summarize my
recollection of the discussion from the Kernel Summit workshop
session. Since there wasn't representation from the userspace world,
there was only a brief 30 minute session to try to get feedback on the
above proposals, and have a bit of open discussion to allow for folks
to air any ideas that hadn't already been proposed.

To start, I expresses what I felt to be the need for whatever solution
we choose, it should ideally be easy to audit in order for folks to be
able to validate that a system has or has not been updated to use
64bit time.  The counterpoint raised is that userspace may still do
problematic things like storing timestamps on disk or elsewhere in
32bit structures, so the value of any trivial auditing may not be that
great.

>From the discussion on the list, the "libc version bump" approach is
unlikely, and consensus in the session is that it would be a userspace
decision anyway. The "virtual architecture" approach, didn't seem to
have many fans either. Linus cut through the discussion with the
request that we not over-design this, just provide the 64bit
interfaces and let userspace do what it wants. So that resolved my
main open questions, and gave a clear way forward from the kernel's
perspective, with userland (or atleast glibc) likely taking the
"large-file style" approach.

There was also some pre-discussion before the sessions started around
why we don't just change time_t to be unsigned. From the kernel's
point of view this would be mostly fine, since dates before 1970 are
not considered valid for any internal uses (with the exception of some
filesystem timestamps). However, the problem with this approach is
that userspace may want to handle dates prior to 1970, so this would
eliminate that possibility. And removing the sign could cause problems
with existing comparison logic. There is also the fact that having the
same time unit range on 32bit and 64bit systems avoids complicating
how timestamps are interpreted between architectures, where as having
it be unsigned on 32bit but signed on 64bit would likely cause
confusion. It is quite likely that using unsigned timestamps will be a
useful solution for cases where timestamps cannot be converted to
64bits, but from the kernel perspective if we are going to change the
abi, we should probably go all the way to 64bits. There seemed to be
no disagreement here.

For the rest of the session, I opened it up for further thoughts or
ideas. While there wasn't any new proposals, there was a question as
to if anyone will really be running 32bit hardware in 2038, which made
some folks point out that as systems get smaller there are likely to
be tiny embedded platforms using Linux. The point that these systems
are likely never to be updated brought out a discussion as to if 2038
is even the least of our worries, given the security issues around
these abandoned systems. Debate of the risks of light-bulb hacks
ensued. This also raised an interesting but further tangential point
that apparently there is talk of legislative enforced obsolescence on
devices that don't get updates.

<sarcasm> So clearly the solution is to simply make it illegal to hit
any 2038 issue. Then there's nothing to worry about. :) </sarcasm>

So that's everything I recall. It was a fairly short session. I'm
hoping Thomas will be able to have a similar session with more
userspace representation at Plumbers, but given the attendance caps
were hit early, I'm suspecting will have to have continued discussions
on the list and wherever we can next year.

I'll be continuing to work (along with Arnd and others) on getting the
kernel internals migrated to 64bit time, and then eventually exporting
64bit syscalls for userspace to use. Further discussion, feedback and
help is of course welcome!

thanks
-john
