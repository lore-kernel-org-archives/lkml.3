Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3FLKx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:53:28 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34830 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab3FLKx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:53:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Youquan Song <youquan.song@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave@sr71.net>,
        Toshi Kani <toshi.kani@hp.com>, Youquan Song <youquan.song@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: cpu hotplug: possible_cpus broken (again?) next-20130607
Date: Wed, 12 Jun 2013 13:02:32 +0200
Message-ID: <4005805.V3phb1agMs@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQXWi7mn6AM=A2qrHO=3S_oLT7wBRLm19rP987hGzwdqKA@mail.gmail.com>
References: <51B79BE5.80804@sr71.net> <20130612123248.GA23978@linux-youquan.bj.intel.com> <CAE9FiQXWi7mn6AM=A2qrHO=3S_oLT7wBRLm19rP987hGzwdqKA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 11, 2013 09:07:37 PM Yinghai Lu wrote:
> On Wed, Jun 12, 2013 at 5:32 AM, Youquan Song
> <youquan.song@linux.intel.com> wrote:
> >> On 06/12/2013 05:03 AM, Youquan Song wrote:
> >> > +#ifdef CONFIG_SMP
> >> > +              /* return when cpu number greater than maximum number of
> >> > CPUs */
> >> > +               if (setup_max_cpus <= num_online_cpus() + 1) {
> >> > +                       cpu_hotplug_driver_unlock();
> >> > +                       return -EINVAL;
> >> > +               }
> >> > +#endif
> >> >                 from_nid = cpu_to_node(cpuid);
> >> >                 ret = cpu_up(cpuid);
> >>
> >> Your patch is line-wrapped.
> >>
> >> Also, the #ifdef is unnecessary.  If CONFIG_SMP is off:
> >>
> >>       static const unsigned int setup_max_cpus = NR_CPUS;
> >>       #define num_online_cpus() 1U
> >>
> >> The compiler will take care of optimizing out the the if() without the
> >> explicit #ifdef.
> >>
> >> Also, the +1 looks goofy to me.  Doesn't this do the same thing (and
> >> isn't it much easier to read)?
> >>
> >>       if (num_online_cpus() >= setup_max_cpus)
> >>
> >
> > Thanks. Here is a formal patch for it. please review and try.
> >
> > Subject: [PATCH] core: Fix maxcpus boot option broken
> >
> > maxcpus boot option to limit maximum number of CPUs on system, but this option
> > is broken at recent kernel. Though we use maxcpus to limit CPUs number, but
> > current kernel will register all of present CPUs in sysfs.
> > udev will enumerate all registered cpu at sysfs, and it will bring up the CPU
> > if the CPU is offline. So the maxcpus option is broken.
> >
> > This patch will limit the online cpus number not over limitation of maxcpus
> > option. So it will keep the maxcpus limitation when udev enumeration
> > or other intention of bring up CPUs over the limitation by method like
> > echo 1 > /sys/devices/system/cpu/online
> 
> Interesting, you are changing long standing meaning of maxcpus=
> 
> We always use maxcpus=1 to have one cpu up, and later in user space
> to online other cpus like
> echo 1 > /sys/devices/system/cpuX/online.
> 
> aka maxcpus= is a soft limit or initial online nr.
> 
> we already have nr_cpus= for hard limit.
> 
> So need to drop
>  commit 3e275a5ba367ab74b3a4e49114307baed989fcac
>  Author: Youquan Song <youquan.song@intel.com>
>  Date:   Fri Jun 7 10:07:08 2013 +1000
> 
>      drivers/base/cpu.c: fix maxcpus boot option

Agreed.

Thanks,
Rafael


> Greg,
> Can you drop that 3e275a5ba36 from your drivers/core tree ?
> 
> Thanks
> 
> Yinghai
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
