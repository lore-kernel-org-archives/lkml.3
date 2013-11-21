Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3KUBlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 20:41:04 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:56475 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755176Ab3KUBk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 20:40:58 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: len.brown@intel.com, pavel@ucw.cz, rjw@rjwysocki.net,
        gregkh@linuxfoundation.org, anton@enomsg.org, dwmw2@infradead.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH 0/2] power_supply: Fix Oops from NULL pointer dereference from wakeup_source_activate
Date: Wed, 20 Nov 2013 18:40:48 -0700
Message-Id: <cover.1384990612.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

power_supply_register() calls device_init_wakeup() to register a wakeup
source before initializing dev_name. As a result, device_wakeup_enable()
end up registering wakeup source with a null name when wakeup_source_register()
gets called with dev_name(dev) which is null at the time.

device_wakeup_enable() uses dev_name(dev) as the wakeup source name.
When it gets called with a device with its name not yet set, ws structure
with ws->name = NULL gets created.

When kernel is booted with wakeup_source_activate enabled, it will panic
when the trace point code tries to dereference ws->name. Registering a
a wakeup source without a name should be possible.

This patch series fixes power_supply_register() to initialize the device name
prior to calling device_init_wakeup() and fixes wakeup_source_activate
tracepoint to check for null name and handle it gracefully by just using
"(no name)" as the name string for the source.

These two patches are not dependent, I left them as a series since the original
discussion started the fixes grouped in a series.

power_supply patch - no changes since series patch v1, other than including
Acked-by from Greg and Anton. Also added stable tag.

Second patch now is the fix to tracepoint code. This fix is definitely better
than adding WARN_ON to device_wakeup_enable(). It removes the dependency
between these two patches.

These patches can be applied independently with no ill effects. I included
the trace for the wakeup_source_activate trace output in the changelogs for
both patches.

Shuah Khan (2):
  power_supply: Fix Oops from NULL pointer dereference from
    wakeup_source_activate
  PM: Fix Oops from NULL pointer dereference in wakeup_source_activate

 drivers/power/power_supply_core.c | 12 ++++++------
 include/trace/events/power.h      |  6 ++++--
 2 files changed, 10 insertions(+), 8 deletions(-)

-- 
1.8.3.2

