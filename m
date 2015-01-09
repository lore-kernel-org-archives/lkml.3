Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492AbbAIX7C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:59:02 -0500
Received: from mga14.intel.com ([192.55.52.115]:44421 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758473AbbAIX7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:59:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,734,1413270000"; 
   d="scan'208";a="667415175"
Subject: Re: [PATCH char-misc-next 04/13] misc: mic: SCIF Peer Bus
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: sudeep.dutt@intel.com, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
In-Reply-To: <20150109230726.GC3614@kroah.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
	 <a6cd58c4c752a4848d078af397ecf341158c2725.1418237176.git.sudeep.dutt@intel.com>
	 <20150109230726.GC3614@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jan 2015 15:58:46 -0800
Message-ID: <1420847926.6393.4.camel@rbtaylor-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-09 at 15:07 -0800, Greg Kroah-Hartman wrote:
> On Wed, Dec 10, 2014 at 11:47:44AM -0800, Sudeep Dutt wrote:
> > The SCIF peer bus is used to register and unregister SCIF peer devices
> > internally by the SCIF driver to signify the addition and removal of
> > peer nodes respectively from the SCIF network. This simplifies remote node
> > handling within SCIF and will also be used to support device probe/remove
> > for SCIF client drivers (e.g. netdev over SCIF)
> > 
> > Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
> > Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
> > Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
> > ---
> >  drivers/misc/mic/scif/scif_peer_bus.h |  63 +++++++++++++++++
> >  drivers/misc/mic/scif/scif_peer_bus.c | 124 ++++++++++++++++++++++++++++++++++
> >  2 files changed, 187 insertions(+)
> >  create mode 100644 drivers/misc/mic/scif/scif_peer_bus.h
> >  create mode 100644 drivers/misc/mic/scif/scif_peer_bus.c
> > 
> > diff --git a/drivers/misc/mic/scif/scif_peer_bus.h b/drivers/misc/mic/scif/scif_peer_bus.h
> > new file mode 100644
> > index 0000000..27ed508
> > --- /dev/null
> > +++ b/drivers/misc/mic/scif/scif_peer_bus.h
> > @@ -0,0 +1,63 @@
> > +/*
> > + * Intel MIC Platform Software Stack (MPSS)
> > + *
> > + * Copyright(c) 2014 Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License, version 2, as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> > + * General Public License for more details.
> > + *
> > + * Intel SCIF driver.
> > + */
> > +#ifndef _SCIF_PEER_BUS_H_
> > +#define _SCIF_PEER_BUS_H_
> > +
> > +#include <linux/device.h>
> > +#include <linux/mic_common.h>
> > +
> > +/*
> > + * Peer devices show up as PCIe devices for the mgmt node but not the cards.
> > + * The mgmt node discovers all the cards on the PCIe bus and informs the other
> > + * cards about their peers. Upon notification of a peer a node adds a peer
> > + * device to the peer bus to maintain symmetry in the way devices are
> > + * discovered across all nodes in the SCIF network.
> > + */
> > +/**
> > + * scif_peer_dev - representation of a peer SCIF device
> > + * @dev: underlying device
> > + * @dnode - The destination node which this device will communicate with.
> > + */
> > +struct scif_peer_dev {
> > +	struct device dev;
> > +	u8 dnode;
> > +};
> > +
> > +/**
> > + * scif_peer_driver - operations for a scif_peer I/O driver
> > + * @driver: underlying device driver (populate name and owner).
> > + * @id_table: the ids serviced by this driver.
> > + * @probe: the function to call when a device is found.  Returns 0 or -errno.
> > + * @remove: the function to call when a device is removed.
> > + */
> > +struct scif_peer_driver {
> > +	struct device_driver driver;
> > +	const struct scif_peer_dev_id *id_table;
> > +
> > +	int (*probe)(struct scif_peer_dev *dev);
> > +	void (*remove)(struct scif_peer_dev *dev);
> > +};
> > +
> > +int scif_peer_register_driver(struct scif_peer_driver *driver);
> > +void scif_peer_unregister_driver(struct scif_peer_driver *driver);
> > +struct scif_dev;
> > +struct scif_peer_dev *
> > +scif_peer_register_device(struct scif_dev *sdev);
> 
> Odd formatting, don't you think?
> 
> Please put your "predeclare scif_dev" on an earlier line by itself, as
> this is a mess.

I will fix it up and send across a v2 early next week.

Thanks,
Sudeep Dutt

