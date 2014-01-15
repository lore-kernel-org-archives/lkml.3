Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaAOORf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:17:35 -0500
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:56410 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752156AbaAOORe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:17:34 -0500
X-TM-IMSS-Message-ID: <125a4c3c0000bc48@nsa.gov>
Message-ID: <52D69844.9000200@tycho.nsa.gov>
Date: Wed, 15 Jan 2014 09:16:36 -0500
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: William Roberts <bill.c.roberts@gmail.com>, linux-audit@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, rgb@redhat.com,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org
CC: William Roberts <wroberts@tresys.com>
Subject: Re: [RFC][PATCH v2 2/3] proc: Update get proc_pid_cmdline() to use
 mm.h helpers
References: <1389632555-7039-1-git-send-email-wroberts@tresys.com> <1389632555-7039-2-git-send-email-wroberts@tresys.com>
In-Reply-To: <1389632555-7039-2-git-send-email-wroberts@tresys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 12:02 PM, William Roberts wrote:
> Re-factor proc_pid_cmdline() to use get_cmdline() helper
> from mm.h.
> 
> Signed-off-by: William Roberts <wroberts@tresys.com>

Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>

> ---
>  fs/proc/base.c |   36 ++----------------------------------
>  1 file changed, 2 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 03c8d74..cfd178d 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -200,41 +200,9 @@ static int proc_root_link(struct dentry *dentry, struct path *path)
>  	return result;
>  }
>  
> -static int proc_pid_cmdline(struct task_struct *task, char * buffer)
> +static int proc_pid_cmdline(struct task_struct *task, char *buffer)
>  {
> -	int res = 0;
> -	unsigned int len;
> -	struct mm_struct *mm = get_task_mm(task);
> -	if (!mm)
> -		goto out;
> -	if (!mm->arg_end)
> -		goto out_mm;	/* Shh! No looking before we're done */
> -
> - 	len = mm->arg_end - mm->arg_start;
> - 
> -	if (len > PAGE_SIZE)
> -		len = PAGE_SIZE;
> - 
> -	res = access_process_vm(task, mm->arg_start, buffer, len, 0);
> -
> -	// If the nul at the end of args has been overwritten, then
> -	// assume application is using setproctitle(3).
> -	if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
> -		len = strnlen(buffer, res);
> -		if (len < res) {
> -		    res = len;
> -		} else {
> -			len = mm->env_end - mm->env_start;
> -			if (len > PAGE_SIZE - res)
> -				len = PAGE_SIZE - res;
> -			res += access_process_vm(task, mm->env_start, buffer+res, len, 0);
> -			res = strnlen(buffer, res);
> -		}
> -	}
> -out_mm:
> -	mmput(mm);
> -out:
> -	return res;
> +	return get_cmdline(task, buffer, PAGE_SIZE);
>  }
>  
>  static int proc_pid_auxv(struct task_struct *task, char *buffer)
> 

