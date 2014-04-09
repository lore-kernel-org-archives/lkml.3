Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbaDIJOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 05:14:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35777 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209AbaDIJOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 05:14:53 -0400
Message-ID: <53450F7E.7040904@canonical.com>
Date: Wed, 09 Apr 2014 11:14:38 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-1?Q?Toralf_F=F6rs?= =?ISO-8859-1?Q?ter?= 
	<toralf.foerster@gmx.de>
CC: Michele Ballabio <barra_cuda@katamail.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: Bisected KVM hang on x86-32 between v3.12 and v3.13
References: <5341707F.5000406@katamail.com> <20140407150337.GO10526@twins.programming.kicks-ass.net> <20140407150705.GB13658@twins.programming.kicks-ass.net> <5342EB78.3060002@gmx.de> <20140407185658.GK11096@twins.programming.kicks-ass.net> <20140408122128.GC13658@twins.programming.kicks-ass.net>
In-Reply-To: <20140408122128.GC13658@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="CH6EAQKGd201lFPw9cbrVwdbgWfWJncqH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CH6EAQKGd201lFPw9cbrVwdbgWfWJncqH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08.04.2014 14:21, Peter Zijlstra wrote:
> On Mon, Apr 07, 2014 at 08:56:58PM +0200, Peter Zijlstra wrote:
>> On Mon, Apr 07, 2014 at 08:16:24PM +0200, Toralf F=F6rster wrote:
>>
>>> v3.14-10353-g2b3a8fd works fine AFAICS
>>> (BTW the fix is stable material, right ?)
>>
>> I'm fairly sure its not; its a rather invasive series; see:
>>
>> 2432e1364bbe x86: Nuke the supervisor_stack field in i386 thread_info
>> b807902a88c4 x86: Nuke GET_THREAD_INFO_WITH_ESP() macro for i386
>> 0788aa6a23cb x86: Prepare removal of previous_esp from i386 thread_inf=
o structure
>> 198d208df437 x86: Keep thread_info on thread stack in x86_32
>>
>> Let me see if there's anything 'simpler' we can stuff in .13+
>=20
> OK.. so could someone test the below patch to see if that makes things
> work for .13 and .14?

Hi Peter,

sorry I only had time to try 3.13 but that looks good. I was able to get =
kvm up
and running for a longer than usual (without the patch) amount of time wi=
thout
seeing any softlockups.

-Stefan
>=20
> ---
>  arch/x86/include/asm/preempt.h | 11 +++++++++++
>  include/linux/preempt.h        |  4 ++++
>  include/linux/thread_info.h    |  2 --
>  3 files changed, 15 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/pree=
mpt.h
> index c8b051933b1b..7ada46d8d4d8 100644
> --- a/arch/x86/include/asm/preempt.h
> +++ b/arch/x86/include/asm/preempt.h
> @@ -5,6 +5,17 @@
>  #include <asm/percpu.h>
>  #include <linux/thread_info.h>
> =20
> +#ifdef CONFIG_X86_32
> +/*
> + * i386's current_thread_info() depends on ESP and for interrupt/excep=
tion
> + * stacks this doesn't yield the actual task thread_info.
> + *
> + * We hard rely on the fact that all the TIF_NEED_RESCHED bits are
> + * the same, therefore use the slightly more expensive version below.
> + */
> +#define tif_need_resched() test_tsk_thread_flag(current, TIF_NEED_RESC=
HED)
> +#endif
> +
>  DECLARE_PER_CPU(int, __preempt_count);
> =20
>  /*
> diff --git a/include/linux/preempt.h b/include/linux/preempt.h
> index de83b4eb1642..891c8f8b52fe 100644
> --- a/include/linux/preempt.h
> +++ b/include/linux/preempt.h
> @@ -17,6 +17,10 @@
> =20
>  #include <asm/preempt.h>
> =20
> +#ifndef tif_need_resched
> +#define tif_need_resched() test_thread_flag(TIF_NEED_RESCHED)
> +#endif
> +
>  #if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
>  extern void preempt_count_add(int val);
>  extern void preempt_count_sub(int val);
> diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
> index fddbe2023a5d..a629e4b23217 100644
> --- a/include/linux/thread_info.h
> +++ b/include/linux/thread_info.h
> @@ -118,8 +118,6 @@ static inline __deprecated void set_need_resched(vo=
id)
>  	 */
>  }
> =20
> -#define tif_need_resched() test_thread_flag(TIF_NEED_RESCHED)
> -
>  #if defined TIF_RESTORE_SIGMASK && !defined HAVE_SET_RESTORE_SIGMASK
>  /*
>   * An arch can define its own version of set_restore_sigmask() to get =
the
>=20



--CH6EAQKGd201lFPw9cbrVwdbgWfWJncqH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTRQ+HAAoJEOhnXe7L7s6joaYQAMi8rCd15jwqC4tTboQ8oXfs
ziIzoz6HFgwq8w5PqHR8mu+2owo4AGYSOlJk49q4VnFQ9IkaFQEdjlC07bBLG115
GYJHaiDeY9ydDVNmud03pKw6kwsp/U6IrX7ln8T4PVD4m1DYJwPVhnrGgyxilRZC
aJNt+MqwS1ad8oITaBvpg0wSIwDZv/lfKLuSdEQgcXZFk3AaIPkGHJ1qtiXP8l0c
qW2HSsSLXTD9Rii51GcwFDlhOLgUhrAq0V2He7LcaQpHszQhxBhUZe7xp4qWhZ1I
wWWN4Am7AccQqFi9DGFl2UErcXYDkhIJ38CF9wAfebJtPXEET4N2Va5a6Tc+3KTD
fls4OWnClhl+V4Ipgr97L4jrjtHMZcrq69munUK4sIpoVOFNCxVX4wjmFPXW4MWM
bqNNL/9qWkUoLQDhHRqCfzqNeNRNuy+tQbU2ZxIBkrLZHc/p0p5nGXZZvskiReRa
BIz4OqXrvZqnYf/rsuemiAxjsrx0VBV45usF8wNIZVkzQXTjBXS8FEEyydZ9tO+V
tavYsG9+2Fe6QgIMXFivKWDyE8CaVUBoKsD1bYf2iCIzQQDcEe/WKfzfEnXz2dCE
nbEu9/cargx1X5DRH6/qeSE38m4Rt6NJmq9ONzoA43jl/ttyyPkJjspeqKfQcISX
Lf+NB4XUbQ0ei/YdQeoT
=odDp
-----END PGP SIGNATURE-----

--CH6EAQKGd201lFPw9cbrVwdbgWfWJncqH--
