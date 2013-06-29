Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab3F2OYc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 10:24:32 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56636 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab3F2OY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 10:24:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sami Kerola <kerolasa@iki.fi>
Cc: linux-kernel@vger.kernel.org, Karel Zak <kzak@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>
References: <1372511678-2726-1-git-send-email-kerolasa@iki.fi>
Date: Sat, 29 Jun 2013 07:23:51 -0700
In-Reply-To: <1372511678-2726-1-git-send-email-kerolasa@iki.fi> (Sami Kerola's
	message of "Sat, 29 Jun 2013 14:14:38 +0100")
Message-ID: <8761wxxafc.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18BBROoNjIg8QzmIimBn7GScbizoniN9oY=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0016]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sami Kerola <kerolasa@iki.fi>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] proc: make high precision system boot time available
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

The pach does not solve the problem described.

Sami Kerola <kerolasa@iki.fi> writes:

> The kernel does not expose precise start time anywhere.  Precision of
> sysinfo() is limited to a second.  The /proc/uptime has precision of two
> decimals.  Neither are good enough when klog messages are displayed with
> a log time stamp that is converted to human understandable format, such
> as ISO-8601.  The problem is that imprecise knowledge about uptime will
> lead human readable klog time stamps to wiggle in user commands, such as
> dmesg(1).

Using an adjusted idea like boottime will also cause wiggle whenever the
clock is set, or we have a leap second.  So I can't see this solving
anything.

> Additionally the current dmesg and journalctl(1) are disagreeing when
> kernel events occurred.  The dmesg is using sysinfo(2) to determine boot
> time, while journalctl is using systemd(1)'s early clock_gettime(2) call.
> Here is demonstration how different baseline effects on a random laptop.
>
> $ dmesg --ctime | grep 'Initializing cgroup subsys cpuset'
> [Fri Jun 28 07:40:12 2013] Initializing cgroup subsys cpuset
> $ journalctl -b | grep 'Initializing cgroup subsys cpuset'
> Jun 28 07:40:21 kerolasa-home kernel: Initializing cgroup subsys cpuset

Here you are show nearly 10 seconds of difference in time.  Subsecond
accuracy is not likely to help you here.

> To solve the wiggling problem, and to have a boot time coming from source
> which everyone can agree is 'good enough' estimation of system start up,
> the kernel needs to tell the boot time as precisily as it can.

Quite frankly none of this makes a lick of sense to me.  Your deep
complaint is a human pretty printer is not matching the results of
another human pretty printer.

I fail to see how the limitations of pretty printers justifies
maintiaing yet another kernel interface.  Especially for something so
dubious and fluctuating as the time we think the wall clock read when we
started up.

I can't imagine this interface doing anything except generating more
user complaints.  A made up number with more digits after the decimal
point remains a made up number.

Eric


> CC: Karel Zak <kzak@redhat.com>
> CC: Lennart Poettering <lennart@poettering.net>
> CC: Kay Sievers <kay@vrfy.org>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> References: http://www.spinics.net/lists/util-linux-ng/msg08092.html
> Measurement: https://plus.google.com/u/0/117341944650953092607/posts/SHy5qu1HpSU
> Signed-off-by: Sami Kerola <kerolasa@iki.fi>
> ---
>  Documentation/ABI/testing/procfs-boottime | 15 ++++++++++++++
>  fs/proc/Makefile                          |  1 +
>  fs/proc/boottime.c                        | 33 +++++++++++++++++++++++++++++++
>  3 files changed, 49 insertions(+)
>  create mode 100644 Documentation/ABI/testing/procfs-boottime
>  create mode 100644 fs/proc/boottime.c
>
> diff --git a/Documentation/ABI/testing/procfs-boottime b/Documentation/ABI/testing/procfs-boottime
> new file mode 100644
> index 0000000..d5bf8f2
> --- /dev/null
> +++ b/Documentation/ABI/testing/procfs-boottime
> @@ -0,0 +1,15 @@
> +What:		/proc/boottime
> +Date:		June 2013
> +KernelVersion:	3.11
> +Contact:	Sami Kerola <kerolasa@iki.fi>
> +
> +Description:	Show high precision time stamp when linux kernel thinks
> +		the system start up.  The value is suitable to be used as
> +		struct timespec.
> +
> +		struct timespec ts;
> +		hpu = fopen("/sys/kernel/boottime", "r");
> +		fscanf(hpu, "%ld.%ld", &ts.tv_sec, &ts.tv_nsec);
> +
> +Users:		At least utilities that print klog entries in
> +		times stamps converted for humans.
> diff --git a/fs/proc/Makefile b/fs/proc/Makefile
> index ab30716..5a7ec5a 100644
> --- a/fs/proc/Makefile
> +++ b/fs/proc/Makefile
> @@ -10,6 +10,7 @@ proc-$(CONFIG_MMU)	:= task_mmu.o
>  proc-y       += inode.o root.o base.o generic.o array.o \
>  		fd.o
>  proc-$(CONFIG_TTY)      += proc_tty.o
> +proc-y	+= boottime.o
>  proc-y	+= cmdline.o
>  proc-y	+= consoles.o
>  proc-y	+= cpuinfo.o
> diff --git a/fs/proc/boottime.c b/fs/proc/boottime.c
> new file mode 100644
> index 0000000..f56c624
> --- /dev/null
> +++ b/fs/proc/boottime.c
> @@ -0,0 +1,33 @@
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/proc_fs.h>
> +#include <linux/seq_file.h>
> +#include <linux/time.h>
> +
> +static int boottime_proc_show(struct seq_file *m, void *v)
> +{
> +	struct timespec ts;
> +	getboottime(&ts);
> +	seq_printf(m, "%ld.%ld\n", ts.tv_sec, ts.tv_nsec);
> +	return 0;
> +}
> +
> +static int boottime_proc_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, boottime_proc_show, NULL);
> +}
> +
> +static const struct file_operations boottime_proc_fops = {
> +	.open = boottime_proc_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +};
> +
> +static int __init proc_boottime_init(void)
> +{
> +	proc_create("boottime", 0, NULL, &boottime_proc_fops);
> +	return 0;
> +}
> +
> +module_init(proc_boottime_init);
