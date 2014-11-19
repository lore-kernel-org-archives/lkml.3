Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaKSAkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 19:40:33 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62951 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754538AbaKSAkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 19:40:31 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Benson Leung <bleung@chromium.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: do not fail suspend if unable to configure wakeup
Date: Wed, 19 Nov 2014 02:01:35 +0100
Message-ID: <4442123.5JIyjOW8pr@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAE_wzQ_keT0zm0iV=S3gM9r94bM73E5kFpbWX85AckRVcC6KSQ@mail.gmail.com>
References: <20141015225657.GA818@dtor-ws> <1863054.8ksDvip1yp@vostro.rjw.lan> <CAE_wzQ_keT0zm0iV=S3gM9r94bM73E5kFpbWX85AckRVcC6KSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 18, 2014 04:14:49 PM Dmitry Torokhov wrote:
> On Tue, Nov 18, 2014 at 4:20 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > It goes again below with a changelog, but since technically it is a regression
> > fix, I'd like to push it for "stable" too.  I suppose that the commit that
> > things stopped working after is a76e9bd89ae7 (i2c: attach/detach I2C client
> > device to the ACPI power domain).  Is that correct?
> 
> Yes.

OK

> > --
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: ACPI / PM: Ignore wakeup setting if the ACPI companion can't wake up
> >
> > As reported by Dmitry, on some Chromebooks there are devices with
> > corresponding ACPI objects and with unusual system wakeup
> > configuration.  Namely, they technically are wakeup-capable, but the
> > wakeup is handled via a platform-specific out-of-band mechanism
> > rather than by standard ACPI means.
> 
> I think they are using standard ACPI wakeup methods, but in a very perverted
> way: there is "shadow" ACPI sleep button corresponding to the GPIO assigned
> to the trackpad or touchscreen; it is just not tied to touchpad/touchscreen
> device in DSDT.

OK

This:

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / PM: Ignore wakeup setting if the ACPI companion can't wake up

As reported by Dmitry, on some Chromebooks there are devices with
corresponding ACPI objects and with unusual system wakeup
configuration.  Namely, they technically are wakeup-capable, but the
wakeup is handled via a platform-specific out-of-band mechanism and
the ACPI PM layer has no information on the wakeup capability.  As
a result, device_may_wakeup(dev) called from acpi_dev_suspend_late()
returns 'true' for those devices, but the wakeup.flags.valid flag is
unset for the corresponding ACPI device objects, so acpi_device_wakeup()
reproducibly fails for them causing acpi_dev_suspend_late() to return
an error code.  The entire system suspend is then aborted and the
machines in question cannot suspend at all.

Address the problem by ignoring the device_may_wakeup(dev) return
value in acpi_dev_suspend_late() if the ACPI companion of the device
being handled has wakeup.flags.valid unset (in which case it is clear
that the wakeup is supposed to be handled by other means).

This fixes a regression introduced by commit a76e9bd89ae7 (i2c:
attach/detach I2C client device to the ACPI power domain) as the
affected systems could suspend and resume successfully before that
commit.

Fixes: a76e9bd89ae7 (i2c: attach/detach I2C client device to the ACPI power domain)
Reported-by: Dmitry Torokhov <dtor@chromium.org>
Cc: 3.13+ <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -878,7 +878,7 @@ int acpi_dev_suspend_late(struct device
 		return 0;
 
 	target_state = acpi_target_system_state();
-	wakeup = device_may_wakeup(dev);
+	wakeup = device_may_wakeup(dev) && acpi_device_can_wakeup(adev);
 	error = acpi_device_wakeup(adev, target_state, wakeup);
 	if (wakeup && error)
 		return error;

