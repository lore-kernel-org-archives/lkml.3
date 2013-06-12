Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab3FLARu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 20:17:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:52256 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3FLARs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 20:17:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,848,1363158000"; 
   d="scan'208";a="315611562"
Date: Wed, 12 Jun 2013 08:03:43 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, youquan.song@intel.com,
        Dave Hansen <dave@sr71.net>, LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org, youquan.song@linux.intel.com
Subject: Re: cpu hotplug:  possible_cpus broken (again?) next-20130607
Message-ID: <20130612120343.GA22109@linux-youquan.bj.intel.com>
References: <51B79BE5.80804@sr71.net> <1637965.BN0HgQKvFj@vostro.rjw.lan> <51B7A1F8.6080507@sr71.net> <27437213.QrmAtijARn@vostro.rjw.lan> <1370989954.21540.4.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370989954.21540.4.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 04:32:34PM -0600, Toshi Kani wrote:
> On Wed, 2013-06-12 at 00:34 +0200, Rafael J. Wysocki wrote:
> > On Tuesday, June 11, 2013 03:17:28 PM Dave Hansen wrote:
> > > On 06/11/2013 03:05 PM, Rafael J. Wysocki wrote:
> > > > On Tuesday, June 11, 2013 02:51:33 PM Dave Hansen wrote:
> > > >> possible_cpus looks broken again.  I'm booting with:
> > > >>
> > > >>  maxcpus=10 possible_cpus=160
> > > >>
> > > >> But I only get 0-9 in sysfs:
> > > >>
> > > >>> # ls /sys/devices/system/cpu/
> > > >>> cpu0  cpu2  cpu4  cpu6  cpu8  cpufreq  kernel_max  offline  possible  probe    uevent
> > > >>> cpu1  cpu3  cpu5  cpu7  cpu9  cpuidle  modalias    online   present   release
> > > > 
> > > > Can you please test the acpi-hotplug branch of the linux-pm.git tree?
> > > 
> > > That branch seems to work happily.
> > 
> > In that case the problem may have been reintroduced by a merge conflict fix in
> > linux-next.
> 
> I believe the problem was introduced by the following change.  From the
> description, though, this is exactly what this patch was trying to
> change...  Adding Youguan to the list.
> 
> commit 3e275a5ba367ab74b3a4e49114307baed989fcac
> Author: Youquan Song <youquan.song@intel.com>
> Date:   Fri Jun 7 10:07:08 2013 +1000
> 
>     drivers/base/cpu.c: fix maxcpus boot option
> 
Hi Toshi,

Thanks Thoshi for the information.
please try the below patch to fix the issue by moving the code to
store_online.

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 3d48fc8..2378f42 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -60,6 +60,13 @@ static ssize_t __ref store_online(struct device *dev,
                        kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
                break;
        case '1':
+#ifdef CONFIG_SMP
+              /* return when cpu number greater than maximum number of
CPUs */
+               if (setup_max_cpus <= num_online_cpus() + 1) {
+                       cpu_hotplug_driver_unlock();
+                       return -EINVAL;
+               }
+#endif
                from_nid = cpu_to_node(cpuid);
                ret = cpu_up(cpuid);

Thanks
-Youquan

