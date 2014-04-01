Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaDAMUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:20:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42141 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaDALQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 011/144] ath9k: protect tid->sched check
Date: Tue,  1 Apr 2014 12:13:35 +0100
Message-Id: <1396350948-29910-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 21f8aaee0c62708654988ce092838aa7df4d25d8 upstream.

We check tid->sched without a lock taken on ath_tx_aggr_sleep(). That
is race condition which can result of doing list_del(&tid->list) twice
(second time with poisoned list node) and cause crash like shown below:

[424271.637220] BUG: unable to handle kernel paging request at 00100104
[424271.637328] IP: [<f90fc072>] ath_tx_aggr_sleep+0x62/0xe0 [ath9k]
...
[424271.639953] Call Trace:
[424271.639998]  [<f90f6900>] ? ath9k_get_survey+0x110/0x110 [ath9k]
[424271.640083]  [<f90f6942>] ath9k_sta_notify+0x42/0x50 [ath9k]
[424271.640177]  [<f809cfef>] sta_ps_start+0x8f/0x1c0 [mac80211]
[424271.640258]  [<c10f730e>] ? free_compound_page+0x2e/0x40
[424271.640346]  [<f809e915>] ieee80211_rx_handlers+0x9d5/0x2340 [mac80211]
[424271.640437]  [<c112f048>] ? kmem_cache_free+0x1d8/0x1f0
[424271.640510]  [<c1345a84>] ? kfree_skbmem+0x34/0x90
[424271.640578]  [<c10fc23c>] ? put_page+0x2c/0x40
[424271.640640]  [<c1345a84>] ? kfree_skbmem+0x34/0x90
[424271.640706]  [<c1345a84>] ? kfree_skbmem+0x34/0x90
[424271.640787]  [<f809dde3>] ? ieee80211_rx_handlers_result+0x73/0x1d0 [mac80211]
[424271.640897]  [<f80a07a0>] ieee80211_prepare_and_rx_handle+0x520/0xad0 [mac80211]
[424271.641009]  [<f809e22d>] ? ieee80211_rx_handlers+0x2ed/0x2340 [mac80211]
[424271.641104]  [<c13846ce>] ? ip_output+0x7e/0xd0
[424271.641182]  [<f80a1057>] ieee80211_rx+0x307/0x7c0 [mac80211]
[424271.641266]  [<f90fa6ee>] ath_rx_tasklet+0x88e/0xf70 [ath9k]
[424271.641358]  [<f80a0f2c>] ? ieee80211_rx+0x1dc/0x7c0 [mac80211]
[424271.641445]  [<f90f82db>] ath9k_tasklet+0xcb/0x130 [ath9k]

Bug report:
https://bugzilla.kernel.org/show_bug.cgi?id=70551

Reported-and-tested-by: Max Sydorenko <maxim.stargazer@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index ab64683..f0aaeb2 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1318,14 +1318,16 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 	for (tidno = 0, tid = &an->tid[tidno];
 	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
 
-		if (!tid->sched)
-			continue;
-
 		ac = tid->ac;
 		txq = ac->txq;
 
 		ath_txq_lock(sc, txq);
 
+		if (!tid->sched) {
+			ath_txq_unlock(sc, txq);
+			continue;
+		}
+
 		buffered = !skb_queue_empty(&tid->buf_q);
 
 		tid->sched = false;
-- 
1.9.1

