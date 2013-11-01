Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3KAWIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:08:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395Ab3KAWIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Evan Huus <eapache@gmail.com>, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.11 61/66] wireless: radiotap: fix parsing buffer overrun
Date: Fri,  1 Nov 2013 15:07:37 -0700
Message-Id: <20131101220651.666000242@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/radiotap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -97,6 +97,10 @@ int ieee80211_radiotap_iterator_init(
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
@@ -131,7 +135,8 @@ int ieee80211_radiotap_iterator_init(
 			 */
 
 			if ((unsigned long)iterator->_arg -
-			    (unsigned long)iterator->_rtheader >
+			    (unsigned long)iterator->_rtheader +
+			    sizeof(uint32_t) >
 			    (unsigned long)iterator->_max_length)
 				return -EINVAL;
 		}


