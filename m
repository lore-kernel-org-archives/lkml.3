Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab3ARUfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:35:09 -0500
Received: from mout.web.de ([212.227.17.11]:59227 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab3ARUfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:35:07 -0500
From: Thomas Schlichter <thomas.schlichter@web.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Andreas =?ISO-8859-1?Q?M=FCller?= <goo@stapelspeicher.org>,
        Julius Werner <jwerner@chromium.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: fix new C-states not functional after AC disconnect
Date: Fri, 18 Jan 2013 21:34:29 +0100
Message-ID: <1755809.pcSThauESZ@netbook>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc4-00001-gfc300f4-dirty; KDE/4.9.4; i686; ; )
In-Reply-To: <11530988.U26HMGnFLa@vostro.rjw.lan>
References: <2099093.cPXO6Nhn9v@netbook> <50F2C79E.5000302@linaro.org> <11530988.U26HMGnFLa@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1437426.ZqIx6kOOZB"
Content-Transfer-Encoding: 7Bit
X-Provags-ID: V02:K0:1MuWCJ+3/1yRByW1k52y9w7wjsyk3Ra2ZppsrTfHy4w
 bWK8chV3cXjPhRB5WgzfZ24o8dfMrZUX95vIQjescvNVZRi3zZ
 y1/jd3TrGcEYVSuD/zADLp7X3pZgmyyoRRqph5Z58tYKt1SmY6
 OCwBK1zBj1XOWFhnnmen1Yxzy5SA3T+ruoyQd/3s4pPlZc/Isd
 ACSkuri7tH3FZsc2vxSb60niq6iRwZ3IN9InTuAtpc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart1437426.ZqIx6kOOZB
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Dear Rafael,

thank you for applying Daniel's patch. I tested 3.8-rc4 and found that one 
patch ist still missing to fix the problem of not usable C-state after 
disconnect. I had it attached with my last e-mail as patch 1. For your 
conveniency, I have attached it here again.

With that patch the problem is fixed for me. So please consider applying this, 
too.

Kind regards,
  Thomas

Am Sonntag, 13. Januar 2013, 21:04:45 schrieb Rafael J. Wysocki:
> On Sunday, January 13, 2013 03:41:34 PM Daniel Lezcano wrote:
> > On 01/13/2013 01:34 PM, Thomas Schlichter wrote:
> > > Hi,
> > > 
> > > there is a long-standing regression about new C-states not working after
> > > disconnecting AC power from a laptop if the cpuidle driver "acpi-idle"
> > > is
> > > used. It was reported here:
> > > 
> > > [1] https://bugzilla.kernel.org/show_bug.cgi?id=42870  (March 5th 2012)
> > > [2] https://bugzilla.kernel.org/show_bug.cgi?id=43349  (June 7th 2012)
> > > [3] https://lkml.org/lkml/2012/10/16/518   (October 19th 2012)
> > > 
> > > In [1] Andreas proposed a patch that initialized the missing power_usage
> > > values from within acpi_idle in the same way as cpuidle does.
> > > In [2] I proposed a patch to use the power values provided by ACPI to
> > > initialize the power_usage variables.
> > > In [3] Julius proposed a patch to call the initialization function
> > > set_power_states()  not only once, but always when the C-states change.
> > > 
> > > Currently, Daniel Lezcano seems to be working on an intrusive change of
> > > not
> > > using the power_usage value at all for choosing a C-state:
> > > 
> > > [4] https://lkml.org/lkml/2012/12/14/155
> > > 
> > > As I could not find any of these patches in any git trees to be merged
> > > for
> > > 3.8, I propose an other, least intrusive patch for the time being. It is
> > > attached an initializes _all_ power_usage values in the first place.
> > > 
> > > As this is a real power consumption regression since 3.2, I really ask
> > > you to apply anything and push it to stable, too!
> > 
> > Rafael, is possible to apply the patch [1/2] I previously sent ?
> > 
> > https://patchwork.kernel.org/patch/1878691/
> 
> I need to talk about this with Len.  That should happen tomorrow if
> everything goes well.
> 
> > So we get this bug fixed.
> > 
> > I will resend the patch [2/2] as soon as possible.
> 
> OK
> 
> Thanks,
> Rafael
--nextPart1437426.ZqIx6kOOZB
Content-Disposition: inline; filename="0001-Get-power-info-before-updating-the-C-states.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0001-Get-power-info-before-updating-the-C-states.patch"

>From fc300f4fefff59fe1029bf7852ea32d957145821 Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sun, 2 Sep 2012 14:35:34 +0200
Subject: [PATCH] Get power info before updating the C-states

acpi_processor_get_power_info() has to be called before
acpi_processor_setup_cpuidle_states() to have the latest
information available. This fixes the missing C-state information
after AC-->DC transition.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 drivers/acpi/processor_idle.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index f1a5da4..17ed60b 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1149,6 +1149,7 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 		}
 
 		/* Populate Updated C-state information */
+		acpi_processor_get_power_info(pr);
 		acpi_processor_setup_cpuidle_states(pr);
 
 		/* Enable all cpuidle devices */
-- 
1.7.10.4


--nextPart1437426.ZqIx6kOOZB--

