Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbaFKVrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:47:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaFKVro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:47:44 -0400
Date: Wed, 11 Jun 2014 23:47:41 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC] printk: allow increasing the ring buffer depending on
	the number of CPUs
Message-ID: <20140611214741.GH6042@wotan.suse.de>
References: <1402448685-30634-1-git-send-email-mcgrof@do-not-panic.com> <20140611093447.GL7772@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Content-Disposition: inline
In-Reply-To: <20140611093447.GL7772@pathway.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 11:34:47AM +0200, Petr Ml=E1dek wrote:
> On Tue 2014-06-10 18:04:45, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > diff --git a/init/Kconfig b/init/Kconfig
> > index 9d3585b..1814436 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -806,6 +806,34 @@ config LOG_BUF_SHIFT
> >  		     13 =3D>  8 KB
> >  		     12 =3D>  4 KB
> > =20
> > +config LOG_CPU_BUF_SHIFT
> > +	int "CPU kernel log buffer size contribution (13 =3D> 8 KB, 17 =3D> 1=
28KB)"
> > +	range 0 21
> > +	default 0
> > +	help
> > +	  The kernel ring buffer will get additional data logged onto it
> > +	  when multiple CPUs are supported. Typically the contributions is a
> > +	  few lines when idle however under under load this can vary and in t=
he
> > +	  worst case it can mean loosing logging information. You can use this
> > +	  to set the maximum expected mount of amount of logging contribution
> > +	  under load by each CPU in the worst case scenerio. Select a size as
> > +	  a power of 2. For example if LOG_BUF_SHIFT is 18 and if your
> > +	  LOG_CPU_BUF_SHIFT is 12 your kernel ring buffer size will be as
> > +	  follows having 16 CPUs as possible.
> > +
> > +	     ((1 << 18) + ((16 - 1) * (1 << 12))) / 1024 =3D 316 KB
>=20
> It might be better to use the CPU_NUM-specific value as a minimum of
> the needed space. Linux distributions might want to distribute kernel
> with non-zero value and still use the static "__log_buf" on reasonable
> small systems.

Not sure if I follow what you mean by CPU_NUM-specific, can you elaborate?
The default in this patch is to ignore this, do you mean that upstream
should probably default to a non-zero value here and then let distributions
select 0 for some kernel builds ? If so then perhaps adding a sysctl
override value might be good to allow only small systems to override
this to 0?

> > +	  Where as typically you'd only end up with 256 KB. This is disabled
> > +	  by default with a value of 0.
>=20
> I would add:
>=20
> 	This value is ignored when "log_buf_len" commandline parameter
> 	is used. It forces the exact size of the ring buffer.

Good point, I've amended this in.

> > +	  Examples:
> > +		     17 =3D> 128 KB
> > +		     16 =3D> 64 KB
> > +	             15 =3D> 32 KB
> > +	             14 =3D> 16 KB
> > +		     13 =3D>  8 KB
> > +		     12 =3D>  4 KB
>=20
> I think that we should make it more cleat that it is per-CPU here,
> for example:
>=20
> 		17 =3D> 128 KB for each CPU
> 		16 =3D>  64 KB for each CPU
> 		15 =3D>  32 KB for each CPU
> 		14 =3D>  16 KB for each CPU
> 		13 =3D>   8 KB for each CPU
> 		12 =3D>   4 KB for each CPU

Thanks, amended as well.

> > diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> > index 7228258..2023424 100644
> > --- a/kernel/printk/printk.c
> > +++ b/kernel/printk/printk.c
> > @@ -246,6 +246,7 @@ static u32 clear_idx;
> >  #define LOG_ALIGN __alignof__(struct printk_log)
> >  #endif
> >  #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
> > +#define __LOG_CPU_BUF_LEN (1 << CONFIG_LOG_CPU_BUF_SHIFT)
> >  static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
> >  static char *log_buf =3D __log_buf;
> >  static u32 log_buf_len =3D __LOG_BUF_LEN;
> > @@ -752,9 +753,10 @@ void __init setup_log_buf(int early)
> >  	unsigned long flags;
> >  	char *new_log_buf;
> >  	int free;
> > +	int cpu_extra =3D (num_possible_cpus() - 1) * __LOG_CPU_BUF_LEN;
> > =20
> > -	if (!new_log_buf_len)
> > -		return;
> > +	if (!new_log_buf_len && cpu_extra > 1)
> > +		new_log_buf_len =3D __LOG_BUF_LEN + cpu_extra;
>=20
> We still should return when both new_log_buf_len and cpu_extra are
> zero and call here:
>=20
> 	if (!new_log_buf_len)
> 		return;

