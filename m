Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab3JURyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 13:54:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab3JURym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 13:54:42 -0400
Message-ID: <52656A5A.4030406@redhat.com>
Date: Mon, 21 Oct 2013 13:54:34 -0400
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
References: <201310181742.r9IHgO1q021001@ib.usersys.redhat.com> <20131019082314.GA7778@gmail.com>
In-Reply-To: <20131019082314.GA7778@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="giDLOdGEbs3XDCbHwGGv5sPg36Lf2FgLU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--giDLOdGEbs3XDCbHwGGv5sPg36Lf2FgLU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/19/2013 04:23 AM, Ingo Molnar wrote:
>=20
> * Doug Ledford <dledford@redhat.com> wrote:
>> All prefetch operations get sent to an access queue in the memory=20
>> controller where they compete with both other reads and writes for the=
=20
>> available memory bandwidth.  The optimal prefetch window is not a fact=
or=20
>> of memory bandwidth and latency, it's a factor of memory bandwidth,=20
>> memory latency, current memory access queue depth at time prefetch is =

>> issued, and memory bank switch time * number of queued memory operatio=
ns=20
>> that will require a bank switch.  In other words, it's much more compl=
ex=20
>> and also much more fluid than any static optimization can pull out.=20
>> [...]
>=20
> But this is generally true of _any_ static operation - CPUs are complex=
,=20
> workloads are complex, other threads, CPUs, sockets, devices might=20
> interact, etc.
>=20
> Yet it does not make it invalid to optimize for the isolated, static=20
> usecase that was offered, because 'dynamism' and parallelism in a real =

> system will rarely make that optimization completely invalid, it will=20
> typically only diminish its fruits to a certain degree (for example by =

> causing prefetches to be discarded).

So, prefetches are a bit of a special beast in that, if they are done
incorrectly, they can actually make the overall system slower than if we
didn't do anything at all.  If you are talking about anything other than
prefetch I would agree with you.  With prefetch, as much as possible,
you need to mimic the environment for which you are optimizing.  Neil's
test kernel module just called csum_partial on a bunch of memory pages.
 The actual usage pattern of csum_partial though is that it will be used
while, most likely, there is ongoing DMA of data packets across the
network interface.  It is very unlikely that we could care less about
the case of optimizing csum_partial for no network activity since
csum_partial is always going to be the result of network activity and
unlikely to happen in isolation.  As such, my suggestion about a kernel
compile was to create activity across the PCI bus to hard drives,
mimicking network interface DMA traffic.  You could also run a netperf
instance instead.  I just don't agree with optimizing it without
simultaneous DMA traffic as that particular case if likely to be a
rarity, not the norm.

> What I was objecting to strongly here was to measure the _wrong_ thing,=
=20
> i.e. the cache-hot case. The cache-cold case should be measured in a lo=
w=20
> noise fashion, so that results are representative. It's closer to the r=
eal=20
> usecase than any other microbenchmark. That will give us a usable speed=
up=20
> figure and will tell us which technique helped how much and which=20
> parameter should be how large.

Cold cache, yes.  Low noise, yes.  But you need DMA traffic at the same
time to be truly representative.

>> [...]  So every time I see someone run a series of micro- benchmarks=20
>> like you just did, where the system was only doing the micro- benchmar=
k=20
>> and not a real workload, and we draw conclusions about optimal prefetc=
h=20
>> distances from that test, I cringe inside and I think I even die... ju=
st=20
>> a little.
>=20
> So the thing is, microbenchmarks can indeed be misleading - and as in t=
his=20
> case the cache-hot claims can be outright dangerously misleading.

So can non-DMA cases.

> But yet, if done correctly and interpreted correctly they tell us a lit=
tle=20
> bit of the truth and are often correlated to real performance.
>=20
> Do microbenchmarks show us everything that a 'real' workload inhibits? =
Not=20
> at all, they are way too simple for that. They are a shortcut, an=20
> indicator, which is often helpful as long as not taken as 'the'=20
> performance of the system.
>=20
>> A better test for this, IMO, would be to start a local kernel compile =

