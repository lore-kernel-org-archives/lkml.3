Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaBNSD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:03:57 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:51604 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaBNSDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:03:55 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming_Li <chaoming_li@realsil.com.cn>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        lekensteyn@gmail.com
Subject: [PATCH 0/3] rtlwifi promiscious mode fix and cleanup
Date: Fri, 14 Feb 2014 19:03:43 +0100
Message-Id: <1392401026-18417-1-git-send-email-lekensteyn@gmail.com>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While investigating bug 60713[1] which is about the inability to connect
with RTL8192CE hardware, I noticed that the monitor mode only shows
broadcast and multicast frames. The cause is described next.

`rtlpci->receive_config` seems to contain the current value of REG_RCR.
It gets initialized in rtl*_init_sw_vars. It is returned by
rtl*_get_hw_reg and set by rtl*_set_hw_reg (after writing to REG_RCR).

`mac->rx_conf` is initialized in rtl_init_rx_config. For PCIe drivers,
it gets inited from `receive_config` via get_hw_reg (one of the
functions from the previous section).

When monitor mode is enabled with otherbss set, rtl_op_configure_filter
is called. This has a problem:

(1) The rtl_op_configure_filter function only sets mac->rx_conf.
(2) rx_conf is only written to register REG_RCR by rtl8192cu and besides
    that driver, it is only read by rtl_init_rx_config in base.c.

Patch 2/3 fixes the above issue. 1/2 makes accessing RCR more consistent
and 3/3 removes unused functions (yay, less code!). Similar
modifications (3 and probably 1) need to be done for staging.

I have tested these patches on top of v3.14-rc2-267-g9398a10, but it
unfortunately does not improve the connectivity problem. It got even
stranger, when I run `iw wlan0 set monitor fcsfail`, I do not see a
"Enable receive FCS error frame" message with debug=5. Instead I see
"Enable receive control frame". More testing will be done later this
day. For example, only the first and second EAPOL frame of a second test
device got captured, others got lost somehow. Hopefully it is not a
memory corruption issue somewhere.

Related question for a Realtek engineer (or someone with access to the
specs): the rx_ctrl_filter and rx_data_filter fields are only *read* in
the rtl8192cu driver. Besides that they are unused. Can this be removed?
Otherwise, what about moving them to rtl_init_rx_config() and updating
the *_get_hw_reg() functions to ignore/process the vars? After doing so,
_update_mac_setting can be removed from rtl8192cu/hw.c.

Regards,
Peter

 [1]: https://bugzilla.kernel.org/show_bug.cgi?id=60713
---

Peter Wu (3):
  rtlwifi: avoid accessing RCR directly
  rtlwifi: properly apply filter flags
  rtlwifi: remove unused allow_all_destaddr functions

 drivers/net/wireless/rtlwifi/core.c         | 52 +++++++++++++++++------------
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c | 25 ++------------
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.h |  2 --
 drivers/net/wireless/rtlwifi/rtl8188ee/sw.c |  1 -
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c | 25 ++------------
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.h |  2 --
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c |  1 -
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c |  4 ++-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c |  6 ++--
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c | 25 ++------------
 drivers/net/wireless/rtlwifi/rtl8192se/hw.h |  2 --
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c |  1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c | 26 ++-------------
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.h |  2 --
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c |  1 -
 drivers/net/wireless/rtlwifi/wifi.h         |  2 --
 16 files changed, 49 insertions(+), 128 deletions(-)

-- 
1.8.5.4

