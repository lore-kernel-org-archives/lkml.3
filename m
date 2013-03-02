Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab3CBWvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 17:51:11 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:60099 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3CBWvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 17:51:09 -0500
Message-ID: <51328391.70609@gmail.com>
Date: Sun, 03 Mar 2013 09:56:17 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Michail Kurachkin <michail.kurachkin@promwad.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>,
        Dmitriy Gorokh <dmitriy.gorokh@promwad.com>,
        Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH v2 05/11] staging: refactoring request/free voice channels
References: <cover.1362133319.git.michail.kurachkin@promwad.com> <b8308342cf266b5d8429e5de41f79ebf37b1d396.1362133319.git.michail.kurachkin@promwad.com>
In-Reply-To: <b8308342cf266b5d8429e5de41f79ebf37b1d396.1362133319.git.michail.kurachkin@promwad.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/13 21:57, Michail Kurachkin wrote:

> From: Michail Kurochkin <michail.kurachkin@promwad.com>
> 
> Signed-off-by: Michail Kurochkin <michail.kurachkin@promwad.com>
> ---
>  drivers/staging/tdm/kirkwood_tdm.c |  162 +++++++++++++++++++++++++-----------
>  drivers/staging/tdm/kirkwood_tdm.h |   10 ++-
>  drivers/staging/tdm/tdm.h          |    5 +-
>  drivers/staging/tdm/tdm_core.c     |   65 +++++++--------
>  4 files changed, 154 insertions(+), 88 deletions(-)
> 
> diff --git a/drivers/staging/tdm/kirkwood_tdm.c b/drivers/staging/tdm/kirkwood_tdm.c
> index 4366d38..e4a9106 100644
> --- a/drivers/staging/tdm/kirkwood_tdm.c
> +++ b/drivers/staging/tdm/kirkwood_tdm.c
> @@ -75,7 +75,7 @@ static int kirkwood_tdm_hw_init(struct tdm_controller *tdm)
>  	u32 control_val = 0;
>  	u32 pclk_freq;
>  	unsigned long flags;
> -	spinlock_t lock;
> +	static spinlock_t lock;
>  	spin_lock_init(&lock);


Global spinlocks should be declared outside of functions using the
spinlock initialisers, eg:

	static DEFINE_SPINLOCK(lock_name);

Having a global spinlock just called 'lock' is not very informative.
I also can't see any new uses of this lock in this patch, so why
is it being made global, and what use was it in the first place?

>  
>  
> @@ -192,13 +192,14 @@ static void kirkwood_tdm_hw_deinit(struct tdm_controller *tdm)
>  }
>  
>  /**
> - * Setup hardware voice channel
> + * Initialization hardware voice channel
> + * for specify TDM device
> + * @param tdm_dev - specify TDM device
>   * @param ch - voice hardware channel
>   * @return 0 - OK
>   */
> -int kirkwood_setup_voice_channel(struct tdm_voice_channel* ch)
> +static int kirkwood_init_voice_channel(struct tdm_device *tdm_dev, struct tdm_voice_channel* ch)
>  {
> -	struct tdm_device *tdm_dev = to_tdm_device(ch->dev);
>  	struct tdm_controller *tdm = tdm_dev->controller;
>  	struct tdm_controller_hw_settings *hw = tdm->settings;
>  	struct kirkwood_tdm *onchip_tdm =
> @@ -208,15 +209,15 @@ int kirkwood_setup_voice_channel(struct tdm_voice_channel* ch)
>  	unsigned long timeout;
>  	u32 state;
>  	int i;
> -
> +	int rc = 0;
>  	u8 voice_num = ch->channel_num;
>  
>  	/* calculate buffer size */
>  	ch->buffer_len = tdm_dev->buffer_sample_count * hw->channel_size;
>  
>  	/* Request timeslot for voice channel */
> -	writeb(ch->tdm_channel, (u8*)&regs->chan_time_slot_ctrl + 2 * voice_num);
> -	writeb(ch->tdm_channel, (u8*)&regs->chan_time_slot_ctrl + 1 + 2 * voice_num);
> +	writeb(tdm_dev->tdm_channel_num, (u8*)&regs->chan_time_slot_ctrl + 2 * voice_num);
> +	writeb(tdm_dev->tdm_channel_num, (u8*)&regs->chan_time_slot_ctrl + 1 + 2 * voice_num);
>  
>  	/* FIXME: move coherent_dma_mask to board specific */
>  	tdm_dev->dev.coherent_dma_mask = 0xffffffff;
> @@ -226,11 +227,12 @@ int kirkwood_setup_voice_channel(struct tdm_voice_channel* ch)
>  		/* allocate memory for DMA receiver */
>  		onchip_ch->rx_buf[i] =
>  		        dma_alloc_coherent(&tdm_dev->dev,
> -		        ch->buffer_len, onchip_ch->rx_buff_phy + i, GFP_DMA);
> +		        ch->buffer_len, onchip_ch->rx_buff_phy + i, GFP_KERNEL);


