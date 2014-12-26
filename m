Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaLZHXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 02:23:01 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15710 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751197AbaLZHW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 02:22:58 -0500
From: Alex Gartrell <agartrell@fb.com>
To: <davem@davemloft.net>, <herbert@gondor.apana.org.au>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Alex Gartrell <agartrell@fb.com>
Subject: [PATCH net-next] tun: return proper error code from tun_do_read
Date: Thu, 25 Dec 2014 23:22:49 -0800
Message-ID: <1419578569-13132-1-git-send-email-agartrell@fb.com>
X-Mailer: git-send-email 1.8.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-25_06:2014-12-24,2014-12-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.87547199992366e-11 kscore.compositescore=0
 circleOfTrustscore=514.84 compositescore=0.98609165920913
 urlsuspect_oldscore=0.98609165920913 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.98609165920913 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412260079
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of -1 with EAGAIN, read on a O_NONBLOCK tun fd will return 0.  This
fixes this by properly returning the error code from __skb_recv_datagram.

Signed-off-by: Alex Gartrell <agartrell@fb.com>
---
 drivers/net/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index a5cbf67..2f65d6c 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1378,7 +1378,7 @@ static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
 	skb = __skb_recv_datagram(tfile->socket.sk, noblock ? MSG_DONTWAIT : 0,
 				  &peeked, &off, &err);
 	if (!skb)
-		return 0;
+		return err;
 
 	ret = tun_put_user(tun, tfile, skb, to);
 	if (unlikely(ret < 0))
-- 
Alex Gartrell <agartrell@fb.com>

