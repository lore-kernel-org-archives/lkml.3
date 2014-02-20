Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbaBTXwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:52:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbaBTXv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pontus Fuchs <pontus.fuchs@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.12 18/82] nl80211: Reset split_start when netlink skb is exhausted
Date: Thu, 20 Feb 2014 15:52:01 -0800
Message-Id: <20140220235020.029125699@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pontus Fuchs <pontus.fuchs@gmail.com>

commit f12cb2893069495726c21a4b0178705dacfecfe0 upstream.

When the netlink skb is exhausted split_start is left set. In the
subsequent retry, with a larger buffer, the dump is continued from the
failing point instead of from the beginning.

This was causing my rt28xx based USB dongle to now show up when
running "iw list" with an old iw version without split dump support.

Fixes: 3713b4e364ef ("nl80211: allow splitting wiphy information in dumps")
Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
[avoid the entire workaround when state->split is set]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1655,9 +1655,10 @@ static int nl80211_dump_wiphy(struct sk_
 				 * We can then retry with the larger buffer.
 				 */
 				if ((ret == -ENOBUFS || ret == -EMSGSIZE) &&
-				    !skb->len &&
+				    !skb->len && !state->split &&
 				    cb->min_dump_alloc < 4096) {
 					cb->min_dump_alloc = 4096;
+					state->split_start = 0;
 					rtnl_unlock();
 					return 1;
 				}


