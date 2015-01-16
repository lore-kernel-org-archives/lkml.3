Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbbAPOkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:40:36 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51082 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbbAPOkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:40:22 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-c2-54b922d5539f
From: Paul Osmialowski <p.osmialowsk@samsung.com>
To: Wolfram Sang <wsa@the-dreams.de>, Jonathan Corbet <corbet@lwn.net>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: [RFC 1/3] i2c: Enhancement of i2c API to address circular lock
 dependency problem
Date: Fri, 16 Jan 2015 15:39:52 +0100
Message-id: <1421419194-1849-1-git-send-email-p.osmialowsk@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEJMWRmVeSWpSXmKPExsVy+t/xy7pXlXaGGPz8wWEx9eETNosnB9oZ
	LZoXr2ez6H/8mtliYdsSFouOv18YLS7vmsNmMeP8PiaLCW8OMFusPDGL2YHLY9OqTjaP/XPX
	sHss7pvM6tG3ZRWjx8lTT1g8Pm+SC2CL4rJJSc3JLEst0rdL4MrY8eQmS8Gb8IqLT++wNjC+
	culi5OSQEDCRmH5sDzOELSZx4d56ti5GLg4hgaWMEo9fn2YDSQgJ9DJJ7HnOD2KzCRhK3Px/
	mBGkSERgB5PEw3uHwYqYBfQlmvqfgk0SFoiRaO1+A2azCKhKfHrwmxXE5hVwl/h6bCELxDY5
	iZPHJrNOYORewMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMknL7uYFx6zOoQowAHoxIP
	r8OmHSFCrIllxZW5hxglOJiVRHgzBHaGCPGmJFZWpRblxxeV5qQWH2Jk4uCUamCcddv11uRM
	2alr7TuMmvID+523+vbNqozqO9dkp/ylNzoswb4k1kOgiTtnz9ELNy69KT8UyNT2X9XO+VGB
	2V3e0PCwCtvq74pKjOtiqzTN7k2KWmi4+5/g1CjxP3nLf2xeP2XGhXbjLbusbiks9+rhmHMy
	aCMnW9ElXVHrEz1WrxxePo55u0iJpTgj0VCLuag4EQBA5rKOBQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enhancement of i2c API is designed to address following problem
caused by circular lock dependency:

-> #1 (prepare_lock){+.+.+.}:
[    2.730502]        [<c0061e50>] __lock_acquire+0x3c0/0x8a4
[    2.735970]        [<c0062868>] lock_acquire+0x6c/0x8c
[    2.741090]        [<c04a2724>] mutex_lock_nested+0x68/0x464
[    2.746733]        [<c0395e84>] clk_prepare_lock+0x40/0xe8
[    2.752201]        [<c0397698>] clk_unprepare+0x18/0x28
[    2.757409]        [<c034cbb0>] s3c24xx_i2c_xfer+0xc8/0x124
[    2.762964]        [<c03457e0>] __i2c_transfer+0x74/0x8c
[    2.768259]        [<c0347234>] i2c_transfer+0x78/0xec
[    2.773380]        [<c02a177c>] regmap_i2c_read+0x48/0x64
[    2.778761]        [<c029d5c0>] _regmap_raw_read+0xa8/0xfc
[    2.784230]        [<c029d920>] _regmap_bus_read+0x28/0x48
[    2.789699]        [<c029ce00>] _regmap_read+0x74/0xdc
[    2.794819]        [<c029d0ec>] _regmap_update_bits+0x24/0x70
[    2.800549]        [<c029e348>] regmap_update_bits+0x40/0x5c
[    2.806190]        [<c024c3c4>] _regulator_do_disable+0x68/0x7c
[    2.812093]        [<c024f4d8>] _regulator_disable+0x90/0x12c
[    2.817822]        [<c024f5a8>] regulator_disable+0x34/0x60
[    2.823377]        [<c0363070>] mmc_regulator_set_ocr+0x74/0xdc
[    2.829279]        [<c03783e8>] sdhci_set_power+0x38/0x20c
[    2.834748]        [<c0379c10>] sdhci_do_set_ios+0x180/0x450
[    2.840389]        [<c0379f00>] sdhci_set_ios+0x20/0x2c
[    2.845597]        [<c0364978>] mmc_set_initial_state+0x5c/0xbc
[    2.851500]        [<c0364f48>] mmc_power_off+0x2c/0x60
[    2.856708]        [<c0365c00>] mmc_rescan+0x268/0x27c
[    2.861829]        [<c003a128>] process_one_work+0x18c/0x3f8
[    2.867471]        [<c003a400>] worker_thread+0x38/0x2f8
[    2.872766]        [<c003f66c>] kthread+0xe4/0x104
[    2.877540]        [<c000f0a8>] ret_from_fork+0x14/0x2c
[    2.882749]
-> #0 (&map->mutex){+.+...}:
[    2.886828]        [<c0061224>] validate_chain.isra.25+0x3bc/0x548
[    2.892990]        [<c0061e50>] __lock_acquire+0x3c0/0x8a4
[    2.898459]        [<c0062868>] lock_acquire+0x6c/0x8c
[    2.903580]        [<c04a2724>] mutex_lock_nested+0x68/0x464
[    2.909222]        [<c029ce9c>] regmap_read+0x34/0x5c
[    2.914257]        [<c039a994>] max_gen_clk_is_prepared+0x1c/0x38
[    2.920333]        [<c0396ec4>] clk_unprepare_unused_subtree+0x64/0x98
[    2.926842]        [<c0396f78>] clk_disable_unused+0x80/0xd8
[    2.932484]        [<c00089d0>] do_one_initcall+0xac/0x1f0
[    2.937953]        [<c068bd44>] do_basic_setup+0x90/0xc8
[    2.943248]        [<c068be00>] kernel_init_freeable+0x84/0x120
[    2.949150]        [<c0491248>] kernel_init+0x8/0xec
[    2.954097]        [<c000f0a8>] ret_from_fork+0x14/0x2c
[    2.959307]
[    2.959307] other info that might help us debug this:
[    2.959307]
[    2.967293]  Possible unsafe locking scenario:
[    2.967293]
[    2.973194]        CPU0                    CPU1
[    2.977708]        ----                    ----
[    2.982221]   lock(prepare_lock);
[    2.985520]                                lock(&map->mutex);
[    2.991248]                                lock(prepare_lock);
[    2.997063]   lock(&map->mutex);
[    3.000276]
[    3.000276]  *** DEADLOCK ***

