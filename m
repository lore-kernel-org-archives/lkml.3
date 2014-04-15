Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaDOA2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 20:28:42 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:59850 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaDOA2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 20:28:40 -0400
Message-ID: <534C7D36.9090008@linaro.org>
Date: Mon, 14 Apr 2014 17:28:38 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Peter Maydell <peter.maydell@linaro.org>, Chris Ball <chris@printf.net>,
        Johan Rudholm <jrudholm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [Regression?] qemu-system-arm flooding "sd_write_data: not in Receiving-Data
 state"
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Forgive the duplicate, I forgot to cc lkml)

I was testing v3.15-rc1 in my qemu-system-arm environment and noticed a
flood of the following messages:
    sd_write_data: not in Receiving-Data state

After looking around in the kernel and not finding such a message, I
realized this was actually a message from qemu, not the kernel.

The system seems to boot normally, but is just very noisy w/ the qemu
messages.

Not sure if this is really a problem with qemu-system-arm, but this
doesn't occur w/ 3.14 and previous kernels.

Bisecting it down pointed to:

commit e7f3d22289e4307b3071cc18b1d8ecc6598c0be4
Author: Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri Jan 10 14:51:42 2014 +0100

    mmc: mmci: Handle CMD irq before DATA irq
        In case of a read operation both MCI_CMDRESPEND and MCI_DATAEND
can be
    set in the status register when entering the interrupt handler. This is
    due to that the card start sending data before the host has
    acknowledged the command response.
        To resolve the issue for this scenario, we must start by
handling the
    CMD irq instead of the DATA irq. The reason is beacuse the completion
    of the DATA irq will not respect the current command and then causing
    it to be garbled.
        Cc: Russell King <linux@arm.linux.org.uk>
    Cc: Johan Rudholm <jrudholm@gmail.com>
    Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
    Signed-off-by: Chris Ball <chris@printf.net>




$ qemu-system-arm -version
QEMU emulator version 1.5.0 (Debian 1.5.0+dfsg-3ubuntu5.3), Copyright
(c) 2003-2008 Fabrice Bellard

Booting w/:
qemu-system-arm -kernel zImage-arm -M vexpress-a9 -cpu cortex-a9
-nographic -m 1024  -append 'root=/dev/mmcblk0p2 rw mem=1024M
raid=noautodetect console=ttyAMA0,38400n8 rootwait vmalloc=256MB
devtmpfs.mount=0' -sd test-arm.img -redir tcp:4300::22

Let me know if you have any other questions or need any other info to
help trouble-shoot this.

thanks
-john
