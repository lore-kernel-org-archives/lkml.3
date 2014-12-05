Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaLENde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:33:34 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11596 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaLENdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:33:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 05 Dec 2014 05:31:46 -0800
From: Arto Merilainen <amerilainen@nvidia.com>
To: <myungjoo.ham@samsung.com>, <kyungmin.park@samsung.com>,
        <tomeu.vizoso@collabora.com>, <gnurou@gmail.com>
CC: <javier.martinez@collabora.co.uk>, <linuxpm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>, <grant.likely@linaro.org>,
        <srasal@nvidia.com>, <amerilainen@nvidia.com>
Subject: [RFC 0/3] Add watermark support to devfreq
Date: Fri, 5 Dec 2014 15:32:51 +0200
Message-ID: <1417786374-375-1-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently main mechanism to implement scaling using devfreq is
polling and the device profile is free to set polling interval.
However, in many cases this approach is not optimal; We may
unnecessarily use CPU time to determine load on engine that
is idle most of time - or we may simply read load when we
already know that the device is busy.

In some cases a device itself has counters to track its activity
and possibility to raise interrupts when load goes above or below
certain threshold.

This series adds support for watermark events to devfreq and
introduces two example governors. The first patch adds two
callbacks to the device profile (for setting watermark) and
adds a new function call to devfreq that informs of crossed
watermark.

The added governors demonstrate usage of the new API. The first
governor (watermark simple) sets device to trigger low watermark
event when load goes below 10% and high watermark interrupt when
the load goes above 60%. Watermark active tries to keep load at
certain level and it actively sets thresholds based on the
frequency table in order get interrupts only when the load value
would affect to the current frequency in re-estimation.

Arto Merilainen (1):
  PM / devfreq: Add watermark active governor

Shridhar Rasal (2):
  PM / devfreq: Add watermark events
  PM / devfreq: Add watermark simple governor

 drivers/devfreq/Kconfig                 |  18 +++
 drivers/devfreq/Makefile                |   2 +
 drivers/devfreq/devfreq.c               |  19 +++
 drivers/devfreq/governor.h              |   1 +
 drivers/devfreq/governor_wmark_active.c | 276 ++++++++++++++++++++++++++++++++
 drivers/devfreq/governor_wmark_simple.c | 245 ++++++++++++++++++++++++++++
 include/linux/devfreq.h                 |  26 +++
 7 files changed, 587 insertions(+)
 create mode 100644 drivers/devfreq/governor_wmark_active.c
 create mode 100644 drivers/devfreq/governor_wmark_simple.c

-- 
1.8.1.5

