Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab3EKANg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24857 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3EKANG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:06 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=7LCdMwag0o4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=M88ZUxpYkQQA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=1XWaLZrsAAAA:8 a=QyXUC8HyAAAA:8 a=PrhRXCh_IkD_4krUzEoA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=UTB_XpHje0EA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=f9KIMHdT4mSrh0TVJEkA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001304.787961779@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, David Sharp <dhsharp@google.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>,
        Tom Zanussi <tom.zanussi@intel.com>
Subject: [PATCH 09/18] tracing: Modify soft-mode only if theres no other referrer
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-Modify-soft-mode-only-if-there-s-no-other-re.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Modify soft-mode flag only if no other soft-mode referrer
(currently only the ftrace triggers) by using a reference
counter in each ftrace_event_file.

Without this fix, adding and removing several different
enable/disable_event triggers on the same event clear
soft-mode bit from the ftrace_event_file. This also
happens with a typo of glob on setting triggers.

e.g.

 # echo vfs_symlink:enable_event:net:netif_rx > set_ftrace_filter
 # cat events/net/netif_rx/enable
 0*
 # echo typo_func:enable_event:net:netif_rx > set_ftrace_filter
 # cat events/net/netif_rx/enable
 0
 # cat set_ftrace_filter
 #### all functions enabled ####
 vfs_symlink:enable_event:net:netif_rx:unlimited

As above, we still have a trigger, but soft-mode is gone.

Link: http://lkml.kernel.org/r/20130509054429.30398.7464.stgit@mhiramat-M0-=
7522

Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    1 +
 kernel/trace/trace_events.c  |   12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 34e00fb..4372658 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -293,6 +293,7 @@ struct ftrace_event_file {
 	 * caching and such. Which is mostly OK ;-)
 	 */
 	unsigned long		flags;
+	atomic_t		sm_ref;	/* soft-mode reference counter */
 };
=20
 #define __TRACE_EVENT_FLAGS(name, value)				\
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 915c136..8be1224 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -251,7 +251,8 @@ static int __ftrace_event_enable_disable(struct ftrace_=
event_file *file,
 	switch (enable) {
 	case 0:
 		/*
-		 * When soft_disable is set and enable is cleared, we want
+		 * When soft_disable is set and enable is cleared, the sm_ref
+		 * reference counter is decremented. If it reaches 0, we want
 		 * to clear the SOFT_DISABLED flag but leave the event in the
 		 * state that it was. That is, if the event was enabled and
 		 * SOFT_DISABLED isn't set, then do nothing. But if SOFT_DISABLED
@@ -263,6 +264,8 @@ static int __ftrace_event_enable_disable(struct ftrace_=
event_file *file,
 		 * "soft enable"s (clearing the SOFT_DISABLED bit) wont work.
 		 */
 		if (soft_disable) {
+			if (atomic_dec_return(&file->sm_ref) > 0)
+				break;
 			disable =3D file->flags & FTRACE_EVENT_FL_SOFT_DISABLED;
 			clear_bit(FTRACE_EVENT_FL_SOFT_MODE_BIT, &file->flags);
 		} else
@@ -291,8 +294,11 @@ static int __ftrace_event_enable_disable(struct ftrace=
_event_file *file,
 		 */
 		if (!soft_disable)
 			clear_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
-		else
+		else {
+			if (atomic_inc_return(&file->sm_ref) > 1)
+				break;
 			set_bit(FTRACE_EVENT_FL_SOFT_MODE_BIT, &file->flags);
+		}
=20
 		if (!(file->flags & FTRACE_EVENT_FL_ENABLED)) {
=20
@@ -1540,6 +1546,7 @@ __trace_add_new_event(struct ftrace_event_call *call,
=20
 	file->event_call =3D call;
 	file->tr =3D tr;
+	atomic_set(&file->sm_ref, 0);
 	list_add(&file->list, &tr->events);
=20
 	return event_create_dir(tr->event_dir, file, id, enable, filter, format);
@@ -1562,6 +1569,7 @@ __trace_early_add_new_event(struct ftrace_event_call =
*call,
=20
 	file->event_call =3D call;
 	file->tr =3D tr;
+	atomic_set(&file->sm_ref, 0);
 	list_add(&file->list, &tr->events);
=20
 	return 0;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0QAAoJEOdOSU1xswtMuL4IANBDFNDjSVY3+4vUby2jKMDo
bR4HbY9cI/hbKx48gf7kp+/+mt0f8vLyVn8t+KkdWSKegMtHXj/wfeQ2EvL5brOS
fdcnWZ5aJDniLRLVUlU81iuePgnzgaPNT5InVBrjqIq4uxUy7ZfkoFw2kajlW7i+
6wM74uKyeaSlxZA6U0adJdIJUcfonsCHJoj50oYxSbM7jPM8geHC5VXAxHUvqKPw
eOALt9o4650Gktn8zhM12E4ojIWPT/xOZ103CJpcQysu/VmXipPp2AEUOKIG9Xe7
gjqMpDRnbNOoQhLQWQQIbLW+n0AkxZg0eMIho1USesL+SPhmU3/uhxFcc5G8Gyg=
=dasq
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
