Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3F2Ux2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 16:53:28 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43802 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab3F2Ux1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 16:53:27 -0400
MIME-Version: 1.0
Reply-To: kerolasa@gmail.com
In-Reply-To: <8761wxxafc.fsf@xmission.com>
References: <1372511678-2726-1-git-send-email-kerolasa@iki.fi>
	<8761wxxafc.fsf@xmission.com>
Date: Sat, 29 Jun 2013 21:53:26 +0100
X-Google-Sender-Auth: Tysu-TpUxgvC-ab6lACUi51h7-k
Message-ID: <CAG27Bk1SZ9txdKrH4DMKZtb=GuuxPZg_12Gi5E3i0hUYQd+WVg@mail.gmail.com>
Subject: Re: [PATCH] proc: make high precision system boot time available
From: Sami Kerola <kerolasa@iki.fi>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Karel Zak <kzak@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 June 2013 15:23, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> The pach does not solve the problem described.

Which might be true, and I am open to better proposals.

> Sami Kerola <kerolasa@iki.fi> writes:
>
>> The kernel does not expose precise start time anywhere.  Precision of
>> sysinfo() is limited to a second.  The /proc/uptime has precision of two
>> decimals.  Neither are good enough when klog messages are displayed with
>> a log time stamp that is converted to human understandable format, such
>> as ISO-8601.  The problem is that imprecise knowledge about uptime will
>> lead human readable klog time stamps to wiggle in user commands, such as
>> dmesg(1).
>
> Using an adjusted idea like boottime will also cause wiggle whenever the
> clock is set, or we have a leap second.  So I can't see this solving
> anything.

I must disagree. Unless a boot time expressed with at least the same
accuracy as the klog messages the human readable time stamps can be
rounded to differently making for example dmesg output to be unstable.

diff -q <(dmesg --ctime) <(sleep 0.5 ; dmesg --ctime)

>> Additionally the current dmesg and journalctl(1) are disagreeing when
>> kernel events occurred.  The dmesg is using sysinfo(2) to determine boot
>> time, while journalctl is using systemd(1)'s early clock_gettime(2) call.
>> Here is demonstration how different baseline effects on a random laptop.
>>
>> $ dmesg --ctime | grep 'Initializing cgroup subsys cpuset'
>> [Fri Jun 28 07:40:12 2013] Initializing cgroup subsys cpuset
>> $ journalctl -b | grep 'Initializing cgroup subsys cpuset'
>> Jun 28 07:40:21 kerolasa-home kernel: Initializing cgroup subsys cpuset
>
> Here you are show nearly 10 seconds of difference in time.  Subsecond
> accuracy is not likely to help you here.

That is exactly the point, systemd is using different logic to
determine system start time. I am not sure why that was done, but my
guess is that all existing ways to determine boot time lead to
rounding errors so a private estimation was invented.

Of course i could align dmesg with systemd, by reading boot time from
systemd's dbus, but I believe after that uptime(1), top(1), [and so
on], would disagree with these two commands. Essentially it seems to
be either a) wiggling, or b) even more random estimation of boot time
from which I need to choose unless there is a new interface.

>> To solve the wiggling problem, and to have a boot time coming from source
>> which everyone can agree is 'good enough' estimation of system start up,
>> the kernel needs to tell the boot time as precisily as it can.
>
> Quite frankly none of this makes a lick of sense to me.  Your deep
> complaint is a human pretty printer is not matching the results of
> another human pretty printer.
>
> I fail to see how the limitations of pretty printers justifies
> maintiaing yet another kernel interface.  Especially for something so
> dubious and fluctuating as the time we think the wall clock read when we
> started up.

Correct. This is at the end user space issue. As a system
administrator I cannot understand when dmesg events happen, when they
are expressed in their 'native' format. But if I use human readable
time stamps output is unstable, and different tools give different
answers. That seems flawed as well.

BTW having a way to measure effect of suspend/resume could lead to a
way to fix time time distortion.

> I can't imagine this interface doing anything except generating more
> user complaints.  A made up number with more digits after the decimal
> point remains a made up number.

I am not claiming the /proc/boottime would fix every considerable
issue. What it tries to address is 1) stable high accuracy boot time
source, which 2) can be agreed in between utilities to be the
authoritative boot time source. Maybe the leap seconds will break
something, but I consider that better problem than current situation.

