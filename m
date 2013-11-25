Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3KYNHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:07:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56979 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3KYNHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 10/78] wireless: radiotap: fix parsing buffer overrun
Date: Mon, 25 Nov 2013 13:05:57 +0000
Message-Id: <1385384825-21681-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit f5563318ff1bde15b10e736e97ffce13be08bc1a upstream.

When parsing an invalid radiotap header, the parser can overrun
the buffer that is passed in because it doesn't correctly check
 1) the minimum radiotap header size
 2) the space for extended bitmaps

The first issue doesn't affect any in-kernel user as they all
check the minimum size before calling the radiotap function.
The second issue could potentially affect the kernel if an skb
is passed in that consists only of the radiotap header with a
lot of extended bitmaps that extend past the SKB. In that case
a read-only buffer overrun by at most 4 bytes is possible.

Fix this by adding the appropriate checks to the parser.

Reported-by: Evan Huus <eapache@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/wireless/radiotap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index c4ad795..617a310 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -95,6 +95,10 @@ int ieee80211_radiotap_iterator_init(
 	struct ieee80211_radiotap_header *radiotap_header,
 	int max_length, const struct ieee80211_radiotap_vendor_namespaces *vns)
 {
+	/* check the radiotap header can actually be present */
+	if (max_length < sizeof(struct ieee80211_radiotap_header))
+		return -EINVAL;
+
 	/* Linux only supports version 0 radiotap format */
 	if (radiotap_header->it_version)
 		return -EINVAL;
@@ -129,7 +133,8 @@ int ieee80211_radiotap_iterator_init(
 			 */
 
 			if ((unsigned long)iterator->_arg -
-			    (unsigned long)iterator->_rtheader >
+			    (unsigned long)iterator->_rtheader +
+			    sizeof(uint32_t) >
 			    (unsigned long)iterator->_max_length)
 				return -EINVAL;
 		}
-- 
1.8.3.2

