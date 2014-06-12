Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaFLUWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:22:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaFLUWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:22:49 -0400
Date: Thu, 12 Jun 2014 22:22:47 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [RFC] printk: allow increasing the ring buffer depending on
	the number of CPUs
Message-ID: <20140612202246.GA4841@wotan.suse.de>
References: <1402448685-30634-1-git-send-email-mcgrof@do-not-panic.com> <20140611093447.GL7772@pathway.suse.cz> <20140611214741.GH6042@wotan.suse.de> <20140612130532.GN7772@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20140612130532.GN7772@pathway.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2014 at 03:05:32PM +0200, Petr Ml=E1dek wrote:
> On Wed 2014-06-11 23:47:41, Luis R. Rodriguez wrote:
> > On Wed, Jun 11, 2014 at 11:34:47AM +0200, Petr Ml=E1dek wrote:
> > > On Tue 2014-06-10 18:04:45, Luis R. Rodriguez wrote:
> > > > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > > > diff --git a/init/Kconfig b/init/Kconfig
> > > > index 9d3585b..1814436 100644
> > > > --- a/init/Kconfig
> > > > +++ b/init/Kconfig
> > > > @@ -806,6 +806,34 @@ config LOG_BUF_SHIFT
> > > >  		     13 =3D>  8 KB
> > > >  		     12 =3D>  4 KB
> > > > =20
> > > > +config LOG_CPU_BUF_SHIFT
> > > > +	int "CPU kernel log buffer size contribution (13 =3D> 8 KB, 17 =
=3D> 128KB)"
> > > > +	range 0 21
> > > > +	default 0
> > > > +	help
> > > > +	  The kernel ring buffer will get additional data logged onto it
> > > > +	  when multiple CPUs are supported. Typically the contributions i=
s a
> > > > +	  few lines when idle however under under load this can vary and =
in the
> > > > +	  worst case it can mean loosing logging information. You can use=
 this
> > > > +	  to set the maximum expected mount of amount of logging contribu=
tion
> > > > +	  under load by each CPU in the worst case scenerio. Select a siz=
e as
> > > > +	  a power of 2. For example if LOG_BUF_SHIFT is 18 and if your
> > > > +	  LOG_CPU_BUF_SHIFT is 12 your kernel ring buffer size will be as
> > > > +	  follows having 16 CPUs as possible.
> > > > +
> > > > +	     ((1 << 18) + ((16 - 1) * (1 << 12))) / 1024 =3D 316 KB
> > >=20
> > > It might be better to use the CPU_NUM-specific value as a minimum of
> > > the needed space. Linux distributions might want to distribute kernel
> > > with non-zero value and still use the static "__log_buf" on reasonable
> > > small systems.
> >=20
> > Not sure if I follow what you mean by CPU_NUM-specific, can you
> > elaborate?
>=20
> I wanted to say that the space requested by LOG_CPU_BUF_SHIFT depends
> on the number of CPUs. If LOG_CPU_BUF_SHIFT is not zero, your
> patch always allocates new ringbuffer and leave the static "__log_buf"
> unused. I think that this is not necessary for machines with small
> amount of CPUs and probably also with small amount of memory.

True, which is why I disabled it by default if we want to only leave
this disabled for < certain amount of num CPU systems, what is that
number, I see below a recommendation and I do like it.

> I would rename the variable to LOG_CPU_BUF_MIN_SHIFT or so. It would
> represent minimal size that is needed to print CPU-specific
> messages. If they take only "small" part of the default ring buffer
> size, we could still use the default rind buffer.

True, and will rename this, that still leaves open the question of a
number of CPUs that is sensible to keep but you resolve that below.