Why are refactors like this happening as a separate patch? Why not
just fold these changes into the first patch so that it is correct
from the beginning (and easier to review)?

>  
>  		if (onchip_ch->rx_buf == NULL) {
>  			dev_err(ch->dev, "Can't allocate memory for TDM receiver DMA buffer\n");
> -			return -ENOMEM;
> +			rc = -ENOMEM;
> +			goto out1;
>  		}
>  		memset(onchip_ch->rx_buf[i], 0, ch->buffer_len);
>  
> @@ -238,20 +240,16 @@ int kirkwood_setup_voice_channel(struct tdm_voice_channel* ch)
>  		/* allocate memory for DMA transmitter */
>  		onchip_ch->tx_buf[i] =
>  		        dma_alloc_coherent(&tdm_dev->dev,
> -		        ch->buffer_len, onchip_ch->tx_buff_phy + i, GFP_DMA);
> +		        ch->buffer_len, onchip_ch->tx_buff_phy + i, GFP_KERNEL);
>  
>  		if (onchip_ch->tx_buf == NULL) {
>  			dev_err(ch->dev, "Can't allocate memory for TDM transmitter DMA buffer\n");
> -			return -ENOMEM;
> +			rc = -ENOMEM;
> +			goto out1;
>  		}
>  		memset(onchip_ch->tx_buf[i], 0, ch->buffer_len);
>  	}
>  
> -	atomic_set(&onchip_ch->write_rx_buf_num, 0);
> -	atomic_set(&onchip_ch->write_tx_buf_num, 0);
> -	atomic_set(&onchip_ch->read_rx_buf_num, 0);
> -	atomic_set(&onchip_ch->read_tx_buf_num, 0);
> -
>  	/* Set length for DMA */
>  	writel(((tdm_dev->buffer_sample_count - 32) << 8) | tdm_dev->buffer_sample_count,
>  	       &regs->chan0_total_sample + voice_num);
> @@ -262,8 +260,10 @@ int kirkwood_setup_voice_channel(struct tdm_voice_channel* ch)
>  		state = readl(&regs->chan0_buff_ownership + 4 * voice_num) & 0x100;
>  		if(time_after(jiffies, timeout)) {
>  			dev_err(ch->dev, "Can`t program DMA tx buffer\n");
> -			return -EBUSY;
> +			rc = -EBUSY;
> +			goto out1;
>  		}
> +		schedule();
>  	} while(state);
>  
>  	/* Set DMA buffers fo transmitter */
> @@ -277,8 +277,10 @@ int kirkwood_setup_voice_channel(struct tdm_voice_channel* ch)
>  		state = readl(&regs->chan0_buff_ownership + 4 * voice_num) & 1;
>  		if(time_after(jiffies, timeout)) {
>  			dev_err(ch->dev, "Can`t program DMA rx buffer\n");
> -			return -EBUSY;
> +			rc = -EBUSY;
> +			goto out1;
>  		}
> +		schedule();
>  	} while(state);


Does the controller have an interrupt for notifying of a state change?
If so, you could turn this into a wait_event_timeout, and have the
interrupt handler issue the wakeup.

