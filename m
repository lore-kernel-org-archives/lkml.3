Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934721Ab3DHBxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 21:53:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54333 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934669Ab3DHBxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 21:53:48 -0400
Date: Mon, 8 Apr 2013 11:53:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Guenter Roeck <linux@roeck-us.net>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Make do_sysinfo() static
Message-Id: <20130408115325.1e4b35359271383b9c459ef9@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__8_Apr_2013_11_53_25_+1000_B8OwZqEtJ0=4Vnx2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Apr_2013_11_53_25_+1000_B8OwZqEtJ0=4Vnx2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The only use outside of kernel/timer.c was in kernel/compat.c, so move
compat_sys_sysinfo() next to sys_sysinfo() in kernel/timer.c.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/kernel.h |  2 --
 kernel/compat.c        | 65 -----------------------------------------------
 kernel/timer.c         | 69 ++++++++++++++++++++++++++++++++++++++++++++++=
+++-
 3 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 79fdd80..a8b579c 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -734,6 +734,4 @@ static inline void ftrace_dump(enum ftrace_dump_mode oo=
ps_dump_mode) { }
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
 #endif
=20
-extern int do_sysinfo(struct sysinfo *info);
-
 #endif
diff --git a/kernel/compat.c b/kernel/compat.c
index 19971d8..1e8f145 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -1138,71 +1138,6 @@ asmlinkage long compat_sys_migrate_pages(compat_pid_=
t pid,
 }
 #endif
=20
-struct compat_sysinfo {
-	s32 uptime;
-	u32 loads[3];
-	u32 totalram;
-	u32 freeram;
-	u32 sharedram;
-	u32 bufferram;
-	u32 totalswap;
-	u32 freeswap;
-	u16 procs;
-	u16 pad;
-	u32 totalhigh;
-	u32 freehigh;
-	u32 mem_unit;
-	char _f[20-2*sizeof(u32)-sizeof(int)];
-};
-
-asmlinkage long
-compat_sys_sysinfo(struct compat_sysinfo __user *info)
-{
-	struct sysinfo s;
-
-	do_sysinfo(&s);
-
-	/* Check to see if any memory value is too large for 32-bit and scale
-	 *  down if needed
-	 */
-	if ((s.totalram >> 32) || (s.totalswap >> 32)) {
-		int bitcount =3D 0;
-
-		while (s.mem_unit < PAGE_SIZE) {
-			s.mem_unit <<=3D 1;
-			bitcount++;
-		}
-
-		s.totalram >>=3D bitcount;
-		s.freeram >>=3D bitcount;
-		s.sharedram >>=3D bitcount;
-		s.bufferram >>=3D bitcount;
-		s.totalswap >>=3D bitcount;
-		s.freeswap >>=3D bitcount;
-		s.totalhigh >>=3D bitcount;
-		s.freehigh >>=3D bitcount;
-	}
-
-	if (!access_ok(VERIFY_WRITE, info, sizeof(struct compat_sysinfo)) ||
-	    __put_user (s.uptime, &info->uptime) ||
-	    __put_user (s.loads[0], &info->loads[0]) ||
-	    __put_user (s.loads[1], &info->loads[1]) ||
-	    __put_user (s.loads[2], &info->loads[2]) ||
-	    __put_user (s.totalram, &info->totalram) ||
-	    __put_user (s.freeram, &info->freeram) ||
-	    __put_user (s.sharedram, &info->sharedram) ||
-	    __put_user (s.bufferram, &info->bufferram) ||
-	    __put_user (s.totalswap, &info->totalswap) ||
-	    __put_user (s.freeswap, &info->freeswap) ||
-	    __put_user (s.procs, &info->procs) ||
-	    __put_user (s.totalhigh, &info->totalhigh) ||
-	    __put_user (s.freehigh, &info->freehigh) ||
-	    __put_user (s.mem_unit, &info->mem_unit))
-		return -EFAULT;
-
-	return 0;
-}
-
 COMPAT_SYSCALL_DEFINE2(sched_rr_get_interval,
 		       compat_pid_t, pid,
 		       struct compat_timespec __user *, interval)
diff --git a/kernel/timer.c b/kernel/timer.c
index dbf7a78..98c9d8c 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1567,7 +1567,7 @@ SYSCALL_DEFINE0(gettid)
  * do_sysinfo - fill in sysinfo struct
  * @info: pointer to buffer to fill
  */
-int do_sysinfo(struct sysinfo *info)
+static int do_sysinfo(struct sysinfo *info)
 {
 	unsigned long mem_total, sav_total;
 	unsigned int mem_unit, bitcount;
@@ -1642,6 +1642,73 @@ SYSCALL_DEFINE1(sysinfo, struct sysinfo __user *, in=
fo)
 	return 0;
 }
