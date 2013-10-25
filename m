Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3JYJ6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:58:24 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64651 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752305Ab3JYJ6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:58:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request during shutdown
Date: Fri, 25 Oct 2013 12:10:24 +0200
Message-ID: <3005031.0yf0g1BPEE@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1483174.NsuFf8aJk6@vostro.rjw.lan>
References: <525BD08C.2080101@t-online.de> <2582195.phiuskXt0x@vostro.rjw.lan> <1483174.NsuFf8aJk6@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 25, 2013 11:51:40 AM Rafael J. Wysocki wrote:
> On Friday, October 25, 2013 11:28:02 AM Rafael J. Wysocki wrote:
> > On Friday, October 25, 2013 10:02:22 AM Linus Torvalds wrote:
> > > Adding more people, so quoting the whole email for them.
> > > 
> > > We definitely have some module unload issues. Guys, try the following
> > > a few times to unload modules:
> > > 
> > >     lsmod | grep ' 0 '| cut -d' ' -f1 | xargs sudo rmmod
> > > 
> > > (a few times because unloading one module will then potentially make
> > > other modules unloadable).
> > > 
> > > On my machine, I can trigger this, for example:
> > > 
> > >   ------------[ cut here ]------------
> > >   WARNING: CPU: 0 PID: 3217 at fs/sysfs/file.c:498 sysfs_attr_ns+0x91/0xa0()
> > >   sysfs: kobject (null) without dirent
> > >   Modules linked in: fuse nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_$
> > >   CPU: 0 PID: 3217 Comm: rmmod Not tainted 3.12.0-rc6-00284-ge6036c0b8896 #19
> > >   Hardware name: Sony Corporation SVP11213CXB/VAIO, BIOS R0270V7 05/17/2013
> > >    0000000000000009 ffff8800aca35df8 ffffffff8160aab5 ffff8800aca35e40
> > >    ffff8800aca35e30 ffffffff810514b8 ffffffffa013f080 ffff8801194a6040
> > >    0000000000000800 0000000000000000 0000000000c5b3e0 ffff8800aca35e90
> > >   Call Trace:
> > >    [<ffffffff8160aab5>] dump_stack+0x45/0x56
> > >    [<ffffffff810514b8>] warn_slowpath_common+0x78/0xa0
> > >    [<ffffffff81051527>] warn_slowpath_fmt+0x47/0x50
> > >    [<ffffffff810b5960>] ? module_refcount+0xb0/0xb0
> > >    [<ffffffff811e5c61>] sysfs_attr_ns+0x91/0xa0
> > >    [<ffffffff811e5d2a>] sysfs_remove_file+0x1a/0x50
> > >    [<ffffffff814c88a3>] cpufreq_sysfs_remove_file+0x13/0x30
> > >    [<ffffffffa013d350>] acpi_cpufreq_exit+0x2e/0xcde [acpi_cpufreq]
> > >    [<ffffffff810b7d1d>] SyS_delete_module+0x15d/0x2c0
> > >    [<ffffffff81002929>] ? do_notify_resume+0x59/0x90
> > >    [<ffffffff81618f62>] system_call_fastpath+0x16/0x1b
> > >   ---[ end trace f887112caaa5c4ab ]---
> > > 
> > > so at least we have a cpufreq/sysfs interaction bug. There may be others.
> > > 
> > > This particular cpufreq issue may be triggered by the fact that
> > > acpi-cpufreq isn't actually in use (pstate is). Or it might be some
> > > generic cpufreq/sysfs bug. Rafael, Greg, ideas?
> > 
> > I *think* that this indeed is related to acpi-cpufreq being unused.  That said,
> > we've been fixing sysfs-related bugs in cpufreq recently and we may have
> > overlooked something.
> > 
> > I'll have a deeper look at that.
> 
> Well, if the ACPI cpufreq driver is not registered, the exit function of the
> module shouldn't try to unregister it, so I have the appended patch (untested)
> to fix that particular thing.

And in my opinion acpi_cpufreq_init() should just return an error code if it
can't register the driver, like in the (untested) patch below.

Rafael


---
 drivers/cpufreq/acpi-cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-pm/drivers/cpufreq/acpi-cpufreq.c
===================================================================
--- linux-pm.orig/drivers/cpufreq/acpi-cpufreq.c
+++ linux-pm/drivers/cpufreq/acpi-cpufreq.c
@@ -988,10 +988,10 @@ static int __init acpi_cpufreq_init(void
 
 	/* don't keep reloading if cpufreq_driver exists */
 	if (cpufreq_get_current_driver())
-		return 0;
+		return -EEXIST;
 
 	if (acpi_disabled)
-		return 0;
+		return -ENODEV;
 
 	pr_debug("acpi_cpufreq_init\n");
 

