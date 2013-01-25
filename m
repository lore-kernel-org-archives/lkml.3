Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab3AYSDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:03:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174Ab3AYSDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:03:22 -0500
Date: Fri, 25 Jan 2013 12:02:56 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] sched: add a tuning knob to allow changing RR
 tmeslice
Message-ID: <20130125120256.52733b51@redhat.com>
In-Reply-To: <20130125081916.GC25314@gmail.com>
References: <20121108195113.2dd51d43@redhat.com>
	<20130124165955.GA9324@gmail.com>
	<20130124135427.1748d057@redhat.com>
	<20130125081916.GC25314@gmail.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qxO_TC9=9xDNh1KHjYziyGI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qxO_TC9=9xDNh1KHjYziyGI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Jan 2013 09:19:16 +0100
Ingo Molnar <mingo@kernel.org> wrote:

>=20
> * Clark Williams <williams@redhat.com> wrote:
>=20
> > On Thu, 24 Jan 2013 17:59:55 +0100
> > Ingo Molnar <mingo@kernel.org> wrote:
> >=20
> > >=20
> > > * Clark Williams <williams@redhat.com> wrote:
> > >=20
> > > > This version stores the user-input value in a separate=20
> > > > location from the jiffies values used by the scheduler, to=20
> > > > prevent a race condition.
> > > >=20
> > > > Subject: [PATCH v2] sched: add a tuning knob to allow changing=20
> > > > RR timeslice
> > >=20
> > > looks useful.
> > >=20
> > > > @@ -2010,7 +2010,7 @@ static void task_tick_rt(struct rq *rq, struct
> > > > task_struct *p, int queued) if (--p->rt.time_slice)
> > > >  		return;
> > > > =20
> > > > -	p->rt.time_slice =3D RR_TIMESLICE;
> > > > +	p->rt.time_slice =3D sched_rr_timeslice;
> > > > =20
> > > >  	/*
> > > >  	 * Requeue to the end of queue if we (and all of our
> > > > ancestors) are the @@ -2041,7 +2041,7 @@ static unsigned int
> > > > get_rr_interval_rt(struct rq *rq, struct task_struct *task)
> > > >  	 * Time slice is 0 for SCHED_FIFO tasks
> > >=20
> > > Patch wont apply due to patch corruption, alas.
> > >=20
> > >=20
> >=20
> > Easily fixed. Modified for 3.8-rc4:
>=20
> Thanks. Some more substantial review feedback this time around:
>=20
> >=20
> > commit 0e2d40c5c84d06670f85cc212591f27f69f59c62
> > Author: Clark Williams <williams@redhat.com>
> > Date:   Thu Jan 24 13:51:01 2013 -0600
> >=20
> >     [kernel] sched: add a tuning knob to allow changing RR timeslice
> >    =20
> >     Add a /proc/sys/kernel scheduler knob named sched_rr_timeslice_ms
>=20
> s/Add a /proc/sys/kernel/sched_rr_timeslice_ms scheduler knob
>=20
> >     that allows global changing of the SCHED_RR timeslice value. User
> >     visable value is in milliseconds but is stored as jiffies.  Setting
>=20
> s/visible
>=20
> >     to 0 (zero) resets to the default (currently 100ms).
> >    =20
> >     Signed-off-by: Clark Williams <williams@redhat.com>
> >=20
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 6fc8f45..d803690 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -2082,6 +2082,11 @@ int sched_rt_handler(struct ctl_table *table, in=
t write,
> >  		void __user *buffer, size_t *lenp,
> >  		loff_t *ppos);
> > =20
> > +extern int sched_rr_timeslice;
> > +extern int sched_rr_handler(struct ctl_table *table, int write,
> > +		void __user *buffer, size_t *lenp,
> > +		loff_t *ppos);
> > +
>=20
> Shouldn't this be in kernel/sched/sched.h instead of the=20
> (already too large) linux/sched.h?
>=20

I don't think that will work be cause kernel/sysctl.c needs the
externs and I doubt we want to include kernel/sched/sched.h from there.=20

> >  #ifdef CONFIG_SCHED_AUTOGROUP
> >  extern unsigned int sysctl_sched_autogroup_enabled;
> > =20
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 257002c..5675074 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -7507,6 +7507,24 @@ static int sched_rt_global_constraints(void)
> >  }
> >  #endif /* CONFIG_RT_GROUP_SCHED */
> > =20
> > +int sched_rr_handler(struct ctl_table *table, int write,
> > +		void __user *buffer, size_t *lenp,
> > +		loff_t *ppos)
> > +{
> > +	int ret;
> > +	static DEFINE_MUTEX(mutex);
>=20
> This mutex should be outside the function (not in local scope),=20
> and named like this, with an explanation:
>=20
> +/*
> + * Since it's an int the CPU will always read a full word
> + * of the RR timeslice interval - no need for locking.
> + *
> + * But in the RR handler we read the value multiple times
> + * before setting it, which should be protected - hence
> + * this mutex:
> + */
> +static DEFINE_MUTEX(rr_timeslice_mutex);
>=20

Done.

>=20
> > +
> > +	mutex_lock(&mutex);
> > +	ret =3D proc_dointvec(table, write, buffer, lenp, ppos);
> > +	/* make sure that internally we keep jiffies */
> > +	/* also, writing zero resets timeslice to default */
> > +	if (!ret && write)=20
> > +		sched_rr_timeslice =3D sched_rr_timeslice <=3D 0 ?=20
> > +			RR_TIMESLICE : msecs_to_jiffies(sched_rr_timeslice);
> > +	mutex_unlock(&mutex);
> > +	return ret;
>=20
> A couple of stray spaces at end of lines. Also, please put curly=20
> braces around multi-line statements.
>=20

I didn't put curly braces there because "technically" that's a single
line statement. But since in fact it is multi-line, I've added them :).

> Multi-line comments should be like this:
>=20
>   /*
>    * Comment .....
>    * ...... goes here.
>    */
>=20

Done.

>=20
> > +}
> > +
> >  int sched_rt_handler(struct ctl_table *table, int write,
> >  		void __user *buffer, size_t *lenp,
> >  		loff_t *ppos)
> > diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> > index 418feb0..6c54e83 100644
> > --- a/kernel/sched/rt.c
> > +++ b/kernel/sched/rt.c
> > @@ -11,6 +11,8 @@ static int do_sched_rt_period_timer(struct rt_bandwid=
th *rt_b, int overrun);
> > =20
> >  struct rt_bandwidth def_rt_bandwidth;
> > =20
> > +int sched_rr_timeslice =3D RR_TIMESLICE;
> > +
>=20
> I think this could go into core.c as well, together with the=20
> mutex. That way it's easier to see why the mutex is needed as=20
> well.
>=20
> It should also be __read_mostly.

