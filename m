Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaIOQD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:03:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbaIOQDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:03:55 -0400
From: Amos Kong <akong@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org, herbert@gondor.apana.org.au, m@bues.ch, mb@bu3sch.de,
        mpm@selenic.com, rusty@rustcorp.com.au, amit.shah@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] fix stuck in accessing hwrng attributes
Date: Tue, 16 Sep 2014 00:02:26 +0800
Message-Id: <1410796949-2221-1-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we read hwrng by long-running dd process, it takes too much cpu
time and almost hold the mutex lock. When we check hwrng attributes
from sysfs by cat, it gets stuck in waiting the lock releaseing.
The problem can only be reproduced with non-smp guest with slow backend.

This patchset resolves the issue by changing rng_dev_read() to always
schedule 10 jiffies after release mutex lock, then cat process can
have chance to get the lock and execute protected code without stuck.

Thanks.

V2: update commitlog to describe PATCH 2, split second patch.

Amos Kong (3):
  virtio-rng cleanup: move some code out of mutex protection
  hw_random: fix stuck in catting hwrng attributes
  hw_random: increase schedule timeout in rng_dev_read()

 drivers/char/hw_random/core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

-- 
1.9.3

