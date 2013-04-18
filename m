Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966961Ab3DROYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:24:04 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:33542 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966179Ab3DROYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:24:02 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Kay Sievers <kay@vrfy.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH RFC] Fix bug if earlyprintk is called twice
Date: Thu, 18 Apr 2013 16:23:38 +0200
Message-Id: <1366295019-30335-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

If on the kernel command line the parameter "earlyprintk" is written
twice, then setup_early_printk is called twice. This can happen for
example with the option CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_EXTEND is
selected, and the "earlyprintk" is passed from the ATAG_CMDLINE and
from the dtb.

This lead to an infinite loop on the message "Booting Linux on
physical CPU 0" displayed from smp_setup_processor_id() in
arch/arm/kernel/setup.c. This behavior as been reproduced on ARMv7
architecture (Armada XP and Armada 370), and on a ARMv5 one
(AT91SAMG35 thanks to Richard Genoud), with and with CONFIG_SMP
selected.

After some investigation I found that the problem happened when the
early_console is register for the second time in file kernel/printk.c
on line 2310 when the function console_lock() is called, and in this
function I managed to have traces until the call to down(&console_sem)
one line 1922. Keep in mind that I had this information using printk
so maybe it was not the best way to debug the console!

I didn't had other platform that ARM one for testing this behavior, so
I don't know if this bug is specific to ARM. If you think it is
something specific to ARM then I propose the patch in the following
email.

Any feedback on this issue would be welcome

Thanks,

Gregory CLEMENT (1):
  ARM: don't allow to register the early_console twice

 arch/arm/kernel/early_printk.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
1.7.9.5

