Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaHLKlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 06:41:31 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37476 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaHLKl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 06:41:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rafael Aquini <aquini@redhat.com>, Rik van Riel <riel@redhat.com>,
        1vier1@web.de, serge@hallyn.com, containers@lists.linux-foundation.org
References: <1407828557-31995-1-git-send-email-manfred@colorfullife.com>
	<1407828557-31995-2-git-send-email-manfred@colorfullife.com>
	<1407828557-31995-3-git-send-email-manfred@colorfullife.com>
	<1407828557-31995-4-git-send-email-manfred@colorfullife.com>
Date: Tue, 12 Aug 2014 03:37:31 -0700
In-Reply-To: <1407828557-31995-4-git-send-email-manfred@colorfullife.com>
	(Manfred Spraul's message of "Tue, 12 Aug 2014 09:29:17 +0200")
Message-ID: <877g2ec7tg.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18+FEUVFhRPf+HjbXurGSpGU1Q5lxVRMv8=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Manfred Spraul <manfred@colorfullife.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 3/3] ipc namespace: copy settings from parent namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul <manfred@colorfullife.com> writes:

Sigh. Patches for new code during the merge window.  It is a really
rotten time to look at new things.

> Right now, each new IPC namespace starts with the kernel default values.
> This means that changes that were made to the limits get overwritten.
>
> With this patch, a new namespace inherits the settings from the parent
> namespace, which is less surprising.

In principle I agree.

In practice I have to ask what have you done to survey applications
that use the ipc namespace to see if they will break with this change in
semantics.

Eric

> The patch updates
> - SysV msg
> - SysV sem
> - SysV shm
> - POSIX mqueues

