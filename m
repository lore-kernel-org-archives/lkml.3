Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaCPN3s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 09:29:48 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:59330 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaCPN3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 09:29:46 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
        Christian Riesch <christian.riesch@omicron.at>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
Subject: [PATCH net-next v2 0/9] ptp: dynamic pin control
Date: Sun, 16 Mar 2014 14:29:21 +0100
Message-Id: <cover.1394975663.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces a way of changing the auxiliary PTP
Hardware Clock functions (periodic output signals and time stamping
external signals) at run time. In the past on the netdev list, we have
discussed other ways to handle this, such as module parameters and
ethtool. This series implements a new PHC ioctl because that is the
most natural way. Users already activate the auxiliary functions via
the ioctls. The sysfs interface has also been expanded so that the pin
configuration can be programmed using shell scripts.

The first patch adds the new ioctls. The PHC subsystem does most of
the work of maintaining the function-to-pin mapping. Drivers will only
need to allocate and initialize a pin configuration table and also
provide a new method that validates a particular assignment.

Patches 5 and 6 just clean up a couple of issues in the phyter driver,
and the remaining patches actually hook the phyter's pins into the new
system.

Comments and questions are most welcome.

Thanks,
Richard

* ChangeLog
** V2
   - fix bug in sysfs code on init error path
   - rename ptp_setpin() to ptp_set_pinfunc()
   - rename .setpin() to .verify() in the driver interface
   - simplify ptp_find_pin() logic
   - use correct test when checking whether the pin with the
     calibration function is being reprogrammed

Richard Cochran (9):
  ptp: introduce programmable pins.
  ptp: add the pin GET/SETFUNC ioctls to the testptp program.
  ptp: expose the programmable pins via sysfs
  ptp: drivers: set the number of programmable pins.
  dp83640: trivial fixes
  dp83640: correct the periodic output frequency
  dp83640: implement programmable pin functions.
  dp83640: let external input pins from the module parameters be
    defaults.
  dp83640: let the periodic pin from the module parameter be a default.

 Documentation/ABI/testing/sysfs-ptp              |   20 ++++
 Documentation/ptp/testptp.c                      |   58 +++++++++-
 drivers/net/ethernet/adi/bfin_mac.c              |    1 +
 drivers/net/ethernet/broadcom/tg3.c              |    1 +
 drivers/net/ethernet/freescale/fec_ptp.c         |    1 +
 drivers/net/ethernet/freescale/gianfar_ptp.c     |    1 +
 drivers/net/ethernet/intel/e1000e/ptp.c          |    1 +
 drivers/net/ethernet/mellanox/mlx4/en_clock.c    |    1 +
 drivers/net/ethernet/sfc/ptp.c                   |    1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c |    1 +
 drivers/net/ethernet/ti/cpts.c                   |    1 +
 drivers/net/ethernet/tile/tilegx.c               |    1 +
 drivers/net/phy/dp83640.c                        |   93 ++++++++++++---
 drivers/ptp/ptp_chardev.c                        |  133 +++++++++++++++++++++-
 drivers/ptp/ptp_clock.c                          |   23 ++++
 drivers/ptp/ptp_ixp46x.c                         |    1 +
 drivers/ptp/ptp_pch.c                            |    1 +
 drivers/ptp/ptp_private.h                        |    7 ++
 drivers/ptp/ptp_sysfs.c                          |  112 ++++++++++++++++++
 include/linux/ptp_clock_kernel.h                 |   33 ++++++
 include/uapi/linux/ptp_clock.h                   |   39 ++++++-
 21 files changed, 510 insertions(+), 20 deletions(-)

-- 
1.7.10.4

