Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab3F1TzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:55:23 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54419 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab3F1TzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:55:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        John Ronciak <john.ronciak@intel.com>,
        Miles J Penner <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 4/6] PCI: acpiphp: check for new devices on enabled host
Date: Fri, 28 Jun 2013 22:04:53 +0200
Message-ID: <2663158.JAQPAXHTm9@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQUQvVbcbWoBnSiNmtF6P_SHTqWYONzfa-WeQUDYPmvHYw@mail.gmail.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com> <20130628093319.D4DE6E0090@blue.fi.intel.com> <CAE9FiQUQvVbcbWoBnSiNmtF6P_SHTqWYONzfa-WeQUDYPmvHYw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 28, 2013 09:22:32 AM Yinghai Lu wrote:
> On Fri, Jun 28, 2013 at 2:33 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > Yinghai Lu wrote:
> >> On Tue, Jun 25, 2013 at 9:22 AM, Mika Westerberg
> >> <mika.westerberg@linux.intel.com> wrote:
> >> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >> >
> >> > Current acpiphp_check_bridge() implementation is pretty dumb:
> >> >  - it enables the slot if it's not enabled and the slot status is
> >> >    ACPI_STA_ALL;
> >> >  - it disables the slot if it's enabled and slot is not in ACPI_STA_ALL
> >> >    state.
> >> >
> >> > This behavior is not enough to handle Thunderbolt chaining case
> >> > properly. We need to actually rescan for new devices even if a device
> >> > has already in the slot.
> >> >
> >> > The new implementation disables and stops the slot if it's not in
> >> > ACPI_STA_ALL state.
> >> >
> >> > For ACPI_STA_ALL state we first trim devices which don't respond and
> >> > look for the ones after that. We do that even if slot already enabled
> >> > (SLOT_ENABLED).
> >>
> >> that is not right, some time BUS_CHECK is even sent root bus.
> >> in that case, stop all devices in slots and load driver again.
> >>
> >> like you put one card in one slots, but all devices in other slots get stop
> >> and enable again.
> >
> > We don't stop enabled devices, we only stop and remove devices which don't
> > respond.  See patch 3/6.
> >
> > I don't see how it's harmful. Do you?
> 
> then please check with disable_device to put back pci_dev ref,
> also may need to trim corresponding acpi devices.

That's correct.  Thunderbolt may not need that, but ACPI device objects need
to be trimmed too in general.

> so this patch is helping: multiple plug-in and remove?

I think it helps the case when a Thunderbolt device is removed and we only
get a bus check notify for the controller after the fact.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
