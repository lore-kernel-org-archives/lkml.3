Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaESUdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:33:32 -0400
Received: from vader.hardeman.nu ([95.142.160.32]:33352 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaESUda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:33:30 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 May 2014 16:33:29 EDT
Date: Mon, 19 May 2014 22:26:16 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Alexander Bersenev <bay@hackerdom.ru>
Cc: linux-sunxi@googlegroups.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, grant.likely@linaro.org,
        ijc+devicetree@hellion.org.uk, james.hogan@imgtec.com,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        m.chehab@samsung.com, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, pawel.moll@arm.com,
        rdunlap@infradead.org, robh+dt@kernel.org, sean@mess.org,
        srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v7 2/3] [media] rc: add sunxi-ir driver
Message-ID: <20140519202616.GA25415@hardeman.nu>
Mail-Followup-To: Alexander Bersenev <bay@hackerdom.ru>,
	linux-sunxi@googlegroups.com, devicetree@vger.kernel.org,
	galak@codeaurora.org, grant.likely@linaro.org,
	ijc+devicetree@hellion.org.uk, james.hogan@imgtec.com,
	linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
	m.chehab@samsung.com, mark.rutland@arm.com,
	maxime.ripard@free-electrons.com, pawel.moll@arm.com,
	rdunlap@infradead.org, robh+dt@kernel.org, sean@mess.org,
	srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
References: <1400104602-16431-1-git-send-email-bay@hackerdom.ru>
 <1400104602-16431-3-git-send-email-bay@hackerdom.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400104602-16431-3-git-send-email-bay@hackerdom.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 03:56:41AM +0600, Alexander Bersenev wrote:
>This patch adds driver for sunxi IR controller.
>It is based on Alexsey Shestacov's work based on the original driver
>supplied by Allwinner.
>

...

>+static irqreturn_t sunxi_ir_irq(int irqno, void *dev_id)
>+{
>+	unsigned long status;
>+	unsigned char dt;
>+	unsigned int cnt, rc;
>+	struct sunxi_ir *ir = dev_id;
>+	DEFINE_IR_RAW_EVENT(rawir);
>+
>+	spin_lock(&ir->ir_lock);
>+
>+	status = readl(ir->base + SUNXI_IR_RXSTA_REG);
>+
>+	/* clean all pending statuses */
>+	writel(status | REG_RXSTA_CLEARALL, ir->base + SUNXI_IR_RXSTA_REG);
>+
>+	if (status & REG_RXINT_RAI_EN) {
>+		/* How many messages in fifo */
>+		rc  = (status >> REG_RXSTA_RAC__SHIFT) & REG_RXSTA_RAC__MASK;
>+		/* Sanity check */
>+		rc = rc > SUNXI_IR_FIFO_SIZE ? SUNXI_IR_FIFO_SIZE : rc;
>+		/* If we have data */
>+		for (cnt = 0; cnt < rc; cnt++) {
>+			/* for each bit in fifo */
>+			dt = readb(ir->base + SUNXI_IR_RXFIFO_REG);
>+			rawir.pulse = (dt & 0x80) != 0;
>+			rawir.duration = (dt & 0x7f) * SUNXI_IR_SAMPLE;

Can the hardware actually return a zero duration or should that be dt &
0x7f + 1?

(Not familiar with this particular hardware but I know I've seen that
behaviour before).

>+			ir_raw_event_store_with_filter(ir->rc, &rawir);
>+		}
>+	}
>+
>+	if (status & REG_RXINT_ROI_EN) {
>+		ir_raw_event_reset(ir->rc);
>+	} else if (status & REG_RXINT_RPEI_EN) {
>+		ir_raw_event_set_idle(ir->rc, true);
>+		ir_raw_event_handle(ir->rc);
>+	}
>+
>+	spin_unlock(&ir->ir_lock);
>+
>+	return IRQ_HANDLED;
>+}
....

