Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab3HZQt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:49:58 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:53537 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3HZQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:49:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
Date: Mon, 26 Aug 2013 09:49:48 -0700
In-Reply-To: <1377534240-13227-1-git-send-email-tixxdz@opendz.org> (Djalal
	Harouni's message of "Mon, 26 Aug 2013 17:23:59 +0100")
Message-ID: <871u5gqtw3.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/wG550GGuj6v6Iq39u2cw07EkxmJYqygY=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0068]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Djalal Harouni <tixxdz@opendz.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/2] procfs: restore 0400 permissions on /proc/*/{syscall,stack,personality}
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Djalal Harouni <tixxdz@opendz.org> writes:

> Avoid giving an fd on privileged files for free by switching these
> files to 0400 mode.

This seems to be a revert of Al's patch in March of 2011 based on broken
reasoning.

Al Viro commited:
> commit a9712bc12c40c172e393f85a9b2ba8db4bf59509
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Wed Mar 23 15:52:50 2011 -0400
> 
>     deal with races in /proc/*/{syscall,stack,personality}
>     
>     All of those are rw-r--r-- and all are broken for suid - if you open
>     a file before the target does suid-root exec, you'll be still able
>     to access it.  For personality it's not a big deal, but for syscall
>     and stack it's a real problem.
>     
>     Fix: check that task is tracable for you at the time of read().
>     
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

How does changing the permissions to S_IRUSR prevent someone from
opening the file before, and reading the file after a suid exec?

> This patch restores the old mode which was 0400

Which seems to add no security whatsoever and obscure the fact that
anyone who cares can read the file so what is the point?

Eric

>
> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> ---
>  fs/proc/base.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 1485e38..6b162cd 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2576,7 +2576,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  	REG("environ",    S_IRUSR, proc_environ_operations),
>  	INF("auxv",       S_IRUSR, proc_pid_auxv),
>  	ONE("status",     S_IRUGO, proc_pid_status),
> -	ONE("personality", S_IRUGO, proc_pid_personality),
> +	ONE("personality", S_IRUSR, proc_pid_personality),
>  	INF("limits",	  S_IRUGO, proc_pid_limits),
>  #ifdef CONFIG_SCHED_DEBUG
>  	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
> @@ -2586,7 +2586,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  #endif
>  	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
>  #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
> -	INF("syscall",    S_IRUGO, proc_pid_syscall),
> +	INF("syscall",    S_IRUSR, proc_pid_syscall),
>  #endif
>  	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
>  	ONE("stat",       S_IRUGO, proc_tgid_stat),
> @@ -2614,7 +2614,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  	INF("wchan",      S_IRUGO, proc_pid_wchan),
>  #endif
>  #ifdef CONFIG_STACKTRACE
> -	ONE("stack",      S_IRUGO, proc_pid_stack),
> +	ONE("stack",      S_IRUSR, proc_pid_stack),
>  #endif
>  #ifdef CONFIG_SCHEDSTATS
>  	INF("schedstat",  S_IRUGO, proc_pid_schedstat),
> @@ -2915,14 +2915,14 @@ static const struct pid_entry tid_base_stuff[] = {
>  	REG("environ",   S_IRUSR, proc_environ_operations),
>  	INF("auxv",      S_IRUSR, proc_pid_auxv),
>  	ONE("status",    S_IRUGO, proc_pid_status),
> -	ONE("personality", S_IRUGO, proc_pid_personality),
> +	ONE("personality", S_IRUSR, proc_pid_personality),
>  	INF("limits",	 S_IRUGO, proc_pid_limits),
>  #ifdef CONFIG_SCHED_DEBUG
>  	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
>  #endif
>  	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
>  #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
> -	INF("syscall",   S_IRUGO, proc_pid_syscall),
> +	INF("syscall",   S_IRUSR, proc_pid_syscall),
>  #endif
>  	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
>  	ONE("stat",      S_IRUGO, proc_tid_stat),
> @@ -2952,7 +2952,7 @@ static const struct pid_entry tid_base_stuff[] = {
>  	INF("wchan",     S_IRUGO, proc_pid_wchan),
>  #endif
>  #ifdef CONFIG_STACKTRACE
> -	ONE("stack",      S_IRUGO, proc_pid_stack),
> +	ONE("stack",      S_IRUSR, proc_pid_stack),
>  #endif
>  #ifdef CONFIG_SCHEDSTATS
>  	INF("schedstat", S_IRUGO, proc_pid_schedstat),
