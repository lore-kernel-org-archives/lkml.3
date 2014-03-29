Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaC2Hc1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 03:32:27 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:44276 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaC2HcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 03:32:13 -0400
MIME-Version: 1.0
In-Reply-To: <87ha6inp7g.fsf@tassilo.jf.intel.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396014469-5937-8-git-send-email-jovi.zhangwei@gmail.com>
	<87ha6inp7g.fsf@tassilo.jf.intel.com>
Date: Sat, 29 Mar 2014 15:32:12 +0800
Message-ID: <CAGdX0WFMXejHjhy5sVkVuQvNwE8MevEuAsDbkAZCb35mJj07zQ@mail.gmail.com>
Subject: Re: [PATCH 07/28] ktap: add runtime/ktap.[c|h]
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Sat, Mar 29, 2014 at 2:38 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Jovi Zhangwei <jovi.zhangwei@gmail.com> writes:
>
> Quick review of the file.
>
>> +#include <linux/version.h>
>> +#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 1, 0)
>> +#error "Currently ktap don't support kernel older than 3.1"
>> +#endif
>> +
>> +#if !CONFIG_EVENT_TRACING
>> +#error "Please enable CONFIG_EVENT_TRACING before compile ktap"
>> +#endif
>> +
>> +#if !CONFIG_PERF_EVENTS
>> +#error "Please enable CONFIG_PERF_EVENTS before compile ktap"
>> +#endif
>
> This should be all in Kconfig
>
Will do.

>> +/* common helper function */
>> +long gettimeofday_ns(void)
>> +{
>> +     struct timespec now;
>> +
>> +     getnstimeofday(&now);
>> +     return now.tv_sec * NSEC_PER_SEC + now.tv_nsec;
>> +}
>
> This is ktime_get()
>
> Or more likely you want something like trace_clock(), otherwise
> you may have problems on systems not using TSC.
>
I now find that function would not be safe to called from probe context,
because it have seq lock in it, I will add a TODO tag in there.

(It seems Systemtap fix this issue by introduce its own time keeping logic)

Like as you said, we may also need other cheap timestamp for tracing,
might trace_clock suit my need.

>> +
>> +static int load_trunk(ktap_option_t *parm, unsigned long **buff)
>> +{
>> +     int ret;
>> +     unsigned long *vmstart;
>> +
>> +     vmstart = vmalloc(parm->trunk_len);
>> +     if (!vmstart)
>> +             return -ENOMEM;
>> +
>> +     ret = copy_from_user(vmstart, (void __user *)parm->trunk,
>> +                          parm->trunk_len);
>
> Needs unsigned length check if supplied from user space.
>
>> +     if (ret < 0) {
>> +             vfree(vmstart);
>> +             return -EFAULT;
>> +     }
>> +
>> +     *buff = vmstart;
>> +     return 0;
>> +}
>> +
>> +static struct dentry *kp_dir_dentry;
>
> What lock protects that?
>
This dentry would not change after insmod ktapvm.ko, so don't need any lock.

>> +static long ktap_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>> +{
>> +     ktap_option_t parm;
>> +     int ret;
>> +
>> +     switch (cmd) {
>> +     case KTAP_CMD_IOC_VERSION:
>> +             print_version();
>
> This seems odd. Should return the version instead?
>
Yes, deleted.
>
>> +             return 0;
>> +     case KTAP_CMD_IOC_RUN:
>> +             /*
>> +              * must be root to run ktap script (at least for now)
>> +              *
>> +              * TODO: check perf_paranoid sysctl and allow non-root user
>> +              * to use ktap for tracing process(like uprobe) ?
>
> This would need ensuring first that there is no possible way to crash
> the kernel. Probably very hard.
>
I agree it's hard to let non-root user to use these dynamic tracing tool,
I will remove this comment to avoid confusion after we find a solution.

>> +              */
>> +             if (!capable(CAP_SYS_ADMIN))
>> +                     return -EACCES;
>> +
>> +             ret = copy_from_user(&parm, (void __user *)arg,
>> +                                  sizeof(ktap_option_t));
>> +             if (ret < 0)
>> +                     return -EFAULT;
>
> The check is wrong, it should be != 0
>
Fixed.

>> +struct syscall_metadata **syscalls_metadata;
>> +
>> +/*TODO: kill this function in future */
>> +static int __init init_dummy_kernel_functions(void)
>> +{
>> +     unsigned long *addr;
>> +
>> +     /*
>> +      * ktap need symbol ftrace_profile_set_filter to set event filter,
>> +      * export it in future.
>
> Obviously you need to fix that. Just export the symbols.
>
Yeah, will do after kernel community decide to merge ktap. :)

>> +
>> +extern struct syscall_metadata **syscalls_metadata;
>> +
>> +/* get from kernel/trace/trace.h */
>
> Use that version instead.
>
Same as above.

>> +static __always_inline int trace_get_context_bit(void)
>> +{
>> +     int bit;
>> +
>> +     if (in_interrupt()) {
>> +             if (in_nmi())
>> +                     bit = 0;
>> +             else if (in_irq())
>> +                     bit = 1;
>> +             else
>> +                     bit = 2;
>> +     } else
>> +             bit = 3;
>> +
>> +     return bit;
>> +}
>
>

Thanks for your review.

Jovi
