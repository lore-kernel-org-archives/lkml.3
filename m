Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaGBNAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:00:47 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55948 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751591AbaGBNAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:00:44 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18HmrT47EnwiMefBISZvWRej8+UJQFv1hs=
X-DKIM: OpenDKIM Filter v2.0.1 titan 004DA5A0380
From: Jason Cooper <jason@lakedaemon.net>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Jason Cooper <jason@lakedaemon.net>, Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, <stable@vger.kernel.org>
Subject: [PATCH 2/2 v2] hwrng: virtio: disable reading during probe
Date: Wed,  2 Jul 2014 13:00:20 +0000
Message-Id: <1404306020-24916-2-git-send-email-jason@lakedaemon.net>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404306020-24916-1-git-send-email-jason@lakedaemon.net>
References: <cover.1404296679.git.amit.shah@redhat.com>
 <1404306020-24916-1-git-send-email-jason@lakedaemon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hwrng core asks for random data in the hwrng_register() call itself
from commit d9e7972619.  This doesn't play well with virtio -- the
DRIVER_OK bit is only set by virtio core on a successful probe, and
we're not yet out of our probe routine when this call is made.  This
causes the host to not acknowledge any requests we put in the virtqueue,
and the insmod or kernel boot process just waits for data to arrive from
the host, which never happens.

The previous commit makes the hwrng core check for the
HWRNG_NO_READ_AT_PROBE flag before reading from the device  If the flag
is set, the request for random data isn't made, and the stall when
loading the module doesn't happen.

[jac: reworked to use a flag instead of an init function.  Reused most
of Amit's commit message. ]

CC: Kees Cook <keescook@chromium.org>
CC: Jason Cooper <jason@lakedaemon.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: <stable@vger.kernel.org> # v3.15+
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/char/hw_random/virtio-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index f3e71501de54..f83433bb1fae 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -115,6 +115,7 @@ static int probe_common(struct virtio_device *vdev)
 		.cleanup = virtio_cleanup,
 		.priv = (unsigned long)vi,
 		.name = vi->name,
+		.flags = HWRNG_NO_READ_AT_PROBE,
 	};
 	vdev->priv = vi;
 
-- 
2.0.0

