Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaKOPij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 10:38:39 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:46796 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbaKOPig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 10:38:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, mtk.manpages@gmail.com,
        linux-api@vger.kernel.org, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
	<0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
Date: Sat, 15 Nov 2014 09:37:27 -0600
In-Reply-To: <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
	(Josh Triplett's message of "Sat, 15 Nov 2014 01:01:02 -0800")
Message-ID: <87d28osceg.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19Voq+N6L8xmV2k+EhoD9Mjl0l61+xdUSk=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4999]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Josh Triplett <josh@joshtriplett.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 971 ms - load_scoreonly_sql: 0.11 (0.0%),
	signal_user_changed: 6 (0.6%), b_tie_ro: 3.5 (0.4%), parse: 1.22 (0.1%),
	extract_message_metadata: 20 (2.1%), get_uri_detail_list: 3.8 (0.4%),
	tests_pri_-1000: 6 (0.6%), tests_pri_-950: 1.52 (0.2%), tests_pri_-900: 1.30
	(0.1%), tests_pri_-400: 30 (3.1%), check_bayes: 28 (2.9%), b_tokenize: 9
	(0.9%), b_tok_get_all: 9 (1.0%), b_comp_prob: 4.0 (0.4%), b_tok_touch_all:
	3.0 (0.3%), b_finish: 1.01 (0.1%), tests_pri_0: 894 (92.1%), tests_pri_500: 5
	(0.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use setgroups to drop groups
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Triplett <josh@joshtriplett.org> writes:

> Currently, unprivileged processes (without CAP_SETGID) cannot call
> setgroups at all.  In particular, processes with a set of supplementary
> groups cannot further drop permissions without obtaining elevated
> permissions first.
>
> Allow unprivileged processes to call setgroups with a subset of their
> current groups; only require CAP_SETGID to add a group the process does
> not currently have.

A couple of questions.
- Is there precedence in other unix flavors for this?
- What motiviates this change?
- Have you looked to see if anything might for bug compatibilty
  require applications not to be able to drop supplementary groups?

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
