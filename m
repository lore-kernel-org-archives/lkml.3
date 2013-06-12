Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab3FLAqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 20:46:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:26491 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599Ab3FLAqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 20:46:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,848,1363158000"; 
   d="scan'208";a="348450176"
Date: Wed, 12 Jun 2013 08:32:49 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: Youquan Song <youquan.song@linux.intel.com>,
        Toshi Kani <toshi.kani@hp.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        youquan.song@intel.com, LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org
Subject: Re: cpu hotplug:  possible_cpus broken (again?) next-20130607
Message-ID: <20130612123248.GA23978@linux-youquan.bj.intel.com>
References: <51B79BE5.80804@sr71.net> <1637965.BN0HgQKvFj@vostro.rjw.lan> <51B7A1F8.6080507@sr71.net> <27437213.QrmAtijARn@vostro.rjw.lan> <1370989954.21540.4.camel@misato.fc.hp.com> <20130612120343.GA22109@linux-youquan.bj.intel.com> <51B7BFB0.8080401@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B7BFB0.8080401@sr71.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 06/12/2013 05:03 AM, Youquan Song wrote:
> > +#ifdef CONFIG_SMP
> > +              /* return when cpu number greater than maximum number of
> > CPUs */
> > +               if (setup_max_cpus <= num_online_cpus() + 1) {
> > +                       cpu_hotplug_driver_unlock();
> > +                       return -EINVAL;
> > +               }
> > +#endif
> >                 from_nid = cpu_to_node(cpuid);
> >                 ret = cpu_up(cpuid);
> 
> Your patch is line-wrapped.
> 
> Also, the #ifdef is unnecessary.  If CONFIG_SMP is off:
> 
> 	static const unsigned int setup_max_cpus = NR_CPUS;
> 	#define num_online_cpus() 1U
> 
> The compiler will take care of optimizing out the the if() without the
> explicit #ifdef.
> 
> Also, the +1 looks goofy to me.  Doesn't this do the same thing (and
> isn't it much easier to read)?
> 
> 	if (num_online_cpus() >= setup_max_cpus)
> 

Thanks. Here is a formal patch for it. please review and try.

Subject: [PATCH] core: Fix maxcpus boot option broken

maxcpus boot option to limit maximum number of CPUs on system, but this option
is broken at recent kernel. Though we use maxcpus to limit CPUs number, but
current kernel will register all of present CPUs in sysfs.
udev will enumerate all registered cpu at sysfs, and it will bring up the CPU
if the CPU is offline. So the maxcpus option is broken.

This patch will limit the online cpus number not over limitation of maxcpus
option. So it will keep the maxcpus limitation when udev enumeration
or other intention of bring up CPUs over the limitation by method like  
echo 1 > /sys/devices/system/cpu/online 

Signed-off-by: Youquan Song <youquan.song@intel.com>
---
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 3d48fc8..e32fffa 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -60,6 +60,13 @@ static ssize_t __ref store_online(struct device *dev,
 			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
 		break;
 	case '1':
+	       /* Return when online cpu number equal or greater than
+		*  maximum number of CPUs */
+		if (num_online_cpus() >= setup_max_cpus) {
+			cpu_hotplug_driver_unlock();
+			return -EINVAL;
+		}
+
 		from_nid = cpu_to_node(cpuid);
 		ret = cpu_up(cpuid);
 
