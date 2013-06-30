Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab3F3OJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 10:09:15 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55676 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab3F3OJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 10:09:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: [PATCH 1/3] ACPI / dock: Rework the handling of notifications
Date: Sun, 30 Jun 2013 16:18:42 +0200
Message-ID: <1494881.y5W1zydDGl@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQXc9WKDZdABOB8p0soT+OTcRbJb7JTgrPz6ffd2dyPEHA@mail.gmail.com>
References: <1640211.P0jyS5muX2@vostro.rjw.lan> <2193112.vKUrhiifXu@vostro.rjw.lan> <CAE9FiQXc9WKDZdABOB8p0soT+OTcRbJb7JTgrPz6ffd2dyPEHA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 29, 2013 09:12:59 AM Yinghai Lu wrote:
> On Sat, Jun 29, 2013 at 4:16 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, June 28, 2013 04:34:21 PM Yinghai Lu wrote:
> >> On Fri, Jun 28, 2013 at 3:53 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> >
> >> > The ACPI dock driver uses register_acpi_bus_notifier() which
> >> > installs a notifier triggered globally for all system notifications.
> >> > That first of all is inefficient, because the dock driver is only
> >> > interested in notifications associated with the devices it handles,
> >> > but it has to handle all system notifies for all devices.  Moreover,
> >> > it does that even if no docking stations are present in the system
> >> > (CONFIG_ACPI_DOCK set is sufficient for that to happen).  Besides,
> >> > that is inconvenient, because it requires the driver to do extra work
> >> > for each notification to find the target dock station object.
> >> >
> >> > For these reasons, rework the dock driver to install a notify
> >> > handler individually for each dock station in the system using
> >> > acpi_install_notify_handler().  This allows the dock station
> >> > object to be passed directly to the notify handler and makes it
> >> > possible to simplify the dock driver quite a bit.  It also
> >> > reduces the overhead related to the handling of all system
> >> > notifies when CONFIG_ACPI_DOCK is set.
> >>
> >> original change to use register_acpi_bus_notifier, have two assumption
> >> 1.  two dock_station will have same handle.
> >
> > Well, that would mean that dock_add() might be called twice for the same handle
> > and I don't see how that's possible.
> >
> > Moreover, even if that were possible, the loop in acpi_dock_notifier_call()
> > would break after finding the *first* matching handle anyway, so
> > acpi_dock_deferred_cb() wouldn't be called for the second dock station with
> > the same handle, if there were two.
> 
> related commit:
> commit 6bd00a61ab63d4ceb635ae0316353c11c900b8d8
> Author: Shaohua Li <shaohua.li@intel.com>
> Date:   Thu Aug 28 10:04:29 2008 +0800
> 
>     ACPI: introduce notifier change to avoid duplicates
> 
>     The battery driver already registers notification handler.
>     To avoid registering notification handler again,
>     introduce a notifier chain in global system notifier handler
>     and use it in dock driver.
> 
> so it is not two dock station have same handle. it is battery acpi driver.
> 
> but notitifer installing is changed
> 
> commit d94066910943837558d2a461c6766da981260bf0
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Thu Apr 30 09:35:47 2009 -0600
> 
>     ACPI: battery: use .notify method instead of installing handler directly
> 
>     This patch adds a .notify() method.  The presence of .notify() causes
>     Linux/ACPI to manage event handlers and notify handlers on our behalf,
>     so we don't have to install and remove them ourselves.
> 
>     This driver apparently relies on seeing ALL notify events, not just
>     device-specific ones (because it used ACPI_ALL_NOTIFY).  We use the
>     ACPI_DRIVER_ALL_NOTIFY_EVENTS driver flag to request all events.
> 
>     Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>     CC: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> 
> >
> >> 2. acpi subsystem: non root acpi device only can have one system
> >> notifier installed.
> >
> > No, that limitation is long gone.  We removed it when we were working on ACPI
> > wakeup support for runtime PM.
> 
> looks like i misread that...
> 
>  * NOTES:       The Root namespace object may have only one handler for each
>  *              type of notify (System/Device). Device/Thermal/Processor objects
>  *              may have one device notify handler, and multiple system notify
>  *              handlers.
> 
> device could have multiple system notify handlers.
> 
> So
> 
> Acked-by: Yinghai Lu <yinghai@kernel.org>

Thanks (and for the other ACKs too)!

