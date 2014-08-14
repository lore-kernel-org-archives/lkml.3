Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbaHNMlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 08:41:52 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37711 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaHNMlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 08:41:51 -0400
Date: Thu, 14 Aug 2014 14:41:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Chuansheng Liu <chuansheng.liu@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, changcheng.liu@intel.com,
        xiaoming.wang@intel.com, souvik.k.chakravarty@intel.com
Subject: Re: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
Message-ID: <20140814124135.GJ16043@twins.programming.kicks-ass.net>
References: <1407982309-4863-1-git-send-email-chuansheng.liu@intel.com>
 <CAKnoXLw3DrBAxCUWEkXtvCTf+E1w0xTHJSiSUY6Qd6xHXeGaoQ@mail.gmail.com>
 <20140814110040.GI16043@twins.programming.kicks-ass.net>
 <53EC9A29.8090408@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOmey7/79ja+7F5w"
Content-Disposition: inline
In-Reply-To: <53EC9A29.8090408@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOmey7/79ja+7F5w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2014 at 01:14:49PM +0200, Daniel Lezcano wrote:
> On 08/14/2014 01:00 PM, Peter Zijlstra wrote:
> >On Thu, Aug 14, 2014 at 12:29:32PM +0200, Daniel Lezcano wrote:
> >>Hi Chuansheng,
> >>
> >>On 14 August 2014 04:11, Chuansheng Liu <chuansheng.liu@intel.com> wrot=
e:
> >>
> >>>We found sometimes even after we let PM_QOS back to DEFAULT,
> >>>the CPU still stuck at C0 for 2-3s, don't do the new suitable C-state
> >>>selection immediately after received the IPI interrupt.
> >>>
> >>>The code model is simply like below:
> >>>{
> >>>         pm_qos_update_request(&pm_qos, C1 - 1);
> >>>                 < =3D=3D Here keep all cores at C0
> >>>         ...;
> >>>         pm_qos_update_request(&pm_qos, PM_QOS_DEFAULT_VALUE);
> >>>                 < =3D=3D Here some cores still stuck at C0 for 2-3s
> >>>}
> >>>
> >>>The reason is when pm_qos come back to DEFAULT, there is IPI interrupt=
 to
> >>>wake up the core, but when core is in poll idle state, the IPI interru=
pt
> >>>can not break the polling loop.
> >
> >So seeing how you're from @intel.com I'm assuming you're using x86 here.
> >
> >I'm not seeing how this can be possible, MWAIT is interrupted by IPIs
> >just fine, which means we'll fall out of the cpuidle_enter(), which
> >means we'll cpuidle_reflect(), and then leave cpuidle_idle_call().
> >
> >It will indeed not leave the cpu_idle_loop() function and go right back
> >into cpuidle_idle_call(), but that will then call cpuidle_select() which
> >should pick a new C state.
> >
> >So the interrupt _should_ work. If it doesn't you need to explain why.
>=20
> I think the issue is related to the poll_idle state, in
> drivers/cpuidle/driver.c. This state is x86 specific and inserted in the
> cpuidle table as the state 0 (POLL). There is no mwait for this state. It=
 is
> a bit confusing because this state is not listed in the acpi / intel idle
> driver but inserted implicitly at the beginning of the idle table by the
> cpuidle framework when the driver is registered.
>=20
> static int poll_idle(struct cpuidle_device *dev,
>                 struct cpuidle_driver *drv, int index)
> {
>         local_irq_enable();
>         if (!current_set_polling_and_test()) {
>                 while (!need_resched())
>                         cpu_relax();
>         }
>         current_clr_polling();
>=20
>         return index;
> }

Ah, well, in that case there's a ton more broken than just this.
kick_all_cpus_sync() won't work either, and cpuidle_reflect() pretty
much expects to be called after each interrupt.

Then again, not reflecting properly isn't really a problem, its not like
not accounting interrupts is going to safe power much.



--BOmey7/79ja+7F5w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7K5/AAoJEHZH4aRLwOS6hrQP/ijp1kqceGl+w1v06czsXSff
6xAH6IoZnVw4Lg29Vc8JWukcl1TRkefAxdS/yVHcuH+Wt6c2sKT8GdYS2Fwo7eaC
DdfZTWRXQOCuouVkneCAi0paCq8lyLjG8lSSz1JWd/S1FfTrIhkVO7+Gh+f3+pwb
pCbJKO3h7seQQdXXJppd90LJmstKK1CeYGyJtmXSlZX7d3hO44M28znYGVJYUQnP
O1OAQe3LsltIZjpZxQT2JLT/fUWg9pVGju40ZycFsWWLpclZwYJx/mlV9CTPPCCh
ImW0K7/nU+JcYp/Dh8XgXroAeuER0U+zVvHvHyfu0y92wIO0n9ZIrWIuUbJPcKrj
D8vZczcrxgxqpfdmafkG0MMqW1TPnjZU55YN3NzGJJ2VjtRSj+Q7RvSothnYjTsI
iF/wrxE/eYRd2wQrm6wyplujaEH4HOAi3tZjKo22VG+pfVHuiQ5pVEpvJbAZkg8h
165L3WFnZoIoF2Y7Yfp7Mijkxkm0y0eIvea+oGxpTWvmky0wTv5gSNeC7gQALCTK
6pM6NhfNqs5bBybj7LdrtJfb1M7h2vkDb6CxpPd2jhKemTP5nnKuGP/sCOcbebcJ
dOv2ZzjsOYz5uRer+hbTSMzTM0GMqrkYqy1dlzM9lQFDFfgWAAt6UxJ69cnBTVdE
edsUjXuXPAki6dBr9G8W
=bTbl
-----END PGP SIGNATURE-----

--BOmey7/79ja+7F5w--
