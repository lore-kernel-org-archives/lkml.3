Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3FOUIa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 16:08:30 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38638 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab3FOUI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 16:08:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [BUGFIX v2 2/4] ACPI, DOCK: resolve possible deadlock scenarios
Date: Sat, 15 Jun 2013 22:17:42 +0200
Message-ID: <8974656.5GmDyxHW7F@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51BBC6FC.2020002@gmail.com>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com> <8220093.o4hXWiX0st@vostro.rjw.lan> <51BBC6FC.2020002@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 15, 2013 09:44:28 AM Jiang Liu wrote:
> On Sat 15 Jun 2013 06:21:02 AM CST, Rafael J. Wysocki wrote:
> > On Saturday, June 15, 2013 03:27:59 AM Jiang Liu wrote:
> >> This is a preparation for next patch to avoid breaking bisecting.
> >> If next patch is applied without this one, it will cause deadlock
> >> as below:
> >>
> >> Case 1:
> >> [   31.015593]  Possible unsafe locking scenario:
> >>
> >> [   31.018350]        CPU0                    CPU1
> >> [   31.019691]        ----                    ----
> >> [   31.021002]   lock(&dock_station->hp_lock);
> >> [   31.022327]                                lock(&slot->crit_sect);
> >> [   31.023650]                                lock(&dock_station->hp_lock);
> >> [   31.025010]   lock(&slot->crit_sect);
> >> [   31.026342]
> >>
> >> Case 2:
> >>         hotplug_dock_devices()
> >>                 mutex_lock(&ds->hp_lock)
> >>                         dd->ops->handler()
> >>                                 register_hotplug_dock_device()
> >>                                         mutex_lock(&ds->hp_lock)
> >> [   34.316570] [ INFO: possible recursive locking detected ]
> >> [   34.316573] 3.10.0-rc4 #6 Tainted: G         C
> >> [   34.316575] ---------------------------------------------
> >> [   34.316577] kworker/0:0/4 is trying to acquire lock:
> >> [   34.316579]  (&dock_station->hp_lock){+.+.+.}, at:
> >> [<ffffffff813c766b>] register_hotplug_dock_device+0x6a/0xbf
> >> [   34.316588]
> >> but task is already holding lock:
> >> [   34.316590]  (&dock_station->hp_lock){+.+.+.}, at:
> >> [<ffffffff813c7270>] hotplug_dock_devices+0x2c/0xda
> >> [   34.316595]
> >> other info that might help us debug this:
> >> [   34.316597]  Possible unsafe locking scenario:
> >>
> >> [   34.316599]        CPU0
> >> [   34.316601]        ----
> >> [   34.316602]   lock(&dock_station->hp_lock);
> >> [   34.316605]   lock(&dock_station->hp_lock);
> >> [   34.316608]
> >>  *** DEADLOCK ***
> >>
> >> So fix this deadlock by not taking ds->hp_lock in function
> >> register_hotplug_dock_device(). This patch also fixes a possible
> >> race conditions in function dock_event() because previously it
> >> accesses ds->hotplug_devices list without holding ds->hp_lock.
> >>
> >> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> >> Cc: Len Brown <lenb@kernel.org>
> >> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> >> Cc: Bjorn Helgaas <bhelgaas@google.com>
> >> Cc: Yinghai Lu <yinghai@kernel.org>
> >> Cc: Yijing Wang <wangyijing@huawei.com>
> >> Cc: linux-acpi@vger.kernel.org
> >> Cc: linux-kernel@vger.kernel.org
> >> Cc: linux-pci@vger.kernel.org
> >> Cc: <stable@vger.kernel.org> # 3.8+
> >> ---
> >>  drivers/acpi/dock.c                | 109 ++++++++++++++++++++++---------------
> >>  drivers/pci/hotplug/acpiphp_glue.c |  15 +++++
> >>  include/acpi/acpi_drivers.h        |   2 +
> >>  3 files changed, 82 insertions(+), 44 deletions(-)
> >>
> >> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> >> index 02b0563..602bce5 100644
> >> --- a/drivers/acpi/dock.c
> >> +++ b/drivers/acpi/dock.c
> >> @@ -66,7 +66,7 @@ struct dock_station {
> >>  	spinlock_t dd_lock;
> >>  	struct mutex hp_lock;
> >>  	struct list_head dependent_devices;
> >> -	struct list_head hotplug_devices;
> >> +	struct klist hotplug_devices;
> >>
> >>  	struct list_head sibling;
> >>  	struct platform_device *dock_device;
> >> @@ -76,12 +76,18 @@ static int dock_station_count;
> >>
> >>  struct dock_dependent_device {
> >>  	struct list_head list;
> >> -	struct list_head hotplug_list;
> >> +	acpi_handle handle;
> >> +};
> >> +
> >> +struct dock_hotplug_info {
> >> +	struct klist_node node;
> >>  	acpi_handle handle;
> >>  	const struct acpi_dock_ops *ops;
> >>  	void *context;
> >>  };
> >
> > Can we please relax a bit and possibly take a step back?
> >
> > So since your last reply to me wasn't particularly helpful, I went through the
> > code in dock.c and acpiphp_glue.c and I simply think that the whole
> > hotplug_list thing is simply redundant.
> >
> > It looks like instead of using it (or the klist in this patch), we can add a
> > "hotlpug_device" flag to dock_dependent_device and set that flag instead of
> > adding dd to hotplug_devices or clear it instead of removing dd from that list.
> >
> > That would allow us to avoid the deadlock, because we wouldn't need the hp_lock
> > any more and perhaps we could make the code simpler instead of making it more
> > complex.
> >
> > How does that sound?
> >
> > Rafael
> Hi Rafael,
>        Thanks for comments! It would be great if we could kill the 
> hotplug_devices
> list so thing gets simple. But there are still some special cases:(
> 
> As you have mentioned,  ds->hp_lock is used to make both addition and 
> removal
> of hotplug devices wait for us to complete walking ds->hotplug_devices.
> So it acts as two roles:
> 1) protect the hotplug_devices list,
> 2) serialize unregister_hotplug_dock_device() and 
> hotplug_dock_devices() so
> the dock driver doesn't access registered handler and associated data 
> structure
> once returing from unregister_hotplug_dock_device().

