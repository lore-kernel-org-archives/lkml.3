Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3EaWx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:53:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab3EaWxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:53:53 -0400
Date: Fri, 31 May 2013 15:53:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] sys: remove unnecesscary parameter of set_one_prio
Message-Id: <20130531155351.830389cd15a543377fbaf289@linux-foundation.org>
In-Reply-To: <1369900686-5936-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1369900686-5936-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013 15:58:03 +0800 liguang <lig.fnst@cn.fujitsu.com> wrote:

> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---
>  kernel/sys.c |   12 +++++-------
>  1 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index b95d3c7..07c6177 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -151,9 +151,9 @@ static bool set_one_prio_perm(struct task_struct *p)
>   * set the priority of a task
>   * - the caller must hold the RCU read lock
>   */
> -static int set_one_prio(struct task_struct *p, int niceval, int error)
> +static int set_one_prio(struct task_struct *p, int niceval)
>  {
> -	int no_nice;
> +	int no_nice, error = 0;
>  
>  	if (!set_one_prio_perm(p)) {
>  		error = -EPERM;
> @@ -168,8 +168,6 @@ static int set_one_prio(struct task_struct *p, int niceval, int error)
>  		error = no_nice;
>  		goto out;
>  	}
> -	if (error == -ESRCH)
> -		error = 0;
>  	set_user_nice(p, niceval);
>  out:
>  	return error;
> @@ -203,7 +201,7 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
>  			else
>  				p = current;
>  			if (p)
> -				error = set_one_prio(p, niceval, error);
> +				error = set_one_prio(p, niceval);
>  			break;
>  		case PRIO_PGRP:
>  			if (who)
> @@ -211,7 +209,7 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
>  			else
>  				pgrp = task_pgrp(current);
>  			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
> -				error = set_one_prio(p, niceval, error);
> +				error = set_one_prio(p, niceval);
>  			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
>  			break;
>  		case PRIO_USER:
> @@ -225,7 +223,7 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
>  
>  			do_each_thread(g, p) {
>  				if (uid_eq(task_uid(p), uid))
> -					error = set_one_prio(p, niceval, error);
> +					error = set_one_prio(p, niceval);
>  			} while_each_thread(g, p);
>  			if (!uid_eq(uid, cred->uid))
>  				free_uid(user);		/* For find_user() */

Yes, that apepars to be an evuivalent change, but only because
security_task_setnice() cannot return -ESRCH.  The existing code is
rather awkward.

A couple of changes:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-sysc-remove-unnecessary-parameter-of-set_one_prio-fix

clean up definitions, remove unneeded assignment

Cc: liguang <lig.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sys.c~kernel-sysc-remove-unnecessary-parameter-of-set_one_prio-fix kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-remove-unnecessary-parameter-of-set_one_prio-fix
+++ a/kernel/sys.c
@@ -153,7 +153,8 @@ static bool set_one_prio_perm(struct tas
  */
 static int set_one_prio(struct task_struct *p, int niceval)
 {
-	int no_nice, error = 0;
+	int no_nice;
+	int error = 0;
 
 	if (!set_one_prio_perm(p)) {
 		error = -EPERM;
@@ -186,7 +187,6 @@ SYSCALL_DEFINE3(setpriority, int, which,
 		goto out;
 
 	/* normalize: avoid signed division (rounding problems) */
-	error = -ESRCH;
 	if (niceval < -20)
 		niceval = -20;
 	if (niceval > 19)
_

