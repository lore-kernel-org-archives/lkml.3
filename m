Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3AMMeu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 07:34:50 -0500
Received: from mout.web.de ([212.227.15.3]:59411 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab3AMMer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 07:34:47 -0500
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Andreas =?ISO-8859-1?Q?M=FCller?= <goo@stapelspeicher.org>,
        Julius Werner <jwerner@chromium.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cpuidle: fix new C-states not functional after AC disconnect
Date: Sun, 13 Jan 2013 13:34:41 +0100
Message-ID: <2099093.cPXO6Nhn9v@netbook>
User-Agent: KMail/4.9.3 (Linux/3.8.0-rc3-00076-g5c635b3-dirty; KDE/4.9.3; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1794952.WA51hkzRQo"
Content-Transfer-Encoding: 7Bit
X-Provags-ID: V02:K0:wVf5p2VCd295vyzkFzk+4zQEcYzz0S+AEhrvOc3FCFs
 MORirKyvdAk4q/3SSiOkle57CeIsRNN8W/Y+904ghbKsf9ERWU
 TG86fbgr6aGyNKZn38teAATmppSz3mEMaMa0J1e5qr/FDPBcNG
 rsa/Hn48Uz9j03lhpDkOELlWLEZ5aeHswZfm7LfKi7G/1e3Z56
 Y45EdgimnZ4Rv+IqT1q624pkoWUlf8ZcTBmxhL9uW0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart1794952.WA51hkzRQo
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

there is a long-standing regression about new C-states not working after 
disconnecting AC power from a laptop if the cpuidle driver "acpi-idle" is 
used. It was reported here:

[1] https://bugzilla.kernel.org/show_bug.cgi?id=42870  (March 5th 2012)
[2] https://bugzilla.kernel.org/show_bug.cgi?id=43349  (June 7th 2012)
[3] https://lkml.org/lkml/2012/10/16/518   (October 19th 2012)

In [1] Andreas proposed a patch that initialized the missing power_usage 
values from within acpi_idle in the same way as cpuidle does.
In [2] I proposed a patch to use the power values provided by ACPI to 
initialize the power_usage variables.
In [3] Julius proposed a patch to call the initialization function 
set_power_states()  not only once, but always when the C-states change.

Currently, Daniel Lezcano seems to be working on an intrusive change of not 
using the power_usage value at all for choosing a C-state:

[4] https://lkml.org/lkml/2012/12/14/155

As I could not find any of these patches in any git trees to be merged for 
3.8, I propose an other, least intrusive patch for the time being. It is 
attached an initializes _all_ power_usage values in the first place.

As this is a real power consumption regression since 3.2, I really ask you to 
apply anything and push it to stable, too!

Kind regards,
Thomas Schlichter
--nextPart1794952.WA51hkzRQo
Content-Disposition: inline; filename="0001-Get-power-info-before-updating-the-C-states.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="0001-Get-power-info-before-updating-the-C-states.patch"

>From 5296fec02cfadf10daf6395ad6b55075381b2439 Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sun, 2 Sep 2012 14:35:34 +0200
Subject: [PATCH 1/2] Get power info before updating the C-states

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

--nextPart1794952.WA51hkzRQo
Content-Disposition: inline; filename="0002-cpuidle-Initialize-power_usage-for-all-C-states.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="0002-cpuidle-Initialize-power_usage-for-all-C-states.patch"

>From 5c635b3530d4f9b41811f7dde12e0d6f5f7dcc54 Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sat, 12 Jan 2013 15:30:43 +0100
Subject: [PATCH 2/2] cpuidle: Initialize power_usage for all C-states

By now, only the power_usage values of currently available C-states are
initialized in the function set_power_states(). But if the number of C-states
increases later (e.g. when using acpi_idle and unplugging the AC power from the
laptop) the power_usage values of the new C-states stay uninitialized.

Fix this by initializing all CPUIDLE_STATE_MAX C-stages in the first place.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 drivers/cpuidle/driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index c2b281a..960d98d 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -37,7 +37,7 @@ static void set_power_states(struct cpuidle_driver *drv)
 	 * an power value of -1.  So we use -2, -3, etc, for other
 	 * c-states.
 	 */
-	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++)
+	for (i = CPUIDLE_DRIVER_STATE_START; i < CPUIDLE_STATE_MAX; i++)
 		drv->states[i].power_usage = -1 - i;
 }
 
-- 
1.7.10.4

--nextPart1794952.WA51hkzRQo--

