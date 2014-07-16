Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbaGPAhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:37:22 -0400
Received: from mga14.intel.com ([192.55.52.115]:32801 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbaGPAhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:37:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,668,1400050800"; 
   d="scan'208";a="562361597"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH v2 0/9] ACPICA: Improve GPE handling model.
Thread-Topic: [PATCH v2 0/9] ACPICA: Improve GPE handling model.
Thread-Index: AQHPoCVaK5XZIbcaVUiqAHGe8EBlfZuh2YHg
Date: Wed, 16 Jul 2014 00:36:38 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026409FF@SHSMSX101.ccr.corp.intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com>
 <cover.1405306438.git.lv.zheng@intel.com> <1659923.7L0Vy69Ets@vostro.rjw.lan>
In-Reply-To: <1659923.7L0Vy69Ets@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6G0bRtp023125

Hi,

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Tuesday, July 15, 2014 8:26 PM
> 
> On Tuesday, July 15, 2014 11:07:10 AM Lv Zheng wrote:
> > This patchset enables the ideal GPE handling model. The ideal GPE handling
> > model should be able to handle the following cases:
> >
> >    1. When upper layers (the users of the driver) submit requests to the
> >       drivers, it means they care about the underlying hardware. For this
> >       case, acpi_enable_gpe() should be invoked. When the reference count
> >       is increased from 0 to 1, driver enables the hardware IRQ. And
> >       acpi_disable_gpe() is used as the reversal when the users have
> >       completed the submitted requests.
> >    2. Driver may temporarily disables the IRQ and wants to re-enable it
> >       later, this case is normally used in order to prevent IRQ storm.
> >       When a driver cannot fully solve the condition that triggered the IRQ
> >       in the IRQ context, in order not to trigger IRQ storm, driver has to
> >       disable IRQ and re-enables it in the deferred execution environment
> >       - which should be in a task context. The acpi_set_gpe() API should be
> >       used exactly for this purpose.
> >
> > The reason why this model hasn't been enabled for the current Linux ACPI
> > drivers is:
> >   In ACPICA, the same GPE lock is held while invoking the GPE handler
> >   callback, it's thus impossible to invoke GPE APIs in the GPE handler
> >   because the APIs require to hold the GPE lock. The recursive locking
> >   leads to dead locks. This is a simple design defect, callbacks should
> >   always be invoked in a lockless environment, normally in Linux, this is
> >   achieved by RCU locking, and in ACPICA, we achieve this using reference
> >   counting.
> >
> > After fixing the above bug and doing necessary cleanups in the ACPICA GPE
> > handling code, we now can enable this ideal GPE handling model for the EC
> > driver to implement "commands flushing" and "storm prevention" (the EC
> > driver enabling is not included in this patchset).
> 
> How this patch series is related to upstream ACPICA?  Is the design fixed
> already upstream?

It hasn't been upstreamed to the ACPICA repo.

This series has been sent to ACPICA upstream as a github pull request, reviewed by David Box.
We are waiting for it to be merged.

This series is required by the EC storm fix series.
I sent both the storm fix series and the linuxized GPE series here, so that we can examine a real OSPM example to see the effect of the new APIs.

Thanks and best regards
-Lv

> 
> > The refined patches are passed the runtime/suspend tests carried out on the
> > following platforms with EC driver enhanced:
> >   "Dell Inspiron Mini 1010" - i386 kernel
> >   "Dell Latitude 6430u" - x86_64 kernel
> >
> > Lv Zheng (9):
> >   ACPICA: Events: Reduce indent divergences of events files.
> >   ACPICA: Events: Fix an issue that GPE APIs cannot be invoked in
> >     atomic context.
> >   ACPICA: Events: Fix an issue that GPE APIs cannot be invoked in
> >     deferred handlers.
> >   ACPICA: Events: Introduce acpi_set_gpe()/acpi_finish_gpe() to reduce
> >     divergences.
> >   ACPICA: Events: Fix an issue that acpi_set_gpe() cannot
> >     unconditionally enable GPEs.
> >   ACPICA: Events: Fix an issue that status of GPEs are unexpectedly
> >     cleared.
> >   ACPICA: Events: Fix an issue that originally_enabled check is not
> >     paired.
> >   ACPICA: Events: Add a flag to disable internal auto GPE clearing.
> >   ACPI: Update interrupt handler to honor new ACPI_REENABLE_GPE bit.
> >
> >  drivers/acpi/acpica/acevents.h |    1 +
> >  drivers/acpi/acpica/aclocal.h  |    5 +-
> >  drivers/acpi/acpica/evgpe.c    |  136 +++++++++++++++++++++-------------------
> >  drivers/acpi/acpica/evxface.c  |   41 ++++++++----
> >  drivers/acpi/acpica/evxfgpe.c  |  105 +++++++++++++++++++++++++++++++
> >  drivers/acpi/osl.c             |    2 +-
> >  include/acpi/actypes.h         |   16 ++---
> >  7 files changed, 219 insertions(+), 87 deletions(-)
> >
> >
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
