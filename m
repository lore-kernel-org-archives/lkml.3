Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaEWPtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:49:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54753 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaEWPtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:49:19 -0400
Date: Fri, 23 May 2014 17:48:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, tglx@linutronix.de,
        mingo@kernel.org, tj@kernel.org, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, hch@infradead.org, mgorman@suse.de,
        riel@redhat.com, bp@suse.de, rostedt@goodmis.org, mgalbraith@suse.de,
        ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com, oleg@redhat.com,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] CPU hotplug, stop-machine: Plug race-window that
 leads to "IPI-to-offline-CPU"
Message-ID: <20140523154858.GH30445@twins.programming.kicks-ass.net>
References: <20140523101134.17924.31463.stgit@srivatsabhat.in.ibm.com>
 <20140523101216.17924.62447.stgit@srivatsabhat.in.ibm.com>
 <20140523132250.GA1768@localhost.localdomain>
 <537F5F0F.5050802@linux.vnet.ibm.com>
 <20140523151252.GE30445@twins.programming.kicks-ass.net>
 <537F66AF.30303@linux.vnet.ibm.com>
 <20140523153113.GG30445@twins.programming.kicks-ass.net>
 <537F6A53.1080703@linux.vnet.ibm.com>
 <537F6B2E.5080907@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eW1Iu04vutECMx4l"
Content-Disposition: inline
In-Reply-To: <537F6B2E.5080907@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eW1Iu04vutECMx4l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 09:07:18PM +0530, Srivatsa S. Bhat wrote:
> On 05/23/2014 09:03 PM, Srivatsa S. Bhat wrote:
> > On 05/23/2014 09:01 PM, Peter Zijlstra wrote:
> >> On Fri, May 23, 2014 at 08:48:07PM +0530, Srivatsa S. Bhat wrote:
> >>> On 05/23/2014 08:42 PM, Peter Zijlstra wrote:
> >>>> On Fri, May 23, 2014 at 08:15:35PM +0530, Srivatsa S. Bhat wrote:
> >>>>>>> +		 * During CPU offline, we don't want the other CPUs to send
> >>>>>>> +		 * IPIs to the active_cpu (the outgoing CPU) *after* it has
> >>>>>>> +		 * disabled interrupts (because, then it will notice the IPIs
> >>>>>>> +		 * only after it has gone offline). We can prevent this by
> >>>>>>> +		 * making the other CPUs disable their interrupts first - that
> >>>>>>> +		 * way, they will run the stop-machine code with interrupts
> >>>>>>> +		 * disabled, and hence won't send IPIs after that point.
> >>>>
> >>>> That's complete nonsense, you can send IPIs all you want with interr=
upts
> >>>> disabled.
> >>>>
> >>>
> >>> True, but that's not what the comment says. It says "you can't send I=
PIs
> >>> because you are running the *stop-machine* loop, because the stop-mac=
hine loop
> >>> doesn't send IPIs itself! The only possibility of sending IPIs from w=
ithin
> >>> stop-machine is if that CPU can takes an interrupt and the *interrupt=
 handler*
> >>> sends the IPI (like what the block layer used to do) - and we precise=
ly avoid
> >>> that possibility by disabling interrupts. So no IPIs will be sent bey=
ond
> >>> this point.
> >>
> >> but one of those CPUs is running the stop machine function, which calls
> >> CPU_DYING which runs all kinds of nonsense and therefore can send IPIs
> >> all it wants, right?
> >>
> >=20
> > Yes, but that CPU certainly won't IPI itself! (We are trying to avoid g=
etting
> > IPIs on precisely that CPU - the one which is about to go offline).
> >=20
>=20
> And the comment makes that distinction between the "active-cpu" and "othe=
r CPUs"
> (where active-cpu is the one which runs the stop-machine function and eve=
ntually
> goes offline). Thus "other CPUs" won't send IPIs after that point, becaus=
e they
> are running the stop-machine loop with interrupts disabled. This ensures =
that
> the "active-cpu" doesn't get any IPIs - which is what we want.

OK, so clearly I'm having trouble reading today :/ Makes sense now.

But yes, its unlikely for CPU_DYING to self-IPI, although if you really
want, I can do ;-)

And I guess the one extra state doesn't hurt too bad for
stop_two_cpus().

--eW1Iu04vutECMx4l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTf23qAAoJEHZH4aRLwOS6OuIQAI4x9qxsWzVrf9Tx6T4vrrFm
1cYP1NzHdtyjl2hW2svI/4B91cuOq7PAv8F39xWmD/mFT6KD2mNjk/r8W2vjPV8A
cf+SdIjldAFqOgpLFSwnBqzmwDTnfWzn3JgmhzN3IU8ZYc+26e7zOWKEFa/yA9cT
ZJ0l8LwKa0sVVw0a3kqFno3LJOcA342OabcvfSa/rzEANNXPVVK2pBL8j0yPbdeE
WsFkcVQr/aI5HWtKFTQogXekYAiZTq71Nsq7UMzukIA5t07Nip4LZhAQdA3uoeI0
c+EJJPP+dt5Iy+SZKrCDY51rDhYPtiwsXQv0Cbm7sO/+ofIIVsEIXL+VJbLIe944
Baek+TJlJaGEtK2hWczJISaZNk6vbC4Upuhckzp0Pn3D2Q6Rgydh2xxJyl5kR5rp
1skSOBySnRknUuSUviLu8zVXRV+/CfK0Qo5lcwzz2AWAq5tzv4Klnd6kn38p7e3I
+RdThtxMvcHt8Ekql05olzv2BAE8M++l9Bs41xT9lr9UwxF23kP51IBBQ2nlU7mt
S/D9+Ji2tWzRV67jhEDzbOsTHjFGd91IXnGVJAm58qdZs8KWclqK30ZE9RQln/WF
Mgs3hS849kiOrxdQdDhahY7IzJk746KBktKlK7MlH5WOvBgwPPWsTbi4HqAt16Y1
/q0c+zaa0o7R7vMhUiAh
=RcN5
-----END PGP SIGNATURE-----

--eW1Iu04vutECMx4l--
