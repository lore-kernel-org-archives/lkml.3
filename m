Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab3BZWdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:33:20 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:52286 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab3BZWdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:33:16 -0500
MIME-Version: 1.0
In-Reply-To: <1361191939-21260-7-git-send-email-Varun.Sethi@freescale.com>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
	<1361191939-21260-7-git-send-email-Varun.Sethi@freescale.com>
Date: Tue, 26 Feb 2013 16:33:15 -0600
Message-ID: <CALRxmdBBO2AoAnKSTNNTYhHZ9fitJKWWeZMUj1ObtFhsZS5iSw@mail.gmail.com>
Subject: Re: [PATCH 6/6 v8] iommu/fsl: Freescale PAMU driver and IOMMU API implementation.
From: Stuart Yoder <b08248@gmail.com>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stuart Yoder <stuart.yoder@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have not got through the entire file, but have a few comments...

+/*
+ * Set the PAACE type as primary and set the coherency required domain
+ * attribute
+ */
+static void pamu_setup_default_xfer_to_host_ppaace(struct paace *ppaace)
+{
+       set_bf(ppaace->addr_bitfields, PAACE_AF_PT, PAACE_PT_PRIMARY);
+
+       set_bf(ppaace->domain_attr.to_host.coherency_required, PAACE_DA_HOST_CR,
+              PAACE_M_COHERENCE_REQ);
+}
+
+/*
+ * Set the PAACE type as secondary and set the coherency required domain
+ * attribute.
+ */
+static void pamu_setup_default_xfer_to_host_spaace(struct paace *spaace)
+{
+       set_bf(spaace->addr_bitfields, PAACE_AF_PT, PAACE_PT_SECONDARY);
+       set_bf(spaace->domain_attr.to_host.coherency_required, PAACE_DA_HOST_CR,
+              PAACE_M_COHERENCE_REQ);
+}

Can we change the names of the above functions...   I know there is some history
with the name, but "xfer_to_host" is confusing.

Maybe just call them:

pamu_init_paace()
pamu_init_spaace()

> +/**
> + * pamu_config_spaace() - Sets up SPAACE entry for specified subwindow
> + *
> + * @liodn:  Logical IO device number
> + * @subwin_cnt:  number of sub-windows associated with dma-window
> + * @subwin_addr: starting address of subwindow
> + * @subwin_size: size of subwindow
> + * @omi: Operation mapping index
> + * @rpn: real (true physical) page number
> + * @snoopid: snoop id for hardware coherency -- if ~snoopid == 0 then
> + *                       snoopid not defined
> + * @stashid: cache stash id for associated cpu
> + * @enable: enable/disable subwindow after reconfiguration
> + * @prot: sub window permissions
> + *
> + * Returns 0 upon success else error code < 0 returned
> + */
> +int pamu_config_spaace(int liodn, u32 subwin_cnt, u32 subwin_addr,
> +                      phys_addr_t subwin_size, u32 omi, unsigned long rpn,
> +                      u32 snoopid, u32 stashid, int enable, int prot)
> +{
> +       struct paace *paace;
> +
> +       /* setup sub-windows */
> +       if (!subwin_cnt) {
> +               pr_err("Invalid subwindow count\n");
> +               return -EINVAL;
> +       }
> +
> +       paace = pamu_get_ppaace(liodn);
> +       if (subwin_addr > 0 && subwin_addr < subwin_cnt && paace) {

Why is the comparison subwin_addr < subwin_cnt?   Seems wrong...

> +               paace = pamu_get_spaace(paace, subwin_addr - 1);
> +
> +               if (paace && !(paace->addr_bitfields & PAACE_V_VALID)) {
> +                       pamu_setup_default_xfer_to_host_spaace(paace);
> +                       set_bf(paace->addr_bitfields, SPAACE_AF_LIODN, liodn);
> +               }
> +       }
> +
> +       if (!paace) {
> +               pr_err("Invalid liodn entry\n");
> +               return -ENOENT;
> +       }
> +
> +       if (!enable && prot == PAACE_AP_PERMS_DENIED) {
> +               if (subwin_addr > 0)
> +                       set_bf(paace->addr_bitfields, PAACE_AF_V,
> +                                PAACE_V_INVALID);
> +               else
> +                       set_bf(paace->addr_bitfields, PAACE_AF_AP,
> +                                prot);
> +               mb();
> +               return 0;
> +       }

Can you add a comment to the above if statement...when is this function called
with PAACE_AP_PERMS_DENIED?


> +       if (subwin_size & (subwin_size - 1) || subwin_size < PAMU_PAGE_SIZE) {
> +               pr_err("subwindow size out of range, or not a power of 2\n");
> +               return -EINVAL;
> +       }
> +
> +       if (rpn == ULONG_MAX) {
> +               pr_err("real page number out of range\n");
> +               return -EINVAL;
> +       }
> +
> +       /* window size is 2^(WSE+1) bytes */
> +       set_bf(paace->win_bitfields, PAACE_WIN_SWSE,
> +              map_addrspace_size_to_wse(subwin_size));
> +
> +       set_bf(paace->impl_attr, PAACE_IA_ATM, PAACE_ATM_WINDOW_XLATE);
> +       paace->twbah = rpn >> 20;
> +       set_bf(paace->win_bitfields, PAACE_WIN_TWBAL, rpn);
> +       set_bf(paace->addr_bitfields, PAACE_AF_AP, prot);
> +
> +       /* configure snoop id */
> +       if (~snoopid != 0)
> +               paace->domain_attr.to_host.snpid = snoopid;
> +
> +       /* set up operation mapping if it's configured */
> +       if (omi < OME_NUMBER_ENTRIES) {
> +               set_bf(paace->impl_attr, PAACE_IA_OTM, PAACE_OTM_INDEXED);
> +               paace->op_encode.index_ot.omi = omi;
> +       } else if (~omi != 0) {
> +               pr_err("bad operation mapping index: %d\n", omi);
> +               return -EINVAL;
> +       }
> +
> +       if (~stashid != 0)
> +               set_bf(paace->impl_attr, PAACE_IA_CID, stashid);
> +
> +       smp_wmb();
> +
> +       if (enable)
> +               paace->addr_bitfields |= PAACE_V_VALID;
> +
> +       mb();
> +
> +       return 0;
> +}
