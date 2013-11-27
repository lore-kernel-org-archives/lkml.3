Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3K0PfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:35:17 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:42370 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab3K0PfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:35:15 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 0/5] PM: Enable option of re-use runtime PM callbacks at system suspend
Date: Wed, 27 Nov 2013 16:34:55 +0100
Message-Id: <1385566500-7666-1-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To put devices into low power state during system suspend, it may be convenient
for runtime PM supported subsystems, power domains and drivers to have the
option of re-using the runtime PM callbacks.

At the moment, quite complex solutions exist for power domains that tries to
handle the above, like for OMAP2. The idea here, is to make it possible for
drivers, who should know best, how to easiest put their devices into low power
state. The intent is thus not only to simplify drivers but also power domains.

Additionally, some drivers seems to have messed up things when combining
runtime PM with system PM. While we enable the option of re-using the runtime
PM callbacks during system PM, we also intend to clarify the way forward for
how these scenarios could be resolved.

Some new helper macros for defining PM callbacks and two new pm_generic*
functions has been implemented in this patch set. These are provided to make it
easier for those who wants to enable the option of re-using the runtime PM
callbacks during system suspend.

A minor fix was needed for the platform bus, which runtime PM callbacks are set
to the pm_genric_runtime_suspend|resume functions. These were implemented only
for CONFIG_PM_RUNTIME and thus the platform bus prevented driver's runtime PM
callbacks to be invoked when only CONFIG_PM_SLEEP was used. We move them into
CONFIG_PM to resolve the problem and then let drivers decide how to handle this
themselves.

Patch 5 is folded into this patch set, to visualize how a driver that uses both
runtime PM and system PM, can benefit from re-using the runtime PM callbacks
during system suspend.

Also note that, patch 1 to 4 has been submitted to linux-pm as standalone
patches recently. I thought it make sense to collect them into a patchset
since those are closely related.

Ulf Hansson (5):
  PM / Sleep: Add pm_generic functions to re-use runtime PM callbacks
  PM / Runtime: Implement the pm_generic_runtime functions for
    CONFIG_PM
  PM / Runtime: Add second macro for definition of runtime PM callbacks
  PM / Sleep: Add macro to define common late/early system PM callbacks
  drm/exynos: Convert to suspend_late/resume_early callbacks for fimc

 drivers/base/power/generic_ops.c         |   90 +++++++++++++++++++++++++++++-
 drivers/gpu/drm/exynos/exynos_drm_fimc.c |   33 ++---------
 include/linux/pm.h                       |   23 ++++++++
 include/linux/pm_runtime.h               |   12 ++--
 4 files changed, 123 insertions(+), 35 deletions(-)

-- 
1.7.9.5

