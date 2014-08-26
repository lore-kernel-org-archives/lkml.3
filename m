Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbaHZXZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 19:25:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44936 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbaHZXZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 19:25:07 -0400
Date: Tue, 26 Aug 2014 16:25:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ying Xue <ying.xue@windriver.com>
Cc: <linux-kernel@vger.kernel.org>, <viro@zeniv.linux.org.uk>, <jack@suse.cz>
Subject: Re: [PATCH] acct: eliminate compile warning
Message-Id: <20140826162501.7c05fa936e79c07927681bad@linux-foundation.org>
In-Reply-To: <1408586326-24579-1-git-send-email-ying.xue@windriver.com>
References: <1408586326-24579-1-git-send-email-ying.xue@windriver.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2014 09:58:46 +0800 Ying Xue <ying.xue@windriver.com> wrote:

> If ACCT_VERSION is not defined to 3, below warning appears:
>   CC      kernel/acct.o
>   kernel/acct.c: In function ___do_acct_process___:
>   kernel/acct.c:475:24: warning: unused variable ___ns___ [-Wunused-variable]
> 
> Signed-off-by: Ying Xue <ying.xue@windriver.com>
> ---
>  kernel/acct.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/acct.c b/kernel/acct.c
> index b4c667d..bb52701 100644
> --- a/kernel/acct.c
> +++ b/kernel/acct.c
> @@ -472,7 +472,6 @@ static void do_acct_process(struct bsd_acct_struct *acct)
>  	acct_t ac;
>  	unsigned long flim;
>  	const struct cred *orig_cred;
> -	struct pid_namespace *ns = acct->ns;
>  	struct file *file = acct->file;
>  
>  	/*
> @@ -500,9 +499,10 @@ static void do_acct_process(struct bsd_acct_struct *acct)
>  	ac.ac_gid16 = ac.ac_gid;
>  #endif
>  #if ACCT_VERSION == 3
> -	ac.ac_pid = task_tgid_nr_ns(current, ns);
> +	ac.ac_pid = task_tgid_nr_ns(current, acct->ns);
>  	rcu_read_lock();
> -	ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(current->real_parent), ns);
> +	ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(current->real_parent),
> +				     acct->ns);
>  	rcu_read_unlock();
>  #endif

With my gcc this change increases .text from 5429 to 5437 bytes.  If we
do it this way:

--- a/kernel/acct.c~acct-eliminate-compile-warning-fix
+++ a/kernel/acct.c
@@ -499,11 +499,15 @@ static void do_acct_process(struct bsd_a
 	ac.ac_gid16 = ac.ac_gid;
 #endif
 #if ACCT_VERSION == 3
-	ac.ac_pid = task_tgid_nr_ns(current, acct->ns);
-	rcu_read_lock();
-	ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(current->real_parent),
-				     acct->ns);
-	rcu_read_unlock();
+	{
+		struct pid_namespace *ns = acct->ns;
+
+		ac.ac_pid = task_tgid_nr_ns(current, ns);
+		rcu_read_lock();
+		ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(current->real_parent),
+					     ns);
+		rcu_read_unlock();
+	}
 #endif
 	/*
 	 * Get freeze protection. If the fs is frozen, just skip the write

it actually shrinks to 5415 bytes.  Weird.


We could actually do

	if (ACCT_VERSION == 3)
		...

in lots of places in acct.c.  The code would be less ugly and
compilation coverage testing would improve.
