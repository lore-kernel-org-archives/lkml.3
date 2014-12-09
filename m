Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbaLIJIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:08:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbaLIJIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:08:46 -0500
Date: Tue, 9 Dec 2014 10:08:43 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] Drivers: hv: balloon: Fix the deadlock issue in the
 memory hot-add code
Message-ID: <20141209090843.GA11373@dhcp22.suse.cz>
References: <1417826471-21131-1-git-send-email-kys@microsoft.com>
 <1417826498-21172-1-git-send-email-kys@microsoft.com>
 <1417826498-21172-2-git-send-email-kys@microsoft.com>
 <20141208150445.GB29102@dhcp22.suse.cz>
 <54864F27.8010008@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54864F27.8010008@jp.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-12-14 10:23:51, Yasuaki Ishimatsu wrote:
> (2014/12/09 0:04), Michal Hocko wrote:
> >On Fri 05-12-14 16:41:38, K. Y. Srinivasan wrote:
> >>Andy Whitcroft <apw@canonical.com> initially saw this deadlock. We
> >>have seen this as well. Here is the original description of the
> >>problem (and a potential solution) from Andy:
> >>
> >>https://lkml.org/lkml/2014/3/14/451
> >>
> >>Here is an excerpt from that mail:
> >>
> >>"We are seeing machines lockup with what appears to be an ABBA
> >>deadlock in the memory hotplug system.  These are from the 3.13.6 based Ubuntu kernels.
> >>The hv_balloon driver is adding memory using add_memory() which takes
> >>the hotplug lock
> >
> >Do you mean mem_hotplug_begin?
> >
> 
> >>and then emits a udev event, and then attempts to
> >>lock the sysfs device.  In response to the udev event udev opens the
> >>sysfs device and locks it, then attempts to grab the hotplug lock to online the memory.
> >
> >Cannot we simply teach online_pages to fail with EBUSY when the memory
> >hotplug is on the way.  We shouldn't try to online something that is not
> >initialized yet, no?
> 
> Yes. Memory online shouldn't try before initializing it. Then memory online
> should wait for initializing it, not easily fails. Generally, kernel sends
> memory ONLINE event to userland by kobject_uevent() during initializing memory
> and udev makes memory online after catching the event. Onlining memory by
> udev almost run during initializing memory.

I guess this is because the event is sent after a mem section is
initialized while the overal hotplug operation is still not completed.

> So if memory online easily fails, onlining memory by udev almost
> fails.

Doesn't udev retry the operation if it gets EBUSY or EAGAIN?

> >The memory hotplug log is global so we can get
> >false positives but that should be easier to deal with than exporting
> >lock_device_hotplug and adding yet another lock dependency.
> >
> >>This seems to be inverted nesting in the two cases, leading to the hangs below:
> >>
> >>[  240.608612] INFO: task kworker/0:2:861 blocked for more than 120 seconds.
> >>[  240.608705] INFO: task systemd-udevd:1906 blocked for more than 120 seconds.
> >>
> >>I note that the device hotplug locking allows complete retries (via
> >>ERESTARTSYS) and if we could detect this at the online stage it could
> >>be used to get us out.
> >
> >I am not sure I understand this but it suggests EBUSY above?
> >
> >>But before I go down this road I wanted to
> >>make sure I am reading this right.  Or indeed if the hv_balloon driver
> >>is just doing this wrong."
> >>
> >>This patch is based on the suggestion from
> >>Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> >
> >This changelog doesn't explain us much. And boy this whole thing is so
> >convoluted. E.g. I have hard time to see why ACPI hotplug is working
> >correctly. My trail got lost at acpi_memory_device_add level which is
> >a callback while acpi_device_hotplug is holding lock_device_hotplug but
> >then again the rest is hidden by callbacks.
> 
> Commit 0f1cfe9d0d06 (mm/hotplug: remove stop_machine() from try_offline_node()) said:
> 
>   ---
>     lock_device_hotplug() serializes hotplug & online/offline operations.  The
>     lock is held in common sysfs online/offline interfaces and ACPI hotplug
>     code paths.
> 
>     And here are the code paths:
> 
>     - CPU & Mem online/offline via sysfs online
>         store_online()->lock_device_hotplug()
> 
>     - Mem online via sysfs state:
>         store_mem_state()->lock_device_hotplug()
> 
>     - ACPI CPU & Mem hot-add:
>         acpi_scan_bus_device_check()->lock_device_hotplug()
> 
>     - ACPI CPU & Mem hot-delete:
>         acpi_scan_hot_remove()->lock_device_hotplug()
>   ---
> 
> CPU & Memory online/offline/hotplug are serialized by lock_device_hotplug().

OK, this patch aimed at the complete nodes hotplug. I am not familiar
with the code enough to tell whether this is really needed but it sounds
like an overkill when we are interested only in the memory hotplug. Why
would we need stop_machine or anything for memory that is guaranteed to
be not used at the time of both online and offline.
And again, why cannot we simply make the onlining fail or try_lock and
retry internally if the event consumer cannot cope with errors?
And even if that is not possible then do not export lock_device_hotplug
but export a memory hotplug functions which use it properly so that
other consumers (xen ballon seem to rely on add_memory as well) do not
need the same change as well.

> >I cannot seem to find any documentation which would explain all the
> >locking here.
> 
> Yes. I need the documentation.

Yes please! This code is incredibly hard to follow and deduce all the
hidden requirements and dependencies is even harder.
-- 
Michal Hocko
SUSE Labs
