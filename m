Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab3FLNuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 09:50:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:38833 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab3FLNui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 09:50:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,852,1363158000"; 
   d="scan'208";a="315872827"
Date: Wed, 12 Jun 2013 21:36:09 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Youquan Song <youquan.song@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave@sr71.net>,
        Toshi Kani <toshi.kani@hp.com>, Youquan Song <youquan.song@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: cpu hotplug: possible_cpus broken (again?) next-20130607
Message-ID: <20130613013609.GA6348@linux-youquan.bj.intel.com>
References: <51B79BE5.80804@sr71.net> <20130612123248.GA23978@linux-youquan.bj.intel.com> <CAE9FiQXWi7mn6AM=A2qrHO=3S_oLT7wBRLm19rP987hGzwdqKA@mail.gmail.com> <4005805.V3phb1agMs@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4005805.V3phb1agMs@vostro.rjw.lan>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Interesting, you are changing long standing meaning of maxcpus=
> > 
> > We always use maxcpus=1 to have one cpu up, and later in user space
> > to online other cpus like
> > echo 1 > /sys/devices/system/cpuX/online.
> > 
> > aka maxcpus= is a soft limit or initial online nr.
> > 
> > we already have nr_cpus= for hard limit.
> > 
> > So need to drop
> >  commit 3e275a5ba367ab74b3a4e49114307baed989fcac
> >  Author: Youquan Song <youquan.song@intel.com>
> >  Date:   Fri Jun 7 10:07:08 2013 +1000
> > 
> >      drivers/base/cpu.c: fix maxcpus boot option
> 
> Agreed.

Yes. I also agree to drop it and the fix need more consideration.
I try use maxcpus to limit cpu number to debug a well known applition 
because it fail to run when cpu number is larger to > 69. 
When I use maxcpus at to limit the boot CPUs number, but udev will 
enable all of the CPUs at 3.10 kernel automatically. 
I also try maxcpus at 3.0 kernel, it does not show the maxcpus issue. 
I have digged out recently, it is the commit at 3.2 kernel
8a25a2fd126c621f44f3aeaef80d51f00fc11639 "cpu: convert 'cpu' and
'machinecheck' sysdev_class to a regular subsystem" result in udev
automatically enable all of CPUs though maxcpus has been provided.

So the next, I need look at udev try to enable all of CPUs though
maxcpus provided.  Possibly, it can also fix it in udev daemon.

Secondly, I think that the maxcpus= option description is too confused in
Documentation/kernel-parameters.txt. The maxcpus and nr_cpus option need
switch their name.
Currently:

	maxcpus=	[SMP] Maximum number of processors that	an SMP kernel
			should make use of.  maxcpus=n : n >= 0 limits the
			kernel to using 'n' processors.  n=0 is a special case,
			it is equivalent to "nosmp", which also disables
			the IO APIC.

How about change to 

	maxcpus=	[SMP] Maximum number of processors that	an SMP kernel
			bring up during booting.  maxcpus=n : n >= 0 limits the
			kernel to using 'n' processors.  n=0 is a special case,
			it is equivalent to "nosmp", which also disables
			the IO APIC.


Thanks
-Youquan
