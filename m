Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbaJCVl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:41:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbaJCVdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:33:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.16 083/357] imx-drm: imx-ldb: fix NULL pointer in imx_ldb_unbind()
Date: Fri,  3 Oct 2014 14:27:49 -0700
Message-Id: <20141003212935.977141181@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit d9fdb9fba7ec08769594abede8f78523ed3f025a upstream.

When trying to unbind imx-drm, the following oops was observed from
the imx-ldb driver:

Unable to handle kernel NULL pointer dereference at virtual address 0000001c
pgd = de954000
[0000001c] *pgd=2e92c831, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] SMP ARM
Modules linked in: bnep rfcomm bluetooth nfsd exportfs hid_cypress brcmfmac brcmutil snd_soc_fsl_ssi snd_soc_fsl_spdif imx_pcm_fiq imx_pcm_dma imx_ldb(C) imx_thermal imx_sdma imx2_wdt snd_soc_sgtl5000 snd_soc_imx_sgtl5000 snd_soc_imx_spdif snd_soc_imx_audmux
CPU: 1 PID: 1228 Comm: bash Tainted: G         C    3.16.0-rc2+ #1229
task: ea378d80 ti: de948000 task.ti: de948000
PC is at imx_ldb_unbind+0x1c/0x58 [imx_ldb]
LR is at component_unbind+0x38/0x70
pc : [<bf025068>]    lr : [<c0353108>]    psr: 200f0013
sp : de949da8  ip : de949dc0  fp : de949dbc
r10: e9a44b0c  r9 : 00000000  r8 : de949f78
r7 : 00000012  r6 : e9b3f400  r5 : e9b133b8  r4 : e9b13010
r3 : 00000000  r2 : e9b3f400  r1 : ea9a0210  r0 : e9b13020
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c53c7d  Table: 2e95404a  DAC: 00000015
Process bash (pid: 1228, stack limit = 0xde948240)
Stack: (0xde949da8 to 0xde94a000)
...
Backtrace:
[<bf02504c>] (imx_ldb_unbind [imx_ldb]) from [<c0353108>] (component_unbind+0x38/0x70)
[<c03530d0>] (component_unbind) from [<c03531d4>] (component_unbind_all+0x94/0xc8)
[<c0353140>] (component_unbind_all) from [<c04bc224>] (imx_drm_driver_unload+0x34/0x4c)
[<c04bc1f0>] (imx_drm_driver_unload) from [<c03394a4>] (drm_dev_unregister+0x2c/0xa0)
[<c0339478>] (drm_dev_unregister) from [<c0339f8c>] (drm_put_dev+0x30/0x6c)
[<c0339f5c>] (drm_put_dev) from [<c04bc1cc>] (imx_drm_unbind+0x14/0x18)
[<c04bc1b8>] (imx_drm_unbind) from [<c03530b4>] (component_master_del+0xbc/0xd8)
...
Code: e5904058 e2840010 e2845fea e59430a0 (e593301c)
---[ end trace 4f211c6dbbcd4963 ]---

This is caused by only having one channel out of the pair configured in
DT; the second channel remains uninitialised, but upon unbind, the
driver attempts to clean up both, thereby dereferencing a NULL pointer.
Avoid this by checking that the second channel is initialised.

Fixes: 1b3f76756633 ("imx-drm: initialise drm components directly")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/imx-drm/imx-ldb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/imx-drm/imx-ldb.c
+++ b/drivers/staging/imx-drm/imx-ldb.c
@@ -574,6 +574,9 @@ static void imx_ldb_unbind(struct device
 	for (i = 0; i < 2; i++) {
 		struct imx_ldb_channel *channel = &imx_ldb->channel[i];
 
+		if (!channel->connector.funcs)
+			continue;
+
 		channel->connector.funcs->destroy(&channel->connector);
 		channel->encoder.funcs->destroy(&channel->encoder);
 	}


