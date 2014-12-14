Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaLNUdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:33:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaLNUWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:22:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ronald Wahl <ronald.wahl@raritan.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14 31/34] mac80211: Fix regression that triggers a kernel BUG with CCMP
Date: Sun, 14 Dec 2014 12:21:09 -0800
Message-Id: <20141214201804.704127042@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201803.791392744@linuxfoundation.org>
References: <20141214201803.791392744@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronald Wahl <ronald.wahl@raritan.com>

commit 4f031fa9f188b2b0641ac20087d9e16bcfb4e49d upstream.

Commit 7ec7c4a9a686c608315739ab6a2b0527a240883c (mac80211: port CCMP to
cryptoapi's CCM driver) introduced a regression when decrypting empty
packets (data_len == 0). This will lead to backtraces like:

(scatterwalk_start) from [<c01312f4>] (scatterwalk_map_and_copy+0x2c/0xa8)
(scatterwalk_map_and_copy) from [<c013a5a0>] (crypto_ccm_decrypt+0x7c/0x25c)
(crypto_ccm_decrypt) from [<c032886c>] (ieee80211_aes_ccm_decrypt+0x160/0x170)
(ieee80211_aes_ccm_decrypt) from [<c031c628>] (ieee80211_crypto_ccmp_decrypt+0x1ac/0x238)
(ieee80211_crypto_ccmp_decrypt) from [<c032ef28>] (ieee80211_rx_handlers+0x870/0x1d24)
(ieee80211_rx_handlers) from [<c0330c7c>] (ieee80211_prepare_and_rx_handle+0x8a0/0x91c)
(ieee80211_prepare_and_rx_handle) from [<c0331260>] (ieee80211_rx+0x568/0x730)
(ieee80211_rx) from [<c01d3054>] (__carl9170_rx+0x94c/0xa20)
(__carl9170_rx) from [<c01d3324>] (carl9170_rx_stream+0x1fc/0x320)
(carl9170_rx_stream) from [<c01cbccc>] (carl9170_usb_tasklet+0x80/0xc8)
(carl9170_usb_tasklet) from [<c00199dc>] (tasklet_hi_action+0x88/0xcc)
(tasklet_hi_action) from [<c00193c8>] (__do_softirq+0xcc/0x200)
(__do_softirq) from [<c0019734>] (irq_exit+0x80/0xe0)
(irq_exit) from [<c0009c10>] (handle_IRQ+0x64/0x80)
(handle_IRQ) from [<c000c3a0>] (__irq_svc+0x40/0x4c)
(__irq_svc) from [<c0009d44>] (arch_cpu_idle+0x2c/0x34)

Such packets can appear for example when using the carl9170 wireless driver
because hardware sometimes generates garbage when the internal FIFO overruns.

This patch adds an additional length check.

Fixes: 7ec7c4a9a686 ("mac80211: port CCMP to cryptoapi's CCM driver")
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 net/mac80211/aes_ccm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/aes_ccm.c
+++ b/net/mac80211/aes_ccm.c
@@ -54,6 +54,9 @@ int ieee80211_aes_ccm_decrypt(struct cry
 
 	memset(&aead_req, 0, sizeof(aead_req));
 
+	if (data_len == 0)
+		return -EINVAL;
+
 	sg_init_one(&pt, data, data_len);
 	sg_init_one(&assoc, &aad[2], be16_to_cpup((__be16 *)aad));
 	sg_init_table(ct, 2);


