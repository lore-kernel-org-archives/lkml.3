Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab3KVRyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:54:37 -0500
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:49405 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517Ab3KVRye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:54:34 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: anton@enomsg.org, dwmw2@infradead.org, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, rjw@rjwysocki.net,
        gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH v3 0/2] power_supply: Fix Oops from NULL pointer dereference from wakeup_source_activate
Date: Fri, 22 Nov 2013 10:54:27 -0700
Message-Id: <cover.1385138418.git.shuah.kh@samsung.com>
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
prior to calling device_init_wakeup() and fixes tracing infrastructure to be
more robust in handling null strings in __assign_string() and __string(). With
this change null string is handled gracefully and replacing it with "(null)"
when trace is generated.

These two patches are not dependent, I left them as a series since the original
discussion started the fixes grouped in a series.

power_supply patch - no changes since series patch v1, other than including
Acked-by from Greg and Anton. Also added stable tag.

Second patch now is the fix to tracepoint infrastructure routines
__assign_string() and __string(). This will address the problem at the tracing
infrastructure level which is better than fixing individual tracepoint code.

These patches can be applied independently with no ill effects. I included
the trace for the wakeup_source_activate trace output in the change logs for
both patches.

Shuah Khan (2):
  power_supply: Fix Oops from NULL pointer dereference from
    wakeup_source_activate
  tracing: Fix Oops from NULL pointer dereference from __assign_str

 drivers/power/power_supply_core.c | 12 ++++++------
 include/trace/ftrace.h            |  7 +++++--
 2 files changed, 11 insertions(+), 8 deletions(-)

-- 
1.8.3.2

