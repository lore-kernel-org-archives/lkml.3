Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3BSICv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:02:51 -0500
Received: from ozlabs.org ([203.10.76.45]:58877 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758091Ab3BSICm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:42 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: sjur.brandeland@stericsson.com, "David S. Miller" <davem@davemloft.net>,
        Ohad Ben-Cohen <ohad@wizery.com>
Cc: sjur@brendeland.net, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>,
        Vikram ARV <vikram.arv@stericsson.com>,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Ido Yariv <ido@wizery.com>
Subject: Re: [PATCHv2 vringh 3/3] caif_virtio: Introduce caif over virtio
In-Reply-To: <1360669793-6921-4-git-send-email-sjur.brandeland@stericsson.com>
References: <1360669793-6921-1-git-send-email-sjur.brandeland@stericsson.com> <1360669793-6921-4-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 19 Feb 2013 10:07:18 +1030
Message-ID: <87k3q5i47l.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sjur.brandeland@stericsson.com writes:
> From: Vikram ARV <vikram.arv@stericsson.com>
>
> Add the the Virtio shared memory driver for STE Modems.
> caif_virtio is implemented utilizing the virtio framework
> for data transport and is managed with the remoteproc frameworks.
>
> The Virtio queue is used for transmitting data to the modem, and
> the new vringh implementation is receiving data over the vring.
>
> Signed-off-by: Vikram ARV <vikram.arv@stericsson.com>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

I have applied 1 and 3 (2 is already in virtio-next); they're in my
pending-rebases branch behind the vringh patches which are pending
a final review.

Here's the warning fix patch I applied:

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index d4f339c..df832e7 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -483,7 +483,7 @@ static int cfv_probe(struct virtio_device *vdev)
 
 	vdev->priv = cfv;
 
-	vringh_iov_init(&cfv->ctx.riov, NULL, 0);
+	vringh_kiov_init(&cfv->ctx.riov, NULL, 0);
 	cfv->ctx.head = USHRT_MAX;
 
 	netif_napi_add(netdev, &cfv->napi, cfv_rx_poll, CFV_DEFAULT_QUOTA);
@@ -517,7 +517,7 @@ static void cfv_remove(struct virtio_device *vdev)
 	struct cfv_info *cfv = vdev->priv;
 
 	tasklet_kill(&cfv->tx_release_tasklet);
-	vringh_iov_cleanup(&cfv->ctx.riov);
+	vringh_kiov_cleanup(&cfv->ctx.riov);
 	vdev->config->reset(vdev);
 	rproc_virtio_del_vringh(vdev, RX_RING_INDEX);
 	cfv->vr_rx = NULL;

Cheers,
Rusty.
