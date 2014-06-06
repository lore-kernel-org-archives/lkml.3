Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaFFUib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 16:38:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37728 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbaFFUia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 16:38:30 -0400
Message-ID: <53922686.6010301@zytor.com>
Date: Fri, 06 Jun 2014 13:37:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Fleming, Matt" <matt.fleming@intel.com>
CC: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, jkosina@suse.cz, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [RFC PATCH 00/13][V3] kexec: A new system call to allow in kernel
 loading
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com> <20140603131203.GA23395@redhat.com> <20140605083134.GE3506@darkstar.nay.redhat.com> <20140605150159.GA14083@redhat.com> <20140606073748.GC3343@darkstar.nay.redhat.com>
In-Reply-To: <20140606073748.GC3343@darkstar.nay.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 12:37 AM, Dave Young wrote:
> On 06/05/14 at 11:01am, Vivek Goyal wrote:
>> On Thu, Jun 05, 2014 at 04:31:34PM +0800, Dave Young wrote:
>>
>> [..]
>>>> +	ret = kexec_file_load(kernel_fd, info.initrd_fd, info.command_line,
>>>> +			info.command_line_len, info.kexec_flags);
>>>
>>> Vivek,
>>>
>>> I tried your patch on my uefi test machine, but kexec load fails like below:
>>>
>>> [root@localhost ~]# kexec -l /boot/vmlinuz-3.15.0-rc8+ --use-kexec2-syscall
>>> Could not find a free area of memory of 0xa000 bytes ...
>>
>> Hi Dave,
>>
>> I think this message is coming from kexec-tools from old loading path. I
>> think somehow new path did not even kick in. I tried above and I got
>> -EBADF as I did not pass initrd. Can you run gdb on kexec and see if
>> you are getting to syscall or run strace.
> 
> Seems I can not reproduce the local hole fail issue but I'm sure it happens
> before the new syscall callback.
> 
> This time I got -ENOEXEC. It's caused by CONFIG_EFI_MIXED=y. In case EFI_MIXED
> 64bit kernel runs on 32bit efi firmware thus XLF_CAN_BE_LOADED_ABOVE_4G is not
> set thus bzImage probe will fail with NOEXEC.
> 

OK... this is seriously problematic.

#if defined(CONFIG_RELOCATABLE) && defined(CONFIG_X86_64) && \
	!defined(CONFIG_EFI_MIXED)
   /* kernel/boot_param/ramdisk could be loaded above 4g */
# define XLF1 XLF_CAN_BE_LOADED_ABOVE_4G
#else
# define XLF1 0
#endif

The fact that even compiling with CONFIG_EFI_MIXED disables
XLF_CAN_BE_LOADED_ABOVE_4G is really not going to fly.  We should expect
CONFIG_EFI_MIXED to be the norm, but *also* should expect that there is
a legitimate need to load above 4G.

Matt, could you explain why this is necessary?  We need to figure out a
way around this.

My thinking is that disabling this flag is unnecessary, since a 32-bit
EFI loader should not load above the 4G mark anyway, but if I'm confused
and there is a more fundamental requirement, then we need to consider
that more carefully.

	-hpa

