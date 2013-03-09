Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200Ab3CISPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:15:09 -0500
Received: from smtp-out-195.synserver.de ([212.40.185.195]:1095 "EHLO
	smtp-out-193.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750737Ab3CISPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:15:08 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31737
From: Lars-Peter Clausen <lars@metafoo.de>
To: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 0/6]  Make return type of i2c_del_adapter() (and i2c_del_mux_adapter()) void
Date: Sat,  9 Mar 2013 19:16:43 +0100
Message-Id: <1362853009-20789-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently i2c_del_adapter() returns 0 on success and potentially an error code
on failure. Unfortunately this doesn't mix too well with the Linux device driver
model. An i2c_adapter is usually registered in a drivers probe callback and
removed in the drivers remove callback. The Linux device driver model assumes
that a device may disappear at any time, e.g. because it is on a hot-plug-able
bus and the device is physically removed or because it is unbound from it's
driver. This means that a driver's remove callback is not allowed to fail. This
has lead to code fragments like the following:

	rc = i2c_del_adapter(&board->i2c_adap);
	BUG_ON(rc);

Currently there are two code paths which can cause to i2c_del_adapter() to
return an error code:
1) If the adapter that is passed to i2c_del_adapter() is not registered
i2c_del_adapter() returns -EINVAL
2) If an I2C client, which is registered as a child to the adapter, implements
the detach_adapter callback and detach_adapter returns an error the removal of
the adapter is aborted and i2c_del_adapter() returns the error returned by the
clients detach_adapter callback.

The first probably never happens unless there is a serious bug in the driver
calling i2c_del_adapter(), but I think even then, for the sake of sanitizing the
API we can argue that the purpose of i2c_del_adapter() is to remove the adapter
from the system. If the adapter currently isn't registered this becomes a no-op
and we can return success, without having to do anything. The second also never
happens, since the detach_adapter callback has been deprecated for quite some
time now and there are currently no drivers left which implement it.

So realisticly i2c_del_adapter() already always returns 0 and all code checking
for errors is more or less dead code. And in fact the majority of the users of
i2c_del_adapter() already ignore the return value, but there are still some
drivers (both newer and older) which assume that i2c_del_adapter() might fail.
This series aims at making it explicit that i2c_del_adapter() can not fail by
making its return type void.

The series will start by making i2c_del_adapter() always return success. For
this it will update the case, where a non-registered adapter is passed in, to
return 0 instead of -EINVAL and remove all code related to the unused
detach_adapter callback. Afterward the series will update all users of
i2c_del_adapter() to ignore the return value (since it is always 0 now). And
finally the series will change the return type of i2c_del_adapter() to void.

The same is true for i2c_del_mux_adapter() which is mostly just a wrapper
around i2c_del_adapter(), so it is also updated in this series.

- Lars

Lars-Peter Clausen (6):
  i2c: Remove detach_adapter
  i2c: i2c_del_adapter: Don't treat removing a non-registered adapter
    as error
  i2c: Ignore return value of i2c_del_adapter()
  i2c: Make return type of i2c_del_adapter() void
  i2c: Ignore the return value of i2c_del_mux_adapter()
  i2c: Make the return type of i2c_del_mux_adapter() void

 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c   |  3 +--
 drivers/i2c/busses/i2c-amd756-s4882.c        |  6 +----
 drivers/i2c/busses/i2c-at91.c                |  5 ++--
 drivers/i2c/busses/i2c-cbus-gpio.c           |  4 ++-
 drivers/i2c/busses/i2c-intel-mid.c           |  3 +--
 drivers/i2c/busses/i2c-mv64xxx.c             |  5 ++--
 drivers/i2c/busses/i2c-mxs.c                 |  5 +---
 drivers/i2c/busses/i2c-nforce2-s4985.c       |  6 +----
 drivers/i2c/busses/i2c-powermac.c            | 10 ++-----
 drivers/i2c/busses/i2c-puv3.c                | 10 ++-----
 drivers/i2c/busses/i2c-viperboard.c          |  5 ++--
 drivers/i2c/i2c-core.c                       | 39 +++++++++-------------------
 drivers/i2c/i2c-mux.c                        |  9 ++-----
 drivers/i2c/muxes/i2c-mux-pca954x.c          |  6 ++---
 drivers/media/pci/bt8xx/bttv-input.c         |  6 ++---
 drivers/media/pci/mantis/mantis_i2c.c        |  4 ++-
 drivers/net/ethernet/sfc/falcon.c            |  6 ++---
 drivers/staging/media/go7007/go7007-driver.c |  7 ++---
 include/linux/i2c-mux.h                      |  2 +-
 include/linux/i2c.h                          |  9 +++----
 20 files changed, 48 insertions(+), 102 deletions(-)

-- 
1.8.0

