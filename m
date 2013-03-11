Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab3CKNHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:07:13 -0400
Received: from multi.imgtec.com ([194.200.65.239]:7955 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab3CKNHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:07:10 -0400
Message-ID: <513DD6FB.4000400@imgtec.com>
Date: Mon, 11 Mar 2013 13:07:07 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Markos <markos.chandras@imgtec.com>
Subject: Re: SYSV IPC broken for no-legacy syscall kernels (was Re: [RFC PATCH
 v1 26/31] ARC: Build system: Makefiles, Kconfig, Linker script)
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-27-git-send-email-vgupta@synopsys.com> <201211071413.49178.arnd@arndb.de> <513DCE2D.6010800@synopsys.com> <513DD1C6.4040401@imgtec.com> <513DD464.2060008@synopsys.com>
In-Reply-To: <513DD464.2060008@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_11_13_07_07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/13 12:56, Vineet Gupta wrote:
> Hi James,
> 
> On Monday 11 March 2013 06:14 PM, James Hogan wrote:
>> Hi Vineet,
>>
>> On 11/03/13 12:29, Vineet Gupta wrote:
>>> On Wednesday 07 November 2012 07:43 PM, Arnd Bergmann wrote:
>>>> On Wednesday 07 November 2012, Vineet Gupta wrote:
>>>>
>>>>> +
>>>>> +config ARC
>>>>> +	def_bool y
>>>>> +	select ARCH_WANT_IPC_PARSE_VERSION
>>>>> +	# ARC Busybox based initramfs absolutely relies on DEVTMPFS for /dev
>>>>> +	# DEVTMPS in turn needs HOTPLUG
>>>>> +	select DEVTMPFS if !INITRAMFS_SOURCE=""
>>>>> +	select GENERIC_ATOMIC64
>>>>> +	select GENERIC_CLOCKEVENTS
>>>>> +	select GENERIC_FIND_FIRST_BIT
>>>>> +	# for now, we don't need GENERIC_IRQ_PROBE, CONFIG_GENERIC_IRQ_CHIP
>>>>> +	select GENERIC_IRQ_SHOW
>>>>> +	select GENERIC_PENDING_IRQ if SMP
>>>>> +	select GENERIC_SMP_IDLE_THREAD
>>>>> +	select HAVE_GENERIC_HARDIRQS
>>>>> +	select HOTPLUG if !INITRAMFS_SOURCE=""
>>>>> +	select MODULES_USE_ELF_RELA
>>>> You should not need ARCH_WANT_IPC_PARSE_VERSION
>>> It seems, we have a small bug in sysV IPC.
>>> A lot of LTP tests have started failing on ARC 3.9-rc1 kernel due to absence of
>>> ARCH_WANT_IPC_PARSE_VERSION.
>>>
>>> I'm assuming that for newer arches, msgctl(2) and friends need to have  need to
>>> have @cmd of type 0x01nn where 0x0100 is IPC_64.
>>> However for ! ARCH_WANT_IPC_PARSE_VERSION, ipc/util.h seems to be defining a dummy
>>> version of ipc_parse_version(), which doesn't strip out the 0x0100 from @cmds,
>>> causing the code to not enter the switch block in SYSCALL_DEFINE3(msgctl) making
>>> it fail.
>>> Adding the above item to arch/arc/Kconfig obviously fixes the breakage.
>>>
>>> It seems there is some bogosity in the way ipc_parse_version() is defined. Given
>>> the way it is used, to strip out the 0x0100 bit, it seems we always need the
>>> function variant - the IA-64 ish comment in there seems to be bit-rot.
>>>
>>> What do you think ?
>> FYI, for metag we assumed this was intentional and that IPC_64 shouldn't
>> be passed since it is the default behaviour for new arches.
>> You may find the following uClibc commit relevant:
>> http://git.uclibc.org/uClibc/commit/?id=6c2fa3451f35f8d78a31689044b2d19efa4eaca2
> 
> I've been using uClibc trunk - ported to ARC - for my testing, so I already have
> that change. Looking at Markos' uClibc branch he is indeed defining __IPC_64 to 0
> in metag port.
> However, looking at the kernel code, it seems newer style is to do the other way
> round - i.e. pass 0x0100 in those cmds - unless the comments in there are bogus.
> 
> include/uapi/linux/ipc.h
> 
> /*
>  * Version flags for semctl, msgctl, and shmctl commands
>  * These are passed as bitflags or-ed with the actual command
>  */
> #define IPC_OLD 0    /* Old version (no 32-bit UID support on many
>                architectures) */
> #define IPC_64  0x0100  /* New version (support 32-bit UIDs, bigger
>                message sizes, etc. */
> 
> So someone with more ABI wisdom needs to suggest what is the right approach.

Agreed.

Note that in uClibc, 64bit arches (excl alpha/mips for some reason) were
already defining __IPC_64 as 0, so there's some precedent for it working
the way it does.

Cheers
James

