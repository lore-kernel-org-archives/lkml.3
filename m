Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbbAJVFf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:05:35 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:39503 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbbAJVFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:05:33 -0500
MIME-Version: 1.0
In-Reply-To: <20150108122928.GB20632@pd.tnic>
References: <cover.1415403984.git.luto@amacapital.net> <49394403b8b12486a6b9c9c70b72bd9f5dce7364.1415403984.git.luto@amacapital.net>
 <20150108122928.GB20632@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 10 Jan 2015 13:05:11 -0800
Message-ID: <CALCETrWbZ9g-61e5bw8bw2irkA+Yr1ESGKSTMaQEvQwsknyUeA@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86_64,entry: Use sysret to return to userspace when possible
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2015 at 4:29 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Nov 07, 2014 at 03:58:18PM -0800, Andy Lutomirski wrote:
>> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
>> index 3710b8241945..a5afdf0f7fa4 100644
>> --- a/arch/x86/kernel/entry_64.S
>> +++ b/arch/x86/kernel/entry_64.S
>> @@ -804,6 +804,54 @@ retint_swapgs:           /* return to user-space */
>
> Ok, so retint_swapgs is also on the error_exit path.
>
> What you're basically proposing is to use SYSRET on exceptions exit
> too AFAICT. And while I don't see anything wrong with the patch, you
> probably need to run this by more people like tip guys + Linus just in
> case. We can't allow ourselves to leak stuff here.

I'll cc Linus et all on v2.

>
>>        */
>>       DISABLE_INTERRUPTS(CLBR_ANY)
>>       TRACE_IRQS_IRETQ
>> +
>> +     /*
>> +      * Try to use SYSRET instead of IRET if we're returning to
>> +      * a completely clean 64-bit userspace context.
>> +      */
>> +     movq (RCX-R11)(%rsp), %rcx
>> +     cmpq %rcx,(RIP-R11)(%rsp)               /* RCX == RIP */
>> +     jne opportunistic_sysret_failed
>> +
>> +     /*
>> +      * On Intel CPUs, sysret with non-canonical RCX/RIP will #GP
>> +      * in kernel space.  This essentially lets the user take over
>> +      * the kernel, since userspace controls RSP.  It's not worth
>> +      * testing for canonicalness exactly -- this check detects any
>> +      * of the 17 high bits set, which is true for non-canonical
>> +      * or kernel addresses.  (This will pessimize vsyscall=native.
>> +      * Big deal.)
>> +      */
>> +     shr $47, %rcx
>
>         shr $__VIRTUAL_MASK_SHIFT, %rcx
>
> I guess, in case someone decides to play with the address space again
> and forgets this naked bit here.
>

I'll probably add a build-time assertion that __VIRTUAL_MASK_SHIFT ==
47 instead.  If we ever support CPUs with an extra level of page
tables, we'll probably need to patch the instruction, since we have a
security hole if that shift ever exceeds 47 on existing CPUs.

--Andy

