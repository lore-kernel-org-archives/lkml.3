Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaAWTGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:06:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbaAWTGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:06:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Phil Carmody <phil.carmody@partner.samsung.com>,
        Stephen Warren <swarren@nvidia.com>, Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.12 09/27] i2c: Re-instate body of i2c_parent_is_i2c_adapter()
Date: Thu, 23 Jan 2014 11:06:46 -0800
Message-Id: <20140123190649.661431498@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123190648.720195687@linuxfoundation.org>
References: <20140123190648.720195687@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 2fac2b891f287691c27ee8d2eeecf39571b27fea upstream.

The body of i2c_parent_is_i2c_adapter() is currently guarded by
I2C_MUX. It should be CONFIG_I2C_MUX instead.

Among potentially other problems, this resulted in i2c_lock_adapter()
only locking I2C mux child adapters, and not the parent adapter. In
turn, this could allow inter-mingling of mux child selection and I2C
transactions, which could result in I2C transactions being directed to
the wrong I2C bus, and possibly even switching between busses in the
middle of a transaction.

One concrete issue caused by this bug was corrupted HDMI EDID reads
during boot on the NVIDIA Tegra Seaboard system, although this only
became apparent in recent linux-next, when the boot timing was changed
just enough to trigger the race condition.

Fixes: 3923172b3d70 ("i2c: reduce parent checking to a NOOP in non-I2C_MUX case")
Cc: Phil Carmody <phil.carmody@partner.samsung.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/i2c.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -447,7 +447,7 @@ static inline void i2c_set_adapdata(stru
 static inline struct i2c_adapter *
 i2c_parent_is_i2c_adapter(const struct i2c_adapter *adapter)
 {
-#if IS_ENABLED(I2C_MUX)
+#if IS_ENABLED(CONFIG_I2C_MUX)
 	struct device *parent = adapter->dev.parent;
 
 	if (parent != NULL && parent->type == &i2c_adapter_type)


