Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077Ab3BTSmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:42:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:62396 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008Ab3BTSmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:42:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,702,1355126400"; 
   d="scan'208";a="293739058"
Message-ID: <1361385717.18593.12.camel@ideak-mobl>
Subject: Re: dw_mmc build broken in next-20130220 (was Re: [PATCH v3 2/2]
 lib/scatterlist: use page iterator in the mapping iterator)
From: Imre Deak <imre.deak@intel.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linaro-mm-sig@lists.linaro.org,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, linux-mmc@vger.kernel.org,
        linux-next@vger.kernel.org
Date: Wed, 20 Feb 2013 20:41:57 +0200
In-Reply-To: <CAAG0J99wUgcOt09_XxuK+ennnuj7OzxcJndYYGXbAqpj59E7PQ@mail.gmail.com>
References: <CAAG0J99wUgcOt09_XxuK+ennnuj7OzxcJndYYGXbAqpj59E7PQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 16:42 +0000, James Hogan wrote:
> On 13 February 2013 15:10, Imre Deak <imre.deak@intel.com> wrote:
> > For better code reuse use the newly added page iterator to iterate
> > through the pages. The offset, length within the page is still
> > calculated by the mapping iterator as well as the actual mapping.
> > Idea from Tejun Heo <tj@kernel.org>.
> >
> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > ---
> >  include/linux/scatterlist.h |    6 +++---
> >  lib/scatterlist.c           |   46 ++++++++++++++++++++-----------------------
> >  2 files changed, 24 insertions(+), 28 deletions(-)
> >
> > diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> > index 788a853..a6cd692 100644
> > --- a/include/linux/scatterlist.h
> > +++ b/include/linux/scatterlist.h
> > @@ -295,9 +295,9 @@ struct sg_mapping_iter {
> >         size_t                  consumed;       /* number of consumed bytes */
> >
> >         /* these are internal states, keep away */
> > -       struct scatterlist      *__sg;          /* current entry */
> > -       unsigned int            __nents;        /* nr of remaining entries */
> > -       unsigned int            __offset;       /* offset within sg */
> > +       unsigned int            __offset;       /* offset within page */
> > +       struct sg_page_iter     __piter;        /* page iterator */
> > +       unsigned int            __remaining;    /* remaining bytes on page */
> >         unsigned int            __flags;
> >  };
> 
> Hi,
> 
> FYI, in next-20130220 this appears to break the build of the dw_mmc driver:
> drivers/mmc/host/dw_mmc.c In function 'dw_mci_read_data_pio':
> drivers/mmc/host/dw_mmc.c +1457 : error: 'struct sg_mapping_iter' has
> no member named '__sg'
> drivers/mmc/host/dw_mmc.c In function 'dw_mci_write_data_pio':
> drivers/mmc/host/dw_mmc.c +1512 : error: 'struct sg_mapping_iter' has
> no member named '__sg'

My fault, I haven't noticed this user of the field. It could be fixed by
using __piter.sg instead of __sg. I will follow up with v4 of this patch
including this change.

--Imre


