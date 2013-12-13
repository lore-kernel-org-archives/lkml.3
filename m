Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab3LMO22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:28:28 -0500
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:60911 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753118Ab3LMO21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:28:27 -0500
X-TM-IMSS-Message-ID: <ad29b93e001aa16a@nsa.gov>
Message-ID: <52AB15C0.7090701@tycho.nsa.gov>
Date: Fri, 13 Dec 2013 09:12:16 -0500
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: William Roberts <bill.c.roberts@gmail.com>, linux-audit@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, rgb@redhat.com,
        viro@zeniv.linux.org.uk
CC: William Roberts <wroberts@tresys.com>
Subject: Re: [PATCH 1/3] mm: Create utility functions for accessing a tasks
 commandline value
References: <1386018639-18916-1-git-send-email-wroberts@tresys.com> <1386018639-18916-2-git-send-email-wroberts@tresys.com>
In-Reply-To: <1386018639-18916-2-git-send-email-wroberts@tresys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 04:10 PM, William Roberts wrote:
> Add two new functions to mm.h:
> * copy_cmdline()
> * get_cmdline_length()
> 
> Signed-off-by: William Roberts <wroberts@tresys.com>
> ---
>  include/linux/mm.h |    7 +++++++
>  mm/util.c          |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+)
> 
> index f7bc209..c8cad32 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -410,6 +411,53 @@ unsigned long vm_commit_limit(void)
>  		* sysctl_overcommit_ratio / 100) + total_swap_pages;
>  }
>  
> +/**
> + * copy_cmdline - Copy's the tasks commandline value to a buffer

spelling: Copies, task's, command-line or command line

> + * @task: The task whose command line to copy

is to be copied?

> + * @mm: The mm struct refering to task with proper semaphores held

referring

> + * @buf: The buffer to copy the value into

> + * @buflen: The length og the buffer. It trucates the value to

of, truncates

> + *           buflen.
> + * @return: The number of chars copied.
> + */
> +int copy_cmdline(struct task_struct *task, struct mm_struct *mm,
> +		 char *buf, unsigned int buflen)
> +{
> +	int res = 0;
> +	unsigned int len;
> +
> +	if (!task || !mm || !buf)
> +		return -1;

Typically these kinds of tests are frowned upon in the kernel unless
there is a legal usage where NULL is valid.  Otherwise you may just be
covering up a bug.

Also, why not just get_task_mm(task) within the function rather than
pass it in by the caller?

> +
> +	res = access_process_vm(task, mm->arg_start, buf, buflen, 0);

Unsigned int buflen passed as int len argument without a range check?
Note that in the proc_pid_cmdline() code, they first cap it at PAGE_SIZE
before passing it.

The closer you can keep your code to the original proc_pid_cmdline()
code, the better (less chance for new bugs to be introduced).

> +	if (res <= 0)
> +		return 0;
> +
> +	if (res > buflen)
> +		res = buflen;

Is this a possible condition?  Under what circumstances?

> +	/*
> +	 * If the nul at the end of args had been overwritten, then
> +	 * assume application is using setproctitle(3).
> +	 */
> +	if (buf[res-1] != '\0') {

Lost the len < PAGE_SIZE check from proc_pid_cmdline() here, and that
isn't the same as the check above.

> +		/* Nul between start and end of vm space?
> +		   If so then truncate */

Not sure where these comments are coming from.  Isn't the issue that
lack of NUL at the end of args indicates that the cmdline extends
further into the environ and thus they need to copy in the rest?

> +		len = strnlen(buf, res);
> +		if (len < res) {
> +			res = len;
> +		} else {
> +			/* No nul, truncate buflen if to big */

It isn't truncating buflen but rather copying the remainder of the
cmdline from the environ, right?

> +			len = mm->env_end - mm->env_start;
> +			if (len > buflen - res)
> +				len = buflen - res;
> +			/* Copy any remaining data */
> +			res += access_process_vm(task, mm->env_start, buf+res,
> +						 len, 0);
> +			res = strnlen(buf, res);
> +		}
> +	}
> +	return res;
> +}

I think you are better off just copying proc_pid_cmdline() exactly as is
into a common helper function and then reusing it for audit.  Far less
work, and far less potential for mistakes.

>  
>  /* Tracepoints definitions. */
>  EXPORT_TRACEPOINT_SYMBOL(kmalloc);
> 