Apparently regulator and clock try to acquire lock which is protecting the
same regmap. Communication over i2c requires clock to be started. Both things
require access to the same regmap in order to complete.
To solve this, i2c clock should be started before attempting operation on
regulator (which requires locked regmap).
Exposing preparation and unpreparation stage of i2c transfer serves this
purpose.
Note that this change does not require modifications in other places:
old behaviour is kept preserved. Anyone who requires this new way of using i2c
transfer can adapt their drivers voluntarily.
Separate commit adapts regmap to use this new feature.

Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
---
 Documentation/i2c/writing-clients |  15 ++++++
 drivers/i2c/i2c-core.c            | 105 ++++++++++++++++++++++++++++++++++++++
 include/linux/i2c.h               |  16 ++++++
 3 files changed, 136 insertions(+)

diff --git a/Documentation/i2c/writing-clients b/Documentation/i2c/writing-clients
index a755b14..d6732a8 100644
--- a/Documentation/i2c/writing-clients
+++ b/Documentation/i2c/writing-clients
@@ -343,6 +343,21 @@ stop bit is sent between transaction. The i2c_msg structure contains
 for each message the client address, the number of bytes of the message
 and the message data itself.
 
+	int i2c_transfer_prepare(struct i2c_adapter *adap);
+	void i2c_transfer_unprepare(struct i2c_adapter *adap);
+
+These routines are used for calling exposed prepare and unprepare stages of
+the i2c_transfer() function. Normally i2c_transfer() does some operations
+(e.g. clock preparation) before actual transfer. These operations are undone
+when transfer is finished. Unfortunately these preparations may take locks,
+even causing circular lock dependency. Sometimes the only way to avoid this
+is to call i2c_transfer_prepare() earlier. Note that these routines do
+nothing when bus driver does not implement `master_prepare_xfer' nor
+`master_unprepare_xfer' callbacks pointed by struct i2c_algorithm.
+Note that underlying bus driver implementing `master_xfer` callback
+should be aware of the fact that preparation stage was or was not invoked
+before i2c_transfer() function call and act accordingly.
+
 You can read the file `i2c-protocol' for more information about the
 actual I2C protocol.
 
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 39d25a8..d649475 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -2064,6 +2064,111 @@ module_exit(i2c_exit);
  */
 
 /**
+ * __i2c_transfer_prepare - unlocked flavor of prepare stage of transfer of
+ *                          a single or combined I2C message (may sleep).
+ * @adap: Handle to I2C bus
+ *
+ * This stage, if exposed by underlying driver, can be called before transfer
+ * in order to avoid deadlock caused by circular lock dependency.
+ *
+ * Returns 0 on success.
+ *
+ * Adapter lock must be held when calling this function. No debug logging
+ * takes place.
+ */
+int __i2c_transfer_prepare(struct i2c_adapter *adap)
+{
+	if (adap->algo->master_prepare_xfer)
+		return adap->algo->master_prepare_xfer(adap);
+
+	return 0;
+}
+EXPORT_SYMBOL(__i2c_transfer_prepare);
+
+/**
+ * i2c_transfer_prepare - prepare transfer of a single or combined I2C message
+ *                        (may sleep).
+ * @adap: Handle to I2C bus
+ *
+ * Returns 0 on success.
+ *
+ * This stage, if exposed by underlying driver, can be called before transfer
+ * in order to avoid deadlock caused by circular lock dependency.
+ */
+int i2c_transfer_prepare(struct i2c_adapter *adap)
+{
+	int ret = 0;
+
+	if (adap->algo->master_prepare_xfer) {
+		if (in_atomic() || irqs_disabled()) {
+			ret = i2c_trylock_adapter(adap);
+			if (!ret)
+				/* I2C activity is ongoing. */
+				return -EAGAIN;
+		} else {
+			i2c_lock_adapter(adap);
+		}
+		ret = __i2c_transfer_prepare(adap);
+		i2c_unlock_adapter(adap);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(i2c_transfer_prepare);
+
+/**
+ * __i2c_transfer_unprepare - unlocked flavor of prepare stage of transfer of
+ *                          a single or combined I2C message (may sleep).
+ * @adap: Handle to I2C bus
+ *
+ * This stage, if exposed by underlying driver, can be called afrer transfer
+ * in order to avoid deadlock caused by circular lock dependency.
+ *
+ * Adapter lock must be held when calling this function. No debug logging
+ * takes place.
+ */
+void __i2c_transfer_unprepare(struct i2c_adapter *adap)
+{
+	if (adap->algo->master_unprepare_xfer)
+		adap->algo->master_unprepare_xfer(adap);
+}
+EXPORT_SYMBOL(__i2c_transfer_unprepare);
+
+/**
+ * i2c_transfer_unprepare - unprepare after transfer of a single or combined
+ *                          I2C message (may sleep).
+ * @adap: Handle to I2C bus
+ *
+ * This stage, if exposed by underlying driver, can be called afrer transfer
+ * in order to avoid deadlock caused by circular lock dependency.
+ */
+void i2c_transfer_unprepare(struct i2c_adapter *adap)
+{
+	if (adap->algo->master_unprepare_xfer) {
+		if (in_atomic() || irqs_disabled()) {
+			/* Wait max 20 ms */
+			int timeout = 20;
+
+			while (!(i2c_trylock_adapter(adap))) {
+				if (timeout == 0) {
+					/* I2C activity is still ongoing. */
+					pr_err("%s: can't unprepare transfer\n",
+					__func__);
+					return;
+				}
+				timeout--;
+				mdelay(1);
+			}
+		} else {
+			i2c_lock_adapter(adap);
+		}
+		__i2c_transfer_unprepare(adap);
+		i2c_unlock_adapter(adap);
+	}
+}
+EXPORT_SYMBOL(i2c_transfer_unprepare);
+
+/**
  * __i2c_transfer - unlocked flavor of i2c_transfer
  * @adap: Handle to I2C bus
  * @msgs: One or more messages to execute before STOP is issued to
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index e3a1721..fce2a5a 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -64,6 +64,14 @@ extern int i2c_master_send(const struct i2c_client *client, const char *buf,
 extern int i2c_master_recv(const struct i2c_client *client, char *buf,
 			   int count);
 
+/* Transfer prepare/unprepare stage (if needed/exposed).
+ */
+extern int i2c_transfer_prepare(struct i2c_adapter *adap);
+extern void i2c_transfer_unprepare(struct i2c_adapter *adap);
+/* Unlocked flavor */
+extern int __i2c_transfer_prepare(struct i2c_adapter *adap);
+extern void __i2c_transfer_unprepare(struct i2c_adapter *adap);
+
 /* Transfer num messages.
  */
 extern int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
@@ -371,6 +379,12 @@ i2c_register_board_info(int busnum, struct i2c_board_info const *info,
  * @master_xfer: Issue a set of i2c transactions to the given I2C adapter
  *   defined by the msgs array, with num messages available to transfer via
  *   the adapter specified by adap.
+ * @master_prepare_xfer: Exposed preparation stage of @master_xfer - use when
+ *   master_xfer must be split into stages: prepare, xfer, unprepare.
+ *   Set to NULL when not exposed.
+ * @master_unprepare_xfer: Exposed unpreparation stage of @master_xfer -
+ *   use when master_xfer must be split into stages: prepare, xfer, unprepare.
+ *   Set to NULL when not exposed.
  * @smbus_xfer: Issue smbus transactions to the given I2C adapter. If this
  *   is not present, then the bus layer will try and convert the SMBus calls
  *   into I2C transfers instead.
@@ -397,6 +411,8 @@ struct i2c_algorithm {
 	   processed, or a negative value on error */
 	int (*master_xfer)(struct i2c_adapter *adap, struct i2c_msg *msgs,
 			   int num);
+	int (*master_prepare_xfer)(struct i2c_adapter *adap);
+	void (*master_unprepare_xfer)(struct i2c_adapter *adap);
 	int (*smbus_xfer) (struct i2c_adapter *adap, u16 addr,
 			   unsigned short flags, char read_write,
 			   u8 command, int size, union i2c_smbus_data *data);
-- 
1.9.1

