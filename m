Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaLGBJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 20:09:43 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41913 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaLGBJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 20:09:42 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm: mach-msm: smd.c:  Remove some unused functions
Date: Sun,  7 Dec 2014 02:12:20 +0100
Message-Id: <1417914740-8390-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
smsm_set_sleep_duration() smsm_get_state() smd_wait_until_writable()
smd_wait_until_readable() smd_write_atomic() smd_sleep_exit()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-msm/include/mach/msm_smd.h |    9 ---
 arch/arm/mach-msm/smd.c                  |  105 ------------------------------
 arch/arm/mach-msm/smd_private.h          |    2 -
 3 files changed, 116 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/msm_smd.h b/arch/arm/mach-msm/include/mach/msm_smd.h
index 029463e..48ddef98 100644
--- a/arch/arm/mach-msm/include/mach/msm_smd.h
+++ b/arch/arm/mach-msm/include/mach/msm_smd.h
@@ -40,7 +40,6 @@ int smd_read(smd_channel_t *ch, void *data, int len);
 ** it will return the requested length written or an error.
 */
 int smd_write(smd_channel_t *ch, const void *data, int len);
-int smd_write_atomic(smd_channel_t *ch, const void *data, int len);
 
 int smd_write_avail(smd_channel_t *ch);
 int smd_read_avail(smd_channel_t *ch);
@@ -57,14 +56,6 @@ int smd_cur_packet_size(smd_channel_t *ch);
 void smd_kick(smd_channel_t *ch);
 
 
-#if 0
-/* these are interruptable waits which will block you until the specified
-** number of bytes are readable or writable.
-*/
-int smd_wait_until_readable(smd_channel_t *ch, int bytes);
-int smd_wait_until_writable(smd_channel_t *ch, int bytes);
-#endif
-
 typedef enum {
 	SMD_PORT_DS = 0,
 	SMD_PORT_DIAG,
diff --git a/arch/arm/mach-msm/smd.c b/arch/arm/mach-msm/smd.c
index b1588a1..4bc1e71 100644
--- a/arch/arm/mach-msm/smd.c
+++ b/arch/arm/mach-msm/smd.c
@@ -401,36 +401,6 @@ static inline int smd_need_int(struct smd_channel *ch)
 	return 0;
 }
 
-void smd_sleep_exit(void)
-{
-	unsigned long flags;
-	struct smd_channel *ch;
-	int need_int = 0;
-
-	spin_lock_irqsave(&smd_lock, flags);
-	list_for_each_entry(ch, &smd_ch_list_modem, ch_list) {
-		if (smd_need_int(ch)) {
-			need_int = 1;
-			break;
-		}
-	}
-	list_for_each_entry(ch, &smd_ch_list_dsp, ch_list) {
-		if (smd_need_int(ch)) {
-			need_int = 1;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&smd_lock, flags);
-	do_smd_probe();
-
-	if (need_int) {
-		if (msm_smd_debug_mask & MSM_SMD_DEBUG)
-			pr_info("smd_sleep_exit need interrupt\n");
-		tasklet_schedule(&smd_fake_irq_tasklet);
-	}
-}
-
-
 void smd_kick(smd_channel_t *ch)
 {
 	unsigned long flags;
@@ -747,16 +717,6 @@ int smd_write(smd_channel_t *ch, const void *data, int len)
 	return ch->write(ch, data, len);
 }
 
-int smd_write_atomic(smd_channel_t *ch, const void *data, int len)
-{
-	unsigned long flags;
-	int res;
-	spin_lock_irqsave(&smd_lock, flags);
-	res = ch->write(ch, data, len);
-	spin_unlock_irqrestore(&smd_lock, flags);
-	return res;
-}
-
 int smd_read_avail(smd_channel_t *ch)
 {
 	return ch->read_avail(ch);
@@ -767,16 +727,6 @@ int smd_write_avail(smd_channel_t *ch)
 	return ch->write_avail(ch);
 }
 
-int smd_wait_until_readable(smd_channel_t *ch, int bytes)
-{
-	return -1;
-}
-
-int smd_wait_until_writable(smd_channel_t *ch, int bytes)
-{
-	return -1;
-}
-
 int smd_cur_packet_size(smd_channel_t *ch)
 {
 	return ch->current_packet;
@@ -875,61 +825,6 @@ int smsm_change_state(enum smsm_state_item item,
 	return 0;
 }
 
-uint32_t smsm_get_state(enum smsm_state_item item)
-{
-	unsigned long flags;
-	uint32_t rv;
-
-	spin_lock_irqsave(&smem_lock, flags);
-
-	rv = readl(smd_info.state + item * 4);
-
-	if (item == SMSM_STATE_MODEM && (rv & SMSM_RESET))
-		handle_modem_crash();
-
-	spin_unlock_irqrestore(&smem_lock, flags);
-
-	return rv;
-}
-
-#ifdef CONFIG_ARCH_MSM_SCORPION
-
-int smsm_set_sleep_duration(uint32_t delay)
-{
-	struct msm_dem_slave_data *ptr;
-
-	ptr = smem_find(SMEM_APPS_DEM_SLAVE_DATA, sizeof(*ptr));
-	if (ptr == NULL) {
-		pr_err("smsm_set_sleep_duration <SM NO APPS_DEM_SLAVE_DATA>\n");
-		return -EIO;
-	}
-	if (msm_smd_debug_mask & MSM_SMSM_DEBUG)
-		pr_info("smsm_set_sleep_duration %d -> %d\n",
-		       ptr->sleep_time, delay);
-	ptr->sleep_time = delay;
-	return 0;
-}
-
-#else
-
-int smsm_set_sleep_duration(uint32_t delay)
-{
-	uint32_t *ptr;
-
-	ptr = smem_find(SMEM_SMSM_SLEEP_DELAY, sizeof(*ptr));
-	if (ptr == NULL) {
-		pr_err("smsm_set_sleep_duration <SM NO SLEEP_DELAY>\n");
-		return -EIO;
-	}
-	if (msm_smd_debug_mask & MSM_SMSM_DEBUG)
-		pr_info("smsm_set_sleep_duration %d -> %d\n",
-		       *ptr, delay);
-	*ptr = delay;
-	return 0;
-}
-
-#endif
-
 int smd_core_init(void)
 {
 	int r;
diff --git a/arch/arm/mach-msm/smd_private.h b/arch/arm/mach-msm/smd_private.h
index 727bfe6..702f34e 100644
--- a/arch/arm/mach-msm/smd_private.h
+++ b/arch/arm/mach-msm/smd_private.h
@@ -148,8 +148,6 @@ enum smsm_state_item {
 
 void *smem_alloc(unsigned id, unsigned size);
 int smsm_change_state(enum smsm_state_item item, uint32_t clear_mask, uint32_t set_mask);
-uint32_t smsm_get_state(enum smsm_state_item item);
-int smsm_set_sleep_duration(uint32_t delay);
 void smsm_print_sleep_info(void);
 
 #define SMEM_NUM_SMD_CHANNELS        64
-- 
1.7.10.4

