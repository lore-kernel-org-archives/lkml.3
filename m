Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030960AbaDJNbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:31:22 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:49803 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030688AbaDJNbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:31:20 -0400
Date: Thu, 10 Apr 2014 09:31:16 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Subject: Re: [RFC PATCH] Suppress a device hot remove related lockdep warning
Message-ID: <20140410133116.GB25308@htj.dyndns.org>
References: <1397121514.25199.91.camel@ThinkPad-T5421.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397121514.25199.91.camel@ThinkPad-T5421.cn.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 10, 2014 at 05:18:34PM +0800, Li Zhong wrote:
> I noticed following lockdep warning when trying acpi hot-remove cpus:
> 
> [84154.204080] ======================================================
> [84154.204080] [ INFO: possible circular locking dependency detected ]
> [84154.204080] 3.14.0-next-20140408+ #24 Tainted: G        W    
> [84154.204080] -------------------------------------------------------
> [84154.204080] bash/777 is trying to acquire lock:
> [84154.204080]  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff810664a7>] cpu_maps_update_begin+0x17/0x20
> [84154.213203] 
> [84154.213203] but task is already holding lock:
> [84154.213203]  (s_active#79){++++.+}, at: [<ffffffff81256e14>] kernfs_fop_write+0xe4/0x190
> [84154.213203] 
> [84154.213203] which lock already depends on the new lock.
> [84154.213203] 
> [84154.213203] 
> [84154.213203] the existing dependency chain (in reverse order) is:
> [84154.213203] 
...
> [84154.213203]  Possible unsafe locking scenario:
> [84154.213203] 
> [84154.213203]        CPU0                    CPU1
> [84154.213203]        ----                    ----
> [84154.213203]   lock(s_active#79);
> [84154.213203]                                lock(cpu_hotplug.lock#2);
> [84154.213203]                                lock(s_active#79);
> [84154.213203]   lock(cpu_add_remove_lock);
> [84154.213203] 
> [84154.213203]  *** DEADLOCK ***
> .............
> 
> The deadlock itself seems already fixed in commit 5e33bc41. 
> 
> This patch uses DEVICE_ATTR_IGNORE_LOCKDEP for "online" attr to suppress
> this lockdep warning. But I'm a little afraid it might also hide
> (future) potential real dead lock scenarios? 

I suppose this is happening because offlining a cpu involves removing
some sysfs files?  If the file isn't trying to remove itself, it
should be okay but I think it could be better to use
kernfs_break_active_protection() from online callback so that the
operation is actually outside the dependency chain rather than just
suppressing lockdep.

Thanks.

-- 
tejun
