Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbaIHNVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:21:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:39215 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbaIHNVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:21:00 -0400
Date: Mon, 8 Sep 2014 15:20:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/9] perf: Remove redundant parent context check from
 context_equiv
Message-ID: <20140908132054.GF6758@twins.programming.kicks-ass.net>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-2-git-send-email-jolsa@kernel.org>
 <20140902105036.GH5806@worktop.ger.corp.intel.com>
 <20140908094348.GB1172@krava.brq.redhat.com>
 <20140908094548.GA6758@twins.programming.kicks-ass.net>
 <20140908094855.GR3588@twins.programming.kicks-ass.net>
 <20140908100122.GS3588@twins.programming.kicks-ass.net>
 <20140908113958.GT3588@twins.programming.kicks-ass.net>
 <20140908121952.GB17728@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FithOarzfhgx15NW"
Content-Disposition: inline
In-Reply-To: <20140908121952.GB17728@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FithOarzfhgx15NW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 02:19:52PM +0200, Jiri Olsa wrote:
> > I have another 'problem' with 179033b3e064. What if you 'want' to
> > continue monitoring after the initial task died? Eg. if you want to
> > monitor crap that unconditionally daemonizes.
>=20
> right.. did not think of that.. need to check more, but
> seems like just the check for children should be enough
>=20

Indeed, that should work.

> ---
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index bf482ccbdbe1..341d0b47ca14 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3568,6 +3568,19 @@ static int perf_event_read_one(struct perf_event *=
event,
>  	return n * sizeof(u64);
>  }
> =20
> +static bool is_event_hup(struct perf_event *event)
> +{
> +	bool no_children;
> +
> +	if (event->state !=3D PERF_EVENT_STATE_EXIT)
> +		return false;
> +
> +	mutex_lock(&event->child_mutex);
> +	no_children =3D list_empty(&event->child_list);
> +	mutex_unlock(&event->child_mutex);
> +	return no_children;
> +}
> +
>  /*
>   * Read the performance event - simple non blocking version for now
>   */
> @@ -3582,8 +3595,7 @@ perf_read_hw(struct perf_event *event, char __user =
*buf, size_t count)
>  	 * error state (i.e. because it was pinned but it couldn't be
>  	 * scheduled on to the CPU at some point).
>  	 */
> -	if ((event->state =3D=3D PERF_EVENT_STATE_ERROR) ||
> -	    (event->state =3D=3D PERF_EVENT_STATE_EXIT))
> +	if ((event->state =3D=3D PERF_EVENT_STATE_ERROR) || (is_event_hup(event=
)))
>  		return 0;

Do we want this? It seems like a fairly sensible thing to start a
counter and wait for the thing to die, only to then read the total
count. But with this on we get 0s.

I suppose Stephane's email got to you after you did this and we should
be dropping this thing entirely?

>  	if (count < event->read_size)
> @@ -3614,7 +3626,7 @@ static unsigned int perf_poll(struct file *file, po=
ll_table *wait)
> =20
>  	poll_wait(file, &event->waitq, wait);
> =20
> -	if (event->state =3D=3D PERF_EVENT_STATE_EXIT)
> +	if (is_event_hup(event))
>  		return events;
> =20
>  	/*

--FithOarzfhgx15NW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDa02AAoJEHZH4aRLwOS6oWMP/inLLvMwjq2bfDAWLbK/igTo
lmNKpQzZHfmH/xetejAeQQpkBaGjRqHbnKb1dUmRsxp/VLmvzL/4nhXUE4u7nBEP
AooiH7SxBE4iD31tnQ5iapvV9/2IL8mTRCCVznQSSOobRNfKhCpm4CkOhldAPwrY
vgEc+j3DWeLdCePeyfWyHJPFXZgi+y7GHJeumL1guq2X1xwOgCZ2CLgvnJ4agDSO
Q0rGaEbXZKgtpqBlwxVCY88vlfVPlVdGi+bIjtWZYH6OGlVmSw42SViVXT22KxjG
sVLvTeHPy5aq0UDUESBJZqn7hh3FY1lyQxoIp5PuRAALOU61m/hwOv5PPJfYvnBI
DuB1X0F4lPdOqqFxNwh0nVat3Ii9T0itF9jQy4XOvpzMyoF13gCVRmKQqiOT1Lz5
QILDyg+snfrUwPzELpmRRxjw93qG1e1gVdvMDmNeuzK5dqwjL88zAIbzEdG9E59U
HNI/QGZFYU9Xu5f4IkX4+y0Ng12eZYatlenS4qouf29WIqmP3w2HXzoafvgaDPFz
IP6XjJ6J0WZE+JTICLvSEAtn7CudDQQzAgFZYCHWGaoD1dfI3TDhcVi4mWr/oLDH
/i2TuNgfAp/QHXT64cWIhyN/2igI/TWr5v4vklDH/tNSlab+PM5sv8uFclWLUUxs
8ivZcf3yWGbIZiDMso3F
=+Bl8
-----END PGP SIGNATURE-----

--FithOarzfhgx15NW--
