Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab3FRNkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:40:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58927 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3FRNks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:40:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Akhil Goyal <akhil.goyal@freescale.com>
Subject: Re: [PATCH 1/5] drivers/misc: Support for RF interface device framework
Date: Tue, 18 Jun 2013 15:40:45 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        pankaj.chauhan@freescale.com
References: <1371456566-4934-1-git-send-email-akhil.goyal@freescale.com> <201306172328.26430.arnd@arndb.de> <51C00FC0.90105@freescale.com>
In-Reply-To: <51C00FC0.90105@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306181540.45454.arnd@arndb.de>
X-Provags-ID: V02:K0:xpvToKhMgxZFGFmBVuxVO7ysx0QrNoJMupbHJJqBxyu
 ZBz4YiUNUULPuFD9zzmDfL2CCUBAuQGx1UTrf1d4AeIayFjLXx
 mFaiLNiG8KsLIrNruXiNnuXKO7ZUdTbr7LsQwQO7vsBOuRpH1E
 ATHQZQqfBElWqdVkOgIWukZt8dfXUSrNuekGHMqbh3Y5N34i0D
 ObuXsgMsT+oOamF87FJ+HlrTvXlckOew0N9CIIl/VldaRCjXKo
 I0DgEdLpflE+TNl3cWkt/NSNyam5Z6Zl8hsnQwJKl7EhNAQpYi
 VCMoCfxVUYwhi/ZCXchsSR79gEgP2dHFgTTESWXlUkoO/wqBED
 ZsdrpxRKV6vo4NqCbodw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 June 2013, Akhil Goyal wrote:
> On 6/18/2013 2:58 AM, Arnd Bergmann wrote:
> >> +	/*
> >> +	 * Spin_locks are changed to mutexes if PREEMPT_RT is enabled,
> >> +	 * i.e they can sleep. This fact is problem for us because
> >> +	 * add_wait_queue()/wake_up_all() takes wait queue spin lock.
> >> +	 * Since spin lock can sleep with PREEMPT_RT, wake_up_all() can not be
> >> +	 * called from rf_notify_dl_tti (which is called in interrupt context).
> >> +	 * As a workaround, wait_q_lock is used for protecting the wait_q and
> >> +	 * add_wait_queue_locked()/ wake_up_locked() functions of wait queues
> >> +	 * are used.
> >> +	 */
> >> +	raw_spin_lock_irqsave(&rf_dev->wait_q_lock, flags);
> >> +	__add_wait_queue_tail_exclusive(&rf_dev->wait_q,&wait);
> >> +	raw_spin_unlock_irqrestore(&rf_dev->wait_q_lock, flags);
> >> +	set_current_state(TASK_INTERRUPTIBLE);
> >> +	/*Now wait here, tti notificaion will wake us up*/
> >> +	schedule();
> >> +	set_current_state(TASK_RUNNING);
> >> +	raw_spin_lock_irqsave(&rf_dev->wait_q_lock, flags);
> >> +	__remove_wait_queue(&rf_dev->wait_q,&wait);
> >> +	raw_spin_unlock_irqrestore(&rf_dev->wait_q_lock, flags);
> >
> > This is not a proper method of waiting for an event. Why can't you
> > use wait_event() here?
> wait_event() is internally calling spin_lock_irqsave() and this function 
> will be called in hard IRQ context with PREEMPT_RT enabled(IRQF_NODELAY 
> set). So wait_event cannot be used.
> This problem can be solved if we can get the following patch applied on 
> the tree.
> https://patchwork.kernel.org/patch/2161261/

I see. How about using wait_event here then and adding a comment about
the RT kernel?

> > The explanation about the interrupt handler seems incorrect, since PREEMPT_RT
> > also turns interrupt handlers into threads.
> The interrupt handler has real time requirement and thus running in 
> HARDIRQ context with flag IRQF_NODELAY. We get this interrupt in every 
> millisecond.

Ok. So there would be no problem without the RT patch set.

