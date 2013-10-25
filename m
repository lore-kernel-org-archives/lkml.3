Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab3JYJMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:12:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab3JYJMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:12:53 -0400
Date: Fri, 25 Oct 2013 10:13:42 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
Message-ID: <20131025091342.GA10037@kroah.com>
References: <525BD08C.2080101@t-online.de>
 <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
 <CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com>
 <CA+55aFyPffR=kt4njmB7oG012kayrKJPsP-u5JR+s7rERjofCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyPffR=kt4njmB7oG012kayrKJPsP-u5JR+s7rERjofCg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 10:02:22AM +0100, Linus Torvalds wrote:
> Adding more people, so quoting the whole email for them.
> 
> We definitely have some module unload issues. Guys, try the following
> a few times to unload modules:
> 
>     lsmod | grep ' 0 '| cut -d' ' -f1 | xargs sudo rmmod
> 
> (a few times because unloading one module will then potentially make
> other modules unloadable).
> 
> On my machine, I can trigger this, for example:
> 
>   ------------[ cut here ]------------
>   WARNING: CPU: 0 PID: 3217 at fs/sysfs/file.c:498 sysfs_attr_ns+0x91/0xa0()
>   sysfs: kobject (null) without dirent
>   Modules linked in: fuse nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_$
>   CPU: 0 PID: 3217 Comm: rmmod Not tainted 3.12.0-rc6-00284-ge6036c0b8896 #19
>   Hardware name: Sony Corporation SVP11213CXB/VAIO, BIOS R0270V7 05/17/2013
>    0000000000000009 ffff8800aca35df8 ffffffff8160aab5 ffff8800aca35e40
>    ffff8800aca35e30 ffffffff810514b8 ffffffffa013f080 ffff8801194a6040
>    0000000000000800 0000000000000000 0000000000c5b3e0 ffff8800aca35e90
>   Call Trace:
>    [<ffffffff8160aab5>] dump_stack+0x45/0x56
>    [<ffffffff810514b8>] warn_slowpath_common+0x78/0xa0
>    [<ffffffff81051527>] warn_slowpath_fmt+0x47/0x50
>    [<ffffffff810b5960>] ? module_refcount+0xb0/0xb0
>    [<ffffffff811e5c61>] sysfs_attr_ns+0x91/0xa0
>    [<ffffffff811e5d2a>] sysfs_remove_file+0x1a/0x50
>    [<ffffffff814c88a3>] cpufreq_sysfs_remove_file+0x13/0x30
>    [<ffffffffa013d350>] acpi_cpufreq_exit+0x2e/0xcde [acpi_cpufreq]
>    [<ffffffff810b7d1d>] SyS_delete_module+0x15d/0x2c0
>    [<ffffffff81002929>] ? do_notify_resume+0x59/0x90
>    [<ffffffff81618f62>] system_call_fastpath+0x16/0x1b
>   ---[ end trace f887112caaa5c4ab ]---
> 
> so at least we have a cpufreq/sysfs interaction bug. There may be others.
> 
> This particular cpufreq issue may be triggered by the fact that
> acpi-cpufreq isn't actually in use (pstate is). Or it might be some
> generic cpufreq/sysfs bug. Rafael, Greg, ideas?

It looks like a cpufreq bug as the sysfs core is telling the driver that
it tried to delete an attribute file that had already been cleaned up.
That's usually true if the kobject was deleted previously (which
recursively removes the files.)

In looking at the cpufreq_sysfs code, there's a hack of a reference
count that is trying to determine if the kobject should be freed or not.
Using an integer that is not protected by a lock to try to duplicate the
internal kobject reference count seems like a race condition waiting to
happen, which I'm guessing is happening here.

I'm slowly working on cleaning up the attribute code in sysfs and the
driver core and the cpufreq handling of attributes is on my list of
places that need the rework, so it will get resolved soon.

> I don't see that this particular one would be the one that causes the
> timer issues, but it's an example of the fact that module unload tends
> to be special and not necessarily well tested.

Yeah, this is a warning that can be safely ignored (the sysfs core
handles the error just fine), it's a warning to the developer that they
did something foolish.

thanks,

greg k-h
