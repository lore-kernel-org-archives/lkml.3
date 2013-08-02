Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3HBAos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 20:44:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:52511 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab3HBAoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 20:44:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,797,1367996400"; 
   d="scan'208";a="380405084"
Subject: Re: [PATCH 3/5] Intel MIC Host Driver Changes for Virtio Devices.
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
In-Reply-To: <20130729070000.GA2308@redhat.com>
References: <cover.1374717252.git.sudeep.dutt@intel.com>
	 <43d0932810d066e52bd6ee996b3cb59da8c42e85.1374717252.git.sudeep.dutt@intel.com>
	 <20130729070000.GA2308@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Aug 2013 17:40:51 -0700
Message-ID: <1375404051.61060.75.camel@blbiskey-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-29 at 10:05 +0300, Michael S. Tsirkin wrote: 
> On Wed, Jul 24, 2013 at 08:31:34PM -0700, Sudeep Dutt wrote:
> > From: Ashutosh Dixit <ashutosh.dixit@intel.com>
> > 
> > This patch introduces the host "Virtio over PCIe" interface for
> > Intel MIC. It allows creating user space backends on the host and
> > instantiating virtio devices for them on the Intel MIC card. A character
> > device per MIC is exposed with IOCTL, mmap and poll callbacks. This allows
> > the user space backend to:
> > (a) add/remove a virtio device via a device page.
> > (b) map (R/O) virtio rings and device page to user space.
> > (c) poll for availability of data.
> > (d) copy a descriptor or entire descriptor chain to/from the card.
> > (e) modify virtio configuration.
> > (f) handle virtio device reset.
> > The buffers are copied over using CPU copies for this initial patch
> > and host initiated MIC DMA support is planned for future patches.
> > The avail and desc virtio rings are in host memory and the used ring
> > is in card memory to maximize writes across PCIe for performance.
> > 
> > Co-author: Sudeep Dutt <sudeep.dutt@intel.com>
> > Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
> > Signed-off-by: Caz Yokoyama <Caz.Yokoyama@intel.com>
> > Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
> > Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
> > Signed-off-by: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
> > Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
> > Acked-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
> > Reviewed-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> 
> I decided to look at the security and ordering of ring accesses.
> Doing a quick look, I think I found some issues, see comments below.
> If it were possible to reuse existing ring handling code,
> such issues would go away automatically.
> Which brings me to the next question: have you looked at reusing
> some code under drivers/vhost for host side processing?
> If not, you probably should.
> Is code in vringh.c generic enough to support your use-case,
> and if not what exactly are the issues preventing this?
> 
> Thanks,
> 
We had implemented our custom MIC vring host access logic before the
VRINGH infrastructure was merged to mainline in v3.10. Based on your
feedback, we have a proof of concept implemented this week, by reusing
the VRINGH infrastructure and it works nicely for us!

One of our goals is to issue the  buffer transfers using DMA with future
patches. The CPU copy in our current patches is also slightly different
compared to VRINGH since we are copying from card buffers to user space
and vice versa. In order to do meet these goals, we are obtaining the
next available descriptor via vringh_getdesc_kern(..), then triggering
the copy (CPU or eventually DMA) via a custom MIC API and then
publishing the descriptor via vringh_complete_kern(..). Are there any
plans of enhancing VRINGH to allow overriding the xfer mechanism in
vringh_iov_xfer(..)? This will allow drivers with custom xfer routines
to reuse APIs like vringh_iov_push_kern(..) and vringh_iov_pull_kern(..)
as well. That said, the existing VRINGH infrastructure is generic enough
for our use case as is today.

We will post a rev1 of the patch series using VRINGH after some more
validation which should automatically address most of your other
feedback. Thanks for the review!

