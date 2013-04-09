Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964889Ab3DII0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:26:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57789 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935065Ab3DII0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:26:16 -0400
Date: Tue, 9 Apr 2013 18:26:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Guenter Roeck <linux@roeck-us.net>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Clean up kernel/timer.c
Message-Id: <20130409182604.15039dc0e35097628f241294@canb.auug.org.au>
In-Reply-To: <20130408143554.3d23a6d96bd880d46c201e8a@linux-foundation.org>
References: <20130408115325.1e4b35359271383b9c459ef9@canb.auug.org.au>
	<20130408144341.7738da3c31074f7098898029@canb.auug.org.au>
	<20130408145616.fc074f04c4c813fd2eac96a1@canb.auug.org.au>
	<20130408143554.3d23a6d96bd880d46c201e8a@linux-foundation.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__9_Apr_2013_18_26_04_+1000_k6No1Vag+CCiU18E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Apr_2013_18_26_04_+1000_k6No1Vag+CCiU18E
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Andrew Morton noted:

	akpm3:/usr/src/25> grep SYSCALL kernel/timer.c
	SYSCALL_DEFINE1(alarm, unsigned int, seconds)
	SYSCALL_DEFINE0(getpid)
	SYSCALL_DEFINE0(getppid)
	SYSCALL_DEFINE0(getuid)
	SYSCALL_DEFINE0(geteuid)
	SYSCALL_DEFINE0(getgid)
	SYSCALL_DEFINE0(getegid)
	SYSCALL_DEFINE0(gettid)
	SYSCALL_DEFINE1(sysinfo, struct sysinfo __user *, info)
	COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)

	Only one of those should be in kernel/timer.c.  Who wrote this thing?

Move some non timer related syscalls to kernel/sys.c

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/sys.c   | 211 +++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++
 kernel/timer.c | 208 +----------------------------------------------------=
---
 2 files changed, 212 insertions(+), 207 deletions(-)

This obviously depends on my previous 2 patches that move/fix
compat_sys_sysinfo.

diff --git a/kernel/sys.c b/kernel/sys.c
index 39c9c4a..ef93ad6 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -49,6 +49,11 @@
 #include <linux/user_namespace.h>
 #include <linux/binfmts.h>
=20
+#include <linux/sched.h>
+#include <linux/rcupdate.h>
+#include <linux/uidgid.h>
+#include <linux/cred.h>
+
 #include <linux/kmsg_dump.h>
 /* Move somewhere else to avoid recompiling? */
 #include <generated/utsrelease.h>
@@ -1043,6 +1048,67 @@ change_okay:
 	return old_fsgid;
 }
