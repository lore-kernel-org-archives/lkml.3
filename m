Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab3KYNyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:54:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58990 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754526Ab3KYNxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:43 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johannes Berg" <johannes.berg@intel.com>,
        "Evan Huus" <eapache@gmail.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.447573664@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 66/87] wireless: radiotap: fix parsing buffer overrun
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/radiotap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

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

