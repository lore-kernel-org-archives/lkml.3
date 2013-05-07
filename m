Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab3EGSOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 14:14:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3425 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab3EGSOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 14:14:02 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=tLUlnkoJZcZI9ocdGARlSQ==:17 a=c11ml42nfjYA:10 a=wom5GMh1gUkA:10 a=ZC6kDl2XazQA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=hBqU3vQJAAAA:8 a=u7_Bl1pM9YkA:10 a=VnNF1IyMAAAA:8 a=DfNHnWVPAAAA:8 a=PtDNVHqPAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=pP0QThq8oH7skTU8vlAA:9 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=lBRciGGoxdUA:10 a=wYE_KDyynt4A:10 a=tLUlnkoJZcZI9ocdGARlSQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 70.114.148.7
Date: Tue, 7 May 2013 13:15:04 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: raven@themaw.net, autofs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, sukadev@linux.vnet.ibm.com,
        serge.hallyn@canonical.com, ebiederm@xmission.com
Subject: Re: [PATCH 2/2] autofs4: translate pids to the right namespace for
 the daemon
Message-ID: <20130507181504.GB12315@austin.hallyn.com>
References: <20130507135446.GA6129@tucsk.piliscsaba.szeredi.hu>
 <20130507135654.GB6129@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507135654.GB6129@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> The PID and the TGID of the process tringgering the mount are sent to the
> daemon.  Currently the global pid values are sent (ones valid in the initial pid
> namespace) but this is wrong if the autofs daemon itself is not running in the
> initial pid namespace.
> 
> So send the pid values that are valid in the namespace of the autofs daemon.
> 
> The namespace to use is taken from the oz_pgrp pid pointer, which was set at
> mount time to the mounting process' pid namespace.
> 
> If the pid translation fails (the triggering process is in an unrelated pid
> namespace) then the automount fails with ENOENT.
> 
> Cc: Serge E. Hallyn <serue@us.ibm.com>

Makes sense.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

Thanks, Miklos.

> Cc: Eric Biederman <ebiederm@xmission.com>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/autofs4/waitq.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> --- a/fs/autofs4/waitq.c
> +++ b/fs/autofs4/waitq.c
> @@ -353,11 +353,23 @@ int autofs4_wait(struct autofs_sb_info *
>  	struct qstr qstr;
>  	char *name;
>  	int status, ret, type;
> +	pid_t pid;
> +	pid_t tgid;
>  
>  	/* In catatonic mode, we don't wait for nobody */
>  	if (sbi->catatonic)
>  		return -ENOENT;
>  
> +	/*
> +	 * Try translating pids to the namespace of the daemon.
> +	 *
> +	 * Zero means failure: we are in an unrelated pid namespace.
> +	 */
> +	pid = task_pid_nr_ns(current, ns_of_pid(sbi->oz_pgrp));
> +	tgid = task_tgid_nr_ns(current, ns_of_pid(sbi->oz_pgrp));
> +	if (pid == 0 || tgid == 0)
> +		return -ENOENT;
> +
>  	if (!dentry->d_inode) {
>  		/*
>  		 * A wait for a negative dentry is invalid for certain
> @@ -423,8 +435,8 @@ int autofs4_wait(struct autofs_sb_info *
>  		wq->ino = autofs4_get_ino(sbi);
>  		wq->uid = current_uid();
>  		wq->gid = current_gid();
> -		wq->pid = current->pid;
> -		wq->tgid = current->tgid;
> +		wq->pid = pid;
> +		wq->tgid = tgid;
>  		wq->status = -EINTR; /* Status return if interrupted */
>  		wq->wait_ctr = 2;
>  		mutex_unlock(&sbi->wq_mutex);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
