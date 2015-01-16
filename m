Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbbAPXdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 18:33:23 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:48401 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbAPXdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 18:33:22 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Luis R . Rodriguez" <mcgrof@suse.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Olof Johansson <olof@lixom.net>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 0/8] Asynchronous device/driver probing support
Date: Fri, 16 Jan 2015 15:33:09 -0800
Message-Id: <1421451197-19723-1-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is a combination of changes proposed by Luis a couple months
ago and implementation used by Chrome OS. The issue we are trying to solve
here is "slow" devices and drivers spending "too much time" in their probe()
methods and it affects:

- overall kernel boot process when drivers are compiled into the kernel
  and slow devices stall entire boot progress;
- systemd desire to time out module loading process.

Unlike Luis' proposal we do make use of asycn_schedule() infrastructure
instead of using a dedicated workqueue, so all  existing synchronization
points in kernel that wait for device registration still work the same.
Also, the asynchronous probing is done not only during driver registration
(i.e. when devices are probed asynchronously only if they are registered
before the driver), but also during device registration and deferred probe
handling. This way slow devices do not stall kernel boot even when drivers
are compiled into the kernel.

The last patch is for adventurous people to try and force
fully-asynchronous boot. It works for me with limited success - I can boot
Rockhip-based box to userspace as long as I force serial to be sychronously
probed and ignore the fact that most devices are using "dummy" regulators
as regulator subsystem really expects regulators to be registered in
orderly fashion on OF-based systems.

Thanks,
Dmitry


Dmitry Torokhov (3):
  driver-core: add asynchronous probing support for drivers
  driver-core: platform_driver_probe() must probe synchronously
  module: add core_param_unsafe

Luis R. Rodriguez (5):
  module: add extra argument for parse_params() callback
  driver-core: add driver module asynchronous probe support
  driver-core: enable drivers to opt-out of async probe
  amd64_edac: enforce synchronous probe
  driver-core: allow forcing async probing for modules and builtins

 Documentation/kernel-parameters.txt |  13 +++
 arch/powerpc/mm/hugetlbpage.c       |   4 +-
 drivers/base/base.h                 |   1 +
 drivers/base/bus.c                  |  31 +++++--
 drivers/base/dd.c                   | 166 +++++++++++++++++++++++++++++++-----
 drivers/base/platform.c             |  13 +++
 drivers/edac/amd64_edac.c           |   1 +
 include/linux/device.h              |  26 ++++++
 include/linux/module.h              |   2 +
 include/linux/moduleparam.h         |  12 ++-
 init/main.c                         |  25 +++---
 kernel/module.c                     |  25 +++++-
 kernel/params.c                     |  11 ++-
 lib/dynamic_debug.c                 |   4 +-
 14 files changed, 284 insertions(+), 50 deletions(-)

-- 
2.2.0.rc0.207.ga3a616c

