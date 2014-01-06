Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbaAFWlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:41:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbaAFWlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Evan Huus <eapache@gmail.com>, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 065/129] radiotap: fix bitmap-end-finding buffer overrun
Date: Mon,  6 Jan 2014 14:38:14 -0800
Message-Id: <20140106223901.465016522@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit bd02cd2549cfcdfc57cb5ce57ffc3feb94f70575 upstream.

Evan Huus found (by fuzzing in wireshark) that the radiotap
iterator code can access beyond the length of the buffer if
the first bitmap claims an extension but then there's no
data at all. Fix this.

Reported-by: Evan Huus <eapache@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/radiotap.c |    4 ++++
 1 file changed, 4 insertions(+)

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


