Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaK0Hcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:32:52 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:37088 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaK0Hcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:32:50 -0500
MIME-Version: 1.0
In-Reply-To: <1415055950-64090-1-git-send-email-s-anna@ti.com>
References: <1415055950-64090-1-git-send-email-s-anna@ti.com>
Date: Thu, 27 Nov 2014 13:02:49 +0530
Message-ID: <CAJe_Zhc7-PZn01C+fNhQ1WZrYcXxiw6eP5xhXVgxACQrM=W2Pg@mail.gmail.com>
Subject: Re: [PATCH v4] mailbox/omap: adapt to the new mailbox framework
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Suman Anna <s-anna@ti.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Dave Gerlach <d-gerlach@ti.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 November 2014 at 04:35, Suman Anna <s-anna@ti.com> wrote:
> The OMAP mailbox driver and its existing clients (remoteproc
> for OMAP4+) are adapted to use the generic mailbox framework.
>
> The main changes for the adaptation are:
>   - The tasklet used for Tx is replaced with the state machine from
>     the generic mailbox framework. The workqueue used for processing
>     the received messages stays intact for minimizing the effects on
>     the OMAP mailbox clients.
>   - The existing exported client API, omap_mbox_get, omap_mbox_put and
>     omap_mbox_send_msg are deleted, as the framework provides equivalent
>     functionality. A OMAP-specific omap_mbox_request_channel is added
>     though to support non-DT way of requesting mailboxes.
>   - The OMAP mailbox driver is integrated with the mailbox framework
>     through the proper implementations of mbox_chan_ops, except for
>     .last_tx_done and .peek_data. The OMAP mailbox driver does not need
>     these ops, as it is completely interrupt driven.
>   - The OMAP mailbox driver uses a custom of_xlate controller ops that
>     allows phandles for the pargs specifier instead of indexing to avoid
>     any channel registration order dependencies.
>   - The new framework does not support multiple clients operating on a
>     single channel, so the reference counting logic is simplified.
>   - The remoteproc driver (current client) is adapted to use the new API.
>     The notifier callbacks used within this client is replaced with the
>     regular callbacks from the newer framework.
>   - The exported OMAP mailbox API are limited to omap_mbox_save_ctx,
>     omap_mbox_restore_ctx, omap_mbox_enable_irq & omap_mbox_disable_irq,
>     with the signature modified to take in the new mbox_chan handle instead
>     of the OMAP specific omap_mbox handle. The first 2 will be removed when
>     the OMAP mailbox driver is adapted to runtime_pm. The other exported
>     API omap_mbox_request_channel will be removed once existing legacy
>     users are converted to DT.
>
> Cc: Jassi Brar <jassisinghbrar@gmail.com>
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Signed-off-by: Suman Anna <s-anna@ti.com>
> ---
> v3->v4: No code changes, switched the example to use the DSP node instead of
> WkupM3 in the bindings document & minor commit description changes. Other than
> that, this is a repost of the driver adaptation patch [1] from the OMAP Mailbox
> framework adaptation series [2]. This patch is intended for the 3.19 merge window,
> all the dependent patches in [2] are merged as of 3.18-rc2. The DTS patch in [2]
> will be posted separately.
>
> [1] http://marc.info/?l=linux-omap&m=141038453917790&w=2
> [2] http://marc.info/?l=linux-omap&m=141038447817775&w=2
>
>  .../devicetree/bindings/mailbox/omap-mailbox.txt   |  23 ++
>  drivers/mailbox/omap-mailbox.c                     | 346 ++++++++++++---------
>  drivers/remoteproc/omap_remoteproc.c               |  51 +--
>  include/linux/omap-mailbox.h                       |  16 +-
>  4 files changed, 256 insertions(+), 180 deletions(-)
>
Applied to mailbox-devel, Thanks
-Jassi
