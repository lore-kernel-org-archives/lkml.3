Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaK2COV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 21:14:21 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:37570 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaK2COT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 21:14:19 -0500
Content-Type: text/plain; charset=koi8-r
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [RFC] i2c: omap: TEST: do IP reset during probe.
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <20141128221350.GW2817@atomide.com>
Date: Sat, 29 Nov 2014 05:14:13 +0300
Cc: Kevin Hilman <khilman@kernel.org>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <AECD26B8-1FFA-4FFB-AC68-4CDC50F3F48B@gmail.com>
References: <1416685634-5864-3-git-send-email-al.kochet@gmail.com> <1417028722-29306-1-git-send-email-al.kochet@gmail.com> <7hzjbdd57j.fsf@deeprootsystems.com> <20141128221350.GW2817@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


29 нояб. 2014 г., в 1:13, Tony Lindgren <tony@atomide.com> написал(а):

> Looks like for some time 2430 i2c has not been behaving
> reliably

    commit dd74548ddece4b9d68e5528287a272fa552c81d0 ("i2c: omap:
    resize fifos before each message") dropped check for dev->buf_len.
    As result, data processing loop cause dev->buf overruns for
    devices with 16-bit data register (omap2420 only).
    Found by code review.

I have the patch for that. omap2420 actually broken at all.
But I'm not ready to send it right now.

Part of the patch:

-       while (num_bytes--) {
+       while (num_bytes) {
                w = omap_i2c_read_reg(dev, OMAP_I2C_DATA_REG);
                *dev->buf++ = w;
                dev->buf_len--;
+               num_bytes--;
 
                /*
                 * Data reg in 2430, omap3 and
                 * omap4 is 8 bit wide
                 */
                if (dev->flags & OMAP_I2C_FLAG_16BIT_DATA_REG) {
-                       *dev->buf++ = w >> 8;
-                       dev->buf_len--;
+                       if (num_bytes) {
+                               *dev->buf++ = w >> 8;
+                               dev->buf_len--;
+                               num_bytes--;
+                       }
                }
        }



-       while (num_bytes--) {
+       while (num_bytes) {
                if (dev->errata & I2C_OMAP_ERRATA_I462) {
                        int ret;
 
@@ -931,14 +947,18 @@ static int omap_i2c_transmit_data(struct omap_i2c_dev *dev, u8 num_bytes,
 
                w = *dev->buf++;
                dev->buf_len--;
+               num_bytes--;
 
                /*
                 * Data reg in 2430, omap3 and
                 * omap4 is 8 bit wide
                 */
                if (dev->flags & OMAP_I2C_FLAG_16BIT_DATA_REG) {
-                       w |= *dev->buf++ << 8;
-                       dev->buf_len--;
+                       if (num_bytes) {
+                               w |= *dev->buf++ << 8;
+                               dev->buf_len--;
+                               num_bytes--;
+                       }
                }

