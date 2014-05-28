Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaE1G5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:57:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:41070 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaE1G5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:57:14 -0400
Date: Wed, 28 May 2014 08:57:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2] sched/numa: Fix use of spin_{un}lock_irq() when
 interrupts are disabled
Message-ID: <20140528065708.GK11096@twins.programming.kicks-ass.net>
References: <20140527170204.2968e4fd@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRAzd1zqvkbVQS90"
Content-Disposition: inline
In-Reply-To: <20140527170204.2968e4fd@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TRAzd1zqvkbVQS90
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2014 at 05:02:04PM -0400, Steven Rostedt wrote:
> As Peter Zijlstra told me, we have the following path:
>=20
> do_exit()
>   exit_itimers()
>     itimer_delete()
>       spin_lock_irqsave(&timer->it_lock, &flags);
>       timer_delete_hook(timer);
>         kc->timer_del(timer) :=3D posix_cpu_timer_del()
>           put_task_struct()
>             __put_task_struct()
>               task_numa_free()
>                 spin_lock(&grp->lock);
>=20
>=20
> Which means that task_numa_free() can be called with interrupts
> disabled, which means that we should not be using spin_lock_irq() but
> spin_lock_irqsave() instead. Otherwise we are enabling interrupts while
> holding an interrupt unsafe lock!
>=20

Duh, yes. Thanks Steve!

--TRAzd1zqvkbVQS90
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThYjEAAoJEHZH4aRLwOS6N70P/3ib29fCtQX6bMqrOTP28Iwg
RwbksA4Spnvnli9SvQcT1/wIMw6XBAS6Ki3dcfkFmHGNFWsvD7kNnH3p46R7DbIA
lygG/h2DcBmPCYiM08xlq0u28h6vAEHRKezcM8nlr2jBVcyIwc9/qZfuZ5T5JDiz
LhMB+lNUsowlyeWdX45y1uBwGAgglgzZgd6fY2QnxMGz0pn+3CAKLbTOW7eI/IfC
6Z6bCGV4Rg8yYJ+184s/PXaaumY8WPfK20oOr2J3JM/Y0lG+Ihpndd6zxVMPKTRS
5YxYqQ2CgSoPamC8Q89+kI4eNkvUiCCeFN17ncgX0ysRE3MVpSDJmtQLKc9BnYeT
JywrpUVZBLrn6C33CNnHYfFKMeS1Np4fjgFIl/7DyYz6a9C34lcZuizFq9pwPvPd
HPr23RPeqInZ0LcmIr3wxEHt6UFs7gMT2MJpl3fDwra3QLYKxY0SKsDOYic9mAhs
pNH/bGSzp9xTfmtnQHrztfm6BZc8/XuZf0YFEp2SeKQKtHR/Xt+NsswG684GT1lM
3wXQsvxE1KFQCe7OROmGhrp06LR6dMXCOQsYncqniu5sYUD0tZR+fb6SBnBZ9ZS1
4LYmlTk0ORnMFNRmb4NnngkjF+F5dMJr2kUfdzCah+fROwkP01fEYCILJaYGNkb6
ZP4rosHuxI+fd+qQ7TfL
=6Hg8
-----END PGP SIGNATURE-----

--TRAzd1zqvkbVQS90--
