Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbaFQMxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:53:09 -0400
Received: from blu004-omc2s15.hotmail.com ([65.55.111.90]:57291 "EHLO
	BLU004-OMC2S15.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755755AbaFQMxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:53:07 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jun 2014 08:53:07 EDT
X-TMN: [go0i1j1NEi1RdbQu39cu2iWRBm/pwSHp]
X-Originating-Email: [registosites@hotmail.com]
Message-ID: <BLU436-SMTP2374766AD1903C1E161D224C6110@phx.gbl>
Date: Tue, 17 Jun 2014 13:47:53 +0100
From: Mauro <registosites@hotmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        srivatsa@mit.edu
Subject: Re: [PATCH 11/15] x86: Rewrite cyc2ns to avoid the need to disable
 IRQs
References: <20131212140835.729222186@infradead.org> <20131212141655.238445339@infradead.org> <CAOh2x=mgeozUMGYQubQ4GKPEB6k_TkcV3CSTzNLqjKok-gROQg@mail.gmail.com> <20140617121535.GY6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140617121535.GY6758@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="a6kQafl21RpFqFAc0su0QDEojD5jEd9CP"
X-OriginalArrivalTime: 17 Jun 2014 12:47:58.0311 (UTC) FILETIME=[5DBF4770:01CF8A2A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--a6kQafl21RpFqFAc0su0QDEojD5jEd9CP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2014 13:15, Peter Zijlstra wrote:
> On Mon, Jun 16, 2014 at 10:43:38PM +0530, Viresh Kumar wrote:
>> Cc'ing Mauro/Rafael/Srivatsa..
>>
>> On Thu, Dec 12, 2013 at 7:38 PM, Peter Zijlstra <peterz@infradead.org>=
 wrote:
>>> Use a ring-buffer like multi-version object structure which allows
>>> always having a coherent object; we use this to avoid having to
>>> disable IRQs while reading sched_clock() and avoids a problem when
>>> getting an NMI while changing the cyc2ns data.
>>>
>>>                         MAINLINE   PRE        POST
>>>
>>>     sched_clock_stable: 1          1          1
>>>     (cold) sched_clock: 329841     331312     257223
>>>     (cold) local_clock: 301773     310296     309889
>>>     (warm) sched_clock: 38375      38247      25280
>>>     (warm) local_clock: 100371     102713     85268
>>>     (warm) rdtsc:       27340      27289      24247
>>>     sched_clock_stable: 0          0          0
>>>     (cold) sched_clock: 382634     372706     301224
>>>     (cold) local_clock: 396890     399275     399870
>>>     (warm) sched_clock: 38194      38124      25630
>>>     (warm) local_clock: 143452     148698     129629
>>>     (warm) rdtsc:       27345      27365      24307
>>>
>>> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>>> ---
>>>  arch/x86/include/asm/timer.h     |   23 +++
>>>  arch/x86/kernel/cpu/perf_event.c |   14 +-
>>>  arch/x86/kernel/tsc.c            |  229 ++++++++++++++++++++++++++++=
++++++-----
>>>  3 files changed, 236 insertions(+), 30 deletions(-)
>>
>> Hi Peter,
>>
>> We have been following a bug around cpufreq changes in 3.14
>> (https://bugzilla.kernel.org/show_bug.cgi?id=3D77201) and our tests
>> narrowed it down to this patch after which things aren't working
>> as expected.
>=20
>> Mauro (registosites@hotmail.com) have reported that since 3.14
>> after doing hot-unplug/hotplug of CPU1, cpufreq POSTCHANGE notificatio=
ns
>> for every second frequency change hangs his machine ..
>=20
> Ah, just a freeze?

If you mean no output whatsoever and frozen to the point of needing a
hard shutdown/reboot, yes.

>> Last working tag was: 3.13.8 and it started failing from 3.14 and fail=
s
>> for latest 3.15 as well..
>>
>> model name : AMD Turion(tm) 64 X2 Mobile Technology TL-64
>> CPUFreq driver: powernow-k8 ..
>> CPUs: Only two CPUs, sharing clock line
>=20
> What's specific to this particular CPU?

That is a very good question, for which I don't have an answer, as far
as I know it is just like any other AMD mobile Turion X2 cpu.

>> Can you give any pointers, so that he can get it fixed ?
>=20
> So what you can try is force a cyc2ns read before the write in
> set_cyc2ns_scale(). I think its possible that if we do not do the read,=

> the write will wait for a 'free' slot indefinitely.

For that I'll need some help/pointers.


--a6kQafl21RpFqFAc0su0QDEojD5jEd9CP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJToDj5AAoJEEOiwsAJMwKcqRQP+gJKTq3QcFsEmpBAZLpV6Bf8
xiWYGXSHgU/nQtoU+MaPIZ8fDLLk/5QitY1ESVQsT9xE7BPnQLwVA1H/EQZQe6Hy
jvvTIBfOUFxKyGNz6ZfnkcqAVToiYrDJ9A88aqhizlxqrKdqarREoP29YyB5aoKC
R3RJNRzQ3qUkAy+qhACgJO84nk95uxVKF4X241WnEkMhIzvxOl8V9VHIL+Oxeu0q
krPin9/rhN1i5uE8A/Bd1PCxzWif/B3zak2JpXEAUio2xv5Q/aTlkl8/REofXdnC
y14hQdfhxyhSUNa57BXeQPyuVjbFQb8rdCRVZB5YKxPxFHGW0HoXSdHTOV3VYpfn
I7dFX7maa6KwqubSMnLG6V/uB2OqVC2WfJV3qIuAz6tzw4k4svksKef9knG70p5b
QDyzlxN9y+goKLsbGLjrbFIZxmh1O0V7O8qjkFcCxLMVhvamltkUEg9QdxZZP9Vu
mCoNToFDWQ0QpMYRJRzg85gcYtWhtLCUVdVPqJ/v22RY1qGpn1rUlzJ8gMZBMwUI
3kPEOC+8mMi+eN1HZsU7yQTZCpGHClzHCOYj5cNl3G/exuAWYP+pJYERqVA5W2p0
tATlKyWlK1DLypu684wIv8DBGPiCLtTX3VKYrnEbuWuu1jdPUkXG8e5bll50nd1f
wih9CHDsTQUVMmxuTLrz
=bkLP
-----END PGP SIGNATURE-----

--a6kQafl21RpFqFAc0su0QDEojD5jEd9CP--
