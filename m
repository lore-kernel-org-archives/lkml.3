Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab3FRHoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 03:44:21 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:51886 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186Ab3FRHoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 03:44:20 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Message-ID: <51C00FC0.90105@freescale.com>
Date: Tue, 18 Jun 2013 13:14:00 +0530
From: Akhil Goyal <akhil.goyal@freescale.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <pankaj.chauhan@freescale.com>
Subject: Re: [PATCH 1/5] drivers/misc: Support for RF interface device framework
References: <1371456566-4934-1-git-send-email-akhil.goyal@freescale.com> <1371456566-4934-2-git-send-email-akhil.goyal@freescale.com> <201306172328.26430.arnd@arndb.de>
In-Reply-To: <201306172328.26430.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/2013 2:58 AM, Arnd Bergmann wrote:
> On Monday 17 June 2013, akhil.goyal@freescale.com wrote:
>> +
>> +menuconfig RFDEVICES
>> +	default n
>> +	bool "RF interface device support"
>> +	---help---
>> +	Support for RF interface devices.
>> +	In a baseband system, different radios (RF PHYs) are
>> +	connected depending on required radio technology. Higher layer
>> +	stacks need to configure the radio according to required network mode.
>> +	Adding this support will export different radios connected in system
>> +	(in case of multi mode system)as RF interface deivces 'rf0', 'rf1' etc.
>> +	Higher layer stacks (running in user space)can use rfX device to
>> +	talk to a specific radio.
>> +
>> +	radio interface controller driver (Antenna controller) and RF PHY driver
>> +	connected to system must also be chosen.
>
> You should spell out "RF" at least once here, not everybody is familiar
> with the term.
Ok I will do that
>
>> +if RFDEVICES
>> +
>> +config FSL_AIC
>> +	default y
>> +	bool "Freescale Antenna Interface Controller (AIC)"
>> +	---help---
>> +	Freescale AIC controller (Antenna Interface Controller) is found
>> +	in bsc913x family of SOCs. AIC has six RF lanes and maximum four
>> +	RF PHYs can be connected and operated simultaneously.
>> +
>> +config ADI9361
>> +	default y
>> +	bool "ADI 9361 RF PHY"
>> +	---help---
>> +	ADI9361 RF phy driver.
>> +
>> +endif
>
> This should probably be part of a later patch.
Ok I will do that
>> +
>> +static struct rf_priv *rf_priv;
>> +static int rf_change_state(struct rf_ctrl_dev *rf_dev, unsigned int state);
>> +static int rf_attach_phy(struct rf_ctrl_dev *rf_dev, struct rf_phy_dev *phy);
>> +static int rf_open(struct inode *inode, struct file *filep);
>> +static int rf_release(struct inode *inode, struct file *filep);
>> +static ssize_t rf_read(struct file *, char __user *, size_t, loff_t *);
>> +static long rf_ioctl(struct file *, unsigned int, unsigned long);
>
> Please reorganize the file so that you don't need forward declarations for
> functions.
>
ok I will do that.
>> +struct rf_ctrl_dev *allocate_rf_ctrl_dev(size_t priv_size,
>> +		unsigned long flags)
>> +{
>> +	struct rf_ctrl_dev *rf_dev;
>> +	size_t size;
>> +
>> +	size = sizeof(struct rf_ctrl_dev) + priv_size;
>> +	rf_dev = kzalloc(size, flags);
>> +
>> +	if (!rf_dev)
>> +		return rf_dev;
>> +
>> +	atomic_set(&rf_dev->ref, 1);
>> +	mutex_init(&rf_dev->lock);
>> +	init_waitqueue_head(&rf_dev->wait_q);
>> +	INIT_LIST_HEAD(&rf_dev->event_handler_list);
>> +	spin_lock_init(&rf_dev->event_handler_lock);
>> +	raw_spin_lock_init(&rf_dev->wait_q_lock);
>> +	rf_dev->priv = (unsigned char *) rf_dev + sizeof(struct rf_ctrl_dev);
>> +	rf_dev->dev_idx = INVAL_DEV_IDX;
>> +
>> +	return rf_dev;
>> +}
>> +EXPORT_SYMBOL(allocate_rf_ctrl_dev);
>
> Normally I would expect to see EXPORT_SYMBOL_GPL.
ok i will correct this
>
>
>> +	/*
>> +	 * Spin_locks are changed to mutexes if PREEMPT_RT is enabled,
>> +	 * i.e they can sleep. This fact is problem for us because
>> +	 * add_wait_queue()/wake_up_all() takes wait queue spin lock.
>> +	 * Since spin lock can sleep with PREEMPT_RT, wake_up_all() can not be
>> +	 * called from rf_notify_dl_tti (which is called in interrupt context).
>> +	 * As a workaround, wait_q_lock is used for protecting the wait_q and
>> +	 * add_wait_queue_locked()/ wake_up_locked() functions of wait queues
>> +	 * are used.
>> +	 */
>> +	raw_spin_lock_irqsave(&rf_dev->wait_q_lock, flags);
>> +	__add_wait_queue_tail_exclusive(&rf_dev->wait_q,&wait);
>> +	raw_spin_unlock_irqrestore(&rf_dev->wait_q_lock, flags);
>> +	set_current_state(TASK_INTERRUPTIBLE);
>> +	/*Now wait here, tti notificaion will wake us up*/
>> +	schedule();
>> +	set_current_state(TASK_RUNNING);
>> +	raw_spin_lock_irqsave(&rf_dev->wait_q_lock, flags);
>> +	__remove_wait_queue(&rf_dev->wait_q,&wait);
>> +	raw_spin_unlock_irqrestore(&rf_dev->wait_q_lock, flags);
>
> This is not a proper method of waiting for an event. Why can't you
> use wait_event() here?
wait_event() is internally calling spin_lock_irqsave() and this function 
will be called in hard IRQ context with PREEMPT_RT enabled(IRQF_NODELAY 
set). So wait_event cannot be used.
This problem can be solved if we can get the following patch applied on 
the tree.
https://patchwork.kernel.org/patch/2161261/