> For example, if we left 50% of the default buffer for CPU-specific
> messages, the code might look like:
>=20
> 	#define __LOG_CPU_MIN_BUF_LEN (1 << CONFIG_LOG_CPU_MIN_BUF_SHIFT)
>=20
> 	int cpu_extra =3D (num_possible_cpus() - 1) * __LOG_CPU_MIN_BUF_LEN;
>=20
> 	if (!new_log_buf_len && (cpu_extra > __LOG_BUF_LEN / 2))
> 		new_log_buf_len =3D __LOG_BUF_LEN + cpu_extra;
>=20
> 	if (!new_log_buf_len)
> 		return;
>=20
> 	allocate the new ring buffer...

Yeah I like these heuristics a lot, will fold them in and send a v2 now in =
patch form.
To be clear with this CONFIG_LOG_CPU_MIN_BUF_SHIFT could actually be left n=
ow to
something other than non zeo by default and only if that contribution is se=
en to
go above 1/2 of __LOG_BUF_LEN will we allocate more for the ring buffer. Wi=
th
default values of LOG_BUF_SHIFT at 18 and say a default value of 12 for
LOG_CPU_MIN_BUF_SHIFT this would mean we'd need if we remove the -1 we'd re=
quire
64 CPUs in order to trigger an allocation for more memory. If we keep the -=
1 we'd
require anything over 64 number of CPUs. Do we want to keep the -1 and the =
> 64
CPU requirement as default? Is the LOG_CPU_MIN_BUF_SHIFT default of 12 reso=
nable
to start with (assumes 4KB in the worst case before the kernel ring buffer =
flips over).

> > The default in this patch is to ignore this, do you mean that upstream
> > should probably default to a non-zero value here and then let distribut=
ions
> > select 0 for some kernel builds ?
>=20
> If the change has effect only for huge systems, the default value
> might be non-zero everywhere.

Sure.

> > If so then perhaps adding a sysctl override value might be good to
> > allow only small systems to override this to 0?
>=20
> I think that it won't help to lover the value using sysctl because the
> huge buffer would be already allocated during boot. If I did not miss any=
thing.
>=20
> [...]

Yeah true, a sensible default would be best, with the systctl we'd also have
to handle dynamic re-allocations and while the tracing code already added
code to make this easier I'd prefer we don't make this a popular path.

> >=20
> > > > diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> > > > index 7228258..2023424 100644
> > > > --- a/kernel/printk/printk.c
> > > > +++ b/kernel/printk/printk.c
> > > > @@ -246,6 +246,7 @@ static u32 clear_idx;
> > > >  #define LOG_ALIGN __alignof__(struct printk_log)
> > > >  #endif
> > > >  #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
> > > > +#define __LOG_CPU_BUF_LEN (1 << CONFIG_LOG_CPU_BUF_SHIFT)
> > > >  static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
> > > >  static char *log_buf =3D __log_buf;
> > > >  static u32 log_buf_len =3D __LOG_BUF_LEN;
> > > > @@ -752,9 +753,10 @@ void __init setup_log_buf(int early)
> > > >  	unsigned long flags;
> > > >  	char *new_log_buf;
> > > >  	int free;
> > > > +	int cpu_extra =3D (num_possible_cpus() - 1) * __LOG_CPU_BUF_LEN;
> > > > =20
> > > > -	if (!new_log_buf_len)
> > > > -		return;
> > > > +	if (!new_log_buf_len && cpu_extra > 1)
> > > > +		new_log_buf_len =3D __LOG_BUF_LEN + cpu_extra;
> > >=20
> > > We still should return when both new_log_buf_len and cpu_extra are
> > > zero and call here:
> > >=20
> > > 	if (!new_log_buf_len)
> > > 		return;
> >=20
> > The check for cpu_extra > 1 does that -- the default in the patch was 0
> > and 1 << 0 is 1, so if in the case that the default is used we'd bail
> > just like before. Or did I perhaps miss what you were saying here?
>=20
> The problem is that we do not bail out because you removed the "return".
> If "new_log_buf_len=3D0" and "cpu_extra=3D1" then we keep
> "new_log_buf_len" as is. Then we continue, try to allocate zero memory
> and print error: "log_buf_len: 0 bytes not available". Do I get it right?

