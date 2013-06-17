Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332Ab3FQV2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:28:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59196 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3FQV2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:28:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: akhil.goyal@freescale.com
Subject: Re: [PATCH 1/5] drivers/misc: Support for RF interface device framework
Date: Mon, 17 Jun 2013 23:28:26 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        pankaj.chauhan@freescale.com
References: <1371456566-4934-1-git-send-email-akhil.goyal@freescale.com> <1371456566-4934-2-git-send-email-akhil.goyal@freescale.com>
In-Reply-To: <1371456566-4934-2-git-send-email-akhil.goyal@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306172328.26430.arnd@arndb.de>
X-Provags-ID: V02:K0:KLFn0YMkcg8mIjiw0JSZzMtIyHPOC1SsJET6KmDkzdn
 UNn4NSImK/89RK5ygKHwrJMw7CEAwtpbUNFd4RH5EuTBADh515
 ymIW1vV4ZdG9D1DpnbLSBPPcJ9LfDmJpl/NELMT1vYYg3kWj3C
 JtsKBgWhqe7YnJvslREzYdrPPBiIPlV3Ypqe6Nq850ycKj+ybb
 O68yD/o5xOpvnq3vlYEOTOzM0FwE5LkRZqabhchnCkLekGwUfg
 cANQVa6aemyAc6yoBgO+rlDuQrSr26OndDNAKasXdCDVre7la2
 RYP904hOK+WMo3UTl4bWgAaOXRabwgg2s5gV318PenqobXVtoy
 0/k6+TlF4SUB0nvzOFH4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 June 2013, akhil.goyal@freescale.com wrote:
> +
> +menuconfig RFDEVICES
> +	default n
> +	bool "RF interface device support"
> +	---help---
> +	Support for RF interface devices.
> +	In a baseband system, different radios (RF PHYs) are
> +	connected depending on required radio technology. Higher layer
> +	stacks need to configure the radio according to required network mode.
> +	Adding this support will export different radios connected in system
> +	(in case of multi mode system)as RF interface deivces 'rf0', 'rf1' etc.
> +	Higher layer stacks (running in user space)can use rfX device to
> +	talk to a specific radio.
> +
> +	radio interface controller driver (Antenna controller) and RF PHY driver
> +	connected to system must also be chosen.

You should spell out "RF" at least once here, not everybody is familiar
with the term.

> +if RFDEVICES
> +
> +config FSL_AIC
> +	default y
> +	bool "Freescale Antenna Interface Controller (AIC)"
> +	---help---
> +	Freescale AIC controller (Antenna Interface Controller) is found
> +	in bsc913x family of SOCs. AIC has six RF lanes and maximum four
> +	RF PHYs can be connected and operated simultaneously.
> +
> +config ADI9361
> +	default y
> +	bool "ADI 9361 RF PHY"
> +	---help---
> +	ADI9361 RF phy driver.
> +
> +endif

This should probably be part of a later patch.
> +
> +static struct rf_priv *rf_priv;
> +static int rf_change_state(struct rf_ctrl_dev *rf_dev, unsigned int state);
> +static int rf_attach_phy(struct rf_ctrl_dev *rf_dev, struct rf_phy_dev *phy);
> +static int rf_open(struct inode *inode, struct file *filep);
> +static int rf_release(struct inode *inode, struct file *filep);
> +static ssize_t rf_read(struct file *, char __user *, size_t, loff_t *);
> +static long rf_ioctl(struct file *, unsigned int, unsigned long);

Please reorganize the file so that you don't need forward declarations for
functions.

> +struct rf_ctrl_dev *allocate_rf_ctrl_dev(size_t priv_size,
> +		unsigned long flags)
> +{
> +	struct rf_ctrl_dev *rf_dev;
> +	size_t size;
> +
> +	size = sizeof(struct rf_ctrl_dev) + priv_size;
> +	rf_dev = kzalloc(size, flags);
> +
> +	if (!rf_dev)
> +		return rf_dev;
> +
> +	atomic_set(&rf_dev->ref, 1);
> +	mutex_init(&rf_dev->lock);
> +	init_waitqueue_head(&rf_dev->wait_q);
> +	INIT_LIST_HEAD(&rf_dev->event_handler_list);
> +	spin_lock_init(&rf_dev->event_handler_lock);
> +	raw_spin_lock_init(&rf_dev->wait_q_lock);
> +	rf_dev->priv = (unsigned char *) rf_dev + sizeof(struct rf_ctrl_dev);
> +	rf_dev->dev_idx = INVAL_DEV_IDX;
> +
> +	return rf_dev;
> +}
> +EXPORT_SYMBOL(allocate_rf_ctrl_dev);

