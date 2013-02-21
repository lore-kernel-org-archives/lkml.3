Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab3BUQq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 11:46:57 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:44101 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab3BUQqy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:46:54 -0500
From: "Roberts, Lee A." <lee.roberts@hp.com>
To: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] sctp: fix association hangs due to errors when reneging
 events from the ordering queue
Thread-Topic: [PATCH 3/4] sctp: fix association hangs due to errors when
 reneging events from the ordering queue
Thread-Index: Ac4QUV5+DLapdcr0SW2nGmW2SRIXew==
Date: Thu, 21 Feb 2013 16:44:48 +0000
Message-ID: <D64EC45690EF85409BA6C4730E0162244310DF0B@G4W3231.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.14]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee A. Roberts <lee.roberts@hp.com>

Resolve SCTP association hangs observed during SCTP stress
testing.  Observable symptoms include communications hangs
with data being held in the association reassembly and/or lobby
(ordering) queues.  Close examination of reassembly queue shows
missing packets.

In sctp_ulpq_renege_list(), events being reneged from the
ordering queue may correspond to multiple TSNs.  Identify
all affected packets; sum freed space and renege from the
tsnmap.

Patch applies to linux-3.8 kernel.

Signed-off-by: Lee A. Roberts <lee.roberts@hp.com>
---
 net/sctp/ulpqueue.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff -uprN -X linux-3.8-vanilla/Documentation/dontdiff linux-3.8-SCTP+2/net/sctp/ulpqueue.c linux-3.8-SCTP+3/net/sctp/ulpqueue.c
--- linux-3.8-SCTP+2/net/sctp/ulpqueue.c	2013-02-21 07:39:40.888281496 -0700
+++ linux-3.8-SCTP+3/net/sctp/ulpqueue.c	2013-02-21 07:55:32.817713326 -0700
@@ -962,8 +962,8 @@ static __u16 sctp_ulpq_renege_list(struc
 		struct sk_buff_head *list, __u16 needed)
 {
 	__u16 freed = 0;
-	__u32 tsn;
-	struct sk_buff *skb;
+	__u32 tsn, last_tsn;
+	struct sk_buff *skb, *flist, *last;
 	struct sctp_ulpevent *event;
 	struct sctp_tsnmap *tsnmap;
 
@@ -977,10 +977,28 @@ static __u16 sctp_ulpq_renege_list(struc
 		if (TSN_lte(tsn, sctp_tsnmap_get_ctsn(tsnmap)))
 			break;
 
-		__skb_unlink(skb, list);
+		/* Events in ordering queue may have multiple fragments
+		 * corresponding to additional TSNs.  Sum the total
+		 * freed space; find the last TSN.
+		 */
 		freed += skb_headlen(skb);
+		flist = skb_shinfo(skb)->frag_list;
+		for (last = flist; flist; flist = flist->next) {
+			last = flist;
+			freed += skb_headlen(last);
+		}
+		if (last)
+			last_tsn = sctp_skb2event(last)->tsn;
+		else
+			last_tsn = tsn;
+
+		/* Unlink the event, then renege all applicable TSNs. */
+		__skb_unlink(skb, list);
 		sctp_ulpevent_free(event);
-		sctp_tsnmap_renege(tsnmap, tsn);
+		while (TSN_lte(tsn, last_tsn)) {
+			sctp_tsnmap_renege(tsnmap, tsn);
+			tsn++;
+		}
 		if (freed >= needed)
 			return freed;
 	}
