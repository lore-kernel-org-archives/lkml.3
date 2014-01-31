Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782AbaAaTOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:14:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46876 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236AbaAaTOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:14:15 -0500
Message-ID: <52EBF5F5.1030508@zytor.com>
Date: Fri, 31 Jan 2014 11:13:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: x86, x32: Correct invalid use of user timespec in the kernel
References: <20140131025453.B594B660CA3@gitolite.kernel.org>	<20140131175009.GA27231@redhat.com>	<52EBE62E.70102@linux.intel.com> <CA+55aFwcgGPb=5cTnkKpP4vH2kqCCvxGteZT58efHhg3aJjcfQ@mail.gmail.com>
In-Reply-To: <CA+55aFwcgGPb=5cTnkKpP4vH2kqCCvxGteZT58efHhg3aJjcfQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 10:45 AM, Linus Torvalds wrote:
> On Fri, Jan 31, 2014 at 10:06 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>
>> My feeling is that {get,put}_compat_timespec() should at the very least
>> have leading underscores to flag it as a low-level function, but better
>> suggestions would be appreciated.
> 
> Why not just remove it entirely, and change all users to
> compat_[get|set]_timespec (same for timeval etc, of course).
> 
> After all, compat_*_time*() does fall back cleanly for non-x32 cases.
> And sure, maybe that particular code is never *needed* for x32
> support, but the overhead is generally zero (since in most cases X32
> isn't even configured), or very low anyway. So the upside of having
> two subtly incompatible interfaces is very dubious, no?
> 

Hmmm... it ends up being a bit weird even so.  Some of the interfaces
ought to be revamped at a higher level.

Consider this bit in ipc/compat.c:

long compat_sys_semtimedop(int semid, struct sembuf __user *tsems,
                unsigned nsops, const struct compat_timespec __user
*timeout)
{
        struct timespec __user *ts64 = NULL;
        if (timeout) {
                struct timespec ts;
                ts64 = compat_alloc_user_space(sizeof(*ts64));
                if (get_compat_timespec(&ts, timeout))
                        return -EFAULT;
                if (copy_to_user(ts64, &ts, sizeof(ts)))
                        return -EFAULT;
        }
        return sys_semtimedop(semid, tsems, nsops, ts64);
}

This is most definitely broken if COMPAT_USE_64BIT_TIME, even with
get_compat_timespec() is replaced by compat_get_timespec().  However,
what is *really* going on here is that we want to provide a user space
pointer to a kernel-format timespec, so we could have an interface like
this:

int compat_convert_timespec_user(struct compat_timespec **ts64p,
const struct compat_timespec __user *ts)
{
        struct timespec __user *ts64;
        struct timespec ts;

	/* If the compat timespec is 64 bits, no conversion is needed */
	if (!ts || COMPAT_USE_64BIT_TIME) {
		*ts64p = (struct timespec __user *)ts;
		return 0;
	}

	*ts64p = ts64 = compat_alloc_user_space(sizeof(*ts64));
        if (__get_compat_timespec(&ts, timeout))
		return -EFAULT;
	if (copy_to_user(ts64, &ts, sizeof(ts)))
        	return -EFAULT;

	return 0;
}

Now one can argue we have a potential problem with type safety here, but
I'm not sure there is any way to avoid that.

	-hpa

