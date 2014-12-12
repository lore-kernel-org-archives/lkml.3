Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbaLLESq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 23:18:46 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:40723 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759949AbaLLESo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 23:18:44 -0500
From: Harini Katakam <harinik@xilinx.com>
To: wsa@the-dreams.de, mark.rutland@arm.com
Cc: michal.simek@xilinx.com, soren.brinkmann@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, harinikatakamlinux@gmail.com,
        harinik@xilinx.com
Subject: [PATCH v5 0/2] Cadence I2C driver fixes
Date: Fri, 12 Dec 2014 09:48:25 +0530
Message-Id: <1418357907-4215-1-git-send-email-harinik@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements workarounds for some bugs in Cadence I2C controller.

- The I2C controller when configured in Master Mode generates invalid read transactions.
When HOLD bit is set and HW timeout occurs, invalid read transactions are
generated on the bus. This will affect repeated start conditions and large
data transfer condtions where transfer_size_register has to be updated again.
The transfer size register rolls over erroneously under these conditions.
Note that this HW timeout cannot be disabled even if the interrupt is unused.
Errata link: http://www.xilinx.com/support/answers/61664.html

-The I2C controller when configured in Master Mode is the missing master completion interrupt.
During repeated start condition, the driver has to set the HOLD bit for
the set of transfer being done together and clear the HOLD bit just before
the last transfer. But the controller does not indicate completion when
a read/receive transfer is done if the HOLD bit is set. This affects
all repeated start operation where a read/receive transfer is not
the last transfer.
Errata link: http://www.xilinx.com/support/answers/61665.html

To address the above,
- >252 byte transfers are done such that transfer_size never becomes zero.
- timeout register value is increased (even though the driver doesn't use this).
- A check is performed to see if there is any transfer following a
read/receive transfer in the set of messages using repeated start.
An error is returned in such cases because if we proceed, completion interrupt
is never obtained and a SW timeout will occur.

Harini Katakam (2):
  i2c: cadence: Handle > 252 byte transfers
  i2c: cadence: Check for errata condition involving master receive

 drivers/i2c/busses/i2c-cadence.c |  185 +++++++++++++++++++++++---------------
 1 file changed, 112 insertions(+), 73 deletions(-)

-- 
1.7.9.5

