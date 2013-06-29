Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab3F2LGe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 07:06:34 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54932 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab3F2LGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 07:06:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: [PATCH 1/3] ACPI / dock: Rework the handling of notifications
Date: Sat, 29 Jun 2013 13:16:01 +0200
Message-ID: <2193112.vKUrhiifXu@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQU8Zwm+8nrT4Sg9h7_P-YVNamg+udLjVaZ0PyNmm-t7bg@mail.gmail.com>
References: <1640211.P0jyS5muX2@vostro.rjw.lan> <1771749.8rDXNf8giR@vostro.rjw.lan> <CAE9FiQU8Zwm+8nrT4Sg9h7_P-YVNamg+udLjVaZ0PyNmm-t7bg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 28, 2013 04:34:21 PM Yinghai Lu wrote:
> On Fri, Jun 28, 2013 at 3:53 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > The ACPI dock driver uses register_acpi_bus_notifier() which
> > installs a notifier triggered globally for all system notifications.
> > That first of all is inefficient, because the dock driver is only
> > interested in notifications associated with the devices it handles,
> > but it has to handle all system notifies for all devices.  Moreover,
> > it does that even if no docking stations are present in the system
> > (CONFIG_ACPI_DOCK set is sufficient for that to happen).  Besides,
> > that is inconvenient, because it requires the driver to do extra work
> > for each notification to find the target dock station object.
> >
> > For these reasons, rework the dock driver to install a notify
> > handler individually for each dock station in the system using
> > acpi_install_notify_handler().  This allows the dock station
> > object to be passed directly to the notify handler and makes it
> > possible to simplify the dock driver quite a bit.  It also
> > reduces the overhead related to the handling of all system
> > notifies when CONFIG_ACPI_DOCK is set.
> 
> original change to use register_acpi_bus_notifier, have two assumption
> 1.  two dock_station will have same handle.

Well, that would mean that dock_add() might be called twice for the same handle
and I don't see how that's possible.

Moreover, even if that were possible, the loop in acpi_dock_notifier_call()
would break after finding the *first* matching handle anyway, so
acpi_dock_deferred_cb() wouldn't be called for the second dock station with
the same handle, if there were two.

> 2. acpi subsystem: non root acpi device only can have one system
> notifier installed.

No, that limitation is long gone.  We removed it when we were working on ACPI
wakeup support for runtime PM.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
