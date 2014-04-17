Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaDQPMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:12:42 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:65284 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaDQPGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:06:44 -0400
Date: Thu, 17 Apr 2014 11:06:40 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Subject: Re: [RFC PATCH v3] Use kernfs_break_active_protection() for device
 online store callbacks
Message-ID: <20140417150640.GJ15326@htj.dyndns.org>
References: <20140410133116.GB25308@htj.dyndns.org>
 <1397189445.3649.14.camel@ThinkPad-T5421>
 <20140411102649.GB26252@mtj.dyndns.org>
 <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
 <20140414201315.GD16835@htj.dyndns.org>
 <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
 <20140415145017.GK1863@htj.dyndns.org>
 <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
 <20140416151749.GE1257@htj.dyndns.org>
 <1397703953.3415.26.camel@ThinkPad-T5421>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397703953.3415.26.camel@ThinkPad-T5421>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 17, 2014 at 11:05:53AM +0800, Li Zhong wrote:
> It seems to me cpu_add_remove_lock is always taken after
> device_hotplug_lock.
> 
> So if cpu_add_remove_lock has been acquired by device removing process,
> then it means the other online/offline process couldn't successfully try
> lock device_hotplug_lock, and will release s_active with a restart
> syscall error;
> 
> if cpu_add_remove_lock has been acquired by online/offline process, then
> it should already hold device_hotlug_lock, and keeps the device removing
> process waiting at device_hotplug_lock. So online/offline process could
> release the lock, and finally release s_active soon. 

I see.  That's kinda nasty tho and lockdep of course doesn't know
about it and generates spurious warnings.

> But after some further thinking, I seem to understand your point.
> s_active has lock order problem with the other series of hotplug related
> locks, so it's better to take s_active out of the dependency chain,
> rather than the first of the other series of locks? like you suggested
> below.

Yeah, I think that'd be the right thing to do and we can revert the
previous convolution.

Thanks.

-- 
tejun
