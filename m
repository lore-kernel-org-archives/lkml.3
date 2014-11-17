Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaKQSHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:07:04 -0500
Received: from smtp102.biz.mail.bf1.yahoo.com ([98.139.221.61]:28352 "EHLO
	smtp102.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751847AbaKQSHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:07:02 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: iREmFpkVM1n5lO3y3seSGLS0yaiyJpKrENljxLyhsCNRDEW
 efQdiQ5lKGzA6fRsrS1G.WEQ1AZqhYCwMO57aBkm_nSGp_Ju1YdynyojNJy6
 BlIySTJDk6j8dwOuCXpcK.21R0eA19GAjFnowMJ7wQg5JjmyYzVEI4cStj0w
 QbPZNsxJPbu0.oTiPE8O5z.rk3DO16eh2ohmxN3fySN9QQLfVTfwr9mSadrW
 OWEZUKTbugGREEEowTgxgpOAeRAAoNi4lntIAok4YPdLVK4S16.0bUYRzQp2
 M72ui.uMMzIsLF0tQepnExZtAAu9dFrmCHtNE04SdUJlNY7hH3iOuZsyzlHI
 DyOl6fSKGMUNqZBqY4aw1Bqv1EOtmRb2s5Orluwcsy6uUXnyMznqWCYaKSzH
 eERSuWfv254mIiwx0bvTnOAzSOYpK2ytvtsblh4JMQcOv5DdDPq6xDAoiAfY
 bLftR3pvdeyWbExcnwhUW3U7DF1fMoiydNiBzb2sq4ekaDjyDJ4f6QgBUIRd
 R.G1fJ7ECx3TIwnwz00nv1HV8
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <546A3942.5040906@schaufler-ca.com>
Date: Mon, 17 Nov 2014 10:06:58 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, mtk.manpages@gmail.com,
        linux-api@vger.kernel.org, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use setgroups
 to drop groups
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org> <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
In-Reply-To: <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2014 1:01 AM, Josh Triplett wrote:
> Currently, unprivileged processes (without CAP_SETGID) cannot call
> setgroups at all.  In particular, processes with a set of supplementary
> groups cannot further drop permissions without obtaining elevated
> permissions first.

Has anyone put any thought into how this will interact with
POSIX ACLs? I don't see that anywhere in the discussion.

Tizen takes advantage of the fact you can't drop groups. If
a process can drop itself out of groups without privilege
it can circumvent the system security policy.

Back when the LSM was introduced a choice was made between
authoritative hooks (which would have allowed this sort of thing)
and restrictive hooks (which would not). Authoritative hooks were
rejected because they would have "broken Linux". I hope that the
people who spoke up then will speak up now.

This is going to introduce a whole class of vulnerabilities.
Don't even think of arguing that the reduction in use of privilege
will make up for that. Developers have enough trouble with the
difference between setuid() and seteuid() to expect them to use
group dropping properly.

>
> Allow unprivileged processes to call setgroups with a subset of their
> current groups; only require CAP_SETGID to add a group the process does
> not currently have.
>
> The kernel already maintains the list of supplementary group IDs in
> sorted order, and setgroups already needs to sort the new list, so this
> just requires a linear comparison of the two sorted lists.
>
> This moves the CAP_SETGID test from setgroups into set_current_groups.
>
> Tested via the following test program:
>
> #include <err.h>
> #include <grp.h>
> #include <stdio.h>
> #include <sys/types.h>
> #include <unistd.h>
>
> void run_id(void)
> {
>     pid_t p = fork();
>     switch (p) {
>         case -1:
>             err(1, "fork");
>         case 0:
>             execl("/usr/bin/id", "id", NULL);
>             err(1, "exec");
>         default:
>             if (waitpid(p, NULL, 0) < 0)
>                 err(1, "waitpid");
>     }
> }
>
> int main(void)
> {
>     gid_t list1[] = { 1, 2, 3, 4, 5 };
>     gid_t list2[] = { 2, 3, 4 };
>     run_id();
>     if (setgroups(5, list1) < 0)
>         err(1, "setgroups 1");
>     run_id();
>     if (setresgid(1, 1, 1) < 0)
>         err(1, "setresgid");
>     if (setresuid(1, 1, 1) < 0)
>         err(1, "setresuid");
>     run_id();
>     if (setgroups(3, list2) < 0)
>         err(1, "setgroups 2");
>     run_id();
>     if (setgroups(5, list1) < 0)
>         err(1, "setgroups 3");
>     run_id();
>
>     return 0;
> }
>
> Without this patch, the test program gets EPERM from the second
> setgroups call, after dropping root privileges.  With this patch, the
> test program successfully drops groups 1 and 5, but then gets EPERM from
> the third setgroups call, since that call attempts to add groups the
> process does not currently have.
>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  kernel/groups.c | 33 ++++++++++++++++++++++++++++++---
>  kernel/uid16.c  |  2 --
>  2 files changed, 30 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/groups.c b/kernel/groups.c
> index f0667e7..fe7367d 100644
> --- a/kernel/groups.c
> +++ b/kernel/groups.c
> @@ -153,6 +153,29 @@ int groups_search(const struct group_info *group_info, kgid_t grp)
>  	return 0;
>  }
>  
> +/* Compare two sorted group lists; return true if the first is a subset of the
> + * second.
> + */
> +static bool is_subset(const struct group_info *g1, const struct group_info *g2)
> +{
> +	unsigned int i, j;
> +
> +	for (i = 0, j = 0; i < g1->ngroups; i++) {
> +		kgid_t gid1 = GROUP_AT(g1, i);
> +		kgid_t gid2;
> +		for (; j < g2->ngroups; j++) {
> +			gid2 = GROUP_AT(g2, j);
> +			if (gid_lte(gid1, gid2))
> +				break;
> +		}
> +		if (j >= g2->ngroups || !gid_eq(gid1, gid2))
> +			return false;
> +		j++;
> +	}
> +
> +	return true;
> +}
> +
>  /**
>   * set_groups_sorted - Change a group subscription in a set of credentials
>   * @new: The newly prepared set of credentials to alter
> @@ -189,11 +212,17 @@ int set_current_groups(struct group_info *group_info)
>  {
>  	struct cred *new;
>  
> +	groups_sort(group_info);
>  	new = prepare_creds();
>  	if (!new)
>  		return -ENOMEM;
> +	if (!ns_capable(current_user_ns(), CAP_SETGID)
> +	    && !is_subset(group_info, new->group_info)) {
> +		abort_creds(new);
> +		return -EPERM;
> +	}
>  
> -	set_groups(new, group_info);
> +	set_groups_sorted(new, group_info);
>  	return commit_creds(new);
>  }
>  
> @@ -233,8 +262,6 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
>  	struct group_info *group_info;
>  	int retval;
>  
> -	if (!ns_capable(current_user_ns(), CAP_SETGID))
> -		return -EPERM;
>  	if ((unsigned)gidsetsize > NGROUPS_MAX)
>  		return -EINVAL;
>  
> diff --git a/kernel/uid16.c b/kernel/uid16.c
> index 602e5bb..b27e167 100644
> --- a/kernel/uid16.c
> +++ b/kernel/uid16.c
> @@ -176,8 +176,6 @@ SYSCALL_DEFINE2(setgroups16, int, gidsetsize, old_gid_t __user *, grouplist)
>  	struct group_info *group_info;
>  	int retval;
>  
> -	if (!ns_capable(current_user_ns(), CAP_SETGID))
> -		return -EPERM;
>  	if ((unsigned)gidsetsize > NGROUPS_MAX)
>  		return -EINVAL;
>  