>
> The explanation about the interrupt handler seems incorrect, since PREEMPT_RT
> also turns interrupt handlers into threads.
The interrupt handler has real time requirement and thus running in 
HARDIRQ context with flag IRQF_NODELAY. We get this interrupt in every 
millisecond.
>
>> +static long rf_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>> +{
>> +	struct rf_ctrl_dev *rf_dev;
>> +	struct rf_phy_dev *phy;
>> +	struct rf_init_params init_params;
>> +	struct rif_phy_cmd_set cmd_set;
>> +	struct rif_reg_buf reg_buf;
>> +	struct rif_write_reg_buf write_reg_buf;
>> +	struct rif_dac_params dac_params;
>> +	struct rif_dac_buf dac_buff;
>> +	struct rf_dev_info dev_info;
>> +	struct rf_tx_buf tx_buf;
>> +	struct rf_tx_en_dis tx_en_dis;
>> +	struct rf_rssi rssi;
>> +	struct rf_rx_gain rx_gain;
>> +	struct rf_gain_ctrl gain_ctrl;
>> +	struct rf_sniff_params sniff_params;
>> +	struct rf_synth_table synth_table;
>> +	struct rf_channel_params chan_params;
>> +	struct rf_event_listener listener;
>> +	unsigned long long (*params_buf)[NUM_SYNTH_PARAMS];
>> +	u8 (*reg_vals_buf)[NUM_SYNTH_REGS];
>
> Are you sure you don't run out of stack space here?
> It may also be beter for style reasons to split this function into a set
> of functions, one for each case.
ok I will split this function.
>
>> +	u32	*buf;
>> +	u32 u32arg;
>> +	int rc = -ENOSYS, size;
>> +
>> +	rf_dev = filep->private_data;
>> +	phy = rf_dev->phy;
>> +
>> +	rc = mutex_lock_interruptible(&rf_dev->lock);
>> +	switch (cmd) {
>
> If mutex_lock_interruptible() fails, you should not enter the
> function because you don't actually hold the mutex.
ok I will do that
>
>> +struct rif_phy_cmd {
>> +	__u32	param1;
>> +	__u32	param2;
>> +	__u32	param3;
>> +	__u8	cmd;
>> +};
>> +
>> +struct rif_phy_cmd_set {
>> +	struct rif_phy_cmd *cmds;
>> +	__u32 count;
>> +};
>
> Please try to avoid ioctl structures with pointers in them, they are harder
> to parse from anything that needs to intercept the ioctl in user space, and
> they break 64 bit compatibility mode.
ok I will do that
>
> You should also add padding in the first structure to ensure that the size
> is a multiple of the largest member. Otherwise you break e.g. ARM OABI
> support or anything else that has unconventional rules on the ABI.
ok i will do that
>
>> +struct time_sync_1588_cnt {
>> +	__u32 high;
>> +	__u32 low;
>> +};
>> +
>> +struct time_info {
>> +	struct time_sync_1588_cnt time_cnt;
>> +	__u8 event;
>> +};
>
> Here too.
>
>> +struct time_sync_data {
>> +	struct time_info time_info;
>> +	__u32 lte_delay;
>> +	__u32 ioctl_cmd;
>> +	__u32 black_out_duration;
>> +	__u8 correction_mode;
>> +	__u8 sync_source;
>> +};
>
> It definitely sounds like a bug to have a member named "ioctl_cmd" in
> a structure that is passed in an ioctl command.
Ok I will correct it.
>
>> +struct rif_dac_buf {
>> +	__u32 correction_type;
>> +	__u32 *buf;
>> +};
>
> A pointer again.
ok i will correct it.
>
>> +#define RF_MAGIC 0xEE
>> +#define RIF_DEV_INIT		_IOWR(RF_MAGIC, 1, struct rf_init_params)
>> +#define RIF_SET_TIMER_SOURCE	_IOW(RF_MAGIC, 2, unsigned int)
>> +#define RIF_GET_STATE		_IOR(RF_MAGIC, 3, unsigned int)
>> +#define RIF_SET_TIMER_CORRECTION _IOW(RF_MAGIC, 4, struct rif_dac_params)
>> +#define	RIF_RUN_PHY_CMDS	_IOW(RF_MAGIC, 5, struct rif_phy_cmd_set)
>> +#define RIF_READ_RSSI		_IOWR(RF_MAGIC, 6, struct rf_rssi)
>> +#define RIF_READ_PHY_REGS	_IOR(RF_MAGIC, 7, struct rif_reg_buf)
>> +#define RIF_READ_CTRL_REGS	_IOR(RF_MAGIC, 8, struct rif_reg_buf)
>> +#define RIF_START		_IO(RF_MAGIC, 9)
>> +#define RIF_STOP		_IO(RF_MAGIC, 10)
>> +#define RIF_GET_DEV_INFO	_IOWR(RF_MAGIC, 11, struct rf_dev_info)
>> +#define RIF_WRITE_PHY_REGS _IOR(RF_MAGIC, 12, struct rif_write_reg_buf)
>> +#define RIF_GET_DAC_VALUE	_IOR(RF_MAGIC, 13, struct rif_dac_buf)
>> +#define RIF_SET_TX_ATTEN	_IOW(RF_MAGIC, 14, struct rf_tx_buf)
>> +#define RIF_EN_DIS_TX		_IOW(RF_MAGIC, 15, struct rf_tx_en_dis)
>> +#define RIF_WRITE_CTRL_REGS 	_IOW(RF_MAGIC, 16, struct rif_write_reg_buf)
>> +#define RIF_READ_RX_GAIN 	_IOWR(RF_MAGIC, 17, struct rf_rx_gain)
>> +#define RIF_CONFIG_SNIFF 	_IOWR(RF_MAGIC, 18, struct rf_sniff_params)
>> +#define RIF_WRITE_RX_GAIN 	_IOW(RF_MAGIC, 19, struct rf_rx_gain)
>> +#define RIF_SET_GAIN_CTRL_MODE 	_IOW(RF_MAGIC, 20, struct rf_gain_ctrl)
>> +#define RIF_INIT_SYNTH_TABLE	_IOW(RF_MAGIC, 21, struct rf_synth_table)
>> +#define RIF_CHANNEL_OPEN	_IOW(RF_MAGIC, 22, struct rf_channel_params)
>> +#define RIF_CHANNEL_CLOSE	_IOW(RF_MAGIC, 23, unsigned int)
>> +#define RIF_REGISTER_EVENT	_IOW(RF_MAGIC, 24, struct rf_event_listener)
>> +#define RIF_UNREGISTER_EVENT	_IO(RF_MAGIC, 25)
>
> On the whole, the ioctl API looks very complex to me. It may well be that
> the complexity is necessary, but I cannot tell because I don't understand
> the subsystem. Can you find someone from another company that has hardware
> which would use the same subsystem, and have them do a review of the API
> to ensure it works for them as well?
>
Antenna controller is a Freescale designed hardware block in the BSC9131 
SOC. I am not aware of any other company which has similar kind of 
controller. I could not find any existing Antenna Controller Driver in 
kernel.

AD9361 RF PHY is being used by other companies also but again there is 
no open source driver for that.

This framework binds the Radio PHY and the Antenna Controller and expose 
the complete rf device(phy + controller) to the user space. Since I am 
not aware of other companies using similar hardware, I was hoping to get 
feedback about framework and APIs on the list itself.

Also I will try to explain more on the IOCTL APIs in the Documentation 
file that I have added in this patch.

-Akhil