Perhaps there is better alternative to fix user space programs.
Unfortunately I do not have either knowledge, or imagination, to come
up with any. Fix hints, ideas, and other proposal are most welcome.


>> CC: Karel Zak <kzak@redhat.com>
>> CC: Lennart Poettering <lennart@poettering.net>
>> CC: Kay Sievers <kay@vrfy.org>
>> CC: Eric W. Biederman <ebiederm@xmission.com>
>> References: http://www.spinics.net/lists/util-linux-ng/msg08092.html
>> Measurement: https://plus.google.com/u/0/117341944650953092607/posts/SHy5qu1HpSU
>> Signed-off-by: Sami Kerola <kerolasa@iki.fi>
>> ---
>>  Documentation/ABI/testing/procfs-boottime | 15 ++++++++++++++
>>  fs/proc/Makefile                          |  1 +
>>  fs/proc/boottime.c                        | 33 +++++++++++++++++++++++++++++++
>>  3 files changed, 49 insertions(+)
>>  create mode 100644 Documentation/ABI/testing/procfs-boottime
>>  create mode 100644 fs/proc/boottime.c
>>
>> diff --git a/Documentation/ABI/testing/procfs-boottime b/Documentation/ABI/testing/procfs-boottime
>> new file mode 100644
>> index 0000000..d5bf8f2
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/procfs-boottime
>> @@ -0,0 +1,15 @@
>> +What:                /proc/boottime
>> +Date:                June 2013
>> +KernelVersion:       3.11
>> +Contact:     Sami Kerola <kerolasa@iki.fi>
>> +
>> +Description: Show high precision time stamp when linux kernel thinks
>> +             the system start up.  The value is suitable to be used as
>> +             struct timespec.
>> +
>> +             struct timespec ts;
>> +             hpu = fopen("/sys/kernel/boottime", "r");
>> +             fscanf(hpu, "%ld.%ld", &ts.tv_sec, &ts.tv_nsec);
>> +
>> +Users:               At least utilities that print klog entries in
>> +             times stamps converted for humans.
>> diff --git a/fs/proc/Makefile b/fs/proc/Makefile
>> index ab30716..5a7ec5a 100644
>> --- a/fs/proc/Makefile
>> +++ b/fs/proc/Makefile
>> @@ -10,6 +10,7 @@ proc-$(CONFIG_MMU)  := task_mmu.o
>>  proc-y       += inode.o root.o base.o generic.o array.o \
>>               fd.o
>>  proc-$(CONFIG_TTY)      += proc_tty.o
>> +proc-y       += boottime.o
>>  proc-y       += cmdline.o
>>  proc-y       += consoles.o
>>  proc-y       += cpuinfo.o
>> diff --git a/fs/proc/boottime.c b/fs/proc/boottime.c
>> new file mode 100644
>> index 0000000..f56c624
>> --- /dev/null
>> +++ b/fs/proc/boottime.c
>> @@ -0,0 +1,33 @@
>> +#include <linux/fs.h>
>> +#include <linux/init.h>
>> +#include <linux/proc_fs.h>
>> +#include <linux/seq_file.h>
>> +#include <linux/time.h>
>> +
>> +static int boottime_proc_show(struct seq_file *m, void *v)
>> +{
>> +     struct timespec ts;
>> +     getboottime(&ts);
>> +     seq_printf(m, "%ld.%ld\n", ts.tv_sec, ts.tv_nsec);
>> +     return 0;
>> +}
>> +
>> +static int boottime_proc_open(struct inode *inode, struct file *file)
>> +{
>> +     return single_open(file, boottime_proc_show, NULL);
>> +}
>> +
>> +static const struct file_operations boottime_proc_fops = {
>> +     .open = boottime_proc_open,
>> +     .read = seq_read,
>> +     .llseek = seq_lseek,
>> +     .release = single_release,
>> +};
>> +
>> +static int __init proc_boottime_init(void)
>> +{
>> +     proc_create("boottime", 0, NULL, &boottime_proc_fops);
>> +     return 0;
>> +}
>> +
>> +module_init(proc_boottime_init);



--
Sami Kerola
http://www.iki.fi/kerolasa/