=20
+/**
+ * sys_getpid - return the thread group id of the current process
+ *
+ * Note, despite the name, this returns the tgid not the pid.  The tgid and
+ * the pid are identical unless CLONE_THREAD was specified on clone() in
+ * which case the tgid is the same in all threads of the same group.
+ *
+ * This is SMP safe as current->tgid does not change.
+ */
+SYSCALL_DEFINE0(getpid)
+{
+	return task_tgid_vnr(current);
+}
+
+/* Thread ID - the internal kernel "pid" */
+SYSCALL_DEFINE0(gettid)
+{
+	return task_pid_vnr(current);
+}
+
+/*
+ * Accessing ->real_parent is not SMP-safe, it could
+ * change from under us. However, we can use a stale
+ * value of ->real_parent under rcu_read_lock(), see
+ * release_task()->call_rcu(delayed_put_task_struct).
+ */
+SYSCALL_DEFINE0(getppid)
+{
+	int pid;
+
+	rcu_read_lock();
+	pid =3D task_tgid_vnr(rcu_dereference(current->real_parent));
+	rcu_read_unlock();
+
+	return pid;
+}
+
+SYSCALL_DEFINE0(getuid)
+{
+	/* Only we change this so SMP safe */
+	return from_kuid_munged(current_user_ns(), current_uid());
+}
+
+SYSCALL_DEFINE0(geteuid)
+{
+	/* Only we change this so SMP safe */
+	return from_kuid_munged(current_user_ns(), current_euid());
+}
+
+SYSCALL_DEFINE0(getgid)
+{
+	/* Only we change this so SMP safe */
+	return from_kgid_munged(current_user_ns(), current_gid());
+}
+
+SYSCALL_DEFINE0(getegid)
+{
+	/* Only we change this so SMP safe */
+	return from_kgid_munged(current_user_ns(), current_egid());
+}
+
 void do_sys_times(struct tms *tms)
 {
 	cputime_t tgutime, tgstime, cutime, cstime;
@@ -2244,3 +2310,148 @@ int orderly_poweroff(bool force)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(orderly_poweroff);
+
+/**
+ * do_sysinfo - fill in sysinfo struct
+ * @info: pointer to buffer to fill
+ */
+static int do_sysinfo(struct sysinfo *info)
+{
+	unsigned long mem_total, sav_total;
+	unsigned int mem_unit, bitcount;
+	struct timespec tp;
+
+	memset(info, 0, sizeof(struct sysinfo));
+
+	ktime_get_ts(&tp);
+	monotonic_to_bootbased(&tp);
+	info->uptime =3D tp.tv_sec + (tp.tv_nsec ? 1 : 0);
+
+	get_avenrun(info->loads, 0, SI_LOAD_SHIFT - FSHIFT);
+
+	info->procs =3D nr_threads;
+
+	si_meminfo(info);
+	si_swapinfo(info);
+
+	/*
+	 * If the sum of all the available memory (i.e. ram + swap)
+	 * is less than can be stored in a 32 bit unsigned long then
+	 * we can be binary compatible with 2.2.x kernels.  If not,
+	 * well, in that case 2.2.x was broken anyways...
+	 *
+	 *  -Erik Andersen <andersee@debian.org>
+	 */
+
+	mem_total =3D info->totalram + info->totalswap;
+	if (mem_total < info->totalram || mem_total < info->totalswap)
+		goto out;
+	bitcount =3D 0;
+	mem_unit =3D info->mem_unit;
+	while (mem_unit > 1) {
+		bitcount++;
+		mem_unit >>=3D 1;
+		sav_total =3D mem_total;
+		mem_total <<=3D 1;
+		if (mem_total < sav_total)
+			goto out;
+	}
+
+	/*
+	 * If mem_total did not overflow, multiply all memory values by
+	 * info->mem_unit and set it to 1.  This leaves things compatible
+	 * with 2.2.x, and also retains compatibility with earlier 2.4.x
+	 * kernels...
+	 */
+
+	info->mem_unit =3D 1;
+	info->totalram <<=3D bitcount;
+	info->freeram <<=3D bitcount;
+	info->sharedram <<=3D bitcount;
+	info->bufferram <<=3D bitcount;
+	info->totalswap <<=3D bitcount;
+	info->freeswap <<=3D bitcount;
+	info->totalhigh <<=3D bitcount;
+	info->freehigh <<=3D bitcount;
+
+out:
+	return 0;
+}
+
+SYSCALL_DEFINE1(sysinfo, struct sysinfo __user *, info)
+{
+	struct sysinfo val;
+
+	do_sysinfo(&val);
+
+	if (copy_to_user(info, &val, sizeof(struct sysinfo)))
+		return -EFAULT;
+
+	return 0;
+}
+
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
+COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)
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
diff --git a/kernel/timer.c b/kernel/timer.c
index f0e6588..09bca8c 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1,7 +1,7 @@
 /*
  *  linux/kernel/timer.c
  *
- *  Kernel internal timers, basic process system calls
+ *  Kernel internal timers
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *
@@ -1396,61 +1396,6 @@ SYSCALL_DEFINE1(alarm, unsigned int, seconds)
=20
 #endif
=20
-/**
- * sys_getpid - return the thread group id of the current process
- *
- * Note, despite the name, this returns the tgid not the pid.  The tgid and
- * the pid are identical unless CLONE_THREAD was specified on clone() in
- * which case the tgid is the same in all threads of the same group.
- *
- * This is SMP safe as current->tgid does not change.
- */
-SYSCALL_DEFINE0(getpid)
-{
-	return task_tgid_vnr(current);
-}
-
-/*
- * Accessing ->real_parent is not SMP-safe, it could
- * change from under us. However, we can use a stale
- * value of ->real_parent under rcu_read_lock(), see
- * release_task()->call_rcu(delayed_put_task_struct).
- */
-SYSCALL_DEFINE0(getppid)
-{
-	int pid;
-
-	rcu_read_lock();
-	pid =3D task_tgid_vnr(rcu_dereference(current->real_parent));
-	rcu_read_unlock();
-
-	return pid;
-}
-
-SYSCALL_DEFINE0(getuid)
-{
-	/* Only we change this so SMP safe */
-	return from_kuid_munged(current_user_ns(), current_uid());
-}
-
-SYSCALL_DEFINE0(geteuid)
-{
-	/* Only we change this so SMP safe */
-	return from_kuid_munged(current_user_ns(), current_euid());
-}
-
-SYSCALL_DEFINE0(getgid)
-{
-	/* Only we change this so SMP safe */
-	return from_kgid_munged(current_user_ns(), current_gid());
-}
-
-SYSCALL_DEFINE0(getegid)
-{
-	/* Only we change this so SMP safe */
-	return from_kgid_munged(current_user_ns(), current_egid());
-}
-
 static void process_timeout(unsigned long __data)
 {
 	wake_up_process((struct task_struct *)__data);
@@ -1558,157 +1503,6 @@ signed long __sched schedule_timeout_uninterruptibl=
e(signed long timeout)
 }
 EXPORT_SYMBOL(schedule_timeout_uninterruptible);
