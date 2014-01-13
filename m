Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaAMOwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:52:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51330 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaAMOZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 37/96] radiotap: fix bitmap-end-finding buffer overrun
Date: Mon, 13 Jan 2014 14:24:00 +0000
Message-Id: <1389623099-18783-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit bd02cd2549cfcdfc57cb5ce57ffc3feb94f70575 upstream.

Evan Huus found (by fuzzing in wireshark) that the radiotap
iterator code can access beyond the length of the buffer if
the first bitmap claims an extension but then there's no
data at all. Fix this.

Reported-by: Evan Huus <eapache@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/wireless/radiotap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index 617a310..60549a4 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -122,6 +122,10 @@ int ieee80211_radiotap_iterator_init(
 	/* find payload start allowing for extended bitmap(s) */
 
 	if (iterator->_bitmap_shifter & (1<<IEEE80211_RADIOTAP_EXT)) {
+		if ((unsigned long)iterator->_arg -
+		    (unsigned long)iterator->_rtheader + sizeof(uint32_t) >
+		    (unsigned long)iterator->_max_length)
+			return -EINVAL;
 		while (get_unaligned_le32(iterator->_arg) &
 					(1 << IEEE80211_RADIOTAP_EXT)) {
 			iterator->_arg += sizeof(uint32_t);
-- 
1.8.3.2

