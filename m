Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaAOWcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:32:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40886 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaAOV4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:56:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 113/166] radiotap: fix bitmap-end-finding buffer overrun
Date: Wed, 15 Jan 2014 13:52:07 -0800
Message-Id: <1389822780-4729-114-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit bd02cd2549cfcdfc57cb5ce57ffc3feb94f70575 upstream.

Evan Huus found (by fuzzing in wireshark) that the radiotap
iterator code can access beyond the length of the buffer if
the first bitmap claims an extension but then there's no
data at all. Fix this.

Reported-by: Evan Huus <eapache@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/wireless/radiotap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index a271c27..722da61 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -124,6 +124,10 @@ int ieee80211_radiotap_iterator_init(
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

