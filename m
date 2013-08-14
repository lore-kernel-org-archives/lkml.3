Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879Ab3HNMbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:31:33 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:39384 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759661Ab3HNMbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:31:31 -0400
From: Xiaolong Ye <yexl@marvell.com>
To: <hjk@hansjkoch.de>, <greg@kroah.com>, <linux-kernel@vger.kernel.org>
CC: Xiaolong Ye <yexl@marvell.com>
Subject: [PATCH] Add uio_sync_event interface to support mulit-instances case in UIO framework
Date: Wed, 14 Aug 2013 20:30:22 +0800
Message-ID: <1376483423-603-1-git-send-email-yexl@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, guys,

Recently, we have met fake interrupt issue when using UIO as our vpu driver in mulit-instances case,
the issue can be described as below:

In multi-instances case, we use vpu_lock(semaphore) to implement the mutually exclusive access to the
device, each instace open uio device once and will be associated with a fd and its own uio_listener,
we use poll to wait for the hardware interrupt. So let's assume that there are two instances, A and B,
their uio_listener->event_count and idev->event are all 0 at the beginning, then A get the vpu_lock and start
to work, it will block at poll()(because listener->event_count == idev->count) until H/W interrupt happens
(atomic_inc(&idev->event)), after it releases vpu_lock, B will get the lock and start to work, however,
its poll will return immediately because B's uio_listener->event_count is 0 while idev->event has been 1,
that's how the fake interrupt happens.

Our proposal:
Add new uio_sync_event(struct uio_listener *listener) function in uio,c, so that we can call it directly
when we want to sync the event count.


Xiaolong Ye (1):
  uio: add uio_event_sync interface

 drivers/uio/uio.c          |   12 ++++++++++++
 include/linux/uio_driver.h |    1 +
 2 files changed, 13 insertions(+)

-- 
1.7.9.5

