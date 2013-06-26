Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab3FZTkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:40:12 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33711 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3FZTkK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:40:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, "Daniel P. Berrange" <berrange@redhat.com>,
        containers@lists.linux-foundation.org,
        Colin Ian King <colin.king@canonical.com>,
        =?utf-8?Q?St=C3=A9phane?= Graber <stgraber@ubuntu.com>
References: <20130626161820.GA32142@tp>
Date: Wed, 26 Jun 2013 12:39:33 -0700
In-Reply-To: <20130626161820.GA32142@tp> (Serge Hallyn's message of "Wed, 26
	Jun 2013 11:18:20 -0500")
Message-ID: <877ghg4q6i.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX18hxoOXUI+haeDWK0br5tCZ9YsIu5msO3U=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3813]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Serge Hallyn <serge.hallyn@ubuntu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH RFC] procfs: add pidnr file
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@ubuntu.com> writes:

> Add a file called pidnr under /proc/task/.  Reading this file gives the
> pid of /proc/task in the reading task's namespace (or 0 if there is no
> valid pid).
>
> This fills a need currently not solvable at all.  The particular need I
> have for it is so that a task inside a container can pass requests to a
> task outside the container (using an open fd for /proc/task) to have the
> target task moved to a new cgroup.  Others have asked for this ability
> for other reasons.

This is solvable today.  Just pass the pid using SCM_CREDENTIALS over a
unix domain socket between the two processes.  That is actually better
because a task can't claim to be a member of another task.  You already
have the unix domain socket if you are using SCM_RIGHTS to pass file
descriptors.

Oh ick.  You have a file whose contents change depending on who is
reading an open file descriptor.  That can get rather ugly.  It is
better for the contents to be constant and based upon when the file was
opened.

I also don't like the name.  Nothing about the name says to me this is
the tasks pid from the reading tasks perspective.

I do sympathize with the problem and I think this patch could be on
the right track.

Eric

> Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: "Daniel P. Berrange" <berrange@redhat.com>
> Cc: containers@lists.linux-foundation.org
> Cc: Colin Ian King <colin.king@canonical.com>
> Cc: Stéphane Graber <stgraber@ubuntu.com>
> ---
>  fs/proc/base.c |   25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index c3834da..b7499eb 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -899,6 +899,28 @@ static const struct file_operations proc_environ_operations = {
>  	.release	= mem_release,
>  };
>  
> +#define TMPBUFLEN 21
> +static ssize_t pidnr_read(struct file * file, char __user * buf,
> +				  size_t count, loff_t *ppos)
> +{
> +	struct inode * inode = file_inode(file);
> +	struct task_struct *task = get_proc_task(inode);
> +	ssize_t length;
> +	char tmpbuf[TMPBUFLEN];
> +
> +	if (!task)
> +		return -ESRCH;
> +	length = scnprintf(tmpbuf, TMPBUFLEN, "%u\n",
> +			task_pid_vnr(task));
> +	put_task_struct(task);
> +	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
> +}
> +
> +static const struct file_operations pidnr_operations = {
> +	.read		= pidnr_read,
> +	.llseek		= generic_file_llseek,
> +};
> +
>  static ssize_t oom_adj_read(struct file *file, char __user *buf, size_t count,
>  			    loff_t *ppos)
>  {
> @@ -1096,7 +1118,6 @@ static const struct file_operations proc_oom_score_adj_operations = {
>  };
>  
>  #ifdef CONFIG_AUDITSYSCALL
> -#define TMPBUFLEN 21
>  static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
>  				  size_t count, loff_t *ppos)
>  {
> @@ -2642,6 +2663,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
>  #endif
>  	REG("environ",    S_IRUSR, proc_environ_operations),
> +	REG("pidnr",      S_IRUGO, pidnr_operations),
>  	INF("auxv",       S_IRUSR, proc_pid_auxv),
>  	ONE("status",     S_IRUGO, proc_pid_status),
>  	ONE("personality", S_IRUGO, proc_pid_personality),
> @@ -2999,6 +3021,7 @@ static const struct pid_entry tid_base_stuff[] = {
>  	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
>  	DIR("ns",	 S_IRUSR|S_IXUGO, proc_ns_dir_inode_operations, proc_ns_dir_operations),
>  	REG("environ",   S_IRUSR, proc_environ_operations),
> +	REG("pidnr",     S_IRUGO, pidnr_operations),
>  	INF("auxv",      S_IRUSR, proc_pid_auxv),
>  	ONE("status",    S_IRUGO, proc_pid_status),
>  	ONE("personality", S_IRUGO, proc_pid_personality),
