Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbaGOMHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:07:25 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61282 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758628AbaGOMHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:07:20 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 0/9] ACPICA: Improve GPE handling model.
Date: Tue, 15 Jul 2014 14:25:33 +0200
Message-ID: <1659923.7L0Vy69Ets@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <cover.1405306438.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405306438.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 15, 2014 11:07:10 AM Lv Zheng wrote:
> This patchset enables the ideal GPE handling model. The ideal GPE handling
> model should be able to handle the following cases:
> 
>    1. When upper layers (the users of the driver) submit requests to the
>       drivers, it means they care about the underlying hardware. For this
>       case, acpi_enable_gpe() should be invoked. When the reference count
>       is increased from 0 to 1, driver enables the hardware IRQ. And
>       acpi_disable_gpe() is used as the reversal when the users have
>       completed the submitted requests.
>    2. Driver may temporarily disables the IRQ and wants to re-enable it
>       later, this case is normally used in order to prevent IRQ storm.
>       When a driver cannot fully solve the condition that triggered the IRQ
>       in the IRQ context, in order not to trigger IRQ storm, driver has to
>       disable IRQ and re-enables it in the deferred execution environment
>       - which should be in a task context. The acpi_set_gpe() API should be
>       used exactly for this purpose.
> 
> The reason why this model hasn't been enabled for the current Linux ACPI
> drivers is:
>   In ACPICA, the same GPE lock is held while invoking the GPE handler
>   callback, it's thus impossible to invoke GPE APIs in the GPE handler
>   because the APIs require to hold the GPE lock. The recursive locking
>   leads to dead locks. This is a simple design defect, callbacks should
>   always be invoked in a lockless environment, normally in Linux, this is
>   achieved by RCU locking, and in ACPICA, we achieve this using reference
>   counting.
> 
> After fixing the above bug and doing necessary cleanups in the ACPICA GPE
> handling code, we now can enable this ideal GPE handling model for the EC
> driver to implement "commands flushing" and "storm prevention" (the EC
> driver enabling is not included in this patchset).

How this patch series is related to upstream ACPICA?  Is the design fixed
already upstream?

> The refined patches are passed the runtime/suspend tests carried out on the
> following platforms with EC driver enhanced:
>   "Dell Inspiron Mini 1010" - i386 kernel
>   "Dell Latitude 6430u" - x86_64 kernel
> 
> Lv Zheng (9):
>   ACPICA: Events: Reduce indent divergences of events files.
>   ACPICA: Events: Fix an issue that GPE APIs cannot be invoked in
>     atomic context.
>   ACPICA: Events: Fix an issue that GPE APIs cannot be invoked in
>     deferred handlers.
>   ACPICA: Events: Introduce acpi_set_gpe()/acpi_finish_gpe() to reduce
>     divergences.
>   ACPICA: Events: Fix an issue that acpi_set_gpe() cannot
>     unconditionally enable GPEs.
>   ACPICA: Events: Fix an issue that status of GPEs are unexpectedly
>     cleared.
>   ACPICA: Events: Fix an issue that originally_enabled check is not
>     paired.
>   ACPICA: Events: Add a flag to disable internal auto GPE clearing.
>   ACPI: Update interrupt handler to honor new ACPI_REENABLE_GPE bit.
> 
>  drivers/acpi/acpica/acevents.h |    1 +
>  drivers/acpi/acpica/aclocal.h  |    5 +-
>  drivers/acpi/acpica/evgpe.c    |  136 +++++++++++++++++++++-------------------
>  drivers/acpi/acpica/evxface.c  |   41 ++++++++----
>  drivers/acpi/acpica/evxfgpe.c  |  105 +++++++++++++++++++++++++++++++
>  drivers/acpi/osl.c             |    2 +-
>  include/acpi/actypes.h         |   16 ++---
>  7 files changed, 219 insertions(+), 87 deletions(-)
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
