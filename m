Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbaGAPa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:30:58 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:13108
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754356AbaGAPa5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:30:57 -0400
From: "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Andrew Pinski <apinski@cavium.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 22/24] ARM64:ILP32: Use a seperate syscall table as a few
 syscalls need to be using the compat syscalls.
Thread-Topic: [PATCH 22/24] ARM64:ILP32: Use a seperate syscall table as a few
 syscalls need to be using the compat syscalls.
Thread-Index: AQHPdx8d9AUdHoaZskG1gR74ly8n2JuLjZiAgAAHC2I=
Date: Tue, 1 Jul 2014 15:30:51 +0000
Message-ID: <800835FF-E10A-4C0C-A68F-0ED1434F1CE2@caviumnetworks.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
 <1400914939-9708-23-git-send-email-apinski@cavium.com>,<20140701150539.GA18309@arm.com>
In-Reply-To: <20140701150539.GA18309@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.253.2.104]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02596AB7DA
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(199002)(189002)(24454002)(51704005)(164054003)(377454003)(101416001)(86362001)(77982001)(79102001)(20776003)(36756003)(64706001)(77096002)(66066001)(83716003)(2656002)(80022001)(105586002)(106356001)(81542001)(85306003)(81342001)(87936001)(95666004)(107046002)(83072002)(85852003)(54356999)(92726001)(82746002)(19580395003)(74502001)(74662001)(83322001)(76482001)(19580405001)(46102001)(21056001)(106116001)(99286002)(4396001)(33656002)(50986999)(76176999)(99396002)(104396001);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR07MB128;H:CO1PR07MB127.namprd07.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On Jul 1, 2014, at 8:07 AM, "Catalin Marinas" <catalin.marinas@arm.com> wrote:
> 
>> On Sat, May 24, 2014 at 12:02:17AM -0700, Andrew Pinski wrote:
>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>> index 1e1ebfc..8241ffe 100644
>> --- a/arch/arm64/kernel/entry.S
>> +++ b/arch/arm64/kernel/entry.S
>> @@ -620,9 +620,14 @@ ENDPROC(ret_from_fork)
>>  */
>>    .align    6
>> el0_svc:
>> -    adrp    stbl, sys_call_table        // load syscall table pointer
>>    uxtw    scno, w8            // syscall number in w8
>>    mov    sc_nr, #__NR_syscalls
>> +#ifdef CONFIG_ARM64_ILP32
>> +    get_thread_info tsk
>> +    ldr    x16, [tsk, #TI_FLAGS]
>> +    tbnz    x16, #TIF_32BIT_AARCH64, el0_ilp32_svc // We are using ILP32
>> +#endif
>> +    adrp    stbl, sys_call_table        // load syscall table pointer
> 
> This adds a slight penalty on the AArch64 SVC entry path. I can't tell
> whether that's visible or not but I think the x86 guys decided to set an
> extra bit to the syscall number to distinguish it from native calls.
> 
>> diff --git a/arch/arm64/kernel/sys_ilp32.c b/arch/arm64/kernel/sys_ilp32.c
>> new file mode 100644
>> index 0000000..1da1d11
>> --- /dev/null
>> +++ b/arch/arm64/kernel/sys_ilp32.c
> [...]
>> +/*
>> + * Wrappers to pass the pt_regs argument.
>> + */
>> +#define sys_rt_sigreturn sys_rt_sigreturn_wrapper
>> +
>> +
>> +/* Using Compat syscalls where necessary */
>> +#define sys_ioctl        compat_sys_ioctl
>> +/* iovec */
>> +#define sys_readv        compat_sys_readv
>> +#define sys_writev        compat_sys_writev
>> +#define sys_preadv        compat_sys_preadv64
>> +#define sys_pwritev        compat_sys_pwritev64
>> +#define sys_vmsplice        compat_sys_vmsplice
> 
> Do these actually work? compat_iovec has two members of 32-bit each
> while the ILP32 iovec has a void * (32-bit) and a __kernel_size_t which
> is 64-bit.

size_t should be unsigned long in ilp32 so a 32bit unsigned integer type.  That part of the abi was already defined in the arm abi documents.  Now are saying we should pass size_t different between user and kernel space?

> 
>> +/* robust_list_head */
>> +#define sys_set_robust_list    compat_sys_set_robust_list
>> +#define sys_get_robust_list    compat_sys_get_robust_list
> 
> Same here, we have a size_t * argument. The compat function would write
> back 32-bit but size_t is 64-bit for ILP32.

See above. Size_t is 32bits. 

> 
>> +/* kexec_segment */
>> +#define sys_kexec_load        compat_sys_kexec_load
> 
> More size_t members in the kexec_segment structure (but we don't yet
> have kexec on arm64).

See above. Size_t is 32bits. 

> 
>> +/* struct msghdr */
>> +#define sys_recvfrom        compat_sys_recvfrom
> 
> Why compat here? struct sockaddr seems to be the same as the native one.
> 
>> +#define sys_recvmmsg        compat_sys_recvmmsg
>> +#define sys_sendmmsg        compat_sys_sendmmsg
>> +#define sys_sendmsg        compat_sys_sendmsg
>> +#define sys_recvmsg        compat_sys_recvmsg
> 
> These get messier as well with a different size_t affecting struct
> msghdr.

See above about size_t. 


> 
>> +#define sys_setsockopt        compat_sys_setsockopt
>> +#define sys_getsockopt        compat_sys_getsockopt
> 
> Looking at the sock_getsockopt() function, we have a union v copied
> to/from user. However, such a union contains a struct timeval which for
> ILP32 would be different than the compat one.

I will look into this one but it might already be taken care of due to the compact uses 64bit time spec define. I will add a comment saying that if it is true. 


> 
>> +/* iovec */
>> +#define sys_process_vm_readv    compat_sys_process_vm_readv
>> +#define sys_process_vm_writev    compat_sys_process_vm_writev
> 
> See above for iovec.

See above for my size_t question. 

> 
>> +/* Pointer in struct */
>> +#define sys_mount               compat_sys_mount
> 
> Which structure is this?

NFS structure, I can expand out the comment if needed. 


> 
>> +/* Scheduler */
>> +/* unsigned long bitmaps */
>> +#define sys_sched_setaffinity   compat_sys_sched_setaffinity
>> +#define sys_sched_getaffinity   compat_sys_sched_getaffinity
> 
> Does the long bitmask matter here? I can see the length is passed in
> bytes.

Yes for big endian. If we were only supporting little endian, bit fields would not matter. 

> 
>> +/* iov usage */
>> +#define sys_keyctl              compat_sys_keyctl
> 
> Same problem as iovec above.
> 
>> +/* aio */
>> +/* Pointer to Pointer  */
>> +#define sys_io_setup        compat_sys_io_setup
> 
> sys_io_setup takes a pointer to aio_context_t which is defined as
> __kernel_ulong_t (same as LP64).

Let me look at why I did this one, I think the code which used aio was not in glibc which is why I used the compat version. 

Thanks,
Andrew

> 
> -- 
> Catalin