The check for cpu_extra > 1 does that -- the default in the patch was 0
and 1 << 0 is 1, so if in the case that the default is used we'd bail
just like before. Or did I perhaps miss what you were saying here?

> Also I would feel more comfortable if we somehow limit the maximum
> size of cpu_extra.

Michal had similar concerns and I thought up to limit it to 1024 max
CPUs, but after my second implementation I did some math on the values
that would be used if say LOG_CPU_BUF_SHIFT was 12, it turns out to not
be *that* bad for even huge num_possible_cpus(). For example for 4096
num_possible_cpus() this comes out to with LOG_BUF_SHIFT of 18:


((1 << 18) + ((4096 - 1) * (1 << 12))) / 1024 =3D 16636 KB

~16 MB doesn't seem that bad for such a monster box which I'd presume
would have an insane amount of memory. If this logic however does
seems unreasonable and we should cap it -- then by all means lets
pick a sensible number, its just not clear to me what that number
should be. Another reason why I stayed away from capping this was
that we'd then likely end up capping this in the future, and I was
trying to find a solution that would not require mucking as
technology evolves. The reasoning above is also why I had opted to
make the default to 0, only distributions would have a good sense
of what might be reasonable, which I guess begs more for a sysctl
value here.

> I wonder if there might be a crazy setup with a lot
> of possible CPUs and possible memory but with some minimal amount of
> CPUs and memory at the boot time.

When I tested disabling smp I saw the log was still amended to include
information about the disabled CPUs, I however hadn't tested on a machine
with hot pluggable CPUs and with tons of CPUs disabled, so not sure if
that adds more info as well. This also though points more to this being
more a system specific thing, which is another reason to perhaps keep this
disabled and leave this instead as a system config?

> The question is how to do it. I am still not much familiar with the
> memory subsystem. I wonder if 10% of memory defined by the
> "total_rampages" variable would be a reasonable limit.

Not sure either, curious if Mel might have a suggestion?

>=20
> >  	if (early) {
> >  		new_log_buf =3D
> > --=20
> > 2.0.0.rc3.18.g00a5b79
> >=20
>=20
> >  LocalWords:  buf len cpu boottime

What's this? :)

  Luis

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAEBAgAGBQJTmM59AAoJEPep4JnvMe6zB58QAL1dw++v7CcMdMDixaFuFt3+
07Yt/+8WV0r4hCYvmaVWltPfIzs7EKeyyiAtW8n3xc4uuE+3zmVFRKWmTliB0Fub
3WVtzWSTDbyuPaTqLvzDQ4CT7jyqraxjFDiG62nBbB8Ytmhnbqe2ZEUVxY5IJOxp
3q91AsvJGc8brXjjTy3XCwoeZzlDbouFjq4FjTvGvTDDohrx5yz/RqBqEafOXn5O
9tuol0VJDPo3uUzM1oyLgQANukhgRJBOiMHB4+smSr7MzprR4p5dbLBHQubTJlkb
JF9RDh/0W8/piIbT2/3gUMl5IWzBTM5Z+USgPrbAy2ZjhAfRV7gyt6VZsbD2E1L/
jChraxox9vsGEOh6GlaE6XOoJcbO+ZpgcftBXmsbpqq3Td4p+ygUo8hvxwYRWpXI
bRMhCwpXjN6s3/DuEbvKc5p4Me468THy5znUg0keU5dE49zgQ+MRXTFhLWXT+MPl
p8jjQ/o3Nle18gtECD1Kux0OcT+hdIIhQ3DRFUqHkqFthmTZ6XEADGA71pn/5F8M
33LuMAKA4JQxSs1XXNT00AHkyBx4hIMNmfNjSSBsY2v964NW03QCfSQHy8p0SuI7
kuUj8/+/4ztTZsVswB0BXnUwuPRJK6V2GnwKkznN7zZIgTUp0fh1/c6YiBxh0k1b
2wfvhD4olLMdC5e1UOqU
=uhkt
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--
