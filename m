Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbaEYUBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 16:01:24 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:64069 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaEYUBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 16:01:22 -0400
Message-ID: <53824C0D.1070204@colorfullife.com>
Date: Sun, 25 May 2014 22:01:17 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marian Marinov <mm@1h.com>, Davidlohr Bueso <davidlohr@hp.com>
CC: akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] IPC initialize shmmax and shmall from the current value
 not the default
References: <5365723D.7030303@1h.com> <1399161216.2573.9.camel@buesod1.americas.hpqcorp.net> <536621D4.60002@colorfullife.com> <5367EDB6.3010408@1h.com> <537DF520.2050904@1h.com>
In-Reply-To: <537DF520.2050904@1h.com>
Content-Type: multipart/mixed;
 boundary="------------040400010102080704000705"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040400010102080704000705
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marian,

On 05/22/2014 03:01 PM, Marian Marinov wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 05/05/2014 10:59 PM, Marian Marinov wrote:
>>
>> In my tests it worked exactly as expected. Here is an example:
>>
>> [root@sp2 ~]# sysctl -a|grep shmmax kernel.shmmax = 68719476736 [root@sp2 ~]# lxc-attach -n cent_plain
>> [root@localhost ~]# sysctl -a|grep shmmax kernel.shmmax = 68719476736 [root@localhost ~]# halt [root@sp2 ~]# sysctl
>> -a|grep shmmax kernel.shmmax = 68719476736 [root@sp2 ~]# sysctl kernel.shmmax=34359738368 kernel.shmmax =
>> 34359738368 [root@sp2 ~]# lxc-start -n cent_plain -d [root@sp2 ~]# lxc-attach -n cent_plain [root@localhost ~]#
>> sysctl -a|grep shmmax kernel.shmmax = 34359738368 [root@localhost ~]#
>>
>> So it seams to work as expected :)
>>
>> It works because wen you setup a new shmmax limit it is actually the limit in the init_ipc_ns. So when we are
>> creating a new ipc_ns its ok to copy the values from init_ipc_ns.
>>
>> -Marian
>>
> Ping?
>
> So will there be any more comments on that?
>
>
Attached is an untested idea:
- each new namespace copies from it's parent, i.e. nested namespaces 
should work.
- msg, sem and shm updated

--
     Manfred

--------------040400010102080704000705
Content-Type: text/x-patch;
 name="0001-ipc-namespace-copy-settings-from-parent-namespace.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ipc-namespace-copy-settings-from-parent-namespace.patch"

>From ed73ce838fc3f55e34041591a72b3135ccaa460b Mon Sep 17 00:00:00 2001
From: Manfred Spraul <manfred@colorfullife.com>
Date: Sun, 25 May 2014 21:04:42 +0200
Subject: [PATCH] ipc namespace: copy settings from parent namespace

Right now, each IPC namespace starts with the kernel boot standard
settings.
This patch changes that:
Now each new namespace starts with the settings from the parent
namespace.

The patch updates msg, sem and shm.

Marian: Would that patch help you?

It's just a proposal - not yet tested.

Open issues:
- auto_msgmni is not yet taken from parent.

--
	Manfred
---
 ipc/msg.c       | 13 +++++++++----
 ipc/namespace.c |  6 +++---
 ipc/sem.c       | 19 +++++++++++++------
 ipc/shm.c       | 19 +++++++++++++------
 ipc/util.h      | 12 ++++++------
 5 files changed, 44 insertions(+), 25 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 6498531..6c72d43 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -107,10 +107,15 @@ void recompute_msgmni(struct ipc_namespace *ns)
 	ns->msg_ctlmni = allowed;
 }
 
