Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab3FATDF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 15:03:05 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:34028 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3FATCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 15:02:55 -0400
Message-ID: <51AA455B.4060807@colorfullife.com>
Date: Sat, 01 Jun 2013 21:02:51 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>
Subject: sem_otime trashing
Content-Type: multipart/mixed;
 boundary="------------040504090805020603070202"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040504090805020603070202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Rik,

I finally managed to get EFI boot, i.e. I'm now able to test on my i3 
(2core+HT).

With semscale (i.e.: just overhead, perform semop=0 operations), the 
scalability from 1 to 2 cores is good, but not linear:
# semscale 10 | grep "interleave 2"
> Cpus 1, interleave 2 delay 0: 35502103 in 10 secs
> Cpus 2, interleave 2 delay 0: 53990954 in 10 secs
---
  +53% when adding the 2nd core
(interleave 2 to force to use different cores)

Did you consider moving sem_otime into the individual semaphores?
I did that (gross patch attached), and the performance is significantly 
better:

# semscale 10 | grep "interleave 2"
Cpus 1, interleave 2 delay 0: 35585634 in 10 secs
Cpus 2, interleave 2 delay 0: 70410230 in 10 secs
      ---
     +99% scalability when adding the 2nd core

Unfortunately I won't be able to read my mails next week, but the effect 
was too significant not to share it immediately.

--
     Manfred

--------------040504090805020603070202
Content-Type: text/plain; charset=UTF-8;
 name="patch-sem_otime_WIP"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch-sem_otime_WIP"

diff --git a/Makefile b/Makefile
index 73e20db..42137ab 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 10
 SUBLEVEL = 0
-EXTRAVERSION = -rc3
+EXTRAVERSION = -rc3-otime
 NAME = Unicycling Gorilla
 
 # *DOCUMENTATION*
diff --git a/include/linux/sem.h b/include/linux/sem.h
index 55e17f6..976ce3a 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -12,7 +12,6 @@ struct task_struct;
 struct sem_array {
 	struct kern_ipc_perm	____cacheline_aligned_in_smp
 				sem_perm;	/* permissions .. see ipc.h */
-	time_t			sem_otime;	/* last semop time */
 	time_t			sem_ctime;	/* last change time */
 	struct sem		*sem_base;	/* ptr to first semaphore in array */
 	struct list_head	pending_alter;	/* pending operations */
diff --git a/ipc/sem.c b/ipc/sem.c
index 1dbb2fa..e5f000f 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -92,6 +92,7 @@
 
 /* One semaphore structure for each semaphore in the system. */
 struct sem {
+	char	filler[64];
 	int	semval;		/* current value */
 	int	sempid;		/* pid of last operation */
 	spinlock_t	lock;	/* spinlock for fine-grained semtimedop */
@@ -99,7 +100,8 @@ struct sem {
 					/* that alter the semaphore */
 	struct list_head pending_const; /* pending single-sop operations */
 					/* that do not alter the semaphore*/
-};
+	time_t	sem_otime;	/* candidate for sem_otime */
+} ____cacheline_aligned_in_smp;
 
 /* One queue for each sleeping process in the system. */
 struct sem_queue {
@@ -919,8 +921,14 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
 			}
 		}
 	}
-	if (otime)
-		sma->sem_otime = get_seconds();
+	if (otime) {
+		if (sops == NULL) {
+			sma->sem_base[0].sem_otime = get_seconds();
+		} else {
+			sma->sem_base[sops[0].sem_num].sem_otime =
+								get_seconds();
+		}
+	}
 }
 
 
@@ -1066,6 +1074,21 @@ static unsigned long copy_semid_to_user(void __user *buf, struct semid64_ds *in,
 	}
 }
 
+static time_t get_semotime(struct sem_array *sma)
+{
+	int i;
+	time_t res;
+
+	res = sma->sem_base[0].sem_otime;
+	for (i = 1; i < sma->sem_nsems; i++) {
+		time_t to = sma->sem_base[i].sem_otime;
+
+		if (to > res)
+			res = to;
+	}
+	return res;
+}
+
 static int semctl_nolock(struct ipc_namespace *ns, int semid,
 			 int cmd, int version, void __user *p)
 {
@@ -1139,9 +1162,9 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 			goto out_unlock;
 
 		kernel_to_ipc64_perm(&sma->sem_perm, &tbuf.sem_perm);
-		tbuf.sem_otime  = sma->sem_otime;
-		tbuf.sem_ctime  = sma->sem_ctime;
-		tbuf.sem_nsems  = sma->sem_nsems;
+		tbuf.sem_otime = get_semotime(sma);
+		tbuf.sem_ctime = sma->sem_ctime;
+		tbuf.sem_nsems = sma->sem_nsems;
 		rcu_read_unlock();
 		if (copy_semid_to_user(p, &tbuf, version))
 			return -EFAULT;
@@ -2029,6 +2052,9 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
 {
 	struct user_namespace *user_ns = seq_user_ns(s);
 	struct sem_array *sma = it;
+	time_t sem_otime;
+
+	sem_otime = get_semotime(sma);
 
 	return seq_printf(s,
 			  "%10d %10d  %4o %10u %5u %5u %5u %5u %10lu %10lu\n",
@@ -2040,7 +2066,7 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
 			  from_kgid_munged(user_ns, sma->sem_perm.gid),
 			  from_kuid_munged(user_ns, sma->sem_perm.cuid),
 			  from_kgid_munged(user_ns, sma->sem_perm.cgid),
-			  sma->sem_otime,
+			  sem_otime,
 			  sma->sem_ctime);
 }
 #endif

--------------040504090805020603070202--
