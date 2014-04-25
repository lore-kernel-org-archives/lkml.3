Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaDYWpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:45:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42881 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaDYWpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:45:05 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC/PATCH 0/4] Use wound/wait mutexes in the common clock framework
Date: Fri, 25 Apr 2014 15:44:44 -0700
Message-Id: <1398465888-12610-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prepare mutex in the common clock framework can lead to tasks waiting a
long time for other tasks to finish a frequency switch or prepare/unprepare
step. In my particular case I have a clock controlled by a co-processor that
can take 10s of millliseconds to change rate. I've seen scenarios where it can
take more than 20ms for another thread to acquire the prepare mutex because
it's waiting on the co-processor to finish changing the rate. Pair this with a
display driver that wants to scale it's clock up before drawing a frame and you
may start dropping frames at 60FPS (one frame is budgeted 16ms). Similar
scenarios exist like CPUfreq scaling getting blocked for large amounts of time.

This patchset attempts to remedy this problem by introducing a per-clock
wwmutex. This allows multiple threads to be traversing and updating the tree at
the same time granted they don't touch the same subtree. In my testcase
this removes the contention on the co-processor clocks and allows the display
driver to scale the clock up and down in parallel.

There is a drawback though, we lose the recursive mutex property. I don't have
a good solution for this besides "don't do that" and I believe we actually have
usecases for such a thing? Technically a thread recursing into the clock
framework probably wouldn't be acquiring the same locks (and even if it was we
could recognize that this is the same thread acquiring it again) but due to the
way wound/wait mutexes work we may need to release all locks and try again the
second time we're in the clock framework and that sounds really annoying to
handle. We'd need to have some list of threads and acquire contexts and then we
would need to rely on drivers returning -EDEADLK through the ops, etc. At least
lockdep will complain loudly when you try this so it isn't a silent failure.

Due to the loss of recursion we can't allow clock drivers to call the
non-underscore versions of the clock APIs either. I don't see too many users
right now under drivers/clk but those would need to be updated before these
patches could be applied.

Please note these patches are based on some cleanup patches I sent already[1]

Stephen Boyd (4):
  clk: Recalc rate and accuracy in underscore functions if not caching
  clk: Make __clk_lookup() use a list instead of tree search
  clk: Use lockless functions for debug printing
  clk: Use ww_mutexes for clk_prepare_{lock/unlock}

 drivers/clk/clk.c           | 598 +++++++++++++++++++++++++++++++++++---------
 include/linux/clk-private.h |   4 +
 2 files changed, 478 insertions(+), 124 deletions(-)

[1] https://lkml.org/lkml/2014/3/26/423

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

