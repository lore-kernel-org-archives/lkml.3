Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbaEOUik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:38:40 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:52612 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbaEOUii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:38:38 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 0/6] watchdog: Add reboot API
Date: Thu, 15 May 2014 13:38:18 -0700
Message-Id: <1400186304-1691-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hardware implements reboot through its watchdog hardware, for example
by triggering a watchdog timeout or by writing into its watchdog register
set. Platform specific code starts to spread into watchdog drivers,
typically by setting pointers to a callback function which is then called
from the architecture's reset handler.

While global and exported callback function pointers (such as arm_pm_restart)
may be acceptable as long as they are used from platform and/or architecture
code, using such a mechanism across subsystems and drivers is less than
desirable. Ultimately, we'll need a better solution.

This patch series provides such a solution. It extends the watchdog
subsystem to support reboot functionality, provides an API function
call to trigger reboots, adds support for the new API to arm and arm64,
and converts the drivers providing reboot functionality to use the new
infrastructure.

The first patch in the series implements the new API. The second patch
documents it. The third and fourth patch modify the arm and arm64
architecture reset handlers to call the added API function. The final
two patches register the reboot handlers in the sunxi and moxart watchdog
drivers with the watchdog subsystem.

The sunxi patch depends on the most recent patch series sumitted by
Maxime Ripard.

Note that I did not address the comments asking for support of multiple
watchdogs with reset handlers, nor the request to add a flag to provide
'preferential' treatment for one of those watchdogs. This will require
additional discussion and needs to be addressed with a later patch if needed.
Key questions are how to add such support for non-DT systems, and if the
scope of restart handling is a function of the driver or of the system.
Also, if one of the watchdogs does not result in a complete system reset
but another one does, it is not clear to me why the less-than-perfect
watchdog would be configured in the first place (or how this situation
would be handled today).

Compile tested only for arm64. Tested on arm/moxart by Jonas Jensen.
