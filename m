Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbbALMuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:50:16 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61657 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbbALMuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:50:10 -0500
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        bernd.lehmann@volkswagen.de, lisovy@gmail.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH] iw: Add OCB mode handling
Date: Mon, 12 Jan 2015 13:49:57 +0100
Message-Id: <1421066997-8676-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the commit 6e0bd6c35b021dc73a81ebd1ef79761233c48b50
("cfg80211: 802.11p OCB mode handling") and
239281f803e2efdb77d906ef296086b6917e5d71
("mac80211: 802.11p OCB mode support")
does the Linux kernel support OCB mode. This commit adds
proper OCB mode handling.

Modify the command for device type setting to support OCB mode.
Add commands for "joining" and "leaving" the OCB mode network.
When joining two arguments are mandatory -- frequency and
channel bandwidth (5 or 10 MHz).

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 Makefile    |  2 +-
 interface.c |  3 +++
 ocb.c       | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 util.c      |  1 +
 4 files changed, 81 insertions(+), 1 deletion(-)
 create mode 100644 ocb.c

diff --git a/Makefile b/Makefile
index 58755dc..548591a 100644
--- a/Makefile
+++ b/Makefile
@@ -13,7 +13,7 @@ CFLAGS ?= -O2 -g
 CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
 
 OBJS = iw.o genl.o event.o info.o phy.o \
-	interface.o ibss.o station.o survey.o util.o \
+	interface.o ibss.o station.o survey.o util.o ocb.o \
 	mesh.o mpath.o mpp.o scan.o reg.o version.o \
 	reason.o status.o connect.o link.o offch.o ps.o cqm.o \
 	bitrate.o wowlan.o coalesce.o roc.o p2p.o vendor.o
diff --git a/interface.c b/interface.c
index f8e39b3..80437bd 100644
--- a/interface.c
+++ b/interface.c
@@ -104,6 +104,9 @@ static int get_if_type(int *argc, char ***argv, enum nl80211_iftype *type,
 	    strcmp(tpstr, "ibss") == 0) {
 		*type = NL80211_IFTYPE_ADHOC;
 		return 0;
+	} else if (strcmp(tpstr, "ocb") == 0) {
+		*type = NL80211_IFTYPE_OCB;
+		return 0;
 	} else if (strcmp(tpstr, "monitor") == 0) {
 		*type = NL80211_IFTYPE_MONITOR;
 		return 0;
diff --git a/ocb.c b/ocb.c
new file mode 100644
index 0000000..7da05d1
--- /dev/null
+++ b/ocb.c
@@ -0,0 +1,76 @@
+#include <net/if.h>
+#include <errno.h>
+#include <string.h>
+
+#include "nl80211.h"
+#include "iw.h"
+
+SECTION(ocb);
+
+static int join_ocb(struct nl80211_state *state, struct nl_cb *cb,
+		    struct nl_msg *msg, int argc, char **argv,
+		    enum id_input id)
+{
+	unsigned long freq;
+	char *end;
+	int i;
+	static const struct {
+		const char *name;
+		unsigned int width;
+	} *chanmode_selected, chanmode[] = {
+		{ .name = "5MHZ",
+		  .width = NL80211_CHAN_WIDTH_5	},
+		{ .name = "10MHZ",
+		  .width = NL80211_CHAN_WIDTH_10 },
+	};
+
+	if (argc < 2)
+		return 1;
+
+	/* freq */
+	freq = strtoul(argv[0], &end, 10);
+	if (*end != '\0')
+		return 1;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
+	argv++;
+	argc--;
+
+	/* channel width */
+	for (i = 0; i < ARRAY_SIZE(chanmode); i++) {
+		if (strcasecmp(chanmode[i].name, argv[0]) == 0) {
+			chanmode_selected = &chanmode[i];
+			break;
+		}
+	}
+	if (chanmode_selected) {
+		NLA_PUT_U32(msg, NL80211_ATTR_CHANNEL_WIDTH,
+			    chanmode_selected->width);
+		NLA_PUT_U32(msg, NL80211_ATTR_CENTER_FREQ1, freq);
+
+		argv++;
+		argc--;
+	} else {
+		return 1;
+	}
+
+	return 0;
+
+nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(ocb, join, "<freq in MHz> <5MHZ|10MHZ>",
+	NL80211_CMD_JOIN_OCB, 0, CIB_NETDEV, join_ocb,
+	"Join the OCB mode network.");
+
+static int leave_ocb(struct nl80211_state *state, struct nl_cb *cb,
+		     struct nl_msg *msg, int argc, char **argv,
+		     enum id_input id)
+{
+	if (argc)
+		return 1;
+
+	return 0;
+}
+COMMAND(ocb, leave, NULL, NL80211_CMD_LEAVE_OCB, 0, CIB_NETDEV, leave_ocb,
+	"Leave the OCB mode network.");
diff --git a/util.c b/util.c
index 7b51b23..411fea1 100644
--- a/util.c
+++ b/util.c
@@ -133,6 +133,7 @@ static const char *ifmodes[NL80211_IFTYPE_MAX + 1] = {
 	"P2P-client",
 	"P2P-GO",
 	"P2P-device",
+	"outside context of a BSS",
 };
 
 static char modebuf[100];
-- 
2.0.0.rc4

