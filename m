Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab3ASUsh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 15:48:37 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59431 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3ASUsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 15:48:35 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUWKCbaL=oAwBk0vcPtLrGmvsqPdpXdYAqPZVKzA9Y_iDw@mail.gmail.com>
References: <CA+icZUWKCbaL=oAwBk0vcPtLrGmvsqPdpXdYAqPZVKzA9Y_iDw@mail.gmail.com>
Date: Sat, 19 Jan 2013 21:48:33 +0100
Message-ID: <CA+icZUX4JC9R=eDhd=sM_jGp_TmFZ3Tf-b8wazRL91LAitLC1g@mail.gmail.com>
Subject: Re: [next-20130118] Analyzing a call-trace reproducible with
 pm_test/freezer [ X86|RCU|TTY|EXT4FS|JBD2|PM related? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: linux-next <linux-next@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        linux-serial@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, x86@kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ilya Zykov <ilya@ilyx.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, Jan Kara <jack@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 7:28 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> Hi,
>
> I am still stepping in the dark how track this problem down.
> If you have useful (debug) help, you are welcome.
>
> Regards,
> - Sedat -
>
> ##### ANALYZING CALL-TRACES SEEN IN LINUX-NEXT-20130118 #####
>
> ##### INTRO
>
> ### MY LINUX-SYSTEM
>
> I am running here Ubuntu/precise AMD64 in a WUBI environment.
> The system was formatted with EXT4-FS.
>
> ### MY LINUX-KERNEL
>
> My own built Linux-Next (next-20130118) kernel includes some additional patches,
> especially a TTY-NEXT fix from Ilya Zykov.
>
> See also attached kernel-config file, dmesg and lspci outputs.
>
> ### SOME USEFUL KERNEL DEBUG OPTIONS
>
> CONFIG_PM_DEBUG=y
> CONFIG_EXT4_DEBUG=y
> CONFIG_JBD2_DEBUG=y
>
>
> ##### [A] ANALYZING LAST REBOOT
>
> ### [A.1] MESSAGES
>
> # Messages #1: DBUS related?
> nm-dispatcher.action: Could not get the system bus. Make sure the
> message bus daemon is running! Message: Failed to connect to socket
> /var/run/dbus/system_bus_socket: No such file or directory
>
> # Messages #2: RCU_SCHED related?
> INFO: rcu_sched detected stalls on CPUs/tasks: { 2 3} (detected by 1,
> t=15004 jiffies, g=70928, c=70927, q=15)
> INFO: task kworker/0:1:37 blocked for more than 120 seconds. "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>
> ### [A.2] ANALYZING DBUS PROBLEM
>
> # ll /var/run/dbus/system_bus_socket*
> srwxrwxrwx 1 root root 0 Jan 19 17:08 /var/run/dbus/system_bus_socket=
>
> # ll /var/run/dbus/
> insgesamt 4
> drwxr-xr-x  2 messagebus messagebus  80 Jan 19 17:08 ./
> drwxr-xr-x 22 root       root       800 Jan 19 17:11 ../
> -rw-r--r--  1 root       root         4 Jan 19 17:08 pid
> srwxrwxrwx  1 root       root         0 Jan 19 17:08 system_bus_socket=
>
> # cat /var/run/dbus/pid
> 862
>
> # ps axu | grep -v grep | grep 862
> 102        862  0.2  0.0  25492  2332 ?        Ss   17:08   0:01
> dbus-daemon --system --fork --activation=upstart
>
> # pidof dbus-daemon
> 1921 862
>
> ### [A.3] ANALYZING RCU_SCHED PROBLEM
>
> # cat /proc/sys/kernel/hung_task_timeout_secs
> 120
>
>
> ##### [B] TESTCASE DESCRIPTION
>
> ### [B.1] TESTCASE #1: Do a "normal" suspend and resume
>
> Select "suspend" (DE: "Bereitschaft") from system's menue within Ubuntu/unity.
>
> ### [B.2] TESTCASE #2: Run pm_test/freezer (PREREQ: CONFIG_PM_DEBUG=y)
>
> HELP: <http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=Documentation/power/basic-pm-debugging.txt#l184>
>
> # cat /sys/power/pm_test
> [none] core processors platform devices freezer
>
> # echo "freezer" > /sys/power/pm_test
> # cat /sys/power/pm_test
> none core processors platform devices [freezer]
>
> # echo mem > /sys/power/state && sleep 1 <--- LOOP until you see a call-trace
>
> ### [B.3] TESTCASE #3: Change "hung_task_timeout_secs" before running
> pm_test/freezer
>
> # cat /proc/sys/kernel/hung_task_timeout_secs
> 120
>
> # echo 0 > /proc/sys/kernel/hung_task_timeout_secs
> # cat /proc/sys/kernel/hung_task_timeout_secs
> 0
>
>
> ##### [C] THE CALL-TRACE
>
> ### [C.1] TRY TO FORCE THE CALL-TRACE
>
> The call-trace is not ***always*** reproducible!
> Even with "0" for "hung_task_timeout_secs" it is seen (see testcase #3)!
>
> The call-trace ***always*** happened when the output "-su: echo: write
> error: Device or resource busy" was seen!
> Unsure, how to intpret it!
> What means "-su"?
> Write-error to which device?
> Which resource is busy?
>
> # LC_ALL=C echo mem > /sys/power/state && sleep 1
> -su: echo: write error: Device or resource busy <--- THIS OUTPUT!
>
> [ /var/log/kern.log ]
>
> n 19 18:00:02 fambox kernel: [ 3065.559184] PM: Syncing filesystems ... done.
> Jan 19 18:00:02 fambox kernel: [ 3065.768458] PM: Preparing system for mem sleep
> Jan 19 18:00:14 fambox kernel: [ 3072.733178] Freezing user space
> processes ... (elapsed 0.01 seconds) done.
> Jan 19 18:00:14 fambox kernel: [ 3072.749284] Freezing remaining
> freezable tasks ... (elapsed 0.01 seconds) done.
> Jan 19 18:00:14 fambox kernel: [ 3072.765274] suspend debug: Waiting
> for 5 seconds.
> Jan 19 18:00:14 fambox kernel: [ 3077.722222] PM: Finishing wakeup.
> Jan 19 18:00:14 fambox kernel: [ 3077.722224] Restarting tasks ... done.
> Jan 19 18:00:14 fambox kernel: [ 3077.726719] video LNXVIDEO:00:
> Restoring backlight state
> Jan 19 18:00:18 fambox kernel: [ 3081.596512] PM: Syncing filesystems ... done.
> Jan 19 18:00:18 fambox kernel: [ 3081.750235] PM: Preparing system for mem sleep
> Jan 19 18:00:45 fambox kernel: [ 3087.738204] Freezing user space
> processes ... (elapsed 0.04 seconds) done.
> Jan 19 18:00:45 fambox kernel: [ 3087.786660] Freezing remaining
> freezable tasks ...
> Jan 19 18:00:45 fambox kernel: [ 3107.788540] Freezing of tasks failed
> after 20.01 seconds (1 tasks refusing to freeze, wq_busy=0):
> Jan 19 18:00:45 fambox kernel: [ 3107.788664] jbd2/loop0-8    D
> ffffffff8180d780     0   299      2 0x00000000
> Jan 19 18:00:45 fambox kernel: [ 3107.788673]  ffff88011822db68
> 0000000000000046 ffff88011822db08 ffffffff81044c29
> Jan 19 18:00:45 fambox kernel: [ 3107.788682]  ffff880117c6dc80
> ffff88011822dfd8 ffff88011822dfd8 ffff88011822dfd8
> Jan 19 18:00:45 fambox kernel: [ 3107.788689]  ffffffff81c15440
> ffff880117c6dc80 ffff88011822db68 ffff88011fa14738
> Jan 19 18:00:45 fambox kernel: [ 3107.788696] Call Trace:
> Jan 19 18:00:45 fambox kernel: [ 3107.788715]  [<ffffffff81044c29>] ?
> default_spin_lock_flags+0x9/0x10
> Jan 19 18:00:45 fambox kernel: [ 3107.788726]  [<ffffffff811c6830>] ?
> __wait_on_buffer+0x30/0x30
> Jan 19 18:00:45 fambox kernel: [ 3107.788735]  [<ffffffff816b7449>]
> schedule+0x29/0x70
> Jan 19 18:00:45 fambox kernel: [ 3107.788741]  [<ffffffff816b751f>]
> io_schedule+0x8f/0xd0
> Jan 19 18:00:45 fambox kernel: [ 3107.788748]  [<ffffffff811c683e>]
> sleep_on_buffer+0xe/0x20
> Jan 19 18:00:45 fambox kernel: [ 3107.788758]  [<ffffffff816b5d1f>]
> __wait_on_bit+0x5f/0x90
> Jan 19 18:00:45 fambox kernel: [ 3107.788765]  [<ffffffff811c5ef1>] ?
> submit_bh+0x121/0x1e0
> Jan 19 18:00:45 fambox kernel: [ 3107.788771]  [<ffffffff811c6830>] ?
> __wait_on_buffer+0x30/0x30
> Jan 19 18:00:45 fambox kernel: [ 3107.788779]  [<ffffffff816b5dcc>]
> out_of_line_wait_on_bit+0x7c/0x90
> Jan 19 18:00:45 fambox kernel: [ 3107.788787]  [<ffffffff8107eb00>] ?
> autoremove_wake_function+0x40/0x40
> Jan 19 18:00:45 fambox kernel: [ 3107.788794]  [<ffffffff811c682e>]
> __wait_on_buffer+0x2e/0x30
> Jan 19 18:00:45 fambox kernel: [ 3107.788805]  [<ffffffff8128c02c>]
> jbd2_journal_commit_transaction+0x18cc/0x1d60
> Jan 19 18:00:45 fambox kernel: [ 3107.788814]  [<ffffffff816b85de>] ?
> _raw_spin_lock_irqsave+0x2e/0x40
> Jan 19 18:00:45 fambox kernel: [ 3107.788823]  [<ffffffff81069fbf>] ?
> try_to_del_timer_sync+0x4f/0x70
> Jan 19 18:00:45 fambox kernel: [ 3107.788830]  [<ffffffff81290836>]
> kjournald2+0xd6/0x3e0
> Jan 19 18:00:45 fambox kernel: [ 3107.788835]  [<ffffffff8107eac0>] ?
> add_wait_queue+0x60/0x60
> Jan 19 18:00:45 fambox kernel: [ 3107.788841]  [<ffffffff81290760>] ?
> commit_timeout+0x10/0x10
> Jan 19 18:00:45 fambox kernel: [ 3107.788846]  [<ffffffff8107ded0>]
> kthread+0xc0/0xd0
> Jan 19 18:00:45 fambox kernel: [ 3107.788852]  [<ffffffff8107de10>] ?
> flush_kthread_worker+0xb0/0xb0
> Jan 19 18:00:45 fambox kernel: [ 3107.788859]  [<ffffffff816c0dec>]
> ret_from_fork+0x7c/0xb0
> Jan 19 18:00:45 fambox kernel: [ 3107.788865]  [<ffffffff8107de10>] ?
> flush_kthread_worker+0xb0/0xb0
> Jan 19 18:00:45 fambox kernel: [ 3107.788929]
> Jan 19 18:00:45 fambox kernel: [ 3107.788932] Restarting kernel
> threads ... done.
> Jan 19 18:00:45 fambox kernel: [ 3107.789086] Restarting tasks ... done.
> Jan 19 18:00:45 fambox kernel: [ 3107.802117] video LNXVIDEO:00:
> Restoring backlight state
>
> ### [C.2] CHECKING DBUS AND RCU_SCHED STATUS POST-MORTEM
>
> # ll /var/run/dbus/
> insgesamt 4
> drwxr-xr-x  2 messagebus messagebus  80 Jan 19 17:08 ./
> drwxr-xr-x 22 root       root       800 Jan 19 17:11 ../
> -rw-r--r--  1 root       root         4 Jan 19 17:08 pid
> srwxrwxrwx  1 root       root         0 Jan 19 17:08 system_bus_socket=
>
> # cat /var/run/dbus/pid
> 862
>
> root@fambox:~# ps axu | grep -v grep | grep 862
> 102        862  0.0  0.0  25492  2332 ?        Ss   17:08   0:01
> dbus-daemon --system --fork --activation=upstart
> wearefam  1931  0.0  0.5 862752 20116 ?        Sl   17:09   0:02
> /usr/lib/gnome-settings-daemon/gnome-settings-daemon
>
> # pidof dbus-daemon
> 1921 862
>
> # cat /proc/sys/kernel/hung_task_timeout_secs
> 0
>
>
> ##### [D] INTERIM SUMMARY
>
> 1. The issue is reproducible!
> 2. The issue ***can*** be forced by running pm_test/freezer!
>
> Again, the root cause is not very clear to me!
>
> Recent TTY-NEXT changes?
> Problems in EXT4-FS/JBD2?
> Problems in X86/RCU?
>
> Ask the experts :-)!
>
>
> -dileks // 19-Jan-2013

I have a applied another pending patch ("tty: Add driver unthrottle in
ioctl(...,TCFLSH,..).") from tty-next.

Now, the call-trace looks like this:

[  433.527986] PM: Syncing filesystems ... done.
[  433.843761] PM: Preparing system for mem sleep
[  436.306002] Freezing user space processes ...
[  456.304956] Freezing of tasks failed after 20.01 seconds (1 tasks
refusing to freeze, wq_busy=0):
[  456.305060] Cache I/O       D ffffffff8180d780     0  2132      1 0x00000004
[  456.305065]  ffff88007b9dfe18 0000000000000046 ffff88007b9dfdc8
0000000300000001
[  456.305069]  ffff880097e21720 ffff88007b9dffd8 ffff88007b9dffd8
ffff88007b9dffd8
[  456.305072]  ffff880119b32e40 ffff880097e21720 ffff88007b9dfe28
ffff880118077800
[  456.305076] Call Trace:
[  456.305085]  [<ffffffff816b7469>] schedule+0x29/0x70
[  456.305089]  [<ffffffff8129067d>] jbd2_log_wait_commit+0xcd/0x1a0
[  456.305094]  [<ffffffff8107eac0>] ? add_wait_queue+0x60/0x60
[  456.305098]  [<ffffffff812307a5>] ext4_sync_file+0x205/0x380
[  456.305103]  [<ffffffff811c43ad>] do_fsync+0x5d/0x90
[  456.305108]  [<ffffffff8119442b>] ? sys_write+0x6b/0xa0
[  456.305111]  [<ffffffff811c4790>] sys_fsync+0x10/0x20
[  456.305114]  [<ffffffff816c0edd>] system_call_fastpath+0x1a/0x1f
[  456.305122]
[  456.305124] Restarting tasks ... done.
[  456.315056] video LNXVIDEO:00: Restoring backlight state

JBD2/EX4FS problem?

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/gregkh/tty.git;a=patch;h=a1bf9584429d61b7096f93ae09325e1ba538e9e8
