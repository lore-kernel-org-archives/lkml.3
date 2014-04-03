Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaDCLXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 07:23:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47174 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbaDCLX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 07:23:28 -0400
Date: Thu, 3 Apr 2014 13:23:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140403112313.GE9616@pd.tnic>
References: <20140402144219.4cafbe37@gandalf.local.home>
 <20140402221212.GD16570@mguzik.redhat.com>
 <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
 <alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
 <20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org>
 <CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
 <alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz>
 <CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
 <CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 06:47:57PM -0700, Linus Torvalds wrote:
> Whether it actually fixes the problem that Borislav had is
> questionable, of course. For all I know, systemd debug mode generates
> so much data in *other* ways and then causes feedback loops with
> the kernel debugging that this patch is totally immaterial, and
> dmesg was never the main issue. But unlike the "hide 'debug' from
> /proc/cmdline", I think this patch at least _conceptually_ makes a lot
> of sense, even if systemd gets fixed, so ...
>
> Borislav?

Yes, ratelimiting makes the box actually boot all the way. Here's how it
looks like:

^MLoading Linux 3.12.16-boris-00441-g60dc93e99a75-dirty ...
^MLoading initial ramdisk ...
^M[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.12.16-boris-00441-g60dc93e99a75-dirty (gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux) ) #11 SMP Thu Apr 3 10:19:49 CEST 2014
[    0.000000] Command line: BOOT_IMAGE=/@/boot/vmlinuz-3.12.16-boris-00441-g60dc93e99a75-dirty root=UUID=5f1a28cf-d910-
4ed0-85ac-0113d43e553f rootflags=subvol=@ resume=/dev/disk/by-uuid/45671aef-cef3-4fcd-9087-7d4f3f81aa70 splash=off showo
pts crashkernel=256M-:128M pci=hpiosize=0 pci=hpmemsize=4m pciehp.pciehp_force=1 notsc mem=0x40000000000 loop.max_loop=6
4 log_buf_len=16M console=tty0 console=ttyS0,38400n8 ignore_loglevel debug
								     ^^^^^

We haz the "debug" thing on.

...

Here we go:

[   50.636000] be2net 0000:db:00.0: irq 102 for MSI/MSI-X
[   50.636000] be2net 0000:db:00.0: irq 103 for MSI/MSI-X
[   50.636000] be2net 0000:db:00.0: irq 104 for MSI/MSI-X
[   50.636000] be2net 0000:db:00.0: enabled 4 MSI-x vector(s) for NIC
[   50.896000] systemd: 1008 callbacks suppressed
			^^^^

[   50.896000] systemd[1]: Started Show Plymouth Boot Screen.
[   50.896000] systemd[1]: Got SIGCHLD for process 1192 (swapon)
[   50.896000] systemd[1]: Child 1192 died (code=exited, status=0/SUCCESS)
[   50.896000] systemd[1]: Child 1192 belongs to dev-disk-by\x2duuid-45671aef\x2dcef3\x2d4fcd\x2d9087\x2d7d4f3f81aa70.swap
[   50.896000] systemd[1]: dev-disk-by\x2duuid-45671aef\x2dcef3\x2d4fcd\x2d9087\x2d7d4f3f81aa70.swap swap process exited, code=exited status=0
[   50.896000] systemd[1]: dev-disk-by\x2duuid-45671aef\x2dcef3\x2d4fcd\x2d9087\x2d7d4f3f81aa70.swap changed activating -> active
[   50.896000] systemd[1]: Job dev-disk-by\x2duuid-45671aef\x2dcef3\x2d4fcd\x2d9087\x2d7d4f3f81aa70.swap/start finished, result=done

...

[   57.988000] scsi2 : Emulex 10Gbe open-iscsi Initiator Driver
[   63.028000] be2iscsi 0000:db:00.3: irq 117 for MSI/MSI-X
[   63.044000] be2iscsi 0000:db:00.3: irq 118 for MSI/MSI-X
[   63.064000] be2iscsi 0000:db:00.3: irq 119 for MSI/MSI-X
[   63.080000] be2iscsi 0000:db:00.3: irq 120 for MSI/MSI-X
[   63.100000] be2iscsi 0000:db:00.3: irq 121 for MSI/MSI-X
[   63.116000] be2iscsi 0000:db:00.3: irq 122 for MSI/MSI-X
[   63.132000] be2iscsi 0000:db:00.3: irq 123 for MSI/MSI-X
[   63.152000] be2iscsi 0000:db:00.3: irq 124 for MSI/MSI-X
[   63.572000] scsi host2: BC_373 : Link Down on Port 1
[   63.588000] scsi host2: BM_4336 : No boot session
[   63.656000] systemd: 11828 callbacks suppressed
			^^^^^

We luvz to talk a lot of crap, don't we.

[   63.672000] systemd[1]: Received SIGCHLD from PID 833 (udevadm).
[   63.692000] systemd[1]: Got SIGCHLD for process 833 (udevadm)
[   63.712000] systemd[1]: Child 833 died (code=exited, status=0/SUCCESS)
[   63.732000] systemd[1]: Child 833 belongs to systemd-udev-settle.service
[   63.756000] systemd[1]: systemd-udev-settle.service: main process exited, code=exited, status=0/SUCCESS
[   63.788000] systemd[1]: systemd-udev-settle.service changed start -> exited
[   63.812000] systemd[1]: Job systemd-udev-settle.service/start finished, result=done
[   63.836000] systemd[1]: Started udev Wait for Complete Device Initialization.

and so on until we get to the boot prompt:

[  186.828000] systemd[3512]: Executing: /etc/postfix/system/wait_qmgr 60
[  186.856000] systemd[3514]: Executing: /etc/postfix/system/cond_slp register
[  186.892000] systemd[3524]: Executing: /usr/sbin/cron -n
[  186.892000] systemd[3525]: Executing: /usr/lib/systemd/systemd-update-utmp runlevel
[  186.896000] systemd[3418]: Executing: /etc/init.d/after.local
[  186.956000] systemd[3416]: Execung: /sbin/agetty --noclear tty1
[  186.956000] systemd[3415]: Executing: /sbin/agetty --keep-baud ttyS0 115200,38400,9600
^M

Welcome to SUSE Linux Enterprise Server 12 Beta1 (x86_64) - Kernel 3.12.16-boris-00441-g60dc93e99a75-dirty (ttyS0).

...

Then it keeps spitting out crap off and on but it is much more
manageable. As it should be.

So thanks for that fix:

Acked-and-tested-by: Borislav Petkov <bp@suse.de>

I'll pick it up for SLE12 once it sees a bit more upstream time.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
