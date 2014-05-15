Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaEORMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:12:03 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:40631 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaEORL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:11:59 -0400
Message-ID: <5374F55E.4030004@codesourcery.com>
Date: Fri, 16 May 2014 01:11:58 +0800
From: Chung-Lin Tang <cltang@codesourcery.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <8399002.IIyBoyEHox@wuerfel> <CANcMJZAOi9ctWkpEgynj6wxCrvW4oS5ZHj3Chv04D=VQDogEvw@mail.gmail.com> <4160991.69XaTMjMrC@wuerfel>
In-Reply-To: <4160991.69XaTMjMrC@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2014 17:11:53.0627 (UTC) FILETIME=[C4B2FEB0:01CF7060]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/15 07:08 PM, Arnd Bergmann wrote:
> On Wednesday 14 May 2014 14:33:18 John Stultz wrote:
>> On Tue, May 13, 2014 at 12:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Tuesday 13 May 2014 20:24:59 Geert Uytterhoeven wrote:
>>>> On Tue, May 13, 2014 at 8:10 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>> Using 64-bit time_t on x32 is fine, because it's fast to operate
>>>>> in user space with 64-bit registers, and the kernel is 64-bit
>>>>> anyway. Inside of the kernel, we may get into trouble using
>>>>> a 64-bit time_t on 32-bit architectures because of the overhead
>>>>> in 64-bit math, e.g. all the timekeeping code that is based on
>>>>> timespec or some code paths in file systems and network code where
>>>>> we actually require division of time_t values.
>>>>
>>>> While going over time_t uses, have you found a pattern for use cases
>>>> involving division of time_t values in filesystem and networking code?
>>>
>>> In ipv4, we have multiple places doing this:
>>>
>>>         icmp_param.data.times[1] = htonl((tv.tv_sec % 86400) * MSEC_PER_SEC +
>>>                                          tv.tv_nsec / NSEC_PER_MSEC);
>>>
>>> to calculate the miliseconds since midnight. For file systems, I
>>> found that FAT uses seconds/minutes/hours/days/month/year representation,
>>> which is a lot of divides, but that can probably be optimized and
>>> we need to handle years beyond 2038 anyway.
>>
>> We can do some tricks for internal optimizations here if these are
>> critical.  I'd be more concerned about userland divisions where moving
>> to a 64bit time_t would cause performance issues that we cannot help
>> optimize.
> 
> Good point.
> 
>>>>> We clearly have to change that code in some for to deal with y2038,
>>>>> but 64-bit time_t may not be the best option. A lot of the
>>>>> in-kernel code can probably use ktime_t, which we can change
>>>>> to a different representation (e.g. 34 bit seconds) if needed,
>>>>> and all the code that is only interested in relative time
>>>>> (e.g. nanosleep) doesn't have to change at all.
>>>>
>>>> Yeah. 32-bit uptimes should be good enough for everyone (don't quote
>>>> me on that), so adding a 64-bit offset when there's a need for absolute
>>>> time should be OK.
>>>
>>> I think we have three categories:
>>>
>>> a) interfaces that uses relative time_t/timespec/timeval:
>>>    - nanosleep
>>>    - select/pselect/poll/ppoll/epoll
>>>    - getrusage
>>>    - sched_rr_get_interval
>>>    - sigtimedwait
>>>    - clock_nanosleep
>>>    - alarm
>>>    - siginfo (rusage)
>>>
>>>   These can stay compatible, but we'd have to use a different
>>>   type if we change time_t.
>>
>>
>> So as a correction, at least clock_nanosleep can specify sleep times
>> using absolute time.
> 
> Thanks.
> 
>>> b) interfaces that don't make sense for times in the past:
>>>    - getitimer/setitimer
>>>    - timer_settime/timer_gettime
>>>    - gettimeofday/settimeofday
>>>    - adjtimex
>>>    - clock_gettime/clock_settime/clock_adjtime
>>>    - time/stime
>>>    - socket time stamps
>>>    - audio time stamps
>>>    - v4l time stamps
>>>    - input event time stamps
>>>    - sysv ipc (msg, sem, shm)
>>>
>>>    Here, we are relatively free to change the start of the
>>>    epoch in the kernel but convert to something else on the
>>>    user space boundary. One possibility is to scale them to
>>>    boot time and use ktime_t in the kernel.
>>
>> I'm not sure I'm totally following this... Are you suggesting we keep
>> 32bit time internally w/ some different offset but then pass to
>> userland a 64bit time_t?  Or are you suggesting we change the abi to
>> move the epoch?
> 
> What I meant is that regardless of what we decide for the ABI,
> we can change the in-kernel representation in any way we like as
> long as we can represent all dates that can occur during the runtime
> of the kernel, i.e. we don't have to represent times between 1970 and
> 2014. This could mean one of many representations:
> 
> - time_t scaled forward by 44 years and/or made unsigned
> - ktime_t scaled to boot time
> - 64-bit nanoseconds starting at the epoch
> - timespec64
> 
>> I think I'm with hpa in his recent mail in that the internal
>> representation is an optimization detail, and the bigger question is
>> do we use a  64bit time_t for future systems (possibly w/ a major ABI
>> break - with compat interface for existing 32bit applications), or do
>> we try to rev interfaces function by function to provide 2038 safe
>> versions which applications will have to be modified to use?
>>
>> Me, I'm a fan of moving time_t to 64bits, since it makes "porting"
>> applications to a 2038 safe ABI easier.
> 
> I think there are two or three distinct problems:
> 
> a) We absolutely have to find a way to build a user space that
>    can survive 2038. This probably involves moving at least
>    time_t, timeval and timespec to use 64-bit representation.
> b) We have to keep compatibility with existing user space running
>    on future kernels, which means at least x86, arm and a few
>    other 32-bit architectures (we can ignore some of the obsolete
>    ones if that helps us) need to provide syscall ABIs for both
>    32-bit time_t and whatever we use for the new syscalls and
>    ioctls. As Thomas said, for some interfaces this could mean
>    64-bit nanoseconds and for others it could be timespec64.
> c) glibc may or may not provide a way for applications to use
>    the extended interfaces without a user space ABI break. My
>    impression so far is that this is going to be too hard and
>    it won't be done, but this is for the glibc developers to
>    determine.

