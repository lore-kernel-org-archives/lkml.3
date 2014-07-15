Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbaGOPgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:36:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49749 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaGOPgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:36:08 -0400
Date: Tue, 15 Jul 2014 17:35:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: perf: FORMAT_GROUP on attached process stops working in 3.16-rc
Message-ID: <20140715153556.GL6758@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.11.1407151030550.20353@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XZCk0ClCHCY/sYOe"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1407151030550.20353@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XZCk0ClCHCY/sYOe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable




Subject: perf: Revert ("perf: Always destroy groups on exit")
=46rom: Peter Zijlstra <peterz@infradead.org>
Date: Tue Jul 15 17:27:27 CEST 2014

Vince reported that commit 15a2d4de0eab5 ("perf: Always destroy groups
on exit") causes a regression with grouped events. In particular his
read_group_attached.c test fails.

  https://github.com/deater/perf_event_tests/blob/master/tests/bugs/read_gr=
oup_attached.c

Because of the context switch optimization in
perf_event_context_sched_out() the 'original' event may end up in the
child process and when that exits the change in the patch in question
destroys the actual grouping.

Therefore revert that change and only destroy inherited groups.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/events/core.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7458,7 +7458,19 @@ __perf_event_exit_task(struct perf_event
 			 struct perf_event_context *child_ctx,
 			 struct task_struct *child)
 {
-	perf_remove_from_context(child_event, true);
+	/*
+	 * Do not destroy the 'original' grouping; because of the context
+	 * switch optimization the original events could've ended up in a
+	 * random child task.
+	 *
+	 * If we were to destroy the original group, all group related
+	 * operations would cease to function properly after this random
+	 * child dies.
+	 *
+	 * Do destroy all inherited groups, we don't care about those
+	 * and being thorough is better.
+	 */
+	perf_remove_from_context(child_event, !!child_event->parent);
=20
 	/*
 	 * It can happen that the parent exits first, and has events

--XZCk0ClCHCY/sYOe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxUpcAAoJEHZH4aRLwOS6PPkQAKHkAShsbsWSg2vVdP7BzocI
8xFFBWa7it8Gh9jPfbn+nVSbqYnlG8mDDHZ4eJl0ddIJdKfklYrF9fT4a4CbHZ/5
u+V7H4yXwdwXgHWluUowO+RwjXomI0B83Ve+uMzk+GZ8r+qYL8TAEu+jXu4tKkJU
znraxH5C9c/iV5HvUMNsk0mZKbAYytHgb+FuKdD43YeC+xemX9sGPW5FcYDJVFBT
hWekciuExZ/Vxs2dr+NlfU8eS9mUSlFrg2RE09q0W+Ku1aGtuv8b3T4F97TP2WqE
lFmW9HHMuBIfwHWFfFT6lhzF2lgvMZ958iC40ZZ2nDmJZd3TbExzR5DydyR9iQlF
/05mWmctwBQS0Q30ZzzxsF/sOKoIOqPoIuejvGOk6GXnAV3M8JNbz2cFldc7hT2v
jehlfF6PGg42jG9w20xBawG3HbUAhOWK7xyAr1hXjInGk8cXLSDXALOk04u1GLI0
OsusK6BpYHiYFk4A8R/4YhrpFDoFseELQUnCJvXrAF/jVY8FavEcZSEbMzkOHYpJ
UyRMR8v0zP7Q2RKJyXOnzVW9287Fb1JRg3yImAGKSTEU6olPNZUHPlcCXAj15DnP
XjcgxDzfrCHXuNSy4lhzaeW/wyE9zfxJsgOuePzwPtS23BNeCvu5r+cTPRB++Wyb
Eqixs2FXtch4ixGwSR52
=EGc7
-----END PGP SIGNATURE-----

--XZCk0ClCHCY/sYOe--
