Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaBNRCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:02:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60661 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaBNRCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:02:52 -0500
Message-ID: <52FE4C28.1080500@canonical.com>
Date: Fri, 14 Feb 2014 18:02:32 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Peter Zijlstra <peterz@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
References: <20140212103713.GE3545@laptop.programming.kicks-ass.net> <20140212104017.GA5121@pd.tnic> <52FB5669.7090506@canonical.com> <20140212115412.GW27965@twins.programming.kicks-ass.net> <52FCFA23.4060701@canonical.com> <20140213173852.GH6835@laptop.programming.kicks-ass.net> <52FD090C.7010408@canonical.com> <20140213182605.GC14089@laptop.programming.kicks-ass.net> <20140214133428.GB26356@pd.tnic> <52FE2709.3050505@canonical.com> <20140214144700.GC26356@pd.tnic>
In-Reply-To: <20140214144700.GC26356@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="J4uOdmqC1RtRln2QXEvrbjRaruW9u64DQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--J4uOdmqC1RtRln2QXEvrbjRaruW9u64DQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 14.02.2014 15:47, Borislav Petkov wrote:
> On Fri, Feb 14, 2014 at 03:24:09PM +0100, Stefan Bader wrote:
>> Actually, this code just makes so much more sense if I let objdump do
>> relocation info...
>=20
> Ok, we're pretty sure you have an MFENCE there in resched_task but can
> you confirm it please.
>=20
> First, does /proc/cpuinfo have the "sse2" string? It should but nowaday=
s
> I don't trust anything.
>=20
> Then, can you boot that kernel in qemu with the -gdb flag so that it
> starts the gdb stub, here's the manpage about it:
>=20
>        -gdb dev
>            Wait for gdb connection on device dev. Typical connections w=
ill likely be
>            TCP-based, but also UDP, pseudo TTY, or even stdio are reaso=
nable use case.
>            The latter is allowing to start QEMU from within gdb and est=
ablish the
>            connection via a pipe:
>=20
>                    (gdb) target remote | exec qemu-system-i386 -gdb std=
io ...
>=20
>        -s  Shorthand for -gdb tcp::1234, i.e. open a gdbserver on TCP p=
ort 1234.
>=20
> then boot the guest and when it is up, do
>=20
> $ gdb ./vmlinux
> $ target remote localhost:1234
>=20
> and type in the prompt
>=20
> $ (gdb) x/50i resched_task
>=20
> It gives here:
>=20
> (gdb) x/50i resched_task
>    0xffffffff810836f0 <resched_task>:   data32 data32 data32 xchg %ax,%=
ax
>    0xffffffff810836f5 <resched_task+5>: push   %rbp
>    0xffffffff810836f6 <resched_task+6>: mov    0x85e123(%rip),%r10d    =
    # 0xffffffff818e1820 <debug_locks>
>    0xffffffff810836fd <resched_task+13>:        mov    %rsp,%rbp
>    0xffffffff81083700 <resched_task+16>:        push   %r12
>    0xffffffff81083702 <resched_task+18>:        test   %r10d,%r10d
>    0xffffffff81083705 <resched_task+21>:        push   %rbx
>    0xffffffff81083706 <resched_task+22>:        mov    %rdi,%rbx
>    0xffffffff81083709 <resched_task+25>:        jne    0xffffffff810837=
60 <resched_task+112>
>    0xffffffff8108370b <resched_task+27>:        mov    0x8(%rbx),%rax
>    0xffffffff8108370f <resched_task+31>:        mov    0x10(%rax),%rdx
>    0xffffffff81083713 <resched_task+35>:        and    $0x8,%edx
>    0xffffffff81083716 <resched_task+38>:        jne    0xffffffff810837=
3c <resched_task+76>
>    0xffffffff81083718 <resched_task+40>:        lock orb $0x8,0x10(%rax=
)
>    0xffffffff8108371d <resched_task+45>:        mov    0x8(%rbx),%rax
>    0xffffffff81083721 <resched_task+49>:        mov    0x18(%rax),%r12d=

