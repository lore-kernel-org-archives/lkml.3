Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbaHEE7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 00:59:37 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:35044 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaHEE7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 00:59:35 -0400
MIME-Version: 1.0
In-Reply-To: <1407214617-27317-1-git-send-email-xerofoify@gmail.com>
References: <1407214617-27317-1-git-send-email-xerofoify@gmail.com>
Date: Tue, 5 Aug 2014 00:59:32 -0400
Message-ID: <CAPDOMVjYuBiEW+ZzFBTDsqoFbAhVubhvC9msR+inNZE=P9q-eA@mail.gmail.com>
Subject: Re: [PATCH] xhci: Merge and Update debugging for patches from 3.6
 kernel tree
From: Nick Krause <xerofoify@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Nyman, Mathias" <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>, dsaxena <dsaxena@linaro.org>,
        "manjunath.goudar" <manjunath.goudar@linaro.org>,
        "jg1.han" <jg1.han@samsung.com>, davidm <davidm@egauge.net>,
        burzalodowa <burzalodowa@gmail.com>,
        hartleys <hartleys@visionengravers.com>,
        "gregory.clement" <gregory.clement@free-electrons.com>,
        oneukum <oneukum@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 12:56 AM, Nicholas Krause <xerofoify@gmail.com> wrote:
> I am adding the fixes to the tree send for adding debugging to the kernel
> tree from a patch sent in 2013 on the the 3.6 release. The patch adds
> debugging over xhci capable debugging usb ports and needed to be updated
> into the latest rc tree. The patch was first sent in this thread,
> http://marc.info/?l=linux-usb&m=135948845511047.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/usb/host/Makefile      |    2 +-
>  drivers/usb/host/xhci-dbgcap.c | 2478 ++++++++++++++++++++++++++++++++++++
>  drivers/usb/host/xhci-pci.c    |    8 +-
>  drivers/usb/host/xhci.h        |  197 ++-
>  xhci.patch                     | 2719 ++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 5384 insertions(+), 20 deletions(-)
>  create mode 100644 drivers/usb/host/xhci-dbgcap.c
>  create mode 100644 xhci.patch
>
> diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
> index af89a90..02f9fb2 100644
> --- a/drivers/usb/host/Makefile  +++ b/drivers/usb/host/Makefile
> @@ -13,7 +13,7 @@ fhci-y += fhci-mem.o fhci-tds.o fhci-sched.o
>  fhci-$(CONFIG_FHCI_DEBUG) += fhci-dbg.o
>
>  xhci-hcd-y := xhci.o xhci-mem.o
> -xhci-hcd-y += xhci-ring.o xhci-hub.o xhci-dbg.o
> +xhci-hcd-y += xhci-ring.o xhci-hub.o xhci-dbg.o xhci-dbgcap.o
>  xhci-hcd-y += xhci-trace.o
>  xhci-hcd-$(CONFIG_PCI) += xhci-pci.o
>
> diff --git a/drivers/usb/host/xhci-dbgcap.c b/drivers/usb/host/xhci-dbgcap.c
> new file mode 100644
> index 0000000..2c3dad1
> --- /dev/null
> +++ b/drivers/usb/host/xhci-dbgcap.c
> @@ -0,0 +1,2478 @@
> +/*
> + * xHCI host controller debug capability driver
> + *
> + * Copyright (C) 2012 Synopsys, Inc.
> + *
> + * Author: Paul Zimmerman
> + * Most code borrowed from the Linux xHCI driver.
> + *
> + */
> +
> +#include <linux/usb.h>
> +#include <linux/pci.h>
> +#include <linux/slab.h>
> +#include <linux/dmapool.h>
> +#include <linux/kthread.h>
> +#include <linux/freezer.h>
> +
> +#include "xhci.h"
> +
> +#define DBC_SRC_SINK   1
> +
> +#define DCD_VENDOR_ID  0x0525
> +#define DCD_PRODUCT_ID 0xa4a0
> +#define DCD_DEVICE_REV 0x0002
> +
> +static int dbc_incr;
> +
> +/*
> + * Debug Capability string descriptors
> + */
> +
> +#undef UCONSTW
> +#define UCONSTW(v)     cpu_to_le16(v)
> +
> +static struct {
> +       __u8    bLength;
> +       __u8    bDescriptorType;
> +       __le16  wString[1];
> +} __attribute__((packed)) dbc_language_string = {
> +       4,              /* bLength (size of string array  2) */
> +       USB_DT_STRING,  /* bDescriptorType */
> +       {               /* wString[] */
> +               /* US English */
> +               UCONSTW(0x0409),
> +       },
> +};
> +
> +static struct {
> +       __u8    bLength;
> +       __u8    bDescriptorType;
> +       __le16  wString[8];
> +} __attribute__((packed)) dbc_manuf_string = {
> +       18,             /* bLength (size of string array  2) */
> +       USB_DT_STRING,  /* bDescriptorType */
> +       {               /* wString[] */
> +               UCONSTW('S'), UCONSTW('y'), UCONSTW('n'), UCONSTW('o'),
> +               UCONSTW('p'), UCONSTW('s'), UCONSTW('y'), UCONSTW('s'),
> +       },
> +};
> +
> +static struct {
> +       __u8    bLength;
> +       __u8    bDescriptorType;
> +       __le16  wString[8];
> +} __attribute__((packed)) dbc_product_string = {
> +       18,             /* bLength (size of string array  2) */
> +       USB_DT_STRING,  /* bDescriptorType */
> +       {               /* wString[] */
> +               UCONSTW('D'), UCONSTW('W'), UCONSTW('C'), UCONSTW(' '),
> +               UCONSTW('U'), UCONSTW('S'), UCONSTW('B'), UCONSTW('3'),
> +       },
> +};
> +
> +static struct {
> +       __u8    bLength;
> +       __u8    bDescriptorType;
> +       __le16  wString[10];
> +} __attribute__((packed)) dbc_serial_string = {
> +       22,             /* bLength (size of string array  2) */
> +       USB_DT_STRING,  /* bDescriptorType */
> +       {               /* wString[] */
> +               UCONSTW('0'), UCONSTW('1'), UCONSTW('2'), UCONSTW('3'),
> +               UCONSTW('4'), UCONSTW('5'), UCONSTW('6'), UCONSTW('7'),
> +               UCONSTW('8'), UCONSTW('9'),
> +       },
> +};
> +
> +#undef UCONSTW
> +
> +/*
> + * Free the string descriptors
> + */
> +static void dbc_teardown_dbcic(struct xhci_hcd *xhci, struct device *dev)
> +{
> +       if (xhci->serial_str_desc) {
> +               dma_free_coherent(dev, sizeof(dbc_serial_string),
> +                               xhci->serial_str_desc,
> +                               xhci->serial_str_desc_dma);
> +               xhci->serial_str_desc = NULL;
> +       }
> +       if (xhci->product_str_desc) {
> +               dma_free_coherent(dev, sizeof(dbc_product_string),
> +                               xhci->product_str_desc,
> +                               xhci->product_str_desc_dma);
> +               xhci->product_str_desc = NULL;
> +       }
> +       if (xhci->manuf_str_desc) {
> +               dma_free_coherent(dev, sizeof(dbc_manuf_string),
> +                               xhci->manuf_str_desc,
> +                               xhci->manuf_str_desc_dma);
> +               xhci->manuf_str_desc = NULL;
> +       }
> +       if (xhci->str_0_desc) {
> +               dma_free_coherent(dev, sizeof(dbc_language_string),
> +                               xhci->str_0_desc,
> +                               xhci->str_0_desc_dma);
> +               xhci->str_0_desc = NULL;
> +       }
> +}
> +
> +/*
> + * Allocate the string descriptors and initialize the DbCIC
> + */
> +static int dbc_setup_dbcic(struct xhci_hcd *xhci, struct device *dev)
> +{
> +       struct xhci_dbg_cap_info_ctx *info_ctx = &xhci->dbg_cap_ctx->info_ctx;
> +
> +       /* Allocate the string descriptors */
> +       xhci->str_0_desc = dma_alloc_coherent(dev, sizeof(dbc_language_string),
> +                               &xhci->str_0_desc_dma, GFP_KERNEL);
> +       if (!xhci->str_0_desc)
> +               goto fail;
> +       xhci->manuf_str_desc = dma_alloc_coherent(dev, sizeof(dbc_manuf_string),
> +                               &xhci->manuf_str_desc_dma, GFP_KERNEL);
> +       if (!xhci->manuf_str_desc)
> +               goto fail;
> +       xhci->product_str_desc = dma_alloc_coherent(dev, sizeof(dbc_product_string),
> +                               &xhci->product_str_desc_dma, GFP_KERNEL);
> +       if (!xhci->product_str_desc)
> +               goto fail;
> +       xhci->serial_str_desc = dma_alloc_coherent(dev, sizeof(dbc_serial_string),
> +                               &xhci->serial_str_desc_dma, GFP_KERNEL);
> +       if (!xhci->serial_str_desc)
> +               goto fail;
> +
> +       memcpy(xhci->str_0_desc, &dbc_language_string, sizeof(dbc_language_string));
> +       memcpy(xhci->manuf_str_desc, &dbc_manuf_string, sizeof(dbc_manuf_string));
> +       memcpy(xhci->product_str_desc, &dbc_product_string, sizeof(dbc_product_string));
> +       memcpy(xhci->serial_str_desc, &dbc_serial_string, sizeof(dbc_serial_string));
> +
> +       /* Set the string descriptor address fields in the DbCIC */
> +       info_ctx->str_0_desc_addr_lo =
> +               cpu_to_le32(lower_32_bits(xhci->str_0_desc_dma));
> +       info_ctx->str_0_desc_addr_hi =
> +               cpu_to_le32(upper_32_bits(xhci->str_0_desc_dma));
> +       info_ctx->manuf_str_desc_addr_lo =
> +               cpu_to_le32(lower_32_bits(xhci->manuf_str_desc_dma));
> +       info_ctx->manuf_str_desc_addr_hi =
> +               cpu_to_le32(upper_32_bits(xhci->manuf_str_desc_dma));
> +       info_ctx->product_str_desc_addr_lo =
> +               cpu_to_le32(lower_32_bits(xhci->product_str_desc_dma));
> +       info_ctx->product_str_desc_addr_hi =
> +               cpu_to_le32(upper_32_bits(xhci->product_str_desc_dma));
> +       info_ctx->serial_str_desc_addr_lo =
> +               cpu_to_le32(lower_32_bits(xhci->serial_str_desc_dma));
> +       info_ctx->serial_str_desc_addr_hi =
> +               cpu_to_le32(upper_32_bits(xhci->serial_str_desc_dma));
> +
> +       /* Set the string length fields in the DbCIC */
> +       info_ctx->str_0_len = dbc_language_string.bLength;
> +       info_ctx->manuf_str_len = dbc_manuf_string.bLength;
> +       info_ctx->product_str_len = dbc_product_string.bLength;
> +       info_ctx->serial_str_len = dbc_serial_string.bLength;
> +
> +       return 0;
> +
> +fail:
> +       dbc_teardown_dbcic(xhci, dev);
> +       return -ENOMEM;
> +}
> +
> +/*
> + * Allocate a generic ring segment from the ring pool, set the dma address,
> + * initialize the segment to zero, and set the private next pointer to NULL
> + *
> + * Section 4.11.1.1:
> + * "All components of all Command and Transfer TRBs shall be initialized to '0'"
> + */
> +static struct xhci_segment *dbc_segment_alloc(struct xhci_hcd *xhci,
> +               unsigned int cycle_state, gfp_t flags)
> +{
> +       int i;
> +       dma_addr_t dma;
> +       struct xhci_segment *seg;
> +
> +       xhci_dbg(xhci, "%s()\n", __func__);
> +
> +       seg = kzalloc(sizeof(*seg), flags);
> +       if (!seg)
> +               return NULL;
> +
> +       seg->trbs = dma_pool_alloc(xhci->dbc_segment_pool, flags, &dma);
> +       if (!seg->trbs) {
> +               kfree(seg);
> +               return NULL;
> +       }
> +
> +       memset(seg->trbs, 0, SEGMENT_SIZE);
> +
> +       /* If the cycle state is 0, set the cycle bit to 1 for all the TRBs */
> +       if (cycle_state == 0) {
> +               xhci_dbg(xhci, "cycle_state = 0\n");
> +               for (i = 0; i < TRBS_PER_SEGMENT; i)
> +                       seg->trbs[i].link.control |= TRB_CYCLE;
> +       }
> +
> +       seg->dma = dma;
> +       seg->next = NULL;
> +       xhci_dbg(xhci, "seg=%p TRBs=%p (%08llx)\n", seg, seg->trbs,
> +                       (unsigned long long)dma);
> +
> +       return seg;
> +}
> +
> +static void dbc_segment_free(struct xhci_hcd *xhci, struct xhci_segment *seg)
> +{
> +       if (seg->trbs) {
> +               dma_pool_free(xhci->dbc_segment_pool, seg->trbs, seg->dma);
> +               seg->trbs = NULL;
> +       }
> +       kfree(seg);
> +}
> +
> +/*
> + * Make the prev segment point to the next segment
> + *
> + * Change the last TRB in the prev segment to be a Link TRB which points to the
> + * DMA address of the next segment. The caller needs to set any Link TRB
> + * related flags, such as End TRB, Toggle Cycle, and no snoop.
> + */
> +static void dbc_link_segments(struct xhci_hcd *xhci, struct xhci_segment *prev,
> +               struct xhci_segment *next, enum xhci_ring_type type)
> +{
> +       u32 val;
> +
> +       if (!prev || !next)
> +               return;
> +       prev->next = next;
> +       if (type != TYPE_EVENT) {
> +               prev->trbs[TRBS_PER_SEGMENT-1].link.segment_ptr =
> +                       cpu_to_le64(next->dma);
> +
> +               /* Set last TRB in segment to have TRB type ID = Link TRB */
> +               val = le32_to_cpu(prev->trbs[TRBS_PER_SEGMENT-1].link.control);
> +               val &= ~TRB_TYPE_BITMASK;
> +               val |= TRB_TYPE(TRB_LINK);
> +               /* Always set the chain bit with 0.95 hardware */
> +               /* Set chain bit for isoc rings on AMD 0.96 host */
> +               if (xhci_link_trb_quirk(xhci))
> +                       val |= TRB_CHAIN;
> +               prev->trbs[TRBS_PER_SEGMENT-1].link.control = cpu_to_le32(val);
> +       }
> +}
> +
> +static void dbc_free_segments_for_ring(struct xhci_hcd *xhci,
> +               struct xhci_segment *first)
> +{
> +       struct xhci_segment *seg = first->next;
> +
> +       while (seg != first) {
> +               struct xhci_segment *next = seg->next;
> +
> +               dbc_segment_free(xhci, seg);
> +
> +               seg = next;
> +       }
> +       dbc_segment_free(xhci, first);
> +}
> +
> +/* Allocate segments and link them for a ring */
> +static int dbc_alloc_segments_for_ring(struct xhci_hcd *xhci,
> +               struct xhci_segment **first, struct xhci_segment **last,
> +               unsigned int num_segs, unsigned int cycle_state,
> +               enum xhci_ring_type type, gfp_t flags)
> +{
> +       struct xhci_segment *prev;
> +
> +       xhci_dbg(xhci, "%s()\n", __func__);
> +
> +       prev = dbc_segment_alloc(xhci, cycle_state, flags);
> +       if (!prev)
> +               return -ENOMEM;
> +       num_segs--;
> +
> +       *first = prev;
> +       while (num_segs > 0) {
> +               struct xhci_segment *next;
> +
> +               next = dbc_segment_alloc(xhci, cycle_state, flags);
> +               if (!next) {
> +                       dbc_free_segments_for_ring(xhci, *first);
> +                       return -ENOMEM;
> +               }
> +               dbc_link_segments(xhci, prev, next, type);
> +
> +               prev = next;
> +               num_segs--;
> +       }
> +       dbc_link_segments(xhci, prev, *first, type);
> +       *last = prev;
> +
> +       return 0;
> +}
> +
> +/* XXX: Do we need the hcd structure in all these functions? */
> +static void dbc_ring_free(struct xhci_hcd *xhci, struct xhci_ring *ring)
> +{
> +       if (!ring)
> +               return;
> +       if (ring->first_seg)
> +               dbc_free_segments_for_ring(xhci, ring->first_seg);
> +       kfree(ring);
> +}
> +
> +static void dbc_initialize_ring_info(struct xhci_ring *ring,
> +               unsigned int cycle_state)
> +{
> +       /* The ring is empty, so the enqueue pointer == dequeue pointer */
> +       ring->enqueue = ring->first_seg->trbs;
> +       ring->enq_seg = ring->first_seg;
> +       ring->dequeue = ring->enqueue;
> +       ring->deq_seg = ring->first_seg;
> +       /* The ring is initialized to 0. The producer must write 1 to the cycle
> +        * bit to handover ownership of the TRB, so PCS = 1. The consumer must
> +        * compare CCS to the cycle bit to check ownership, so CCS = 1.
> +        *
> +        * New rings are initialized with cycle state equal to 1; if we are
> +        * handling ring expansion, set the cycle state equal to the old ring.
> +        */
> +       ring->cycle_state = cycle_state;
> +       /* Not necessary for new rings, but needed for re-initialized rings */
> +       ring->enq_updates = 0;
> +       ring->deq_updates = 0;
> +
> +       /*
> +        * Each segment has a link TRB, and leave an extra TRB for SW
> +        * accounting purpose
> +        */
> +       ring->num_trbs_free = ring->num_segs * (TRBS_PER_SEGMENT - 1) - 1;
> +}
> +
> +/**
> + * Create a new ring with zero or more segments
> + *
> + * Link each segment together into a ring.
> + * Set the end flag and the cycle toggle bit on the last segment.
> + * See section 4.9.1 and figures 15 and 16.
> + */
> +static struct xhci_ring *dbc_ring_alloc(struct xhci_hcd *xhci,
> +               unsigned int num_segs, unsigned int cycle_state,
> +               enum xhci_ring_type type, gfp_t flags)
> +{
> +       int ret;
> +       struct xhci_ring *ring;
> +
> +       xhci_dbg(xhci, "%s()\n", __func__);
> +
> +       ring = kzalloc(sizeof(*ring), flags);
> +       if (!ring)
> +               return NULL;
> +
> +       ring->num_segs = num_segs;
> +       INIT_LIST_HEAD(&ring->td_list);
> +       ring->type = type;
> +       if (num_segs == 0)
> +               return ring;
> +
> +       ret = dbc_alloc_segments_for_ring(xhci, &ring->first_seg,
> +                       &ring->last_seg, num_segs, cycle_state, type, flags);
> +       if (ret)
> +               goto fail;
> +
> +       /* Only event ring does not use link TRB */
> +       if (type != TYPE_EVENT) {
> +               /* See section 4.9.2.1 and 6.4.4.1 */
> +               ring->last_seg->trbs[TRBS_PER_SEGMENT - 1].link.control |=
> +                       cpu_to_le32(LINK_TOGGLE);
> +       }
> +       dbc_initialize_ring_info(ring, cycle_state);
> +       xhci_dbg(xhci, "first=%p TRBs=%p (%08llx)\n", ring->first_seg,
> +               ring->first_seg->trbs, (unsigned long long)ring->first_seg->dma);
> +       xhci_dbg(xhci, "last=%p TRBs=%p (%08llx)\n", ring->last_seg,
> +               ring->last_seg->trbs, (unsigned long long)ring->last_seg->dma);
> +       return ring;
> +
> +fail:
> +       dbc_ring_free(xhci, ring);
> +       return NULL;
> +}
> +
> +static void dbc_set_hc_event_deq(struct xhci_hcd *xhci)
> +{
> +       u64 temp;
> +       dma_addr_t deq;
> +
> +       xhci_dbg(xhci, "%s()\n", __func__);
> +
> +       deq = xhci_trb_virt_to_dma(xhci->dbc_event_ring->deq_seg,
> +                               xhci->dbc_event_ring->dequeue);
> +       if (deq == 0)
> +               xhci_warn(xhci, "WARN: something wrong with SW DbC event ring ptr\n");
> +       /* Update HC event ring dequeue pointer */
> +       temp = xhci_read_64(xhci, &xhci->dbg_cap_regs->dcerdp);
> +       if (temp == 0xffffffffffffffffUL) {
> +               xhci_err(xhci, "ERROR %s: DbC host controller died\n", __func__);
> +               return;
> +       }
> +       temp &= ERST_PTR_MASK;
> +       xhci_dbg(xhci, "// Write DbC event ring dequeue pointer, preserving EHB bit\n");
> +       xhci_write_64(xhci, ((u64)deq & ~(u64)ERST_PTR_MASK) | temp,
> +                       &xhci->dbg_cap_regs->dcerdp);
> +}
> +
> +/*
> + * Set up an endpoint with two ring segments
> + */
> +static int dbc_endpoint_init(struct xhci_hcd *xhci, int in, gfp_t mem_flags)
> +{
> +       struct xhci_virt_ep *ep;
> +       struct xhci_ep_ctx *ep_ctx;
> +       struct xhci_ring *ep_ring;
> +       u32 type, burst;
> +
> +       xhci_dbg(xhci, "%s()\n", __func__);
> +
> +       ep_ring = dbc_ring_alloc(xhci, 2, 1, TYPE_BULK, mem_flags);
> +       if (!ep_ring)
> +               return -ENOMEM;
> +
> +       if (in) {
> +               xhci_dbg(xhci, "IN\n");
> +               xhci->dbc_in_ring = ep_ring;
> +               ep = &xhci->dbc_in_ep;
> +               ep_ctx = &xhci->dbg_cap_ctx->in_ep_ctx;
> +               type = EP_TYPE(BULK_IN_EP);
> +       } else {
> +               xhci_dbg(xhci, "OUT\n");
> +               xhci->dbc_out_ring = ep_ring;
> +               ep = &xhci->dbc_out_ep;
> +               ep_ctx = &xhci->dbg_cap_ctx->out_ep_ctx;
> +               type = EP_TYPE(BULK_OUT_EP);
> +       }
> +
> +       xhci_dbg(xhci, "ring=%p first=%p TRBs=%p (%08llx)\n", ep_ring, ep_ring->first_seg,
> +               ep_ring->first_seg->trbs, (unsigned long long)ep_ring->first_seg->dma);
> +       ep->ring = ep_ring;
> +
> +       ep_ctx->deq = cpu_to_le64(ep_ring->first_seg->dma | ep_ring->cycle_state);
> +       ep_ctx->ep_info = 0;
> +       ep_ctx->ep_info2 = cpu_to_le32(type);
> +
> +       /* Set the max packet, max burst, and average TRB length */
> +       ep_ctx->ep_info2 |= cpu_to_le32(MAX_PACKET(1024));
> +       burst = xhci_readl(xhci, &xhci->dbg_cap_regs->dcctrl);
> +       if (burst == 0xffffffff) {
> +               xhci_err(xhci, "ERROR %s: DbC host controller died\n", __func__);
> +               dbc_ring_free(xhci, ep_ring);
> +               if (in)
> +                       xhci->dbc_in_ring = NULL;
> +               else
> +                       xhci->dbc_out_ring = NULL;
> +               return -ENODEV;
> +       }
> +       burst = DCCTRL_MAXBST(burst);
> +       ep_ctx->ep_info2 |= cpu_to_le32(MAX_BURST(burst));
> +       ep_ctx->tx_info = cpu_to_le32(AVG_TRB_LENGTH_FOR_EP(1024));
> +       wmb();
> +
> +       xhci_dbg(xhci, "%08x %08x %08x %08x %08x\n", le32_to_cpu(ep_ctx->ep_info),
> +               le32_to_cpu(ep_ctx->ep_info2), le32_to_cpu(*(__le32 *)&ep_ctx->deq),
> +               le32_to_cpu(*((__le32 *)&ep_ctx->deq  1)), le32_to_cpu(ep_ctx->tx_info));
> +       return 0;
> +}
> +
> +static void dbc_endpoint_deinit(struct xhci_hcd *xhci, int in)
> +{
> +       struct xhci_ring *ep_ring;
> +
> +       if (in) {
> +               ep_ring = xhci->dbc_in_ring;
> +               xhci->dbc_in_ring = NULL;
> +       } else {
> +               ep_ring = xhci->dbc_out_ring;
> +               xhci->dbc_out_ring = NULL;
> +       }
> +
> +       if (ep_ring)
> +               dbc_ring_free(xhci, ep_ring);
> +}
> +
> +static struct xhci_virt_ep *dbc_epidx_to_ep(struct xhci_hcd *xhci,
> +               unsigned int ep_index, struct xhci_ep_ctx **ep_ctx_ret)
> +{
> +       struct xhci_virt_ep *ep;
> +       struct xhci_ep_ctx *ep_ctx;
> +
> +       xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> +       switch (ep_index) {
> +       case 0:
> +               ep = &xhci->dbc_out_ep;
> +               ep_ctx = &xhci->dbg_cap_ctx->out_ep_ctx;
> +               break;
> +       case 1:
> +               ep = &xhci->dbc_in_ep;
> +               ep_ctx = &xhci->dbg_cap_ctx->in_ep_ctx;
> +               break;
> +       default:
> +               return NULL;
> +       }
> +
> +       if (ep_ctx_ret)
> +               *ep_ctx_ret = ep_ctx;
> +
> +       return ep;
> +}
> +
> +static void dbc_ring_ep_doorbell(struct xhci_hcd *xhci, unsigned int ep_index)
> +{
> +       u32 temp;
> +
> +       xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> +
> +       wmb();
> +       temp = xhci_readl(xhci, &xhci->dbg_cap_regs->dcdb);
> +       temp |= DCDB_WR_TARGET(ep_index ? 1 : 0);
> +       xhci_dbg(xhci, "writing %08x to doorbell\n", temp);
> +       xhci_writel(xhci, temp, &xhci->dbg_cap_regs->dcdb);
> +}
> +
> +/*
> + * Find the segment that trb is in. Start searching in start_seg.
> + * If we must move past a segment that has a link TRB with a toggle cycle state
> + * bit set, then we will toggle the value pointed at by cycle_state.
> + */
> +static struct xhci_segment *dbc_find_trb_seg(struct xhci_segment *start_seg,
> +               union xhci_trb *trb, int *cycle_state)
> +{
> +       struct xhci_segment *cur_seg = start_seg;
> +       struct xhci_generic_trb *generic_trb;
> +
> +       while (cur_seg->trbs > trb ||
> +                       &cur_seg->trbs[TRBS_PER_SEGMENT - 1] < trb) {
> +               generic_trb = &cur_seg->trbs[TRBS_PER_SEGMENT - 1].generic;
> +               if (generic_trb->field[3] & cpu_to_le32(LINK_TOGGLE))
> +                       *cycle_state ^= 0x1;
> +               cur_seg = cur_seg->next;
> +               if (cur_seg == start_seg)
> +                       /* Looped over the entire list. Oops! */
> +                       return NULL;
> +       }
> +       return cur_seg;
> +}
> +
> +/* Does this link TRB point to the first segment in a ring,
> + * or was the previous TRB the last TRB on the last segment in the ERST?
> + */
> +static bool dbc_last_trb_on_last_seg(struct xhci_hcd *xhci,
> +               struct xhci_ring *ring, struct xhci_segment *seg,
> +               union xhci_trb *trb)
> +{
> +       if (ring == xhci->dbc_event_ring)
> +               return (trb == &seg->trbs[TRBS_PER_SEGMENT]) &&
> +                       (seg->next == xhci->dbc_event_ring->first_seg);
> +       else
> +               return le32_to_cpu(trb->link.control) & LINK_TOGGLE;
> +}
> +
> +/* Is this TRB a link TRB or was the last TRB the last TRB in this event ring
> + * segment? I.e. would the updated event TRB pointer step off the end of the
> + * event seg?
> + */
> +static int dbc_last_trb(struct xhci_hcd *xhci, struct xhci_ring *ring,
> +               struct xhci_segment *seg, union xhci_trb *trb)
> +{
> +       if (ring == xhci->dbc_event_ring)
> +               return trb == &seg->trbs[TRBS_PER_SEGMENT];
> +       else
> +               return TRB_TYPE_LINK_LE32(trb->link.control);
> +}
> +
> +static int dbc_enqueue_is_link_trb(struct xhci_ring *ring)
> +{
> +       struct xhci_link_trb *link = &ring->enqueue->link;
> +
> +       return TRB_TYPE_LINK_LE32(link->control);
> +}
> +
> +/* Updates trb to point to the next TRB in the ring, and updates seg if the next
> + * TRB is in a new segment. This does not skip over link TRBs, and it does not
> + * affect the ring dequeue or enqueue pointers.
> + */
> +static void dbc_next_trb(struct xhci_hcd *xhci, struct xhci_ring *ring,
> +               struct xhci_segment **seg, union xhci_trb **trb)
> +{
> +       if (dbc_last_trb(xhci, ring, *seg, *trb)) {
> +               *seg = (*seg)->next;
> +               *trb = (*seg)->trbs;
> +       } else {
> +               (*trb);
> +       }
> +}
> +
> +/*
> + * See Cycle bit rules. SW is the consumer for the event ring only.
> + * Don't make a ring full of link TRBs. That would be dumb and this would loop.
> + */
> +static void dbc_inc_deq(struct xhci_hcd *xhci, struct xhci_ring *ring)
> +{
> +       union xhci_trb *next;
> +       unsigned long long addr;
> +
> +       xhci_dbg(xhci, "%s()\n", __func__);
> +
> +       ring->deq_updates;
> +
> +       /* If this is not event ring, there is one more usable TRB */
> +       if (ring->type != TYPE_EVENT &&
> +                       !dbc_last_trb(xhci, ring, ring->deq_seg, ring->dequeue)) {
> +               ring->num_trbs_free;
> +               xhci_dbg(xhci, "one less TRB\n");
> +       }
> +       next = (ring->dequeue);
> +
> +       /* Update the dequeue pointer further if that was a link TRB or we're at
> +        * the end of an event ring segment (which doesn't have link TRBS)
> +        */
> +       while (dbc_last_trb(xhci, ring, ring->deq_seg, next)) {
> +               if (ring->type == TYPE_EVENT && dbc_last_trb_on_last_seg(xhci,
> +                               ring, ring->deq_seg, next)) {
> +                       ring->cycle_state = (ring->cycle_state ? 0 : 1);
> +               }
> +               ring->deq_seg = ring->deq_seg->next;
> +               ring->dequeue = ring->deq_seg->trbs;
> +               next = ring->dequeue;
> +       }
> +       addr = (unsigned long long)xhci_trb_virt_to_dma(ring->deq_seg,
> +                                                       ring->dequeue);
> +}
> +
> +/*
> + * See Cycle bit rules. SW is the consumer for the event ring only.
> + * Don't make a ring full of link TRBs. That would be dumb and this would loop.
> + *
> + * If we've just enqueued a TRB that is in the middle of a TD (meaning the
> + * chain bit is set), then set the chain bit in all the following link TRBs.
> + * If we've enqueued the last TRB in a TD, make sure the following link TRBs
> + * have their chain bit cleared (so that each Link TRB is a separate TD).
> + *
> + * Section 6.4.4.1 of the 0.95 spec says link TRBs cannot have the chain bit
> + * set, but other sections talk about dealing with the chain bit set. This was
> + * fixed in the 0.96 specification errata, but we have to assume that all 0.95
> + * xHCI hardware can't handle the chain bit being cleared on a link TRB.
> + *
> + * @more_trbs_coming:  Will you enqueue more TRBs before calling
> + *                     prepare_transfer()?
> + */
> +static void dbc_inc_enq(struct xhci_hcd *xhci, struct xhci_ring *ring,
> +               bool more_trbs_coming)
> +{
> +       union xhci_trb *next;
> +       unsigned long long addr;
> +       u32 chain = le32_to_cpu(ring->enqueue->generic.field[3]) & TRB_CHAIN;
> +
> +       xhci_dbg(xhci, "%s()\n", __func__);
> +
> +       /* If this is not event ring, there is one less usable TRB */
> +       if (ring->type != TYPE_EVENT &&
> +                       !dbc_last_trb(xhci, ring, ring->enq_seg, ring->enqueue)) {
> +               ring->num_trbs_free--;
> +               xhci_dbg(xhci, "one less TRB\n");
> +       }
> +       next = (ring->enqueue);
> +
> +       ring->enq_updates;
> +       /* Update the dequeue pointer further if that was a link TRB or we're at
> +        * the end of an event ring segment (which doesn't have link TRBS)
> +        */
> +       while (dbc_last_trb(xhci, ring, ring->enq_seg, next)) {
> +               xhci_dbg(xhci, "last TRB\n");
> +               if (ring->type != TYPE_EVENT) {
> +                       xhci_dbg(xhci, "not event ring\n");
> +                       /*
> +                        * If the caller doesn't plan on enqueueing more
> +                        * TDs before ringing the doorbell, then we
> +                        * don't want to give the link TRB to the
> +                        * hardware just yet. We'll give the link TRB
> +                        * back in prepare_ring() just before we enqueue
> +                        * the TD at the top of the ring.
> +                        */
> +                       if (!chain && !more_trbs_coming) {
> +                               xhci_dbg(xhci, "no more TRBs\n");
> +                               break;
> +                       }
> +
> +                       /* If we're not dealing with 0.95 hardware,
> +                        * carry over the chain bit of the previous TRB
> +                        * (which may mean the chain bit is cleared).
> +                        */
> +                       if (!xhci_link_trb_quirk(xhci)) {
> +                               xhci_dbg(xhci, "not link quirk\n");
> +                               next->link.control &= cpu_to_le32(~TRB_CHAIN);
> +                               next->link.control |= cpu_to_le32(chain);
> +                       }
> +                       /* Give this link TRB to the hardware */
> +                       wmb();
> +                       next->link.control ^= cpu_to_le32(TRB_CYCLE);
> +
> +                       /* Toggle the cycle bit after the last ring segment */
> +                       if (dbc_last_trb_on_last_seg(xhci, ring, ring->enq_seg, next)) {
> +                               xhci_dbg(xhci, "last TRB on last seg\n");
> +                               ring->cycle_state = (ring->cycle_state ? 0 : 1);
> +                       }
> +               }
> +               ring->enq_seg = ring->enq_seg->next;
> +               ring->enqueue = ring->enq_seg->trbs;
> +               next = ring->enqueue;
> +       }
> +       addr = (unsigned long long)xhci_trb_virt_to_dma(ring->enq_seg, ring->enqueue);
> +}
> +
> +/*
> + * Check to see if there's room to enqueue num_trbs on the ring and make sure
> + * enqueue pointer will not advance into dequeue segment. See rules above.
> + */
> +static inline int dbc_room_on_ring(struct xhci_hcd *xhci,
> +               struct xhci_ring *ring, unsigned int num_trbs)
> +{
> +       int num_trbs_in_deq_seg;
> +
> +       if (ring->num_trbs_free < num_trbs)
> +               return 0;
> +
> +       if (ring->type != TYPE_COMMAND && ring->type != TYPE_EVENT) {
> +               num_trbs_in_deq_seg = ring->dequeue - ring->deq_seg->trbs;
> +               if (ring->num_trbs_free < num_trbs  num_trbs_in_deq_seg)
> +                       return 0;
> +       }
> +
> +       return 1;
> +}
> +
> +/*
> + * The TD size is the number of bytes remaining in the TD (including this TRB),
> + * right shifted by 10.
> + * It must fit in bits 21:17, so it can't be bigger than 31.
> + */
> +static u32 dbc_td_remainder(unsigned int remainder)
> +{
> +       u32 max = (1 << (21 - 17  1)) - 1;
> +
> +       if ((remainder >> 10) >= max)
> +               return max << 17;
> +       else
> +               return (remainder >> 10) << 17;
> +}
> +
> +/*
> + * For xHCI 1.0 host controllers, TD size is the number of packets remaining in
> + * the TD (*not* including this TRB)
> + *
> + * Total TD packet count = total_packet_count =
> + *     roundup(TD size in bytes / wMaxPacketSize)
> + *
> + * Packets transferred up to and including this TRB = packets_transferred =
> + *     rounddown(total bytes transferred including this TRB / wMaxPacketSize)
> + *
> + * TD size = total_packet_count - packets_transferred
> + *
> + * It must fit in bits 21:17, so it can't be bigger than 31
> + */
> +static u32 dbc_v1_0_td_remainder(int running_total, int trb_buff_len,
> +               unsigned int total_packet_count, struct urb *urb)
> +{
> +       int packets_transferred;
> +
> +       /* One TRB with a zero-length data packet */
> +       if (running_total == 0 && trb_buff_len == 0)
> +               return 0;
> +
> +       /* All the TRB queueing functions don't count the current TRB in
> +        * running_total.
> +        */
> +       packets_transferred = (running_total  trb_buff_len) / 1024;
> +
> +       return dbc_td_remainder(total_packet_count - packets_transferred);
> +}
> +
> +/*
> + * Generic function for queueing a TRB on a ring.
> + * The caller must have checked to make sure there's room on the ring.
> + *
> + * @more_trbs_coming:  Will you enqueue more TRBs before calling
> + *                     prepare_transfer()?
> + */
> +static void dbc_queue_trb(struct xhci_hcd *xhci, struct xhci_ring *ring,
> +               bool more_trbs_coming, u32 field1, u32 field2, u32 field3,
> +               u32 field4)
> +{
> +       struct xhci_generic_trb *trb = &ring->enqueue->generic;
> +
> +       xhci_dbg(xhci, "%s()\n", __func__);
> +       trb->field[0] = cpu_to_le32(field1);
> +       trb->field[1] = cpu_to_le32(field2);
> +       trb->field[2] = cpu_to_le32(field3);
> +       trb->field[3] = cpu_to_le32(field4);
> +       xhci_dbg(xhci, "0x%08x 0x%08x 0x%08x 0x%08x\n", le32_to_cpu(trb->field[0]),
> +                       le32_to_cpu(trb->field[1]), le32_to_cpu(trb->field[2]),
> +                       le32_to_cpu(trb->field[3]));
> +
> +       dbc_inc_enq(xhci, ring, more_trbs_coming);
> +}
> +
> +static void dbc_check_trb_math(struct xhci_hcd *xhci, struct urb *urb,
> +               unsigned int ep_index, int num_trbs, int running_total)
> +{
> +       xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> +
> +       if (num_trbs != 0)
> +               xhci_err(xhci, "%s - ep %#x - Miscalculated number of"
> +                               " TRBs, %d left\n", __func__,
> +                               ep_index ? 0x81 : 0x01, num_trbs);
> +       if (running_total != urb->transfer_buffer_length)
> +               xhci_err(xhci, "%s - ep %#x - Miscalculated tx length,"
> +                               " queued %#x (%d), asked for %#x (%d)\n",
> +                               __func__,
> +                               ep_index ? 0x81 : 0x01,
> +                               running_total, running_total,
> +                               urb->transfer_buffer_length,
> +                               urb->transfer_buffer_length);
> +}
> +
> +static void dbc_giveback_first_trb(struct xhci_hcd *xhci, unsigned int ep_index,
> +               int start_cycle, struct xhci_generic_trb *start_trb)
> +{
> +       xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> +       /*
> +        * Pass all the TRBs to the hardware at once and make sure this write
> +        * isn't reordered.
> +        */
> +       wmb();
> +       if (start_cycle) {
> +               xhci_dbg(xhci, "start cycle\n");
> +               start_trb->field[3] |= cpu_to_le32(start_cycle);
> +       } else {
> +               xhci_dbg(xhci, "not start cycle\n");
> +               start_trb->field[3] &= cpu_to_le32(~TRB_CYCLE);
> +       }
> +       xhci_dbg(xhci, "field[3] = 0x%08x\n", le32_to_cpu(start_trb->field[3]));
> +       wmb();
> +       dbc_ring_ep_doorbell(xhci, ep_index);
> +}
> +
> +/* This is very similar to what ehci-q.c qtd_fill() does */
> +static int dbc_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
> +               struct urb *urb, unsigned int ep_index)
> +{
> +       struct xhci_ring *ep_ring;
> +       struct urb_priv *urb_priv;
> +       struct xhci_td *td;
> +       struct xhci_generic_trb *start_trb;
> +       struct list_head *urb_list;
> +       int num_trbs;
> +       bool first_trb;
> +       bool more_trbs_coming;
> +       int start_cycle;
> +       u32 field, length_field;
> +       int running_total, trb_buff_len, tmp;
> +       unsigned int total_packet_count;
> +       u64 addr;
> +
> +       xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> +       xhci_dbg(xhci, "URB=%p\n", urb);
> +
> +       if (ep_index == 0) {
> +               ep_ring = xhci->dbc_out_ring;
> +               urb_list = &xhci->dbc_out_urb_list;
> +       } else {
> +               ep_ring = xhci->dbc_in_ring;
> +               urb_list = &xhci->dbc_in_urb_list;
> +       }
> +
> +       if (!ep_ring) {
> +               xhci_err(xhci, "ERROR: no EP ring\n");
> +               return -EINVAL;
> +       }
> +
> +       xhci_dbg(xhci, "ring=%p first=%p TRBs=%p (%08llx)\n", ep_ring, ep_ring->first_seg, ep_ring->first_seg->trbs, (unsigned long long)ep_ring->first_seg->dma);
> +
> +       num_trbs = 0;
> +       /* How much data is (potentially) left before the 64KB boundary? */
> +       running_total = TRB_MAX_BUFF_SIZE -
> +               (urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
> +       running_total &= TRB_MAX_BUFF_SIZE - 1;
> +       xhci_dbg(xhci, "runtot 1 = %d\n", running_total);
> +
> +       /* If there's some data on this 64KB chunk, or we have to send a
> +        * zero-length transfer, we need at least one TRB
> +        */
> +       if (running_total != 0 || urb->transfer_buffer_length == 0)
> +               num_trbs;
> +       /* How many more 64KB chunks to transfer, how many more TRBs? */
> +       while (running_total < urb->transfer_buffer_length) {
> +               num_trbs;
> +               running_total = TRB_MAX_BUFF_SIZE;
> +       }
> +       /* FIXME: this doesn't deal with URB_ZERO_PACKET - need one more */
> +       xhci_dbg(xhci, "runtot 2 = %d, trbs = %d\n", running_total, num_trbs);
> +
> +       if (!dbc_room_on_ring(xhci, ep_ring, num_trbs)) {
> +               xhci_err(xhci, "ERROR: no room on ring\n");
> +               return -ENOMEM;
> +       }
> +
> +       if (dbc_enqueue_is_link_trb(ep_ring)) {
> +               struct xhci_ring *ring = ep_ring;
> +               union xhci_trb *next;
> +
> +               xhci_dbg(xhci, "enqueue is link trb\n");
> +               next = ring->enqueue;
> +
> +               while (dbc_last_trb(xhci, ring, ring->enq_seg, next)) {
> +                       /* If we're not dealing with 0.95 hardware,
> +                        * clear the chain bit.
> +                        */
> +                       if (!xhci_link_trb_quirk(xhci))
> +                               next->link.control &= cpu_to_le32(~TRB_CHAIN);
> +                       else
> +                               next->link.control |= cpu_to_le32(TRB_CHAIN);
> +
> +                       wmb();
> +                       next->link.control ^= cpu_to_le32(TRB_CYCLE);
> +
> +                       /* Toggle the cycle bit after the last ring segment */
> +       if (dbc_last_trb_on_last_seg(xhci, ring, ring->enq_seg, next))
> +                               ring->cycle_state = (ring->cycle_state ? 0 : 1);
> +
> +                       ring->enq_seg = ring->enq_seg->next;
> +                       ring->enqueue = ring->enq_seg->trbs;
> +                       next = ring->enqueue;
> +               }
> +       }
> +
> +       urb_priv = urb->hcpriv;
> +       td = urb_priv->td[0];
> +       xhci_dbg(xhci, "TD=%p\n", td);
> +
> +       INIT_LIST_HEAD(&td->td_list);
> +       INIT_LIST_HEAD(&td->cancelled_td_list);
> +
> +       urb->unlinked = 0;
> +       list_add_tail(&urb->urb_list, urb_list);
> +
> +       td->urb = urb;
> +       /* Add this TD to the tail of the endpoint ring's TD list */
> +       list_add_tail(&td->td_list, &ep_ring->td_list);
> +       td->start_seg = ep_ring->enq_seg;
> +       xhci_dbg(xhci, "start_seg=%p\n", td->start_seg);
> +       td->first_trb = ep_ring->enqueue;
> +
> +       /*
> +        * Don't give the first TRB to the hardware (by toggling the cycle bit)
> +        * until we've finished creating all the other TRBs. The ring's cycle
> +        * state may change as we enqueue the other TRBs, so save it too.
> +        */
> +       start_trb = &ep_ring->enqueue->generic;
> +       xhci_dbg(xhci, "TRB=%p\n", start_trb);
> +       start_cycle = ep_ring->cycle_state;
> +       xhci_dbg(xhci, "cycle=%d\n", start_cycle);
> +
> +       running_total = 0;
> +       total_packet_count = roundup(urb->transfer_buffer_length, 1024);
> +
> +       /* How much data is in the first TRB? */
> +       addr = (u64)urb->transfer_dma;
> +       trb_buff_len = TRB_MAX_BUFF_SIZE -
> +               (urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
> +       if (trb_buff_len > urb->transfer_buffer_length)
> +               trb_buff_len = urb->transfer_buffer_length;
> +
> +       first_trb = true;
> +
> +       /* Queue the first TRB, even if it's zero-length */
> +       do {
> +               u32 remainder = 0;
> +
> +               field = 0;
> +
> +               /* Don't change the cycle bit of the first TRB until later */
> +               if (first_trb) {
> +                       first_trb = false;
> +                       if (start_cycle == 0)
> +                               field |= 0x1;
> +               } else
> +                       field |= ep_ring->cycle_state;
> +
> +               /* Chain all the TRBs together; clear the chain bit in the last
> +                * TRB to indicate it's the last TRB in the chain.
> +                */
> +               if (num_trbs > 1) {
> +                       field |= TRB_CHAIN;
> +               } else {
> +                       /* FIXME - add check for ZERO_PACKET flag before this */
> +                       td->last_trb = ep_ring->enqueue;
> +                       field |= TRB_IOC;
> +               }
> +
> +               field |= TRB_ISP;
> +
> +               /* Set the TRB length, TD size, and interrupter fields */
> +               if (xhci->hci_version < 0x100) {
> +                       xhci_dbg(xhci, "is not 1.0 host\n");
> +                       remainder = 0; /*dbc_td_remainder(
> +                                       urb->transfer_buffer_length -
> +                                       running_total);*/
> +               } else {
> +                       xhci_dbg(xhci, "is 1.0 host\n");
> +                       remainder = 0; /*dbc_v1_0_td_remainder(running_total,
> +                                       trb_buff_len, total_packet_count, urb);*/
> +               }
> +               if (ep_index)
> +                       tmp = trb_buff_len >= 1024 ? trb_buff_len : 1024;
> +               else
> +                       tmp = trb_buff_len;
> +               xhci_dbg(xhci, "TRB len = %d\n", tmp);
> +               length_field = TRB_LEN(tmp) | remainder |
> +                               TRB_INTR_TARGET(0);
> +
> +               if (num_trbs > 1)
> +                       more_trbs_coming = true;
> +               else
> +                       more_trbs_coming = false;
> +               dbc_queue_trb(xhci, ep_ring, more_trbs_coming,
> +                               lower_32_bits(addr),
> +                               upper_32_bits(addr),
> +                               length_field,
> +                               field | TRB_TYPE(TRB_NORMAL));
> +               --num_trbs;
> +               running_total = trb_buff_len;
> +
> +               /* Calculate length for next transfer */
> +               addr = trb_buff_len;
> +               trb_buff_len = urb->transfer_buffer_length - running_total;
> +               if (trb_buff_len > TRB_MAX_BUFF_SIZE)
> +                       trb_buff_len = TRB_MAX_BUFF_SIZE;
> +       } while (running_total < urb->transfer_buffer_length);
> +
> +       dbc_check_trb_math(xhci, urb, ep_index, num_trbs, running_total);
> +       dbc_giveback_first_trb(xhci, ep_index, start_cycle, start_trb);
> +/*     xhci_debug_segment(xhci, td->start_seg); */
> +       xhci_dbg(xhci, "first OUT segment:\n");
> +       xhci_debug_segment(xhci, xhci->dbc_out_ring->first_seg);
> +       xhci_dbg(xhci, "last OUT segment:\n");
> +       xhci_debug_segment(xhci, xhci->dbc_out_ring->last_seg);
> +       xhci_dbg(xhci, "first IN segment:\n");
> +       xhci_debug_segment(xhci, xhci->dbc_in_ring->first_seg);
> +       xhci_dbg(xhci, "last IN segment:\n");
> +       xhci_debug_segment(xhci, xhci->dbc_in_ring->last_seg);
> +       return 0;
> +}
> +
> +/*
> + * non-error returns are a promise to giveback() the urb later
> + * we drop ownership so next owner (or urb unlink) can get it
> + */
> +static int dbc_urb_enqueue(struct xhci_hcd *xhci, struct urb *urb,
> +               unsigned int ep_index, gfp_t mem_flags)
> +{
> +       struct xhci_td *buffer;
> +       struct urb_priv *urb_priv;
> +       int ret = 0;
> +
> +       xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> +       if (!urb)
> +               return -EINVAL;
> +
> +       urb_priv = kzalloc(sizeof(struct urb_priv)
> +                       sizeof(struct xhci_td *), mem_flags);
> +       if (!urb_priv)
> +               return -ENOMEM;
> +
> +       buffer = kzalloc(sizeof(struct xhci_td), mem_flags);
> +       if (!buffer) {
> +               kfree(urb_priv);
> +               return -ENOMEM;
> +       }
> +
> +       urb_priv->td[0] = buffer;
> +       urb_priv->length = 1;
> +       urb_priv->td_cnt = 0;
> +       urb->hcpriv = urb_priv;
> +
> +       if (xhci->xhc_state & XHCI_STATE_DYING)
> +               goto dying;
> +       ret = dbc_queue_bulk_tx(xhci, mem_flags, urb, ep_index);
> +       if (ret)
> +               goto free_priv;
> +
> +       return ret;
> +
> +dying:
> +       xhci_dbg(xhci, "ep %#x: URB %p submitted for non-responsive xHCI host.\n", ep_index ? 0x81 : 0x01, urb);
> +       ret = -ESHUTDOWN;
> +
> +free_priv:
> +       xhci_urb_free_priv(xhci, urb_priv);
> +       urb->hcpriv = NULL;
> +       return ret;
> +}
> +
> +/**
> + * dbc_hcd_giveback_urb - return URB from HCD to device driver
> + * @hcd: host controller returning the URB
> + * @urb: urb being returned to the USB device driver.
> + * @status: completion status code for the URB.
> + * Context: in_interrupt()
> + *
> + * This hands the URB from HCD to its USB device driver, using its
> + * completion function.  The HCD has freed all per-urb resources
> + * (and is done using urb->hcpriv).  It also released all HCD locks;
> + * the device driver won't cause problems if it frees, modifies,
> + * or resubmits this URB.
> + *
> + * If @urb was unlinked, the value of @status will be overridden by
> + * @urb->unlinked.  Erroneous short transfers are detected in case
> + * the HCD hasn't checked for them.
> + */
> +static void dbc_giveback_urb(struct xhci_hcd *xhci, struct urb *urb, int status)
> +{
> +       xhci_dbg(xhci, "%s()\n", __func__);
> +       urb->hcpriv = NULL;
> +
> +       if (unlikely(urb->unlinked))
> +               status = urb->unlinked;
> +       else if (unlikely((urb->transfer_flags & URB_SHORT_NOT_OK) &&
> +                       urb->actual_length < urb->transfer_buffer_length &&
> +                       !status))
> +               status = -EREMOTEIO;
> +
> +       /* pass ownership to the completion handler */
> +       urb->status = status;
> +       urb->complete(urb);
> +}
> +
> +/*
> + * Move the xHC's endpoint ring dequeue pointer past cur_td.
> + * Record the new state of the xHC's endpoint ring dequeue segment,
> + * dequeue pointer, and new consumer cycle state in state.
> + * Update our internal representation of the ring's dequeue pointer.
> + *
> + * We do this in three jumps:
> + *  - First we update our new ring state to be the same as when the xHC stopped.
> + *  - Then we traverse the ring to find the segment that contains
> + *    the last TRB in the TD. We toggle the xHC's new cycle state when we pass
> + *    any link TRBs with the toggle cycle bit set.
> + *  - Finally we move the dequeue state one TRB further, toggling the cycle bit
> + *    if we've moved it past a link TRB with the toggle cycle bit set.
> + *
> + * Some of the uses of xhci_generic_trb are grotty, but if they're done with
> + * correct __le32 accesses they should work fine. Only users of this are
> + * in here.
> + */
> +static void dbc_find_new_dequeue_state(struct xhci_hcd *xhci,
> +               unsigned int ep_index, struct xhci_td *cur_td,
> +               struct xhci_dequeue_state *state)
> +{
> +       dma_addr_t addr;
> +       struct xhci_ring *ep_ring;
> +       struct xhci_ep_ctx *ep_ctx;
> +       struct xhci_generic_trb *trb;
> +       struct xhci_virt_ep *ep;
> +
> +       xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> +
> +       ep = dbc_epidx_to_ep(xhci, ep_index, &ep_ctx);
> +       if (!ep) {
> +               WARN_ON(1);
> +               return;
> +       }
> +
> +       ep_ring = ep->ring;
> +       if (!ep_ring) {
> +               WARN_ON(1);
> +               return;
> +       }
> +
> +       state->new_cycle_state = 0;
> +       xhci_dbg(xhci, "Finding segment containing stopped TRB\n");
> +       state->new_deq_seg = dbc_find_trb_seg(cur_td->start_seg,
> +                       ep->stopped_trb, &state->new_cycle_state);
> +       if (!state->new_deq_seg) {
> +               WARN_ON(1);
> +               return;
> +       }
> +
> +       /* Dig out the cycle state saved by the xHC during the stop ep cmd */
> +       state->new_cycle_state = le64_to_cpu(ep_ctx->deq) & 0x1;
> +
> +       state->new_deq_ptr = cur_td->last_trb;
> +       xhci_dbg(xhci, "Finding segment containing last TRB in TD\n");
> +       state->new_deq_seg = dbc_find_trb_seg(state->new_deq_seg,
> +                       state->new_deq_ptr, &state->new_cycle_state);
> +       if (!state->new_deq_seg) {
> +               WARN_ON(1);
> +               return;
> +       }
> +
> +       trb = &state->new_deq_ptr->generic;
> +       if (TRB_TYPE_LINK_LE32(trb->field[3]) &&
> +                       (trb->field[3] & cpu_to_le32(LINK_TOGGLE)))
> +               state->new_cycle_state ^= 0x1;
> +       dbc_next_trb(xhci, ep_ring, &state->new_deq_seg, &state->new_deq_ptr);
> +
> +       /*
> +        * If there is only one segment in a ring, find_trb_seg()'s while loop
> +        * will not run, and it will return before it has a chance to see if it
> +        * needs to toggle the cycle bit. It can't tell if the stalled transfer
> +        * ended just before the link TRB on a one-segment ring, or if the TD
> +        * wrapped around the top of the ring, because it doesn't have the TD in
> +        * question. Look for the one-segment case where stalled TRB's address
> +        * is greater than the new dequeue pointer address.
> +        */
> +       if (ep_ring->first_seg == ep_ring->first_seg->next &&
> +                       state->new_deq_ptr < ep->stopped_trb)
> +               state->new_cycle_state ^= 0x1;
> +       xhci_dbg(xhci, "Cycle state = 0x%x\n", state->new_cycle_state);
> +
> +       /* Don't update the ring cycle state for the producer (us) */
> +       xhci_dbg(xhci, "New dequeue segment = %p (virtual)\n",
> +                       state->new_deq_seg);
> +       addr = xhci_trb_virt_to_dma(state->new_deq_seg, state->new_deq_ptr);
> +       xhci_dbg(xhci, "New dequeue pointer = 0x%llx (DMA)\n",
> +                       (unsigned long long)addr);
> +}
> +
> +static void dbc_set_new_dequeue_state(struct xhci_hcd *xhci,
> +               unsigned int ep_index, struct xhci_dequeue_state *deq_state)
> +{
> +       dma_addr_t addr;
> +       struct xhci_ep_ctx *ep_ctx;
> +       struct xhci_virt_ep *ep;
> +
> +       xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> +
> +       ep = dbc_epidx_to_ep(xhci, ep_index, &ep_ctx);
> +       if (!ep) {
> +               xhci_err(xhci, "ERROR %s: bad DbC endpoint index %d\n",
> +                               __func__, ep_index);
> +               return;
> +       }
> +
> +       addr = xhci_trb_virt_to_dma(deq_state->new_deq_seg,
> +                       deq_state->new_deq_ptr);
> +       if (addr == 0) {
> +               xhci_warn(xhci, "WARN %s: Cannot set TR Deq Ptr\n", __func__);
> +               return;
> +       }
> +
> +       xhci_dbg(xhci, "Set TR Deq Ptr, new deq seg = %p (%llx dma),"
> +                       " new deq ptr = %p (%llx dma), new cycle = %u\n",
> +                       deq_state->new_deq_seg,
> +                       (unsigned long long)deq_state->new_deq_seg->dma,
> +                       deq_state->new_deq_ptr,
> +                       (unsigned long long)xhci_trb_virt_to_dma(
> +                                       deq_state->new_deq_seg,
> +                                       deq_state->new_deq_ptr),
> +                       deq_state->new_cycle_state);
> +
> +       ep_ctx->deq = cpu_to_le64(addr);
> +       wmb();
> +}
> +
> +static void dbc_cleanup_stalled_ring(struct xhci_hcd *xhci,
> +               unsigned int ep_index)
> +{
> +       struct xhci_dequeue_state deq_state = { 0 };
> +       struct xhci_virt_ep *ep;
> +
> +       xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> +
> +       ep = dbc_epidx_to_ep(xhci, ep_index, NULL);
> +       if (!ep) {
> +               xhci_err(xhci, "ERROR %s: bad DbC endpoint index %d\n",
> +                               __func__, ep_index);
> +               return;
> +       }
> +
> +       /* We need to move the HW's dequeue pointer past this TD,
> +        * or it will attempt to resend it on the next doorbell ring.
> +        */
> +       dbc_find_new_dequeue_state(xhci, ep_index, ep->stopped_td, &deq_state);
> +
> +       xhci_dbg(xhci, "Setting new dequeue state\n");
> +       dbc_set_new_dequeue_state(xhci, ep_index, &deq_state);
> +}
> +
> +static void dbc_cleanup_halted_endpoint(struct xhci_hcd *xhci,
> +               unsigned int ep_index, struct xhci_td *td,
> +               union xhci_trb *event_trb)
> +{
> +       struct xhci_virt_ep *ep;
> +
> +       xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> +
> +       ep = dbc_epidx_to_ep(xhci, ep_index, NULL);
> +       if (!ep) {
> +               xhci_err(xhci, "ERROR %s: bad DbC endpoint index %d\n",
> +                               __func__, ep_index);
> +               return;
> +       }
> +
> +       ep->ep_state |= EP_HALTED;
> +       ep->stopped_td = td;
> +       ep->stopped_trb = event_trb;
> +
> +       dbc_cleanup_stalled_ring(xhci, ep_index);
> +
> +       ep->stopped_td = NULL;
> +       ep->stopped_trb = NULL;
> +
> +       dbc_ring_ep_doorbell(xhci, ep_index);
> +}
> +
> +/* Check if an error has halted the endpoint ring. The class driver will
> + * cleanup the halt for a non-default control endpoint if we indicate a stall.
> + * However, a babble and other errors also halt the endpoint ring, and the class
> + * driver won't clear the halt in that case, so we need to issue a Set Transfer
> + * Ring Dequeue Pointer command manually.
> + */
> +static int dbc_requires_manual_halt_cleanup(struct xhci_hcd *xhci,
> +               struct xhci_ep_ctx *ep_ctx, unsigned int trb_comp_code)
> +{
> +       /* TRB completion codes that may require a manual halt cleanup */
> +       if (trb_comp_code == COMP_TX_ERR ||
> +                       trb_comp_code == COMP_BABBLE ||
> +                       trb_comp_code == COMP_SPLIT_ERR)
> +               /* The 0.96 spec says a babbling control endpoint
> +                * is not halted. The 0.96 spec says it is. Some HW
> +                * claims to be 0.95 compliant, but it halts the control
> +                * endpoint anyway. Check if a babble halted the endpoint.
> +                */
> +               if ((ep_ctx->ep_info & cpu_to_le32(EP_STATE_MASK)) ==
> +                               cpu_to_le32(EP_STATE_HALTED))
> +                       return 1;
> +
> +       return 0;
> +}
> +
> +/*
> + * Finish the td processing, remove the td from td list;
> + * Return 1 if the urb can be given back.
> + */
> +static int dbc_finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
> +               union xhci_trb *event_trb, struct xhci_transfer_event *event,
> +               struct xhci_virt_ep *ep, struct xhci_ep_ctx *ep_ctx,
> +               int *status, bool skip)
> +{
> +       struct xhci_ring *ep_ring;
> +       unsigned int ep_index;
> +       struct urb *urb = NULL;
> +       struct urb_priv *urb_priv;
> +       u32 trb_comp_code;
> +       int ret = 0;
> +
> +       xhci_dbg(xhci, "%s()\n", __func__);
> +       ep_index = TRB_TO_EP_ID(le32_to_cpu(event->flags)) - 1;
> +       xhci_dbg(xhci, "ep_index=%d\n", ep_index);
> +       ep_ring = ep->ring;
> +       trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
> +
> +       if (skip)
> +               goto td_cleanup;
> +
> +       if (trb_comp_code == COMP_STOP_INVAL ||
> +                       trb_comp_code == COMP_STOP) {
> +               /* The Endpoint Stop Command completion will take care of any
> +                * stopped TDs. A stopped TD may be restarted, so don't update
> +                * the ring dequeue pointer or take this TD off any lists yet.
> +                */
> +               ep->stopped_td = td;
> +               ep->stopped_trb = event_trb;
> +               xhci_dbg(xhci, "INVAL/STOP, returning 0\n");
> +               return 0;
> +       } else {
> +               if (trb_comp_code == COMP_STALL) {
> +                       /* The transfer is completed from the driver's
> +                        * perspective, but we need to issue a set dequeue
> +                        * command for this stalled endpoint to move the dequeue
> +                        * pointer past the TD. We can't do that here because
> +                        * the halt condition must be cleared first. Let the
> +                        * USB class driver clear the stall later.
> +                        */
> +                       ep->stopped_td = td;
> +                       ep->stopped_trb = event_trb;
> +               } else if (dbc_requires_manual_halt_cleanup(xhci,
> +                                       ep_ctx, trb_comp_code)) {
> +                       /* Other types of errors halt the endpoint, but the
> +                        * class driver doesn't call usb_reset_endpoint() unless
> +                        * the error is -EPIPE. Clear the halted status in the
> +                        * xHCI hardware manually.
> +                        */
> +                       dbc_cleanup_halted_endpoint(xhci,
> +                                       ep_index, td, event_trb);
> +               } else {
> +                       /* Update ring dequeue pointer */
> +                       while (ep_ring->dequeue != td->last_trb)
> +                               dbc_inc_deq(xhci, ep_ring);
> +                       dbc_inc_deq(xhci, ep_ring);
> +               }
> +
> +td_cleanup:
> +               /* Clean up the endpoint's TD list */
> +               urb = td->urb;
> +               urb_priv = urb->hcpriv;
> +
> +               /* Do one last check of the actual transfer length.
> +                * If the host controller said we transferred more data than
> +                * the buffer length, urb->actual_length will be a very big
> +                * number (since it's unsigned). Play it safe and say we didn't
> +                * transfer anything.
> +                */
> +               if (urb->actual_length > urb->transfer_buffer_length) {
> +                       xhci_warn(xhci, "WARN: URB transfer length is wrong,"
> +                                       " xHC issue? req. len = %u,"
> +                                       " act. len = %u\n",
> +                                       urb->transfer_buffer_length,
> +                                       urb->actual_length);
> +                       urb->actual_length = 0;
> +                       if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
> +                               *status = -EREMOTEIO;
> +                       else
> +                               *status = 0;
> +               }
> +               list_del_init(&td->td_list);
> +               /* Was this TD slated to be cancelled but completed anyway? */
> +               if (!list_empty(&td->cancelled_td_list))
> +                       list_del_init(&td->cancelled_td_list);
> +
> +               urb_priv->td_cnt;
> +               /* Giveback the urb when all the tds are completed */
> +               if (urb_priv->td_cnt == urb_priv->length)
> +                       ret = 1;
> +       }
> +
> +       xhci_dbg(xhci, "returning %d\n", ret);
> +       return ret;
> +}
> +
> +/*
> + * Process bulk and interrupt tds, update urb status and actual_length
> + */
> +static int dbc_process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
> +               union xhci_trb *event_trb, struct xhci_transfer_event *event,
> +               struct xhci_virt_ep *ep, struct xhci_ep_ctx *ep_ctx, int *status)
> +{
> +       struct xhci_ring *ep_ring;
> +       union xhci_trb *cur_trb;
> +       struct xhci_segment *cur_seg;
> +       unsigned int ep_index;
> +       u32 trb_comp_code;
> +
> +       xhci_dbg(xhci, "%s()\n", __func__);
> +       ep_ring = ep->ring;
> +       trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
> +       xhci_dbg(xhci, "cmpl_code=%d\n", trb_comp_code);
> +
> +       switch (trb_comp_code) {
> +       case COMP_SUCCESS:
> +               /* Double check that the HW transferred everything */
> +               if (event_trb != td->last_trb ||
> +                               TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
> +                       xhci_warn(xhci, "WARN: successful completion on short TX\n");
> +                       if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
> +                               *status = -EREMOTEIO;
> +                       else
> +                               *status = 0;
> +                       if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
> +                               trb_comp_code = COMP_SHORT_TX;
> +               } else {
> +                       *status = 0;
> +               }
> +               break;
> +       case COMP_SHORT_TX:
> +               if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
> +                       *status = -EREMOTEIO;
> +               else
> +                       *status = 0;
> +               break;
> +       default:
> +               /* Others already handled above */
> +               break;
> +       }
> +
> +       ep_index = TRB_TO_EP_ID(le32_to_cpu(event->flags)) - 1;
> +       xhci_dbg(xhci, "ep_index=%d\n", ep_index);
> +
> +       if (trb_comp_code == COMP_SHORT_TX)
> +               xhci_dbg(xhci, "ep %#x - asked for %d bytes, %d bytes untransferred\n",
> +                               ep_index ? 0x81 : 0x01,
> +                               td->urb->transfer_buffer_length,
> +                               TRB_LEN(le32_to_cpu(event->transfer_len)));
> +       /* Fast path - was this the last TRB in the TD for this URB? */
> +       if (event_trb == td->last_trb) {
> +               if (TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
> +                       td->urb->actual_length =
> +                               td->urb->transfer_buffer_length -
> +                               TRB_LEN(le32_to_cpu(event->transfer_len));
> +                       if (td->urb->transfer_buffer_length <
> +                                       td->urb->actual_length) {
> +                               xhci_warn(xhci, "WARN: HC gave bad length of %d bytes left\n",
> +                                       TRB_LEN(le32_to_cpu(event->transfer_len)));
> +                               td->urb->actual_length = 0;
> +                               if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
> +                                       *status = -EREMOTEIO;
> +                               else
> +                                       *status = 0;
> +                       }
> +                       /* Don't overwrite a previously set error code */
> +                       if (*status == -EINPROGRESS) {
> +                               if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
> +                                       *status = -EREMOTEIO;
> +                               else
> +                                       *status = 0;
> +                       }
> +               } else {
> +                       td->urb->actual_length =
> +                               td->urb->transfer_buffer_length;
> +                       /* Ignore a short packet completion if the
> +                        * untransferred length was zero.
> +                        */
> +                       if (*status == -EREMOTEIO)
> +                               *status = 0;
> +               }
> +       } else {
> +               /* Slow path - walk the list, starting from the dequeue
> +                * pointer, to get the actual length transferred.
> +                */
> +               td->urb->actual_length = 0;
> +               for (cur_trb = ep_ring->dequeue, cur_seg = ep_ring->deq_seg;
> +                               cur_trb != event_trb;
> +                               dbc_next_trb(xhci, ep_ring, &cur_seg, &cur_trb)) {
> +                       if (!TRB_TYPE_NOOP_LE32(cur_trb->generic.field[3]) &&
> +                           !TRB_TYPE_LINK_LE32(cur_trb->generic.field[3]))
> +                               td->urb->actual_length =
> +                                       TRB_LEN(le32_to_cpu(cur_trb->generic.field[2]));
> +               }
> +               /* If the ring didn't stop on a Link or No-op TRB, add
> +                * in the actual bytes transferred from the Normal TRB
> +                */
> +               if (trb_comp_code != COMP_STOP_INVAL)
> +                       td->urb->actual_length =
> +                               TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
> +                               TRB_LEN(le32_to_cpu(event->transfer_len));
> +       }
> +
> +       return dbc_finish_td(xhci, td, event_trb, event, ep, ep_ctx, status,
> +                       false);
> +}
> +
> +/*
> + * If this function returns an error condition, it means it got a Transfer
> + * event with a corrupted Slot ID, Endpoint ID, or TRB DMA address.
> + * At this point, the host controller is probably hosed and should be reset.
> + */
> +static int dbc_handle_tx_event(struct xhci_hcd *xhci,
> +               struct xhci_transfer_event *event)
> +{
> +       struct xhci_virt_ep *ep;
> +       struct xhci_ep_ctx *ep_ctx;
> +       struct xhci_ring *ep_ring;
> +       struct urb *urb;
> +       struct urb_priv *urb_priv;
> +       struct xhci_td *td = NULL;
> +       dma_addr_t event_dma;
> +       struct xhci_segment *event_seg;
> +       union xhci_trb *event_trb;
> +       u32 trb_comp_code;
> +       unsigned int ep_index;
> +       int ret = 0;
> +       int status = -EINPROGRESS;
> +
> +       xhci_dbg(xhci, "%s()\n", __func__);
> +       ep_index = TRB_TO_EP_ID(le32_to_cpu(event->flags)) - 1;
> +       xhci_dbg(xhci, "ep_index=%d\n", ep_index);
> +
> +       ep = dbc_epidx_to_ep(xhci, ep_index, &ep_ctx);
> +       if (!ep) {
> +               xhci_err(xhci, "ERROR %s: bad DbC endpoint index %d\n",
> +                               __func__, ep_index);
> +               return -EINVAL;
> +       }
> +
> +       ep_ring = ep->ring;
> +
> +       if (!ep_ring || (le32_to_cpu(ep_ctx->ep_info) & EP_STATE_MASK) ==
> +                       EP_STATE_DISABLED) {
> +               xhci_err(xhci, "ERROR: DbC transfer event for disabled endpoint\n");
> +               xhci_err(xhci, "@%016llx %08x %08x %08x %08x\n",
> +                               (unsigned long long)xhci_trb_virt_to_dma(
> +                                       xhci->dbc_event_ring->deq_seg,
> +                                       xhci->dbc_event_ring->dequeue),
> +                               lower_32_bits(le64_to_cpu(event->buffer)),
> +                               upper_32_bits(le64_to_cpu(event->buffer)),
> +                               le32_to_cpu(event->transfer_len),
> +                               le32_to_cpu(event->flags));
> +               xhci_dbg(xhci, "DbC event ring:\n");
> +               xhci_debug_segment(xhci, xhci->dbc_event_ring->deq_seg);
> +               return -ENODEV;
> +       }
> +
> +       event_dma = le64_to_cpu(event->buffer);
> +       trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
> +       xhci_dbg(xhci, "cmpl_code=%d\n", trb_comp_code);
> +
> +       /* Look for common error cases */
> +       switch (trb_comp_code) {
> +       /* Skip codes that require special handling depending on
> +        * transfer type
> +        */
> +       case COMP_SUCCESS:
> +               if (TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
> +                       break;
> +               if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
> +                       trb_comp_code = COMP_SHORT_TX;
> +               else
> +                       xhci_warn(xhci, "WARN: successful DbC completion on short TX:"
> +                                       " needs XHCI_TRUST_TX_LENGTH quirk?\n");
> +       case COMP_DB_ERR:
> +               xhci_warn(xhci, "WARN: DbC HC couldn't access mem fast enough\n");
> +               status = -ENOSR;
> +               break;
> +       case COMP_BABBLE:
> +               xhci_dbg(xhci, "DbC babble error on endpoint\n");
> +               status = -EOVERFLOW;
> +               break;
> +       case COMP_TX_ERR:
> +               xhci_dbg(xhci, "DbC transfer error on endpoint\n");
> +               status = -EPROTO;
> +               break;
> +       case COMP_TRB_ERR:
> +               xhci_warn(xhci, "WARN: DbC TRB error on endpoint\n");
> +               status = -EILSEQ;
> +               break;
> +       case COMP_SHORT_TX:
> +               break;
> +       case COMP_ER_FULL:
> +               xhci_dbg(xhci, "DbC event ring full error\n");
> +               status = -EOVERFLOW;
> +               break;
> +       case COMP_STOP:
> +               xhci_dbg(xhci, "DbC stopped on Transfer TRB\n");
> +               break;
> +       case COMP_STOP_INVAL:
> +               xhci_dbg(xhci, "DbC stopped on No-op or Link TRB\n");
> +               break;
> +       default:
> +               xhci_warn(xhci, "WARN: unknown event condition, DbC HC probably busted\n");
> +               goto cleanup;
> +       }
> +
> +       /* This TRB should be in the TD at the head of this ring's TD list */
> +       if (list_empty(&ep_ring->td_list)) {
> +               xhci_warn(xhci, "WARN: DbC event TRB for slot %d ep %d"
> +                       " with no TDs queued?\n",
> +                       TRB_TO_SLOT_ID(le32_to_cpu(event->flags)), ep_index);
> +               xhci_dbg(xhci, "DbC event TRB with TRB type ID %u\n", (le32_to_cpu(event->flags) & TRB_TYPE_BITMASK) >> 10);
> +               xhci_print_trb_offsets(xhci, (union xhci_trb *)event);
> +               ret = 0;
> +               goto cleanup;
> +       }
> +
> +       td = list_entry(ep_ring->td_list.next, struct xhci_td, td_list);
> +
> +       /* Is this a TRB in the currently executing TD? */
> +       event_seg = trb_in_td(ep_ring->deq_seg, ep_ring->dequeue,
> +                       td->last_trb, event_dma);
> +
> +       /*
> +        * Skip the Force Stopped Event. The event_trb(event_dma) of FSE
> +        * is not in the current TD pointed by ep_ring->dequeue because
> +        * that the hardware dequeue pointer still at the previous TRB
> +        * of the current TD. The previous TRB maybe a Link TD or the
> +        * last TRB of the previous TD. The command completion handle
> +        * will take care the rest.
> +        */
> +       if (!event_seg && trb_comp_code == COMP_STOP_INVAL) {
> +               xhci_dbg(xhci, "Skipping DbC force stopped event\n");
> +               ret = 0;
> +               goto cleanup;
> +       }
> +
> +       if (!event_seg) {
> +               /* Some host controllers give a spurious
> +                * successful event after a short transfer.
> +                * Ignore it.
> +                */
> +               if ((xhci->quirks & XHCI_SPURIOUS_SUCCESS) &&
> +                               ep_ring->last_td_was_short) {
> +                       ep_ring->last_td_was_short = false;
> +                       ret = 0;
> +                       goto cleanup;
> +               }
> +               /* HC is busted, give up! */
> +               xhci_err(xhci,
> +                       "ERROR: DbC transfer event TRB DMA ptr not"
> +                       " part of current TD\n");
> +               return -ESHUTDOWN;
> +       }
> +
> +       if (trb_comp_code == COMP_SHORT_TX)
> +               ep_ring->last_td_was_short = true;
> +       else
> +               ep_ring->last_td_was_short = false;
> +
> +       event_trb = &event_seg->trbs[(event_dma - event_seg->dma) /
> +                                       sizeof(*event_trb)];
> +       /*
> +        * No-op TRB should not trigger interrupts.
> +        * If event_trb is a no-op TRB, it means the corresponding
> +        * TD has been cancelled. Just ignore the TD.
> +        */
> +       if (TRB_TYPE_NOOP_LE32(event_trb->generic.field[3])) {
> +               xhci_dbg(xhci, "DbC event_trb is a no-op TRB. Skip it.\n");
> +               goto cleanup;
> +       }
> +
> +       /* Now update the urb's actual_length and give back to the core */
> +       ret = dbc_process_bulk_intr_td(xhci, td, event_trb, event, ep, ep_ctx,
> +                       &status);
> +       xhci_dbg(xhci, "dbc_process_bulk_intr_td() returned %d\n", ret);
> +
> +cleanup:
> +       dbc_inc_deq(xhci, xhci->dbc_event_ring);
> +
> +       if (ret) {
> +               urb = td->urb;
> +               urb_priv = urb->hcpriv;
> +               /* Leave the TD around for the reset endpoint function
> +                * to use (but only if it's not a control endpoint,
> +                * since we already queued the Set TR dequeue pointer
> +                * command for stalled control endpoints)
> +                */
> +               if (trb_comp_code != COMP_STALL && trb_comp_code != COMP_BABBLE)
> +                       xhci_urb_free_priv(xhci, urb_priv);
> +
> +               list_del_init(&urb->urb_list);
> +               if ((urb->actual_length != urb->transfer_buffer_length &&
> +                    (urb->transfer_flags & URB_SHORT_NOT_OK)) || status != 0)
> +                       xhci_dbg(xhci, "DbC giveback URB %p, len = %d,"
> +                                       " expected = %d, status = %d\n",
> +                                       urb, urb->actual_length,
> +                                       urb->transfer_buffer_length,
> +                                       status);
> +               spin_unlock(&xhci->lock);
> +               dbc_giveback_urb(xhci, urb, status);
> +               spin_lock(&xhci->lock);
> +       }
> +
> +       return 0;
> +}
> +
> +static void dbc_handle_port_status(struct xhci_hcd *xhci,
> +               union xhci_trb *event)
> +{
> +       u32 port_id, temp;
> +
> +       /* Port status change events always have a successful completion code */
> +       if (GET_COMP_CODE(le32_to_cpu(event->generic.field[2])) != COMP_SUCCESS) {
> +               xhci_warn(xhci, "WARN: DbC xHC returned failed port status event\n");
> +               xhci->dbc_error_bitmask |= 1 << 8;
> +       }
> +
> +       port_id = GET_PORT_ID(le32_to_cpu(event->generic.field[0]));
> +       xhci_dbg(xhci, "DbC Port Status Change Event for port %d\n", port_id);
> +
> +       if (port_id != 0) {
> +               xhci_warn(xhci, "WARN: invalid DbC port id %d\n", port_id);
> +               goto cleanup;
> +       }
> +
> +       temp = xhci_readl(xhci, &xhci->dbg_cap_regs->dcportsc);
> +       if (temp == 0xffffffff) {
> +               xhci_err(xhci, "ERROR %s: DbC host controller died\n", __func__);
> +               return;
> +       }
> +
> +       xhci_dbg(xhci, "DCPORTSC %08x\n", temp);
> +       xhci_writel(xhci, temp, &xhci->dbg_cap_regs->dcportsc);
> +
> +       if (DCPORTSC_CSC(temp)) {
> +               dbc_incr = 2;
> +
> +               if (DCPORTSC_CCS(temp))
> +                       xhci_info(xhci, "DbC CONNECT detected\n");
> +               else
> +                       xhci_info(xhci, "DbC DISCONNECT detected\n");
> +       }
> +
> +cleanup:
> +       /* Update event ring dequeue pointer */
> +       dbc_inc_deq(xhci, xhci->dbc_event_ring);
> +}
> +
> +static void dbc_handle_vendor_event(struct xhci_hcd *xhci,
> +               union xhci_trb *event)
> +{
> +       u32 trb_type = TRB_FIELD_TO_TYPE(le32_to_cpu(event->generic.field[3]));
> +
> +       xhci_dbg(xhci, "Vendor specific event TRB type = %u\n", trb_type);
> +}
> +
> +/*
> + * This function handles all OS-owned events on the event ring. It may drop
> + * xhci->lock between event processing (e.g. to pass up port status changes).
> + * Returns >0 for "possibly more events to process" (caller should call again),
> + * otherwise 0 if done. In future, <0 returns should indicate error code.
> + */
> +static int dbc_handle_event(struct xhci_hcd *xhci)
> +{
> +       union xhci_trb *event;
> +       int update_ptrs = 1;
> +       int ret;
> +
> +       if (!xhci->dbc_event_ring || !xhci->dbc_event_ring->dequeue) {
> +               xhci->dbc_error_bitmask |= 1 << 1;
> +               return 0;
> +       }
> +
> +       event = xhci->dbc_event_ring->dequeue;
> +       /* Does the HC or OS own the TRB? */
> +       if ((le32_to_cpu(event->event_cmd.flags) & TRB_CYCLE) !=
> +                       xhci->dbc_event_ring->cycle_state) {
> +               xhci->dbc_error_bitmask |= 1 << 2;
> +               return 0;
> +       }
> +
> +       /*
> +        * Barrier between reading the TRB_CYCLE (valid) flag above and any
> +        * speculative reads of the event's flags/data below
> +        */
> +       rmb();
> +
> +       /* FIXME: Handle more event types */
> +       switch (le32_to_cpu(event->event_cmd.flags) & TRB_TYPE_BITMASK) {
> +       case TRB_TYPE(TRB_TRANSFER):
> +               xhci_dbg(xhci, "DbC xfer event\n");
> +               ret = dbc_handle_tx_event(xhci, &event->trans_event);
> +               if (ret < 0)
> +                       xhci->dbc_error_bitmask |= 1 << 9;
> +               else
> +                       update_ptrs = 0;
> +               break;
> +       case TRB_TYPE(TRB_PORT_STATUS):
> +               xhci_dbg(xhci, "DbC port status event\n");
> +               dbc_handle_port_status(xhci, event);
> +               update_ptrs = 0;
> +               break;
> +       default:
> +               xhci_dbg(xhci, "DbC unknown event\n");
> +               if ((le32_to_cpu(event->event_cmd.flags) & TRB_TYPE_BITMASK) >=
> +                               TRB_TYPE(48))
> +                       dbc_handle_vendor_event(xhci, event);
> +               else
> +                       xhci->dbc_error_bitmask |= 1 << 3;
> +       }
> +
> +       /* Any of the above functions may drop and re-acquire the lock, so check
> +        * to make sure a watchdog timer didn't mark the host as non-responsive
> +        */
> +       if (xhci->xhc_state & XHCI_STATE_DYING) {
> +               xhci_dbg(xhci, "xHCI host dying, returning from"
> +                               " event handler\n");
> +               return 0;
> +       }
> +
> +       if (update_ptrs)
> +               /* Update SW event ring dequeue pointer */
> +               dbc_inc_deq(xhci, xhci->dbc_event_ring);
> +
> +       /* Are there more items on the event ring?  Caller will call us again to
> +        * check.
> +        */
> +       return 1;
> +}
> +
> +static void dbc_complete(struct urb *urb)
> +{
> +       struct xhci_hcd *xhci = urb->context;
> +
> +       if (urb->status != 0)
> +               xhci_err(xhci, "ERROR: DbC ep %#x completion status %d\n",
> +                               urb->pipe, urb->status);
> +#ifdef DBC_SRC_SINK
> +       /* If OUT EP */
> +       if (urb->pipe == 0x01) {
> +               xhci_dbg(xhci, "DbC got completion for OUT ep, requeuing\n");
> +
> +               /* Requeue URB on the OUT EP */
> +               urb->transfer_buffer_length = 65536;
> +               urb->actual_length = 0;
> +               urb->pipe = 0x01;
> +               urb->status = -EINPROGRESS;
> +               if (dbc_urb_enqueue(xhci, urb, 1, GFP_ATOMIC))
> +                       xhci_err(xhci, "ERROR: DbC failed to queue OUT xfer\n");
> +       } else {
> +               xhci_dbg(xhci, "DbC got completion for IN ep, requeuing\n");
> +               dbc_incr;
> +               if (dbc_incr > 65535)
> +                       dbc_incr = 0;
> +               if ((dbc_incr & 1023) == 0)
> +                       dbc_incr;
> +               /* Requeue URB on the IN EP */
> +               urb->transfer_buffer_length = dbc_incr;
> +               urb->actual_length = 0;
> +               urb->pipe = 0x81;
> +               urb->status = -EINPROGRESS;
> +               if (dbc_urb_enqueue(xhci, urb, 0, GFP_ATOMIC))
> +                       xhci_err(xhci, "ERROR: DbC failed to queue IN xfer\n");
> +       }
> +#else
> +       /* If OUT EP */
> +       if (urb->pipe == 0x01) {
> +               xhci_dbg(xhci, "DbC got completion for OUT ep,"
> +                               " requeuing on IN\n");
> +
> +               /* Handle 0-length marker packet */
> +               if (urb->actual_length && (urb->actual_length & 1023) == 0) {
> +                       xhci_dbg(xhci, "DbC received 0-length packet\n");
> +                       xhci->dbc_next_0 = 1;
> +               }
> +
> +               /* Requeue URB on the IN EP */
> +               urb->transfer_buffer_length = urb->actual_length;
> +               urb->actual_length = 0;
> +               urb->pipe = 0x81;
> +               urb->status = -EINPROGRESS;
> +               if (dbc_urb_enqueue(xhci, urb, 0, GFP_ATOMIC)) {
> +                       xhci->dbc_next_0 = 0;
> +                       xhci_err(xhci, "ERROR: DbC failed to queue IN xfer,"
> +                                       " requeuing on OUT\n");
> +               } else {
> +                       return;
> +               }
> +       } else {
> +               xhci_dbg(xhci, "DbC got completion for IN ep, requeuing on OUT\n");
> +       }
> +
> +       /* Handle 0-length marker packet */
> +       if (xhci->dbc_next_0) {
> +               xhci_dbg(xhci, "DbC sending 0-length packet\n");
> +               xhci->dbc_next_0 = 0;
> +               urb->transfer_buffer_length = 0;
> +               urb->actual_length = 0;
> +               urb->pipe = 0x81;
> +               urb->status = -EINPROGRESS;
> +               if (dbc_urb_enqueue(xhci, urb, 0, GFP_ATOMIC))
> +                       xhci_err(xhci, "ERROR: DbC failed to queue IN 0-length xfer, requeuing on OUT\n");
> +               else
> +                       return;
> +       }
> +
> +       /* Requeue URB on the OUT EP */
> +       urb->transfer_buffer_length = 65536;
> +       urb->actual_length = 0;
> +       urb->pipe = 0x01;
> +       urb->status = -EINPROGRESS;
> +       if (dbc_urb_enqueue(xhci, urb, 1, GFP_ATOMIC))
> +               xhci_err(xhci, "ERROR: DbC failed to queue OUT xfer\n");
> +#endif
> +}
> +
> +static int dbc_poll_events(void *data)
> +{
> +       struct xhci_hcd *xhci = data;
> +       u32 status;
> +       union xhci_trb *trb;
> +       u64 temp_64;
> +       union xhci_trb *event_ring_deq;
> +       dma_addr_t deq;
> +       unsigned long flags;
> +       int count = 0;
> +       int dead = 0;
> +       int ret = -ENOMEM;
> +
> +       /* Allow the thread to be killed by a signal, but set the signal mask
> +        * to block everything but INT, TERM, KILL, and USR1
> +        */
> +       allow_signal(SIGINT);
> +       allow_signal(SIGTERM);
> +       allow_signal(SIGKILL);
> +       allow_signal(SIGUSR1);
> +
> +       /* Allow the thread to be frozen */
> +       set_freezable();
> +
> +       xhci->dbc_configured = 0;
> +       xhci->dbc_next_0 = 0;
> +
> +       xhci->dbc_buf_0 = dma_alloc_coherent(NULL, 65536,
> +                       &xhci->dbc_buf_0_dma, GFP_KERNEL);
> +       if (!xhci->dbc_buf_0)
> +               goto fail1;
> +       xhci->dbc_buf_1 = dma_alloc_coherent(NULL, 65536,
> +                       &xhci->dbc_buf_1_dma, GFP_KERNEL);
> +       if (!xhci->dbc_buf_1)
> +               goto fail2;
> +       xhci->dbc_buf_2 = dma_alloc_coherent(NULL, 65536,
> +                       &xhci->dbc_buf_2_dma, GFP_KERNEL);
> +       if (!xhci->dbc_buf_2)
> +               goto fail3;
> +       xhci->dbc_buf_3 = dma_alloc_coherent(NULL, 65536,
> +                       &xhci->dbc_buf_3_dma, GFP_KERNEL);
> +       if (!xhci->dbc_buf_3)
> +               goto fail4;
> +
> +       xhci->dbc_urb_0.transfer_buffer = xhci->dbc_buf_0;
> +       xhci->dbc_urb_0.transfer_dma = xhci->dbc_buf_0_dma;
> +       xhci->dbc_urb_0.transfer_buffer_length = 65536;
> +       xhci->dbc_urb_0.pipe = 0x01;
> +       xhci->dbc_urb_0.transfer_flags = 0;
> +       xhci->dbc_urb_0.actual_length = 0;
> +       xhci->dbc_urb_0.status = -EINPROGRESS;
> +       xhci->dbc_urb_0.complete = dbc_complete;
> +       xhci->dbc_urb_0.context = data;
> +
> +       xhci->dbc_urb_1.transfer_buffer = xhci->dbc_buf_1;
> +       xhci->dbc_urb_1.transfer_dma = xhci->dbc_buf_1_dma;
> +       xhci->dbc_urb_1.transfer_buffer_length = 65536;
> +       xhci->dbc_urb_1.pipe = 0x01;
> +       xhci->dbc_urb_1.transfer_flags = 0;
> +       xhci->dbc_urb_1.actual_length = 0;
> +       xhci->dbc_urb_1.status = -EINPROGRESS;
> +       xhci->dbc_urb_1.complete = dbc_complete;
> +       xhci->dbc_urb_1.context = data;
> +
> +       xhci->dbc_urb_2.transfer_buffer = xhci->dbc_buf_2;
> +       xhci->dbc_urb_2.transfer_dma = xhci->dbc_buf_2_dma;
> +#ifdef DBC_SRC_SINK
> +       xhci->dbc_buf_2[0] = 0;
> +       xhci->dbc_urb_2.transfer_buffer_length = 1;
> +       xhci->dbc_urb_2.pipe = 0x81;
> +#else
> +       xhci->dbc_urb_2.transfer_buffer_length = 65536;
> +       xhci->dbc_urb_2.pipe = 0x01;
> +#endif
> +       xhci->dbc_urb_2.transfer_flags = 0;
> +       xhci->dbc_urb_2.actual_length = 0;
> +       xhci->dbc_urb_2.status = -EINPROGRESS;
> +       xhci->dbc_urb_2.complete = dbc_complete;
> +       xhci->dbc_urb_2.context = data;
> +
> +       xhci->dbc_urb_3.transfer_buffer = xhci->dbc_buf_3;
> +       xhci->dbc_urb_3.transfer_dma = xhci->dbc_buf_3_dma;
> +#ifdef DBC_SRC_SINK
> +       xhci->dbc_buf_3[0] = 0;
> +       xhci->dbc_buf_3[1] = 1;
> +       xhci->dbc_urb_3.transfer_buffer_length = 2;
> +       xhci->dbc_urb_3.pipe = 0x81;
> +#else
> +       xhci->dbc_urb_3.transfer_buffer_length = 65536;
> +       xhci->dbc_urb_3.pipe = 0x01;
> +#endif
> +       xhci->dbc_urb_3.transfer_flags = 0;
> +       xhci->dbc_urb_3.actual_length = 0;
> +       xhci->dbc_urb_3.status = -EINPROGRESS;
> +       xhci->dbc_urb_3.complete = dbc_complete;
> +       xhci->dbc_urb_3.context = data;
> +
> +       dbc_incr = 0;
> +
> +       while (1) {
> +               spin_lock_irqsave(&xhci->lock, flags);
> +               if (dead)
> +                       goto cont;
> +               trb = xhci->dbc_event_ring->dequeue;
> +               status = xhci_readl(xhci, &xhci->dbg_cap_regs->dcst);
> +               if (status == 0xffffffff) {
> +                       xhci_err(xhci, "ERROR %s 1: DbC host controller died\n",
> +                               __func__);
> +                       ret = -ENODEV;
> +                       dead = 1;
> +                       goto cont;
> +               }
> +               if (!DCST_ER(status))
> +                       goto cont2;
> +
> +               event_ring_deq = xhci->dbc_event_ring->dequeue;
> +               /* FIXME this should be a delayed service routine
> +                * that clears the EHB
> +                */
> +       while (dbc_handle_event(xhci) > 1) {
> +               }
> +
> +               temp_64 = xhci_read_64(xhci, &xhci->dbg_cap_regs->dcerdp);
> +               if (temp_64 == 0xffffffffffffffffUL) {
> +                       xhci_err(xhci, "ERROR %s 2: DbC host controller died\n",
> +                               __func__);
> +                       ret = -ENODEV;
> +                       dead = 1;
> +                       goto cont;
> +               }
> +
> +               /* If necessary, update the HW's version of the event ring deq ptr */
> +               if (event_ring_deq != xhci->dbc_event_ring->dequeue) {
> +                       deq = xhci_trb_virt_to_dma(xhci->dbc_event_ring->deq_seg,
> +                                               xhci->dbc_event_ring->dequeue);
> +                       if (deq == 0)
> +                               xhci_warn(xhci, "WARN: something wrong with DbC SW event ring dequeue ptr\n");
> +                       /* Update HC event ring dequeue pointer */
> +                       temp_64 &= ERST_PTR_MASK;
> +                       temp_64 |= (u64)deq & ~(u64)ERST_PTR_MASK;
> +               }
> +
> +               xhci_write_64(xhci, temp_64, &xhci->dbg_cap_regs->dcerdp);
> +
> +               if (count > 5000) {
> +                       count = 0;
> +                       status = xhci_readl(xhci, &xhci->dbg_cap_regs->dcctrl);
> +                       xhci_dbg(xhci, "DCCTRL=0x%08x\n", status);
> +               }
> +cont2:
> +               if (!xhci->dbc_configured) {
> +                       status = xhci_readl(xhci, &xhci->dbg_cap_regs->dcctrl);
> +                       if (DCCTRL_DCR(status)) {
> +                               xhci->dbc_configured = 1;
> +                               xhci_dbg(xhci, "DbC configured, starting xfers\n");
> +
> +                               if (dbc_urb_enqueue(xhci, &xhci->dbc_urb_0,
> +                                                       1, GFP_ATOMIC)) {
> +                                       xhci_err(xhci, "ERROR: DbC failed to queue 1st OUT xfer\n");
> +                                       ret = -EPROTO;
> +                                       dead = 1;
> +                                       goto cont;
> +                               }
> +                               if (dbc_urb_enqueue(xhci, &xhci->dbc_urb_1,
> +                                                       1, GFP_ATOMIC)) {
> +                                       xhci_err(xhci, "ERROR: DbC failed to queue 2nd OUT xfer\n");
> +                                       ret = -EPROTO;
> +                                       dead = 1;
> +                                       goto cont;
> +                               }
> +                               if (dbc_urb_enqueue(xhci, &xhci->dbc_urb_2,
> +#ifdef DBC_SRC_SINK
> +                                                       0,
> +#else
> +                                                       1,
> +#endif
> +                                                       GFP_ATOMIC)) {
> +                                       xhci_err(xhci, "ERROR: DbC failed to"
> +#ifdef DBC_SRC_SINK
> +                                                       " queue 1st IN xfer\n"
> +#else
> +                                                       " queue 3rd OUT xfer\n"
> +#endif
> +                                               );
> +                                       ret = -EPROTO;
> +                                       dead = 1;
> +                                       goto cont;
> +                               }
> +                               if (dbc_urb_enqueue(xhci, &xhci->dbc_urb_3,
> +#ifdef DBC_SRC_SINK
> +                                                       0,
> +#else
> +                                                       1,
> +#endif
> +                                                       GFP_ATOMIC)) {
> +                                       xhci_err(xhci, "ERROR: DbC failed to"
> +#ifdef DBC_SRC_SINK
> +                                                       " queue 2nd IN xfer\n"
> +#else
> +                                                       " queue 4th OUT xfer\n"
> +#endif
> +                                               );
> +                                       ret = -EPROTO;
> +                                       dead = 1;
> +                                       goto cont;
> +                               }
> +                       }
> +               }
> +cont:
> +               spin_unlock_irqrestore(&xhci->lock, flags);
> +               if (kthread_should_stop())
> +                       break;
> +               msleep(1);
> +       }
> +
> +       dma_free_coherent(NULL, 65536, xhci->dbc_buf_3, xhci->dbc_buf_3_dma);
> +fail4:
> +       dma_free_coherent(NULL, 65536, xhci->dbc_buf_2, xhci->dbc_buf_2_dma);
> +fail3:
> +       dma_free_coherent(NULL, 65536, xhci->dbc_buf_1, xhci->dbc_buf_1_dma);
> +fail2:
> +       dma_free_coherent(NULL, 65536, xhci->dbc_buf_0, xhci->dbc_buf_0_dma);
> +fail1:
> +       return ret;
> +}
> +
> +/*
> + * De-initialize the Debug Capability
> + */
> +void xhci_teardown_dbg_cap(struct xhci_hcd *xhci, struct device *dev)
> +{
> +       u32 val;
> +
> +       xhci_dbg(xhci, "xhci_teardown_dbg_cap()\n");
> +       if (!xhci->dbg_cap_regs)
> +               return;
> +
> +       /* Kill the kernel thread */
> +       if (xhci->dbc_thread) {
> +               kthread_stop(xhci->dbc_thread);
> +               xhci->dbc_thread = NULL;
> +       }
> +
> +       /* Set DCE bit to 0 in DCCTRL */
> +       val = xhci_readl(xhci, &xhci->dbg_cap_regs->dcctrl);
> +       if (val == 0xffffffff) {
> +               xhci_err(xhci, "ERROR %s: DbC host controller died\n", __func__);
> +       } else {
> +               val &= ~DCCTRL_WR_DCE(1);
> +               xhci_writel(xhci, val, &xhci->dbg_cap_regs->dcctrl);
> +       }
> +
> +       dbc_endpoint_deinit(xhci, 1);
> +       dbc_endpoint_deinit(xhci, 0);
> +
> +       dbc_teardown_dbcic(xhci, dev);
> +
> +       if (xhci->dbg_cap_ctx) {
> +               dma_pool_free(xhci->dbc_device_pool, xhci->dbg_cap_ctx,
> +                               xhci->dbg_cap_ctx_dma);
> +               xhci->dbg_cap_ctx = NULL;
> +       }
> +       if (xhci->dbc_erst.entries) {
> +               dma_free_coherent(dev,
> +                               sizeof(struct xhci_erst_entry) * ERST_NUM_SEGS,
> +                               xhci->dbc_erst.entries,
> +                               xhci->dbc_erst.erst_dma_addr);
> +               xhci->dbc_erst.entries = NULL;
> +       }
> +       if (xhci->dbc_event_ring) {
> +               dbc_ring_free(xhci, xhci->dbc_event_ring);
> +               xhci->dbc_event_ring = NULL;
> +       }
> +       if (xhci->dbc_device_pool) {
> +               dma_pool_destroy(xhci->dbc_device_pool);
> +               xhci->dbc_device_pool = NULL;
> +       }
> +       if (xhci->dbc_segment_pool) {
> +               dma_pool_destroy(xhci->dbc_segment_pool);
> +               xhci->dbc_segment_pool = NULL;
> +       }
> +}
> +
> +/*
> + * Scan the Extended Capabilities to find the Debug Capability, then initialize
> + * and start it
> + */
> +int xhci_setup_dbg_cap(struct xhci_hcd *xhci, struct device *dev)
> +{
> +       struct xhci_segment *seg;
> +       dma_addr_t dma;
> +       u64 val_64;
> +       u32 val, offset;
> +       int ret = -ENOMEM;
> +       __le32 __iomem *addr = &xhci->cap_regs->hcc_params;
> +
> +       offset = XHCI_HCC_EXT_CAPS(xhci_readl(xhci, addr));
> +       if (offset == 0) {
> +               xhci_err(xhci, "ERROR: no Extended Capability registers, unable to set up Debug Capability\n");
> +               return -ENODEV;
> +       }
> +
> +       /*
> +        * For whatever reason, the first capability offset is from the
> +        * capability register base, not from the HCCPARAMS register.
> +        * See section 5.3.6 for offset calculation.
> +        */
> +       addr = &xhci->cap_regs->hc_capbase  offset;
> +       while (1) {
> +               u32 cap_id;
> +
> +               cap_id = xhci_readl(xhci, addr);
> +               if (XHCI_EXT_CAPS_ID(cap_id) == XHCI_EXT_CAPS_DEBUG)
> +                       break;
> +               offset = XHCI_EXT_CAPS_NEXT(cap_id);
> +               if (!offset) {
> +                       xhci_info(xhci, "No Debug Capability found\n");
> +                       return -ENODEV;
> +               }
> +               /*
> +                * Once you're into the Extended Capabilities, the offset is
> +                * always relative to the register holding the offset
> +                */
> +               addr = offset;
> +       }
> +
> +       /* Save address of debug capability registers */
> +       xhci->dbg_cap_regs = (struct xhci_dbg_cap_regs __iomem *)addr;
> +
> +       /*
> +        * Initialize the ring segment pool. The ring must be a contiguous
> +        * structure comprised of TRBs. The TRBs must be 16 byte aligned,
> +        * however, the command ring segment needs 64-byte aligned segments,
> +        * so we pick the greater alignment need.
> +        */
> +       xhci->dbc_segment_pool = dma_pool_create("xHCI DbC ring segments", dev,
> +                       SEGMENT_SIZE, 64, 1 << 12);
> +
> +       /* See Table 46 and Note on Figure 55 */
> +       xhci->dbc_device_pool = dma_pool_create("xHCI DbC contexts", dev,
> +                       192, 64, 1 << 12);
> +       if (!xhci->dbc_segment_pool || !xhci->dbc_device_pool) {
> +               xhci_err(xhci, "ERROR: failed to allocate DbC segment/device pools\n");
> +               goto fail;
> +       }
> +
> +       /*
> +        * Event ring setup: Allocate a normal ring, but also setup
> +        * the event ring segment table (ERST). Section 4.9.3.
> +        */
> +       xhci_dbg(xhci, "// Allocating DbC event ring\n");
> +       xhci->dbc_event_ring = dbc_ring_alloc(xhci, ERST_NUM_SEGS, 1,
> +                                               TYPE_EVENT, GFP_KERNEL);
> +       if (!xhci->dbc_event_ring) {
> +               xhci_err(xhci, "ERROR: failed to allocate DbC event ring\n");
> +               goto fail;
> +       }
> +
> +       xhci->dbc_erst.entries = dma_alloc_coherent(dev,
> +                       sizeof(struct xhci_erst_entry) * ERST_NUM_SEGS, &dma,
> +                       GFP_KERNEL);
> +       if (!xhci->dbc_erst.entries) {
> +               xhci_err(xhci, "ERROR: failed to allocate DbC event ring seg table\n");
> +               goto fail;
> +       }
> +       xhci_dbg(xhci, "// Allocated DbC event ring segment table at 0x%llx\n",
> +                       (unsigned long long)dma);
> +
> +       memset(xhci->dbc_erst.entries, 0,
> +                       sizeof(struct xhci_erst_entry) * ERST_NUM_SEGS);
> +       xhci->dbc_erst.num_entries = ERST_NUM_SEGS;
> +       xhci->dbc_erst.erst_dma_addr = dma;
> +       xhci_dbg(xhci, "Set DbC ERST to 0; private num segs = %i, virt addr = %p, dma addr = 0x%llx\n",
> +                       xhci->dbc_erst.num_entries, xhci->dbc_erst.entries,
> +                       (unsigned long long)xhci->dbc_erst.erst_dma_addr);
> +
> +       /* set ring base address and size for each segment table entry */
> +       for (val = 0, seg = xhci->dbc_event_ring->first_seg;
> +                                       val < ERST_NUM_SEGS; val) {
> +               struct xhci_erst_entry *entry = &xhci->dbc_erst.entries[val];
> +
> +               entry->seg_addr = cpu_to_le64(seg->dma);
> +               entry->seg_size = cpu_to_le32(TRBS_PER_SEGMENT);
> +               entry->rsvd = 0;
> +               seg = seg->next;
> +       }
> +
> +       /* set ERST count with the number of entries in the segment table */
> +       xhci_dbg(xhci, "// Write DbC ERST size = %i to dcerstsz\n",
> +                       ERST_NUM_SEGS);
> +       xhci_writel(xhci, ERST_NUM_SEGS, &xhci->dbg_cap_regs->dcerstsz);
> +
> +       xhci_dbg(xhci, "// Set DbC ERST entries to point to event ring\n");
> +       /* set the segment table base address */
> +       xhci_dbg(xhci, "// Set DbC ERST base address for dcerstba = 0x%llx\n",
> +                       (unsigned long long)xhci->dbc_erst.erst_dma_addr);
> +       val_64 = xhci_read_64(xhci, &xhci->dbg_cap_regs->dcerstba);
> +       if (val_64 == 0xffffffffffffffffUL) {
> +               xhci_err(xhci, "ERROR %s 1: DbC host controller died\n", __func__);
> +               ret = -ENODEV;
> +               goto fail;
> +       }
> +       val_64 &= ERST_PTR_MASK;
> +       val_64 |= xhci->dbc_erst.erst_dma_addr & ~(u64)ERST_PTR_MASK;
> +       xhci_write_64(xhci, val_64, &xhci->dbg_cap_regs->dcerstba);
> +
> +       /* Set the event ring dequeue address */
> +       dbc_set_hc_event_deq(xhci);
> +       xhci_dbg(xhci, "Wrote DbC ERST address\n");
> +/      xhci_print_ir_set(xhci, 0); */
> +
> +       /* Allocate and set up the DbCC */
> +       xhci->dbg_cap_ctx = dma_pool_alloc(xhci->dbc_device_pool, GFP_KERNEL,
> +                                       &xhci->dbg_cap_ctx_dma);
> +       if (!xhci->dbg_cap_ctx) {
> +               xhci_err(xhci, "ERROR: failed to allocate DbC capability context\n");
> +               goto fail;
> +       }
> +       ret = dbc_setup_dbcic(xhci, dev);
> +       if (ret) {
> +               xhci_err(xhci, "ERROR: failed to set up DbCIC\n");
> +               goto fail;
> +       }
> +
> +       /* Set VendorID, ProductID, and DbC Protocol */
> +       val = DCDDI1_WR_VENDID(DCD_VENDOR_ID) | DCDDI1_WR_PROTOCOL(DCDDI1_PROTO_VEND);
> +       xhci_writel(xhci, cpu_to_le32(val), &xhci->dbg_cap_regs->dcddi1);
> +       val = DCDDI2_WR_DEVREV(DCD_DEVICE_REV) | DCDDI2_WR_PRODID(DCD_PRODUCT_ID);
> +       xhci_writel(xhci, cpu_to_le32(val), &xhci->dbg_cap_regs->dcddi2);
> +
> +       /* Set up the OUT and IN bulk endpoints */
> +       ret = dbc_endpoint_init(xhci, 0, GFP_KERNEL);
> +       if (ret) {
> +               xhci_err(xhci, "ERROR: failed to init DbC EP1-OUT\n");
> +               goto fail;
> +       }
> +       ret = dbc_endpoint_init(xhci, 1, GFP_KERNEL);
> +       if (ret) {
> +               xhci_err(xhci, "ERROR: failed to init DbC EP1-IN\n");
> +               goto fail;
> +       }
> +
> +       INIT_LIST_HEAD(&xhci->dbc_out_urb_list);
> +       INIT_LIST_HEAD(&xhci->dbc_in_urb_list);
> +
> +       /* set the DbCC address in the DCCP register */
> +       xhci_write_64(xhci, xhci->dbg_cap_ctx_dma, &xhci->dbg_cap_regs->dccp);
> +
> +       /* Set DCE bit to 1 in DCCTRL */
> +       val = xhci_readl(xhci, &xhci->dbg_cap_regs->dcctrl);
> +       if (val == 0xffffffff) {
> +               xhci_err(xhci, "ERROR %s 2: DbC host controller died\n", __func__);
> +               ret = -ENODEV;
> +               goto fail;
> +       }
> +       val |= DCCTRL_WR_DCE(1);
> +       xhci_writel(xhci, val, &xhci->dbg_cap_regs->dcctrl);
> +
> +       /* Start the kernel thread to poll for events */
> +       xhci->dbc_thread = kthread_run(dbc_poll_events, xhci, "dbcthr");
> +       if (IS_ERR(xhci->dbc_thread)) {
> +               ret = PTR_ERR(xhci->dbc_thread);
> +               xhci->dbc_thread = NULL;
> +               xhci_err(xhci, "ERROR: failed to start DbC event thread\n");
> +               goto fail;
> +       }
> +
> +       return 0;
> +
> +fail:
> +       xhci_teardown_dbg_cap(xhci, dev);
> +       return ret;
> +
> +}
> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> index e20520f..c0b8db5b 100644
> --- a/drivers/usb/host/xhci-pci.c
> +++ b/drivers/usb/host/xhci-pci.c
> @@ -43,12 +43,13 @@ static const char hcd_name[] = "xhci_hcd";
>  /* called after powerup, by probe or system-pm "wakeup" */
>  static int xhci_pci_reinit(struct xhci_hcd *xhci, struct pci_dev *pdev)
>  {
> +       int retval;
>         /*
>          * TODO: Implement finding debug ports later.
>          * TODO: see if there are any quirks that need to be added to handle
>          * new extended capabilities.
>          */
> -
> +       retval = xhci_dgb(xhci, "xhci_setup_dbg_cap() returned %d\n", retval);
>         /* PCI Memory-Write-Invalidate cycle support is optional (uncommon) */
>         if (!pci_set_mwi(pdev))
>                 xhci_dbg(xhci, "MWI active\n");
> @@ -256,12 +257,9 @@ static void xhci_pci_remove(struct pci_dev *dev)
>                 usb_remove_hcd(xhci->shared_hcd);
>                 usb_put_hcd(xhci->shared_hcd);
>         }
> +       xhci_teardown_dbg_cap(xhci, &dev->dev);
>         usb_hcd_pci_remove(dev);
>
> -       /* Workaround for spurious wakeups at shutdown with HSW */
> -       if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
> -               pci_set_power_state(dev, PCI_D3hot);
> -
>         kfree(xhci);
> }
>
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index 9ffecd5..16a36c5 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -117,8 +117,8 @@ struct xhci_cap_regs {
>  #define HCC_LTC(p)             ((p) & (1 << 6))
>  /* true: no secondary Stream ID Support */
>  #define HCC_NSS(p)             ((p) & (1 << 7))
> -/* Max size for Primary Stream Arrays - 2^(n+1), where n is bits 12:15 */
> -#define HCC_MAX_PSA(p)         (1 << ((((p) >> 12) & 0xf) + 1))
> +/* Max size for Primary Stream Arrays - 2^(n1), where n is bits 12:15 */
> +#define HCC_MAX_PSA(p)         (1 << ((((p) >> 12) & 0xf)  1))
>  /* Extended Capabilities pointer from PCI base - section 5.3.6 */
>  #define HCC_EXT_CAPS(p)                XHCI_HCC_EXT_CAPS(p)
>
> @@ -143,7 +143,7 @@ struct xhci_cap_regs {
>   * @status:            USBSTS - xHC status register
>   * @page_size:         This indicates the page size that the host controller
>   *                     supports.  If bit n is set, the HC supports a page size
> - *                     of 2^(n+12), up to a 128MB page size.
> + *                     of 2^(n12), up to a 128MB page size.
>   *                     4K is the minimum page size.
>   * @cmd_ring:          CRP - 64-bit Command Ring Pointer
>   * @dcbaa_ptr:         DCBAAP - 64-bit Device Context Base Address Array Pointer
> @@ -494,7 +494,7 @@ struct xhci_doorbell_array {
>         __le32  doorbell[256];
>  };
>
> -#define DB_VALUE(ep, stream)   ((((ep) + 1) & 0xff) | ((stream) << 16))
> +#define DB_VALUE(ep, stream)   ((((ep)  1) & 0xff) | ((stream) << 16))
>  #define DB_VALUE_HOST          0x00000000
>
>  /**
> @@ -720,9 +720,9 @@ struct xhci_input_control_ctx {
>  };
>
>  #define        EP_IS_ADDED(ctrl_ctx, i) \
> -       (le32_to_cpu(ctrl_ctx->add_flags) & (1 << (i + 1)))
> +       (le32_to_cpu(ctrl_ctx->add_flags) & (1 << (i  1)))
>  #define        EP_IS_DROPPED(ctrl_ctx, i)       \
> -       (le32_to_cpu(ctrl_ctx->drop_flags) & (1 << (i + 1)))
> +       (le32_to_cpu(ctrl_ctx->drop_flags) & (1 << (i  1)))
>
>  /* Represents everything that is needed to issue a command on the command ring.
>   * It's useful to pre-allocate these for commands that cannot fail due to
> @@ -829,8 +829,8 @@ struct xhci_bw_info {
>   * of overhead associated with split transfers crossing microframe boundaries.
>   * 31 blocks is pure protocol overhead.
>   */
> -#define TT_HS_OVERHEAD (31 + 94)
> -#define TT_DMI_OVERHEAD (25 + 12)
> +#define TT_HS_OVERHEAD (31  94)
> +#define TT_DMI_OVERHEAD (25  12)
>
>  /* Bandwidth limits in blocks */
>  #define FS_BW_LIMIT            1285
> @@ -1108,7 +1108,7 @@ enum xhci_setup_dev {
>
>  /* Stop Endpoint TRB - ep_index to endpoint ID for this TRB */
>  #define TRB_TO_EP_INDEX(p)             ((((p) & (0x1f << 16)) >> 16) - 1)
> -#define        EP_ID_FOR_TRB(p)                ((((p) + 1) & 0x1f) << 16)
> +#define        EP_ID_FOR_TRB(p)                ((((p)  1) & 0x1f) << 16)
>
>  #define SUSPEND_PORT_FOR_TRB(p)                (((p) & 1) << 23)
>  #define TRB_TO_SUSPEND_PORT(p)         (((p) & (1 << 23)) >> 23)
> @@ -1266,7 +1266,7 @@ union xhci_trb {
>   * It must also be greater than 16.
>   */
>  #define TRBS_PER_SEGMENT       64
> -/* Allow two commands + a link TRB, along with any reserved command TRBs */
> +/* Allow two commands  a link TRB, along with any reserved command TRBs */
>  #define MAX_RSVD_CMD_TRBS      (TRBS_PER_SEGMENT - 3)
>  #define TRB_SEGMENT_SIZE       (TRBS_PER_SEGMENT*16)
>  #define TRB_SEGMENT_SHIFT      (ilog2(TRB_SEGMENT_SIZE))
> @@ -1420,6 +1420,174 @@ struct xhci_bus_state {
>         unsigned long           rexit_ports;
>         struct completion       rexit_done[USB_MAXCHILDREN];
>  };
> +/**
> + * struct xhci_dbg_cap_regs
> + *
> + * See section 7.6.8 in the xHCI 1.0 spec.
> + */
> +struct xhci_dbg_cap_regs {
> +       __le32                  dcid;
> +#define        DCID_ERSTMAX(x)         (((x) >> 16) & 0x1f)
> +       __le32                  dcdb;
> +#define DCDB_WR_TARGET(x)      (((x) & 0xff) << 8)
> +       __le32                  dcerstsz;
> +#define        DCERSTSZ(x)             ((x) & 0xffff)
> +#define        DCERSTSZ_WR(x)          ((x) & 0xffff)
> +       __le32                  rsvd1;
> +       __le64                  dcerstba;
> +#define        DCERSTBA_LO(x)          ((x) & 0xfffffff0)
> +#define        DCERSTBA_HI(x)          (x)
> +#define        DCERSTBA_WR_LO(x)       ((x) & 0xfffffff0)
> +#define        DCERSTBA_WR_HI(x)       (x)
> +       __le64                  dcerdp;
> +#define        DCERDP_LO(x)            ((x) & 0xfffffff0)
> +#define        DCERDP_HI(x)            (x)
> +#define        DCERDP_WR_LO(x)         ((x) & 0xfffffff0)
> +#define        DCERDP_WR_HI(x)         (x)
> +       __le32                  dcctrl;
> +#define        DCCTRL_DCE(x)           (((x) >> 31) & 1)
> +#define        DCCTRL_WR_DCE(x)        (((x) & 1) << 31)
> +#define        DCCTRL_DEVADR(x)        (((x) >> 24) & 0x7f)
> +#define        DCCTRL_MAXBST(x)        (((x) >> 16) & 0xff)
> +#define        DCCTRL_DRC(x)           (((x) >> 4) & 1)
> +#define        DCCTRL_CLR_DRC          (1 << 4)
> +#define        DCCTRL_HIT(x)           (((x) >> 3) & 1)
> +#define        DCCTRL_SET_HIT          (1 << 3)
> +#define        DCCTRL_HOT(x)           (((x) >> 2) & 1)
> +#define        DCCTRL_SET_HOT          (1 << 2)
> +#define        DCCTRL_LSE(x)           (((x) >> 1) & 1)
> +#define        DCCTRL_WR_LSE(x)        (((x) & 1) << 1)
> +#define        DCCTRL_DCR(x)           ((x) & 1)
> +       __le32                  dcst;
> +#define        DCST_PORTNUM(x)         (((x) >> 24) & 0xff)
> +#define        DCST_ER(x)              ((x) & 1)
> +       __le32                  dcportsc;
> +#define        DCPORTSC_CEC(x)         (((x) >> 23) & 1)
> +#define        DCPORTSC_CLR_CEC        (1 << 23)
> +#define        DCPORTSC_PLC(x)         (((x) >> 22) & 1)
> +#define        DCPORTSC_CLR_PLC        (1 << 22)
> +#define        DCPORTSC_PRC(x)         (((x) >> 21) & 1)
> +#define        DCPORTSC_CLR_PRC        (1 << 21)
> +#define        DCPORTSC_CSC(x)         (((x) >> 17) & 1)
> +#define        DCPORTSC_CLR_CSC        (1 << 17)
> +#define        DCPORTSC_PORTSPD(x)     (((x) >> 10) & 0x0f)
> +#define        DCPORTSC_PLS(x)         (((x) >> 5) & 0x0f)
> +#define        DCPORTSC_PR(x)          (((x) >> 4) & 1)
> +#define        DCPORTSC_PED(x)         (((x) >> 1) & 1)
> +#define        DCPORTSC_WR_PED(x)      (((x) & 1) << 1)
> +#define        DCPORTSC_CCS(x)         ((x) & 1)
> +       __le32                  rsvd2;
> +       __le64                  dccp;
> +#define        DCCP_LO(x)              ((x) & 0xfffffff0)
> +#define        DCCP_HI(x)              (x)
> +#define        DCCP_WR_LO(x)           ((x) & 0xfffffff0)
> +#define        DCCP_WR_HI(x)           (x)
> +       __le32                  dcddi1;
> +#define        DCDDI1_VENDID(x)        (((x) >> 16) & 0xffff)
> +#define        DCDDI1_WR_VENDID(x)     (((x) & 0xffff) << 16)
> +#define        DCDDI1_PROTOCOL(x)      ((x) & 0xff)
> +#define        DCDDI1_WR_PROTOCOL(x)   ((x) & 0xff)
> +#define DCDDI1_PROTO_VEND      0
> +#define DCDDI1_PROTO_GNU       1
> +       __le32                  dcddi2;
> +#define        DCDDI2_DEVREV(x)        (((x) >> 16) & 0xffff)
> +#define        DCDDI2_WR_DEVREV(x)     (((x) & 0xffff) << 16)
> +#define        DCDDI2_PRODID(x)        ((x) & 0xffff)
> +#define        DCDDI2_WR_PRODID(x)     ((x) & 0xffff)
> +};
> +
> +/**
> + * struct xhci_dbg_cap_info_ctx
> + *
> + * See section 7.6.9.1 in the xHCI 1.0 spec.
> + */
> +struct xhci_dbg_cap_info_ctx {
> +       __le32  str_0_desc_addr_lo;
> +       __le32  str_0_desc_addr_hi;
> +       __le32  manuf_str_desc_addr_lo;
> +       __le32  manuf_str_desc_addr_hi;
> +       __le32  product_str_desc_addr_lo;
> +       __le32  product_str_desc_addr_hi;
> +       __le32  serial_str_desc_addr_lo;
> +       __le32  serial_str_desc_addr_hi;
> +       __u8    str_0_len;
> +       __u8    manuf_str_len;
> +       __u8    product_str_len;
> +       __u8    serial_str_len;
> +       __le32  reserved[7];
> +};
> +
> +/**
> + * struct xhci_dbg_cap_ctx
> + *
> + * See section 7.6.9 in the xHCI 1.0 spec.
> + */
> +struct xhci_dbg_cap_ctx {
> +       struct xhci_dbg_cap_info_ctx    info_ctx;
> +       struct xhci_ep_ctx              out_ep_ctx;
> +       __le32                          reserved1[8];
> +       struct xhci_ep_ctx              in_ep_ctx;
> +       __le32                          reserved2[8];
> +
> +/*
> + * Debug Capability support - see section 7 in the xHCI 1.0 spec.
> + */
> +       /* Debug Capability registers */
> +       struct xhci_dbg_cap_regs __iomem *dbg_cap_regs;
> +
> +       /* Statistics */
> +       int                             dbc_error_bitmask;
> +
> +       /* DMA pools */
> +       struct dma_pool                 *dbc_device_pool;
> +       struct dma_pool                 *dbc_segment_pool;
> +
> +       /* Contexts */
> +       struct xhci_dbg_cap_ctx         *dbg_cap_ctx;
> +       dma_addr_t                      dbg_cap_ctx_dma;
> +
> +       /* DbCIC */
> +       void                            *str_0_desc;
> +       void                            *manuf_str_desc;
> +       void                            *product_str_desc;
> +       void                            *serial_str_desc;
> +       dma_addr_t                      str_0_desc_dma;
> +       dma_addr_t                      manuf_str_desc_dma;
> +       dma_addr_t                      product_str_desc_dma;
> +       dma_addr_t                      serial_str_desc_dma;
> +
> +       /* EPs */
> +       struct xhci_virt_ep             dbc_out_ep;
> +       struct xhci_virt_ep             dbc_in_ep;
> +       struct xhci_ring                *dbc_out_ring;
> +       struct xhci_ring                *dbc_in_ring;
> +       struct list_head                dbc_out_urb_list;
> +       struct list_head                dbc_in_urb_list;
> +
> +       /* Event ring */
> +       struct xhci_ring                *dbc_event_ring;
> +       struct xhci_erst                dbc_erst;
> +
> +       /* Event thread */
> +       struct task_struct              *dbc_thread;
> +       char                            *dbc_buf_0;
> +       char                            *dbc_buf_1;
> +       char                            *dbc_buf_2;
> +       char                            *dbc_buf_3;
> +       dma_addr_t                      dbc_buf_0_dma;
> +       dma_addr_t                      dbc_buf_1_dma;
> +       dma_addr_t                      dbc_buf_2_dma;
> +       dma_addr_t                      dbc_buf_3_dma;
> +       struct urb                      dbc_urb_0;
> +       struct urb                      dbc_urb_1;
> +       struct urb                      dbc_urb_2;
> +       struct urb                      dbc_urb_3;
> +       int                             dbc_configured;
> +       int                             dbc_next_0;
> +};
> +};
> +
> +
>
>
>  /*
> @@ -1618,8 +1786,8 @@ static inline u64 xhci_read_64(const struct xhci_hcd *xhci,
>  {
>         __u32 __iomem *ptr = (__u32 __iomem *) regs;
>         u64 val_lo = readl(ptr);
> -       u64 val_hi = readl(ptr + 1);
> -       return val_lo + (val_hi << 32);
> +       u64 val_hi = readl(ptr  1);
> +
> +       return val_lo(val_hi << 32);
>  }
>  static inline void xhci_write_64(struct xhci_hcd *xhci,
>                                  const u64 val, __le64 __iomem *regs)
> @@ -1629,7 +1797,7 @@ static inline void xhci_write_64(struct xhci_hcd *xhci,
>         u32 val_hi = upper_32_bits(val);
>
>         writel(val_lo, ptr);
> -       writel(val_hi, ptr + 1);
> +       writel(val_hi, ptr  1);
>  }
>
>  static inline int xhci_link_trb_quirk(struct xhci_hcd *xhci)
> @@ -1884,7 +2052,8 @@ void xhci_ring_device(struct xhci_hcd *xhci, int slot_id);
>  struct xhci_input_control_ctx *xhci_get_input_control_ctx(struct xhci_hcd *xhci, struct xhci_container_ctx *ctx);
>  struct xhci_slot_ctx *xhci_get_slot_ctx(struct xhci_hcd *xhci, struct xhci_container_ctx *ctx);
>  struct xhci_ep_ctx *xhci_get_ep_ctx(struct xhci_hcd *xhci, struct xhci_container_ctx *ctx, unsigned int ep_index);
> -
> +int xhci_setup_dbg_cap(struct xhci_hcd *xhci, struct device *dev);
> +void xhci_teardown_dbg_cap(struct xhci_hcd *xhci, struct device *dev);
>  /* xHCI quirks */
>  bool xhci_compliance_mode_recovery_timer_quirk_check(void);
>
> diff --git a/xhci.patch b/xhci.patch
> new file mode 100644
> index 0000000..fb7c466
> --- /dev/null
> +++ b/xhci.patch
> @@ -0,0 +1,2719 @@
> +diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
> +index 9e0a89c..4926474 100644
> +--- a/drivers/usb/host/Makefile
> ++++ b/drivers/usb/host/Makefile
> +@@ -13,7 +13,7 @@ fhci-y += fhci-mem.o fhci-tds.o fhci-sched.o
> +
> + fhci-$(CONFIG_FHCI_DEBUG) += fhci-dbg.o
> +
> + xhci-hcd-y := xhci.o xhci-mem.o
> +-xhci-hcd-y += xhci-ring.o xhci-hub.o xhci-dbg.o
> ++xhci-hcd-y += xhci-ring.o xhci-hub.o xhci-dbg.o xhci-dbgcap.o
> + xhci-hcd-$(CONFIG_PCI)        += xhci-pci.o
> +
> + ifneq ($(CONFIG_USB_XHCI_PLATFORM), )
> +diff --git a/drivers/usb/host/xhci-dbgcap.c b/drivers/usb/host/xhci-dbgcap.c
> +new file mode 100644
> +index 0000000..11d644d
> +--- /dev/null
> ++++ b/drivers/usb/host/xhci-dbgcap.c
> +@@ -0,0 +1,2478 @@
> ++/*
> ++ * xHCI host controller debug capability driver
> ++ *
> ++ * Copyright (C) 2012 Synopsys, Inc.
> ++ *
> ++ * Author: Paul Zimmerman
> ++ * Most code borrowed from the Linux xHCI driver.
> */
> ++#include <linux/usb.h>
> ++#include <linux/pci.h>
> ++#include <linux/slab.h>
> ++#include <linux/dmapool.h>
> ++#include <linux/kthread.h>
> ++#include <linux/freezer.h>
> ++
> ++#include "xhci.h"
> ++
> ++#define DBC_SRC_SINK  1
> ++
> ++#define DCD_VENDOR_ID 0x0525
> ++#define DCD_PRODUCT_ID        0xa4a0
> ++#define DCD_DEVICE_REV        0x0002
> ++
> ++static int dbc_incr;
> ++
> ++/*
> ++ * Debug Capability string descriptors
> ++ */
> ++
> ++#undef UCONSTW
> ++#define UCONSTW(v)    __constant_cpu_to_le16(v)
> ++
> ++static struct {
> ++      __u8    bLength;
> ++      __u8    bDescriptorType;
> ++      __le16  wString[1];
> ++} __attribute__((packed)) dbc_language_string = {
> ++      4,              /* bLength (size of string array + 2) */
> ++      USB_DT_STRING,  /* bDescriptorType */
> ++      {               /* wString[] */
> ++              /* US English */
> ++              UCONSTW(0x0409),
> ++      },
> ++};
> ++
> ++static struct {
> ++      __u8    bLength;
> ++      __u8    bDescriptorType;
> ++      __le16  wString[8];
> ++} __attribute__((packed)) dbc_manuf_string = {
> ++      18,             /* bLength (size of string array + 2) */
> ++      USB_DT_STRING,  /* bDescriptorType */
> ++      {               /* wString[] */
> ++              UCONSTW('S'), UCONSTW('y'), UCONSTW('n'), UCONSTW('o'),
> ++              UCONSTW('p'), UCONSTW('s'), UCONSTW('y'), UCONSTW('s'),
> ++      },
> ++};
> ++
> ++static struct {
> ++      __u8    bLength;
> ++      __u8    bDescriptorType;
> ++      __le16  wString[8];
> ++} __attribute__((packed)) dbc_product_string = {
> ++      18,             /* bLength (size of string array + 2) */
> ++      USB_DT_STRING,  /* bDescriptorType */
> ++      {               /* wString[] */
> ++              UCONSTW('D'), UCONSTW('W'), UCONSTW('C'), UCONSTW(' '),
> ++              UCONSTW('U'), UCONSTW('S'), UCONSTW('B'), UCONSTW('3'),
> ++      },
> ++};
> ++
> ++static struct {
> ++      __u8    bLength;
> ++      __u8    bDescriptorType;
> ++      __le16  wString[10];
> ++} __attribute__((packed)) dbc_serial_string = {
> ++      22,             /* bLength (size of string array + 2) */
> ++      USB_DT_STRING,  /* bDescriptorType */
> ++      {               /* wString[] */
> ++              UCONSTW('0'), UCONSTW('1'), UCONSTW('2'), UCONSTW('3'),
> ++              UCONSTW('4'), UCONSTW('5'), UCONSTW('6'), UCONSTW('7'),
> ++              UCONSTW('8'), UCONSTW('9'),
> ++      },
> ++};
> ++
> ++#undef UCONSTW
> ++
> ++/*
> ++ * Free the string descriptors
> ++ */
> ++static void dbc_teardown_dbcic(struct xhci_hcd *xhci, struct device *dev)
> ++{
> ++      if (xhci->serial_str_desc) {
> ++              dma_free_coherent(dev, sizeof(dbc_serial_string),
> ++                              xhci->serial_str_desc,
> ++                              xhci->serial_str_desc_dma);
> ++              xhci->serial_str_desc = NULL;
> ++      }
> ++      if (xhci->product_str_desc) {
> ++              dma_free_coherent(dev, sizeof(dbc_product_string),
> ++                              xhci->product_str_desc,
> ++                              xhci->product_str_desc_dma);
> ++              xhci->product_str_desc = NULL;
> ++      }
> ++      if (xhci->manuf_str_desc) {
> ++              dma_free_coherent(dev, sizeof(dbc_manuf_string),
> ++                              xhci->manuf_str_desc,
> ++                              xhci->manuf_str_desc_dma);
> ++              xhci->manuf_str_desc = NULL;
> ++      }
> ++      if (xhci->str_0_desc) {
> ++              dma_free_coherent(dev, sizeof(dbc_language_string),
> ++                              xhci->str_0_desc,
> ++                              xhci->str_0_desc_dma);
> ++              xhci->str_0_desc = NULL;
> ++      }
> ++}
> ++
> ++/*
> ++ * Allocate the string descriptors and initialize the DbCIC
> ++ */
> ++static int dbc_setup_dbcic(struct xhci_hcd *xhci, struct device *dev)
> ++{
> ++      struct xhci_dbg_cap_info_ctx *info_ctx = &xhci->dbg_cap_ctx->info_ctx;
> ++
> ++      /* Allocate the string descriptors */
> ++      xhci->str_0_desc = dma_alloc_coherent(dev, sizeof(dbc_language_string),
> ++                              &xhci->str_0_desc_dma, GFP_KERNEL);
> ++      if (!xhci->str_0_desc)
> ++              goto fail;
> ++      xhci->manuf_str_desc = dma_alloc_coherent(dev, sizeof(dbc_manuf_string),
> ++                              &xhci->manuf_str_desc_dma, GFP_KERNEL);
> ++      if (!xhci->manuf_str_desc)
> ++              goto fail;
> ++      xhci->product_str_desc = dma_alloc_coherent(dev, sizeof(dbc_product_string),
> ++                              &xhci->product_str_desc_dma, GFP_KERNEL);
> ++      if (!xhci->product_str_desc)
> ++              goto fail;
> ++      xhci->serial_str_desc = dma_alloc_coherent(dev, sizeof(dbc_serial_string),
> ++                              &xhci->serial_str_desc_dma, GFP_KERNEL);
> ++      if (!xhci->serial_str_desc)
> ++              goto fail;
> ++
> ++      memcpy(xhci->str_0_desc, &dbc_language_string, sizeof(dbc_language_string));
> ++      memcpy(xhci->manuf_str_desc, &dbc_manuf_string, sizeof(dbc_manuf_string));
> ++      memcpy(xhci->product_str_desc, &dbc_product_string, sizeof(dbc_product_string));
> ++      memcpy(xhci->serial_str_desc, &dbc_serial_string, sizeof(dbc_serial_string));
> ++
> ++      /* Set the string descriptor address fields in the DbCIC */
> ++      info_ctx->str_0_desc_addr_lo =
> ++              cpu_to_le32(lower_32_bits(xhci->str_0_desc_dma));
> ++      info_ctx->str_0_desc_addr_hi =
> ++              cpu_to_le32(upper_32_bits(xhci->str_0_desc_dma));
> ++      info_ctx->manuf_str_desc_addr_lo =
> ++              cpu_to_le32(lower_32_bits(xhci->manuf_str_desc_dma));
> ++      info_ctx->manuf_str_desc_addr_hi =
> ++              cpu_to_le32(upper_32_bits(xhci->manuf_str_desc_dma));
> ++      info_ctx->product_str_desc_addr_lo =
> ++              cpu_to_le32(lower_32_bits(xhci->product_str_desc_dma));
> ++      info_ctx->product_str_desc_addr_hi =
> ++              cpu_to_le32(upper_32_bits(xhci->product_str_desc_dma));
> ++      info_ctx->serial_str_desc_addr_lo =
> ++              cpu_to_le32(lower_32_bits(xhci->serial_str_desc_dma));
> ++      info_ctx->serial_str_desc_addr_hi =
> ++              cpu_to_le32(upper_32_bits(xhci->serial_str_desc_dma));
> ++
> ++      /* Set the string length fields in the DbCIC */
> ++      info_ctx->str_0_len = dbc_language_string.bLength;
> ++      info_ctx->manuf_str_len = dbc_manuf_string.bLength;
> ++      info_ctx->product_str_len = dbc_product_string.bLength;
> ++      info_ctx->serial_str_len = dbc_serial_string.bLength;
> ++
> ++      return 0;
> ++
> ++fail:
> ++      dbc_teardown_dbcic(xhci, dev);
> ++      return -ENOMEM;
> ++}
> ++
> ++/*
> ++ * Allocate a generic ring segment from the ring pool, set the dma address,
> ++ * initialize the segment to zero, and set the private next pointer to NULL
> ++ *
> ++ * Section 4.11.1.1:
> ++ * "All components of all Command and Transfer TRBs shall be initialized to '0'"
> ++ */
> ++static struct xhci_segment *dbc_segment_alloc(struct xhci_hcd *xhci,
> ++              unsigned int cycle_state, gfp_t flags)
> ++{
> ++      int i;
> ++      dma_addr_t dma;
> ++      struct xhci_segment *seg;
> ++
> ++      xhci_dbg(xhci, "%s()\n", __func__);
> ++
> ++      seg = kzalloc(sizeof(*seg), flags);
> ++      if (!seg)
> ++              return NULL;
> ++
> ++      seg->trbs = dma_pool_alloc(xhci->dbc_segment_pool, flags, &dma);
> ++      if (!seg->trbs) {
> ++              kfree(seg);
> ++              return NULL;
> ++      }
> ++
> ++      memset(seg->trbs, 0, SEGMENT_SIZE);
> ++
> ++      /* If the cycle state is 0, set the cycle bit to 1 for all the TRBs */
> ++      if (cycle_state == 0) {
> ++              xhci_dbg(xhci, "cycle_state = 0\n");
> ++              for (i = 0; i < TRBS_PER_SEGMENT; i++)
> ++                      seg->trbs[i].link.control |= TRB_CYCLE;
> ++      }
> ++
> ++      seg->dma = dma;
> ++      seg->next = NULL;
> ++      xhci_dbg(xhci, "seg=%p TRBs=%p (%08llx)\n", seg, seg->trbs,
> ++                      (unsigned long long)dma);
> ++
> ++      return seg;
> ++}
> ++
> ++static void dbc_segment_free(struct xhci_hcd *xhci, struct xhci_segment *seg)
> ++{
> ++      if (seg->trbs) {
> ++              dma_pool_free(xhci->dbc_segment_pool, seg->trbs, seg->dma);
> ++              seg->trbs = NULL;
> ++      }
> ++      kfree(seg);
> ++}
> ++
> ++/*
> ++ * Make the prev segment point to the next segment
> ++ *
> ++ * Change the last TRB in the prev segment to be a Link TRB which points to the
> ++ * DMA address of the next segment. The caller needs to set any Link TRB
> ++ * related flags, such as End TRB, Toggle Cycle, and no snoop.
> ++ */
> ++static void dbc_link_segments(struct xhci_hcd *xhci, struct xhci_segment *prev,
> ++              struct xhci_segment *next, enum xhci_ring_type type)
> ++{
> ++      u32 val;
> ++
> ++      if (!prev || !next)
> ++              return;
> ++      prev->next = next;
> ++      if (type != TYPE_EVENT) {
> ++              prev->trbs[TRBS_PER_SEGMENT-1].link.segment_ptr =
> ++                      cpu_to_le64(next->dma);
> ++
> ++              /* Set last TRB in segment to have TRB type ID = Link TRB */
> ++              val = le32_to_cpu(prev->trbs[TRBS_PER_SEGMENT-1].link.control);
> ++              val &= ~TRB_TYPE_BITMASK;
> ++              val |= TRB_TYPE(TRB_LINK);
> ++              /* Always set the chain bit with 0.95 hardware */
> ++              /* Set chain bit for isoc rings on AMD 0.96 host */
> ++              if (xhci_link_trb_quirk(xhci))
> ++                      val |= TRB_CHAIN;
> ++              prev->trbs[TRBS_PER_SEGMENT-1].link.control = cpu_to_le32(val);
> ++      }
> ++}
> ++
> ++static void dbc_free_segments_for_ring(struct xhci_hcd *xhci,
> ++              struct xhci_segment *first)
> ++{
> ++      struct xhci_segment *seg = first->next;
> ++
> ++      while (seg != first) {
> ++              struct xhci_segment *next = seg->next;
> ++              dbc_segment_free(xhci, seg);
> ++              seg = next;
> ++      }
> ++      dbc_segment_free(xhci, first);
> ++}
> ++
> ++/* Allocate segments and link them for a ring */
> ++static int dbc_alloc_segments_for_ring(struct xhci_hcd *xhci,
> ++              struct xhci_segment **first, struct xhci_segment **last,
> ++              unsigned int num_segs, unsigned int cycle_state,
> ++              enum xhci_ring_type type, gfp_t flags)
> ++{
> ++      struct xhci_segment *prev;
> ++
> ++      xhci_dbg(xhci, "%s()\n", __func__);
> ++
> ++      prev = dbc_segment_alloc(xhci, cycle_state, flags);
> ++      if (!prev)
> ++              return -ENOMEM;
> ++      num_segs--;
> ++
> ++      *first = prev;
> ++      while (num_segs > 0) {
> ++              struct xhci_segment *next;
> ++
> ++              next = dbc_segment_alloc(xhci, cycle_state, flags);
> ++              if (!next) {
> ++                      dbc_free_segments_for_ring(xhci, *first);
> ++                      return -ENOMEM;
> ++              }
> ++              dbc_link_segments(xhci, prev, next, type);
> ++
> ++              prev = next;
> ++              num_segs--;
> ++      }
> ++      dbc_link_segments(xhci, prev, *first, type);
> ++      *last = prev;
> ++
> ++      return 0;
> ++}
> ++
> ++/* XXX: Do we need the hcd structure in all these functions? */
> ++static void dbc_ring_free(struct xhci_hcd *xhci, struct xhci_ring *ring)
> ++{
> ++      if (!ring)
> ++              return;
> ++      if (ring->first_seg)
> ++              dbc_free_segments_for_ring(xhci, ring->first_seg);
> ++      kfree(ring);
> ++}
> ++
> ++static void dbc_initialize_ring_info(struct xhci_ring *ring,
> ++              unsigned int cycle_state)
> ++{
> ++      /* The ring is empty, so the enqueue pointer == dequeue pointer */
> ++      ring->enqueue = ring->first_seg->trbs;
> ++      ring->enq_seg = ring->first_seg;
> ++      ring->dequeue = ring->enqueue;
> ++      ring->deq_seg = ring->first_seg;
> ++      /* The ring is initialized to 0. The producer must write 1 to the cycle
> ++       * bit to handover ownership of the TRB, so PCS = 1. The consumer must
> ++       * compare CCS to the cycle bit to check ownership, so CCS = 1.
> ++       *
> ++       * New rings are initialized with cycle state equal to 1; if we are
> ++       * handling ring expansion, set the cycle state equal to the old ring.
> ++       */
> ++      ring->cycle_state = cycle_state;
> ++      /* Not necessary for new rings, but needed for re-initialized rings */
> ++      ring->enq_updates = 0;
> ++      ring->deq_updates = 0;
> ++
> ++      /*
> ++       * Each segment has a link TRB, and leave an extra TRB for SW
> ++       * accounting purpose
> ++       */
> ++      ring->num_trbs_free = ring->num_segs * (TRBS_PER_SEGMENT - 1) - 1;
> ++}
> ++
> ++/**
> ++ * Create a new ring with zero or more segments
> ++ *
> ++ * Link each segment together into a ring.
> ++ * Set the end flag and the cycle toggle bit on the last segment.
> ++ * See section 4.9.1 and figures 15 and 16.
> ++ */
> ++static struct xhci_ring *dbc_ring_alloc(struct xhci_hcd *xhci,
> ++              unsigned int num_segs, unsigned int cycle_state,
> ++              enum xhci_ring_type type, gfp_t flags)
> ++{
> ++      int ret;
> ++      struct xhci_ring *ring;
> ++
> ++      xhci_dbg(xhci, "%s()\n", __func__);
> ++
> ++      ring = kzalloc(sizeof(*ring), flags);
> ++      if (!ring)
> ++              return NULL;
> ++
> ++      ring->num_segs = num_segs;
> ++      INIT_LIST_HEAD(&ring->td_list);
> ++      ring->type = type;
> ++      if (num_segs == 0)
> ++              return ring;
> ++
> ++      ret = dbc_alloc_segments_for_ring(xhci, &ring->first_seg,
> ++                      &ring->last_seg, num_segs, cycle_state, type, flags);
> ++      if (ret)
> ++              goto fail;
> ++
> ++      /* Only event ring does not use link TRB */
> ++      if (type != TYPE_EVENT) {
> ++              /* See section 4.9.2.1 and 6.4.4.1 */
> ++              ring->last_seg->trbs[TRBS_PER_SEGMENT - 1].link.control |=
> ++                      cpu_to_le32(LINK_TOGGLE);
> ++      }
> ++      dbc_initialize_ring_info(ring, cycle_state);
> ++      xhci_dbg(xhci, "first=%p TRBs=%p (%08llx)\n", ring->first_seg,
> ++              ring->first_seg->trbs, (unsigned long long)ring->first_seg->dma);
> ++      xhci_dbg(xhci, "last=%p TRBs=%p (%08llx)\n", ring->last_seg,
> ++              ring->last_seg->trbs, (unsigned long long)ring->last_seg->dma);
> ++      return ring;
> ++
> ++fail:
> ++      dbc_ring_free(xhci, ring);
> ++      return NULL;
> ++}
> ++
> ++static void dbc_set_hc_event_deq(struct xhci_hcd *xhci)
> ++{
> ++      u64 temp;
> ++      dma_addr_t deq;
> ++
> ++      xhci_dbg(xhci, "%s()\n", __func__);
> ++
> ++      deq = xhci_trb_virt_to_dma(xhci->dbc_event_ring->deq_seg,
> ++                              xhci->dbc_event_ring->dequeue);
> ++      if (deq == 0)
> ++              xhci_warn(xhci, "WARN: something wrong with SW DbC event ring"
> ++                              " dequeue ptr\n");
> ++      /* Update HC event ring dequeue pointer */
> ++      temp = xhci_read_64(xhci, &xhci->dbg_cap_regs->dcerdp);
> ++      if (temp == 0xffffffffffffffffUL) {
> ++              xhci_err(xhci, "ERROR %s: DbC host controller died\n", __func__);
> ++              return;
> ++      }
> ++      temp &= ERST_PTR_MASK;
> ++      xhci_dbg(xhci, "// Write DbC event ring dequeue pointer,"
> ++                      " preserving EHB bit\n");
> ++      xhci_write_64(xhci, ((u64)deq & ~(u64)ERST_PTR_MASK) | temp,
> ++                      &xhci->dbg_cap_regs->dcerdp);
> ++}
> ++
> ++/*
> ++ * Set up an endpoint with two ring segments
> ++ */
> ++static int dbc_endpoint_init(struct xhci_hcd *xhci, int in, gfp_t mem_flags)
> ++{
> ++      struct xhci_virt_ep *ep;
> ++      struct xhci_ep_ctx *ep_ctx;
> ++      struct xhci_ring *ep_ring;
> ++      u32 type, burst;
> ++
> ++      xhci_dbg(xhci, "%s()\n", __func__);
> ++
> ++      ep_ring = dbc_ring_alloc(xhci, 2, 1, TYPE_BULK, mem_flags);
> ++      if (!ep_ring)
> ++              return -ENOMEM;
> ++
> ++      if (in) {
> ++              xhci_dbg(xhci, "IN\n");
> ++              xhci->dbc_in_ring = ep_ring;
> ++              ep = &xhci->dbc_in_ep;
> ++              ep_ctx = &xhci->dbg_cap_ctx->in_ep_ctx;
> ++              type = EP_TYPE(BULK_IN_EP);
> ++      } else {
> ++              xhci_dbg(xhci, "OUT\n");
> ++              xhci->dbc_out_ring = ep_ring;
> ++              ep = &xhci->dbc_out_ep;
> ++              ep_ctx = &xhci->dbg_cap_ctx->out_ep_ctx;
> ++              type = EP_TYPE(BULK_OUT_EP);
> ++      }
> ++
> ++      xhci_dbg(xhci, "ring=%p first=%p TRBs=%p (%08llx)\n", ep_ring, ep_ring->first_seg,
> ++              ep_ring->first_seg->trbs, (unsigned long long)ep_ring->first_seg->dma);
> ++      ep->ring = ep_ring;
> ++
> ++      ep_ctx->deq = cpu_to_le64(ep_ring->first_seg->dma | ep_ring->cycle_state);
> ++      ep_ctx->ep_info = 0;
> ++      ep_ctx->ep_info2 = cpu_to_le32(type);
> ++
> ++      /* Set the max packet, max burst, and average TRB length */
> ++      ep_ctx->ep_info2 |= cpu_to_le32(MAX_PACKET(1024));
> ++      burst = xhci_readl(xhci, &xhci->dbg_cap_regs->dcctrl);
> ++      if (burst == 0xffffffff) {
> ++              xhci_err(xhci, "ERROR %s: DbC host controller died\n", __func__);
> ++              dbc_ring_free(xhci, ep_ring);
> ++              if (in)
> ++                      xhci->dbc_in_ring = NULL;
> ++              else
> ++                      xhci->dbc_out_ring = NULL;
> ++              return -ENODEV;
> ++      }
> ++      burst = DCCTRL_MAXBST(burst);
> ++      ep_ctx->ep_info2 |= cpu_to_le32(MAX_BURST(burst));
> ++      ep_ctx->tx_info = cpu_to_le32(AVG_TRB_LENGTH_FOR_EP(1024));
> ++      wmb();
> ++
> ++      xhci_dbg(xhci, "%08x %08x %08x %08x %08x\n", le32_to_cpu(ep_ctx->ep_info),
> ++              le32_to_cpu(ep_ctx->ep_info2), le32_to_cpu(*(__le32 *)&ep_ctx->deq),
> ++              le32_to_cpu(*((__le32 *)&ep_ctx->deq + 1)), le32_to_cpu(ep_ctx->tx_info));
> ++      return 0;
> ++}
> ++
> ++static void dbc_endpoint_deinit(struct xhci_hcd *xhci, int in)
> ++{
> ++      struct xhci_ring *ep_ring;
> ++
> ++      if (in) {
> ++              ep_ring = xhci->dbc_in_ring;
> ++              xhci->dbc_in_ring = NULL;
> ++      } else {
> ++              ep_ring = xhci->dbc_out_ring;
> ++              xhci->dbc_out_ring = NULL;
> ++      }
> ++
> ++      if (ep_ring)
> ++              dbc_ring_free(xhci, ep_ring);
> ++}
> ++
> ++static struct xhci_virt_ep *dbc_epidx_to_ep(struct xhci_hcd *xhci,
> ++              unsigned int ep_index, struct xhci_ep_ctx **ep_ctx_ret)
> ++{
> ++      struct xhci_virt_ep *ep;
> ++      struct xhci_ep_ctx *ep_ctx;
> ++
> ++      xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> ++      switch (ep_index) {
> ++      case 0:
> ++              ep = &xhci->dbc_out_ep;
> ++              ep_ctx = &xhci->dbg_cap_ctx->out_ep_ctx;
> ++              break;
> ++      case 1:
> ++              ep = &xhci->dbc_in_ep;
> ++              ep_ctx = &xhci->dbg_cap_ctx->in_ep_ctx;
> ++              break;
> ++      default:
> ++              return NULL;
> ++      }
> ++
> ++      if (ep_ctx_ret)
> ++              *ep_ctx_ret = ep_ctx;
> ++
> ++      return ep;
> ++}
> ++
> ++static void dbc_ring_ep_doorbell(struct xhci_hcd *xhci, unsigned int ep_index)
> ++{
> ++      u32 temp;
> ++
> ++      xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> ++
> ++      wmb();
> ++      temp = xhci_readl(xhci, &xhci->dbg_cap_regs->dcdb);
> ++      temp |= DCDB_WR_TARGET(ep_index ? 1 : 0);
> ++      xhci_dbg(xhci, "writing %08x to doorbell\n", temp);
> ++      xhci_writel(xhci, temp, &xhci->dbg_cap_regs->dcdb);
> ++}
> ++
> ++/*
> ++ * Find the segment that trb is in. Start searching in start_seg.
> ++ * If we must move past a segment that has a link TRB with a toggle cycle state
> ++ * bit set, then we will toggle the value pointed at by cycle_state.
> ++ */
> ++static struct xhci_segment *dbc_find_trb_seg(struct xhci_segment *start_seg,
> ++              union xhci_trb *trb, int *cycle_state)
> ++{
> ++      struct xhci_segment *cur_seg = start_seg;
> ++      struct xhci_generic_trb *generic_trb;
> ++
> ++      while (cur_seg->trbs > trb ||
> ++                      &cur_seg->trbs[TRBS_PER_SEGMENT - 1] < trb) {
> ++              generic_trb = &cur_seg->trbs[TRBS_PER_SEGMENT - 1].generic;
> ++              if (generic_trb->field[3] & cpu_to_le32(LINK_TOGGLE))
> ++                      *cycle_state ^= 0x1;
> ++              cur_seg = cur_seg->next;
> ++              if (cur_seg == start_seg)
> ++                      /* Looped over the entire list. Oops! */
> ++                      return NULL;
> ++      }
> ++      return cur_seg;
> ++}
> ++
> ++/* Does this link TRB point to the first segment in a ring,
> ++ * or was the previous TRB the last TRB on the last segment in the ERST?
> ++ */
> ++static bool dbc_last_trb_on_last_seg(struct xhci_hcd *xhci,
> ++              struct xhci_ring *ring, struct xhci_segment *seg,
> ++              union xhci_trb *trb)
> ++{
> ++      if (ring == xhci->dbc_event_ring)
> ++              return (trb == &seg->trbs[TRBS_PER_SEGMENT]) &&
> ++                      (seg->next == xhci->dbc_event_ring->first_seg);
> ++      else
> ++              return le32_to_cpu(trb->link.control) & LINK_TOGGLE;
> ++}
> ++
> ++/* Is this TRB a link TRB or was the last TRB the last TRB in this event ring
> ++ * segment? I.e. would the updated event TRB pointer step off the end of the
> ++ * event seg?
> ++ */
> ++static int dbc_last_trb(struct xhci_hcd *xhci, struct xhci_ring *ring,
> ++              struct xhci_segment *seg, union xhci_trb *trb)
> ++{
> ++      if (ring == xhci->dbc_event_ring)
> ++              return trb == &seg->trbs[TRBS_PER_SEGMENT];
> ++      else
> ++              return TRB_TYPE_LINK_LE32(trb->link.control);
> ++}
> ++
> ++static int dbc_enqueue_is_link_trb(struct xhci_ring *ring)
> ++{
> ++      struct xhci_link_trb *link = &ring->enqueue->link;
> ++
> ++      return TRB_TYPE_LINK_LE32(link->control);
> ++}
> ++
> ++/* Updates trb to point to the next TRB in the ring, and updates seg if the next
> ++ * TRB is in a new segment. This does not skip over link TRBs, and it does not
> ++ * affect the ring dequeue or enqueue pointers.
> ++ */
> ++static void dbc_next_trb(struct xhci_hcd *xhci, struct xhci_ring *ring,
> ++              struct xhci_segment **seg, union xhci_trb **trb)
> ++{
> ++      if (dbc_last_trb(xhci, ring, *seg, *trb)) {
> ++              *seg = (*seg)->next;
> ++              *trb = (*seg)->trbs;
> ++      } else {
> ++              (*trb)++;
> ++      }
> ++}
> ++
> ++/*
> ++ * See Cycle bit rules. SW is the consumer for the event ring only.
> ++ * Don't make a ring full of link TRBs. That would be dumb and this would loop.
> ++ */
> ++static void dbc_inc_deq(struct xhci_hcd *xhci, struct xhci_ring *ring)
> ++{
> ++      union xhci_trb *next;
> ++      unsigned long long addr;
> ++
> ++      xhci_dbg(xhci, "%s()\n", __func__);
> ++
> ++      ring->deq_updates++;
> ++
> ++      /* If this is not event ring, there is one more usable TRB */
> ++      if (ring->type != TYPE_EVENT &&
> ++                      !dbc_last_trb(xhci, ring, ring->deq_seg, ring->dequeue)) {
> ++              ring->num_trbs_free++;
> ++              xhci_dbg(xhci, "one less TRB\n");
> ++      }
> ++      next = ++(ring->dequeue);
> ++
> ++      /* Update the dequeue pointer further if that was a link TRB or we're at
> ++       * the end of an event ring segment (which doesn't have link TRBS)
> ++       */
> ++      while (dbc_last_trb(xhci, ring, ring->deq_seg, next)) {
> ++              if (ring->type == TYPE_EVENT && dbc_last_trb_on_last_seg(xhci,
> ++                              ring, ring->deq_seg, next)) {
> ++                      ring->cycle_state = (ring->cycle_state ? 0 : 1);
> ++              }
> ++              ring->deq_seg = ring->deq_seg->next;
> ++              ring->dequeue = ring->deq_seg->trbs;
> ++              next = ring->dequeue;
> ++      }
> ++      addr = (unsigned long long)xhci_trb_virt_to_dma(ring->deq_seg,
> ++                                                      ring->dequeue);
> ++}
> ++
> ++/*
> ++ * See Cycle bit rules. SW is the consumer for the event ring only.
> ++ * Don't make a ring full of link TRBs. That would be dumb and this would loop.
> ++ *
> ++ * If we've just enqueued a TRB that is in the middle of a TD (meaning the
> ++ * chain bit is set), then set the chain bit in all the following link TRBs.
> ++ * If we've enqueued the last TRB in a TD, make sure the following link TRBs
> ++ * have their chain bit cleared (so that each Link TRB is a separate TD).
> ++ *
> ++ * Section 6.4.4.1 of the 0.95 spec says link TRBs cannot have the chain bit
> ++ * set, but other sections talk about dealing with the chain bit set. This was
> ++ * fixed in the 0.96 specification errata, but we have to assume that all 0.95
> ++ * xHCI hardware can't handle the chain bit being cleared on a link TRB.
> ++ *
> ++ * @more_trbs_coming: Will you enqueue more TRBs before calling
> ++ *                    prepare_transfer()?
> ++ */
> ++static void dbc_inc_enq(struct xhci_hcd *xhci, struct xhci_ring *ring,
> ++              bool more_trbs_coming)
> ++{
> ++      union xhci_trb *next;
> ++      unsigned long long addr;
> ++      u32 chain = le32_to_cpu(ring->enqueue->generic.field[3]) & TRB_CHAIN;
> ++
> ++      xhci_dbg(xhci, "%s()\n", __func__);
> ++
> ++      /* If this is not event ring, there is one less usable TRB */
> ++      if (ring->type != TYPE_EVENT &&
> ++                      !dbc_last_trb(xhci, ring, ring->enq_seg, ring->enqueue)) {
> ++              ring->num_trbs_free--;
> ++              xhci_dbg(xhci, "one less TRB\n");
> ++      }
> ++      next = ++(ring->enqueue);
> ++
> ++      ring->enq_updates++;
> ++      /* Update the dequeue pointer further if that was a link TRB or we're at
> ++       * the end of an event ring segment (which doesn't have link TRBS)
> ++       */
> ++      while (dbc_last_trb(xhci, ring, ring->enq_seg, next)) {
> ++              xhci_dbg(xhci, "last TRB\n");
> ++              if (ring->type != TYPE_EVENT) {
> ++                      xhci_dbg(xhci, "not event ring\n");
> ++                      /*
> ++                       * If the caller doesn't plan on enqueueing more
> ++                       * TDs before ringing the doorbell, then we
> ++                       * don't want to give the link TRB to the
> ++                       * hardware just yet. We'll give the link TRB
> ++                       * back in prepare_ring() just before we enqueue
> ++                       * the TD at the top of the ring.
> ++                       */
> ++                      if (!chain && !more_trbs_coming) {
> ++                              xhci_dbg(xhci, "no more TRBs\n");
> ++                              break;
> ++                      }
> ++
> ++                      /* If we're not dealing with 0.95 hardware,
> ++                       * carry over the chain bit of the previous TRB
> ++                       * (which may mean the chain bit is cleared).
> ++                       */
> ++                      if (!xhci_link_trb_quirk(xhci)) {
> ++                              xhci_dbg(xhci, "not link quirk\n");
> ++                              next->link.control &= cpu_to_le32(~TRB_CHAIN);
> ++                              next->link.control |= cpu_to_le32(chain);
> ++                      }
> ++                      /* Give this link TRB to the hardware */
> ++                      wmb();
> ++                      next->link.control ^= cpu_to_le32(TRB_CYCLE);
> ++
> ++                      /* Toggle the cycle bit after the last ring segment */
> ++                      if (dbc_last_trb_on_last_seg(xhci, ring, ring->enq_seg, next)) {
> ++                              xhci_dbg(xhci, "last TRB on last seg\n");
> ++                              ring->cycle_state = (ring->cycle_state ? 0 : 1);
> ++                      }
> ++              }
> ++              ring->enq_seg = ring->enq_seg->next;
> ++              ring->enqueue = ring->enq_seg->trbs;
> ++              next = ring->enqueue;
> ++      }
> ++      addr = (unsigned long long)xhci_trb_virt_to_dma(ring->enq_seg, ring->enqueue);
> ++}
> ++
> ++/*
> ++ * Check to see if there's room to enqueue num_trbs on the ring and make sure
> ++ * enqueue pointer will not advance into dequeue segment. See rules above.
> ++ */
> ++static inline int dbc_room_on_ring(struct xhci_hcd *xhci,
> ++              struct xhci_ring *ring, unsigned int num_trbs)
> ++{
> ++      int num_trbs_in_deq_seg;
> ++
> ++      if (ring->num_trbs_free < num_trbs)
> ++              return 0;
> ++
> ++      if (ring->type != TYPE_COMMAND && ring->type != TYPE_EVENT) {
> ++              num_trbs_in_deq_seg = ring->dequeue - ring->deq_seg->trbs;
> ++              if (ring->num_trbs_free < num_trbs + num_trbs_in_deq_seg)
> ++                      return 0;
> ++      }
> ++
> ++      return 1;
> ++}
> ++
> ++/*
> ++ * The TD size is the number of bytes remaining in the TD (including this TRB),
> ++ * right shifted by 10.
> ++ * It must fit in bits 21:17, so it can't be bigger than 31.
> ++ */
> ++static u32 dbc_td_remainder(unsigned int remainder)
> ++{
> ++      u32 max = (1 << (21 - 17 + 1)) - 1;
> ++
> ++      if ((remainder >> 10) >= max)
> ++              return max << 17;
> ++      else
> ++              return (remainder >> 10) << 17;
> ++}
> ++
> ++/*
> ++ * For xHCI 1.0 host controllers, TD size is the number of packets remaining in
> ++ * the TD (*not* including this TRB)
> ++ *
> ++ * Total TD packet count = total_packet_count =
> ++ *     roundup(TD size in bytes / wMaxPacketSize)
> ++ *
> ++ * Packets transferred up to and including this TRB = packets_transferred =
> ++ *     rounddown(total bytes transferred including this TRB / wMaxPacketSize)
> ++ *
> ++ * TD size = total_packet_count - packets_transferred
> ++ *
> ++ * It must fit in bits 21:17, so it can't be bigger than 31
> ++ */
> ++static u32 dbc_v1_0_td_remainder(int running_total, int trb_buff_len,
> ++              unsigned int total_packet_count, struct urb *urb)
> ++{
> ++      int packets_transferred;
> ++
> ++      /* One TRB with a zero-length data packet */
> ++      if (running_total == 0 && trb_buff_len == 0)
> ++              return 0;
> ++
> ++      /* All the TRB queueing functions don't count the current TRB in
> ++       * running_total.
> ++       */
> ++      packets_transferred = (running_total + trb_buff_len) / 1024;
> ++
> ++      return dbc_td_remainder(total_packet_count - packets_transferred);
> ++}
> ++
> ++/*
> ++ * Generic function for queueing a TRB on a ring.
> ++ * The caller must have checked to make sure there's room on the ring.
> ++ *
> ++ * @more_trbs_coming: Will you enqueue more TRBs before calling
> ++ *                    prepare_transfer()?
> ++ */
> ++static void dbc_queue_trb(struct xhci_hcd *xhci, struct xhci_ring *ring,
> ++              bool more_trbs_coming, u32 field1, u32 field2, u32 field3,
> ++              u32 field4)
> ++{
> ++      struct xhci_generic_trb *trb = &ring->enqueue->generic;
> ++
> ++      xhci_dbg(xhci, "%s()\n", __func__);
> ++      trb->field[0] = cpu_to_le32(field1);
> ++      trb->field[1] = cpu_to_le32(field2);
> ++      trb->field[2] = cpu_to_le32(field3);
> ++      trb->field[3] = cpu_to_le32(field4);
> ++      xhci_dbg(xhci, "0x%08x 0x%08x 0x%08x 0x%08x\n", le32_to_cpu(trb->field[0]),
> ++                      le32_to_cpu(trb->field[1]), le32_to_cpu(trb->field[2]),
> ++                      le32_to_cpu(trb->field[3]));
> ++
> ++      dbc_inc_enq(xhci, ring, more_trbs_coming);
> ++}
> ++
> ++static void dbc_check_trb_math(struct xhci_hcd *xhci, struct urb *urb,
> ++              unsigned int ep_index, int num_trbs, int running_total)
> ++{
> ++      xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> ++
> ++      if (num_trbs != 0)
> ++              xhci_err(xhci, "%s - ep %#x - Miscalculated number of"
> ++                              " TRBs, %d left\n", __func__,
> ++                              ep_index ? 0x81 : 0x01, num_trbs);
> ++      if (running_total != urb->transfer_buffer_length)
> ++              xhci_err(xhci, "%s - ep %#x - Miscalculated tx length,"
> ++                              " queued %#x (%d), asked for %#x (%d)\n",
> ++                              __func__,
> ++                              ep_index ? 0x81 : 0x01,
> ++                              running_total, running_total,
> ++                              urb->transfer_buffer_length,
> ++                              urb->transfer_buffer_length);
> ++}
> ++
> ++static void dbc_giveback_first_trb(struct xhci_hcd *xhci, unsigned int ep_index,
> ++              int start_cycle, struct xhci_generic_trb *start_trb)
> ++{
> ++      xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> ++      /*
> ++       * Pass all the TRBs to the hardware at once and make sure this write
> ++       * isn't reordered.
> ++       */
> ++      wmb();
> ++      if (start_cycle) {
> ++              xhci_dbg(xhci, "start cycle\n");
> ++              start_trb->field[3] |= cpu_to_le32(start_cycle);
> ++      } else {
> ++              xhci_dbg(xhci, "not start cycle\n");
> ++              start_trb->field[3] &= cpu_to_le32(~TRB_CYCLE);
> ++      }
> ++      xhci_dbg(xhci, "field[3] = 0x%08x\n", le32_to_cpu(start_trb->field[3]));
> ++      wmb();
> ++      dbc_ring_ep_doorbell(xhci, ep_index);
> ++}
> ++
> ++/* This is very similar to what ehci-q.c qtd_fill() does */
> ++static int dbc_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
> ++              struct urb *urb, unsigned int ep_index)
> ++{
> ++      struct xhci_ring *ep_ring;
> ++      struct urb_priv *urb_priv;
> ++      struct xhci_td *td;
> ++      struct xhci_generic_trb *start_trb;
> ++      struct list_head *urb_list;
> ++      int num_trbs;
> ++      bool first_trb;
> ++      bool more_trbs_coming;
> ++      int start_cycle;
> ++      u32 field, length_field;
> ++      int running_total, trb_buff_len, tmp;
> ++      unsigned int total_packet_count;
> ++      u64 addr;
> ++
> ++      xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> ++      xhci_dbg(xhci, "URB=%p\n", urb);
> ++
> ++      if (ep_index == 0) {
> ++              ep_ring = xhci->dbc_out_ring;
> ++              urb_list = &xhci->dbc_out_urb_list;
> ++      } else {
> ++              ep_ring = xhci->dbc_in_ring;
> ++              urb_list = &xhci->dbc_in_urb_list;
> ++      }
> ++
> ++      if (!ep_ring) {
> ++              xhci_err(xhci, "ERROR: no EP ring\n");
> ++              return -EINVAL;
> ++      }
> ++
> ++      xhci_dbg(xhci, "ring=%p first=%p TRBs=%p (%08llx)\n", ep_ring, ep_ring->first_seg,
> ++              ep_ring->first_seg->trbs, (unsigned long long)ep_ring->first_seg->dma);
> ++
> ++      num_trbs = 0;
> ++      /* How much data is (potentially) left before the 64KB boundary? */
> ++      running_total = TRB_MAX_BUFF_SIZE -
> ++              (urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
> ++      running_total &= TRB_MAX_BUFF_SIZE - 1;
> ++      xhci_dbg(xhci, "runtot 1 = %d\n", running_total);
> ++
> ++      /* If there's some data on this 64KB chunk, or we have to send a
> ++       * zero-length transfer, we need at least one TRB
> ++       */
> ++      if (running_total != 0 || urb->transfer_buffer_length == 0)
> ++              num_trbs++;
> ++      /* How many more 64KB chunks to transfer, how many more TRBs? */
> ++      while (running_total < urb->transfer_buffer_length) {
> ++              num_trbs++;
> ++              running_total += TRB_MAX_BUFF_SIZE;
> ++      }
> ++      /* FIXME: this doesn't deal with URB_ZERO_PACKET - need one more */
> ++      xhci_dbg(xhci, "runtot 2 = %d, trbs = %d\n", running_total, num_trbs);
> ++
> ++      if (!dbc_room_on_ring(xhci, ep_ring, num_trbs)) {
> ++              xhci_err(xhci, "ERROR: no room on ring\n");
> ++              return -ENOMEM;
> ++      }
> ++
> ++      if (dbc_enqueue_is_link_trb(ep_ring)) {
> ++              struct xhci_ring *ring = ep_ring;
> ++              union xhci_trb *next;
> ++
> ++              xhci_dbg(xhci, "enqueue is link trb\n");
> ++              next = ring->enqueue;
> ++
> ++              while (dbc_last_trb(xhci, ring, ring->enq_seg, next)) {
> ++                      /* If we're not dealing with 0.95 hardware,
> ++                       * clear the chain bit.
> ++                       */
> ++                      if (!xhci_link_trb_quirk(xhci))
> ++                              next->link.control &= cpu_to_le32(~TRB_CHAIN);
> ++                      else
> ++                              next->link.control |= cpu_to_le32(TRB_CHAIN);
> ++
> ++                      wmb();
> ++                      next->link.control ^= cpu_to_le32(TRB_CYCLE);
> ++
> ++                      /* Toggle the cycle bit after the last ring segment */
> ++                      if (dbc_last_trb_on_last_seg(xhci, ring, ring->enq_seg, next)) {
> ++                              ring->cycle_state = (ring->cycle_state ? 0 : 1);
> ++                      }
> ++                      ring->enq_seg = ring->enq_seg->next;
> ++                      ring->enqueue = ring->enq_seg->trbs;
> ++                      next = ring->enqueue;
> ++              }
> ++      }
> ++
> ++      urb_priv = urb->hcpriv;
> ++      td = urb_priv->td[0];
> ++      xhci_dbg(xhci, "TD=%p\n", td);
> ++
> ++      INIT_LIST_HEAD(&td->td_list);
> ++      INIT_LIST_HEAD(&td->cancelled_td_list);
> ++
> ++      urb->unlinked = 0;
> ++      list_add_tail(&urb->urb_list, urb_list);
> ++
> ++      td->urb = urb;
> ++      /* Add this TD to the tail of the endpoint ring's TD list */
> ++      list_add_tail(&td->td_list, &ep_ring->td_list);
> ++      td->start_seg = ep_ring->enq_seg;
> ++      xhci_dbg(xhci, "start_seg=%p\n", td->start_seg);
> ++      td->first_trb = ep_ring->enqueue;
> ++
> ++      /*
> ++       * Don't give the first TRB to the hardware (by toggling the cycle bit)
> ++       * until we've finished creating all the other TRBs. The ring's cycle
> ++       * state may change as we enqueue the other TRBs, so save it too.
> ++       */
> ++      start_trb = &ep_ring->enqueue->generic;
> ++      xhci_dbg(xhci, "TRB=%p\n", start_trb);
> ++      start_cycle = ep_ring->cycle_state;
> ++      xhci_dbg(xhci, "cycle=%d\n", start_cycle);
> ++
> ++      running_total = 0;
> ++      total_packet_count = roundup(urb->transfer_buffer_length, 1024);
> ++
> ++      /* How much data is in the first TRB? */
> ++      addr = (u64)urb->transfer_dma;
> ++      trb_buff_len = TRB_MAX_BUFF_SIZE -
> ++              (urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
> ++      if (trb_buff_len > urb->transfer_buffer_length)
> ++              trb_buff_len = urb->transfer_buffer_length;
> ++
> ++      first_trb = true;
> ++
> ++      /* Queue the first TRB, even if it's zero-length */
> ++      do {
> ++              u32 remainder = 0;
> ++
> ++              field = 0;
> ++
> ++              /* Don't change the cycle bit of the first TRB until later */
> ++              if (first_trb) {
> ++                      first_trb = false;
> ++                      if (start_cycle == 0)
> ++                              field |= 0x1;
> ++              } else
> ++                      field |= ep_ring->cycle_state;
> ++
> ++              /* Chain all the TRBs together; clear the chain bit in the last
> ++               * TRB to indicate it's the last TRB in the chain.
> ++               */
> ++              if (num_trbs > 1) {
> ++                      field |= TRB_CHAIN;
> ++              } else {
> ++                      /* FIXME - add check for ZERO_PACKET flag before this */
> ++                      td->last_trb = ep_ring->enqueue;
> ++                      field |= TRB_IOC;
> ++              }
> ++
> ++              field |= TRB_ISP;
> ++
> ++              /* Set the TRB length, TD size, and interrupter fields */
> ++              if (xhci->hci_version < 0x100) {
> ++                      xhci_dbg(xhci, "is not 1.0 host\n");
> ++                      remainder = 0; /*dbc_td_remainder(
> ++                                      urb->transfer_buffer_length -
> ++                                      running_total);*/
> ++              } else {
> ++                      xhci_dbg(xhci, "is 1.0 host\n");
> ++                      remainder = 0; /*dbc_v1_0_td_remainder(running_total,
> ++                                      trb_buff_len, total_packet_count, urb);*/
> ++              }
> ++              if (ep_index)
> ++                      tmp = trb_buff_len >= 1024 ? trb_buff_len : 1024;
> ++              else
> ++                      tmp = trb_buff_len;
> ++              xhci_dbg(xhci, "TRB len = %d\n", tmp);
> ++              length_field = TRB_LEN(tmp) | remainder |
> ++                              TRB_INTR_TARGET(0);
> ++
> ++              if (num_trbs > 1)
> ++                      more_trbs_coming = true;
> ++              else
> ++                      more_trbs_coming = false;
> ++              dbc_queue_trb(xhci, ep_ring, more_trbs_coming,
> ++                              lower_32_bits(addr),
> ++                              upper_32_bits(addr),
> ++                              length_field,
> ++                              field | TRB_TYPE(TRB_NORMAL));
> ++              --num_trbs;
> ++              running_total += trb_buff_len;
> ++
> ++              /* Calculate length for next transfer */
> ++              addr += trb_buff_len;
> ++              trb_buff_len = urb->transfer_buffer_length - running_total;
> ++              if (trb_buff_len > TRB_MAX_BUFF_SIZE)
> ++                      trb_buff_len = TRB_MAX_BUFF_SIZE;
> ++      } while (running_total < urb->transfer_buffer_length);
> ++
> ++      dbc_check_trb_math(xhci, urb, ep_index, num_trbs, running_total);
> ++      dbc_giveback_first_trb(xhci, ep_index, start_cycle, start_trb);
> ++//    xhci_debug_segment(xhci, td->start_seg);
> ++      xhci_dbg(xhci, "first OUT segment:\n");
> ++      xhci_debug_segment(xhci, xhci->dbc_out_ring->first_seg);
> ++      xhci_dbg(xhci, "last OUT segment:\n");
> ++      xhci_debug_segment(xhci, xhci->dbc_out_ring->last_seg);
> ++      xhci_dbg(xhci, "first IN segment:\n");
> ++      xhci_debug_segment(xhci, xhci->dbc_in_ring->first_seg);
> ++      xhci_dbg(xhci, "last IN segment:\n");
> ++      xhci_debug_segment(xhci, xhci->dbc_in_ring->last_seg);
> ++      return 0;
> ++}
> ++
> ++/*
> ++ * non-error returns are a promise to giveback() the urb later
> ++ * we drop ownership so next owner (or urb unlink) can get it
> ++ */
> ++static int dbc_urb_enqueue(struct xhci_hcd *xhci, struct urb *urb,
> ++              unsigned int ep_index, gfp_t mem_flags)
> ++{
> ++      struct xhci_td *buffer;
> ++      struct urb_priv *urb_priv;
> ++      int ret = 0;
> ++
> ++      xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> ++      if (!urb)
> ++              return -EINVAL;
> ++
> ++      urb_priv = kzalloc(sizeof(struct urb_priv) +
> ++                      sizeof(struct xhci_td *), mem_flags);
> ++      if (!urb_priv)
> ++              return -ENOMEM;
> ++
> ++      buffer = kzalloc(sizeof(struct xhci_td), mem_flags);
> ++      if (!buffer) {
> ++              kfree(urb_priv);
> ++              return -ENOMEM;
> ++      }
> ++
> ++      urb_priv->td[0] = buffer;
> ++      urb_priv->length = 1;
> ++      urb_priv->td_cnt = 0;
> ++      urb->hcpriv = urb_priv;
> ++
> ++      if (xhci->xhc_state & XHCI_STATE_DYING)
> ++              goto dying;
> ++      ret = dbc_queue_bulk_tx(xhci, mem_flags, urb, ep_index);
> ++      if (ret)
> ++              goto free_priv;
> ++
> ++      return ret;
> ++
> ++dying:
> ++      xhci_dbg(xhci, "ep %#x: URB %p submitted for "
> ++                      "non-responsive xHCI host.\n",
> ++                      ep_index ? 0x81 : 0x01, urb);
> ++      ret = -ESHUTDOWN;
> ++
> ++free_priv:
> ++      xhci_urb_free_priv(xhci, urb_priv);
> ++      urb->hcpriv = NULL;
> ++      return ret;
> ++}
> ++
> ++/**
> ++ * dbc_hcd_giveback_urb - return URB from HCD to device driver
> ++ * @hcd: host controller returning the URB
> ++ * @urb: urb being returned to the USB device driver.
> ++ * @status: completion status code for the URB.
> ++ * Context: in_interrupt()
> ++ *
> ++ * This hands the URB from HCD to its USB device driver, using its
> ++ * completion function.  The HCD has freed all per-urb resources
> ++ * (and is done using urb->hcpriv).  It also released all HCD locks;
> ++ * the device driver won't cause problems if it frees, modifies,
> ++ * or resubmits this URB.
> ++ *
> ++ * If @urb was unlinked, the value of @status will be overridden by
> ++ * @urb->unlinked.  Erroneous short transfers are detected in case
> ++ * the HCD hasn't checked for them.
> ++ */
> ++static void dbc_giveback_urb(struct xhci_hcd *xhci, struct urb *urb, int status)
> ++{
> ++      xhci_dbg(xhci, "%s()\n", __func__);
> ++      urb->hcpriv = NULL;
> ++
> ++      if (unlikely(urb->unlinked))
> ++              status = urb->unlinked;
> ++      else if (unlikely((urb->transfer_flags & URB_SHORT_NOT_OK) &&
> ++                      urb->actual_length < urb->transfer_buffer_length &&
> ++                      !status))
> ++              status = -EREMOTEIO;
> ++
> ++      /* pass ownership to the completion handler */
> ++      urb->status = status;
> ++      urb->complete(urb);
> ++}
> ++
> ++/*
> ++ * Move the xHC's endpoint ring dequeue pointer past cur_td.
> ++ * Record the new state of the xHC's endpoint ring dequeue segment,
> ++ * dequeue pointer, and new consumer cycle state in state.
> ++ * Update our internal representation of the ring's dequeue pointer.
> ++ *
> ++ * We do this in three jumps:
> ++ *  - First we update our new ring state to be the same as when the xHC stopped.
> ++ *  - Then we traverse the ring to find the segment that contains
> ++ *    the last TRB in the TD. We toggle the xHC's new cycle state when we pass
> ++ *    any link TRBs with the toggle cycle bit set.
> ++ *  - Finally we move the dequeue state one TRB further, toggling the cycle bit
> ++ *    if we've moved it past a link TRB with the toggle cycle bit set.
> ++ *
> ++ * Some of the uses of xhci_generic_trb are grotty, but if they're done with
> ++ * correct __le32 accesses they should work fine. Only users of this are
> ++ * in here.
> ++ */
> ++static void dbc_find_new_dequeue_state(struct xhci_hcd *xhci,
> ++              unsigned int ep_index, struct xhci_td *cur_td,
> ++              struct xhci_dequeue_state *state)
> ++{
> ++      dma_addr_t addr;
> ++      struct xhci_ring *ep_ring;
> ++      struct xhci_ep_ctx *ep_ctx;
> ++      struct xhci_generic_trb *trb;
> ++      struct xhci_virt_ep *ep;
> ++
> ++      xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> ++
> ++      ep = dbc_epidx_to_ep(xhci, ep_index, &ep_ctx);
> ++      if (!ep) {
> ++              WARN_ON(1);
> ++              return;
> ++      }
> ++
> ++      ep_ring = ep->ring;
> ++      if (!ep_ring) {
> ++              WARN_ON(1);
> ++              return;
> ++      }
> ++
> ++      state->new_cycle_state = 0;
> ++      xhci_dbg(xhci, "Finding segment containing stopped TRB\n");
> ++      state->new_deq_seg = dbc_find_trb_seg(cur_td->start_seg,
> ++                      ep->stopped_trb, &state->new_cycle_state);
> ++      if (!state->new_deq_seg) {
> ++              WARN_ON(1);
> ++              return;
> ++      }
> ++
> ++      /* Dig out the cycle state saved by the xHC during the stop ep cmd */
> ++      state->new_cycle_state = le64_to_cpu(ep_ctx->deq) & 0x1;
> ++
> ++      state->new_deq_ptr = cur_td->last_trb;
> ++      xhci_dbg(xhci, "Finding segment containing last TRB in TD\n");
> ++      state->new_deq_seg = dbc_find_trb_seg(state->new_deq_seg,
> ++                      state->new_deq_ptr, &state->new_cycle_state);
> ++      if (!state->new_deq_seg) {
> ++              WARN_ON(1);
> ++              return;
> ++      }
> ++
> ++      trb = &state->new_deq_ptr->generic;
> ++      if (TRB_TYPE_LINK_LE32(trb->field[3]) &&
> ++                      (trb->field[3] & cpu_to_le32(LINK_TOGGLE)))
> ++              state->new_cycle_state ^= 0x1;
> ++      dbc_next_trb(xhci, ep_ring, &state->new_deq_seg, &state->new_deq_ptr);
> ++
> ++      /*
> ++       * If there is only one segment in a ring, find_trb_seg()'s while loop
> ++       * will not run, and it will return before it has a chance to see if it
> ++       * needs to toggle the cycle bit. It can't tell if the stalled transfer
> ++       * ended just before the link TRB on a one-segment ring, or if the TD
> ++       * wrapped around the top of the ring, because it doesn't have the TD in
> ++       * question. Look for the one-segment case where stalled TRB's address
> ++       * is greater than the new dequeue pointer address.
> ++       */
> ++      if (ep_ring->first_seg == ep_ring->first_seg->next &&
> ++                      state->new_deq_ptr < ep->stopped_trb)
> ++              state->new_cycle_state ^= 0x1;
> ++      xhci_dbg(xhci, "Cycle state = 0x%x\n", state->new_cycle_state);
> ++
> ++      /* Don't update the ring cycle state for the producer (us) */
> ++      xhci_dbg(xhci, "New dequeue segment = %p (virtual)\n",
> ++                      state->new_deq_seg);
> ++      addr = xhci_trb_virt_to_dma(state->new_deq_seg, state->new_deq_ptr);
> ++      xhci_dbg(xhci, "New dequeue pointer = 0x%llx (DMA)\n",
> ++                      (unsigned long long)addr);
> ++}
> ++
> ++static void dbc_set_new_dequeue_state(struct xhci_hcd *xhci,
> ++              unsigned int ep_index, struct xhci_dequeue_state *deq_state)
> ++{
> ++      dma_addr_t addr;
> ++      struct xhci_ep_ctx *ep_ctx;
> ++      struct xhci_virt_ep *ep;
> ++
> ++      xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> ++
> ++      ep = dbc_epidx_to_ep(xhci, ep_index, &ep_ctx);
> ++      if (!ep) {
> ++              xhci_err(xhci, "ERROR %s: bad DbC endpoint index %d\n",
> ++                              __func__, ep_index);
> ++              return;
> ++      }
> ++
> ++      addr = xhci_trb_virt_to_dma(deq_state->new_deq_seg,
> ++                      deq_state->new_deq_ptr);
> ++      if (addr == 0) {
> ++              xhci_warn(xhci, "WARN %s: Cannot set TR Deq Ptr\n", __func__);
> ++              return;
> ++      }
> ++
> ++      xhci_dbg(xhci, "Set TR Deq Ptr, new deq seg = %p (%llx dma),"
> ++                      " new deq ptr = %p (%llx dma), new cycle = %u\n",
> ++                      deq_state->new_deq_seg,
> ++                      (unsigned long long)deq_state->new_deq_seg->dma,
> ++                      deq_state->new_deq_ptr,
> ++                      (unsigned long long)xhci_trb_virt_to_dma(
> ++                                      deq_state->new_deq_seg,
> ++                                      deq_state->new_deq_ptr),
> ++                      deq_state->new_cycle_state);
> ++
> ++      ep_ctx->deq = cpu_to_le64(addr);
> ++      wmb();
> ++}
> ++
> ++static void dbc_cleanup_stalled_ring(struct xhci_hcd *xhci,
> ++              unsigned int ep_index)
> ++{
> ++      struct xhci_dequeue_state deq_state = { 0 };
> ++      struct xhci_virt_ep *ep;
> ++
> ++      xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> ++
> ++      ep = dbc_epidx_to_ep(xhci, ep_index, NULL);
> ++      if (!ep) {
> ++              xhci_err(xhci, "ERROR %s: bad DbC endpoint index %d\n",
> ++                              __func__, ep_index);
> ++              return;
> ++      }
> ++
> ++      /* We need to move the HW's dequeue pointer past this TD,
> ++       * or it will attempt to resend it on the next doorbell ring.
> ++       */
> ++      dbc_find_new_dequeue_state(xhci, ep_index, ep->stopped_td, &deq_state);
> ++
> ++      xhci_dbg(xhci, "Setting new dequeue state\n");
> ++      dbc_set_new_dequeue_state(xhci, ep_index, &deq_state);
> ++}
> ++
> ++static void dbc_cleanup_halted_endpoint(struct xhci_hcd *xhci,
> ++              unsigned int ep_index, struct xhci_td *td,
> ++              union xhci_trb *event_trb)
> ++{
> ++      struct xhci_virt_ep *ep;
> ++
> ++      xhci_dbg(xhci, "%s(), ep_index=%d\n", __func__, ep_index);
> ++
> ++      ep = dbc_epidx_to_ep(xhci, ep_index, NULL);
> ++      if (!ep) {
> ++              xhci_err(xhci, "ERROR %s: bad DbC endpoint index %d\n",
> ++                              __func__, ep_index);
> ++              return;
> ++      }
> ++
> ++      ep->ep_state |= EP_HALTED;
> ++      ep->stopped_td = td;
> ++      ep->stopped_trb = event_trb;
> ++
> ++      dbc_cleanup_stalled_ring(xhci, ep_index);
> ++
> ++      ep->stopped_td = NULL;
> ++      ep->stopped_trb = NULL;
> ++
> ++      dbc_ring_ep_doorbell(xhci, ep_index);
> ++}
> ++
> ++/* Check if an error has halted the endpoint ring. The class driver will
> ++ * cleanup the halt for a non-default control endpoint if we indicate a stall.
> ++ * However, a babble and other errors also halt the endpoint ring, and the class
> ++ * driver won't clear the halt in that case, so we need to issue a Set Transfer
> ++ * Ring Dequeue Pointer command manually.
> ++ */
> ++static int dbc_requires_manual_halt_cleanup(struct xhci_hcd *xhci,
> ++              struct xhci_ep_ctx *ep_ctx, unsigned int trb_comp_code)
> ++{
> ++      /* TRB completion codes that may require a manual halt cleanup */
> ++      if (trb_comp_code == COMP_TX_ERR ||
> ++                      trb_comp_code == COMP_BABBLE ||
> ++                      trb_comp_code == COMP_SPLIT_ERR)
> ++              /* The 0.96 spec says a babbling control endpoint
> ++               * is not halted. The 0.96 spec says it is. Some HW
> ++               * claims to be 0.95 compliant, but it halts the control
> ++               * endpoint anyway. Check if a babble halted the endpoint.
> ++               */
> ++              if ((ep_ctx->ep_info & cpu_to_le32(EP_STATE_MASK)) ==
> ++                              cpu_to_le32(EP_STATE_HALTED))
> ++                      return 1;
> ++
> ++      return 0;
> ++}
> ++
> ++/*
> ++ * Finish the td processing, remove the td from td list;
> ++ * Return 1 if the urb can be given back.
> ++ */
> ++static int dbc_finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
> ++              union xhci_trb *event_trb, struct xhci_transfer_event *event,
> ++              struct xhci_virt_ep *ep, struct xhci_ep_ctx *ep_ctx,
> ++              int *status, bool skip)
> ++{
> ++      struct xhci_ring *ep_ring;
> ++      unsigned int ep_index;
> ++      struct urb *urb = NULL;
> ++      struct urb_priv *urb_priv;
> ++      u32 trb_comp_code;
> ++      int ret = 0;
> ++
> ++      xhci_dbg(xhci, "%s()\n", __func__);
> ++      ep_index = TRB_TO_EP_ID(le32_to_cpu(event->flags)) - 1;
> ++      xhci_dbg(xhci, "ep_index=%d\n", ep_index);
> ++      ep_ring = ep->ring;
> ++      trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
> ++
> ++      if (skip)
> ++              goto td_cleanup;
> ++
> ++      if (trb_comp_code == COMP_STOP_INVAL ||
> ++                      trb_comp_code == COMP_STOP) {
> ++              /* The Endpoint Stop Command completion will take care of any
> ++               * stopped TDs. A stopped TD may be restarted, so don't update
> ++               * the ring dequeue pointer or take this TD off any lists yet.
> ++               */
> ++              ep->stopped_td = td;
> ++              ep->stopped_trb = event_trb;
> ++              xhci_dbg(xhci, "INVAL/STOP, returning 0\n");
> ++              return 0;
> ++      } else {
> ++              if (trb_comp_code == COMP_STALL) {
> ++                      /* The transfer is completed from the driver's
> ++                       * perspective, but we need to issue a set dequeue
> ++                       * command for this stalled endpoint to move the dequeue
> ++                       * pointer past the TD. We can't do that here because
> ++                       * the halt condition must be cleared first. Let the
> ++                       * USB class driver clear the stall later.
> ++                       */
> ++                      ep->stopped_td = td;
> ++                      ep->stopped_trb = event_trb;
> ++              } else if (dbc_requires_manual_halt_cleanup(xhci,
> ++                                      ep_ctx, trb_comp_code)) {
> ++                      /* Other types of errors halt the endpoint, but the
> ++                       * class driver doesn't call usb_reset_endpoint() unless
> ++                       * the error is -EPIPE. Clear the halted status in the
> ++                       * xHCI hardware manually.
> ++                       */
> ++                      dbc_cleanup_halted_endpoint(xhci,
> ++                                      ep_index, td, event_trb);
> ++              } else {
> ++                      /* Update ring dequeue pointer */
> ++                      while (ep_ring->dequeue != td->last_trb)
> ++                              dbc_inc_deq(xhci, ep_ring);
> ++                      dbc_inc_deq(xhci, ep_ring);
> ++              }
> ++
> ++td_cleanup:
> ++              /* Clean up the endpoint's TD list */
> ++              urb = td->urb;
> ++              urb_priv = urb->hcpriv;
> ++
> ++              /* Do one last check of the actual transfer length.
> ++               * If the host controller said we transferred more data than
> ++               * the buffer length, urb->actual_length will be a very big
> ++               * number (since it's unsigned). Play it safe and say we didn't
> ++               * transfer anything.
> ++               */
> ++              if (urb->actual_length > urb->transfer_buffer_length) {
> ++                      xhci_warn(xhci, "WARN: URB transfer length is wrong,"
> ++                                      " xHC issue? req. len = %u,"
> ++                                      " act. len = %u\n",
> ++                                      urb->transfer_buffer_length,
> ++                                      urb->actual_length);
> ++                      urb->actual_length = 0;
> ++                      if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
> ++                              *status = -EREMOTEIO;
> ++                      else
> ++                              *status = 0;
> ++              }
> ++              list_del_init(&td->td_list);
> ++              /* Was this TD slated to be cancelled but completed anyway? */
> ++              if (!list_empty(&td->cancelled_td_list))
> ++                      list_del_init(&td->cancelled_td_list);
> ++
> ++              urb_priv->td_cnt++;
> ++              /* Giveback the urb when all the tds are completed */
> ++              if (urb_priv->td_cnt == urb_priv->length)
> ++                      ret = 1;
> ++      }
> ++
> ++      xhci_dbg(xhci, "returning %d\n", ret);
> ++      return ret;
> ++}
> ++
> ++/*
> ++ * Process bulk and interrupt tds, update urb status and actual_length
> ++ */
> ++static int dbc_process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
> ++              union xhci_trb *event_trb, struct xhci_transfer_event *event,
> ++              struct xhci_virt_ep *ep, struct xhci_ep_ctx *ep_ctx, int *status)
> ++{
> ++      struct xhci_ring *ep_ring;
> ++      union xhci_trb *cur_trb;
> ++      struct xhci_segment *cur_seg;
> ++      unsigned int ep_index;
> ++      u32 trb_comp_code;
> ++
> ++      xhci_dbg(xhci, "%s()\n", __func__);
> ++      ep_ring = ep->ring;
> ++      trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
> ++      xhci_dbg(xhci, "cmpl_code=%d\n", trb_comp_code);
> ++
> ++      switch (trb_comp_code) {
> ++      case COMP_SUCCESS:
> ++              /* Double check that the HW transferred everything */
> ++              if (event_trb != td->last_trb ||
> ++                              TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
> ++                      xhci_warn(xhci, "WARN: successful completion"
> ++                                      " on short TX\n");
> ++                      if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
> ++                              *status = -EREMOTEIO;
> ++                      else
> ++                              *status = 0;
> ++                      if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
> ++                              trb_comp_code = COMP_SHORT_TX;
> ++              } else {
> ++                      *status = 0;
> ++              }
> ++              break;
> ++      case COMP_SHORT_TX:
> ++              if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
> ++                      *status = -EREMOTEIO;
> ++              else
> ++                      *status = 0;
> ++              break;
> ++      default:
> ++              /* Others already handled above */
> ++              break;
> ++      }
> ++
> ++      ep_index = TRB_TO_EP_ID(le32_to_cpu(event->flags)) - 1;
> ++      xhci_dbg(xhci, "ep_index=%d\n", ep_index);
> ++
> ++      if (trb_comp_code == COMP_SHORT_TX)
> ++              xhci_dbg(xhci, "ep %#x - asked for %d bytes,"
> ++                              " %d bytes untransferred\n",
> ++                              ep_index ? 0x81 : 0x01,
> ++                              td->urb->transfer_buffer_length,
> ++                              TRB_LEN(le32_to_cpu(event->transfer_len)));
> ++      /* Fast path - was this the last TRB in the TD for this URB? */
> ++      if (event_trb == td->last_trb) {
> ++              if (TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
> ++                      td->urb->actual_length =
> ++                              td->urb->transfer_buffer_length -
> ++                              TRB_LEN(le32_to_cpu(event->transfer_len));
> ++                      if (td->urb->transfer_buffer_length <
> ++                                      td->urb->actual_length) {
> ++                              xhci_warn(xhci, "WARN: HC gave bad length of"
> ++                                      " %d bytes left\n",
> ++                                      TRB_LEN(le32_to_cpu(event->transfer_len)));
> ++                              td->urb->actual_length = 0;
> ++                              if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
> ++                                      *status = -EREMOTEIO;
> ++                              else
> ++                                      *status = 0;
> ++                      }
> ++                      /* Don't overwrite a previously set error code */
> ++                      if (*status == -EINPROGRESS) {
> ++                              if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
> ++                                      *status = -EREMOTEIO;
> ++                              else
> ++                                      *status = 0;
> ++                      }
> ++              } else {
> ++                      td->urb->actual_length =
> ++                              td->urb->transfer_buffer_length;
> ++                      /* Ignore a short packet completion if the
> ++                       * untransferred length was zero.
> ++                       */
> ++                      if (*status == -EREMOTEIO)
> ++                              *status = 0;
> ++              }
> ++      } else {
> ++              /* Slow path - walk the list, starting from the dequeue
> ++               * pointer, to get the actual length transferred.
> ++               */
> ++              td->urb->actual_length = 0;
> ++              for (cur_trb = ep_ring->dequeue, cur_seg = ep_ring->deq_seg;
> ++                              cur_trb != event_trb;
> ++                              dbc_next_trb(xhci, ep_ring, &cur_seg, &cur_trb)) {
> ++                      if (!TRB_TYPE_NOOP_LE32(cur_trb->generic.field[3]) &&
> ++                          !TRB_TYPE_LINK_LE32(cur_trb->generic.field[3]))
> ++                              td->urb->actual_length +=
> ++                                      TRB_LEN(le32_to_cpu(cur_trb->generic.field[2]));
> ++              }
> ++              /* If the ring didn't stop on a Link or No-op TRB, add
> ++               * in the actual bytes transferred from the Normal TRB
> ++               */
> ++              if (trb_comp_code != COMP_STOP_INVAL)
> ++                      td->urb->actual_length +=
> ++                              TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
> ++                              TRB_LEN(le32_to_cpu(event->transfer_len));
> ++      }
> ++
> ++      return dbc_finish_td(xhci, td, event_trb, event, ep, ep_ctx, status,
> ++                      false);
> ++}
> ++
> ++/*
> ++ * If this function returns an error condition, it means it got a Transfer
> ++ * event with a corrupted Slot ID, Endpoint ID, or TRB DMA address.
> ++ * At this point, the host controller is probably hosed and should be reset.
> ++ */
> ++static int dbc_handle_tx_event(struct xhci_hcd *xhci,
> ++              struct xhci_transfer_event *event)
> ++{
> ++      struct xhci_virt_ep *ep;
> ++      struct xhci_ep_ctx *ep_ctx;
> ++      struct xhci_ring *ep_ring;
> ++      struct urb *urb;
> ++      struct urb_priv *urb_priv;
> ++      struct xhci_td *td = NULL;
> ++      dma_addr_t event_dma;
> ++      struct xhci_segment *event_seg;
> ++      union xhci_trb *event_trb;
> ++      u32 trb_comp_code;
> ++      unsigned int ep_index;
> ++      int ret = 0;
> ++      int status = -EINPROGRESS;
> ++
> ++      xhci_dbg(xhci, "%s()\n", __func__);
> ++      ep_index = TRB_TO_EP_ID(le32_to_cpu(event->flags)) - 1;
> ++      xhci_dbg(xhci, "ep_index=%d\n", ep_index);
> ++
> ++      ep = dbc_epidx_to_ep(xhci, ep_index, &ep_ctx);
> ++      if (!ep) {
> ++              xhci_err(xhci, "ERROR %s: bad DbC endpoint index %d\n",
> ++                              __func__, ep_index);
> ++              return -EINVAL;
> ++      }
> ++
> ++      ep_ring = ep->ring;
> ++
> ++      if (!ep_ring || (le32_to_cpu(ep_ctx->ep_info) & EP_STATE_MASK) ==
> ++                      EP_STATE_DISABLED) {
> ++              xhci_err(xhci, "ERROR: DbC transfer event for disabled endpoint\n");
> ++              xhci_err(xhci, "@%016llx %08x %08x %08x %08x\n",
> ++                              (unsigned long long)xhci_trb_virt_to_dma(
> ++                                      xhci->dbc_event_ring->deq_seg,
> ++                                      xhci->dbc_event_ring->dequeue),
> ++                              lower_32_bits(le64_to_cpu(event->buffer)),
> ++                              upper_32_bits(le64_to_cpu(event->buffer)),
> ++                              le32_to_cpu(event->transfer_len),
> ++                              le32_to_cpu(event->flags));
> ++              xhci_dbg(xhci, "DbC event ring:\n");
> ++              xhci_debug_segment(xhci, xhci->dbc_event_ring->deq_seg);
> ++              return -ENODEV;
> ++      }
> ++
> ++      event_dma = le64_to_cpu(event->buffer);
> ++      trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
> ++      xhci_dbg(xhci, "cmpl_code=%d\n", trb_comp_code);
> ++
> ++      /* Look for common error cases */
> ++      switch (trb_comp_code) {
> ++      /* Skip codes that require special handling depending on
> ++       * transfer type
> ++       */
> ++      case COMP_SUCCESS:
> ++              if (TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
> ++                      break;
> ++              if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
> ++                      trb_comp_code = COMP_SHORT_TX;
> ++              else
> ++                      xhci_warn(xhci, "WARN: successful DbC completion on short TX:"
> ++                                      " needs XHCI_TRUST_TX_LENGTH quirk?\n");
> ++      case COMP_DB_ERR:
> ++              xhci_warn(xhci, "WARN: DbC HC couldn't access mem fast enough\n");
> ++              status = -ENOSR;
> ++              break;
> ++      case COMP_BABBLE:
> ++              xhci_dbg(xhci, "DbC babble error on endpoint\n");
> ++              status = -EOVERFLOW;
> ++              break;
> ++      case COMP_TX_ERR:
> ++              xhci_dbg(xhci, "DbC transfer error on endpoint\n");
> ++              status = -EPROTO;
> ++              break;
> ++      case COMP_TRB_ERR:
> ++              xhci_warn(xhci, "WARN: DbC TRB error on endpoint\n");
> ++              status = -EILSEQ;
> ++              break;
> ++      case COMP_SHORT_TX:
> ++              break;
> ++      case COMP_ER_FULL:
> ++              xhci_dbg(xhci, "DbC event ring full error\n");
> ++              status = -EOVERFLOW;
> ++              break;
> ++      case COMP_STOP:
> ++              xhci_dbg(xhci, "DbC stopped on Transfer TRB\n");
> ++              break;
> ++      case COMP_STOP_INVAL:
> ++              xhci_dbg(xhci, "DbC stopped on No-op or Link TRB\n");
> ++              break;
> ++      default:
> ++              xhci_warn(xhci, "WARN: unknown event condition, DbC HC probably"
> ++                              " busted\n");
> ++              goto cleanup;
> ++      }
> ++
> ++      /* This TRB should be in the TD at the head of this ring's TD list */
> ++      if (list_empty(&ep_ring->td_list)) {
> ++              xhci_warn(xhci, "WARN: DbC event TRB for slot %d ep %d"
> ++                      " with no TDs queued?\n",
> ++                      TRB_TO_SLOT_ID(le32_to_cpu(event->flags)), ep_index);
> ++              xhci_dbg(xhci, "DbC event TRB with TRB type ID %u\n",
> ++                      (le32_to_cpu(event->flags) & TRB_TYPE_BITMASK) >> 10);
> ++              xhci_print_trb_offsets(xhci, (union xhci_trb *)event);
> ++              ret = 0;
> ++              goto cleanup;
> ++      }
> ++
> ++      td = list_entry(ep_ring->td_list.next, struct xhci_td, td_list);
> ++
> ++      /* Is this a TRB in the currently executing TD? */
> ++      event_seg = trb_in_td(ep_ring->deq_seg, ep_ring->dequeue,
> ++                      td->last_trb, event_dma);
> ++
> ++      /*
> ++       * Skip the Force Stopped Event. The event_trb(event_dma) of FSE
> ++       * is not in the current TD pointed by ep_ring->dequeue because
> ++       * that the hardware dequeue pointer still at the previous TRB
> ++       * of the current TD. The previous TRB maybe a Link TD or the
> ++       * last TRB of the previous TD. The command completion handle
> ++       * will take care the rest.
> ++       */
> ++      if (!event_seg && trb_comp_code == COMP_STOP_INVAL) {
> ++              xhci_dbg(xhci, "Skipping DbC force stopped event\n");
> ++              ret = 0;
> ++              goto cleanup;
> ++      }
> ++
> ++      if (!event_seg) {
> ++              /* Some host controllers give a spurious
> ++               * successful event after a short transfer.
> ++               * Ignore it.
> ++               */
> ++              if ((xhci->quirks & XHCI_SPURIOUS_SUCCESS) &&
> ++                              ep_ring->last_td_was_short) {
> ++                      ep_ring->last_td_was_short = false;
> ++                      ret = 0;
> ++                      goto cleanup;
> ++              }
> ++              /* HC is busted, give up! */
> ++              xhci_err(xhci,
> ++                      "ERROR: DbC transfer event TRB DMA ptr not"
> ++                      " part of current TD\n");
> ++              return -ESHUTDOWN;
> ++      }
> ++
> ++      if (trb_comp_code == COMP_SHORT_TX)
> ++              ep_ring->last_td_was_short = true;
> ++      else
> ++              ep_ring->last_td_was_short = false;
> ++
> ++      event_trb = &event_seg->trbs[(event_dma - event_seg->dma) /
> ++                                      sizeof(*event_trb)];
> ++      /*
> ++       * No-op TRB should not trigger interrupts.
> ++       * If event_trb is a no-op TRB, it means the corresponding
> ++       * TD has been cancelled. Just ignore the TD.
> ++       */
> ++      if (TRB_TYPE_NOOP_LE32(event_trb->generic.field[3])) {
> ++              xhci_dbg(xhci, "DbC event_trb is a no-op TRB. Skip it.\n");
> ++              goto cleanup;
> ++      }
> ++
> ++      /* Now update the urb's actual_length and give back to the core */
> ++      ret = dbc_process_bulk_intr_td(xhci, td, event_trb, event, ep, ep_ctx,
> ++                      &status);
> ++      xhci_dbg(xhci, "dbc_process_bulk_intr_td() returned %d\n", ret);
> ++
> ++cleanup:
> ++      dbc_inc_deq(xhci, xhci->dbc_event_ring);
> ++
> ++      if (ret) {
> ++              urb = td->urb;
> ++              urb_priv = urb->hcpriv;
> ++              /* Leave the TD around for the reset endpoint function
> ++               * to use (but only if it's not a control endpoint,
> ++               * since we already queued the Set TR dequeue pointer
> ++               * command for stalled control endpoints)
> ++               */
> ++              if (trb_comp_code != COMP_STALL && trb_comp_code != COMP_BABBLE)
> ++                      xhci_urb_free_priv(xhci, urb_priv);
> ++
> ++              list_del_init(&urb->urb_list);
> ++              if ((urb->actual_length != urb->transfer_buffer_length &&
> ++                   (urb->transfer_flags & URB_SHORT_NOT_OK)) || status != 0)
> ++                      xhci_dbg(xhci, "DbC giveback URB %p, len = %d,"
> ++                                      " expected = %d, status = %d\n",
> ++                                      urb, urb->actual_length,
> ++                                      urb->transfer_buffer_length,
> ++                                      status);
> ++              spin_unlock(&xhci->lock);
> ++              dbc_giveback_urb(xhci, urb, status);
> ++              spin_lock(&xhci->lock);
> ++      }
> ++
> ++      return 0;
> ++}
> ++
> ++static void dbc_handle_port_status(struct xhci_hcd *xhci,
> ++              union xhci_trb *event)
> ++{
> ++      u32 port_id, temp;
> ++
> ++      /* Port status change events always have a successful completion code */
> ++      if (GET_COMP_CODE(le32_to_cpu(event->generic.field[2])) != COMP_SUCCESS) {
> ++              xhci_warn(xhci, "WARN: DbC xHC returned failed port status event\n");
> ++              xhci->dbc_error_bitmask |= 1 << 8;
> ++      }
> ++
> ++      port_id = GET_PORT_ID(le32_to_cpu(event->generic.field[0]));
> ++      xhci_dbg(xhci, "DbC Port Status Change Event for port %d\n", port_id);
> ++
> ++      if (port_id != 0) {
> ++              xhci_warn(xhci, "WARN: invalid DbC port id %d\n", port_id);
> ++              goto cleanup;
> ++      }
> ++
> ++      temp = xhci_readl(xhci, &xhci->dbg_cap_regs->dcportsc);
> ++      if (temp == 0xffffffff) {
> ++              xhci_err(xhci, "ERROR %s: DbC host controller died\n", __func__);
> ++              return;
> ++      }
> ++
> ++      xhci_dbg(xhci, "DCPORTSC %08x\n", temp);
> ++      xhci_writel(xhci, temp, &xhci->dbg_cap_regs->dcportsc);
> ++
> ++      if (DCPORTSC_CSC(temp)) {
> ++              dbc_incr = 2;
> ++
> ++              if (DCPORTSC_CCS(temp))
> ++                      xhci_info(xhci, "DbC CONNECT detected\n");
> ++              else
> ++                      xhci_info(xhci, "DbC DISCONNECT detected\n");
> ++      }
> ++
> ++cleanup:
> ++      /* Update event ring dequeue pointer */
> ++      dbc_inc_deq(xhci, xhci->dbc_event_ring);
> ++}
> ++
> ++static void dbc_handle_vendor_event(struct xhci_hcd *xhci,
> ++              union xhci_trb *event)
> ++{
> ++      u32 trb_type = TRB_FIELD_TO_TYPE(le32_to_cpu(event->generic.field[3]));
> ++
> ++      xhci_dbg(xhci, "Vendor specific event TRB type = %u\n", trb_type);
> ++}
> ++
> ++/*
> ++ * This function handles all OS-owned events on the event ring. It may drop
> ++ * xhci->lock between event processing (e.g. to pass up port status changes).
> ++ * Returns >0 for "possibly more events to process" (caller should call again),
> ++ * otherwise 0 if done. In future, <0 returns should indicate error code.
> ++ */
> ++static int dbc_handle_event(struct xhci_hcd *xhci)
> ++{
> ++      union xhci_trb *event;
> ++      int update_ptrs = 1;
> ++      int ret;
> ++
> ++      if (!xhci->dbc_event_ring || !xhci->dbc_event_ring->dequeue) {
> ++              xhci->dbc_error_bitmask |= 1 << 1;
> ++              return 0;
> ++      }
> ++
> ++      event = xhci->dbc_event_ring->dequeue;
> ++      /* Does the HC or OS own the TRB? */
> ++      if ((le32_to_cpu(event->event_cmd.flags) & TRB_CYCLE) !=
> ++                      xhci->dbc_event_ring->cycle_state) {
> ++              xhci->dbc_error_bitmask |= 1 << 2;
> ++              return 0;
> ++      }
> ++
> ++      /*
> ++       * Barrier between reading the TRB_CYCLE (valid) flag above and any
> ++       * speculative reads of the event's flags/data below
> ++       */
> ++      rmb();
> ++
> ++      /* FIXME: Handle more event types */
> ++      switch (le32_to_cpu(event->event_cmd.flags) & TRB_TYPE_BITMASK) {
> ++      case TRB_TYPE(TRB_TRANSFER):
> ++              xhci_dbg(xhci, "DbC xfer event\n");
> ++              ret = dbc_handle_tx_event(xhci, &event->trans_event);
> ++              if (ret < 0)
> ++                      xhci->dbc_error_bitmask |= 1 << 9;
> ++              else
> ++                      update_ptrs = 0;
> ++              break;
> ++      case TRB_TYPE(TRB_PORT_STATUS):
> ++              xhci_dbg(xhci, "DbC port status event\n");
> ++              dbc_handle_port_status(xhci, event);
> ++              update_ptrs = 0;
> ++              break;
> ++      default:
> ++              xhci_dbg(xhci, "DbC unknown event\n");
> ++              if ((le32_to_cpu(event->event_cmd.flags) & TRB_TYPE_BITMASK) >=
> ++                              TRB_TYPE(48))
> ++                      dbc_handle_vendor_event(xhci, event);
> ++              else
> ++                      xhci->dbc_error_bitmask |= 1 << 3;
> ++      }
> ++
> ++      /* Any of the above functions may drop and re-acquire the lock, so check
> ++       * to make sure a watchdog timer didn't mark the host as non-responsive
> ++       */
> ++      if (xhci->xhc_state & XHCI_STATE_DYING) {
> ++              xhci_dbg(xhci, "xHCI host dying, returning from"
> ++                              " event handler\n");
> ++              return 0;
> ++      }
> ++
> ++      if (update_ptrs)
> ++              /* Update SW event ring dequeue pointer */
> ++              dbc_inc_deq(xhci, xhci->dbc_event_ring);
> ++
> ++      /* Are there more items on the event ring?  Caller will call us again to
> ++       * check.
> ++       */
> ++      return 1;
> ++}
> ++
> ++static void dbc_complete(struct urb *urb)
> ++{
> ++      struct xhci_hcd *xhci = urb->context;
> ++
> ++      if (urb->status != 0)
> ++              xhci_err(xhci, "ERROR: DbC ep %#x completion status %d\n",
> ++                              urb->pipe, urb->status);
> ++#ifdef DBC_SRC_SINK
> ++      /* If OUT EP */
> ++      if (urb->pipe == 0x01) {
> ++              xhci_dbg(xhci, "DbC got completion for OUT ep, requeuing\n");
> ++
> ++              /* Requeue URB on the OUT EP */
> ++              urb->transfer_buffer_length = 65536;
> ++              urb->actual_length = 0;
> ++              urb->pipe = 0x01;
> ++              urb->status = -EINPROGRESS;
> ++              if (dbc_urb_enqueue(xhci, urb, 1, GFP_ATOMIC))
> ++                      xhci_err(xhci, "ERROR: DbC failed to queue OUT xfer\n");
> ++      } else {
> ++              xhci_dbg(xhci, "DbC got completion for IN ep, requeuing\n");
> ++              dbc_incr++;
> ++              if (dbc_incr > 65535)
> ++                      dbc_incr = 0;
> ++              if ((dbc_incr & 1023) == 0)
> ++                      dbc_incr++;
> ++              /* Requeue URB on the IN EP */
> ++              urb->transfer_buffer_length = dbc_incr;
> ++              urb->actual_length = 0;
> ++              urb->pipe = 0x81;
> ++              urb->status = -EINPROGRESS;
> ++              if (dbc_urb_enqueue(xhci, urb, 0, GFP_ATOMIC))
> ++                      xhci_err(xhci, "ERROR: DbC failed to queue IN xfer\n");
> ++      }
> ++#else
> ++      /* If OUT EP */
> ++      if (urb->pipe == 0x01) {
> ++              xhci_dbg(xhci, "DbC got completion for OUT ep,"
> ++                              " requeuing on IN\n");
> ++
> ++              /* Handle 0-length marker packet */
> ++              if (urb->actual_length && (urb->actual_length & 1023) == 0) {
> ++                      xhci_dbg(xhci, "DbC received 0-length packet\n");
> ++                      xhci->dbc_next_0 = 1;
> ++              }
> ++
> ++              /* Requeue URB on the IN EP */
> ++              urb->transfer_buffer_length = urb->actual_length;
> ++              urb->actual_length = 0;
> ++              urb->pipe = 0x81;
> ++              urb->status = -EINPROGRESS;
> ++              if (dbc_urb_enqueue(xhci, urb, 0, GFP_ATOMIC)) {
> ++                      xhci->dbc_next_0 = 0;
> ++                      xhci_err(xhci, "ERROR: DbC failed to queue IN xfer,"
> ++                                      " requeuing on OUT\n");
> ++              } else {
> ++                      return;
> ++              }
> ++      } else {
> ++              xhci_dbg(xhci, "DbC got completion for IN ep,"
> ++                              " requeuing on OUT\n");
> ++      }
> ++
> ++      /* Handle 0-length marker packet */
> ++      if (xhci->dbc_next_0) {
> ++              xhci_dbg(xhci, "DbC sending 0-length packet\n");
> ++              xhci->dbc_next_0 = 0;
> ++              urb->transfer_buffer_length = 0;
> ++              urb->actual_length = 0;
> ++              urb->pipe = 0x81;
> ++              urb->status = -EINPROGRESS;
> ++              if (dbc_urb_enqueue(xhci, urb, 0, GFP_ATOMIC))
> ++                      xhci_err(xhci, "ERROR: DbC failed to queue IN 0-length"
> ++                                      " xfer, requeuing on OUT\n");
> ++              else
> ++                      return;
> ++      }
> ++
> ++      /* Requeue URB on the OUT EP */
> ++      urb->transfer_buffer_length = 65536;
> ++      urb->actual_length = 0;
> ++      urb->pipe = 0x01;
> ++      urb->status = -EINPROGRESS;
> ++      if (dbc_urb_enqueue(xhci, urb, 1, GFP_ATOMIC))
> ++              xhci_err(xhci, "ERROR: DbC failed to queue OUT xfer\n");
> ++#endif
> ++}
> ++
> ++static int dbc_poll_events(void *data)
> ++{
> ++      struct xhci_hcd *xhci = data;
> ++      u32 status;
> ++      union xhci_trb *trb;
> ++      u64 temp_64;
> ++      union xhci_trb *event_ring_deq;
> ++      dma_addr_t deq;
> ++      unsigned long flags;
> ++      int count = 0;
> ++      int dead = 0;
> ++      int ret = -ENOMEM;
> ++
> ++      /* Allow the thread to be killed by a signal, but set the signal mask
> ++       * to block everything but INT, TERM, KILL, and USR1
> ++       */
> ++      allow_signal(SIGINT);
> ++      allow_signal(SIGTERM);
> ++      allow_signal(SIGKILL);
> ++      allow_signal(SIGUSR1);
> ++
> ++      /* Allow the thread to be frozen */
> ++      set_freezable();
> ++
> ++      xhci->dbc_configured = 0;
> ++      xhci->dbc_next_0 = 0;
> ++
> ++      xhci->dbc_buf_0 = dma_alloc_coherent(NULL, 65536,
> ++                      &xhci->dbc_buf_0_dma, GFP_KERNEL);
> ++      if (!xhci->dbc_buf_0)
> ++              goto fail1;
> ++      xhci->dbc_buf_1 = dma_alloc_coherent(NULL, 65536,
> ++                      &xhci->dbc_buf_1_dma, GFP_KERNEL);
> ++      if (!xhci->dbc_buf_1)
> ++              goto fail2;
> ++      xhci->dbc_buf_2 = dma_alloc_coherent(NULL, 65536,
> ++                      &xhci->dbc_buf_2_dma, GFP_KERNEL);
> ++      if (!xhci->dbc_buf_2)
> ++              goto fail3;
> ++      xhci->dbc_buf_3 = dma_alloc_coherent(NULL, 65536,
> ++                      &xhci->dbc_buf_3_dma, GFP_KERNEL);
> ++      if (!xhci->dbc_buf_3)
> ++              goto fail4;
> ++
> ++      xhci->dbc_urb_0.transfer_buffer = xhci->dbc_buf_0;
> ++      xhci->dbc_urb_0.transfer_dma = xhci->dbc_buf_0_dma;
> ++      xhci->dbc_urb_0.transfer_buffer_length = 65536;
> ++      xhci->dbc_urb_0.pipe = 0x01;
> ++      xhci->dbc_urb_0.transfer_flags = 0;
> ++      xhci->dbc_urb_0.actual_length = 0;
> ++      xhci->dbc_urb_0.status = -EINPROGRESS;
> ++      xhci->dbc_urb_0.complete = dbc_complete;
> ++      xhci->dbc_urb_0.context = data;
> ++
> ++      xhci->dbc_urb_1.transfer_buffer = xhci->dbc_buf_1;
> ++      xhci->dbc_urb_1.transfer_dma = xhci->dbc_buf_1_dma;
> ++      xhci->dbc_urb_1.transfer_buffer_length = 65536;
> ++      xhci->dbc_urb_1.pipe = 0x01;
> ++      xhci->dbc_urb_1.transfer_flags = 0;
> ++      xhci->dbc_urb_1.actual_length = 0;
> ++      xhci->dbc_urb_1.status = -EINPROGRESS;
> ++      xhci->dbc_urb_1.complete = dbc_complete;
> ++      xhci->dbc_urb_1.context = data;
> ++
> ++      xhci->dbc_urb_2.transfer_buffer = xhci->dbc_buf_2;
> ++      xhci->dbc_urb_2.transfer_dma = xhci->dbc_buf_2_dma;
> ++#ifdef DBC_SRC_SINK
> ++      xhci->dbc_buf_2[0] = 0;
> ++      xhci->dbc_urb_2.transfer_buffer_length = 1;
> ++      xhci->dbc_urb_2.pipe = 0x81;
> ++#else
> ++      xhci->dbc_urb_2.transfer_buffer_length = 65536;
> ++      xhci->dbc_urb_2.pipe = 0x01;
> ++#endif
> ++      xhci->dbc_urb_2.transfer_flags = 0;
> ++      xhci->dbc_urb_2.actual_length = 0;
> ++      xhci->dbc_urb_2.status = -EINPROGRESS;
> ++      xhci->dbc_urb_2.complete = dbc_complete;
> ++      xhci->dbc_urb_2.context = data;
> ++
> ++      xhci->dbc_urb_3.transfer_buffer = xhci->dbc_buf_3;
> ++      xhci->dbc_urb_3.transfer_dma = xhci->dbc_buf_3_dma;
> ++#ifdef DBC_SRC_SINK
> ++      xhci->dbc_buf_3[0] = 0;
> ++      xhci->dbc_buf_3[1] = 1;
> ++      xhci->dbc_urb_3.transfer_buffer_length = 2;
> ++      xhci->dbc_urb_3.pipe = 0x81;
> ++#else
> ++      xhci->dbc_urb_3.transfer_buffer_length = 65536;
> ++      xhci->dbc_urb_3.pipe = 0x01;
> ++#endif
> ++      xhci->dbc_urb_3.transfer_flags = 0;
> ++      xhci->dbc_urb_3.actual_length = 0;
> ++      xhci->dbc_urb_3.status = -EINPROGRESS;
> ++      xhci->dbc_urb_3.complete = dbc_complete;
> ++      xhci->dbc_urb_3.context = data;
> ++
> ++      dbc_incr = 0;
> ++
> ++      while (1) {
> ++              spin_lock_irqsave(&xhci->lock, flags);
> ++              if (dead)
> ++                      goto cont;
> ++              trb = xhci->dbc_event_ring->dequeue;
> ++              status = xhci_readl(xhci, &xhci->dbg_cap_regs->dcst);
> ++              if (status == 0xffffffff) {
> ++                      xhci_err(xhci, "ERROR %s 1: DbC host controller died\n",
> ++                              __func__);
> ++                      ret = -ENODEV;
> ++                      dead = 1;
> ++                      goto cont;
> ++              }
> ++              if (!DCST_ER(status))
> ++                      goto cont2;
> ++
> ++              event_ring_deq = xhci->dbc_event_ring->dequeue;
> ++              /* FIXME this should be a delayed service routine
> ++               * that clears the EHB
> ++               */
> ++              while (dbc_handle_event(xhci) > 0) {}
> ++
> ++              temp_64 = xhci_read_64(xhci, &xhci->dbg_cap_regs->dcerdp);
> ++              if (temp_64 == 0xffffffffffffffffUL) {
> ++                      xhci_err(xhci, "ERROR %s 2: DbC host controller died\n",
> ++                              __func__);
> ++                      ret = -ENODEV;
> ++                      dead = 1;
> ++                      goto cont;
> ++              }
> ++
> ++              /* If necessary, update the HW's version of the event ring deq ptr */
> ++              if (event_ring_deq != xhci->dbc_event_ring->dequeue) {
> ++                      deq = xhci_trb_virt_to_dma(xhci->dbc_event_ring->deq_seg,
> ++                                              xhci->dbc_event_ring->dequeue);
> ++                      if (deq == 0)
> ++                              xhci_warn(xhci, "WARN: something wrong with DbC"
> ++                                              " SW event ring dequeue ptr\n");
> ++                      /* Update HC event ring dequeue pointer */
> ++                      temp_64 &= ERST_PTR_MASK;
> ++                      temp_64 |= (u64)deq & ~(u64)ERST_PTR_MASK;
> ++              }
> ++
> ++              xhci_write_64(xhci, temp_64, &xhci->dbg_cap_regs->dcerdp);
> ++
> ++              if (count++ > 5000) {
> ++                      count = 0;
> ++                      status = xhci_readl(xhci, &xhci->dbg_cap_regs->dcctrl);
> ++                      xhci_dbg(xhci, "DCCTRL=0x%08x\n", status);
> ++              }
> ++cont2:
> ++              if (!xhci->dbc_configured) {
> ++                      status = xhci_readl(xhci, &xhci->dbg_cap_regs->dcctrl);
> ++                      if (DCCTRL_DCR(status)) {
> ++                              xhci->dbc_configured = 1;
> ++                              xhci_dbg(xhci, "DbC configured, starting xfers\n");
> ++
> ++                              if (dbc_urb_enqueue(xhci, &xhci->dbc_urb_0,
> ++                                                      1, GFP_ATOMIC)) {
> ++                                      xhci_err(xhci, "ERROR: DbC failed to"
> ++                                                      " queue 1st OUT xfer\n");
> ++                                      ret = -EPROTO;
> ++                                      dead = 1;
> ++                                      goto cont;
> ++                              }
> ++                              if (dbc_urb_enqueue(xhci, &xhci->dbc_urb_1,
> ++                                                      1, GFP_ATOMIC)) {
> ++                                      xhci_err(xhci, "ERROR: DbC failed to"
> ++                                                      " queue 2nd OUT xfer\n");
> ++                                      ret = -EPROTO;
> ++                                      dead = 1;
> ++                                      goto cont;
> ++                              }
> ++                              if (dbc_urb_enqueue(xhci, &xhci->dbc_urb_2,
> ++#ifdef DBC_SRC_SINK
> ++                                                      0,
> ++#else
> ++                                                      1,
> ++#endif
> ++                                                      GFP_ATOMIC)) {
> ++                                      xhci_err(xhci, "ERROR: DbC failed to"
> ++#ifdef DBC_SRC_SINK
> ++                                                      " queue 1st IN xfer\n"
> ++#else
> ++                                                      " queue 3rd OUT xfer\n"
> ++#endif
> ++                                              );
> ++                                      ret = -EPROTO;
> ++                                      dead = 1;
> ++                                      goto cont;
> ++                              }
> ++                              if (dbc_urb_enqueue(xhci, &xhci->dbc_urb_3,
> ++#ifdef DBC_SRC_SINK
> ++                                                      0,
> ++#else
> ++                                                      1,
> ++#endif
> ++                                                      GFP_ATOMIC)) {
> ++                                      xhci_err(xhci, "ERROR: DbC failed to"
> ++#ifdef DBC_SRC_SINK
> ++                                                      " queue 2nd IN xfer\n"
> ++#else
> ++                                                      " queue 4th OUT xfer\n"
> ++#endif
> ++                                              );
> ++                                      ret = -EPROTO;
> ++                                      dead = 1;
> ++                                      goto cont;
> ++                              }
> ++                      }
> ++              }
> ++cont:
> ++              spin_unlock_irqrestore(&xhci->lock, flags);
> ++              if (kthread_should_stop())
> ++                      break;
> ++              msleep(1);
> ++      }
> ++
> ++      dma_free_coherent(NULL, 65536, xhci->dbc_buf_3, xhci->dbc_buf_3_dma);
> ++fail4:
> ++      dma_free_coherent(NULL, 65536, xhci->dbc_buf_2, xhci->dbc_buf_2_dma);
> ++fail3:
> ++      dma_free_coherent(NULL, 65536, xhci->dbc_buf_1, xhci->dbc_buf_1_dma);
> ++fail2:
> ++      dma_free_coherent(NULL, 65536, xhci->dbc_buf_0, xhci->dbc_buf_0_dma);
> ++fail1:
> ++      return ret;
> ++}
> ++
> ++/*
> ++ * De-initialize the Debug Capability
> ++ */
> ++void xhci_teardown_dbg_cap(struct xhci_hcd *xhci, struct device *dev)
> ++{
> ++      u32 val;
> ++
> ++      xhci_dbg(xhci, "xhci_teardown_dbg_cap()\n");
> ++      if (!xhci->dbg_cap_regs)
> ++              return;
> ++
> ++      /* Kill the kernel thread */
> ++      if (xhci->dbc_thread) {
> ++              kthread_stop(xhci->dbc_thread);
> ++              xhci->dbc_thread = NULL;
> ++      }
> ++
> ++      /* Set DCE bit to 0 in DCCTRL */
> ++      val = xhci_readl(xhci, &xhci->dbg_cap_regs->dcctrl);
> ++      if (val == 0xffffffff) {
> ++              xhci_err(xhci, "ERROR %s: DbC host controller died\n", __func__);
> ++      } else {
> ++              val &= ~DCCTRL_WR_DCE(1);
> ++              xhci_writel(xhci, val, &xhci->dbg_cap_regs->dcctrl);
> ++      }
> ++
> ++      dbc_endpoint_deinit(xhci, 1);
> ++      dbc_endpoint_deinit(xhci, 0);
> ++
> ++      dbc_teardown_dbcic(xhci, dev);
> ++
> ++      if (xhci->dbg_cap_ctx) {
> ++              dma_pool_free(xhci->dbc_device_pool, xhci->dbg_cap_ctx,
> ++                              xhci->dbg_cap_ctx_dma);
> ++              xhci->dbg_cap_ctx = NULL;
> ++      }
> ++      if (xhci->dbc_erst.entries) {
> ++              dma_free_coherent(dev,
> ++                              sizeof(struct xhci_erst_entry) * ERST_NUM_SEGS,
> ++                              xhci->dbc_erst.entries,
> ++                              xhci->dbc_erst.erst_dma_addr);
> ++              xhci->dbc_erst.entries = NULL;
> ++      }
> ++      if (xhci->dbc_event_ring) {
> ++              dbc_ring_free(xhci, xhci->dbc_event_ring);
> ++              xhci->dbc_event_ring = NULL;
> ++      }
> ++      if (xhci->dbc_device_pool) {
> ++              dma_pool_destroy(xhci->dbc_device_pool);
> ++              xhci->dbc_device_pool = NULL;
> ++      }
> ++      if (xhci->dbc_segment_pool) {
> ++              dma_pool_destroy(xhci->dbc_segment_pool);
> ++              xhci->dbc_segment_pool = NULL;
> ++      }
> ++}
> ++
> ++/*
> ++ * Scan the Extended Capabilities to find the Debug Capability, then initialize
> ++ * and start it
> ++ */
> ++int xhci_setup_dbg_cap(struct xhci_hcd *xhci, struct device *dev)
> ++{
> ++      struct xhci_segment *seg;
> ++      dma_addr_t dma;
> ++      u64 val_64;
> ++      u32 val, offset;
> ++      int ret = -ENOMEM;
> ++      __le32 __iomem *addr = &xhci->cap_regs->hcc_params;
> ++
> ++      offset = XHCI_HCC_EXT_CAPS(xhci_readl(xhci, addr));
> ++      if (offset == 0) {
> ++              xhci_err(xhci, "ERROR: no Extended Capability registers,"
> ++                              " unable to set up Debug Capability\n");
> ++              return -ENODEV;
> ++      }
> ++
> ++      /*
> ++       * For whatever reason, the first capability offset is from the
> ++       * capability register base, not from the HCCPARAMS register.
> ++       * See section 5.3.6 for offset calculation.
> ++       */
> ++      addr = &xhci->cap_regs->hc_capbase + offset;
> ++      while (1) {
> ++              u32 cap_id;
> ++
> ++              cap_id = xhci_readl(xhci, addr);
> ++              if (XHCI_EXT_CAPS_ID(cap_id) == XHCI_EXT_CAPS_DEBUG)
> ++                      break;
> ++              offset = XHCI_EXT_CAPS_NEXT(cap_id);
> ++              if (!offset) {
> ++                      xhci_info(xhci, "No Debug Capability found\n");
> ++                      return -ENODEV;
> ++              }
> ++              /*
> ++               * Once you're into the Extended Capabilities, the offset is
> ++               * always relative to the register holding the offset
> ++               */
> ++              addr += offset;
> ++      }
> ++
> ++      /* Save address of debug capability registers */
> ++      xhci->dbg_cap_regs = (struct xhci_dbg_cap_regs __iomem *)addr;
> ++
> ++      /*
> ++       * Initialize the ring segment pool. The ring must be a contiguous
> ++       * structure comprised of TRBs. The TRBs must be 16 byte aligned,
> ++       * however, the command ring segment needs 64-byte aligned segments,
> ++       * so we pick the greater alignment need.
> ++       */
> ++      xhci->dbc_segment_pool = dma_pool_create("xHCI DbC ring segments", dev,
> ++                      SEGMENT_SIZE, 64, 1 << 12);
> ++
> ++      /* See Table 46 and Note on Figure 55 */
> ++      xhci->dbc_device_pool = dma_pool_create("xHCI DbC contexts", dev,
> ++                      192, 64, 1 << 12);
> ++      if (!xhci->dbc_segment_pool || !xhci->dbc_device_pool) {
> ++              xhci_err(xhci, "ERROR: failed to allocate DbC segment/device pools\n");
> ++              goto fail;
> ++      }
> ++
> ++      /*
> ++       * Event ring setup: Allocate a normal ring, but also setup
> ++       * the event ring segment table (ERST). Section 4.9.3.
> ++       */
> ++      xhci_dbg(xhci, "// Allocating DbC event ring\n");
> ++      xhci->dbc_event_ring = dbc_ring_alloc(xhci, ERST_NUM_SEGS, 1,
> ++                                              TYPE_EVENT, GFP_KERNEL);
> ++      if (!xhci->dbc_event_ring) {
> ++              xhci_err(xhci, "ERROR: failed to allocate DbC event ring\n");
> ++              goto fail;
> ++      }
> ++
> ++      xhci->dbc_erst.entries = dma_alloc_coherent(dev,
> ++                      sizeof(struct xhci_erst_entry) * ERST_NUM_SEGS, &dma,
> ++                      GFP_KERNEL);
> ++      if (!xhci->dbc_erst.entries) {
> ++              xhci_err(xhci, "ERROR: failed to allocate DbC event ring seg table\n");
> ++              goto fail;
> ++      }
> ++      xhci_dbg(xhci, "// Allocated DbC event ring segment table at 0x%llx\n",
> ++                      (unsigned long long)dma);
> ++
> ++      memset(xhci->dbc_erst.entries, 0,
> ++                      sizeof(struct xhci_erst_entry) * ERST_NUM_SEGS);
> ++      xhci->dbc_erst.num_entries = ERST_NUM_SEGS;
> ++      xhci->dbc_erst.erst_dma_addr = dma;
> ++      xhci_dbg(xhci, "Set DbC ERST to 0; private num segs = %i,"
> ++                      " virt addr = %p, dma addr = 0x%llx\n",
> ++                      xhci->dbc_erst.num_entries, xhci->dbc_erst.entries,
> ++                      (unsigned long long)xhci->dbc_erst.erst_dma_addr);
> ++
> ++      /* set ring base address and size for each segment table entry */
> ++      for (val = 0, seg = xhci->dbc_event_ring->first_seg;
> ++                                      val < ERST_NUM_SEGS; val++) {
> ++              struct xhci_erst_entry *entry = &xhci->dbc_erst.entries[val];
> ++              entry->seg_addr = cpu_to_le64(seg->dma);
> ++              entry->seg_size = cpu_to_le32(TRBS_PER_SEGMENT);
> ++              entry->rsvd = 0;
> ++              seg = seg->next;
> ++      }
> ++
> ++      /* set ERST count with the number of entries in the segment table */
> ++      xhci_dbg(xhci, "// Write DbC ERST size = %i to dcerstsz\n",
> ++                      ERST_NUM_SEGS);
> ++      xhci_writel(xhci, ERST_NUM_SEGS, &xhci->dbg_cap_regs->dcerstsz);
> ++
> ++      xhci_dbg(xhci, "// Set DbC ERST entries to point to event ring\n");
> ++      /* set the segment table base address */
> ++      xhci_dbg(xhci, "// Set DbC ERST base address for dcerstba = 0x%llx\n",
> ++                      (unsigned long long)xhci->dbc_erst.erst_dma_addr);
> ++      val_64 = xhci_read_64(xhci, &xhci->dbg_cap_regs->dcerstba);
> ++      if (val_64 == 0xffffffffffffffffUL) {
> ++              xhci_err(xhci, "ERROR %s 1: DbC host controller died\n", __func__);
> ++              ret = -ENODEV;
> ++              goto fail;
> ++      }
> ++      val_64 &= ERST_PTR_MASK;
> ++      val_64 |= xhci->dbc_erst.erst_dma_addr & ~(u64)ERST_PTR_MASK;
> ++      xhci_write_64(xhci, val_64, &xhci->dbg_cap_regs->dcerstba);
> ++
> ++      /* Set the event ring dequeue address */
> ++      dbc_set_hc_event_deq(xhci);
> ++      xhci_dbg(xhci, "Wrote DbC ERST address\n");
> ++//    xhci_print_ir_set(xhci, 0);
> ++
> ++      /* Allocate and set up the DbCC */
> ++      xhci->dbg_cap_ctx = dma_pool_alloc(xhci->dbc_device_pool, GFP_KERNEL,
> ++                                      &xhci->dbg_cap_ctx_dma);
> ++      if (!xhci->dbg_cap_ctx) {
> ++              xhci_err(xhci, "ERROR: failed to allocate DbC capability context\n");
> ++              goto fail;
> ++      }
> ++      ret = dbc_setup_dbcic(xhci, dev);
> ++      if (ret) {
> ++              xhci_err(xhci, "ERROR: failed to set up DbCIC\n");
> ++              goto fail;
> ++      }
> ++
> ++      /* Set VendorID, ProductID, and DbC Protocol */
> ++      val = DCDDI1_WR_VENDID(DCD_VENDOR_ID) | DCDDI1_WR_PROTOCOL(DCDDI1_PROTO_VEND);
> ++      xhci_writel(xhci, cpu_to_le32(val), &xhci->dbg_cap_regs->dcddi1);
> ++      val = DCDDI2_WR_DEVREV(DCD_DEVICE_REV) | DCDDI2_WR_PRODID(DCD_PRODUCT_ID);
> ++      xhci_writel(xhci, cpu_to_le32(val), &xhci->dbg_cap_regs->dcddi2);
> ++
> ++      /* Set up the OUT and IN bulk endpoints */
> ++      ret = dbc_endpoint_init(xhci, 0, GFP_KERNEL);
> ++      if (ret) {
> ++              xhci_err(xhci, "ERROR: failed to init DbC EP1-OUT\n");
> ++              goto fail;
> ++      }
> ++      ret = dbc_endpoint_init(xhci, 1, GFP_KERNEL);
> ++      if (ret) {
> ++              xhci_err(xhci, "ERROR: failed to init DbC EP1-IN\n");
> ++              goto fail;
> ++      }
> ++
> ++      INIT_LIST_HEAD(&xhci->dbc_out_urb_list);
> ++      INIT_LIST_HEAD(&xhci->dbc_in_urb_list);
> ++
> ++      /* set the DbCC address in the DCCP register */
> ++      xhci_write_64(xhci, xhci->dbg_cap_ctx_dma, &xhci->dbg_cap_regs->dccp);
> ++
> ++      /* Set DCE bit to 1 in DCCTRL */
> ++      val = xhci_readl(xhci, &xhci->dbg_cap_regs->dcctrl);
> ++      if (val == 0xffffffff) {
> ++              xhci_err(xhci, "ERROR %s 2: DbC host controller died\n", __func__);
> ++              ret = -ENODEV;
> ++              goto fail;
> ++      }
> ++      val |= DCCTRL_WR_DCE(1);
> ++      xhci_writel(xhci, val, &xhci->dbg_cap_regs->dcctrl);
> ++
> ++      /* Start the kernel thread to poll for events */
> ++      xhci->dbc_thread = kthread_run(dbc_poll_events, xhci, "dbcthr");
> ++      if (IS_ERR(xhci->dbc_thread)) {
> ++              ret = PTR_ERR(xhci->dbc_thread);
> ++              xhci->dbc_thread = NULL;
> ++              xhci_err(xhci, "ERROR: failed to start DbC event thread\n");
> ++              goto fail;
> ++      }
> ++
> ++      return 0;
> ++
> ++fail:
> ++      xhci_teardown_dbg_cap(xhci, dev);
> ++      return ret;
> ++}
> +diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> +index 9bfd4ca..efe8a5d 100644
> +--- a/drivers/usb/host/xhci-pci.c
> ++++ b/drivers/usb/host/xhci-pci.c
> +@@ -38,11 +38,15 @@ static const char hcd_name[] = "xhci_hcd";
> + /* called after powerup, by probe or system-pm "wakeup" */
> + static int xhci_pci_reinit(struct xhci_hcd *xhci, struct pci_dev *pdev)
> + {
> ++      int retval;
> ++
> +       /*
> +        * TODO: Implement finding debug ports later.
> +        * TODO: see if there are any quirks that need to be added to handle
> +        * new extended capabilities.
> +        */
> ++      retval = xhci_setup_dbg_cap(xhci , &pdev->dev);
> ++      xhci_dbg(xhci, "xhci_setup_dbg_cap() returned %d\n", retval);
> +
> +       /* PCI Memory-Write-Invalidate cycle support is optional (uncommon) */
> +       if (!pci_set_mwi(pdev))
> +@@ -209,6 +213,8 @@ static void xhci_pci_remove(struct pci_dev *dev)
> +               usb_remove_hcd(xhci->shared_hcd);
> +               usb_put_hcd(xhci->shared_hcd);
> +       }
> ++
> ++      xhci_teardown_dbg_cap(xhci, &dev->dev);
> +       usb_hcd_pci_remove(dev);
> +       kfree(xhci);
> + }
> +diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> +index c713256..d6ba61c 100644
> +--- a/drivers/usb/host/xhci.h
> ++++ b/drivers/usb/host/xhci.h
> +@@ -1374,6 +1374,116 @@ struct xhci_bus_state {
> +       unsigned long           resuming_ports;
> + };
> +
> ++/**
> ++ * struct xhci_dbg_cap_regs
> ++ *
> ++ * See section 7.6.8 in the xHCI 1.0 spec.
> ++ */
> ++struct xhci_dbg_cap_regs {
> ++      __le32                  dcid;
> ++#define       DCID_ERSTMAX(x)         (((x) >> 16) & 0x1f)
> ++      __le32                  dcdb;
> ++#define DCDB_WR_TARGET(x)     (((x) & 0xff) << 8)
> ++      __le32                  dcerstsz;
> ++#define       DCERSTSZ(x)             ((x) & 0xffff)
> ++#define       DCERSTSZ_WR(x)          ((x) & 0xffff)
> ++      __le32                  rsvd1;
> ++      __le64                  dcerstba;
> ++#define       DCERSTBA_LO(x)          ((x) & 0xfffffff0)
> ++#define       DCERSTBA_HI(x)          (x)
> ++#define       DCERSTBA_WR_LO(x)       ((x) & 0xfffffff0)
> ++#define       DCERSTBA_WR_HI(x)       (x)
> ++      __le64                  dcerdp;
> ++#define       DCERDP_LO(x)            ((x) & 0xfffffff0)
> ++#define       DCERDP_HI(x)            (x)
> ++#define       DCERDP_WR_LO(x)         ((x) & 0xfffffff0)
> ++#define       DCERDP_WR_HI(x)         (x)
> ++      __le32                  dcctrl;
> ++#define       DCCTRL_DCE(x)           (((x) >> 31) & 1)
> ++#define       DCCTRL_WR_DCE(x)        (((x) & 1) << 31)
> ++#define       DCCTRL_DEVADR(x)        (((x) >> 24) & 0x7f)
> ++#define       DCCTRL_MAXBST(x)        (((x) >> 16) & 0xff)
> ++#define       DCCTRL_DRC(x)           (((x) >> 4) & 1)
> ++#define       DCCTRL_CLR_DRC          (1 << 4)
> ++#define       DCCTRL_HIT(x)           (((x) >> 3) & 1)
> ++#define       DCCTRL_SET_HIT          (1 << 3)
> ++#define       DCCTRL_HOT(x)           (((x) >> 2) & 1)
> ++#define       DCCTRL_SET_HOT          (1 << 2)
> ++#define       DCCTRL_LSE(x)           (((x) >> 1) & 1)
> ++#define       DCCTRL_WR_LSE(x)        (((x) & 1) << 1)
> ++#define       DCCTRL_DCR(x)           ((x) & 1)
> ++      __le32                  dcst;
> ++#define       DCST_PORTNUM(x)         (((x) >> 24) & 0xff)
> ++#define       DCST_ER(x)              ((x) & 1)
> ++      __le32                  dcportsc;
> ++#define       DCPORTSC_CEC(x)         (((x) >> 23) & 1)
> ++#define       DCPORTSC_CLR_CEC        (1 << 23)
> ++#define       DCPORTSC_PLC(x)         (((x) >> 22) & 1)
> ++#define       DCPORTSC_CLR_PLC        (1 << 22)
> ++#define       DCPORTSC_PRC(x)         (((x) >> 21) & 1)
> ++#define       DCPORTSC_CLR_PRC        (1 << 21)
> ++#define       DCPORTSC_CSC(x)         (((x) >> 17) & 1)
> ++#define       DCPORTSC_CLR_CSC        (1 << 17)
> ++#define       DCPORTSC_PORTSPD(x)     (((x) >> 10) & 0x0f)
> ++#define       DCPORTSC_PLS(x)         (((x) >> 5) & 0x0f)
> ++#define       DCPORTSC_PR(x)          (((x) >> 4) & 1)
> ++#define       DCPORTSC_PED(x)         (((x) >> 1) & 1)
> ++#define       DCPORTSC_WR_PED(x)      (((x) & 1) << 1)
> ++#define       DCPORTSC_CCS(x)         ((x) & 1)
> ++      __le32                  rsvd2;
> ++      __le64                  dccp;
> ++#define       DCCP_LO(x)              ((x) & 0xfffffff0)
> ++#define       DCCP_HI(x)              (x)
> ++#define       DCCP_WR_LO(x)           ((x) & 0xfffffff0)
> ++#define       DCCP_WR_HI(x)           (x)
> ++      __le32                  dcddi1;
> ++#define       DCDDI1_VENDID(x)        (((x) >> 16) & 0xffff)
> ++#define       DCDDI1_WR_VENDID(x)     (((x) & 0xffff) << 16)
> ++#define       DCDDI1_PROTOCOL(x)      ((x) & 0xff)
> ++#define       DCDDI1_WR_PROTOCOL(x)   ((x) & 0xff)
> ++#define DCDDI1_PROTO_VEND     0
> ++#define DCDDI1_PROTO_GNU      1
> ++      __le32                  dcddi2;
> ++#define       DCDDI2_DEVREV(x)        (((x) >> 16) & 0xffff)
> ++#define       DCDDI2_WR_DEVREV(x)     (((x) & 0xffff) << 16)
> ++#define       DCDDI2_PRODID(x)        ((x) & 0xffff)
> ++#define       DCDDI2_WR_PRODID(x)     ((x) & 0xffff)
> ++};
> ++
> ++/**
> ++ * struct xhci_dbg_cap_info_ctx
> ++ *
> ++ * See section 7.6.9.1 in the xHCI 1.0 spec.
> ++ */
> ++struct xhci_dbg_cap_info_ctx {
> ++      __le32  str_0_desc_addr_lo;
> ++      __le32  str_0_desc_addr_hi;
> ++      __le32  manuf_str_desc_addr_lo;
> ++      __le32  manuf_str_desc_addr_hi;
> ++      __le32  product_str_desc_addr_lo;
> ++      __le32  product_str_desc_addr_hi;
> ++      __le32  serial_str_desc_addr_lo;
> ++      __le32  serial_str_desc_addr_hi;
> ++      __u8    str_0_len;
> ++      __u8    manuf_str_len;
> ++      __u8    product_str_len;
> ++      __u8    serial_str_len;
> ++      __le32  reserved[7];
> ++};
> ++
> ++/**
> ++ * struct xhci_dbg_cap_ctx
> ++ *
> ++ * See section 7.6.9 in the xHCI 1.0 spec.
> ++ */
> ++struct xhci_dbg_cap_ctx {
> ++      struct xhci_dbg_cap_info_ctx    info_ctx;
> ++      struct xhci_ep_ctx              out_ep_ctx;
> ++      __le32                          reserved1[8];
> ++      struct xhci_ep_ctx              in_ep_ctx;
> ++      __le32                          reserved2[8];
> ++};
> ++
> + static inline unsigned int hcd_index(struct usb_hcd *hcd)
> + {
> +       if (hcd->speed == HCD_USB3)
> +@@ -1511,6 +1621,62 @@ struct xhci_hcd {
> +       unsigned                sw_lpm_support:1;
> +       /* support xHCI 1.0 spec USB2 hardware LPM */
> +       unsigned                hw_lpm_support:1;
> ++
> ++/*
> ++ * Debug Capability support - see section 7 in the xHCI 1.0 spec.
> ++ */
> ++      /* Debug Capability registers */
> ++      struct xhci_dbg_cap_regs __iomem *dbg_cap_regs;
> ++
> ++      /* Statistics */
> ++      int                             dbc_error_bitmask;
> ++
> ++      /* DMA pools */
> ++      struct dma_pool                 *dbc_device_pool;
> ++      struct dma_pool                 *dbc_segment_pool;
> ++
> ++      /* Contexts */
> ++      struct xhci_dbg_cap_ctx         *dbg_cap_ctx;
> ++      dma_addr_t                      dbg_cap_ctx_dma;
> ++
> ++      /* DbCIC */
> ++      void                            *str_0_desc;
> ++      void                            *manuf_str_desc;
> ++      void                            *product_str_desc;
> ++      void                            *serial_str_desc;
> ++      dma_addr_t                      str_0_desc_dma;
> ++      dma_addr_t                      manuf_str_desc_dma;
> ++      dma_addr_t                      product_str_desc_dma;
> ++      dma_addr_t                      serial_str_desc_dma;
> ++
> ++      /* EPs */
> ++      struct xhci_virt_ep             dbc_out_ep;
> ++      struct xhci_virt_ep             dbc_in_ep;
> ++      struct xhci_ring                *dbc_out_ring;
> ++      struct xhci_ring                *dbc_in_ring;
> ++      struct list_head                dbc_out_urb_list;
> ++      struct list_head                dbc_in_urb_list;
> ++
> ++      /* Event ring */
> ++      struct xhci_ring                *dbc_event_ring;
> ++      struct xhci_erst                dbc_erst;
> ++
> ++      /* Event thread */
> ++      struct task_struct              *dbc_thread;
> ++      char                            *dbc_buf_0;
> ++      char                            *dbc_buf_1;
> ++      char                            *dbc_buf_2;
> ++      char                            *dbc_buf_3;
> ++      dma_addr_t                      dbc_buf_0_dma;
> ++      dma_addr_t                      dbc_buf_1_dma;
> ++      dma_addr_t                      dbc_buf_2_dma;
> ++      dma_addr_t                      dbc_buf_3_dma;
> ++      struct urb                      dbc_urb_0;
> ++      struct urb                      dbc_urb_1;
> ++      struct urb                      dbc_urb_2;
> ++      struct urb                      dbc_urb_3;
> ++      int                             dbc_configured;
> ++      int                             dbc_next_0;
> + };
> +
> + /* convert between an HCD pointer and the corresponding EHCI_HCD */
> +@@ -1822,4 +1986,7 @@ struct xhci_input_control_ctx *xhci_get_input_control_ctx(struct xhci_hcd *xhci,
> + struct xhci_slot_ctx *xhci_get_slot_ctx(struct xhci_hcd *xhci, struct xhci_container_ctx *ctx);
> + struct xhci_ep_ctx *xhci_get_ep_ctx(struct xhci_hcd *xhci, struct xhci_container_ctx *ctx, unsigned int ep_index);
> +
> ++int xhci_setup_dbg_cap(struct xhci_hcd *xhci, struct device *dev);
> ++void xhci_teardown_dbg_cap(struct xhci_hcd *xhci, struct device *dev);
> ++
> + #endif /* __LINUX_XHCI_HCD_H */
> --
> 1.9.1
>
Just to let you known I may have hit a error message with checkpatch
that is invalid due to line wrap as all other
git diff lines are fine. There also are still errors about line length
over 80 but that's fine any way.
Cheers Nick
