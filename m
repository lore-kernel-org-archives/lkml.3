Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaDVC3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 22:29:49 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:44895 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaDVC3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 22:29:46 -0400
Message-ID: <1398133777.2805.7.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH v5 1/2] Use lock_device_hotplug() in
 cpu_probe_store() and cpu_release_store()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Date: Tue, 22 Apr 2014 10:29:37 +0800
In-Reply-To: <20140421223804.GD22730@htj.dyndns.org>
References: <20140411102649.GB26252@mtj.dyndns.org>
	 <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140414201315.GD16835@htj.dyndns.org>
	 <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140415145017.GK1863@htj.dyndns.org>
	 <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140416151749.GE1257@htj.dyndns.org>
	 <1397717444.4034.15.camel@ThinkPad-T5421>
	 <20140417151728.GK15326@htj.dyndns.org>
	 <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140421223804.GD22730@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042202-1948-0000-0000-000008894091
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-21 at 18:38 -0400, Tejun Heo wrote:
> Hello,
> 
> On Mon, Apr 21, 2014 at 05:20:59PM +0800, Li Zhong wrote:
> > While auditing the usage of lock_device_hotplug_sysfs() for implementing
> > it in another way in following patch, it seems to me that the code here
> > is to add/remove device, and the files probe/release for cpu bus
> > themselves won't be removed. 
> > 
> > So it seems to me there is no s_active related deadlock here, and we
> > could just use lock_device_hotplug().
> 
> It may still cause issue if offlining ends up removing sysfs files or
> gets involved with the same lock used during cpu hot[un]plug
> operations (e.g. offlining racing against cpu hotunplug) and offlining
> a cpu does remove files.  Has this change been tested?

The probe/release files are attribute files for cpu subsys, looks like
following in sysfs dirs

$ cd /sys/devices/system/cpu/
$ ls -l
total 0
drwxr-xr-x. 7 root root     0 Apr 17 19:00 cpu0
drwxr-xr-x. 4 root root     0 Apr 17 19:00 cpu1
drwxr-xr-x. 4 root root     0 Apr 17 19:00 cpu10
......
drwxr-xr-x. 3 root root     0 Apr 20 08:00 cpufreq
drwxr-xr-x. 2 root root     0 Apr 20 08:00 cpuidle
-rw-------. 1 root root 65536 Apr 21 00:28 dscr_default
-r--r--r--. 1 root root 65536 Apr 21 00:28 kernel_max
-r--r--r--. 1 root root 65536 Apr 21 00:28 offline
-r--r--r--. 1 root root 65536 Sep  4  2014 online
-r--r--r--. 1 root root 65536 Apr 21 00:28 possible
drwxr-xr-x. 2 root root     0 Apr 20 08:00 power
-r--r--r--. 1 root root 65536 Apr 17 20:46 present
--w-------. 1 root root 65536 Apr 21 00:28 probe        <-----	
--w-------. 1 root root 65536 Apr 21 00:28 release      <-----
-rw-------. 1 root root 65536 Apr 21 00:28 subcores_per_core
-rw-r--r--. 1 root root 65536 Apr 21 00:28 uevent

>From the code, it seems cpu subsys won't be unregistered, and it doesn't
make sense to remove all the cpus in the system. 

Thanks, Zhong

> 
> Thanks.
> 