>
> Cc: serge@hallyn.com
> Cc: ebiederm@xmission.com
> Cc: containers@lists.linux-foundation.org
> Cc: mtk.manpages@gmail.com
>
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> ---
>  include/linux/ipc_namespace.h |  6 ++++--
>  ipc/mqueue.c                  | 23 ++++++++++++++++-------
>  ipc/msg.c                     | 16 +++++++++++-----
>  ipc/namespace.c               |  8 ++++----
>  ipc/sem.c                     | 19 +++++++++++++------
>  ipc/shm.c                     | 19 +++++++++++++------
>  ipc/util.h                    | 20 ++++++++++++++------
>  7 files changed, 75 insertions(+), 36 deletions(-)
>
> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
> index e365d5e..1cc36a0 100644
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -73,7 +73,7 @@ static inline void shm_destroy_orphaned(struct ipc_namespace *ns) {}
>  #endif /* CONFIG_SYSVIPC */
>  
>  #ifdef CONFIG_POSIX_MQUEUE
> -extern int mq_init_ns(struct ipc_namespace *ns);
> +extern int mq_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns);
>  /*
>   * POSIX Message Queue default values:
>   *
> @@ -108,7 +108,9 @@ extern int mq_init_ns(struct ipc_namespace *ns);
>  #define DFLT_MSGSIZEMAX		     8192
>  #define HARD_MSGSIZEMAX	    (16*1024*1024)
>  #else
> -static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
> +static inline int mq_init_ns(struct ipc_namespace *ns,
> +				struct ipc_namespace *old_ns)
> +{ return 0; }
>  #endif
>  
>  #if defined(CONFIG_IPC_NS)
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 4fcf39a..3473072d 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -1397,14 +1397,23 @@ static struct file_system_type mqueue_fs_type = {
>  	.fs_flags = FS_USERNS_MOUNT,
>  };
>  
> -int mq_init_ns(struct ipc_namespace *ns)
> +int mq_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns)
>  {
> +	if (old_ns != NULL) {
> +		ns->mq_queues_max    = old_ns->mq_queues_max;
> +		ns->mq_msg_max       = old_ns->mq_msg_max;
> +		ns->mq_msgsize_max   = old_ns->mq_msgsize_max;
> +		ns->mq_msg_default   = old_ns->mq_msg_default;
> +		ns->mq_msgsize_default  = old_ns->mq_msgsize_default;
> +	} else {
> +		ns->mq_queues_max    = DFLT_QUEUESMAX;
> +		ns->mq_msg_max       = DFLT_MSGMAX;
> +		ns->mq_msgsize_max   = DFLT_MSGSIZEMAX;
> +		ns->mq_msg_default   = DFLT_MSG;
> +		ns->mq_msgsize_default  = DFLT_MSGSIZE;
> +	}
> +
>  	ns->mq_queues_count  = 0;
> -	ns->mq_queues_max    = DFLT_QUEUESMAX;
> -	ns->mq_msg_max       = DFLT_MSGMAX;
> -	ns->mq_msgsize_max   = DFLT_MSGSIZEMAX;
> -	ns->mq_msg_default   = DFLT_MSG;
> -	ns->mq_msgsize_default  = DFLT_MSGSIZE;
>  
>  	ns->mq_mnt = kern_mount_data(&mqueue_fs_type, ns);
>  	if (IS_ERR(ns->mq_mnt)) {
> @@ -1444,7 +1453,7 @@ static int __init init_mqueue_fs(void)
>  
>  	spin_lock_init(&mq_lock);
>  
> -	error = mq_init_ns(&init_ipc_ns);
> +	error = mq_init_ns(&init_ipc_ns, NULL);
>  	if (error)
>  		goto out_filesystem;
>  
> diff --git a/ipc/msg.c b/ipc/msg.c
> index a7261d5..3cbd2ad 100644
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -990,11 +990,17 @@ SYSCALL_DEFINE5(msgrcv, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz,
>  }
>  
>  
> -void msg_init_ns(struct ipc_namespace *ns)
> +void msg_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns)
>  {
> -	ns->msg_ctlmax = MSGMAX;
> -	ns->msg_ctlmnb = MSGMNB;
> -	ns->msg_ctlmni = MSGMNI;
> +	if (old_ns != NULL) {
> +		ns->msg_ctlmax = old_ns->msg_ctlmax;
> +		ns->msg_ctlmnb = old_ns->msg_ctlmnb;
> +		ns->msg_ctlmni = old_ns->msg_ctlmni;
> +	} else {
> +		ns->msg_ctlmax = MSGMAX;
> +		ns->msg_ctlmnb = MSGMNB;
> +		ns->msg_ctlmni = MSGMNI;
> +	}
>  
>  	atomic_set(&ns->msg_bytes, 0);
>  	atomic_set(&ns->msg_hdrs, 0);
> @@ -1036,7 +1042,7 @@ static int sysvipc_msg_proc_show(struct seq_file *s, void *it)
>  
>  void __init msg_init(void)
>  {
> -	msg_init_ns(&init_ipc_ns);
> +	msg_init_ns(&init_ipc_ns, NULL);
>  
>  	ipc_init_proc_interface("sysvipc/msg",
>  				"       key      msqid perms      cbytes       qnum lspid lrpid   uid   gid  cuid  cgid      stime      rtime      ctime\n",
> diff --git a/ipc/namespace.c b/ipc/namespace.c
> index 1a3ffd4..97e3332 100644
> --- a/ipc/namespace.c
> +++ b/ipc/namespace.c
> @@ -33,7 +33,7 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
>  	}
>  
>  	atomic_set(&ns->count, 1);
> -	err = mq_init_ns(ns);
> +	err = mq_init_ns(ns, old_ns);
>  	if (err) {
>  		proc_free_inum(ns->proc_inum);
>  		kfree(ns);
> @@ -41,9 +41,9 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
>  	}
>  	atomic_inc(&nr_ipc_ns);
>  
> -	sem_init_ns(ns);
> -	msg_init_ns(ns);
> -	shm_init_ns(ns);
> +	sem_init_ns(ns, old_ns);
> +	msg_init_ns(ns, old_ns);
> +	shm_init_ns(ns, old_ns);
>  
>  	ns->user_ns = get_user_ns(user_ns);
>  
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 454f6c6..f1ded77 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -170,12 +170,19 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
>  #define sc_semopm	sem_ctls[2]
>  #define sc_semmni	sem_ctls[3]
>  
> -void sem_init_ns(struct ipc_namespace *ns)
> +void sem_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns)
>  {
> -	ns->sc_semmsl = SEMMSL;
> -	ns->sc_semmns = SEMMNS;
> -	ns->sc_semopm = SEMOPM;
> -	ns->sc_semmni = SEMMNI;
> +	if (old_ns != NULL) {
> +		ns->sc_semmsl = old_ns->sc_semmsl;
> +		ns->sc_semmns = old_ns->sc_semmns;
> +		ns->sc_semopm = old_ns->sc_semopm;
> +		ns->sc_semmni = old_ns->sc_semmni;
> +	} else {
> +		ns->sc_semmsl = SEMMSL;
> +		ns->sc_semmns = SEMMNS;
> +		ns->sc_semopm = SEMOPM;
> +		ns->sc_semmni = SEMMNI;
> +	}
>  	ns->used_sems = 0;
>  	ipc_init_ids(&ns->ids[IPC_SEM_IDS]);
>  }
> @@ -190,7 +197,7 @@ void sem_exit_ns(struct ipc_namespace *ns)
>  
>  void __init sem_init(void)
>  {
> -	sem_init_ns(&init_ipc_ns);
> +	sem_init_ns(&init_ipc_ns, NULL);
>  	ipc_init_proc_interface("sysvipc/sem",
>  				"       key      semid perms      nsems   uid   gid  cuid  cgid      otime      ctime\n",
>  				IPC_SEM_IDS, sysvipc_sem_proc_show);
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 7fc9f9f..7856952 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -72,12 +72,19 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp);
>  static int sysvipc_shm_proc_show(struct seq_file *s, void *it);
>  #endif
>  
> -void shm_init_ns(struct ipc_namespace *ns)
> +void shm_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns)
>  {
> -	ns->shm_ctlmax = SHMMAX;
> -	ns->shm_ctlall = SHMALL;
> -	ns->shm_ctlmni = SHMMNI;
> -	ns->shm_rmid_forced = 0;
> +	if (old_ns != NULL) {
> +		ns->shm_ctlmax = old_ns->shm_ctlmax;
> +		ns->shm_ctlall = old_ns->shm_ctlall;
> +		ns->shm_ctlmni = old_ns->shm_ctlmni;
> +		ns->shm_rmid_forced = old_ns->shm_rmid_forced;
> +	} else {
> +		ns->shm_ctlmax = SHMMAX;
> +		ns->shm_ctlall = SHMALL;
> +		ns->shm_ctlmni = SHMMNI;
> +		ns->shm_rmid_forced = 0;
> +	}
>  	ns->shm_tot = 0;
>  	ipc_init_ids(&shm_ids(ns));
>  }
> @@ -110,7 +117,7 @@ void shm_exit_ns(struct ipc_namespace *ns)
>  
>  static int __init ipc_ns_init(void)
>  {
> -	shm_init_ns(&init_ipc_ns);
> +	shm_init_ns(&init_ipc_ns, NULL);
>  	return 0;
>  }
>  
> diff --git a/ipc/util.h b/ipc/util.h
> index 1a5a0fc..1be9830 100644
> --- a/ipc/util.h
> +++ b/ipc/util.h
> @@ -30,17 +30,25 @@ static inline void mq_put_mnt(struct ipc_namespace *ns) { }
>  #endif
>  
>  #ifdef CONFIG_SYSVIPC
> -void sem_init_ns(struct ipc_namespace *ns);
> -void msg_init_ns(struct ipc_namespace *ns);
> -void shm_init_ns(struct ipc_namespace *ns);
> +void sem_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns);
> +void msg_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns);
> +void shm_init_ns(struct ipc_namespace *ns, struct ipc_namespace *old_ns);
>  
>  void sem_exit_ns(struct ipc_namespace *ns);
>  void msg_exit_ns(struct ipc_namespace *ns);
>  void shm_exit_ns(struct ipc_namespace *ns);
>  #else
> -static inline void sem_init_ns(struct ipc_namespace *ns) { }
> -static inline void msg_init_ns(struct ipc_namespace *ns) { }
> -static inline void shm_init_ns(struct ipc_namespace *ns) { }
> +static inline void sem_init_ns(struct ipc_namespace *ns,
> +				struct ipc_namespace *old_ns)
> +{ }
> +
> +static inline void msg_init_ns(struct ipc_namespace *ns,
> +				struct ipc_namespace *old_ns)
> +{ }
> +
> +static inline void shm_init_ns(struct ipc_namespace *ns,
> +				struct ipc_namespace *old_ns)
> +{ }
>  
>  static inline void sem_exit_ns(struct ipc_namespace *ns) { }
>  static inline void msg_exit_ns(struct ipc_namespace *ns) { }
