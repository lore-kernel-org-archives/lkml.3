Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaIVDXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 23:23:18 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:50800 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaIVDXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 23:23:16 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <m.chehab@samsung.com>, <dheitmueller@kernellabs.com>,
        <shuah.kh@samsung.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] driver/drx39xyj: fix some compiling warnings
Date: Mon, 22 Sep 2014 11:22:43 +0800
Message-Id: <1411356163-6018-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling kernel, in module drx39xyj, there are some warnings
showing some variables may be used uninitialized, though they have
 been initialized in fact.

drivers/media/dvb-frontends/drx39xyj/drxj.c: In function
 ‘drxj_dap_atomic_read_reg32.isra.17’:
drivers/media/dvb-frontends/drx39xyj/drxj.c:2190:7: warning:
 ‘*((void *)&buf+3)’ may be used uninitialized in this function
[-Wmaybe-uninitialized]
  word = (u32) buf[3];
       ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:2192:10: warning:
 ‘*((void *)&buf+2)’ may be used uninitialized in this function
 [-Wmaybe-uninitialized]
  word |= (u32) buf[2];
          ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:2194:10: warning:
 ‘*((void *)&buf+1)’ may be used uninitialized in this function
 [-Wmaybe-uninitialized]
  word |= (u32) buf[1];
          ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:2196:10: warning:
 ‘buf’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  word |= (u32) buf[0];
          ^
drivers/media/dvb-frontends/drx39xyj/drxj.c: In function
 ‘drx39xxj_read_status’:
drivers/media/dvb-frontends/drx39xyj/drxj.c:10671:11: warning:
 ‘strength’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  u16 mer, strength;
           ^
drivers/media/dvb-frontends/drx39xyj/drxj.c: In function
 ‘drxj_dap_scu_atomic_read_reg16’:
drivers/media/dvb-frontends/drx39xyj/drxj.c:4208:9: warning:
 ‘*((void *)&buf+1)’ may be used uninitialized in this function
 [-Wmaybe-uninitialized]
  word = (u16) (buf[0] + (buf[1] << 8));
         ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:4208:9: warning:
 ‘buf’ may be used uninitialized in this function [-Wmaybe-uninitialized]

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 7ca7a21..afb14c70 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -2181,6 +2181,7 @@ int drxj_dap_atomic_read_reg32(struct i2c_device_addr *dev_addr,
 	if (!data)
 		return -EINVAL;
 
+	memset(buf, 0, sizeof(*data));
 	rc = drxj_dap_atomic_read_write_block(dev_addr, addr,
 					      sizeof(*data), buf, true);
 
@@ -4200,6 +4201,7 @@ int drxj_dap_scu_atomic_read_reg16(struct i2c_device_addr *dev_addr,
 	if (!data)
 		return -EINVAL;
 
+	memset(buf, 0, 2);
 	rc = drxj_dap_scu_atomic_read_write_block(dev_addr, addr, 2, buf, true);
 	if (rc < 0)
 		return rc;
@@ -10667,7 +10669,7 @@ ctrl_sig_quality(struct drx_demod_instance *demod,
 	enum drx_standard standard = ext_attr->standard;
 	int rc;
 	u32 ber, cnt, err, pkt;
-	u16 mer, strength;
+	u16 mer, strength = 0;
 
 	rc = get_sig_strength(demod, &strength);
 	if (rc < 0) {
-- 
2.0.0-rc0

