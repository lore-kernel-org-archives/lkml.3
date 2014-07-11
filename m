Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaGKIA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:00:28 -0400
Received: from mout.gmx.net ([212.227.17.21]:54194 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbaGKIA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:00:26 -0400
Message-ID: <53BF998D.50903@gmx.de>
Date: Fri, 11 Jul 2014 10:00:13 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Dave Anglin <dave.anglin@bell.net>
Subject: Re: [PATCH] fix fanotify_mark() breakage on big endian 32bit kernel
 [SOLVED]
References: <20140704151235.GA22454@ls3530.dhcp.wdf.sap.corp> <20140706091530.GA3589@osiris> <trinity-8380f6e4-393a-40f8-ba95-3ab03baa85b7-1404741277414@3capp-gmx-bs54> <20140707152809.GA6373@osiris>
In-Reply-To: <20140707152809.GA6373@osiris>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:OS0O7M3ZKtieTIMZFU4NqKUWj9sK9uLcE2oiVNwRMrEQeR2BbK9
 LBez+Bw0lr4L/CAiuz1aquKn8akGQ+w/KDIUareFCkjcPAMQyjJXaDc1TJoan95XMvQA74t
 s/Uu7JkTQcCNORfUpkR09TS3pycJ98W7BKK33U4K+SzwVm3+4lhneXQ17KngCL6fJTRAmQK
 jyxZKfFCHqNAkfmhVX3xg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 05:28 PM, Heiko Carstens wrote:
> On Mon, Jul 07, 2014 at 03:54:37PM +0200, Helge Deller wrote:
>> Hi Heiko,
>>> So for sys_fanotify_mark everything is fine on s390, and probably most other
>>> architectures as well. Having a 64 bit syscall parameter indeed does work,
>>> if all the architecture specific details have been correctly considered.
>>
>> I think this is the problem!
> [...]
>> So on hppa r26 is fanotify_fd, %r25 is flags, %r24/%r23 is lower/higher 32bits of mask.
>> For the mask parameter this is different to what the __LONG_LONG_PAIR() marcro
>> would hand over to the syscall (which would be %r24/%r23 as higher/lower 32bits).
>>
>> So, the problem is the usage of __u64 in the 32bit API. It has to be handled architecture-specific.
>> It seems to work for little-endian machines, and probably (by luck?!?) for s390, but I'm not sure if
>> it maybe breaks (like on parisc) on other arches, e.g. what about sparc?
> 
> No, it's not luck that it works on s390. Whenever we add a new entry to
> our system call table, we make sure that 64 bit parameters, if present,
> work on s390.
> Otherwise we add s390 specific system calls like e.g. sys_s390_fallocate.
> 
>> For parisc I can work around that problem in the architecture-specifc coding, but I still
>> think using __64 here is wrong and just may lead to such bugs.
> 
> There have always been problems with 64 bit system call parameters on 32 bit
> architectures. See for example this thread:
> http://oss.sgi.com/archives/xfs/2007-03/msg00557.html
> 
> David Woodhouse wrote summed up the system call ABI of a couple of
> architectures a couple of years ago:
> http://marc.info/?l=linux-arch&m=118277150812137&w=2
> 
> And there was also a system call howto from Ulrich Drepper:
> http://copilotco.com/mail-archives/linux-kernel.2007/msg27844.html

It finally turned out, that on hppa we end up with different assignments of parameters to kernel arguments depending on if we call the glibc wrapper function
int fanotify_mark (int __fanotify_fd, unsigned int __flags, uint64_t __mask, int __dfd, const char *__pathname);
or directly calling the syscall manually
syscall(__NR_fanotify_mark, ...)

Reason is, that the syscall() function is implemented as C-function and because we now have the sysno as first parameter in front of the other parameters the compiler will unexpectedly add an empty paramenter in front of the u64 value to ensure the correct calling alignment for 64bit values.
This means, on hppa you can't simply use syscall() to call the kernel fanotify_mark() function directly, but you have to use the glibc function instead.

I'll push this patch through the parisc-linux git tree:
https://patchwork.kernel.org/patch/4524561/
which fixes the kernel in the hppa-arch specifc coding to adjust the parameters in a way as if userspace calls the glibc wrapper function fanotify_mark().

So, please ignore my previous patches in this thread.

Thanks!
Helge
