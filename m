Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaLCMfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:35:45 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:50681 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaLCMfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:35:43 -0500
From: Harini Katakam <harinik@xilinx.com>
To: wsa@the-dreams.de, mark.rutland@arm.com
Cc: michal.simek@xilinx.com, soren.brinkmann@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, vishnum@xilinx.com, harinik@xilinx.com,
        harinikatakamlinux@gmail.com
Subject: [PATCH v2 0/3] Cadence I2C driver fixes
Date: Wed,  3 Dec 2014 18:05:23 +0530
Message-Id: <1417610126-7957-1-git-send-email-harinik@xilinx.com>
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
- >252 byte transfer are done such that transfer_size never becomes zero.
- timeout register value is increased (even though the driver doesn't use this).
- A check is performed to see if there any transfer following a
read/receive transfer in the set of messages using repeated start.
An error is returned in such cases because if we proceed, completion interrupt
is never obtained and a SW timeout will occur.

Harini Katakam (2):
  i2c: cadence: Handle > 252 byte transfers
  i2c: cadence: Check for errata condition involving master receive

Vishnu Motghare (1):
  i2c: cadence: Set the hardware time-out register to maximum value

 drivers/i2c/busses/i2c-cadence.c |  178 ++++++++++++++++++++++----------------
 1 file changed, 103 insertions(+), 75 deletions(-)

-- 
1.7.9.5