IRQF_NODELAY is specific to the RT kernel, so you can change the wait_event
function to something else in the same patch that adds this flag.
> >> +#define RF_MAGIC 0xEE
> >> +#define RIF_DEV_INIT		_IOWR(RF_MAGIC, 1, struct rf_init_params)
> >> +#define RIF_SET_TIMER_SOURCE	_IOW(RF_MAGIC, 2, unsigned int)
> >> +#define RIF_GET_STATE		_IOR(RF_MAGIC, 3, unsigned int)
> >> +#define RIF_SET_TIMER_CORRECTION _IOW(RF_MAGIC, 4, struct rif_dac_params)
> >> +#define	RIF_RUN_PHY_CMDS	_IOW(RF_MAGIC, 5, struct rif_phy_cmd_set)
> >> +#define RIF_READ_RSSI		_IOWR(RF_MAGIC, 6, struct rf_rssi)
> >> +#define RIF_READ_PHY_REGS	_IOR(RF_MAGIC, 7, struct rif_reg_buf)
> >> +#define RIF_READ_CTRL_REGS	_IOR(RF_MAGIC, 8, struct rif_reg_buf)
> >> +#define RIF_START		_IO(RF_MAGIC, 9)
> >> +#define RIF_STOP		_IO(RF_MAGIC, 10)
> >> +#define RIF_GET_DEV_INFO	_IOWR(RF_MAGIC, 11, struct rf_dev_info)
> >> +#define RIF_WRITE_PHY_REGS _IOR(RF_MAGIC, 12, struct rif_write_reg_buf)
> >> +#define RIF_GET_DAC_VALUE	_IOR(RF_MAGIC, 13, struct rif_dac_buf)
> >> +#define RIF_SET_TX_ATTEN	_IOW(RF_MAGIC, 14, struct rf_tx_buf)
> >> +#define RIF_EN_DIS_TX		_IOW(RF_MAGIC, 15, struct rf_tx_en_dis)
> >> +#define RIF_WRITE_CTRL_REGS 	_IOW(RF_MAGIC, 16, struct rif_write_reg_buf)
> >> +#define RIF_READ_RX_GAIN 	_IOWR(RF_MAGIC, 17, struct rf_rx_gain)
> >> +#define RIF_CONFIG_SNIFF 	_IOWR(RF_MAGIC, 18, struct rf_sniff_params)
> >> +#define RIF_WRITE_RX_GAIN 	_IOW(RF_MAGIC, 19, struct rf_rx_gain)
> >> +#define RIF_SET_GAIN_CTRL_MODE 	_IOW(RF_MAGIC, 20, struct rf_gain_ctrl)
> >> +#define RIF_INIT_SYNTH_TABLE	_IOW(RF_MAGIC, 21, struct rf_synth_table)
> >> +#define RIF_CHANNEL_OPEN	_IOW(RF_MAGIC, 22, struct rf_channel_params)
> >> +#define RIF_CHANNEL_CLOSE	_IOW(RF_MAGIC, 23, unsigned int)
> >> +#define RIF_REGISTER_EVENT	_IOW(RF_MAGIC, 24, struct rf_event_listener)
> >> +#define RIF_UNREGISTER_EVENT	_IO(RF_MAGIC, 25)
> >
> > On the whole, the ioctl API looks very complex to me. It may well be that
> > the complexity is necessary, but I cannot tell because I don't understand
> > the subsystem. Can you find someone from another company that has hardware
> > which would use the same subsystem, and have them do a review of the API
> > to ensure it works for them as well?
> >
> Antenna controller is a Freescale designed hardware block in the BSC9131 
> SOC. I am not aware of any other company which has similar kind of 
> controller. I could not find any existing Antenna Controller Driver in 
> kernel.
> 
> AD9361 RF PHY is being used by other companies also but again there is 
> no open source driver for that.
> 
> This framework binds the Radio PHY and the Antenna Controller and expose 
> the complete rf device(phy + controller) to the user space. Since I am 
> not aware of other companies using similar hardware, I was hoping to get 
> feedback about framework and APIs on the list itself.

Ok. I hope you can find someone else to provide a review of the API.

> Also I will try to explain more on the IOCTL APIs in the Documentation 
> file that I have added in this patch.

Yes, that would be good.

	Arnd