>  
>  	/* Set DMA buffers for receiver */
> @@ -286,11 +288,51 @@ int kirkwood_setup_voice_channel(struct tdm_voice_channel* ch)
>  	    &regs->chan0_receive_start_addr + 4 * voice_num);
>  	writeb(0x1, (u8*)(&regs->chan0_buff_ownership + 4 * voice_num) );
>  
> -	return 0;
> +out0:
> +	return rc;
> +
> +out1:
> +	kirkwood_reset_voice_channel(tdm_dev);
> +	return rc;
>  }
>  
>  
>  /**
> + * Release and reset hardware voice channel
> + * free DMA buffers.
> + * @param tdm_dev - TDM device early requested voice channel
> + * @return 0 - OK
> + */
> +int kirkwood_release_voice_channel(struct tdm_device *tdm_dev)
> +{
> +	struct tdm_voice_channel* ch = tdm_dev->ch;
> +	struct kirkwood_tdm_voice *onchip_ch = ch->private_data;
> +	int i;
> +
> +	if (!tdm_dev->ch)
> +		return -ENODEV;
> +
> +	for(i = 0; i < COUNT_DMA_BUFFERS_PER_CHANNEL; i++)
> +	{
> +		if (onchip_ch->rx_buf[i])
> +		{
> +			dma_free_coherent(&ch->dev,
> +			        ch->buffer_len, onchip_ch->rx_buf[i], onchip_ch->rx_buff_phy + i);
> +			onchip_ch->rx_buf[i] = 0;
> +		}
> +
> +		if (onchip_ch->tx_buf[i])
> +		{
> +			dma_free_coherent(&ch->dev,
> +			        ch->buffer_len, onchip_ch->tx_buf[i], onchip_ch->tx_buff_phy + i);
> +			onchip_ch->tx_buf[i] = 0;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
>   * Run tdm transmitter and receiver
>   * @param tdm_dev - tdm device
>   * @return 0 - ok
> @@ -304,8 +346,8 @@ int kirkwood_tdm_run_audio(struct tdm_device *tdm_dev)
>  	struct tdm_voice_channel *ch = tdm_dev->ch;
>  	struct kirkwood_tdm_voice *onchip_ch = ch->private_data;
>  
> -	memset(onchip_ch->tx_buf[0], 0, ch->buffer_len);
> -	memset(onchip_ch->tx_buf[1], 0, ch->buffer_len);
> +	for (i = 0; i < COUNT_DMA_BUFFERS_PER_CHANNEL; i++)
> +		memset(onchip_ch->tx_buf[i], 0, ch->buffer_len);
>  
>  	writeb(0x1, (u8 *)(&regs->chan0_enable_disable + 4 * ch->channel_num) + 1);
>  	writeb(0x1, (u8 *)(&regs->chan0_enable_disable + 4 * ch->channel_num) );
> @@ -364,11 +406,18 @@ int kirkwood_tdm_stop_audio(struct tdm_device *tdm_dev)
>   */
>  int get_tx_latency(struct kirkwood_tdm_voice *onchip_ch)
>  {
> -	if (atomic_read(&onchip_ch->read_tx_buf_num) <= atomic_read(&onchip_ch->write_tx_buf_num))
> -		return atomic_read(&onchip_ch->write_tx_buf_num) - atomic_read(&onchip_ch->read_tx_buf_num);
> +	unsigned long flags;
> +	int latency;
> +
> +	spin_lock_irqsave(&onchip_ch->lock, flags);
> +	if (onchip_ch->read_tx_buf_num <= onchip_ch->write_tx_buf_num)
> +		latency = onchip_ch->write_tx_buf_num - onchip_ch->read_tx_buf_num;
>  	else
> -		return COUNT_DMA_BUFFERS_PER_CHANNEL - atomic_read(&onchip_ch->read_tx_buf_num)
> -		       + atomic_read(&onchip_ch->write_tx_buf_num);
> +		latency = COUNT_DMA_BUFFERS_PER_CHANNEL - onchip_ch->read_tx_buf_num
> +		       + onchip_ch->write_tx_buf_num;
> +	spin_unlock_irqrestore(&onchip_ch->lock, flags);

You may need the caller to hold the lock instead. As soon as you
release the lock here, the values in the above calculation can
change, and so you may return a value which is no longer current.
Is that safe to do?

> +	return latency;
>  }
>  
>  
> @@ -379,11 +428,18 @@ int get_tx_latency(struct kirkwood_tdm_voice *onchip_ch)
>   */
>  int get_rx_latency(struct kirkwood_tdm_voice *onchip_ch)
>  {
> -	if (atomic_read(&onchip_ch->read_rx_buf_num) <= atomic_read(&onchip_ch->write_rx_buf_num))
> -		return atomic_read(&onchip_ch->write_rx_buf_num) - atomic_read(&onchip_ch->read_rx_buf_num);
> +	unsigned long flags;
> +	int latency;
> +
> +	spin_lock_irqsave(&onchip_ch->lock, flags);
> +	if (onchip_ch->read_rx_buf_num <= onchip_ch->write_rx_buf_num)
> +		latency = onchip_ch->write_rx_buf_num - onchip_ch->read_rx_buf_num;
>  	else
> -		return COUNT_DMA_BUFFERS_PER_CHANNEL - atomic_read(&onchip_ch->read_rx_buf_num)
> -		       + atomic_read(&onchip_ch->write_rx_buf_num);
> +		latency = COUNT_DMA_BUFFERS_PER_CHANNEL - onchip_ch->read_rx_buf_num
> +		       + onchip_ch->write_rx_buf_num;
> +	spin_unlock_irqrestore(&onchip_ch->lock, flags);
> +
> +	return latency;
>  }
>  
>  
> @@ -421,7 +477,7 @@ int kirkwood_poll_tx(struct tdm_device *tdm_dev)
>   * @param num - current buffer number
>   * @return next buffer number
>   */
> -static int inc_next_dma_buf_num(int num)
> +static inline int inc_next_dma_buf_num(int num)
>  {
>  	num ++;
>  	if (num >= COUNT_DMA_BUFFERS_PER_CHANNEL)
> @@ -445,6 +501,7 @@ static int kirkwood_send(struct tdm_voice_channel *ch, u8 *data)
>  {
>  	struct kirkwood_tdm_voice *onchip_ch = ch->private_data;
>  	int rc = 0;
> +	unsigned long flags;
>  
>  	rc = wait_event_interruptible(ch->tx_queue,
>  	                         get_tx_latency(onchip_ch) > 1);
> @@ -452,10 +509,12 @@ static int kirkwood_send(struct tdm_voice_channel *ch, u8 *data)
>  	if (rc)
>  		return rc;
>  
> -	memcpy(onchip_ch->tx_buf[atomic_read(&onchip_ch->read_tx_buf_num)], data,
> +	spin_lock_irqsave(&onchip_ch->lock, flags);
> +	memcpy(onchip_ch->tx_buf[onchip_ch->read_tx_buf_num], data,
>  	       ch->buffer_len);
> -	atomic_set(&onchip_ch->read_tx_buf_num,
> -		inc_next_dma_buf_num(atomic_read(&onchip_ch->read_tx_buf_num)));
> +	onchip_ch->read_tx_buf_num =
> +		inc_next_dma_buf_num(onchip_ch->read_tx_buf_num);
> +	spin_unlock_irqrestore(&onchip_ch->lock, flags);
>  	return rc;
>  }
>  
> @@ -473,6 +532,7 @@ static int kirkwood_recv(struct tdm_voice_channel *ch, u8 *data)
>  {
>  	struct kirkwood_tdm_voice *onchip_ch = ch->private_data;
>  	int rc = 0;
> +	unsigned long flags;
>  
>  	rc = wait_event_interruptible(ch->rx_queue,
>  	                         get_rx_latency(onchip_ch) > 1);
> @@ -480,10 +540,12 @@ static int kirkwood_recv(struct tdm_voice_channel *ch, u8 *data)
>  	if (rc)
>  		return rc;
>  
> -	memcpy(data, onchip_ch->rx_buf[atomic_read(&onchip_ch->read_rx_buf_num)],
> +	spin_lock_irqsave(&onchip_ch->lock, flags);
> +	memcpy(data, onchip_ch->rx_buf[onchip_ch->read_rx_buf_num],
>  	       ch->buffer_len);
> -	atomic_set(&onchip_ch->read_rx_buf_num,
> -		   inc_next_dma_buf_num(atomic_read(&onchip_ch->read_rx_buf_num)));
> +	onchip_ch->read_rx_buf_num =
> +		   inc_next_dma_buf_num(onchip_ch->read_rx_buf_num);
> +	spin_unlock_irqrestore(&onchip_ch->lock, flags);
>  	return rc;
>  }
>  
> @@ -595,11 +657,11 @@ static irqreturn_t kirkwood_tdm_irq(s32 irq, void *context_data)
>  		switch(mode) {
>  		case IRQ_RECEIVE: {
>  			/* get next buffer number, and move write/read pointer */
> -			next_buf_num = inc_next_dma_buf_num(atomic_read(&onchip_ch->write_rx_buf_num));
> -			atomic_set(&onchip_ch->write_rx_buf_num, next_buf_num);
> -			if(next_buf_num == atomic_read(&onchip_ch->read_rx_buf_num))
> -				atomic_set(&onchip_ch->read_rx_buf_num,
> -				           inc_next_dma_buf_num(atomic_read(&onchip_ch->read_rx_buf_num)));
> +			next_buf_num = inc_next_dma_buf_num(onchip_ch->write_rx_buf_num);
> +			onchip_ch->write_rx_buf_num = next_buf_num;
> +			if(next_buf_num == onchip_ch->read_rx_buf_num)
> +				onchip_ch->read_rx_buf_num =
> +				           inc_next_dma_buf_num(onchip_ch->read_rx_buf_num);
>  
>  			/* if receive overflow event */
>  			if (overflow) {
> @@ -631,11 +693,11 @@ static irqreturn_t kirkwood_tdm_irq(s32 irq, void *context_data)
>  
>  		case IRQ_TRANSMIT: {
>  			/* get next buffer number, and move write/read pointer */
> -			next_buf_num = inc_next_dma_buf_num(atomic_read(&onchip_ch->write_tx_buf_num));
> -			atomic_set(&onchip_ch->write_tx_buf_num, next_buf_num);
> -			if(next_buf_num == atomic_read(&onchip_ch->read_tx_buf_num))
> -				atomic_set(&onchip_ch->read_tx_buf_num,
> -				           inc_next_dma_buf_num(atomic_read(&onchip_ch->read_tx_buf_num)));
> +			next_buf_num = inc_next_dma_buf_num(onchip_ch->write_tx_buf_num);
> +			onchip_ch->write_tx_buf_num=  next_buf_num;
> +			if(next_buf_num == onchip_ch->read_tx_buf_num)
> +				onchip_ch->read_tx_buf_num =
> +				           inc_next_dma_buf_num(onchip_ch->read_tx_buf_num);
>  
>  			/* if transmit overflow event */
>  			if (overflow) {
> @@ -777,7 +839,8 @@ static int __init kirkwood_tdm_probe(struct platform_device *pdev)
>  	/* Set controller data */
>  	tdm->bus_num = pdev->id;
>  	tdm->settings = hw;
> -	tdm->setup_voice_channel = kirkwood_setup_voice_channel;
> +	tdm->init_voice_channel = kirkwood_init_voice_channel;
> +	tdm->release_voice_channel = kirkwood_release_voice_channel;
>  	tdm->recv = kirkwood_recv;
>  	tdm->send = kirkwood_send;
>  	tdm->run_audio = kirkwood_tdm_run_audio;
> @@ -787,13 +850,16 @@ static int __init kirkwood_tdm_probe(struct platform_device *pdev)
>  
>  	for (i = 0; i < KIRKWOOD_MAX_VOICE_CHANNELS; i++)
>  	{
> +			struct kirkwood_tdm_voice *oncip_ch = onchip_tdm->voice_channels + i;
> +
> +	        spin_lock_init(&oncip_ch->lock);
>  	        ch = tdm_alloc_voice_channel();
>  	        if (ch == NULL) {
>  	                dev_err(&pdev->dev, "Can`t alloc voice channel %d\n", i);
>  	                goto out1;
>  	        }
>  
> -            tdm_register_new_voice_channel(tdm, ch, (void *)(onchip_tdm->voice_channels + i));
> +            tdm_register_new_voice_channel(tdm, ch, (void *)oncip_ch);
>  	}
>  
>  
> diff --git a/drivers/staging/tdm/kirkwood_tdm.h b/drivers/staging/tdm/kirkwood_tdm.h
> index 6c7f34d..fe7aadf 100644
> --- a/drivers/staging/tdm/kirkwood_tdm.h
> +++ b/drivers/staging/tdm/kirkwood_tdm.h
> @@ -58,6 +58,8 @@ struct kirkwood_tdm_regs {
>   * Data specified for kirkwood hardware voice channel
>   */
>  struct kirkwood_tdm_voice {
> +	spinlock_t		lock;
> +
>  	/* Transmitter and receiver buffers split to half.
>  	 * While first half buffer is filling by DMA controller,
>  	 * second half buffer is used by consumer and etc.
> @@ -67,10 +69,10 @@ struct kirkwood_tdm_voice {
>  
>  	dma_addr_t tx_buff_phy[COUNT_DMA_BUFFERS_PER_CHANNEL]; /*  two physical pointers to tx_buf */
>  	dma_addr_t rx_buff_phy[COUNT_DMA_BUFFERS_PER_CHANNEL]; /*  two physical pointers to rx_buf */
> -	atomic_t write_tx_buf_num; /*  current writing transmit buffer number */
> -	atomic_t read_tx_buf_num; /*  current reading transmit buffer number */
> -	atomic_t write_rx_buf_num; /*  current writing receive buffer number */
> -	atomic_t read_rx_buf_num; /*  current reading receive buffer number */
> +	u8 write_tx_buf_num; /*  current writing transmit buffer number */
> +	u8 read_tx_buf_num; /*  current reading transmit buffer number */
> +	u8 write_rx_buf_num; /*  current writing receive buffer number */
> +	u8 read_rx_buf_num; /*  current reading receive buffer number */
>  };
>  
>  
> diff --git a/drivers/staging/tdm/tdm.h b/drivers/staging/tdm/tdm.h
> index ee7b5bf..80c1460 100644
> --- a/drivers/staging/tdm/tdm.h
> +++ b/drivers/staging/tdm/tdm.h
> @@ -53,7 +53,7 @@ struct tdm_voice_channel {
>  	wait_queue_head_t tx_queue;
>  	wait_queue_head_t rx_queue;
>  
> -        struct list_head list; /*  Union all tdm voice channels by one controller */
> +	struct list_head list; /*  Union all tdm voice channels by one controller */


Whitespace fixes like this should definetly be folded into the
first patch.

>  
>  	struct device *dev; /*  device requested voice channel */
>  };
> @@ -106,7 +106,8 @@ struct tdm_controller {
>  	/*  TDM hardware settings */
>  	struct tdm_controller_hw_settings *settings;
>  
> -	int (*setup_voice_channel)(struct tdm_voice_channel *ch);
> +	int (*init_voice_channel)(struct tdm_device *tdm_dev, struct tdm_voice_channel* ch);
> +	int (*release_voice_channel)(struct tdm_device *tdm_dev);
>  	int (*send)(struct tdm_voice_channel *ch, u8 *data);
>  	int (*recv)(struct tdm_voice_channel *ch, u8 *data);
>  	int (*run_audio)(struct tdm_device *tdm_dev);
> diff --git a/drivers/staging/tdm/tdm_core.c b/drivers/staging/tdm/tdm_core.c
> index 0182a4f..f3ac6fc 100644
> --- a/drivers/staging/tdm/tdm_core.c
> +++ b/drivers/staging/tdm/tdm_core.c
> @@ -174,53 +174,64 @@ EXPORT_SYMBOL_GPL(tdm_unregister_driver);
>  
>  
>  /**
> - * Request unused voice channel
> + * Request and init unused voice channel
>   * @param tdm_dev - TDM device requested voice channel
>   * @return pointer to voice channel
>   */
>  struct tdm_voice_channel *request_voice_channel(struct tdm_device *tdm_dev) {
> -        struct tdm_controller *tdm = tdm_dev->controller;
> -        struct tdm_voice_channel *ch;
> -        unsigned long flags;
> +	struct tdm_controller *tdm = tdm_dev->controller;
> +	struct tdm_voice_channel *ch;
> +	unsigned long flags;
> +	int rc;
>  
> -        spin_lock_irqsave(&tdm->lock, flags);
> +	spin_lock_irqsave(&tdm->lock, flags);
>  
>  	list_for_each_entry(ch, &tdm->voice_channels, list)
>                  if (ch->dev == NULL) {
>                          ch->dev = &tdm_dev->dev;
> +                        ch->mode_wideband = tdm_dev->mode_wideband;
> +                        ch->tdm_channel = tdm_dev->tdm_channel_num;
>                          tdm_dev->ch = ch;
>                          spin_unlock_irqrestore(&tdm->lock, flags);
> +                        rc = tdm->init_voice_channel(tdm_dev, ch);
> +                        if (rc)
> +                        {
> +                            dev_err(&tdm_dev->dev, "Can't init TDM voice channel\n");
> +                        	return NULL;
> +                        }
> +
>                          return ch;
>                  }
>  
> -        spin_unlock_irqrestore(&tdm->lock, flags);
> -        return NULL;
> +	spin_unlock_irqrestore(&tdm->lock, flags);
> +	return NULL;
>  }
>  
>  /**
> - * Release requested voice channel
> + * Release requested early voice channel
>   * @param TDM device requested early voice channel
>   * @return 0 - OK
>   */
>  int release_voice_channel(struct tdm_device *tdm_dev)
>  {
> -        struct tdm_controller *tdm = tdm_dev->controller;
> -        struct tdm_voice_channel *ch;
> -        unsigned long flags;
> +	struct tdm_controller *tdm = tdm_dev->controller;
> +	struct tdm_voice_channel *ch;
> +	unsigned long flags;
>  
> -        spin_lock_irqsave(&tdm->lock, flags);
> +	spin_lock_irqsave(&tdm->lock, flags);
>  
> -        tdm_dev->ch = NULL;
> +	tdm_dev->ch = NULL;
>  	list_for_each_entry(ch, &tdm->voice_channels, list)
> -                if (ch->dev == &tdm_dev->dev) {
> -                        ch->dev = NULL;
> -                        spin_unlock_irqrestore(&tdm->lock, flags);
> -                        return 0;
> -                }
> +			if (ch->dev == &tdm_dev->dev) {
> +					tdm->release_voice_channel(tdm_dev);
> +					ch->dev = NULL;
> +					spin_unlock_irqrestore(&tdm->lock, flags);
> +					return 0;
> +			}
>  
> -        spin_unlock_irqrestore(&tdm->lock, flags);
> +	spin_unlock_irqrestore(&tdm->lock, flags);
>  
> -        return -ENODEV;
> +	return -ENODEV;
>  }
>  
>  
> @@ -326,7 +337,6 @@ struct tdm_voice_channel *tdm_alloc_voice_channel(void)
>          if (!ch)
>                  return NULL;
>  
> -        memset(ch, 0, sizeof *ch);
>          init_waitqueue_head(&ch->tx_queue);
>          init_waitqueue_head(&ch->rx_queue);
>  
> @@ -614,19 +624,6 @@ int tdm_add_device(struct tdm_device *tdm_dev)
>                  goto done;
>          }
>  
> -        printk("ch = %s\n", dev_name(ch->dev));
> -
> -        /* Configuring voice channel */
> -        ch->mode_wideband = tdm_dev->mode_wideband;
> -        ch->tdm_channel = tdm_dev->tdm_channel_num;
> -
> -        /* Run setup voice channel */
> -        status = tdm_dev->controller->setup_voice_channel(ch);
> -        if (status < 0) {
> -                dev_err(dev, "can't setup voice channel, status %d\n", status);
> -                goto done;
> -        }
> -
>          /* Device may be bound to an active driver when this returns */
>          status = device_add(&tdm_dev->dev);
>          if (status < 0)