Yeah sorry, I meant to add the else.. and bail with a return if the default
was of 0 was not used or if the kernel parameter to increase the size was
not passed.

> > > Also I would feel more comfortable if we somehow limit the maximum
> > > size of cpu_extra.
> >=20
> > Michal had similar concerns and I thought up to limit it to 1024 max
> > CPUs, but after my second implementation I did some math on the values
> > that would be used if say LOG_CPU_BUF_SHIFT was 12, it turns out to not
> > be *that* bad for even huge num_possible_cpus(). For example for 4096
> > num_possible_cpus() this comes out to with LOG_BUF_SHIFT of 18:
> >=20
> >=20
> > ((1 << 18) + ((4096 - 1) * (1 << 12))) / 1024 =3D 16636 KB
> >=20
> > ~16 MB doesn't seem that bad for such a monster box which I'd presume
> > would have an insane amount of memory. If this logic however does
> > seems unreasonable and we should cap it -- then by all means lets
> > pick a sensible number, its just not clear to me what that number
> > should be. Another reason why I stayed away from capping this was
> > that we'd then likely end up capping this in the future, and I was
> > trying to find a solution that would not require mucking as
> > technology evolves. The reasoning above is also why I had opted to
> > make the default to 0, only distributions would have a good sense
> > of what might be reasonable, which I guess begs more for a sysctl
> > value here.
>=20
> I am not sure but I think that the huge buffer would be allocated
> before any sysctl value could be modified. So, I think that sysctl
> would not really help here.

Sure.

> I think that the 10% or 20% of the total memory size is a good limit.
> Nobody would want to use more than 20% of memory for logging. So, it
> needs not be higher. The main purpose of the limit is that the system
> does not die immediately after allocating the ring buffer. The 80%
> reserve for the rest of the system sounds fine as well. Note that
> the limit won't be needed on 99,9% of systems but it would help
> with debugging the last 0.1% :-)

Oh, what we do for the the 0.1%.

  Luis

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAEBAgAGBQJTmgwWAAoJEPep4JnvMe6zg1EP/jzOZJYOa1oerzldPvn7f9w0
x/pcSJci/QZ/Cfcnl7lAObv6VFtrM7Zfl9bH8krnRIQxSbkyZv8uhtVcovl3yciA
6eEd2MxF945qj0yoeZCtATrVBcyB6jUAKwJ6SX3mtPi1BH/eGq9Gc02nYZ3iD+ek
Sk6kuNX536Hj8QTw3ewMaZR/kaGAtsZ2ZD6pzPFppvZVjYb9HszUwiWJJG6KicAZ
hc1bto/Xn7pMO9NQ9kR9azHs//vDWw/Gc7e3C1waYTqVN0LGzZxjoHfYgsdx9/BH
lWIzxdm6Sa3XjaiNMBzRFLbJtrTiPA7yrePkZ8g4oE2DcVC72UpUIu9EusVu2C4n
9duz6FFnQzpIUsM74vmQ0AVSo1P5i3wB6S7hMXCDg0eZ8uEs5kTq+ZV9C73gMdX6
5olF9iiGw7WHrmvDyHpaHUKV30NrGi6m7Z1UoZysN1zo1Ypz9sufk1BDvyP6b4+f
GFo00oMKvlCyZ6fPDVOwcho1iHcHOyqia36maWFMrRn9KZD06mzoryM1D5ZkFkOg
xmTb+UWOFhpqQwmvQ/GIyjAcSFpxSexrLsADLHmw2yxU9HrozlAp/YUsQhsnj59a
MMw1ZcHVIXZVmOK3haQoCCdanqD+sM3eUWHyOYXybfiYde8OA1t4GJWlUVDRMOTr
fumZvQAUFhNP3i5gzykm
=8wfM
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
