Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaJGUp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:45:57 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56387 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaJGUpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:45:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, Andrey Vagin <avagin@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Rob Landley <rob@landley.net>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
Date: Tue, 07 Oct 2014 13:45:22 -0700
In-Reply-To: <1412683977-29543-1-git-send-email-avagin@openvz.org> (Andrey
	Vagin's message of "Tue, 7 Oct 2014 16:12:57 +0400")
Message-ID: <87mw97wqvx.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18DciAVkpgXmLGTZj9Qgfapjmt+us7MgMQ=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4999]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrey Vagin <avagin@openvz.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 446 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 6 (1.4%), b_tie_ro: 4.9 (1.1%), parse: 1.49 (0.3%),
	extract_message_metadata: 27 (6.1%), get_uri_detail_list: 6 (1.3%),
	tests_pri_-1000: 11 (2.5%), tests_pri_-950: 1.04 (0.2%), tests_pri_-900: 0.86
	(0.2%), tests_pri_-400: 35 (7.9%), check_bayes: 34 (7.6%), b_tokenize: 11
	(2.5%), b_tok_get_all: 12 (2.6%), b_comp_prob: 4.6 (1.0%), b_tok_touch_all:
	3.1 (0.7%), b_finish: 1.05 (0.2%), tests_pri_0: 353 (79.1%), tests_pri_500: 6
	(1.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the current root
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Vagin <avagin@openvz.org> writes:

> From: Andrey Vagin <avagin@gmail.com>
>
> Currently when we create a new container with a separate root,
> we need to clone the current mount namespace with all mounts and then
> clean up it by using pivot_root(). A big part of mountpoints are cloned
> only to be umounted.

Is the motivation performance?  Because if that is the motivation we
need numbers.

> Another problem is that rootfs can't be hidden from a container, because
> rootfs can't be moved or umounted.
>
> Here is an example how to get access to rootfs:
> fd = open("/proc/self/ns/mnt", O_RDONLY)
> umount2("/", MNT_DETACH);
> setns(fd, CLONE_NEWNS)
>
> rootfs may contain data, which should not be avaliable in CT-s.

Well don't give those containers CAP_SYS_ADMIN.  If you aren't using
user namespaces there is no expectation of safety from those kinds of
problems.  Getting at rootfs is perfectly valid for root.

> I suggest to add ability to create a mount namespace with specified
> mount points. A current task root can be used as a root for the new
> mount namespace.

I really don't think you are going to like the result because you will
loose access to /proc and /sys.

> With this patch you can call chroot(ct->rootfs) and
> unshare(UNSHARE_NEWNS2) to get a clean mount namespace.

That is a little bit of an ugly way to smuggle a parameter into the
creation of a mount namespace.  Further I am pretty certain this patch
totally breaks the setting of new_fs->root and new_fs->pwd.


In net my opinion is that the code doesn't work and does not provide
sufficient justification for a new system call.

> UNSHARE_NEWNS2 can be used only with the unshare() syscall. The clone()
> syscall doesn't have unused flags.
>
> Here is an example how it looks like:
> $ cat ../../unshare.c
>
> int main(int argc, char **argv)
> {
	/* You left out
	 * mount --bind /some/root/path /some/root/path
         * chroot /some/root/path
         */

> 	if (unshare(UNSHARE_NEWNS2))
> 		return 1;
>
> 	execl("/bin/bash", "/bin/bash", NULL);
> 	return 1;
> }
> $ mount --bind test/ubuntu/ test/ubuntu/
> $ cd test/ubuntu/
> $ chroot .
> $ ./unshare2
> $ mount -t proc proc proc
> $ cat /proc/self/mountinfo
> 55 55 252:1 /home/avagin/test/ubuntu / rw,relatime - ext4 /dev/disk/by-uuid/d672b85f-533c-4868-9609-ca80be52d3c6 rw,errors=remount-ro,data=ordered
> 56 55 0:3 / /proc rw,relatime - proc proc rw
>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: Rob Landley <rob@landley.net>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  fs/namespace.c             | 16 ++++++++++++++--
>  include/uapi/linux/sched.h |  8 ++++++++
>  kernel/fork.c              | 11 ++++++++---
>  kernel/nsproxy.c           |  2 +-
>  4 files changed, 31 insertions(+), 6 deletions(-)
>
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 730c50e..f50a848 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -2569,12 +2569,24 @@ struct mnt_namespace *copy_mnt_ns(unsigned long flags, struct mnt_namespace *ns,
>  
>  	BUG_ON(!ns);
>  
> -	if (likely(!(flags & CLONE_NEWNS))) {
> +	if (likely(!(flags & (CLONE_NEWNS | UNSHARE_NEWNS2)))) {
>  		get_mnt_ns(ns);
>  		return ns;
>  	}
>  
> -	old = ns->root;
> +	if (flags & CLONE_NEWNS)
> +		old = ns->root;
> +	else { /* UNSHARE_NEWNS2 */
> +		struct path root;
> +
> +		get_fs_root(current->fs, &root);
> +		if (root.mnt->mnt_root != root.dentry) {
> +			path_put(&root);
> +			return ERR_PTR(-EINVAL); /* not a mountpoint */
> +		}
> +		old = real_mount(root.mnt);
> +		path_put(&root);
> +	}
>  
>  	new_ns = alloc_mnt_ns(user_ns);
>  	if (IS_ERR(new_ns))
> diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> index 34f9d73..8092e50 100644
> --- a/include/uapi/linux/sched.h
> +++ b/include/uapi/linux/sched.h
> @@ -31,6 +31,14 @@
>  #define CLONE_IO		0x80000000	/* Clone io context */
>  
>  /*
> + * Following flags can be used only with unshare(), because
> + * they are intersected with CSIGNAL
> + */
> +#define UNSHARE_NEWNS2		0x00000001	/* Clone mnt namespace starting with the current task root. */
> +
> +#define UNSHARE_FLAGS		(UNSHARE_NEWNS2)
> +
> +/*
>   * Scheduling policies
>   */
>  #define SCHED_NORMAL		0
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 0cf9cdb..52f1fc0 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1381,7 +1381,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	retval = copy_mm(clone_flags, p);
>  	if (retval)
>  		goto bad_fork_cleanup_signal;
> -	retval = copy_namespaces(clone_flags, p);
> +
> +	/*
> +	 * CSIGNAL and UNSHARE_FLAGS are intersected, but
> +	 * UNSHARE_FLAGS can't be used with clone().
> +	 */
> +	retval = copy_namespaces(clone_flags & ~UNSHARE_FLAGS, p);
>  	if (retval)
>  		goto bad_fork_cleanup_mm;
>  	retval = copy_io(clone_flags, p);
> @@ -1790,7 +1795,7 @@ static int check_unshare_flags(unsigned long unshare_flags)
>  	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
>  				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
>  				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNET|
> -				CLONE_NEWUSER|CLONE_NEWPID))
> +				CLONE_NEWUSER|CLONE_NEWPID|UNSHARE_FLAGS))
It seems confusing to use UNSHARE_FLAGS here.
>  		return -EINVAL;
>  	/*
>  	 * Not implemented, but pretend it works if there is nothing to
> @@ -1880,7 +1885,7 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
>  	/*
>  	 * If unsharing namespace, must also unshare filesystem information.
>  	 */
> -	if (unshare_flags & CLONE_NEWNS)
> +	if (unshare_flags & (CLONE_NEWNS | UNSHARE_NEWNS2))
>  		unshare_flags |= CLONE_FS;
>  
>  	err = check_unshare_flags(unshare_flags);
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index ef42d0a..a29e836 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -180,7 +180,7 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
>  	int err = 0;
>  
>  	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
> -			       CLONE_NEWNET | CLONE_NEWPID)))
> +			       CLONE_NEWNET | CLONE_NEWPID | UNSHARE_FLAGS)))

It is inappropriate to assume that all unshare flags will be namespaces.

>  		return 0;
>  
>  	user_ns = new_cred ? new_cred->user_ns : current_user_ns();
