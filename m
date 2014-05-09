Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbaEIIxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:53:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45286 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaEIIxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:53:42 -0400
Date: Fri, 9 May 2014 10:53:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        rostedt@goodmis.org, Oleg Nesterov <oleg@redhat.com>,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, Linux Kernel <linux-kernel@vger.kernel.org>,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        linux-man@vger.kernel.org
Subject: Re: sched_{set,get}attr() manpage
Message-ID: <20140509085311.GJ30445@twins.programming.kicks-ass.net>
References: <20140428081858.GX13658@twins.programming.kicks-ass.net>
 <535FA467.2070403@gmail.com>
 <20140429160441.GU11096@twins.programming.kicks-ass.net>
 <5360D9E5.9080206@gmail.com>
 <20140430130937.GH30445@twins.programming.kicks-ass.net>
 <20140503124355.5d927080518051ca507bc381@gmail.com>
 <536735E0.7020204@gmail.com>
 <20140505072114.GY11096@twins.programming.kicks-ass.net>
 <20140506081636.GA4460@twins.programming.kicks-ass.net>
 <536C907A.1040205@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lUFOiBjYbj2M+tdK"
Content-Disposition: inline
In-Reply-To: <536C907A.1040205@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lUFOiBjYbj2M+tdK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 10:23:22AM +0200, Michael Kerrisk (man-pages) wrote:
> Hi Peter,
>=20
> I'm working on this text. I see the following in kernel/sched/core.c:
>=20
> [[
> static int __sched_setscheduler(struct task_struct *p,
>                                 const struct sched_attr *attr,
>                                 bool user)
> {
>         ...
>=20
>         int policy =3D attr->sched_policy;
>         ...
>         if (policy < 0) {
>                 reset_on_fork =3D p->sched_reset_on_fork;
>                 policy =3D oldpolicy =3D p->policy;
> ]]
>=20
> What's a negative policy about? Is this something that should=20
> be documented?

That's for sched_setparam(), which internally passes policy =3D -1, it
wasn't meant to be user visible, lemme double check that.

sys_sched_setscheduler() -- explicit check for policy < 0
sys_sched_setparam() -- explicitly passes policy=3D-1, not user visible
sys_sched_setattr() -- hmm, it looks like fail


---
Subject: sched: Disallow sched_attr::sched_policy < 0
=46rom: Peter Zijlstra <peterz@infradead.org>
Date: Fri May  9 10:49:03 CEST 2014

The scheduler uses policy=3D-1 to preserve the current policy state to
implement sys_sched_setparam(), this got exposed to userspace by
accident through sys_sched_setattr(), cure this.

Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-b4kbwz2qh21xlngdzje00t55@git.kernel.org
---
 kernel/sched/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3711,6 +3711,9 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pi
 	if (sched_copy_attr(uattr, &attr))
 		return -EFAULT;
=20
+	if (attr.sched_policy < 0)
+		return -EINVAL;
+
 	rcu_read_lock();
 	retval =3D -ESRCH;
 	p =3D find_process_by_pid(pid);

--lUFOiBjYbj2M+tdK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbJd3AAoJEHZH4aRLwOS6TaoP+wc3xUldgd/tuGWtdt0JC4sE
8BIygx4L06FxrZdCwjvYCwZbI2aUxLY7iy0XExnIhsiOqD9BpYOVs0tfpc2/KIVP
4bMk7u1N8mbbqSZ9ITecNjFYvHjccDK3YsmF33Nb3WTtYdrEG3E8ddLuUGwXOpVp
CyjT0EOOQy9DrghlNgvK1I1ZS/wKAkI9pqlfjgC94BZkCxnExNcxcmMcS+8thutw
A878FTPpkURPrBIU3lEW1xbgkWMrCmQXz3Y0mhQrv+Dvuuksw1DaVvQbt6weQd/T
LdpdgmhRXI/BKARdH44oc8lymEQCSFrTmS4cpA51kz9lJrLnu/VMoVkJukGGpqJT
m6Bqle7BVNIjzarVtrEEYVsMKpwxeciUCuXhHZoZ/PHo6aY4kjJWnqiueYCKHqcJ
BOZbNuQnyjg+XB7GbXU8pxuN0JbeY7qYQV2IoaUfBBdegwjoPdxfbesgf6DeYxn+
fyR6s1RFfK7vhNNrrstZXl8WUr/zGVu9XIKjGDVqC/9SsFq97wtoFVIShXqGq1+W
o4sMd8XIEVEf+lu9AJlICwo1CNbRGlqXtk+CMpi1CijCuFA92r2vP3w74Ynog5er
L3Fh4Dy1FZMHy4QLtxpkuj3Wx5yM8seYnIxhwCPzBYjulLbp5iCpwRa9cdy8MTjF
mkQ581PjYNkazQDU9vVs
=Qgb8
-----END PGP SIGNATURE-----

--lUFOiBjYbj2M+tdK--