Normally I would expect to see EXPORT_SYMBOL_GPL.


> +	/*
> +	 * Spin_locks are changed to mutexes if PREEMPT_RT is enabled,
> +	 * i.e they can sleep. This fact is problem for us because
> +	 * add_wait_queue()/wake_up_all() takes wait queue spin lock.
> +	 * Since spin lock can sleep with PREEMPT_RT, wake_up_all() can not be
> +	 * called from rf_notify_dl_tti (which is called in interrupt context).
> +	 * As a workaround, wait_q_lock is used for protecting the wait_q and
> +	 * add_wait_queue_locked()/ wake_up_locked() functions of wait queues
> +	 * are used.
> +	 */
> +	raw_spin_lock_irqsave(&rf_dev->wait_q_lock, flags);
> +	__add_wait_queue_tail_exclusive(&rf_dev->wait_q, &wait);
> +	raw_spin_unlock_irqrestore(&rf_dev->wait_q_lock, flags);
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	/*Now wait here, tti notificaion will wake us up*/
> +	schedule();
> +	set_current_state(TASK_RUNNING);
> +	raw_spin_lock_irqsave(&rf_dev->wait_q_lock, flags);
> +	__remove_wait_queue(&rf_dev->wait_q, &wait);
> +	raw_spin_unlock_irqrestore(&rf_dev->wait_q_lock, flags);

This is not a proper method of waiting for an event. Why can't you
use wait_event() here?

The explanation about the interrupt handler seems incorrect, since PREEMPT_RT
also turns interrupt handlers into threads.

