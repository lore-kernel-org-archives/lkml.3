Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaFEHTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:19:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:50569 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaFEHTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:19:21 -0400
Date: Thu, 5 Jun 2014 09:19:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Liu ShuoX <shuox.liu@intel.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Zhang Yanmin <yanmin.zhang@intel.com>,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] perf: fix kernel panic when parsing user space CS saved
 in pt_regs
Message-ID: <20140605071919.GD3213@twins.programming.kicks-ass.net>
References: <20140605023610.GA12905@lskakaxi-intel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0/kgSOzhNoDC5T3a"
Content-Disposition: inline
In-Reply-To: <20140605023610.GA12905@lskakaxi-intel>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0/kgSOzhNoDC5T3a
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 10:36:10AM +0800, Liu ShuoX wrote:
> From: Zhang Yanmin <yanmin.zhang@intel.com>
>=20
> We hit a kernel panic when running perf to collect some performance data.
> kenel is x86_64 and user space apps are 32bit.
>=20
> [   71.965351, 1] [       Binder_2] BUG: unable to handle kernel NULL poi=
nter dereference at 0000000000000004
> [   71.965360, 1] [       Binder_2] IP: [<ffffffff82012091>] get_segment_=
base+0x71/0xc0
> [   71.965367, 1] [       Binder_2] PGD 6c65f067 PUD 0
> [   71.965375, 1] [       Binder_2] Oops: 0000 [#1] PREEMPT SMP
> [   71.965413, 1] [       Binder_2] Modules linked in: ddrgx snd_merr_dpc=
m_wm8958 snd_intel_sst snd_soc_sst_platform snd_soc_wm8994 snd_soc_wm_hubs =
lm3559 imx1x5 atomisp_css2401a0_v21 libmsrlisthelper rmi4 bcm_bt_lpm videob=
uf_vmalloc videobuf_core fps_throttle hdmi_audio pn544(O) tngdisp bcm4335(O=
) cfg80211
> [   71.965420, 1] [       Binder_2] CPU: 1 PID: 304 Comm: Binder_2 Tainte=
d: G        W  O 3.10.20-263902-g184bfbc-dirty #14
> [   71.965426, 1] [       Binder_2] task: ffff8800764dc300 ti: ffff88006c=
6e8000 task.ti: ffff88006c6e8000
> [   71.965439, 1] [       Binder_2] RIP: 0010:[<ffffffff82012091>]  [<fff=
fff=E6f82012091>] get_segment_base+0x71/0xc0
                                                                           =
   ^
> [   71.965<44, 1] [       Binder_2] RSP: 0018:ffff^X8007ea87b98  EFLAGS: =
00010092
            ^                                       ^
> [   71.965447, 1] [      !Binder_2] RAX: 0000000000000024 RBX: 0000000000=
000000 RCX: 0000000000000000
                           ^
> [   71.965450, 1] [       Binder_2] RDX: 0000000000000000 RSI: 0000000000=
000000 RDI: 0000000000000009
> [   71.965454, 1] [       Binder_2] RBP: ffff88007ea87ba8 R08: ffffffff83=
143b3c R09: ffffffff831848a8
> [   71.965458, 1] [       Binder_2] R10: 0000000000000000 R11: 0000000000=
1bf2d8 R12: 0000000000000000
> [   71.965462, 1] [       Binder_2] R13: ffff88006c6e9fd8 R14: ffff88006c=
6e9f58 R15: ffff8800764dc300
> [   71.965468, 1_ [       Binder_2] FS:  0000000000000000(0000) GS:ffff88=
007ea80000(006b) knlGS:00000000f704add0
                  ^

Are you suffering some serious corruption?

> Basically, ia32 uses sysenter to start system calls.
>=20
> sysexit_from_sys_call=3D>trace_hardirqs_on_thunk. Before calling,
> sysexit_from_sys_call already pops up pt_regs, then trace_hardirqs_on_thu=
nk
> would reuse pt_regs space. If perf NMI happens here, perf might use a bad=
 pt_regs.
>=20
> The patch fixes it  by moving the calling to trace_hardirqs_on_thunk ahea=
d of
> the stack popup.
>=20
> Change-Id: I6c4fc46b009ea056f2321ce5b8f54cf8769a7bdd

No idea what that is, but it needs to go.

I'll leave the actual patch to hpa, this isn't something I'm too
familiar with.

> Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
> ---
>  arch/x86/ia32/ia32entry.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
> index 4299eb0..df61fdb 100644
> --- a/arch/x86/ia32/ia32entry.S
> +++ b/arch/x86/ia32/ia32entry.S
> @@ -167,6 +167,7 @@ sysenter_dispatch:
>  	testl	$_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
>  	jnz	sysexit_audit
>  sysexit_from_sys_call:
> +	TRACE_IRQS_ON
>  	andl    $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
>  	/* clear IF, that popfq doesn't enable interrupts early */
>  	andl  $~0x200,EFLAGS-R11(%rsp) @@ -181,7 +182,6 @@ sysexit_from_sys_cal=
l:
>  	/*CFI_RESTORE rflags*/
>  	popq_cfi %rcx				/* User %esp */
>  	CFI_REGISTER rsp,rcx
> -	TRACE_IRQS_ON
>  	ENABLE_INTERRUPTS_SYSEXIT32
>  #ifdef CONFIG_AUDITSYSCALL
> --=20
> 1.8.3.2
>=20

--0/kgSOzhNoDC5T3a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkBn3AAoJEHZH4aRLwOS6h50P/1LgcHW7nVRrGtxD7EoWnhTo
IKNmu3PWKnC7gyjMn0Pcw4j0C3uO31u43RWFyxNeNV0VX+K9xx89OvmFbGBs96nI
EAdBKIaVxwNs/Qrt9A7QiM+stgkg4Jk5a+A/howACH5SEBCU/D+pfaGKP4pMzlWQ
7euE6+1rU2xpsaaqk13FfKTAJtR0AY8QGPPvaDN2rHSAPaxcZW9ia7QYv6syNflm
6usnC2CXjjVn9SIvPz1SBAN4yxEZOXarYArDeDvy91FuTmmm5hTQAlnMixzHqJib
umDClWj8qrn1/IMIPYMvHopAejCHIGn40xEIOToisqeujrqzmFTdbwAO2BtmWCoD
Ria4Dd366JN7YGyO4UdLKqt04FFNDlGqcbNjjaXzeUgJ2Hya6xvzi+O/DAy0Zje6
sCNNgWRnybBT6j2CFQS1SYFoMNnPt6G1AFXb2Jrg8jocVs4e9VIHLQdqqRMlNu55
0YYyvkRVAO7ktI8LCMvsPr77IXper9baWR1zj31PAtK5WeMx6A4EbcYe6ozTSbrA
7Jxm7Rg3niD9lHbTFEafayr4U1j2yM+GdJUFQPAB+20l/eplYFx9EUYGgDdtXp0l
Q6E1ZVyQAyU9WCs2EP3xEsxEbSxTQVFQ2frdmSFCahCj7cDQP+u0TZrcZpEEjOxP
/dVI/VNe3AeogHdKIs5t
=CyAe
-----END PGP SIGNATURE-----

--0/kgSOzhNoDC5T3a--