Done and done.=20

>=20
> >  static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *time=
r)
> >  {
> >  	struct rt_bandwidth *rt_b =3D
> > @@ -2010,7 +2012,7 @@ static void task_tick_rt(struct rq *rq, struct ta=
sk_struct *p, int queued)
> >  	if (--p->rt.time_slice)
> >  		return;
> > =20
> > -	p->rt.time_slice =3D RR_TIMESLICE;
> > +	p->rt.time_slice =3D sched_rr_timeslice;
> > =20
> >  	/*
> >  	 * Requeue to the end of queue if we (and all of our ancestors) are t=
he
> > @@ -2041,7 +2043,7 @@ static unsigned int get_rr_interval_rt(struct rq =
*rq, struct task_struct *task)
> >  	 * Time slice is 0 for SCHED_FIFO tasks
> >  	 */
> >  	if (task->policy =3D=3D SCHED_RR)
> > -		return RR_TIMESLICE;
> > +		return sched_rr_timeslice;
> >  	else
> >  		return 0;
> >  }
> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > index c88878d..1eabf86 100644
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -403,6 +403,14 @@ static struct ctl_table kern_table[] =3D {
> >  		.mode		=3D 0644,
> >  		.proc_handler	=3D sched_rt_handler,
> >  	},
> > +	{
> > +		.procname	=3D "sched_rr_timeslice_ms",
> > +		.data		=3D &sched_rr_timeslice,
> > +		.maxlen		=3D sizeof(int),
> > +		.mode		=3D 0644,
> > +		.proc_handler	=3D sched_rr_handler,
>=20
> Does this allow negative values? Wouldn't it be better to make=20
> it unsigned int all around?

Good point. Changed to unsigned int.=20

Updated patch:

commit 93dfbf6326cc4ba85c917f9440203f9fc19e9bcc
Author: Clark Williams <williams@redhat.com>
Date:   Thu Jan 24 13:51:01 2013 -0600

    [kernel] sched: add a tuning knob to allow changing RR timeslice
   =20
    Add a /proc/sys/kernel/sched_rr_timeslice_ms tuning knob
    that allows global changing of the SCHED_RR timeslice value. User
    visible value is in milliseconds but is stored as jiffies.  Setting
    to 0 (zero) resets to the default (currently 100ms).
   =20
    Signed-off-by: Clark Williams <williams@redhat.com>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6fc8f45..5d0a7cf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1226,6 +1226,11 @@ struct sched_rt_entity {
  */
 #define RR_TIMESLICE		(100 * HZ / 1000)
=20
+extern __read_mostly unsigned int sched_rr_timeslice;
+
+extern int sched_rr_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
 struct rcu_node;
=20
 enum perf_event_task_context {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 257002c..0f7e6a2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7507,6 +7507,43 @@ static int sched_rt_global_constraints(void)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
=20
+/*
+ * Since it's an int the CPU will always read a full word
+ * of the RR timeslice interval - no need for locking.
+ *
+ * But in the RR handler we read the value multiple times
+ * before setting it, which should be protected - hence
+ * this mutex:
+ */
+static DEFINE_MUTEX(rr_timeslice_mutex);
+
+unsigned int __read_mostly sched_rr_timeslice =3D RR_TIMESLICE;
+
+/*
+ * manage /proc/sys/kernel/sched_rr_timeslice_ms entry
+ * for changing SCHED_RR quantum interval
+ */
+
+int sched_rr_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret;
+
+	mutex_lock(&rr_timeslice_mutex);
+	ret =3D proc_dointvec(table, write, buffer, lenp, ppos);
+	/*
+	 * make sure that internally we keep jiffies
+	 * also, writing zero resets timeslice to default
+	 */
+	if (!ret && write)  {
+		sched_rr_timeslice =3D sched_rr_timeslice =3D=3D 0 ?
+			RR_TIMESLICE : msecs_to_jiffies(sched_rr_timeslice);
+	}
+	mutex_unlock(&rr_timeslice_mutex);
+	return ret;
+}
+
 int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 418feb0..71aa6d0 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2010,7 +2010,7 @@ static void task_tick_rt(struct rq *rq, struct task_s=
truct *p, int queued)
 	if (--p->rt.time_slice)
 		return;
=20
-	p->rt.time_slice =3D RR_TIMESLICE;
+	p->rt.time_slice =3D sched_rr_timeslice;
=20
 	/*
 	 * Requeue to the end of queue if we (and all of our ancestors) are the
@@ -2041,7 +2041,7 @@ static unsigned int get_rr_interval_rt(struct rq *rq,=
 struct task_struct *task)
 	 * Time slice is 0 for SCHED_FIFO tasks
 	 */
 	if (task->policy =3D=3D SCHED_RR)
-		return RR_TIMESLICE;
+		return sched_rr_timeslice;
 	else
 		return 0;
 }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c88878d..6770fc8 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -403,6 +403,14 @@ static struct ctl_table kern_table[] =3D {
 		.mode		=3D 0644,
 		.proc_handler	=3D sched_rt_handler,
 	},
+	{
+		.procname	=3D "sched_rr_timeslice_ms",
+		.data		=3D &sched_rr_timeslice,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D sched_rr_handler,
+	},
+
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	=3D "sched_autogroup_enabled",




--Sig_/qxO_TC9=9xDNh1KHjYziyGI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlECyNEACgkQHyuj/+TTEp0EWACcDGZHaXmzJeKhQBWS4Fait055
DGsAoMZt8FzMAywQ2yK3RneWz95HoBlo
=DcUi
-----END PGP SIGNATURE-----

--Sig_/qxO_TC9=9xDNh1KHjYziyGI--