=20
-/* Thread ID - the internal kernel "pid" */
-SYSCALL_DEFINE0(gettid)
-{
-	return task_pid_vnr(current);
-}
-
-/**
- * do_sysinfo - fill in sysinfo struct
- * @info: pointer to buffer to fill
- */
-static int do_sysinfo(struct sysinfo *info)
-{
-	unsigned long mem_total, sav_total;
-	unsigned int mem_unit, bitcount;
-	struct timespec tp;
-
-	memset(info, 0, sizeof(struct sysinfo));
-
-	ktime_get_ts(&tp);
-	monotonic_to_bootbased(&tp);
-	info->uptime =3D tp.tv_sec + (tp.tv_nsec ? 1 : 0);
-
-	get_avenrun(info->loads, 0, SI_LOAD_SHIFT - FSHIFT);
-
-	info->procs =3D nr_threads;
-
-	si_meminfo(info);
-	si_swapinfo(info);
-
-	/*
-	 * If the sum of all the available memory (i.e. ram + swap)
-	 * is less than can be stored in a 32 bit unsigned long then
-	 * we can be binary compatible with 2.2.x kernels.  If not,
-	 * well, in that case 2.2.x was broken anyways...
-	 *
-	 *  -Erik Andersen <andersee@debian.org>
-	 */
-
-	mem_total =3D info->totalram + info->totalswap;
-	if (mem_total < info->totalram || mem_total < info->totalswap)
-		goto out;
-	bitcount =3D 0;
-	mem_unit =3D info->mem_unit;
-	while (mem_unit > 1) {
-		bitcount++;
-		mem_unit >>=3D 1;
-		sav_total =3D mem_total;
-		mem_total <<=3D 1;
-		if (mem_total < sav_total)
-			goto out;
-	}
-
-	/*
-	 * If mem_total did not overflow, multiply all memory values by
-	 * info->mem_unit and set it to 1.  This leaves things compatible
-	 * with 2.2.x, and also retains compatibility with earlier 2.4.x
-	 * kernels...
-	 */
-
-	info->mem_unit =3D 1;
-	info->totalram <<=3D bitcount;
-	info->freeram <<=3D bitcount;
-	info->sharedram <<=3D bitcount;
-	info->bufferram <<=3D bitcount;
-	info->totalswap <<=3D bitcount;
-	info->freeswap <<=3D bitcount;
-	info->totalhigh <<=3D bitcount;
-	info->freehigh <<=3D bitcount;
-
-out:
-	return 0;
-}
-
-SYSCALL_DEFINE1(sysinfo, struct sysinfo __user *, info)
-{
-	struct sysinfo val;
-
-	do_sysinfo(&val);
-
-	if (copy_to_user(info, &val, sizeof(struct sysinfo)))
-		return -EFAULT;
-
-	return 0;
-}
-
-#ifdef CONFIG_COMPAT
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
-COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)
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
-#endif /* CONFIG_COMPAT */
-
 static int __cpuinit init_timers_cpu(int cpu)
 {
 	int j;
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__9_Apr_2013_18_26_04_+1000_k6No1Vag+CCiU18E
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRY9CcAAoJEECxmPOUX5FEfQYP/3dntVIOv4laodoT4vDLjwhT
UOlAGfRjmazurPlAevlNt5+p6dHa52hP7HlVra4mAzUCN++Qy2u/wQYZf0jVP2ax
By8Z0bilfoPl+vKs0cCkF3lDOxoysWZCrXW84QrvHZb55aO8Q6PW8d52gwqqsuEe
evAWQMUJ9lE3SsKqmmI0R76YpvW7B6g91b9Un+9542Ac8nNW/KyyBOwjq3pvfAub
PqvGVkYYeUA0momHhwlbbQDxYMdS+TsAOxYipbD0HCtBfvsDB9B/KZX7w6g8Kpyz
pCAZTAuYhF8XMdoCeLiicvTHme7ceN+cwbSHHFvjQVKXfqX4BUMRICUh8LD+HerO
gjzDx9dxqE8bZGOWUDUN5EUcLA4gRanx74W/LRy90VJord5Jnqld5pWPtKBfBp7h
a2zmkM0oibgV6mK5zfCou2SS/0OupdgaVkX1ZRBL8ARNran3WnB7ciAO2tL4xZ5k
5cyU59LkEspUZtY/cVG2sKpUdgp/CZ1gNsyyct+otgmMoypFK1mg2O0VPz5I/Hjk
q20kgpqc7tsEebe7SrpvqN8jjCiVDtMzdQ2ynM6clQyqxTIXwTN5hBugt6wpEyFt
DshYTdJY+i/M6ui1+8zn90Reu3vY2hcXrms8iZ3qAbAyTPkdJBwoUWEjnior45pO
gYx8KtFxtgcDKMnYuJgb
=bXhg
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Apr_2013_18_26_04_+1000_k6No1Vag+CCiU18E--