=20
+#ifdef CONFIG_COMPAT
+struct compat_sysinfo {
+	s32 uptime;
+	u32 loads[3];
+	u32 totalram;
+	u32 freeram;
+	u32 sharedram;
+	u32 bufferram;
+	u32 totalswap;
+	u32 freeswap;
+	u16 procs;
+	u16 pad;
+	u32 totalhigh;
+	u32 freehigh;
+	u32 mem_unit;
+	char _f[20-2*sizeof(u32)-sizeof(int)];
+};
+
+asmlinkage long
+compat_sys_sysinfo(struct compat_sysinfo __user *info)
+{
+	struct sysinfo s;
+
+	do_sysinfo(&s);
+
+	/* Check to see if any memory value is too large for 32-bit and scale
+	 *  down if needed
+	 */
+	if ((s.totalram >> 32) || (s.totalswap >> 32)) {
+		int bitcount =3D 0;
+
+		while (s.mem_unit < PAGE_SIZE) {
+			s.mem_unit <<=3D 1;
+			bitcount++;
+		}
+
+		s.totalram >>=3D bitcount;
+		s.freeram >>=3D bitcount;
+		s.sharedram >>=3D bitcount;
+		s.bufferram >>=3D bitcount;
+		s.totalswap >>=3D bitcount;
+		s.freeswap >>=3D bitcount;
+		s.totalhigh >>=3D bitcount;
+		s.freehigh >>=3D bitcount;
+	}
+
+	if (!access_ok(VERIFY_WRITE, info, sizeof(struct compat_sysinfo)) ||
+	    __put_user (s.uptime, &info->uptime) ||
+	    __put_user (s.loads[0], &info->loads[0]) ||
+	    __put_user (s.loads[1], &info->loads[1]) ||
+	    __put_user (s.loads[2], &info->loads[2]) ||
+	    __put_user (s.totalram, &info->totalram) ||
+	    __put_user (s.freeram, &info->freeram) ||
+	    __put_user (s.sharedram, &info->sharedram) ||
+	    __put_user (s.bufferram, &info->bufferram) ||
+	    __put_user (s.totalswap, &info->totalswap) ||
+	    __put_user (s.freeswap, &info->freeswap) ||
+	    __put_user (s.procs, &info->procs) ||
+	    __put_user (s.totalhigh, &info->totalhigh) ||
+	    __put_user (s.freehigh, &info->freehigh) ||
+	    __put_user (s.mem_unit, &info->mem_unit))
+		return -EFAULT;
+
+	return 0;
+}
+#endif /* CONFIG_COMPAT */
+
 static int __cpuinit init_timers_cpu(int cpu)
 {
 	int j;
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__8_Apr_2013_11_53_25_+1000_B8OwZqEtJ0=4Vnx2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRYiMVAAoJEECxmPOUX5FELi8QAIc0NcprBW52blCL7vbArB/e
+90MCRMvvcZb5fkmgRzt7EFfDj4rgH93CVvVMXd1oJSyIuEyYxj02PeGO9UOHsuv
G1IOOQVd+2mc9zdh+CCpwn/wUH20FpA4F+BctMRvOvCp9PNJGtR2Oqybm07iXEZ4
gms0+jOl/wnkeLiLi7OG9AXPaTK0djAZu6IJa9wcgrsfGI335r9CIPyVbZubgx/8
fPiBh3gwW7e6Uzif1MH/v6ZEWhm5jCvpHfJMuZYluVKG3sRFJXvYwdicJnthv/Vh
Wy0G8h/U02uS34UiegAaahfKQPG0PzXpSrYN58vZqCRPg5Ps9hABwLCiz06OHSml
cSDjK8vN6QUBQDU57NbaLulIo45BKJIwp9/UxNsV3IJa7GuRIasHV8QYzrObG9Zn
IlLdxBJjriB8O54HlSHrSuGDd25nBXaeSaLpy+f6WiqWnLhyJVZv0gIpFOe2n2YP
V79Cga+/rb4RUKI7eE3MF1H65judESHQ3ci76HO6QpoXRSbJoq8AWeYbxw0P1I+H
sDSmLd5vLp3SEpOL6gnbNEuSKPvanFJydZdiAtHZVJ4edkxkcZw/Ubhd0lMmdIOI
Euo/xBblW0U2S45EIk2l4DbcCFxYDlz/ZjUy/gM3dkXYq3D0X25hxI9IrI/1IUSz
qsRzYVkQAuPffv504rvn
=SHgD
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Apr_2013_11_53_25_+1000_B8OwZqEtJ0=4Vnx2--