>> with at least twice as many gcc instances allowed as you have CPUs,=20
>> *then* run your benchmark kernel module and see what prefetch distance=
=20
>> works well. [...]
>=20
> I don't agree that this represents our optimization target. It may=20
> represent _one_ optimization target. But many other important usecases =

> such as a dedicated file server, or a computation node that is=20
> cache-optimized, would unlikely to show such high parallel memory press=
ure=20
> as a GCC compilation.

But they will *all* show network DMA load, not quiescent DMA load.

>> [...]  This distance should be far enough out that it can withstand=20
>> other memory pressure, yet not so far as to constantly be prefetching,=
=20
>> tossing the result out of cache due to pressure, then fetching/stallin=
g=20
>> that same memory on load.  And it may not benchmark as well on a=20
>> quiescent system running only the micro-benchmark, but it should end u=
p=20
>> performing better in actual real world usage.
>=20
> The 'fully adversarial' case where all resources are maximally competed=
=20
> for by all other cores is actually pretty rare in practice. I don't say=
 it=20
> does not happen or that it does not matter, but I do say there are many=
=20
> other important usecases as well.
>=20
> More importantly, the 'maximally adversarial' case is very hard to=20
> generate, validate, and it's highly system dependent!

This I agree with 100%, which is why I tend to think we should scrap the
static prefetch optimizations entirely and have a boot up test that
allows us to find our optimum prefetch distance for our given hardware.

> Cache-cold (and cache hot) microbenchmarks on the other hand tend to be=
=20
> more stable, because they typically reflect current physical (mostly=20
> latency) limits of CPU and system technology, _not_ highly system=20
> dependent resource sizing (mostly bandwidth) limits which are very hard=
 to=20
> optimize for in a generic fashion.
>=20
> Cache-cold and cache-hot measurements are, in a way, important physical=
=20
> 'eigenvalues' of a complex system. If they both show speedups then it's=
=20
> likely that a more dynamic, contended for, mixed workload will show=20
> speedups as well. And these 'eigenvalues' are statistically much more=20
> stable across systems, and that's something we care for when we impleme=
nt=20
> various lowlevel assembly routines in arch/x86/ which cover many differ=
ent=20
> systems with different bandwidth characteristics.
>=20
> I hope I managed to explain my views clearly enough on this.
>=20
> Thanks,
>=20
> 	Ingo
>=20


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--giDLOdGEbs3XDCbHwGGv5sPg36Lf2FgLU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSZWpaAAoJELgmozMOVy/d6/UP/A2ITDAyEnb7XP5sRMm1m8DM
dCMzz3PUndrg4Ml/HPGgzVjm5IJadY5Mc8Z+Vmcpg8lsjOU54BzCiAy8ctou6sxz
zdsR0qIuw4tKI0A5ii6XDhkC51S4NxsSAoGNqsdNjgCrxv4Lb43wrQ2lrxWVLe2/
oXStzOuPjZ8qBANChc0naKsmhtEzu8t0B0+I5tmIYWIQAErjoGXEyZFnBkwPCsEj
TtFxEb317ns7AH5oyeYzq5+/jWspHQxSnxDHocv5s9vrr8d6yJJ+KvmmjqplXZc7
qFV2tydfqpE0t05M3Ks6Jld01Kn5EjGSuSShcL2wqRds5uxFtKjg6qqtUI252ei3
/hJu8inIUgoR59pA+IrwrV710Gng/aMNO/Biy8TtSTOrhgkKWkM6SOxbwvSJMTnz
jIlnC8Mi3llCEAkjPOgeElCR6qCtRLVBfbg1LmApYM10xdkBMNm3mkOIQ1llH4+2
BYRoT5+xQ2+z+Fuo3FRUV1qMJsJjAVAtmaEL6q+IhlcO7GP0iuprfJIBAv/4lBtA
yTEqrrrcWRcdEVHzCv64CSdNFDWaf5mr4f6Nva6TLQTDXEnzuF+o0loRX8MRwvSS
5Udv4o0yBIA9rTe3TAVndDb1GfmIkumHL25d+cBT/g6fgaf3TYCUCQXCIjUq99qx
LQtdakL7/cZaBBPcHkWF
=TAcD
-----END PGP SIGNATURE-----

--giDLOdGEbs3XDCbHwGGv5sPg36Lf2FgLU--