-void msg_init_ns(struct ipc_namespace *ns)
+void msg_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns)
 {
-	ns->msg_ctlmax = MSGMAX;
-	ns->msg_ctlmnb = MSGMNB;
+	if (old_ns != NULL) {
+		ns->msg_ctlmax = old_ns->msg_ctlmax;
+		ns->msg_ctlmnb = old_ns->msg_ctlmnb;
+	} else {
+		ns->msg_ctlmax = MSGMAX;
+		ns->msg_ctlmnb = MSGMNB;
+	}
 
 	recompute_msgmni(ns);
 
@@ -129,7 +134,7 @@ void msg_exit_ns(struct ipc_namespace *ns)
 
 void __init msg_init(void)
 {
-	msg_init_ns(&init_ipc_ns);
+	msg_init_ns(&init_ipc_ns, NULL);
 
 	printk(KERN_INFO "msgmni has been set to %d\n",
 		init_ipc_ns.msg_ctlmni);
diff --git a/ipc/namespace.c b/ipc/namespace.c
index 59451c1..57b65fa 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -41,9 +41,9 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 	}
 	atomic_inc(&nr_ipc_ns);
 
-	sem_init_ns(ns);
-	msg_init_ns(ns);
-	shm_init_ns(ns);
+	sem_init_ns(ns, old_ns);
+	msg_init_ns(ns, old_ns);
+	shm_init_ns(ns, old_ns);
 
 	/*
 	 * msgmni has already been computed for the new ipc ns.
diff --git a/ipc/sem.c b/ipc/sem.c
index bee5554..0e232e6 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -170,12 +170,19 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
 #define sc_semopm	sem_ctls[2]
 #define sc_semmni	sem_ctls[3]
 
-void sem_init_ns(struct ipc_namespace *ns)
+void sem_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns)
 {
-	ns->sc_semmsl = SEMMSL;
-	ns->sc_semmns = SEMMNS;
-	ns->sc_semopm = SEMOPM;
-	ns->sc_semmni = SEMMNI;
+	if (old_ns != NULL) {
+		ns->sc_semmsl = old_ns->sc_semmsl;
+		ns->sc_semmns = old_ns->sc_semmns;
+		ns->sc_semopm = old_ns->sc_semopm;
+		ns->sc_semmni = old_ns->sc_semmni;
+	} else {
+		ns->sc_semmsl = SEMMSL;
+		ns->sc_semmns = SEMMNS;
+		ns->sc_semopm = SEMOPM;
+		ns->sc_semmni = SEMMNI;
+	}
 	ns->used_sems = 0;
 	ipc_init_ids(&ns->ids[IPC_SEM_IDS]);
 }
@@ -190,7 +197,7 @@ void sem_exit_ns(struct ipc_namespace *ns)
 
 void __init sem_init(void)
 {
-	sem_init_ns(&init_ipc_ns);
+	sem_init_ns(&init_ipc_ns, NULL);
 	ipc_init_proc_interface("sysvipc/sem",
 				"       key      semid perms      nsems   uid   gid  cuid  cgid      otime      ctime\n",
 				IPC_SEM_IDS, sysvipc_sem_proc_show);
diff --git a/ipc/shm.c b/ipc/shm.c
index 7645961..5c54b25 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -72,12 +72,19 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp);
 static int sysvipc_shm_proc_show(struct seq_file *s, void *it);
 #endif
 
-void shm_init_ns(struct ipc_namespace *ns)
+void shm_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns)
 {
-	ns->shm_ctlmax = SHMMAX;
-	ns->shm_ctlall = SHMALL;
-	ns->shm_ctlmni = SHMMNI;
-	ns->shm_rmid_forced = 0;
+	if (old_ns != NULL) {
+		ns->shm_ctlmax = old_ns->shm_ctlmax;
+		ns->shm_ctlall = old_ns->shm_ctlall;
+		ns->shm_ctlmni = old_ns->shm_ctlmni;
+		ns->shm_rmid_forced = old_ns->shm_rmid_forced;
+	} else {
+		ns->shm_ctlmax = SHMMAX;
+		ns->shm_ctlall = SHMALL;
+		ns->shm_ctlmni = SHMMNI;
+		ns->shm_rmid_forced = 0;
+	}
 	ns->shm_tot = 0;
 	ipc_init_ids(&shm_ids(ns));
 }
@@ -110,7 +117,7 @@ void shm_exit_ns(struct ipc_namespace *ns)
 
 static int __init ipc_ns_init(void)
 {
-	shm_init_ns(&init_ipc_ns);
+	shm_init_ns(&init_ipc_ns, NULL);
 	return 0;
 }
 
diff --git a/ipc/util.h b/ipc/util.h
index 9c47d6f..bb62b44 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -30,17 +30,17 @@ static inline void mq_put_mnt(struct ipc_namespace *ns) { }
 #endif
 
 #ifdef CONFIG_SYSVIPC
-void sem_init_ns(struct ipc_namespace *ns);
-void msg_init_ns(struct ipc_namespace *ns);
-void shm_init_ns(struct ipc_namespace *ns);
+void sem_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns);
+void msg_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns);
+void shm_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns);
 
 void sem_exit_ns(struct ipc_namespace *ns);
 void msg_exit_ns(struct ipc_namespace *ns);
 void shm_exit_ns(struct ipc_namespace *ns);
 #else
-static inline void sem_init_ns(struct ipc_namespace *ns) { }
-static inline void msg_init_ns(struct ipc_namespace *ns) { }
-static inline void shm_init_ns(struct ipc_namespace *ns) { }
+static inline void sem_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns) { }
+static inline void msg_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns) { }
+static inline void shm_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns) { }
 
 static inline void sem_exit_ns(struct ipc_namespace *ns) { }
 static inline void msg_exit_ns(struct ipc_namespace *ns) { }
-- 
1.9.0



--------------040400010102080704000705--
