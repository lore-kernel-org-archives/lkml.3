Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbbA0XgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:36:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbbA0XgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:36:19 -0500
From: NeilBrown <neilb@suse.de>
To: Tony Lindgren <tony@atomide.com>, Ulf Hansson <ulf.hansson@linaro.org>
Date: Wed, 28 Jan 2015 10:35:24 +1100
Subject: [PATCH 1/3] mmc: core: allow non-blocking form of mmc_claim_host
Cc: Andreas Fenkart <afenkart@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>,
        NeilBrown <neil@brown.name>, linux-omap@vger.kernel.org
Message-ID: <20150127233524.32160.26896.stgit@notabene.brown>
In-Reply-To: <20150127233118.32160.11899.stgit@notabene.brown>
References: <20150127233118.32160.11899.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the handling for the 'abort' flag so that if
it is set, but we can claim the host, the do the claim,
rather than aborting.

When the abort is async this just means that a race between aborting
an allowing a claim is resolved slightly differently.  Any
code must already be able to handle 'abort' being set just as the host
is claimed.

This allows extra functionality.  If __mmc_claim_host() is called
with an 'abort' point which is initialized to '1', it will effect a
non-blocking 'claim'.

Signed-off-by: NeilBrown <neil@brown.name>
---
 drivers/mmc/core/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index b8cc02b325c4..7162ada24a24 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -903,10 +903,11 @@ int __mmc_claim_host(struct mmc_host *host, atomic_t *abort)
 		spin_lock_irqsave(&host->lock, flags);
 	}
 	set_current_state(TASK_RUNNING);
-	if (!stop) {
+	if (!host->claimed || host->claimer == current) {
 		host->claimed = 1;
 		host->claimer = current;
 		host->claim_cnt += 1;
+		stop = 0;
 	} else
 		wake_up(&host->wq);
 	spin_unlock_irqrestore(&host->lock, flags);


