Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaHMDpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 23:45:09 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:44049 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaHMDpH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 23:45:07 -0400
Message-ID: <53EADF3F.20909@linaro.org>
Date: Tue, 12 Aug 2014 20:45:03 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: josh@joshtriplett.org
CC: ksummit-discuss@lists.linuxfoundation.org,
        "Joseph S. Myers" <joseph@codesourcery.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-discuss] (Resend) 2038 Kernel Summit Discussion Fodder
References: <53EAAC95.7080301@linaro.org> <20140813013342.GB6783@cloud>
In-Reply-To: <20140813013342.GB6783@cloud>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2014 06:33 PM, josh@joshtriplett.org wrote:
> On Tue, Aug 12, 2014 at 05:08:53PM -0700, John Stultz wrote:
>> Also, just to clarify, as time related discussions can bring out a laundry
>> list of issues, I would like to focus this discussion on providing a 2038
>> solution for existing interfaces and applications in a way that ideally
>> doesn't require modifying application source code.  While there will be
>> plenty of places where applications have cast or stored time_t values
>> explicitly as longs, and for those applications, deep modifications will be
>> necessary. But I’d like to avoid getting into new-interface discussions,
>> like exporting ktime_t like nanosecond interfaces instead of timepsecs,
>> unifying time-stamping formats, or methods for avoiding leapseconds. Those
>> are all interesting issues, and I’d be up for discussing them separately,
>> but those issue apply equally to 32bit and 64bit systems, and really aren't
>> 2038 specific, so I think its best to separate them out.
> That's understandable.  However, I wonder to what extent we could
> support unmodified source code via libc wrappers (since code calling
> syscalls directly can't work completely unmodified), while using better
> interfaces for new syscalls.  Given syscalls written in terms of (for
> instance) nanoseconds rather than timespec values, it seems
> straightforward enough for libc to provide compatibility interfaces.

So we'd be then introducing new syscalls not just for 32bit but 64bit
systems as well, and its a fairly substantial list:
    http://kernelnewbies.org/y2038

Again, I worry that just getting time_t to be 64bits is a big enough
problem to solve without trying to mix in interface preference
discussions along, adding totally new interfaces, coordinating all the
libcs out there to provide wrappers, and then deprecating the old
interfaces.

If there are more desirable interfaces wanted, I really think that needs
to be a separate topic from fixing the ones we have.


>
>> From discussions so far, it seems the preferred change to the userspace
>> interface is what I’ll call the “Large File” method, as it follows the
>> approach used for large file support:
>>
>> Create new 64bit time_t/timespec/timeval/etc variants for syscalls, while
>> preserving existing interfaces. This has some complexity around IOCTLs, but
>> that can mostly be handled by creating new ioctl numbers while preserving
>> the old ones. Since we’re only modifying time types, we’ll also need to add
>> compat versions for many of these syscalls for 64bit native systems.
>>
>> Libc then introduces versioned symbols, and a new compile options to allow
>> applications to be built for “large time”. New and old applications could
>> then share the same libc.
>>
>> The benefits of this approach is is simply and minimally extends the
>> current 32 bit environment, without any effect on existing applications
>> which continue to work. Most of the complexity is in the libc library and
>> its build environment.
>>
>> The downsides to this approach is that as it follows the large-file
>> approach, it has many of the same problems as large-file support, in that
>> the transition to large-file has been slow and is still ongoing. Also,
>> since this solution focuses on libc, there is also the problem of existing
>> 3rd party libraries, which have no way of knowing which sized time is being
>> used, will break. So all libraries that do anything with time will then
>> have to implement their own versioned interfaces. This approach also makes
>> it a little more difficult to audit that a system is 2038 safe, without
>> running it and looking for issues.
> If we go this route, we should also provide a "depends on EMBEDDED"
> Kconfig option that omits all of the compatibility support, for systems
> that have fully migrated to new userspace.

Right, though I think for any of the solutions, having methods to
actually remove support for the 2038 unsafe interfaces is important to
help ensure systems are completely converted.


>
>> A potential alternative I’d like to also propose is the “Libc Version Bump”
>> approach.
>>
>> Basically this is the same as the above, where the kernel provides both
>> legacy and new time_t related interfaces. However, the libc would make a
>> version break, migrating to using 64bit time_t types and syscalls. Legacy
>> applications would still work using the old glibc version, but this would
>> provide a stronger line in the sand between 2038 safe and unsafe
>> applications and libraries, making it easier to avoid mixing the two.
>> NetBSD developers discussed this same approach back in 2008 here:
>> https://mail-index.netbsd.org/tech-userlevel/2008/03/22/msg000231.html
>>
>> The downsides here is, for legacy application support, one would have to
>> have all the requisite legacy libraries also installed, which will add a
>> burden to distro vendors. However, this extra storage overhead would likely
>> be a positive motivator to get applications rebuilt and migrated to new
>> version. Additionally, for 3rd party libraries built against the new libc
>> version, the libraries may need to do a version bump themselves, in order
>> to be able to co-exist with versions built against the previous libc. This
>> approach also assumes that libraries that use time_t related values would
>> have a libc dependency.
> The migration pain here doesn't seem worth it at all.

Hmm. I see this as a more mechanical process, rather then the
large-file-style support, which requires libraries to all add versioned
interfaces. This approach uses the library version number to in-effect
version the interfaces. But it does require version bumps everywhere.

The basic point here is that for compatibility we have to pick a method
to chose the new or old interfaces. That can be internal to the
libraries at build time w/ versioned symbols, external to the libraries
by the linker, using their named version numbers, or by the kernel
loader itself with the virtual architecture.

Each step along the gradient has different trade-offs in how mechanical
it can be vs the level of duplication needed to support it. I think the
libc bump has the best balance, but think the distro folks might have
better insight as to the pain of what I'm suggesting.


>
>> A more aggressive version of the previous proposal is what I’m calling the
>> “New Virtual-Architecture” approach, basically extending the versioning
>> control from the linker down into the kernel as well.  It would be adding a
>> new “virtual-architecture” to the kernel, not entirely unlike how x32 is
>> supported on x86_64 systems.  We would create entirely new ABI and
>> architecture name in the kernel (think something like “armllt” or
>> “i386llt”). We would preserve compatibility for legacy applications via
>> personalities, similar mechanism as the compat_ interface used to support
>> 32bit applications on 64bit kernels. In this case, we wouldn’t introduce
>> new 64 bit syscalls in the kernel, as the existing interfaces would just be
>> typed correctly for our new virtual architecture, but we would have
>> duplicate syscall interfaces via the compat interfaces. The extra
>> complexity would also be that we would have to support new 32bit compat
>> environment on 64bit systems. Userspace would be completely rebuilt to
>> support the new -llt architecture, and compatibility for legacy
>> applications would be done via the same multiarch packaging as is done now
>> for running 32bit applications on 64bit systems.
> I wonder: could we make this new architecture effectively use the
> signatures of the 64-bit syscalls (similar to x32), just with a 32-bit
> calling convention?

So if you mean on 64bit systems, having the 2038-safe 32bit compat use
the same 64bit entry-points, I think that would be possible for some of
the syscalls, but there's some where other data fields in structures
won't be expected to be 64bit. But I might not be understanding what
your suggesting.

thanks
-john


