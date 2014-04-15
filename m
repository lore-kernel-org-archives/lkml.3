Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161AbaDOOuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:50:24 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:35715 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaDOOuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:50:22 -0400
Date: Tue, 15 Apr 2014 10:50:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Subject: Re: [RFC PATCH v3] Use kernfs_break_active_protection() for device
 online store callbacks
Message-ID: <20140415145017.GK1863@htj.dyndns.org>
References: <1397121514.25199.91.camel@ThinkPad-T5421.cn.ibm.com>
 <20140410133116.GB25308@htj.dyndns.org>
 <1397189445.3649.14.camel@ThinkPad-T5421>
 <20140411102649.GB26252@mtj.dyndns.org>
 <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
 <20140414201315.GD16835@htj.dyndns.org>
 <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 15, 2014 at 10:44:37AM +0800, Li Zhong wrote:
> / *
>   * This process might deadlock with another process trying to 
>   * remove this device:
>   * This process holding the s_active of "online" attribute, and tries 
>   * to online/offline the device with some locks protecting hotplug.
>   * Device removing process holding some locks protecting hotplug, and 
>   * tries to remove the "online" attribute, waiting for the s_active to
>   * be released. 
>   *
>   * The deadlock described above should be solved with
>   * lock_device_hotplug_sysfs(). We temporarily drop the active 
>   * protection here to avoid some lockdep warnings. 
>   *
>   * If device_hotplug_lock is forgotten to be used when removing
>   * device(possibly some very simple device even don't need this lock?),
>   * @dev could go away any time after dropping the active protection. 
>   * So increase its ref count before dropping active protection. 
>   * Though invoking device_{on|off}line() on a removed device seems
>   * unreasonable, it should be less disastrous than playing with freed
>   * @dev. Also, we might be able to have some mechanism abort 
>   * device_{on|off}line() if @dev already removed.
>   */

Hmmm... I'm not sure I fully understand the problem.  Does the code
ever try to remove "online" while holding cpu_add_remove_lock and,
when written 0, online knob grabs cpu_add_remove_lock?  If so, that is
an actually possible deadlock, no?

Thanks.

-- 
tejun
