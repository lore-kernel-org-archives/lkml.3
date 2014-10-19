Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaJSJNj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 05:13:39 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60764 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaJSJNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 05:13:36 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] fault-inject: add ratelimit option
In-Reply-To: <87ppfvqlcu.fsf@openvz.org>
References: <1408539282-5699-1-git-send-email-dmonakhov@openvz.org> <1408539282-5699-2-git-send-email-dmonakhov@openvz.org> <CAC5umyjaE6HimXyBc52jMvGYM3OgQCX1aOhQxtZ90j+9vfGnSg@mail.gmail.com> <87ppfvqlcu.fsf@openvz.org>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-redhat-linux-gnu)
Date: Sun, 19 Oct 2014 13:07:36 +0400
Message-ID: <87mw8sctrb.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dmitry Monakhov <dmonakhov@openvz.org> writes:
Ping.
> On Wed, 20 Aug 2014 23:20:18 +0900, Akinobu Mita <akinobu.mita@gmail.com>=
 wrote:
>> This looks a bit redundant.  NULL pointer to "%pd" format produces
>> "(null)" string, so this printk and if-else can be removed.
>>=20
>> Also, this message line is a bit longer than usual kernel message.
>> Should we put '\n' after "forcing a failure."?
>>=20
>> This patch looks good to me.  Please feel free to add my ACK.
> Ok. Here is updated version.
> From d06acefdd4da0d590e6dc0b1351e7adefad98fc7 Mon Sep 17 00:00:00 2001
> From: Dmitry Monakhov <dmonakhov@openvz.org>
> Date: Wed, 20 Aug 2014 18:31:06 +0400
> Subject: [PATCH] fault-inject: add ratelimit option  v2
>
> Current debug levels are not optimal. Especially if one want to
> provoke big numbers of faults(broken device simulator) then any verbose
> level will produce giant numbers of identical logging messages.
> Let's add ratelimit parameter for that purpose.
>
> Change-log:
> - Dump fault_attr configuration on minimal verbose level.
> - Add name to fault_attr
> - Add ratelimit parameter
>
> Example:
>   # Limit verbosity to one at 5 seconds
>   echo 1 > /sys/kernel/debug/fail_make_request/verbose_ratelimit_burst
>   echo 5000 > /sys/kernel/debug/fail_make_request/verbose_ratelimit_inter=
val_ms
>
>   # dump only once in a day
>   echo 1 > /sys/kernel/debug/fail_make_request/verbose_ratelimit_burst
>   echo $((24 * 60 * 60* 1000)) > /sys/kernel/debug/fail_make_request/verb=
ose_ratelimit_interval_ms
>
> Acked-by: Akinobu Mita <akinobu.mita@gmail.com>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  include/linux/fault-inject.h |   17 +++++++++++------
>  lib/fault-inject.c           |   21 +++++++++++++++++----
>  2 files changed, 28 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
> index c6f996f..798fad9 100644
> --- a/include/linux/fault-inject.h
> +++ b/include/linux/fault-inject.h
> @@ -5,6 +5,7 @@
>=20=20
>  #include <linux/types.h>
>  #include <linux/debugfs.h>
> +#include <linux/ratelimit.h>
>  #include <linux/atomic.h>
>=20=20
>  /*
> @@ -25,14 +26,18 @@ struct fault_attr {
>  	unsigned long reject_end;
>=20=20
>  	unsigned long count;
> +	struct ratelimit_state ratelimit_state;
> +	struct dentry *dname;
>  };
>=20=20
> -#define FAULT_ATTR_INITIALIZER {				\
> -		.interval =3D 1,					\
> -		.times =3D ATOMIC_INIT(1),			\
> -		.require_end =3D ULONG_MAX,			\
> -		.stacktrace_depth =3D 32,				\
> -		.verbose =3D 2,					\
> +#define FAULT_ATTR_INITIALIZER {					\
> +		.interval =3D 1,						\
> +		.times =3D ATOMIC_INIT(1),				\
> +		.require_end =3D ULONG_MAX,				\
> +		.stacktrace_depth =3D 32,					\
> +		.ratelimit_state =3D RATELIMIT_STATE_INIT_DISABLED,	\
> +		.verbose =3D 2,						\
> +		.dname =3D NULL,						\
>  	}
>=20=20
>  #define DECLARE_FAULT_ATTR(name) struct fault_attr name =3D FAULT_ATTR_I=
NITIALIZER
> diff --git a/lib/fault-inject.c b/lib/fault-inject.c
> index d7d501e..f1cdeb0 100644
> --- a/lib/fault-inject.c
> +++ b/lib/fault-inject.c
> @@ -40,10 +40,16 @@ EXPORT_SYMBOL_GPL(setup_fault_attr);
>=20=20
>  static void fail_dump(struct fault_attr *attr)
>  {
> -	if (attr->verbose > 0)
> -		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure\n");
> -	if (attr->verbose > 1)
> -		dump_stack();
> +	if (attr->verbose > 0 && __ratelimit(&attr->ratelimit_state)) {
> +		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure.\n"
> +		       "name %pd, interval %lu, probability %lu, "
> +		       "space %d, times %d\n", attr->dname,
> +		       attr->probability, attr->interval,
> +		       atomic_read(&attr->space),
> +		       atomic_read(&attr->times));
> +		if (attr->verbose > 1)
> +			dump_stack();
> +	}
>  }
>=20=20
>  #define atomic_dec_not_zero(v)		atomic_add_unless((v), -1, 0)
> @@ -202,6 +208,12 @@ struct dentry *fault_create_debugfs_attr(const char =
*name,
>  		goto fail;
>  	if (!debugfs_create_ul("verbose", mode, dir, &attr->verbose))
>  		goto fail;
> +	if (!debugfs_create_u32("verbose_ratelimit_interval_ms", mode, dir,
> +				&attr->ratelimit_state.interval))
> +		goto fail;
> +	if (!debugfs_create_u32("verbose_ratelimit_burst", mode, dir,
> +				&attr->ratelimit_state.burst))
> +		goto fail;
>  	if (!debugfs_create_bool("task-filter", mode, dir, &attr->task_filter))
>  		goto fail;
>=20=20
> @@ -222,6 +234,7 @@ struct dentry *fault_create_debugfs_attr(const char *=
name,
>=20=20
>  #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
>=20=20
> +	attr->dname =3D dget(dir);
>  	return dir;
>  fail:
>  	debugfs_remove_recursive(dir);
> --=20
> 1.7.1

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQ39YAAoJEFzOBSYIXfve8QYP/R6CbvTzhoPXlPZiGb5IWX3G
1Nr3LUKC7/i15WCls2R3zlTUGYd+savKavBrgXeegVDKPZ7LKaKwyBBVdNQHc9s8
ocIHJbVh//+K/GGQ4P66dDX7kl1iJuVo43h/y71rPx9lIvLW6zC9Mhd3uMU4LNl+
6olP0FKRNoMfi+ziU8AgZNPUnGUDBqCDmg7kRUylye3Do84wnMHQ/IWVlC3vHPCS
F/TiKPV8RVgvHzPR/ziY/WdH0cORsaL4ulta12y2jKe9Bk2+dEpn8ZvJtmqHKXsC
cAXARs42ivdcvlfZN/RF3y1ophfffNSiyDAk8rQPMrad1iwlRAjJKyfbjXGmCklC
0Hv7H+n6odCy5aML1zCI0jmg7x1800oa01jt3861tXoeN9bJD7w2yGGA0H4SbbXx
s/Cm4IFu8E5F92/Qi/v+ukd3VQs1Xj/cyuG/T6OaHhaKZeS1p6GfQciKaf83vfkQ
VYD5BqWNwF9VsqG2EAvWFYmHoaIKedQhZ9+IQHIl1/Mw84RbYtGZKLGOz8V5SYH8
TfufhRYis/1sWwyNnpbKo3MxqZLOlWRRjnu/jFctZHwn/+0CCPxWTD/vXBkg1Ajc
EQnEXZZeIKffW59EF5b/+LlDgURHN8W4aL/C8J4R42YsFZKlk1ID8CfYBG4O0Wt4
10w4HSgfsV4U2/A4r724
=M9Ol
-----END PGP SIGNATURE-----
--=-=-=--
