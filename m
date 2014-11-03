Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaKCJd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:33:29 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:47663 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaKCJd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:33:26 -0500
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com, lisovy@gmail.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 0/2 v3] cfg80211: mac80211: 802.11p OCB mode support
Date: Mon,  3 Nov 2014 10:33:17 +0100
Message-Id: <1415007199-31506-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IEEE 802.11p amendment (already part of IEEE 802.11-2012)
specifies usage of 5 and 10 MHz wide channels in 5.9GHz band for
vehicular environment. All the 802.11p compliant devices should
be set to the newly added operation mode -- OCB (Outside the
Context of a BSS). No authentication/association is necessary to
communicate. The only parameter to be configured is the channel
(central frequency and bandwidth) to communicate on. The channel
has to be known a priori. It is set during the 'ocb join'
operation (sent via netlink message from user-space).

This patchset adds the OCB mode, OCB join and leave handling
(nl80211, cfg80211, mac80211), 802.11p EDCA parameters
modification, RX and TX path (for unicast/broadcast messages).

What aspects are ignored for now:
* Rate control -- We limit the supported datarates to the .11a
  mandatory rates and use the Minstrel as usual
* Actually restricting the OCB mode to the 5.9GHz band

Tested with the ath9k card with slightly modified driver.
User-space configuration utilities are not part of this patch.


Changes since v2:
* Make each separate patch warning-free (define dummy "case
  NL80211_IFTYPE_OCB" statements to mac80211 for the "cfg80211
  patch") (JBerg)
* Remove unnecessary check in nl80211_join_ocb() (JBerg)
* Do not forget to call __cfg80211_leave_ocb() in __cfg80211_leave()
  (JBerg)

Changes since v1:
* Do not define bssid_wildcard in a header file, define it as
  'static const' in ieee80211_setup_sdata only (JBerg)
* Use GFP_ATOMIC memory allocation in ieee80211_ocb_rx_no_sta
  so it can be called in the RX path (JBerg)
* IEEE80211_CHANCTX_EXCLUSIVE -> IEEE80211_CHANCTX_SHARED (JBerg)
* Fix the situation when the housekeeping timer might be called
  during ocb_leave() (JBerg)
* Remove NL80211_CHAN_WIDTH_5/10 from 'old channels' handling
  functions cfg80211_get_chandef_type() and nl80211_send_chandef()
  (JBerg)
* Do not break ABI by adding new fields in the middle of the enum
  nl80211_commands (JBerg)
* Add a flag denoting whether we are joined to the network or not
* Handle multiple consecutive calls to ocb_join
* Many minor fixes


Rostislav Lisovy (2):
  cfg80211: mac80211: 802.11p OCB mode handling
  mac80211: 802.11p OCB mode support

 include/net/cfg80211.h       |  14 +++
 include/net/mac80211.h       |   2 +
 include/uapi/linux/nl80211.h |  11 ++
 net/mac80211/Kconfig         |  11 ++
 net/mac80211/Makefile        |   3 +-
 net/mac80211/cfg.c           |  14 +++
 net/mac80211/chan.c          |   3 +
 net/mac80211/debug.h         |  10 ++
 net/mac80211/driver-ops.h    |   3 +-
 net/mac80211/ieee80211_i.h   |  29 +++++
 net/mac80211/iface.c         |  23 ++++
 net/mac80211/ocb.c           | 250 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c            |  35 ++++++
 net/mac80211/tx.c            |  15 +++
 net/mac80211/util.c          |  31 +++++-
 net/mac80211/wme.c           |   4 +
 net/wireless/Makefile        |   2 +-
 net/wireless/chan.c          |   8 ++
 net/wireless/core.c          |   3 +
 net/wireless/core.h          |  12 +++
 net/wireless/nl80211.c       |  39 +++++++
 net/wireless/ocb.c           |  88 +++++++++++++++
 net/wireless/rdev-ops.h      |  21 ++++
 net/wireless/trace.h         |  21 ++++
 net/wireless/util.c          |   5 +-
 25 files changed, 648 insertions(+), 9 deletions(-)
 create mode 100644 net/mac80211/ocb.c
 create mode 100644 net/wireless/ocb.c

-- 
2.0.0.rc4