>> +     jnz opportunistic_sysret_failed
>> +
>> +     cmpq $__USER_CS,(CS-R11)(%rsp)          /* CS must match SYSRET */
>> +     jne opportunistic_sysret_failed
>> +
>> +     movq (R11-R11)(%rsp), %r11
>> +     cmpq %r11,(EFLAGS-R11)(%rsp)            /* R11 == RFLAGS */
>> +     jne opportunistic_sysret_failed
>> +
>> +     testq $X86_EFLAGS_RF,%r11               /* sysret can't restore RF */
>> +     jnz opportunistic_sysret_failed
>> +
>> +     /* nothing to check for RSP */
>> +
>> +     cmpq $__USER_DS,(SS-R11)(%rsp)          /* SS must match SYSRET */
>> +     jne opportunistic_sysret_failed
>> +
>> +     /*
>> +      * We win!  This label is here just for ease of understanding
>> +      * perf profiles.  Nothing jumps here.
>> +      */
>> +irq_return_via_sysret:
>> +     CFI_REMEMBER_STATE
>> +     RESTORE_ARGS 1,8,1
>> +     movq (RSP-RIP)(%rsp),%rsp
>> +     USERGS_SYSRET64
>> +     CFI_RESTORE_STATE
>> +
>> +opportunistic_sysret_failed:
>>       SWAPGS
>>       jmp restore_args
>
> Ok, dammit, it happened again:
>
> ...
> [   13.480778] BTRFS info (device sda9): disk space caching is enabled
> [   13.487270] BTRFS: has skinny extents
> [   14.368392] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   15.928679] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
> [   15.936406] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
> [   15.942879] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [  115.065408] ata1.00: exception Emask 0x0 SAct 0x7fd80000 SErr 0x0 action 0x6 frozen
> [  115.073159] ata1.00: failed command: WRITE FPDMA QUEUED
> [  115.078459] ata1.00: cmd 61/80:98:c0:e7:35/4a:00:1f:00:00/40 tag 19 ncq 9764864 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  115.093623] ata1.00: status: { DRDY }
> [  115.097314] ata1.00: failed command: WRITE FPDMA QUEUED
> [  115.102569] ata1.00: cmd 61/30:a0:40:32:36/20:00:1f:00:00/40 tag 20 ncq 4218880 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  115.117668] ata1.00: status: { DRDY }
> [  115.121351] ata1.00: failed command: WRITE FPDMA QUEUED
> [  115.126602] ata1.00: cmd 61/80:b0:80:f7:37/20:00:1f:00:00/40 tag 22 ncq 4259840 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  115.141701] ata1.00: status: { DRDY }
> [  115.145389] ata1.00: failed command: WRITE FPDMA QUEUED
> [  115.150638] ata1.00: cmd 61/90:b8:70:52:36/03:00:1f:00:00/40 tag 23 ncq 466944 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  115.165682] ata1.00: status: { DRDY }
> [  115.169357] ata1.00: failed command: WRITE FPDMA QUEUED
> [  115.174617] ata1.00: cmd 61/c0:c0:00:58:36/39:00:1f:00:00/40 tag 24 ncq 7569408 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  115.189713] ata1.00: status: { DRDY }
> [  115.193400] ata1.00: failed command: WRITE FPDMA QUEUED
> [  115.198650] ata1.00: cmd 61/80:c8:c0:91:36/4b:00:1f:00:00/40 tag 25 ncq 9895936 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  115.213755] ata1.00: status: { DRDY }
> [  115.217431] ata1.00: failed command: WRITE FPDMA QUEUED
> [  115.222692] ata1.00: cmd 61/80:d0:40:dd:36/4a:00:1f:00:00/40 tag 26 ncq 9764864 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  115.237788] ata1.00: status: { DRDY }
> [  115.241479] ata1.00: failed command: WRITE FPDMA QUEUED
> [  115.246723] ata1.00: cmd 61/40:d8:c0:27:37/30:00:1f:00:00/40 tag 27 ncq 6324224 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  115.261825] ata1.00: status: { DRDY }
> [  115.265519] ata1.00: failed command: READ FPDMA QUEUED
> [  115.270683] ata1.00: cmd 60/08:e0:40:98:18/00:00:1f:00:00/40 tag 28 ncq 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  115.285432] ata1.00: status: { DRDY }
> [  115.289113] ata1.00: failed command: WRITE FPDMA QUEUED
> [  115.294367] ata1.00: cmd 61/00:e8:00:58:37/15:00:1f:00:00/40 tag 29 ncq 2752512 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  115.309463] ata1.00: status: { DRDY }
> [  115.313149] ata1.00: failed command: WRITE FPDMA QUEUED
> [  115.318399] ata1.00: cmd 61/00:f0:00:6d:37/2b:00:1f:00:00/40 tag 30 ncq 5636096 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  115.333503] ata1.00: status: { DRDY }
> [  115.337201] ata1: hard resetting link
> [  115.645895] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  115.743776] ata1.00: configured for UDMA/133
> [  115.748074] ata1.00: device reported invalid CHS sector 0
> [  115.753516] ata1.00: device reported invalid CHS sector 0
> [  115.758947] ata1.00: device reported invalid CHS sector 0
> [  115.764383] ata1.00: device reported invalid CHS sector 0
> [  115.769825] ata1.00: device reported invalid CHS sector 0
> [  115.775260] ata1.00: device reported invalid CHS sector 0
> [  115.780689] ata1.00: device reported invalid CHS sector 0
> [  115.786123] ata1.00: device reported invalid CHS sector 0
> [  115.791563] ata1.00: device reported invalid CHS sector 0
> [  115.796998] ata1.00: device reported invalid CHS sector 0
> [  115.802431] ata1.00: device reported invalid CHS sector 0
> [  115.807914] ata1: EH complete
> [  146.085052] ata1.00: exception Emask 0x0 SAct 0x77c SErr 0x0 action 0x6 frozen
> [  146.092320] ata1.00: failed command: READ FPDMA QUEUED
> [  146.097489] ata1.00: cmd 60/08:10:40:98:18/00:00:1f:00:00/40 tag 2 ncq 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  146.112367] ata1.00: status: { DRDY }
> [  146.116244] ata1.00: failed command: WRITE FPDMA QUEUED
> [  146.121696] ata1.00: cmd 61/40:18:c0:27:37/30:00:1f:00:00/40 tag 3 ncq 6324224 out
>          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  146.137389] ata1.00: status: { DRDY }
> [  146.141267] ata1.00: failed command: WRITE FPDMA QUEUED
> [  146.146710] ata1.00: cmd 61/80:20:40:dd:36/4a:00:1f:00:00/40 tag 4 ncq 9764864 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  146.162395] ata1.00: status: { DRDY }
> [  146.166269] ata1.00: failed command: WRITE FPDMA QUEUED
> [  146.171723] ata1.00: cmd 61/80:28:c0:91:36/4b:00:1f:00:00/40 tag 5 ncq 9895936 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  146.187402] ata1.00: status: { DRDY }
> [  146.191278] ata1.00: failed command: WRITE FPDMA QUEUED
> [  146.196718] ata1.00: cmd 61/c0:30:00:58:36/39:00:1f:00:00/40 tag 6 ncq 7569408 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  146.212399] ata1.00: status: { DRDY }
> [  146.216275] ata1.00: failed command: WRITE FPDMA QUEUED
> [  146.221723] ata1.00: cmd 61/80:40:80:f7:37/20:00:1f:00:00/40 tag 8 ncq 4259840 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  146.237407] ata1.00: status: { DRDY }
> [  146.241280] ata1.00: failed command: WRITE FPDMA QUEUED
> [  146.246725] ata1.00: cmd 61/30:48:40:32:36/20:00:1f:00:00/40 tag 9 ncq 4218880 out
>          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  146.262407] ata1.00: status: { DRDY }
> [  146.266282] ata1.00: failed command: WRITE FPDMA QUEUED
> [  146.271731] ata1.00: cmd 61/80:50:c0:e7:35/4a:00:1f:00:00/40 tag 10 ncq 9764864 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  146.287498] ata1.00: status: { DRDY }
> [  146.291371] ata1: hard resetting link
> [  146.599768] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  146.608680] ata1.00: configured for UDMA/133
> [  146.613180] ata1.00: device reported invalid CHS sector 0
> [  146.618807] ata1.00: device reported invalid CHS sector 0
> [  146.624430] ata1.00: device reported invalid CHS sector 0
> [  146.630048] ata1.00: device reported invalid CHS sector 0
> [  146.635658] ata1.00: device reported invalid CHS sector 0
> [  146.641270] ata1.00: device reported invalid CHS sector 0
> [  146.646881] ata1.00: device reported invalid CHS sector 0
> [  146.652484] ata1.00: device reported invalid CHS sector 0
> [  146.658122] ata1: EH complete
> [  177.110908] ata1.00: exception Emask 0x0 SAct 0x7f800 SErr 0x0 action 0x6 frozen
> [  177.118525] ata1.00: failed command: WRITE FPDMA QUEUED
> [  177.123960] ata1.00: cmd 61/80:58:c0:e7:35/4a:00:1f:00:00/40 tag 11 ncq 9764864 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  177.139559] ata1.00: status: { DRDY }
> [  177.143419] ata1.00: failed command: WRITE FPDMA QUEUED
> [  177.148849] ata1.00: cmd 61/30:60:40:32:36/20:00:1f:00:00/40 tag 12 ncq 4218880 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  177.164454] ata1.00: status: { DRDY }
> [  177.168311] ata1.00: failed command: WRITE FPDMA QUEUED
> [  177.173747] ata1.00: cmd 61/80:68:80:f7:37/20:00:1f:00:00/40 tag 13 ncq 4259840 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  177.189387] ata1.00: status: { DRDY }
> [  177.193254] ata1.00: failed command: WRITE FPDMA QUEUED
> [  177.198691] ata1.00: cmd 61/c0:70:00:58:36/39:00:1f:00:00/40 tag 14 ncq 7569408 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  177.214430] ata1.00: status: { DRDY }
> [  177.218304] ata1.00: failed command: WRITE FPDMA QUEUED
> [  177.223755] ata1.00: cmd 61/80:78:c0:91:36/4b:00:1f:00:00/40 tag 15 ncq 9895936 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  177.239575] ata1.00: status: { DRDY }
> [  177.243460] ata1.00: failed command: WRITE FPDMA QUEUED
> [  177.248908] ata1.00: cmd 61/80:80:40:dd:36/4a:00:1f:00:00/40 tag 16 ncq 9764864 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  177.264743] ata1.00: status: { DRDY }
> [  177.268622] ata1.00: failed command: WRITE FPDMA QUEUED
> [  177.274075] ata1.00: cmd 61/40:88:c0:27:37/30:00:1f:00:00/40 tag 17 ncq 6324224 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  177.289913] ata1.00: status: { DRDY }
> [  177.293795] ata1.00: failed command: READ FPDMA QUEUED
> [  177.299153] ata1.00: cmd 60/08:90:40:98:18/00:00:1f:00:00/40 tag 18 ncq 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  177.314633] ata1.00: status: { DRDY }
> [  177.318509] ata1: hard resetting link
> [  177.626616] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  177.968639] ata1.00: configured for UDMA/133
> [  177.973609] ata1.00: device reported invalid CHS sector 0
> [  177.979669] ata1.00: device reported invalid CHS sector 0
> [  177.985723] ata1.00: device reported invalid CHS sector 0
> [  177.991371] ata1.00: device reported invalid CHS sector 0
> [  177.997008] ata1.00: device reported invalid CHS sector 0
> [  178.002641] ata1.00: device reported invalid CHS sector 0
> [  178.008260] ata1.00: device reported invalid CHS sector 0
> [  178.013886] ata1.00: device reported invalid CHS sector 0
> [  178.019558] ata1: EH complete
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --



-- 
Andy Lutomirski
AMA Capital Management, LLC