glibc does version its exported symbols, so provided new/old syscalls
are both provided, haveing a new version of a routine (using 64-bit
time_t and new syscall interfaces) and the old compat routine co-exist
should be possible. Of course, old binaries may still not be saved when
2038 arrives.

(Adding Joseph to the CC, for more definitive comments)

Thanks,
Chung-Lin


> The important distinction here is between user space time_t
> (timeval, timespec) and __kernel_time_t. We probably need
> to make the user space time_t a build-time conditional,
> at least for the foreseeable future. New architectures or
> new C libraries can start out using 64-bit time_t unconditionally.
> 
> For the kernel interface, I think we should deprecate any interfaces
> using plain time_t and timeval, i.e. keep them around for existing
> architectures (possibly with a kernel compile time option to disable
> them so we are sure they don't leak out to new user space) and
> provide kernel interfaces based on 64-bit timespec (or other 
> appropriate data structures for timestamps) for new architectures.
> 
> I see multiple ways of doing this, and I don't like any of them ;-)
> 
> 1) rename all *time* types to *old_time*, and provide new ones
>    based on 64-bit time_t. We'd have to change them all at once,
>    and there would likely still be some build breakage with glibc.
>    The idea is that a libc built against old headers still works
>    fine on old and new kernels, and a libc built against new kernels
>    would automatically get 64-bit time but stop working on old
>    kernels. Also, any binaries built against old glibc wouldn't
>    work on new glibc, which is probably a killer.
> 
>    Example:
> 
>    -typedef long __kernel_time_t;
>    +typedef long __kernel_oldtime_t;
>    +typedef __s64 __kernel_time_t;
>    -struct timespec { __kernel_oldtime_t tv_sec; long   tv_nsec; };
>    +struct oldtimespec { __kernel_oldtime_t tv_sec; long   tv_nsec; };
>    +struct timespec { __s64 tv_sec; __s64 tv_nsec; };
> 
>    -long sys_utime(char __user *filename, struct utimbuf __user *times);
>    -long sys_utimes(char __user *filename, struct timeval __user *utimes);
>    -long sys_futimesat(int dfd, const char __user *filename, struct timeval __user *utimes);
>    -long sys_utimensat(int dfd, const char __user *filename, struct timespec __user *utimes, int flags);
>    +long sys_oldutime(char __user *filename, struct oldutimbuf __user *times);
>    +long sys_oldutimes(char __user *filename, struct oldtimeval __user *utimes);
>    +long sys_oldfutimesat(int dfd, const char __user *filename, struct oldtimeval __user *utimes);
>    +long sys_oldutimensat(int dfd, const char __user *filename, struct oldtimespec __user *utimes, int flags);
> 
>    +long sys_utimensat(int dfd, const char __user *filename, struct timespec __user *utimes, int flags);
> 
>    -#define __NR_utimensat 88
>    -#define __NR_utimes 1037
>    -#define __NR_futimesat 1066
>    -#define __NR_utime 1063
>    +#define __NR_oldutimensat 88
>    +#define __NR_oldutimes 1037
>    +#define __NR_oldfutimesat 1066
>    +#define __NR_oldutime 1063
> 
>    +#define __NR_utimensat 277  /* next free number for asm-generic/unistd.h */
>  
> 2) leave the kernel time_t as 'long' and only introduce a new
>    struct timespec64,defined to be compatible with struct timespec on
>    64-bit architectures. For each syscall or ioctl that we need, come up
>    with a new one. Make the libc define its own time_t as 64-bit and use
>    the new syscalls instead of the old ones. This will allow a smooth
>    transition, but we might not be done with it before 2038.
> 
>    Example:
> 
>     typedef long __kernel_time_t;
>     struct timespec { __kernel_time_t tv_sec; long   tv_nsec; };
>    +struct timespec64 { __s64 tv_sec; __s64 tv_nsec; };
> 
>    +#ifdef __ARCH_WANT_32BIT_TIME
>     long sys_utime(char __user *filename, struct utimbuf __user *times);
>     long sys_utimes(char __user *filename, struct timeval __user *utimes);
>     long sys_futimesat(int dfd, const char __user *filename, struct timeval __user *utimes);
>     long sys_utimensat(int dfd, const char __user *filename, struct timespec __user *utimes, int flags);
>    +#endif
>    +long sys_futimens64at(int dfd, const char __user *filename, struct timespec64 __user *utimes, int flags);
> 
> 
>    +#ifdef __ARCH_WANT_32BIT_TIME
>     #define __NR_utimensat 88
>     #define __NR_utimes 1037
>     #define __NR_futimesat 1066
>     #define __NR_utime 1063
>    +#endif
> 
>    +#define __NR_futimens64at 277  /* next free number for asm-generic/unistd.h */
> 
> 3) Make time_t 64-bit for new 32-bit architectures right away, and worry
>    about existing architectures separately. This will mean avoiding intentional
>    ABI changes for the new architectures later, at the cost of having fringe
>    architecture use an ABI that nobody else uses, likely more broken.
> 
>    Example (as in the patch series under review):
> 
>    #ifndef __kernel_time_t
>    #typedef __s64 __kernel_time_t
>    #endif
> 
> 4) Allow combinations of the above approaches using #ifdef in the uabi
>    headers to let the libc decide at compile time which of the first two
>    it wants. At the binary level they are compatible. This is most flexible
>    but means we have to worry more about getting the corner cases right,
>    with code that is even harder to maintain.
> 
>    Example:
> 
>    #ifdef __libc_want_64bit_time
>    typedef long __kernel_oldtime_t;
>    typedef __s64 __kernel_time_t;
>    #else
>    typedef long __kernel_time_t;
>    typedef __s64 __kernel_time64_t;
>    #endif
> 
>    #ifdef __libc_want_64bit_time
>    #define __NR_oldutimensat	88
>    #define __NR_futimensat	277
>    #else
>    #define __NR_utimensat	88
>    #define __NR_futimens64at	277
>    #endif
> 
> 	Arnd
> 

