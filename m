Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbaDWCAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 22:00:37 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:36760 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaDWCAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 22:00:36 -0400
Message-ID: <1398218426.2805.42.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH v5 1/2] Use lock_device_hotplug() in
 cpu_probe_store() and cpu_release_store()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Date: Wed, 23 Apr 2014 10:00:26 +0800
In-Reply-To: <20140422204006.GA3615@mtj.dyndns.org>
References: <20140414201315.GD16835@htj.dyndns.org>
	 <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140415145017.GK1863@htj.dyndns.org>
	 <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140416151749.GE1257@htj.dyndns.org>
	 <1397717444.4034.15.camel@ThinkPad-T5421>
	 <20140417151728.GK15326@htj.dyndns.org>
	 <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140421223804.GD22730@htj.dyndns.org>
	 <1398133777.2805.7.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140422204006.GA3615@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042302-1948-0000-0000-0000088C725C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 16:40 -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Apr 22, 2014 at 10:29:37AM +0800, Li Zhong wrote:
> > The probe/release files are attribute files for cpu subsys, looks like
> > following in sysfs dirs
> > 
> > $ cd /sys/devices/system/cpu/
> > $ ls -l
> > total 0
> > drwxr-xr-x. 7 root root     0 Apr 17 19:00 cpu0
> > drwxr-xr-x. 4 root root     0 Apr 17 19:00 cpu1
> > drwxr-xr-x. 4 root root     0 Apr 17 19:00 cpu10
> > ......
> > drwxr-xr-x. 3 root root     0 Apr 20 08:00 cpufreq
> > drwxr-xr-x. 2 root root     0 Apr 20 08:00 cpuidle
> > -rw-------. 1 root root 65536 Apr 21 00:28 dscr_default
> > -r--r--r--. 1 root root 65536 Apr 21 00:28 kernel_max
> > -r--r--r--. 1 root root 65536 Apr 21 00:28 offline
> > -r--r--r--. 1 root root 65536 Sep  4  2014 online
> > -r--r--r--. 1 root root 65536 Apr 21 00:28 possible
> > drwxr-xr-x. 2 root root     0 Apr 20 08:00 power
> > -r--r--r--. 1 root root 65536 Apr 17 20:46 present
> > --w-------. 1 root root 65536 Apr 21 00:28 probe        <-----	
> > --w-------. 1 root root 65536 Apr 21 00:28 release      <-----
> > -rw-------. 1 root root 65536 Apr 21 00:28 subcores_per_core
> > -rw-r--r--. 1 root root 65536 Apr 21 00:28 uevent
> > 
> > From the code, it seems cpu subsys won't be unregistered, and it doesn't
> > make sense to remove all the cpus in the system. 
> 
> I don't think I'm following you.  Are you saying that no files which
> are protected under the hotplug lock that cpu subsys uses are removed
> during offlining?

Sorry, Maybe I didn't say it clearly. 

There are files under cpu#, e.g. 

$ cd /sys/devices/system/cpu/cpu0
$ ls
cache             dscr   node1        pmc1  pmc5   smt_snooze_delay
uevent
cpuidle           mmcr0  online       pmc2  pmc6   spurr
crash_notes       mmcr1  physical_id  pmc3  power  subsystem
crash_notes_size  mmcra  pir          pmc4  purr   topology

If you remove cpu0, then the cpu0 directory will be removed, together
with the "online" file in the directory, while some other process might
be writing 0 or 1 to it.

But here, for the probe/release, take "release" for example, if user
writes something that stands for cpu0 to it, the cpu0 will be removed, 
and the cpu0 directory and the files under it will be removed. But
"release" itself is not removed.

They are attributes of cpu_subsys, not of some specific cpus.

Hopes the above makes things a bit clearer. 

Thanks, Zhong

> 
> Thanks.
> 


