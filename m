Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab3FQMpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:45:34 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40230 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab3FQMpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:45:32 -0400
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
Date: Mon, 17 Jun 2013 14:54:49 +0200
Message-ID: <1772508.cyctAa8VtK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <27452260.5ySAzSUIS7@vostro.rjw.lan>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com> <51BDEF7F.1070107@gmail.com> <27452260.5ySAzSUIS7@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 17, 2013 01:39:04 PM Rafael J. Wysocki wrote:
> On Monday, June 17, 2013 01:01:51 AM Jiang Liu wrote:
> > On 06/16/2013 05:20 AM, Rafael J. Wysocki wrote:
> > > On Saturday, June 15, 2013 10:17:42 PM Rafael J. Wysocki wrote:
> > >> On Saturday, June 15, 2013 09:44:28 AM Jiang Liu wrote:
> > [...]
> > >> When it returns from unregister_hotplug_dock_device(), nothing prevents it
> > >> from accessing whatever it wants, because ds->hp_lock is not used outside
> > >> of the add/del and hotplug_dock_devices().  So, the actual role of
> > >> ds->hp_lock (not the one that it is supposed to play, but the real one)
> > >> is to prevent addition/deletion from happening when hotplug_dock_devices()
> > >> is running.  [Yes, it does protect the list, but since the list is in fact
> > >> unnecessary, that doesn't matter.]
> > >>
> > >>> If we simply use a flag to mark presence of registered callback, we 
> > >>> can't achieve the second goal.
> > >>
> > >> I don't mean using the flag *alone*.
> > >>
> > >>> Take the sony laptop as an example. It has several PCI 
> > >>> hotplug
> > >>> slot associated with the dock station:
> > >>> [   28.829316] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> > >>> notify on \_SB_.PCI0.RP07.LPMB
> > >>> [   30.174964] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> > >>> notify on \_SB_.PCI0.RP07.LPMB.LPM0
> > >>> [   30.174973] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> > >>> notify on \_SB_.PCI0.RP07.LPMB.LPM1
> > >>> [   30.174979] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> > >>> notify on \_SB_.PCI0.RP07.LPMB.LPM2
> > >>> [   30.174985] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> > >>> notify on \_SB_.PCI0.RP07.LPMB.LPM2.LPRI.LPR0.GFXA
> > >>> [   30.175020] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> > >>> notify on \_SB_.PCI0.RP07.LPMB.LPM2.LPRI.LPR0.GHDA
> > >>> [   30.175040] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> > >>> notify on \_SB_.PCI0.RP07.LPMB.LPM2.LPRI.LPR1.LPCI.LPC0.DLAN
> > >>> [   30.175050] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> > >>> notify on \_SB_.PCI0.RP07.LPMB.LPM2.LPRI.LPR1.LPCI.LPC1.DODD
> > >>> [   30.175060] acpiphp_glue: _handle_hotplug_event_func: Bus check 
> > >>> notify on \_SB_.PCI0.RP07.LPMB.LPM2.LPRI.LPR1.LPCI.LPC2.DUSB
> > >>>
> > >>> So it still has some race windows if we undock the station while 
> > >>> repeatedly rescanning/removing
> > >>> the PCI bus for \_SB_.PCI0.RP07.LPMB.LPM0 through sysfs interfaces.
> > > 
> > > Which sysfs interfaces do you mean, by the way?
> > > 
> > > If you mean "eject", then it takes acpi_scan_lock and hotplug_dock_devices()
> > > should always be run under acpi_scan_lock too.  It isn't at the moment,
> > > because write_undock() doesn't take acpi_scan_lock(), but this is an obvious
> > > bug (so I'm going to send a patch to fix it in a while).
> > > 
> > > With that bug fixed, the possible race between acpi_eject_store() and
> > > hotplug_dock_devices() should be prevented from happening, so perhaps we're
> > > worrying about something that cannot happen?
> > Hi Rafael,
> > 	I mean the "remove" method of each PCI device, and the "power" method
> > of PCI hotplug slot here.
> > 	These methods may be used to remove P2P bridges with associated ACPIPHP
> > hotplug slots, which in turn will cause invoking of
> > unregister_hotplug_dock_device().
> > 	So theoretical we may trigger the bug by undocking while repeatedly
> > adding/removing P2P bridges with ACPIPHP hotplug slot through PCI
> > "rescan" and "remove" sysfs interface,
> 
> Why don't we make these things take acpi_scan_lock upfront, then?

Or perhaps (and maybe better) why don't we replace ds->hp_lock by another
lock that will be acquired upper in the call chain so that
dock_add_hotplug_device(), dock_del_hotplug_device(), hotplug_dock_devices()
and dock_event() are all guaranteed to be called under that lock?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
