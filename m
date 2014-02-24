Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaBXRLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:11:05 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45062 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaBXRLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:11:03 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: linux-usb@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] introduce assign_if() macros in attempt to reduce ifdeffery
Date: Mon, 24 Feb 2014 11:08:24 -0600
Message-Id: <1393261707-30565-1-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the observation that given the following:

	static void my_callback(void)
	{
	}
	void (*callback)(void) = 0 ? my_callback : NULL;

GCC will,

	1.) Not emit 'defined but unused' warnings for 'my_callback'
	2.) Typecheck my_callback against typeof(*callback)
	3.) Eliminate my_callback as dead code (assuming it's unused elsewhere)

this patchset explores where/how this might be used to reduce the amount of
ifdeffed code in device drivers.

Patch 1 in this series introduces two friendly-named helper macros:

	assign_if(const_expr, fn):   A friendlier form of (const_expr ? fn : NULL)
	assign_if_enabled(conf, fn): Composition of assign_if() and IS_ENABLED().

In order to show a good target usecase for these macros, patch 2 introduces a
new set of PM-related macros, similar to SET_*_PM_OPS, using
assign_if_enabled() under the hood.

In particular, this is aimed at reducing code like the following:

	#ifdef CONFIG_PM_SLEEP
	static int foo_suspend(struct device *dev)
	{
		/* ... */
	}
	#else
	#define foo_suspend NULL
	#endif

	static const struct dev_pm_ops foo_pm_ops = {
		SET_SYSTEM_SLEEP_PM_OPS(foo_suspend, NULL)
	};

With the ifdefless:

	static int foo_suspend(struct device *dev)
	{
		/* ... */
	}

	static const struct dev_pm_ops foo_pm_ops = {
		ASSIGN_SYSTEM_SLEEP_PM_OPS(foo_suspend, NULL),
	};

For patch 3, an existing consumer of SET_*_PM_OPS(), the MSM USB phy driver[1]
is modified to use the newly introduced ASSIGN_*_PM_OPS() macros to show in a
real case what simplifications could be gained.

For testing that GCC is actually eliminating the PM-related callbacks when it
can, the MSM USB phy driver was built before and after patch 3, in 4 different
configurations, and object sizes compared[2]:

   text	   data	    bss	    dec	    hex	filename
  11008	    488	     20	  11516	   2cfc	phy_objects_before/phy-msm-usb.nopm.o
  11008	    488	     20	  11516	   2cfc	phy_objects_after/phy-msm-usb.nopm.o

  13528	    584	     20	  14132	   3734	phy_objects_before/phy-msm-usb.runtime.o
  13528	    584	     20	  14132	   3734	phy_objects_after/phy-msm-usb.runtime.o

  13828	    632	     20	  14480	   3890	phy_objects_before/phy-msm-usb.runtime+sleep.o
  13828	    632	     20	  14480	   3890	phy_objects_after/phy-msm-usb.runtime+sleep.o

  13072	    560	     20	  13652	   3554	phy_objects_before/phy-msm-usb.sleep.o
  13072	    560	     20	  13652	   3554	phy_objects_after/phy-msm-usb.sleep.o

[1]: Chosen because it has recently broken randconfig builds due to improper
     #ifdeffery using CONFIG_PM* defines
[2]:
	$ ${CROSS_COMPILE}gcc --version
	arm-linux-gnueabihf-gcc (crosstool-NG linaro-1.13.1-4.8-2013.07-1 - Linaro GCC 2013.07) 4.8.2 20130624 (prerelease)
	Copyright (C) 2013 Free Software Foundation, Inc.
	This is free software; see the source for copying conditions.  There is NO
	warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


Josh Cartwright (3):
  typecheck: introduce assign_if() and assign_if_enabled()
  PM: define new ASSIGN_*_PM_OPS macros based on assign_if
  usb: phy: msm: use ASSIGN_*_PM_OPS variants

 drivers/usb/phy/phy-msm-usb.c | 13 +++----------
 include/linux/pm.h            | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/typecheck.h     | 18 ++++++++++++++++++
 3 files changed, 60 insertions(+), 10 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

