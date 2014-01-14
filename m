Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaANA3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:29:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbaANA3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:29:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dawid Stawiarski <dawid.stawiarski@netart.pl>,
        Phil Oester <kernel@linuxace.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.12 71/77] netfilter: fix wrong byte order in nf_ct_seqadj_set internal information
Date: Mon, 13 Jan 2014 16:28:32 -0800
Message-Id: <20140114002754.508017903@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Oester <kernel@linuxace.com>

commit 23dfe136e2bf8d9ea1095704c535368a9bc721da upstream.

In commit 41d73ec053d2, sequence number adjustments were moved to a
separate file. Unfortunately, the sequence numbers that are stored
in the nf_ct_seqadj structure are expressed in host byte order. The
necessary ntohl call was removed when the call to adjust_tcp_sequence
was collapsed into nf_ct_seqadj_set. This broke the FTP NAT helper.
Fix it by adding back the byte order conversions.

Reported-by: Dawid Stawiarski <dawid.stawiarski@netart.pl>
Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_seqadj.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -41,8 +41,8 @@ int nf_ct_seqadj_set(struct nf_conn *ct,
 	spin_lock_bh(&ct->lock);
 	this_way = &seqadj->seq[dir];
 	if (this_way->offset_before == this_way->offset_after ||
-	    before(this_way->correction_pos, seq)) {
-		this_way->correction_pos = seq;
+	    before(this_way->correction_pos, ntohl(seq))) {
+		this_way->correction_pos = ntohl(seq);
 		this_way->offset_before	 = this_way->offset_after;
 		this_way->offset_after	+= off;
 	}


