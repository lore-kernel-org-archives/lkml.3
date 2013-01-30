Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3A3Nn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:43:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab3A3NnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:43:24 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Kurachkin Michail <Michail.Kurachkin@promwad.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>
Subject: Re: TDM bus support in Linux Kernel [PATCH]
Date: Wed, 30 Jan 2013 14:43:29 +0100
Message-ID: <2570275.zfck7HrlM6@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <F7F628C32E67B04DAECC5CA53521253E5FAB15CE@sv-exmb01-lo1.promwad.corp>
References: <F7F628C32E67B04DAECC5CA53521253E5FAB15CE@sv-exmb01-lo1.promwad.corp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2013 12:37:25 Kurachkin Michail wrote:
> Hi Greg,
> 
> I followed your recommendations and created a diff using Linux 3.8-rc5 sources. Please review it and give your comments.
> 
Part #5

+/**
+ * Reset SLIC
+ */
+static int slic_reset(struct si3226x_slic *slic)
+{
+	unsigned long timeout;
+
+	gpio_set_value(slic->reset_gpio, 0);
+
+	timeout = jiffies + MSEC(RESET_SLIC_PERIOD);
+
+	while(!(time_after(jiffies, timeout)))
+		schedule();

Ouch. We have a delay primitive.

+
+	gpio_set_value(slic->reset_gpio, 1);
+
+	return 0;
+}

+/**
+ * Receive voice data block from TDM voice channel controller.
+ * @param ch - voice channel attendant to transmit data in TDM frame
+ * @param data - pointer to read data received by DMA.
+                 Length data for read equal to value returned by get_tdm_voice_block_size()
+ *
+ * Context: can sleep
+ * @return 0 on success; negative errno on failure
+ */
+static int kirkwood_recv(struct tdm_voice_channel *ch, u8 *data)
+{
+	struct kirkwood_tdm_voice *onchip_ch = ch->private_data;
+
+	wait_event_interruptible(ch->rx_queue,
+	                         get_rx_latency(onchip_ch) > 1);

If you are waiting interruptably, you need to be able to handle an interruption.

+
+	memcpy(data, onchip_ch->rx_buf[atomic_read(&onchip_ch->read_rx_buf_num)],
+	       ch->buffer_len);
+
+	atomic_set(&onchip_ch->read_rx_buf_num,
+	           inc_next_dma_buf_num(atomic_read(&onchip_ch->read_rx_buf_num)));
+
+	return 0;
+}
