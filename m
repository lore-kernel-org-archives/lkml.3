Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab3ISFl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 01:41:29 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:51624 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab3ISFl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 01:41:27 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130919052419.GB4363@gmail.com>
References: <1379503383-17086-1-git-send-email-zubair.lutfullah@gmail.com> <1379503383-17086-3-git-send-email-zubair.lutfullah@gmail.com> <5239B197.2040807@jic23.retrosnub.co.uk> <20130919052419.GB4363@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
From: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
Date: Thu, 19 Sep 2013 06:41:22 +0100
To: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
CC: jic23@cam.ac.uk, dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        bigeasy@linutronix.de, gregkh@linuxfoundation.org
Message-ID: <085d9527-c80e-4307-b8b9-c008976b4be1@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



"Zubair Lutfullah :" <zubair.lutfullah@gmail.com> wrote:
>On Wed, Sep 18, 2013 at 02:58:47PM +0100, Jonathan Cameron wrote:
>> On 18/09/13 12:23, Zubair Lutfullah wrote:
>> >Previously the driver had only one-shot reading functionality.
>> >This patch adds continuous sampling support to the driver.
>> >
>...
>> 
>> Very very nearly there. Couple of suggestions in-line.
>> (about 30 seconds work + testing ;)
>
>Thank-you so much. Makes me want to put in more work and finish it :)
>
>> 
>> I'm still unsure of why we need 32bit storage in the fifo
>> for the data.  I've proposed the changes I'd make to put it in 16 bit
>> storage inline.  The fact that the device is working in 32bits
>> is irrelevant given we only have a 12 bit number coming out and
>> it is in 12 least significant bits.  I guess there might be a tiny
>> cost in doing the conversion, but you kfifo will be half the size
>> as a result and that seems more likely to a worthwhile gain!
>> 
>
>I understand and will make the changes.
>
>> Out of interest, are you testing this with generic_buffer.c?
>> If so, what changes were necessary?  Given this driver will not
>> have a trigger it would be nice to update that example code to handle
>> that case if it doesn't already.
>
>I simply remove the lines like goto err_trigger etc. :p
>Sneaky but works. I wasn't sure how to make the code understand its a 
>INDIO_BUFFER_HARDWARE..
>But this is a separate discussion..
>
>> 
>> 
>> >---
>> >  drivers/iio/adc/ti_am335x_adc.c      |  216
>+++++++++++++++++++++++++++++++++-
>> >  include/linux/mfd/ti_am335x_tscadc.h |    9 ++
>> >  2 files changed, 220 insertions(+), 5 deletions(-)
>> >
>> >diff --git a/drivers/iio/adc/ti_am335x_adc.c
>b/drivers/iio/adc/ti_am335x_adc.c
>...
>> >
>> >  struct tiadc_device {
>> >  	struct ti_tscadc_dev *mfd_tscadc;
>> >  	int channels;
>> >  	u8 channel_line[8];
>> >  	u8 channel_step[8];
>> >+	int buffer_en_ch_steps;
>> >+	u32 *data;
>> u16 *data;
>> 
>> Also it might actually save memory to simply have a fixed size array
>> of the maximum size used here and avoid the extra allocations for
>> the cost
>> of 16 bytes in here.
>> 
>> Hence,
>> 
>> u16 data[8];
>> >  };
>
>Why data[8]? The length is dynamic. 
>This would be valid for the usual one sample per trigger case.
>But here its continuous sampling and the hardware pushes samples
>*quickly*
>Dynamic allocation is needed.

As far as I can see you pull one set of channels into data[] then push that out to the kfifo. 

That is repeated lots of times but only up to 8 entries are ever used in this array. If not what is the maximum scanbytes can be?

>
>
>...
>
>> >+static irqreturn_t tiadc_worker_h(int irq, void *private)
>> >+{
>> >+	struct iio_dev *indio_dev = private;
>> >+	struct tiadc_device *adc_dev = iio_priv(indio_dev);
>> >+	int i, k, fifo1count, read;
>> >+	u32 *data = adc_dev->data;
>> 	u16* data = adc_dev->data;
>> >+
>> >+	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
>> >+	for (k = 0; k < fifo1count; k = k + i) {
>> >+		for (i = 0; i < (indio_dev->scan_bytes)/4; i++) {
>> >+			read = tiadc_readl(adc_dev, REG_FIFO1);
>> >+			data[i] = read & FIFOREAD_DATA_MASK;

i is only ever up to scanbytes / 4.
Hence max of 8 I think?

Now there is a good argument for adding some bulk filling code for the buffers but that is not happening here.
>> //This is a 12 bit number after the mask so will fit just fine into
>16 bits.
>
>Indeed
>...
>> >+
>> >+static int tiadc_buffer_postenable(struct iio_dev *indio_dev)
>> >+{
>> >+	struct tiadc_device *adc_dev = iio_priv(indio_dev);
>> >+	struct iio_buffer *buffer = indio_dev->buffer;
>> >+	unsigned int enb = 0;
>> >+	u8 bit;
>> >+
>> (can drop this if doing the array with adc_dev as suggested above)
>> >+	adc_dev->data = kmalloc(indio_dev->scan_bytes, GFP_KERNEL);
>> >+	if (adc_dev->data == NULL)
>> >+		return -ENOMEM;
>
>As explained previously. Large array.. This is needed..
>
>...
>> >+{
>> >+	struct tiadc_device *adc_dev = iio_priv(indio_dev);
>> >+
>> >+	tiadc_step_config(indio_dev);
>> (can drop this if doing the array withing adc_dev as suggested above)
>> >+	kfree(adc_dev->data);
>> This is also missbalanced with the preenable (which is true of quite
>> a few drivers - one day I'll clean those up!)
>
>Misbalanced? :s
>
>> >+
>> >+	return 0;
>> >+}
>> 
>
>Thanks for the review and feedback.
>I'll resend the patches with 16 bit everything and dynamic allocation.
>
>Zubair
>> 

