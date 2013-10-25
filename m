Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab3JYJCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:02:25 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:65094 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3JYJCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:02:23 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com>
References: <525BD08C.2080101@t-online.de>
	<CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
	<CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com>
Date: Fri, 25 Oct 2013 10:02:22 +0100
X-Google-Sender-Auth: z3tMHk_j9HRDeND806gDLxriw3U
Message-ID: <CA+55aFyPffR=kt4njmB7oG012kayrKJPsP-u5JR+s7rERjofCg@mail.gmail.com>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Knut Petersen <Knut_Petersen@t-online.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding more people, so quoting the whole email for them.

We definitely have some module unload issues. Guys, try the following
a few times to unload modules:

    lsmod | grep ' 0 '| cut -d' ' -f1 | xargs sudo rmmod

(a few times because unloading one module will then potentially make
other modules unloadable).

On my machine, I can trigger this, for example:

  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 3217 at fs/sysfs/file.c:498 sysfs_attr_ns+0x91/0xa0()
  sysfs: kobject (null) without dirent
  Modules linked in: fuse nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_$
  CPU: 0 PID: 3217 Comm: rmmod Not tainted 3.12.0-rc6-00284-ge6036c0b8896 #19
  Hardware name: Sony Corporation SVP11213CXB/VAIO, BIOS R0270V7 05/17/2013
   0000000000000009 ffff8800aca35df8 ffffffff8160aab5 ffff8800aca35e40
   ffff8800aca35e30 ffffffff810514b8 ffffffffa013f080 ffff8801194a6040
   0000000000000800 0000000000000000 0000000000c5b3e0 ffff8800aca35e90
  Call Trace:
   [<ffffffff8160aab5>] dump_stack+0x45/0x56
   [<ffffffff810514b8>] warn_slowpath_common+0x78/0xa0
   [<ffffffff81051527>] warn_slowpath_fmt+0x47/0x50
   [<ffffffff810b5960>] ? module_refcount+0xb0/0xb0
   [<ffffffff811e5c61>] sysfs_attr_ns+0x91/0xa0
   [<ffffffff811e5d2a>] sysfs_remove_file+0x1a/0x50
   [<ffffffff814c88a3>] cpufreq_sysfs_remove_file+0x13/0x30
   [<ffffffffa013d350>] acpi_cpufreq_exit+0x2e/0xcde [acpi_cpufreq]
   [<ffffffff810b7d1d>] SyS_delete_module+0x15d/0x2c0
   [<ffffffff81002929>] ? do_notify_resume+0x59/0x90
   [<ffffffff81618f62>] system_call_fastpath+0x16/0x1b
  ---[ end trace f887112caaa5c4ab ]---

so at least we have a cpufreq/sysfs interaction bug. There may be others.

This particular cpufreq issue may be triggered by the fact that
acpi-cpufreq isn't actually in use (pstate is). Or it might be some
generic cpufreq/sysfs bug. Rafael, Greg, ideas?

I don't see that this particular one would be the one that causes the
timer issues, but it's an example of the fact that module unload tends
to be special and not necessarily well tested.

                   Linus

On Fri, Oct 25, 2013 at 9:38 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Hmm.. I just got a run_timer_softirq oops on my own laptop, slightly
> different. That was not during shutdown, although there was a "yum
> upgrade" finishing when that happened, so it's quite likely that there
> was a service shutdown (and then restart).
>
> I think it's related. But my oops has almost no information: the IP
> that was jumped to was bogus, and the callchain is just CPU idle
> followed by the softirq -> run_timers_softirq handling, so there's no
> real way to see *what* triggered it.
>
> The bad rip was ffffffffa051e250, which is not a valid code address.
> It *might* be a module address, though. So this might be triggered by
> rmmod on some module that doesn't remove all its timers...
>
> Ideas?
>
>                  Linus
