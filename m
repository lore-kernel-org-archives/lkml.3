Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab3GIRX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 13:23:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:52891 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab3GIRXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 13:23:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1029,1363158000"; 
   d="scan'208";a="265986892"
Date: Tue, 9 Jul 2013 10:24:57 -0700
From: Jubin Mehta <jubin.mehta@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Jon Mason <jon.mason@intel.com>
Subject: Re: [PATCH v2] dmatest: masking tests for channel capabilities
Message-ID: <20130709172456.GC9213@intel.com>
References: <20130621234647.GA3763@intel.com>
 <CAA9_cmePsWFfqmnEGB6XBJj7dsY7dSJtSLvy+s3NzVkttviRWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmePsWFfqmnEGB6XBJj7dsY7dSJtSLvy+s3NzVkttviRWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 01:47:07PM -0700, Dan Williams wrote:
> On Fri, Jun 21, 2013 at 4:46 PM, Jubin Mehta <jubin.mehta@intel.com> wrote:
> > The current dmatest module tests all the hardware capabilities (MEMCPY, XOR
> > and PQ) supported by a particular DMA channel and these tests are performed
> > concurrently by default. This patch allows the user to enable or disable the
> > test performed for any particular capability. The mask bits for enabling the
> > tests are set using the debugfs.
> >
> > Signed-off-by: Jubin Mehta <jubin.mehta@intel.com>
> [..]
> > diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> > index d8ce4ec..c152755 100644
> > --- a/drivers/dma/dmatest.c
> > +++ b/drivers/dma/dmatest.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/debugfs.h>
> >  #include <linux/uaccess.h>
> >  #include <linux/seq_file.h>
> > +#include <linux/string.h>
> >
> >  static unsigned int test_buf_size = 16384;
> >  module_param(test_buf_size, uint, S_IRUGO);
> > @@ -66,6 +67,11 @@ module_param(timeout, uint, S_IRUGO);
> >  MODULE_PARM_DESC(timeout, "Transfer Timeout in msec (default: 3000), "
> >                  "Pass -1 for infinite timeout");
> >
> > +static char test_cap_mask[20] = "copy,xor,pq";
> > +module_param_string(cap_mask, test_cap_mask, sizeof(test_cap_mask), S_IRUGO);
> 
> Let's just make this module parameter writable so we don't need to add
> a new debugfs file.
>

I shall do that. But, instead of having just the cap_mask parameter as
a writable module parameter, it would be great if we could have all
the module parameters writable and just have run file (to trigger the
test) and results file (to display the results of the test) in debugfs.

> The 'get' routine can also display the available testable operation
> types.
>

The testable operation types depend on the dma channel under test.
Thus, a 'get' routine cannot be used to obtain a default value for
the module parameter 'cap_mask'.

--
Jubin
> > +MODULE_PARM_DESC(cap_mask, "Mask bits for different capability test "
> > +                "(default: copy,xor,pq)");
> > +
> >  /* Maximum amount of mismatched bytes in buffer to print */
> >  #define MAX_ERROR_COUNT                32
> >
> > @@ -164,6 +170,7 @@ struct dmatest_chan {
> >   * @xor_sources:       number of xor source buffers
> >   * @pq_sources:                number of p+q source buffers
> >   * @timeout:           transfer timeout in msec, -1 for infinite timeout
> > + * @cap_mask:          mask for different hardware capabilities tests
> >   */
> >  struct dmatest_params {
> >         unsigned int    buf_size;
> > @@ -175,6 +182,7 @@ struct dmatest_params {
> >         unsigned int    xor_sources;
> >         unsigned int    pq_sources;
> >         int             timeout;
> > +       char            cap_mask[128];
> 
> This can be the capability mask directly... see below:
> 
> >  };
> >
> >  /**
> > @@ -883,11 +891,44 @@ static int dmatest_add_threads(struct dmatest_info *info,
> >         return i;
> >  }
> >
> > +static int dmatest_cap_check(struct dmatest_info *info,
> > +               dma_cap_mask_t *test_cap_mask)
> > +{
> > +       struct dmatest_params   *params;
> > +       char                    *cap;
> > +       unsigned char c;
> > +       int i;
> > +
> > +       params = &info->params;
> > +       cap = (params->cap_mask);
> > +
> > +       for (i = 0; i < 3; i++) {
> > +               if (!strncmp(cap, "copy", 4)) {
> > +                       dma_cap_set(DMA_MEMCPY, *test_cap_mask);
> > +                       cap += 4;
> > +               } else if (!strncmp(cap, "xor", 3)) {
> > +                       dma_cap_set(DMA_XOR, *test_cap_mask);
> > +                       cap += 3;
> > +               } else if (!strncmp(cap, "pq", 2)) {
> > +                       dma_cap_set(DMA_PQ, *test_cap_mask);
> > +                       cap += 2;
> > +               } else {
> > +                       return -1;
> > +               }
> > +               c = *cap++;
> > +               if (c != ',')
> > +                       break;
> > +       }
> > +       return 0;
> > +}
> 
> We can run this routine when the capabilities are set to return error
> on invalid capability masks directly.  Then we can set the
> test_cap_mask before dmatest_add_channel().
> 
> > +
> >  static int dmatest_add_channel(struct dmatest_info *info,
> >                 struct dma_chan *chan)
> >  {
> >         struct dmatest_chan     *dtc;
> >         struct dma_device       *dma_dev = chan->device;
> > +       struct dmatest_params   *params;
> > +       dma_cap_mask_t          test_cap_mask;
> >         unsigned int            thread_count = 0;
> >         int cnt;
> >
> > @@ -900,15 +941,28 @@ static int dmatest_add_channel(struct dmatest_info *info,
> >         dtc->chan = chan;
> >         INIT_LIST_HEAD(&dtc->threads);
> >
> > -       if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)) {
> > +       params = &info->params;
> > +
> > +       dma_cap_zero(test_cap_mask);
> > +       cnt = dmatest_cap_check(info, &test_cap_mask);
> > +       if (cnt) {
> > +               pr_warn("dmatest: Invalid Capability Mask Paramters\n");
> > +               return -EINVAL;
> > +       }
> 
> As above I think this too late to be validating the parameters.
> 
> > +
> > +       /* Run dmatest threads for the supported and enabled capabilities */
> > +       if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)
> > +           && dma_has_cap(DMA_MEMCPY, test_cap_mask)) {
> >                 cnt = dmatest_add_threads(info, dtc, DMA_MEMCPY);
> >                 thread_count += cnt > 0 ? cnt : 0;
> >         }
> > -       if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
> > +       if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)
> > +           && dma_has_cap(DMA_XOR, test_cap_mask)) {
> >                 cnt = dmatest_add_threads(info, dtc, DMA_XOR);
> >                 thread_count += cnt > 0 ? cnt : 0;
> >         }
> > -       if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
> > +       if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)
> > +           && dma_has_cap(DMA_PQ, test_cap_mask)) {
> >                 cnt = dmatest_add_threads(info, dtc, DMA_PQ);
> >                 thread_count += cnt > 0 ? cnt : 0;
> >         }
> 
> Could above be written simpler with one bitmap_and(test_cap_mask,
> dma_dev->cap_mask, test_cap_mask) at the start and then
> for_each_set_bit(test_cap_mask)?
> 
> 
> --
> Dan
