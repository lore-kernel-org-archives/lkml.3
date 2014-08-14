Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaHNKxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 06:53:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:49015 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbaHNKxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 06:53:49 -0400
Date: Thu, 14 Aug 2014 12:53:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Chuansheng Liu <chuansheng.liu@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, changcheng.liu@intel.com,
        xiaoming.wang@intel.com, souvik.k.chakravarty@intel.com
Subject: Re: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
Message-ID: <20140814105336.GH16043@twins.programming.kicks-ass.net>
References: <1407982309-4863-1-git-send-email-chuansheng.liu@intel.com>
 <CAKnoXLw3DrBAxCUWEkXtvCTf+E1w0xTHJSiSUY6Qd6xHXeGaoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8/pVXlBMPtxfSuJG"
Content-Disposition: inline
In-Reply-To: <CAKnoXLw3DrBAxCUWEkXtvCTf+E1w0xTHJSiSUY6Qd6xHXeGaoQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8/pVXlBMPtxfSuJG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2014 at 12:29:32PM +0200, Daniel Lezcano wrote:
> Hi Chuansheng,
>=20
> On 14 August 2014 04:11, Chuansheng Liu <chuansheng.liu@intel.com> wrote:
>=20
> > We found sometimes even after we let PM_QOS back to DEFAULT,
> > the CPU still stuck at C0 for 2-3s, don't do the new suitable C-state
> > selection immediately after received the IPI interrupt.
> >
> > The code model is simply like below:
> > {
> >         pm_qos_update_request(&pm_qos, C1 - 1);
> >                 < =3D=3D Here keep all cores at C0
> >         ...;
> >         pm_qos_update_request(&pm_qos, PM_QOS_DEFAULT_VALUE);
> >                 < =3D=3D Here some cores still stuck at C0 for 2-3s
> > }
> >
> > The reason is when pm_qos come back to DEFAULT, there is IPI interrupt =
to
> > wake up the core, but when core is in poll idle state, the IPI interrupt
> > can not break the polling loop.
> >
> > So here in the IPI callback interrupt, when currently the idle task is
> > running, we need to forcedly set reschedule bit to break the polling lo=
op,
> > as for other non-polling idle state, IPI interrupt can break them direc=
tly,
> > and setting reschedule bit has no harm for them too.
> >
> > With this fix, we saved about 30mV power in our android platform.
> >
> > Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> > ---
> >  drivers/cpuidle/cpuidle.c |    8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> > index ee9df5e..9e28a13 100644
> > --- a/drivers/cpuidle/cpuidle.c
> > +++ b/drivers/cpuidle/cpuidle.c
> > @@ -532,7 +532,13 @@ EXPORT_SYMBOL_GPL(cpuidle_register);
> >
> >  static void smp_callback(void *v)
> >  {
> > -       /* we already woke the CPU up, nothing more to do */
> > +       /* we already woke the CPU up, and when the corresponding
> > +        * CPU is at polling idle state, we need to set the sched
> > +        * bit to trigger reselect the new suitable C-state, it
> > +        * will be helpful for power.
> > +       */
> > +       if (is_idle_task(current))
> > +               set_tsk_need_resched(current);
> >
>=20
> Mmh, shouldn't we inspect the polling flag instead ? Peter (Cc'ed) did so=
me
> changes around this and I think we should ask its opinion. I am not sure
> this code won't make all cpu to return to the scheduler and go back to the
> idle task.

Yes, this is wrong.. Also cpuidle should not know about this, so this is
very much the wrong place to go fix this. Lemme have a look.

--8/pVXlBMPtxfSuJG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7JUvAAoJEHZH4aRLwOS6JGAP/1YLbCn+iXV+gNaRqED9EXcS
2M9HVwQeY6kNFFB5w8CeRNKRFJuXxB/x503JbJK97BlonQpLKANees6eCFDYRZ3R
UQqt3FPQKjjZZ2IDBQW48Ctb0aTuUqv0h3trpZGrdjo4Yuby9ziZLuvGrjUnhN1W
dZKES47sPBvzP4icxmdKmHkboepJD808sunDgwqfQMDWAWN0WiMerynUJ/ws9Dyx
OzITljQu6tvXcKOxfy28Ct/JtuDVF4ySWLCoV39s3jDjLOcFoQHn2ruJ2MM8RStJ
+7iqjKTEaw/EedYNcEzkH3RzQZTuhbMmyaL9RGLy/vBMy1fhqtDvdKnKzcD7ANFy
cT0azcRwLVWmcs1JTDf58/qRjF6ocCYBzDcuyxF4GvKok4iecCS8UgOkLKJTM4sl
mMA7vMKZfIZ5p3jEbL+QEC4fWhuURbQcmVDVUr7faOlazpzRGvB8LlYCJfEQUd7X
P8fPIq+03o6RXpylG0VLdBmbknGZ7Vzx6KpKJbY0Q4B6vcahJGDfK7rN6+W3iT5M
7OSuK47yxxRrEDtOx3EO4Oj+IXh0mC3ACOkkXJ8i/EHoz6e3DDMAgGT9SDKmkYtg
SC6sjd266Ji2TCJzWLYchA0o7Sxx2YbABnwP5AmCheXAjTN5t9tnO4/7p+ADX6pm
4aC4o6x4z+xybWPE2iSF
=eyix
-----END PGP SIGNATURE-----

--8/pVXlBMPtxfSuJG--