When it returns from unregister_hotplug_dock_device(), nothing prevents it
from accessing whatever it wants, because ds->hp_lock is not used outside
of the add/del and hotplug_dock_devices().  So, the actual role of
ds->hp_lock (not the one that it is supposed to play, but the real one)
is to prevent addition/deletion from happening when hotplug_dock_devices()
is running.  [Yes, it does protect the list, but since the list is in fact
unnecessary, that doesn't matter.]

> If we simply use a flag to mark presence of registered callback, we 
> can't achieve the second goal.

I don't mean using the flag *alone*.

> Take the sony laptop as an example. It has several PCI 
> hotplug
> slot associated with the dock station:
> [   28.829316] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> notify on \_SB_.PCI0.RP07.LPMB
> [   30.174964] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> notify on \_SB_.PCI0.RP07.LPMB.LPM0
> [   30.174973] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> notify on \_SB_.PCI0.RP07.LPMB.LPM1
> [   30.174979] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> notify on \_SB_.PCI0.RP07.LPMB.LPM2
> [   30.174985] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> notify on \_SB_.PCI0.RP07.LPMB.LPM2.LPRI.LPR0.GFXA
> [   30.175020] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> notify on \_SB_.PCI0.RP07.LPMB.LPM2.LPRI.LPR0.GHDA
> [   30.175040] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> notify on \_SB_.PCI0.RP07.LPMB.LPM2.LPRI.LPR1.LPCI.LPC0.DLAN
> [   30.175050] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> notify on \_SB_.PCI0.RP07.LPMB.LPM2.LPRI.LPR1.LPCI.LPC1.DODD
> [   30.175060] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> notify on \_SB_.PCI0.RP07.LPMB.LPM2.LPRI.LPR1.LPCI.LPC2.DUSB
> 
> So it still has some race windows if we undock the station while 
> repeatedly rescanning/removing
> the PCI bus for \_SB_.PCI0.RP07.LPMB.LPM0 through sysfs interfaces. For 
> example, thread 1 is
> handling undocking event, walking the dependent device list and 
> invoking registered callback
> handler with associated data. While that, thread 2 may step in to 
> unregister the callback for
>  \_SB_.PCI0.RP07.LPMB.LPM0. Then thread 1 may cause access-after-free 
> issue.

That should be handled in acpiphp_glue instead of dock.  What you're trying to
do is to make dock work around synchronization issues in the acpiphp driver.

> The klist patch solves this issue by adding a "put" callback method to 
> explicitly notify
> dock client that the dock core has done with previously registered 
> handler and associated
> data.

Honestly, don't you think this is overly compilcated?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
