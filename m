Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaGGImB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:42:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:48652 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaGGIl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:41:59 -0400
Date: Mon, 7 Jul 2014 10:41:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, xiaofeng.yan2012@gmail.com,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH] sched/rt: overrun could happen in start_hrtick_dl
Message-ID: <20140707084150.GC19379@twins.programming.kicks-ass.net>
References: <1404475341-22536-1-git-send-email-xiaofeng.yan@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QnGs129iAKyuXRcc"
Content-Disposition: inline
In-Reply-To: <1404475341-22536-1-git-send-email-xiaofeng.yan@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QnGs129iAKyuXRcc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 04, 2014 at 12:02:21PM +0000, xiaofeng.yan wrote:
> It could be wrong for the precision of runtime and deadline
> when the precision is within microsecond level. For example:
> Task runtime deadline period
>  P1   200us   500us   500us
>=20
> This case need enbale HRTICK feature by the next command
> PC#echo "HRTICK" > /sys/kernel/debug/sched_features
> PC#./schedtool -E -t 200000:500000 -e ./test&
> PC#trace-cmd record -e sched_switch

Are you actually using HRTICK ?

> Some of runtime and deadline run with millisecond level by
> reading kernershark.
> The problem is caused by a conditional judgment "delta > 10000".
> Because no hrtimer start up to control the runtime when runtime is less t=
han 10us.
> So the process will continue to run until tick-period coming.
> For fixing this problem, Let delta is equal to 10us when it is less than =
10us.
> So the hrtimer will start up to control the end of process.
>=20
> Signed-off-by: xiaofeng.yan <xiaofeng.yan@huawei.com>

Always when sending patches for deadline, also CC Juri.

> ---
>  kernel/sched/deadline.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index fc4f98b1..dfefa82 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -997,10 +997,8 @@ static void check_preempt_curr_dl(struct rq *rq, str=
uct task_struct *p,
>  #ifdef CONFIG_SCHED_HRTICK
>  static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
>  {
> -	s64 delta =3D p->dl.dl_runtime - p->dl.runtime;
> -
> -	if (delta > 10000)
> -		hrtick_start(rq, p->dl.runtime);
> +	s64 delta =3D p->dl.runtime > 10000 ? p->dl.runtime : 10000;
> +	hrtick_start(rq, delta);

Yeah, that looks funny. And seeing how the only other user does
something similar:

hrtick_start_fair()
	delta =3D max(10000ULL, delta)
	hrtick_start(rq, delta)


Does it make sense to move this max() into hrtick_start()?

Also; and I don't think you mentioned that but did fix, the argument to
hrtick_start() is wrong, it should be the delta, not the absolute
timeout.

--QnGs129iAKyuXRcc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTul1OAAoJEHZH4aRLwOS6vsIP/jIsExhA7/hrtkutR4D63n8o
T94B0p+ouoZGLdXNeA9ursbNp4A0Ua480v7eErIU4gkNjQ0Rm5/82ml4HknQ0ItF
0sbrCIsEiNu5HeMsqwM0RFng96TY+jpGYVeIj5LXy6J/Y24ZSnR/RlCGypq5FcRa
Cx7GlgGiFCf1K0P9yjvpB+ZydNHGxfHd7H/os1d78yXKFUeh+osgMqLdawaMeGKQ
qGEzUNq28nJLULx+ounGd8TsVUh88pEzGk0aptqdiyKn/Ndrq+RgoIuvHgtyiW4l
P+Ewc9Y54J6fl7GnXY9JxMm817d7t3iAmY5s2c/wN+ln3DNQGF53ULuVu/+jfLrd
ko6cPUtk0lWdIA5Q1tN/8lvVrA6PPUD1+f+7iGnGZCZhpmHtGobU6ZPEpEywzhZo
Rey4Dtal5Pm6ZUIN18Fc1HIvVnGIOewPwEv9t2qRKX1dzJlOQ0XMlH9NK7teBqQE
g7RNNsBkII2zm65MeUY0lB0ThtHFltkCi1iXxR1Tl6Vd6NRWDsO6x3L+4yIf9xrB
0cZOXdM0HNiOW8q652HKJ4XncfnkmGKLvMkbVl4au+lufktAyacLUxsNLWnh7yEB
lUQnj9NopUjS1OV1M1y0r7Wo10koxgwOO4mRF+9zjatEoJS4lm3n+Pa+ZCcBKAPN
2IZLJsQgqnnJQ0tz6Ed+
=y4i4
-----END PGP SIGNATURE-----

--QnGs129iAKyuXRcc--
