Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbaDXQuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:50:25 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58334 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932521AbaDXQtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:49:41 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mantas =?utf-8?B?TWlrdWzEl25hcw==?= <grawity@gmail.com>,
        Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Len Brown <lenb@kernel.org>, Robert Moore <robert.moore@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Media keys cause "ACPI: \_SB_.ATKD: Unsupported event" on ASUS laptop
Date: Thu, 24 Apr 2014 19:06:03 +0200
Message-ID: <2689604.Irr3FKRzyq@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAPWNY8X3fVAM3kcdWmg0BcQuNw84ROY+wQsh-JzfxGEt1uWFQQ@mail.gmail.com>
References: <liocsk$le0$1@ger.gmane.org> <2784123.GhF2tcctEM@vostro.rjw.lan> <CAPWNY8X3fVAM3kcdWmg0BcQuNw84ROY+wQsh-JzfxGEt1uWFQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 24, 2014 04:31:19 PM Mantas Mikulėnas wrote:
> On Thu, Apr 24, 2014 at 1:51 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Thursday, April 24, 2014 06:21:52 AM Sitsofe Wheeler wrote:
> >> On Thu, Apr 17, 2014 at 02:11:15PM +0300, Mantas Mikulėnas wrote:
> >> > After commit 1a699476e258 [two months ago], Linux has stopped
> >> > recognizing the media & function keys on my laptop's keyboard (the
> >> > laptop is ASUS K52JT.206).
> >> >
> >> > When I press any of the Fn keys (Play/Pause, Stop, Prev, Next, Vol+,
> >> > Vol-, Mute, WiFi, Brightness +/-...), I get the following messages in dmesg:
> >> >
> >> > | ACPI: \_SB_.ATKD: Unsupported event type 0x45
> >> > | ACPI: \_SB_.ATKD: Unsupported event type 0x43
> >> > | ACPI: \_SB_.ATKD: Unsupported event type 0x40
> >> > | etc.
> >>
> >> I'm seeing the same problem with an EeePC 900's volume and brightness
> >> keys:
> >> [ 90.098518] ACPI: \_SB_.ATKD: Unsupported event type 0x14
> >> [   90.785202] ACPI: \_SB_.ATKD: Unsupported event type 0x15
> >> [  457.062072] ACPI: \_SB_.ATKD: Unsupported event type 0x2e
> >> [  457.926754] ACPI: \_SB_.ATKD: Unsupported event type 0x2d
> >> [  458.418740] ACPI: \_SB_.ATKD: Unsupported event type 0x2c
> >> [  458.821482] ACPI: \_SB_.ATKD: Unsupported event type 0x2b
> >> [  459.240896] ACPI: \_SB_.ATKD: Unsupported event type 0x2a
> >
> > Does this patch help:
> >
> > ---
> >  drivers/acpi/bus.c |    5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> Yes, it seems to be working fine.

OK, thanks for verifying, below it goes with a changelog and tags.

Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / notify: Do not block unknown type notifications in root handler

Commit 1a699476e258 "ACPI / hotplug / PCI: Hotplug notifications from
acpi_bus_notify()" changed the root notify handler, acpi_bus_notify(),
to block unknown type norifications, but it overlooked the fact that
they might be propagated to drivers via the ->notify() callback.

Fix the problem by allowing drivers to receive unknown type
notifications via ->notify() as before.

Reported-and-tested-by: Mantas Mikulėnas <grawity@gmail.com>
Reported-and-tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/bus.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-pm/drivers/acpi/bus.c
===================================================================
--- linux-pm.orig/drivers/acpi/bus.c
+++ linux-pm/drivers/acpi/bus.c
@@ -380,9 +380,8 @@ static void acpi_bus_notify(acpi_handle
 		break;
 
 	default:
-		acpi_handle_warn(handle, "Unsupported event type 0x%x\n", type);
-		ost_code = ACPI_OST_SC_UNRECOGNIZED_NOTIFY;
-		goto err;
+		acpi_handle_debug(handle, "Unknown event type 0x%x\n", type);
+		break;
 	}
 
 	adev = acpi_bus_get_acpi_device(handle);