> +static long rf_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> +{
> +	struct rf_ctrl_dev *rf_dev;
> +	struct rf_phy_dev *phy;
> +	struct rf_init_params init_params;
> +	struct rif_phy_cmd_set cmd_set;
> +	struct rif_reg_buf reg_buf;
> +	struct rif_write_reg_buf write_reg_buf;
> +	struct rif_dac_params dac_params;
> +	struct rif_dac_buf dac_buff;
> +	struct rf_dev_info dev_info;
> +	struct rf_tx_buf tx_buf;
> +	struct rf_tx_en_dis tx_en_dis;
> +	struct rf_rssi rssi;
> +	struct rf_rx_gain rx_gain;
> +	struct rf_gain_ctrl gain_ctrl;
> +	struct rf_sniff_params sniff_params;
> +	struct rf_synth_table synth_table;
> +	struct rf_channel_params chan_params;
> +	struct rf_event_listener listener;
> +	unsigned long long (*params_buf)[NUM_SYNTH_PARAMS];
> +	u8 (*reg_vals_buf)[NUM_SYNTH_REGS];

Are you sure you don't run out of stack space here?
It may also be beter for style reasons to split this function into a set
of functions, one for each case.

> +	u32	*buf;
> +	u32 u32arg;
> +	int rc = -ENOSYS, size;
> +
> +	rf_dev = filep->private_data;
> +	phy = rf_dev->phy;
> +
> +	rc = mutex_lock_interruptible(&rf_dev->lock);
> +	switch (cmd) {

If mutex_lock_interruptible() fails, you should not enter the
function because you don't actually hold the mutex.

> +struct rif_phy_cmd {
> +	__u32	param1;
> +	__u32	param2;
> +	__u32	param3;
> +	__u8	cmd;
> +};
> +
> +struct rif_phy_cmd_set {
> +	struct rif_phy_cmd *cmds;
> +	__u32 count;
> +};

Please try to avoid ioctl structures with pointers in them, they are harder
to parse from anything that needs to intercept the ioctl in user space, and
they break 64 bit compatibility mode.

You should also add padding in the first structure to ensure that the size
is a multiple of the largest member. Otherwise you break e.g. ARM OABI
support or anything else that has unconventional rules on the ABI.

> +struct time_sync_1588_cnt {
> +	__u32 high;
> +	__u32 low;
> +};
> +
> +struct time_info {
> +	struct time_sync_1588_cnt time_cnt;
> +	__u8 event;
> +};

Here too.

> +struct time_sync_data {
> +	struct time_info time_info;
> +	__u32 lte_delay;
> +	__u32 ioctl_cmd;
> +	__u32 black_out_duration;
> +	__u8 correction_mode;
> +	__u8 sync_source;
> +};

It definitely sounds like a bug to have a member named "ioctl_cmd" in
a structure that is passed in an ioctl command.

> +struct rif_dac_buf {
> +	__u32 correction_type;
> +	__u32 *buf;
> +};

A pointer again.

> +#define RF_MAGIC 0xEE
> +#define RIF_DEV_INIT		_IOWR(RF_MAGIC, 1, struct rf_init_params)
> +#define RIF_SET_TIMER_SOURCE	_IOW(RF_MAGIC, 2, unsigned int)
> +#define RIF_GET_STATE		_IOR(RF_MAGIC, 3, unsigned int)
> +#define RIF_SET_TIMER_CORRECTION _IOW(RF_MAGIC, 4, struct rif_dac_params)
> +#define	RIF_RUN_PHY_CMDS	_IOW(RF_MAGIC, 5, struct rif_phy_cmd_set)
> +#define RIF_READ_RSSI		_IOWR(RF_MAGIC, 6, struct rf_rssi)
> +#define RIF_READ_PHY_REGS	_IOR(RF_MAGIC, 7, struct rif_reg_buf)
> +#define RIF_READ_CTRL_REGS	_IOR(RF_MAGIC, 8, struct rif_reg_buf)
> +#define RIF_START		_IO(RF_MAGIC, 9)
> +#define RIF_STOP		_IO(RF_MAGIC, 10)
> +#define RIF_GET_DEV_INFO	_IOWR(RF_MAGIC, 11, struct rf_dev_info)
> +#define RIF_WRITE_PHY_REGS _IOR(RF_MAGIC, 12, struct rif_write_reg_buf)
> +#define RIF_GET_DAC_VALUE	_IOR(RF_MAGIC, 13, struct rif_dac_buf)
> +#define RIF_SET_TX_ATTEN	_IOW(RF_MAGIC, 14, struct rf_tx_buf)
> +#define RIF_EN_DIS_TX		_IOW(RF_MAGIC, 15, struct rf_tx_en_dis)
> +#define RIF_WRITE_CTRL_REGS 	_IOW(RF_MAGIC, 16, struct rif_write_reg_buf)
> +#define RIF_READ_RX_GAIN 	_IOWR(RF_MAGIC, 17, struct rf_rx_gain)
> +#define RIF_CONFIG_SNIFF 	_IOWR(RF_MAGIC, 18, struct rf_sniff_params)
> +#define RIF_WRITE_RX_GAIN 	_IOW(RF_MAGIC, 19, struct rf_rx_gain)
> +#define RIF_SET_GAIN_CTRL_MODE 	_IOW(RF_MAGIC, 20, struct rf_gain_ctrl)
> +#define RIF_INIT_SYNTH_TABLE	_IOW(RF_MAGIC, 21, struct rf_synth_table)
> +#define RIF_CHANNEL_OPEN	_IOW(RF_MAGIC, 22, struct rf_channel_params)
> +#define RIF_CHANNEL_CLOSE	_IOW(RF_MAGIC, 23, unsigned int)
> +#define RIF_REGISTER_EVENT	_IOW(RF_MAGIC, 24, struct rf_event_listener)
> +#define RIF_UNREGISTER_EVENT	_IO(RF_MAGIC, 25)

On the whole, the ioctl API looks very complex to me. It may well be that
the complexity is necessary, but I cannot tell because I don't understand
the subsystem. Can you find someone from another company that has hardware
which would use the same subsystem, and have them do a review of the API
to ensure it works for them as well?

	Arnd
