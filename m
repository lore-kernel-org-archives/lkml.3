Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbaGEFfd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 01:35:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760455AbaGEFfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 01:35:32 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@lakedaemon.net,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v2 0/2] hwrng, virtio-rng: init-time fixes
Date: Sat,  5 Jul 2014 11:04:51 +0530
Message-Id: <cover.1404538109.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
 - this now separates both the patches; the virtio-rng fix is self-contained
 - re-work hwrng core to fetch randomness at device init time if
   ->init() is registered by the device, instead of not calling it at all.
 - virtio-rng: introduce a probe_done bool to ensure we don't ask host
   for data before successful probe

Hi,

When booting a recent kernel under KVM with the virtio-rng device
enabled, the boot process was stalling.  Bisect pointed to a commit
made during the 3.15 window to fetch randomness from newly-registered
devices in the hwrng core.  The details are in the patches.

Turns out there were two bugs: the initial randomness was being
fetched w/o the device being initialized in cases where the init
callback was registered and the device wasn't the first device being
added to the hwrng core.  The second bug is virtio can't communicate
with the host without the device probe is successfully completed.

Please review and apply if appropriate,

Amit Shah (2):
  hwrng: fetch randomness only after device init
  virtio: rng: ensure reads happen after successful probe

 drivers/char/hw_random/core.c       | 37 +++++++++++++++++++++++++++++++------
 drivers/char/hw_random/virtio-rng.c | 10 ++++++++++
 2 files changed, 41 insertions(+), 6 deletions(-)

-- 
1.9.3

