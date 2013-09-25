Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab3IYAZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:25:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab3IYAVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:21:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: [ 103/117] amd64_edac: Fix single-channel setups
Date: Tue, 24 Sep 2013 17:19:29 -0700
Message-Id: <20130925001752.172013738@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@suse.de>

commit f0a56c480196a98479760862468cc95879df3de0 upstream.

It can happen that configurations are running in a single-channel mode
even with a dual-channel memory controller, by, say, putting the DIMMs
only on the one channel and leaving the other empty. This causes a
problem in init_csrows which implicitly assumes that when the second
channel is enabled, i.e. channel 1, the struct dimm hierarchy will be
present. Which is not.

So always allocate two channels unconditionally.

This provides for the nice side effect that the data structures are
initialized so some day, when memory hotplug is supported, it should
just work out of the box when all of a sudden a second channel appears.

Reported-and-tested-by: Roger Leigh <rleigh@debian.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/amd64_edac.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2470,8 +2470,15 @@ static int amd64_init_one_instance(struc
 	layers[0].size = pvt->csels[0].b_cnt;
 	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
-	layers[1].size = pvt->channel_count;
+
+	/*
+	 * Always allocate two channels since we can have setups with DIMMs on
+	 * only one channel. Also, this simplifies handling later for the price
+	 * of a couple of KBs tops.
+	 */
+	layers[1].size = 2;
 	layers[1].is_virt_csrow = false;
+
 	mci = edac_mc_alloc(nid, ARRAY_SIZE(layers), layers, 0);
 	if (!mci)
 		goto err_siblings;


