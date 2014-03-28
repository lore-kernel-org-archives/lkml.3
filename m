Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaC1Skf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:40:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:55548 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbaC1Skd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 14:40:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,752,1389772800"; 
   d="scan'208";a="509175785"
From: Andi Kleen <andi@firstfloor.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@redhat.org>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 07/28] ktap: add runtime/ktap.[c|h]
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396014469-5937-8-git-send-email-jovi.zhangwei@gmail.com>
Date: Fri, 28 Mar 2014 11:38:27 -0700
In-Reply-To: <1396014469-5937-8-git-send-email-jovi.zhangwei@gmail.com> (Jovi
	Zhangwei's message of "Fri, 28 Mar 2014 09:47:28 -0400")
Message-ID: <87ha6inp7g.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jovi Zhangwei <jovi.zhangwei@gmail.com> writes:

Quick review of the file.

> +#include <linux/version.h>
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 1, 0)
> +#error "Currently ktap don't support kernel older than 3.1"
> +#endif
> +
> +#if !CONFIG_EVENT_TRACING
> +#error "Please enable CONFIG_EVENT_TRACING before compile ktap"
> +#endif
> +
> +#if !CONFIG_PERF_EVENTS
> +#error "Please enable CONFIG_PERF_EVENTS before compile ktap"
> +#endif

This should be all in Kconfig

> +/* common helper function */
> +long gettimeofday_ns(void)
> +{
> +	struct timespec now;
> +
> +	getnstimeofday(&now);
> +	return now.tv_sec * NSEC_PER_SEC + now.tv_nsec;
> +}

This is ktime_get()

Or more likely you want something like trace_clock(), otherwise
you may have problems on systems not using TSC.

> +
> +static int load_trunk(ktap_option_t *parm, unsigned long **buff)
> +{
> +	int ret;
> +	unsigned long *vmstart;
> +
> +	vmstart = vmalloc(parm->trunk_len);
> +	if (!vmstart)
> +		return -ENOMEM;
> +
> +	ret = copy_from_user(vmstart, (void __user *)parm->trunk,
> +			     parm->trunk_len);

Needs unsigned length check if supplied from user space.

> +	if (ret < 0) {
> +		vfree(vmstart);
> +		return -EFAULT;
> +	}
> +
> +	*buff = vmstart;
> +	return 0;
> +}
> +
> +static struct dentry *kp_dir_dentry;

What lock protects that?

> +static long ktap_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	ktap_option_t parm;
> +	int ret;
> +
> +	switch (cmd) {
> +	case KTAP_CMD_IOC_VERSION:
> +		print_version();

This seems odd. Should return the version instead?


> +		return 0;
> +	case KTAP_CMD_IOC_RUN:
> +		/*
> +		 * must be root to run ktap script (at least for now)
> +		 *
> +		 * TODO: check perf_paranoid sysctl and allow non-root user
> +		 * to use ktap for tracing process(like uprobe) ?

This would need ensuring first that there is no possible way to crash
the kernel. Probably very hard.

> +		 */
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EACCES;
> +
> +		ret = copy_from_user(&parm, (void __user *)arg,
> +				     sizeof(ktap_option_t));
> +		if (ret < 0)
> +			return -EFAULT;

The check is wrong, it should be != 0

> +struct syscall_metadata **syscalls_metadata;
> +
> +/*TODO: kill this function in future */
> +static int __init init_dummy_kernel_functions(void)
> +{
> +	unsigned long *addr;
> +
> +	/*
> +	 * ktap need symbol ftrace_profile_set_filter to set event filter, 
> +	 * export it in future. 

Obviously you need to fix that. Just export the symbols.

> +
> +extern struct syscall_metadata **syscalls_metadata;
> +
> +/* get from kernel/trace/trace.h */

Use that version instead.

> +static __always_inline int trace_get_context_bit(void)
> +{
> +	int bit;
> +
> +	if (in_interrupt()) {
> +		if (in_nmi())
> +			bit = 0;
> +		else if (in_irq())
> +			bit = 1;
> +		else
> +			bit = 2;
> +	} else
> +		bit = 3;
> +
> +	return bit;
> +}


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
