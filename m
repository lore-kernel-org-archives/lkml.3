Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3H1MY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:24:28 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:39240 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab3H1MY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:24:26 -0400
Date: Wed, 28 Aug 2013 08:24:22 -0400
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH] driver core / ACPI: Avoid device removal locking problems
Message-ID: <20130828122422.GA18348@mtj.dyndns.org>
References: <1543475.L7gSB7lLAu@vostro.rjw.lan>
 <521C6FA8.4070804@cn.fujitsu.com>
 <20130827183644.GC12212@mtj.dyndns.org>
 <2885746.SMJa75jgiX@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2885746.SMJa75jgiX@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Tue, Aug 27, 2013 at 11:45:46PM +0200, Rafael J. Wysocki wrote:
> I've thought about that a bit over the last several hours and I'm still
> thinking that that patch is a bit overkill, because it will trigger the
> restart_syscall() for all cases when device_hotplug_lock is locked, even
> if they can't lead to any deadlocks.  The only deadlockish situation is
> when device *removal* is in progress when store_online(), for example,
> is called.
> 
> So to address that particular situation without adding too much overhead for
> other cases, I've come up with the appended patch (untested for now).
> 
> This is how it is supposed to work.
> 
> There are three "lock levels" for device hotplug, "normal", "remove"
> and "weak".  The difference is related to how __lock_device_hotplug()
> works.  Namely, if device hotplug is currently locked, that function
> will either block or return false, depending on the "current lock
> level" and its argument (the "new lock level").  The rules here are
> that false is returned immediately if the "current lock level" is
> "remove" and the "new lock level" is "weak".  The function blocks
> for all other combinations of the two.

I think this is going way too far and a massive overkill in terms of
complexity, which is way more important than for doing some
restart_syscall loops during some rare sysfs file access, which isn't
gonna be that common anyway.  Fancy locking always sucks.  The root
cause of the problem is file removal ref draining from sysfs side and
a proper solution should be implemented there.  Adding all this
complexity to device hotplug lock won't solve problems involving other
locks while obfuscating what's going on through all the complexity.
Also, when sysfs is updated with a proper solution, a simpler
workaround from device hotplug side would be far easier to convert to
the new solution than this, which over time is likely to grow
interesting uses.

Let's *please* stick to something simple.

Thanks.

-- 
tejun