> > diff --git a/drivers/misc/mic/host/mic_virtio.c b/drivers/misc/mic/host/mic_virtio.c
> > new file mode 100644
> > index 0000000..7282e12
> > --- /dev/null
> > +++ b/drivers/misc/mic/host/mic_virtio.c
> > @@ -0,0 +1,703 @@
> > +/*
> > + * Intel MIC Platform Software Stack (MPSS)
> > + *
> > + * Copyright(c) 2013 Intel Corporation.
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
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
> > + * USA.
> > + *
> > + * The full GNU General Public License is included in this distribution in
> > + * the file called "COPYING".
> > + *
> > + * Intel MIC Host driver.
> > + *
> > + */
> > +#include <linux/module.h>
> > +#include <linux/fs.h>
> > +#include <linux/pci.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/firmware.h>
> > +#include <linux/completion.h>
> > +#include <linux/poll.h>
> > +#include <linux/sched.h>
> > +#include <uapi/linux/virtio_ids.h>
> > +#include <uapi/linux/virtio_net.h>
> > +
> > +#include "mic_common.h"
> > +#include "mic_virtio.h"
> > +
> > +/* See comments in vhost.c for explanation of next_desc() */
> > +static unsigned next_desc(struct vring_desc *desc)
> > +{
> > +	unsigned int next;
> > +
> > +	if (!(le16_to_cpu(desc->flags) & VRING_DESC_F_NEXT))
> > +		return -1U;
> > +	next = le16_to_cpu(desc->next);
> > +	read_barrier_depends();
> > +	return next;
> > +}
> > +
> > +/*
> > + * Central API which initiates the copies across the PCIe bus.
> > + */
> > +static int mic_virtio_copy_desc_buf(struct mic_vdev *mvdev,
> > +			struct vring_desc *desc,
> > +			void __user *ubuf, u32 rem_len, u32 doff, u32 *out_len)
> > +{
> > +	void __iomem *dbuf;
> > +	int err;
> > +	u32 len = le32_to_cpu(desc->len);
> > +	u16 flags = le16_to_cpu(desc->flags);
> > +	u64 addr = le64_to_cpu(desc->addr);
> > +
> > +	dbuf = mvdev->mdev->aper.va + addr + doff;
> > +	*out_len = min_t(u32, rem_len, len - doff);
> > +	if (flags & VRING_DESC_F_WRITE) {
> > +		/*
> > +		 * We are copying to IO below and the subsequent
> > +		 * wmb(..) ensures that the stores have completed.
> 
> It doesn't - you would need to read card memory for this.
> What wmb does is order previous stores wrt subsequent stores.
> So I am guessing you really want to move this smb to
> where avail ring is written.
> 
There are similar discussions around write combining and PCIe posted
writes @ [1] and [2]. For now, I am adding the (slow) read in the next
revision of the patch series here since that is guaranteed to work
correctly. Please let us know if there is any other way to ensure that
the previous PCIe posted writes have completed, (if we map card memory
as write combined from the host) without a PCIe read from the card.

Thanks,
Sudeep Dutt

[1] http://lkml.indiana.edu/hypermail/linux/kernel/0208.2/0049.html
[2] https://lkml.org/lkml/2006/2/25/146

> > +		 * We should ideally use something like
> > +		 * copy_from_user_toio(..) if it existed.
> > +		 */
> > +		if (copy_from_user(dbuf, ubuf, *out_len)) {
> > +			err = -EFAULT;
> > +			dev_err(mic_dev(mvdev), "%s %d err %d\n",
> > +				__func__, __LINE__, err);
> > +			goto err;
> > +		}
> > +		mvdev->out_bytes += *out_len;
> > +		wmb();
> > +	} else {
> > +		/*
> > +		 * We are copying from IO below and the subsequent
> > +		 * rmb(..) ensures that the loads have completed.
> > +		 * We should ideally use something like
> > +		 * copy_to_user_fromio(..) if it existed.
> > +		 */
> > +		if (copy_to_user(ubuf, dbuf, *out_len)) {
> > +			err = -EFAULT;
> > +			dev_err(mic_dev(mvdev), "%s %d err %d\n",
> > +				__func__, __LINE__, err);
> > +			goto err;
> > +		}
> > +		mvdev->in_bytes += *out_len;
> > +		rmb();
> > +	}
> > +	err = 0;
> > +err:
> > +	dev_dbg(mic_dev(mvdev),
> > +		"%s: ubuf %p dbuf %p rem_len 0x%x *out_len 0x%x "
> > +		"dlen 0x%x desc->writable %d err %d\n",
> > +		__func__, ubuf, dbuf, rem_len, *out_len,
> > +		len, flags & VRING_DESC_F_WRITE, err);
> > +	return err;
> > +}
> > +




