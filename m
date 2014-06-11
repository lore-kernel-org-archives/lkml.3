Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbaFKIzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:55:00 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51741 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaFKIy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:54:58 -0400
Date: Wed, 11 Jun 2014 10:54:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: acme@kernel.org, mingo@redhat.com, paulus@samba.org, hpa@zytor.com,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/x86/intel: ignore CondChgd bit to avoid false NMI
 handling
Message-ID: <20140611085448.GI3213@twins.programming.kicks-ass.net>
References: <20140611073028.9847.65622.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hy6Wd/+xmQCqA1QQ"
Content-Disposition: inline
In-Reply-To: <20140611073028.9847.65622.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hy6Wd/+xmQCqA1QQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 04:30:28PM +0900, HATAYAMA Daisuke wrote:
> Currently, a NMI handler for NMI watchdog may falsely handle any NMI
> signaled for different purpose if CondChgd bit in
> MSR_CORE_PERF_GLOBAL_STATUS MSR is set.
>=20
> This commit deals with the issue simply by ignoring CondChgd bit.
>=20
> Here is explanation in detail.
>=20
> On x86 NMI watchdog uses performance monitoring feature to
> periodically signal NMI each time performance counter gets overflowed.
>=20
> intel_pmu_handle_irq() is called as a NMI_LOCAL handler from a NMI
> handler of NMI watchdog, perf_event_nmi_handler(). It identifies owner
> of a given NMI by looking at overflow status bits in
> MSR_CORE_PERF_GLOBAL_STATUS MSR. If some of the bits are set, then it
> handles the given NMI as its own NMI.
>=20
> The problem is that intel_pmu_handle_irq() doesn't distinguish
> CondChgd bit from other bits. Unlike the other status bits, CondChgd
> bit doesn't represent overflow status for performance counters. Thus,
> CondChgd bit cannot be thought of as a mark indicating a given NMI is
> NMI watchdog's.

So what was the problem? It ate another NMI?

> I noticed this behavior on systems with Ivy Bridge processors: Intel
> Xeon CPU E5-2630 v2 and Intel Xeon CPU E7-8890 v2. On both systems,
> CondChgd bit in MSR_CORE_PERF_GLOBAL_STATUS MSR has already been set
> in the beginning at boot. (then the CondChgd bit is cleared by next
> wrmsr to MSR_CORE_PERF_GLOBAL_CTRL MSR and appears to remain 0.)
>=20
> On the other hand, on older processors such as Nehalem, CondChgd bit
> is not set in the beginning at boot.
>=20
> I'm not sure about exact behavior of CondChgd bit, in particular when
> this bit is set. Although I read Intel System Programmer's Manual to
> figure out but I have yet completed that. At least, I think ignoring
> CondChgd bit should be enough for NMI watchdog perspective.

So yes, the SDM lists the bit as existing but never once mentions it
outside of that, and its been doing that at least back to 2008.

Ooh, I found it:

  "The IA32_PERF_GLOBAL_STATUS MSR also provides a =E2=80=98sticky bit=E2=
=80=99 to
indicate changes to the state of performance monitoring hardware (see
Figure 18-29)."

Which is of course completely useless, not to mention inconsistent with
the later CondChgd name.

HPA, can you explain wtf that bit does and why hatayama-san's ivb feels
like having that set on boot?=20

--Hy6Wd/+xmQCqA1QQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTmBlYAAoJEHZH4aRLwOS6yV4P/3SjAjDTSgaoiHgi3oGrnO6b
j29ONe7DtoOQhs29Y6FLmQ1oS/DYg+qQgtdxDEmhuvaxbFi8jVaA8aqp1cYInAMo
IDPHxAiK4GN8DuOImyRs24B2yQr1tmVFvlwkEAUMZbyzEPBhZ3MyT3Pm6zTs+I4b
F74NHAM7rBdlwij7g143SOeeu8fcUw/rs+Ho1fTChJGht9mLiODG4aidapHm7kH0
B6tCqYTffff9NFDYLs24UEHuDqBjoGPMYz1qStgNjl8kC1mTWvuoqduxeQocrg8t
c/Gyn0A0+tPTAFxFNacJw3mnhRNKf+R28WxttKWqaQD1ByDFmBSUwr086EDxp19/
eDDcChxqLUMYl+4bI8QwVad1io1qpZaAYG6RS7Wa2XdX9v1lGL63SBmM1ADHdGcU
peMBOAqvUPwAKxmSUJvGEJUTO+mQaxziu/mN3nd42RXbkR3XuOZfzvg7JzeDcXrC
Q79xqm/m4DzORD+e/bc3nnhiUiYaf8lNARAkaw6wMtYS69e5Kc9k6Xmn61jLLwkN
XbJCDluhYNP5PlzdDcytvQvP5W1AK1Jd9AgdOXpzuoW7itnWjDhwXyn/zYXPTDKy
A8mvipkaqixbLw/KZLUE6PiT+F56d9rcLV5jBjaC2vKnnBe88VjVQnSnOx66V3XB
TTOE83NocCaz1shT+FL4
=zxLa
-----END PGP SIGNATURE-----

--Hy6Wd/+xmQCqA1QQ--
