Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3H1NOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:14:09 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39475 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab3H1NOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:14:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH] driver core / ACPI: Avoid device removal locking problems
Date: Wed, 28 Aug 2013 15:24:45 +0200
Message-ID: <1592448.YZbpON5n7n@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130828122422.GA18348@mtj.dyndns.org>
References: <1543475.L7gSB7lLAu@vostro.rjw.lan> <2885746.SMJa75jgiX@vostro.rjw.lan> <20130828122422.GA18348@mtj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 28, 2013 08:24:22 AM Tejun Heo wrote:
> Hello, Rafael.
> 
> On Tue, Aug 27, 2013 at 11:45:46PM +0200, Rafael J. Wysocki wrote:
> > I've thought about that a bit over the last several hours and I'm still
> > thinking that that patch is a bit overkill, because it will trigger the
> > restart_syscall() for all cases when device_hotplug_lock is locked, even
> > if they can't lead to any deadlocks.  The only deadlockish situation is
> > when device *removal* is in progress when store_online(), for example,
> > is called.
> > 
> > So to address that particular situation without adding too much overhead for
> > other cases, I've come up with the appended patch (untested for now).
> > 
> > This is how it is supposed to work.
> > 
> > There are three "lock levels" for device hotplug, "normal", "remove"
> > and "weak".  The difference is related to how __lock_device_hotplug()
> > works.  Namely, if device hotplug is currently locked, that function
> > will either block or return false, depending on the "current lock
> > level" and its argument (the "new lock level").  The rules here are
> > that false is returned immediately if the "current lock level" is
> > "remove" and the "new lock level" is "weak".  The function blocks
> > for all other combinations of the two.
> 
> I think this is going way too far and a massive overkill in terms of
> complexity, which is way more important than for doing some
> restart_syscall loops during some rare sysfs file access, which isn't
> gonna be that common anyway.  Fancy locking always sucks.  The root
> cause of the problem is file removal ref draining from sysfs side and
> a proper solution should be implemented there.  Adding all this
> complexity to device hotplug lock won't solve problems involving other
> locks while obfuscating what's going on through all the complexity.
> Also, when sysfs is updated with a proper solution, a simpler
> workaround from device hotplug side would be far easier to convert to
> the new solution than this, which over time is likely to grow
> interesting uses.
> 
> Let's *please* stick to something simple.

OK, I'll use restart_syscall() approach in the simplest form, then.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
