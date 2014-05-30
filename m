Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbaE3GQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:16:24 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:45544 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbaE3GQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:16:21 -0400
X-Greylist: delayed 90010 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2014 02:16:20 EDT
X-AuditID: 85900ec0-d0927b9000001514-d3-53882231b629
Subject: [PATCH V8 0/2] serial/uart/8250: Introduce tunable RX trigger I/F
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Alan <gnomes@lxorguk.ukuu.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Date: Fri, 30 May 2014 15:16:17 +0900
Message-ID: <20140530061617.21929.25777.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This patch set introduces tunable RX interrupt trigger I/F for 8250 serials.
I just split V7's patch up into 2 patches, and all functions are not changed
from previous version. V6 patch was reviewed by Stephen Warren and acked, 
but I removed the 'Reviewed-by' for this patch set just in case.

Thanks!

<Change log>

Changed in V2:
 - Use _IOW for TIOCSFIFORTRIG definition
 - Pass the interrupt trigger value itself

Changes in V3:
 - Change I/F from ioctl(2) to sysfs(rx_int_trig)

Changes in V4:
 - Introduce fifo_bug flag in uart_8250_port structure
   This is enabled only when parity is enabled and UART_BUG_PARITY is enabled
   for up->bugs. If this flag is enabled, user cannot set RX trigger.
 - Return -EOPNOTSUPP when it does not support device at convert_fcr2val() and
   at convert_val2rxtrig()
 - Set the nearest lower RX trigger when users input a meaningless value at
   convert_val2rxtrig()
 - Check whether p->fcr is existing at serial8250_clear_and_reinit_fifos()
 - Set fcr = up->fcr in the begging of serial8250_do_set_termios()

Changes in V5:
 - Support Tegra, 16650V2, 16654, and 16750
 - Store default FCR value to up->fcr when the port is first created
 - Add rx_trig_byte[] in uart_config[] for each device and use rx_trig_byte[]
   in convert_fcr2val() and convert_val2rxtrig()

Changes in V5.1:
 - Fix FCR_RX_TRIG_MAX_STATE definition

Changes in V6:
 - Move FCR_RX_TRIG_* definition in 8250.h to include/uapi/linux/serial_reg.h,
   rename those to UART_FCR_R_TRIG_*, and use UART_FCR_TRIGGER_MASK to
   UART_FCR_R_TRIG_BITS()
 - Change following function names:
    convert_fcr2val() => fcr_get_rxtrig_bytes()
    convert_val2rxtrig() => bytes_to_fcr_rxtrig()
 - Fix typo in serial8250_do_set_termios()
 - Delete the verbose error message pr_info() in bytes_to_fcr_rxtrig()
 - Rename *rx_int_trig/rx_trig* to *rxtrig* for several functions or variables
   (but UI remains rx_int_trig)
 - Change the meaningless variable name 'val' to 'bytes' following functions:
    fcr_get_rxtrig_bytes(), bytes_to_fcr_rxtrig(), do_set_rxtrig(),
    do_serial8250_set_rxtrig(), and serial8250_set_attr_rxtrig()
 - Use up->fcr in order to get rxtrig_bytes instead of rx_trig_raw in
   fcr_get_rxtrig_bytes()
 - Use conf_type->rxtrig_bytes[0] instead of switch statement for support check
   in register_dev_spec_attr_grp()
 - Delete the checking whether a user changed FCR or not when minimum buffer
   is needed in serial8250_do_set_termios()

Changes in V7:
 - Add Documentation
 - Change I/F name from rx_int_trig to rx_trig_bytes because the name
   rx_int_trig is hard to understand how users specify the value

Changes in V8:
 - Split V7's patch up into 2 patches

---

Yoshihiro YUNOMAE (2):
      serial/uart: Introduce device specific attribute group to uart_port structure
      serial/uart/8250: Add tunable RX interrupt trigger I/F of FIFO buffers


 Documentation/ABI/testing/sysfs-tty |   16 +++
 drivers/tty/serial/8250/8250.h      |    2 
 drivers/tty/serial/8250/8250_core.c |  173 ++++++++++++++++++++++++++++++++---
 drivers/tty/serial/serial_core.c    |   18 ++--
 include/linux/serial_8250.h         |    2 
 include/linux/serial_core.h         |    4 +
 include/uapi/linux/serial_reg.h     |    5 +
 7 files changed, 198 insertions(+), 22 deletions(-)

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
