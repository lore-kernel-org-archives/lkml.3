Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaHLJEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:04:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49595 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbaHLJEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:04:15 -0400
Date: Tue, 12 Aug 2014 11:03:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, oleg@redhat.com,
        rostedt@goodmis.org, umgwanakikbuti@gmail.com, tkhai@yandex.ru,
        tim.c.chen@linux.intel.com, mingo@kernel.org, nicolas.pitre@linaro.org
Subject: Re: [PATCH v4 5/6] sched/fair: Remove double_lock_balance() from
 active_load_balance_cpu_stop()
Message-ID: <20140812090357.GP9918@twins.programming.kicks-ass.net>
References: <20140806075138.24858.23816.stgit@tkhai>
 <1407312416.8424.47.camel@tkhai>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1FYnk8XtmuXxTUQY"
Content-Disposition: inline
In-Reply-To: <1407312416.8424.47.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1FYnk8XtmuXxTUQY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 06, 2014 at 12:06:56PM +0400, Kirill Tkhai wrote:
>=20
> Bad situation:
>=20
> double_lock_balance() drops busiest_rq lock. The busiest_rq is *busiest*,
> and a lot of tasks and context switches there. We are dropping the lock
> and waiting for it again.
>=20
> Let's just detach the task and once finally unlock it!

that wants rewording, much like the previous one I did.

>=20
> Warning: this admits unlocked using of can_migrate_task(), throttled_lb_p=
air(),
> and task_hot(). I've added lockdep asserts to point on this.

That doesn't make sense; see below.

> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> ---
>  kernel/sched/fair.c |   55 +++++++++++++++++++++++++++++++++++----------=
------
>  1 file changed, 38 insertions(+), 17 deletions(-)
>=20
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index d54b72c..cfeafb1 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3297,6 +3297,8 @@ static inline int throttled_hierarchy(struct cfs_rq=
 *cfs_rq)
>   * Ensure that neither of the group entities corresponding to src_cpu or
>   * dest_cpu are members of a throttled hierarchy when performing group
>   * load-balance operations.
> + *
> + * Note: RQs may be unlocked.
>   */
>  static inline int throttled_lb_pair(struct task_group *tg,
>  				    int src_cpu, int dest_cpu)

I'm not immediately seeing this; this function is only ever called from
can_migrate_task(); and there you assert that we must be holding src_rq.

And at this point src_rq is the only relevant rq, since that is the one
the task is still on.

so let me remove this comment.

--1FYnk8XtmuXxTUQY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6dh9AAoJEHZH4aRLwOS611gP/3hE78oOhDG1Cvf1oYWnaXcR
ELUWhvO7KPnBZdbInBRzX0hoyxEpMMtmz2lTRHYLTE88EjxHNzTeDpxPSuKYF1na
l/xErXg7sX4c3PWl8hOGeCo0PFMHGWbouN/Ggigb2QYxZ5rz7wHw5Dzff0N3YLHQ
yl9J/rR4qI6VAxzqZ7Qdnz2JACKLvhqtfcFpzNi76N5sd/Ki/UwFJiWilqHp0XbY
wqd5VJ/nu9LA3GK0b+7PVTViatklKAb5bYlrB19Qp0GjuQPLO/O7Twg3oE4rHico
cejm8Z7wQSk70OnLRsdCsrQV1fikd813enlGzmaqTGsMJQATlvKx64yCOf3kTn7h
OsZ80NxTjrThAyHrdzLerBCj24xLQrfL5zQwj3hLFA5G9hE65S5Kt4GTyg22EKsK
MgAiOpm3miPZZiu2xXEGMqIA1SI9yzeRfLUicI6WXTebfQks/iDuj3ySf88+lF5j
c9dbChcaB7+6ll8uf8un5vLepoOtvkFwwj9PI+8xXwBHhmLhrLnCza0S6hpnyHi8
2mg21/1n/7lDUr6G2STAlvY5iMJmyCzED8zYLQJAdwykDNmIqjt+AuAMhi7WyWYr
M3iTx5tovlSpupfO7imImDVZtDo7HNEUDt3L0/Ifv1h1VBTRVZEzeim/1cf5OWhC
/7rwfCMkOUwCRAYLBD9g
=qf/d
-----END PGP SIGNATURE-----

--1FYnk8XtmuXxTUQY--
