Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912Ab3GZNbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:31:04 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41643 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957Ab3GZNbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:31:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Corey Minyard <minyard@acm.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH 07/13] ACPI/IPMI: Add reference counting for ACPI IPMI transfers
Date: Fri, 26 Jul 2013 15:41:05 +0200
Message-ID: <5356265.MuhlrzBCgP@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E8802435AFE@SHSMSX101.ccr.corp.intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com> <4808924.gkxOzGhztB@vostro.rjw.lan> <1AE640813FDE7649BE1B193DEA596E8802435AFE@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 26, 2013 01:21:18 AM Zheng, Lv wrote:
> > From: linux-acpi-owner@vger.kernel.org
> > [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
> > Sent: Friday, July 26, 2013 6:23 AM
> > 
> > On Tuesday, July 23, 2013 04:09:54 PM Lv Zheng wrote:
> > > This patch adds reference counting for ACPI IPMI transfers to tune the
> > > locking granularity of tx_msg_lock.
> > >
> > > The acpi_ipmi_msg handling is re-designed using referece counting.
> > > 1. tx_msg is always unlinked before complete(), so that:
> > >    1.1. it is safe to put complete() out side of tx_msg_lock;
> > >    1.2. complete() can only happen once, thus smp_wmb() is not required.
> > > 2. Increasing the reference of tx_msg before calling
> > >    ipmi_request_settime() and introducing tx_msg_lock protected
> > >    ipmi_cancel_tx_msg() so that a complete() can happen in parellel with
> > >    tx_msg unlinking in the failure cases.
> > > 3. tx_msg holds the reference of acpi_ipmi_device so that it can be flushed
> > >    and freed in the contexts other than acpi_ipmi_space_handler().
> > >
> > > The lockdep_chains shows all acpi_ipmi locks are leaf locks after the
> > > tuning:
> > > 1. ipmi_lock is always leaf:
> > >    irq_context: 0
> > >    [ffffffff81a943f8] smi_watchers_mutex
> > >    [ffffffffa06eca60] driver_data.ipmi_lock
> > >    irq_context: 0
> > >    [ffffffff82767b40] &buffer->mutex
> > >    [ffffffffa00a6678] s_active#103
> > >    [ffffffffa06eca60] driver_data.ipmi_lock
> > > 2. without this patch applied, lock used by complete() is held after
> > >    holding tx_msg_lock:
> > >    irq_context: 0
> > >    [ffffffff82767b40] &buffer->mutex
> > >    [ffffffffa00a6678] s_active#103
> > >    [ffffffffa06ecce8] &(&ipmi_device->tx_msg_lock)->rlock
> > >    irq_context: 1
> > >    [ffffffffa06ecce8] &(&ipmi_device->tx_msg_lock)->rlock
> > >    irq_context: 1
> > >    [ffffffffa06ecce8] &(&ipmi_device->tx_msg_lock)->rlock
> > >    [ffffffffa06eccf0] &x->wait#25
> > >    irq_context: 1
> > >    [ffffffffa06ecce8] &(&ipmi_device->tx_msg_lock)->rlock
> > >    [ffffffffa06eccf0] &x->wait#25
> > >    [ffffffff81e36620] &p->pi_lock
> > >    irq_context: 1
> > >    [ffffffffa06ecce8] &(&ipmi_device->tx_msg_lock)->rlock
> > >    [ffffffffa06eccf0] &x->wait#25
> > >    [ffffffff81e36620] &p->pi_lock
> > >    [ffffffff81e5d0a8] &rq->lock
> > > 3. with this patch applied, tx_msg_lock is always leaf:
> > >    irq_context: 0
> > >    [ffffffff82767b40] &buffer->mutex
> > >    [ffffffffa00a66d8] s_active#107
> > >    [ffffffffa07ecdc8] &(&ipmi_device->tx_msg_lock)->rlock
> > >    irq_context: 1
> > >    [ffffffffa07ecdc8] &(&ipmi_device->tx_msg_lock)->rlock
> > >
> > > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > > Cc: Zhao Yakui <yakui.zhao@intel.com>
> > > Reviewed-by: Huang Ying <ying.huang@intel.com>
> > > ---
> > >  drivers/acpi/acpi_ipmi.c |  107
> > +++++++++++++++++++++++++++++++++-------------
> > >  1 file changed, 77 insertions(+), 30 deletions(-)
> > >
> > > diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
> > > index 2a09156..0ee1ea6 100644
> > > --- a/drivers/acpi/acpi_ipmi.c
> > > +++ b/drivers/acpi/acpi_ipmi.c
> > > @@ -105,6 +105,7 @@ struct acpi_ipmi_msg {
> > >  	u8	data[ACPI_IPMI_MAX_MSG_LENGTH];
> > >  	u8	rx_len;
> > >  	struct acpi_ipmi_device *device;
> > > +	atomic_t	refcnt;
> > 
> > Again: kref, please?
> 
> Please see the concerns in another email.
> 
> > 
> > >  };
> > >
> > >  /* IPMI request/response buffer per ACPI 4.0, sec 5.5.2.4.3.2 */
> > > @@ -195,22 +196,47 @@ static struct acpi_ipmi_device
> > *acpi_ipmi_get_selected_smi(void)
> > >  	return ipmi_device;
> > >  }
> > >
> > > -static struct acpi_ipmi_msg *acpi_alloc_ipmi_msg(struct acpi_ipmi_device
> > *ipmi)
> > > +static struct acpi_ipmi_msg *ipmi_msg_alloc(void)
> > >  {
> > > +	struct acpi_ipmi_device *ipmi;
> > >  	struct acpi_ipmi_msg *ipmi_msg;
> > > -	struct pnp_dev *pnp_dev = ipmi->pnp_dev;
> > >
> > > +	ipmi = acpi_ipmi_get_selected_smi();
> > > +	if (!ipmi)
> > > +		return NULL;
> > >  	ipmi_msg = kzalloc(sizeof(struct acpi_ipmi_msg), GFP_KERNEL);
> > > -	if (!ipmi_msg)	{
> > > -		dev_warn(&pnp_dev->dev, "Can't allocate memory for ipmi_msg\n");
> > > +	if (!ipmi_msg) {
> > > +		acpi_ipmi_dev_put(ipmi);
> > >  		return NULL;
> > >  	}
> > > +	atomic_set(&ipmi_msg->refcnt, 1);
> > >  	init_completion(&ipmi_msg->tx_complete);
> > >  	INIT_LIST_HEAD(&ipmi_msg->head);
> > >  	ipmi_msg->device = ipmi;
> > > +
> > >  	return ipmi_msg;
> > >  }
> > >
> > > +static struct acpi_ipmi_msg *
> > > +acpi_ipmi_msg_get(struct acpi_ipmi_msg *tx_msg)
> > > +{
> > > +	if (tx_msg)
> > > +		atomic_inc(&tx_msg->refcnt);
> > > +	return tx_msg;
> > > +}
> > > +
> > > +static void ipmi_msg_release(struct acpi_ipmi_msg *tx_msg)
> > > +{
> > > +	acpi_ipmi_dev_put(tx_msg->device);
> > > +	kfree(tx_msg);
> > > +}
> > > +
> > > +static void acpi_ipmi_msg_put(struct acpi_ipmi_msg *tx_msg)
> > > +{
> > > +	if (tx_msg && atomic_dec_and_test(&tx_msg->refcnt))
> > > +		ipmi_msg_release(tx_msg);
> > > +}
> > > +
> > >  #define		IPMI_OP_RGN_NETFN(offset)	((offset >> 8) & 0xff)
> > >  #define		IPMI_OP_RGN_CMD(offset)		(offset & 0xff)
> > >  static int acpi_format_ipmi_request(struct acpi_ipmi_msg *tx_msg,
> > > @@ -300,7 +326,7 @@ static void acpi_format_ipmi_response(struct
> > acpi_ipmi_msg *msg,
> > >
> > >  static void ipmi_flush_tx_msg(struct acpi_ipmi_device *ipmi)
> > >  {
> > > -	struct acpi_ipmi_msg *tx_msg, *temp;
> > > +	struct acpi_ipmi_msg *tx_msg;
> > >  	unsigned long flags;
> > >
> > >  	/*
> > > @@ -311,16 +337,46 @@ static void ipmi_flush_tx_msg(struct
> > acpi_ipmi_device *ipmi)
> > >  	 */
> > >  	while (atomic_read(&ipmi->refcnt) > 1) {
> > >  		spin_lock_irqsave(&ipmi->tx_msg_lock, flags);
> > > -		list_for_each_entry_safe(tx_msg, temp,
> > > -					 &ipmi->tx_msg_list, head) {
> > > +		while (!list_empty(&ipmi->tx_msg_list)) {
> > > +			tx_msg = list_first_entry(&ipmi->tx_msg_list,
> > > +						  struct acpi_ipmi_msg,
> > > +						  head);
> > > +			list_del(&tx_msg->head);
> > > +			spin_unlock_irqrestore(&ipmi->tx_msg_lock, flags);
> > > +
> > >  			/* wake up the sleep thread on the Tx msg */
> > >  			complete(&tx_msg->tx_complete);
> > > +			acpi_ipmi_msg_put(tx_msg);
> > > +			spin_lock_irqsave(&ipmi->tx_msg_lock, flags);
> > >  		}
> > >  		spin_unlock_irqrestore(&ipmi->tx_msg_lock, flags);
> > > +
> > >  		schedule_timeout_uninterruptible(msecs_to_jiffies(1));
> > >  	}
> > >  }
> > >
> > > +static void ipmi_cancel_tx_msg(struct acpi_ipmi_device *ipmi,
> > > +			       struct acpi_ipmi_msg *msg)
> > > +{
> > > +	struct acpi_ipmi_msg *tx_msg;
> > > +	int msg_found = 0;
> > 
> > Use bool?
> 
> OK.
> There are other int flags in the original codes, do I need to do a cleanup for all of them (dev_found)?

Not in this patch, but in general it wouldn't hurt.

> > > +	unsigned long flags;
> > > +
> > > +	spin_lock_irqsave(&ipmi->tx_msg_lock, flags);
> > > +	list_for_each_entry(tx_msg, &ipmi->tx_msg_list, head) {
> > > +		if (msg == tx_msg) {
> > > +			msg_found = 1;
> > > +			break;
> > > +		}
> > > +	}
> > > +	if (msg_found)
> > > +		list_del(&tx_msg->head);
> > 
> > The list_del() can be done when you set msg_found.
> 
> Please see my concerns in another email.

OK, I'll reply there.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
