Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191AbaGDRDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:03:44 -0400
Received: from mout.gmx.net ([212.227.15.19]:51077 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbaGDRDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:03:42 -0400
Message-ID: <53B6DE64.4000706@gmx.de>
Date: Fri, 04 Jul 2014 19:03:32 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
CC: Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] fix fanotify_mark() breakage on big endian 32bit kernel
References: <20140704151235.GA22454@ls3530.dhcp.wdf.sap.corp> <53B6DAE1.1040709@gmx.de>
In-Reply-To: <53B6DAE1.1040709@gmx.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:hkNtITXNeMSPnynLFxgBBNs6BBYi4AiOXzR5v5gDnSMrRPmPFmn
 7UL65QV2LcZA2fBR8I5D1ibfM6dC9MlxldZghUAEcsHh5A6Vq5q3E1oI0wDkJ/pK6Nw5be2
 ahJgUOCBMa3ukv6wXLWQvCn/IIp9RXJifIPuoQwM8kTpgHLRsMAouuDwgw7u0a+MxIQM29D
 qzHvRKvf/Xm4RmR0VPSpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heinrich,

On 07/04/2014 06:48 PM, Heinrich Schuchardt wrote:
> On 04.07.2014 17:12, Helge Deller wrote:
>> This patch affects big endian architectures only.
>>
>> On those with 32bit userspace and 64bit kernel (CONFIG_COMPAT=y) the
>> 64bit mask parameter is correctly constructed out of two 32bit values in
>> the compat_fanotify_mark() function and then passed as 64bit parameter
>> to the fanotify_mark() syscall.
>>
>> But for the CONFIG_COMPAT=n case (32bit kernel & userspace),
>> compat_fanotify_mark() isn't used and the fanotify_mark syscall implementation
> 
> I was not able to find a symbol compat_fanotify_mark. Could you, please, indicate were this coding is.

fs/notify/fanotify/fanotify_user.c around line 892:
#ifdef CONFIG_COMPAT
COMPAT_SYSCALL_DEFINE6(fanotify_mark,
                                int, fanotify_fd, unsigned int, flags,
                                __u32, mask0, __u32, mask1, int, dfd,
                                const char  __user *, pathname)

>> is used directly. In that case the upper and lower 32 bits of the 64bit mask
>> parameter is still swapped on big endian machines and thus leads to
>> fanotify_mark failing with -EINVAL.
>>
>> Here is a strace of the same 32bit executable (fanotify01 testcase from LTP):
> 
> https://github.com/linux-test-project/ltp
> testcases/kernel/syscalls/fanotify/fanotify01.c
> I guess.

Yes.

>> On a 64bit kernel it suceeds:
>> syscall_322(0, 0, 0x3, 0x3, 0x266c8, 0x1) = 0x3
>> syscall_323(0x3, 0x1, 0, 0x3b, 0xffffff9c, 0x266c8) = 0
>>
>> On a 32bit kernel it fails:
>> syscall_322(0, 0, 0x3, 0x3, 0x266c8, 0x1) = 0x3
>> syscall_323(0x3, 0x1, 0, 0x3b, 0xffffff9c, 0x266c8) = -1 (errno 22)
> 
> The syscall numbers are architecture specific.
> Which architecture did you test on?

Yes, the numbers are architecture specifc.
I tested on HP-PARISC (parisc arch) with 32- and 64bit kernel.

>> Below is the easiest fix for this problem by simply swapping the upper and
>> lower 32bit of the 64 bit mask parameter when building a pure 32bit kernel.
> 
> The problem you report is architecture specific.

It affects all *big endian* architectures (parisc, s390, ppc, ...)
So, if people could test it with a 32bit kernel on those other architectures
it would be nice.

> Is fanotify_user.c really the right place for the correction?
> Or should the fix be in the "arch" directory?

I don't think the fix should go in the arch architectures, because
then you have to modify it for each big endian arch.

>> But on the other side, using __u64 in a syscall API is IMHO wrong.  This may
>> easily break 32bit kernel builds, esp. on big endian machines.
>>
>> The clean solution would probably be to use SYSCALL_DEFINE5() when
>> building a 64bit-kernel, and SYSCALL_DEFINE6() for fanotify_mark() when
>> building a pure 32bit kernel, something like this:

Again, I think using __u64 as type for a generic syscall is wrong, esp.
if the same code is compiled for 32- and 64bit. 
This is my (uncomplete!) suggestion, but it would add many more lines and 
makes reading the code more complicated.

>> #ifdef CONFIG_64BIT
>> SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
>>                                __u64, mask, int, dfd,
>>                                const char  __user *, pathname)
>> #else
>> SYSCALL_DEFINE6(fanotify_mark, int, fanotify_fd, unsigned int, flags,
>>                                  __u32, mask0, __u32, mask1, int, dfd,
>>                                  const char  __user *, pathname)
>> #endif
>>
>>
>> Signed-off-by: Helge Deller <deller@gmx.de>
>> To: Eric Paris <eparis@redhat.com>
>> Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
>> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
>>
>>
>> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
>> index 3fdc8a3..374261c 100644
>> --- a/fs/notify/fanotify/fanotify_user.c
>> +++ b/fs/notify/fanotify/fanotify_user.c
>> @@ -787,6 +787,10 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
>>       struct path path;
>>       int ret;
>>
>> +#if defined(__BIG_ENDIAN) && !defined(CONFIG_64BIT)
>> +    mask = (mask << 32) | (mask >> 32);
>> +#endif
>> +
>>       pr_debug("%s: fanotify_fd=%d flags=%x dfd=%d pathname=%p mask=%llx\n",
>>            __func__, fanotify_fd, flags, dfd, pathname, mask);
>>