>    0xffffffff81083725 <resched_task+53>:        callq  0xffffffff812d8f=
c0 <debug_smp_processor_id>
>    0xffffffff8108372a <resched_task+58>:        cmp    %r12d,%eax
>    0xffffffff8108372d <resched_task+61>:        je     0xffffffff810837=
a0 <resched_task+176>
>    0xffffffff8108372f <resched_task+63>:        mfence
>    						^^^^^^
> I want to make sure the smp_mb() is really replaced with an MFENCE ther=
e.
>=20
> Thanks!
>=20
Okaaay, I think I did what you asked. So yes, there is sse2 in the cpu in=
fo. And
there is a mfence in the disassembly:

   0xc107dcb0 <resched_task>:	push   %ebp
   0xc107dcb1 <resched_task+1>:	mov    %esp,%ebp
   0xc107dcb3 <resched_task+3>:	lea    %ds:0x0(%esi,%eiz,1),%esi
   0xc107dcb8 <resched_task+8>:	mov    0x4(%eax),%edx
   0xc107dcbb <resched_task+11>:	mov    0x8(%edx),%ecx
   0xc107dcbe <resched_task+14>:	and    $0x8,%ecx
   0xc107dcc1 <resched_task+17>:	jne    0xc107dce7 <resched_task+55>
   0xc107dcc3 <resched_task+19>:	orb    $0x8,%ds:0x8(%edx)
   0xc107dcc8 <resched_task+24>:	mov    0x4(%eax),%edx
   0xc107dccb <resched_task+27>:	mov    %fs:0xc1a71010,%ecx
   0xc107dcd2 <resched_task+34>:	mov    0x10(%edx),%edx
   0xc107dcd5 <resched_task+37>:	cmp    %ecx,%edx
   0xc107dcd7 <resched_task+39>:	je     0xc107dd00 <resched_task+80>
   0xc107dcd9 <resched_task+41>:	mfence
   0xc107dcdc <resched_task+44>:	mov    %esi,%esi
   0xc107dcde <resched_task+46>:	mov    0x4(%eax),%eax
   0xc107dce1 <resched_task+49>:	testb  $0x4,0xc(%eax)
   0xc107dce5 <resched_task+53>:	je     0xc107dcf0 <resched_task+64>
   0xc107dce7 <resched_task+55>:	pop    %ebp
   0xc107dce8 <resched_task+56>:	ret
   0xc107dce9 <resched_task+57>:	lea    0x0(%esi,%eiz,1),%esi
   0xc107dcf0 <resched_task+64>:	mov    %edx,%eax
   0xc107dcf2 <resched_task+66>:	call   *0xc1917950
   0xc107dcf8 <resched_task+72>:	pop    %ebp

Thinking about it, I guess Peter is quite right saying that I likely will=
 end on
the patch that converted preempt_count to percpu.

One thing I likely should do is to reinstall the exact same laptop with 6=
4bit
kernel and userspace... maybe only 64bit kernel first... and make sure on=
 my
side that this does not show up on 64bit, too. I took the word of reporte=
rs for
that (and the impression that otherwise many more people would have compl=
ained).



--J4uOdmqC1RtRln2QXEvrbjRaruW9u64DQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJS/kwoAAoJEOhnXe7L7s6jRXQQAMrKg1Uc6nUosBvNdBRvfwbo
IvzuBFX9t2qAQV+Lqb3b5i9zypaHjX4DDyhuupB2nTjmIalApumZhBKeyDC2E8Sd
7w7cFMvPBLtZ8WxLWp8Y0gL0bkjZz1ln273jz7WNZ+DY+LQOVJxs1iRY11nd+qdq
DRH4TOTcVZMg+ca+IQVBrTyB8glEcG16KSM9iXDKJc4DvvfA2+sBLLRXNElCubKk
qfjM4V+z1OMmIQfM/qstDdlQn6ujrkz9Y06ThZ/B2jsJEB6f1hwyqCdAQj6HUh3X
WGIQEwrxHNej7ASAsoxhzapBP7Ab8uJ3PJOrsGHIxVYjo6VfQCcFvTZX/l7KTRYt
+pJgiqnAnlic7oah3NDMrV6LrNoa/RydU7OEGDd61WHCWx6klTIEn8ETGGHQkSxd
HblSSrxoov6m1OlP7wEdNGco+U0rJgC0FSx6rqiS6VL8Z7FXOKvbQMfUkl7ETVl3
5D1PZ0RukeOBoAojaJrdRpp1gCokeoK2zeZ4K4/WWZSEyOgemA0JCnrCD1IgQYtc
Uo4OQSpb/JWnWJgX3IPNtB823FeN+q7I+dSw+LEb+Z4/v0XV3+iHPMdBvesoZsI/
tgftv3CK8AgqaehDEGI13GWQ5lWicYHjiO37QQrQSPa+vlU5us+agbWUMFi8Gqb5
V5Xk9qUDCcye6S99WVse
=gvXB
-----END PGP SIGNATURE-----

--J4uOdmqC1RtRln2QXEvrbjRaruW9u64DQ--
