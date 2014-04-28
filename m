Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaD1Avs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 20:51:48 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:41846 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaD1Avq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 20:51:46 -0400
Message-ID: <1398646295.3046.30.camel@ThinkPad-T5421>
Subject: Re: [RFC PATCH v5 1/2] Use lock_device_hotplug() in
 cpu_probe_store() and cpu_release_store()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Date: Mon, 28 Apr 2014 08:51:35 +0800
In-Reply-To: <20140425122822.GA20460@htj.dyndns.org>
References: <20140417151728.GK15326@htj.dyndns.org>
	 <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140421223804.GD22730@htj.dyndns.org>
	 <1398133777.2805.7.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140422204006.GA3615@mtj.dyndns.org>
	 <1398218426.2805.42.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140423143940.GD4781@htj.dyndns.org>
	 <1398328643.2805.102.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140424143208.GB14460@htj.dyndns.org>
	 <1398390970.2805.136.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140425122822.GA20460@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042800-4966-0000-0000-0000093479B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 08:28 -0400, Tejun Heo wrote:
> On Fri, Apr 25, 2014 at 09:56:10AM +0800, Li Zhong wrote:
> > > A nests cpu subsys mutex under s_active of the online node.  B nests
> > > s_active of the online node under the cpu subsys mutex.  What am I
> > > missing?
> > 
> > From the above two chain, I think the problem is cpu_subsys_mutex and
> > s_active(online), which is the deadlock we are trying to solve in patch
> 
> Yeap, that one was what I was thinking about.
> 
> > #2. I seems to me s_active(release) here doesn't have lock issues? 
> 
> And your patch doesn't change the situation for online.  

I'm a little confused here...

To clarify for this patch(#1): 

Currently(before patch#2), the s_active(online) and cpu subsys mutex
deadlock is solved by lock_device_hotplug_sysfs(). (lockdep warnings are
still there, so we want to change the implementation of
lock_device_hotplug_sysfs() in patch #2 to take out of s_active_online,
instead of device_hotplug_lock, which is grabbed before cpu subsys
mutex). 

But here, for the probe/release, I think we really don't need to use
this _sysfs() version. 

So it is replaced with lock_device_hotplug() directly to avoid two
unnecessary conversions of lock_device_hotplug_sysfs(), that otherwise
need to be done in patch #2.

Thanks, Zhong

> Alright,
> thanks a lot for the explanation.
> 


