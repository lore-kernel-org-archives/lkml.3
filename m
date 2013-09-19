Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3ISFz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 01:55:59 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:37728 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab3ISFz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 01:55:57 -0400
Date: Thu, 19 Sep 2013 10:55:44 +0500
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
Cc: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        bigeasy@linutronix.de, gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
Message-ID: <20130919055542.GA7939@gmail.com>
References: <1379503383-17086-1-git-send-email-zubair.lutfullah@gmail.com>
 <1379503383-17086-3-git-send-email-zubair.lutfullah@gmail.com>
 <5239B197.2040807@jic23.retrosnub.co.uk>
 <20130919052419.GB4363@gmail.com>
 <085d9527-c80e-4307-b8b9-c008976b4be1@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <085d9527-c80e-4307-b8b9-c008976b4be1@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 06:41:22AM +0100, Jonathan Cameron wrote:
> 
> 
> >...
> >> >
> >> >  struct tiadc_device {
> >> >  	struct ti_tscadc_dev *mfd_tscadc;
> >> >  	int channels;
> >> >  	u8 channel_line[8];
> >> >  	u8 channel_step[8];
> >> >+	int buffer_en_ch_steps;
> >> >+	u32 *data;
> >> u16 *data;
> >> 
> >> Also it might actually save memory to simply have a fixed size array
> >> of the maximum size used here and avoid the extra allocations for
> >> the cost
> >> of 16 bytes in here.
> >> 
> >> Hence,
> >> 
> >> u16 data[8];
> >> >  };
> >
> >Why data[8]? The length is dynamic. 
> >This would be valid for the usual one sample per trigger case.
> >But here its continuous sampling and the hardware pushes samples
> >*quickly*
> >Dynamic allocation is needed.
> 
> As far as I can see you pull one set of channels into data[] then push that out to the kfifo. 
> 
> That is repeated lots of times but only up to 8 entries are ever used in this array. If not what is the maximum scanbytes can be?
> 

You have a good eye :).
I understand and will update.

Thanks
Zubair

> >
> >
> >...
> >
> >> >+static irqreturn_t tiadc_worker_h(int irq, void *private)
> >> >+{
> >> >+	struct iio_dev *indio_dev = private;
> >> >+	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> >> >+	int i, k, fifo1count, read;
> >> >+	u32 *data = adc_dev->data;
> >> 	u16* data = adc_dev->data;
> >> >+
> >> >+	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
> >> >+	for (k = 0; k < fifo1count; k = k + i) {
> >> >+		for (i = 0; i < (indio_dev->scan_bytes)/4; i++) {
> >> >+			read = tiadc_readl(adc_dev, REG_FIFO1);
> >> >+			data[i] = read & FIFOREAD_DATA_MASK;
> 
> i is only ever up to scanbytes / 4.
> Hence max of 8 I think?
> 
> Now there is a good argument for adding some bulk filling code for the buffers but that is not happening here.
> >> //This is a 12 bit number after the mask so will fit just fine into
> >16 bits.
> >
