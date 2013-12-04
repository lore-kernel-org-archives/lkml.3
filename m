Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3LDHkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 02:40:40 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16155 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab3LDHki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 02:40:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 03 Dec 2013 23:37:40 -0800
Date: Wed, 4 Dec 2013 09:40:27 +0200
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "joro@8bytes.org" <joro@8bytes.org>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv6 05/13] iommu/core: add ops->{bound,unbind}_driver()
Message-ID: <20131204094027.dad1288aec14551ec42f3743@nvidia.com>
In-Reply-To: <20131125154937.d6dbe9aedc16aab335d92f99@nvidia.com>
References: <1385041249-7705-1-git-send-email-hdoyu@nvidia.com>
	<1385041249-7705-6-git-send-email-hdoyu@nvidia.com>
	<20131125154937.d6dbe9aedc16aab335d92f99@nvidia.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Nov 2013 14:49:37 +0100
Hiroshi Doyu <hdoyu@nvidia.com> wrote:

> Hi Joerg,
> 
> Do you have some time to review this patch along with the following ones?
> 
>   [PATCHv6 02/13] iommu/of: introduce a global iommu device list
>   http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007050.html
> 
>   [PATCHv6 03/13] iommu/of: check if dependee iommu is ready or not
>   http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007051.html

Any chance to get some feedback on them?

> With those patches, now I'm trying to populate iommu master devices
> after an IOMMU device is populated. Originally [PATCHv6 02/13] was
> proposed by Thierry. I'm a bit afraid of adding new IOMMU API as
> this, but I think that this new {bound,unbind}_driver() is the right
> timiing that depeding devices are populated instead of add_device()
> since, even after add_device, a device won't be populated. I'm not so
> sure how this affects on the existing IOMMUs.
> 
> It would be nice if you give some feedback on this.
> 
> On Thu, 21 Nov 2013 14:40:41 +0100
> Hiroshi Doyu <hdoyu@nvidia.com> wrote:
> 
> > ops->{bound,unbind}_driver() functions are called at
> > BUS_NOTIFY_{BOUND,UNBIND}_DRIVER respectively.
> > 
> > This is necessary to control the device population order. IOMMU master
> > devices depend on an IOMMU device instanciation. IOMMU master devices
> > can be registered to an IOMMU only after it's successfully
> > populated. This IOMMU registration is done via
> > ops->bound_driver(). Currently this population can be deferred if
> > depending IOMMU device hasn't yet been populated in driver core. This
> > cannot be done via ops->add_device() since after add_device() device's
> > population/instanciation can be still deferred via probe().
> > 
> > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> > ---
> > v6:
> > New for v6.
> > ---
> >  drivers/iommu/iommu.c | 13 +++++++++++--
> >  include/linux/iommu.h |  4 ++++
> >  2 files changed, 15 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > index e5555fc..5469d36 100644
> > --- a/drivers/iommu/iommu.c
> > +++ b/drivers/iommu/iommu.c
> > @@ -540,14 +540,23 @@ static int iommu_bus_notifier(struct notifier_block *nb,
> >  	 * ADD/DEL call into iommu driver ops if provided, which may
> >  	 * result in ADD/DEL notifiers to group->notifier
> >  	 */
> > -	if (action == BUS_NOTIFY_ADD_DEVICE) {
> > +	switch (action) {
> > +	case BUS_NOTIFY_ADD_DEVICE:
> >  		if (ops->add_device)
> >  			return ops->add_device(dev);
> > -	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
> > +	case BUS_NOTIFY_DEL_DEVICE:
> >  		if (ops->remove_device && dev->iommu_group) {
> >  			ops->remove_device(dev);
> >  			return 0;
> >  		}
> > +	case BUS_NOTIFY_BOUND_DRIVER:
> > +		if (ops->bound_driver)
> > +			ops->bound_driver(dev);
> > +		break;
> > +	case BUS_NOTIFY_UNBIND_DRIVER:
> > +		if (ops->unbind_driver)
> > +			ops->unbind_driver(dev);
> > +		break;
> >  	}
> >  
> >  	/*
> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > index a444c79..a0e92be 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -96,6 +96,8 @@ enum iommu_attr {
> >   * @domain_has_cap: domain capabilities query
> >   * @add_device: add device to iommu grouping
> >   * @remove_device: remove device from iommu grouping
> > + * @bound_driver: called at BUS_NOTIFY_BOUND_DRIVER
> > + * @unbind_driver: called at BUS_NOTIFY_UNBIND_DRIVER
> >   * @domain_get_attr: Query domain attributes
> >   * @domain_set_attr: Change domain attributes
> >   * @pgsize_bitmap: bitmap of supported page sizes
> > @@ -114,6 +116,8 @@ struct iommu_ops {
> >  			      unsigned long cap);
> >  	int (*add_device)(struct device *dev);
> >  	void (*remove_device)(struct device *dev);
> > +	int (*bound_driver)(struct device *dev);
> > +	void (*unbind_driver)(struct device *dev);
> >  	int (*device_group)(struct device *dev, unsigned int *groupid);
> >  	int (*domain_get_attr)(struct iommu_domain *domain,
> >  			       enum iommu_attr attr, void *data);
> > -- 
> > 1.8.1.5
> > 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
