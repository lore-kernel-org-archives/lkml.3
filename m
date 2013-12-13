Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3LMChu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:37:50 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:28068 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3LMChr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:37:47 -0500
Message-ID: <52AA72B4.4080807@huawei.com>
Date: Fri, 13 Dec 2013 10:36:36 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: Hushiyuan <hushiyuan@huawei.com>,
        <openipmi-developer@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhangdianfang <zhangdianfang@huawei.com>
Subject: [PATCH 0/2] ipmi: fix timeout calculation when bmc is disconnected
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hu Shiyuan report, when loading ipmi_si module while bmc is
disconnected, we found the timeout is longer than 5 secs.
Actually it takes about 3 mins and 20 secs (HZ=250).

error message as below:
Dec 12 19:08:59 linux kernel: IPMI BT: timeout in RD_WAIT [ ] 1 retries left
Dec 12 19:08:59 linux kernel: BT: write 4 bytes seq=0x01 03 18 00 01
[...]
Dec 12 19:12:19 linux kernel: IPMI BT: timeout in RD_WAIT [ ]
Dec 12 19:12:19 linux kernel: failed 2 retries, sending error response
Dec 12 19:12:19 linux kernel: IPMI: BT reset (takes 5 secs)
Dec 12 19:12:19 linux kernel: IPMI BT: flag reset [ ]

Function wait_for_msg_done() use schedule_timeout_uninterruptible(1)
to sleep 1 tick, so we should subtract jiffies_to_usecs(1) usecs
instead of 100 usecs from timeout.

For more clearly, I used USEC_PER_SEC instead of 1000000.

Xie XiuQi (2):
  ipmi: use USEC_PER_SEC instead of 1000000 for more meaningful
  ipmi: fix timeout calculation when bmc is disconnected

 drivers/char/ipmi/ipmi_bt_sm.c   | 8 ++++----
 drivers/char/ipmi/ipmi_kcs_sm.c  | 4 ++--
 drivers/char/ipmi/ipmi_si_intf.c | 2 +-
 drivers/char/ipmi/ipmi_smic_sm.c | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

-- 
1.8.2.2


