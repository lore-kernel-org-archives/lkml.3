Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbaLDV3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:29:34 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:58602 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315AbaLDV3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:29:33 -0500
Subject: [PATCH 2/5] pcmcia cis: on an out of range CIS read return 0xff,
 don't just warn
From: Alan Cox <alan@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-pcmica@lists.infradead.org
Date: Thu, 04 Dec 2014 21:29:22 +0000
Message-ID: <20141204212903.1351.22063.stgit@localhost.localdomain>
In-Reply-To: <20141204212746.1351.89165.stgit@localhost.localdomain>
References: <20141204212746.1351.89165.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code displays warnings but then proceeds to try and reference
the data through the PCMCIA window. Instead return 0xff. This prevents bogus
CIS data sending us off into hyperspace.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/pcmcia/cistpl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
index 884a984..4ff725c 100644
--- a/drivers/pcmcia/cistpl.c
+++ b/drivers/pcmcia/cistpl.c
@@ -168,9 +168,12 @@ int pcmcia_read_cis_mem(struct pcmcia_socket *s, int attr, u_int addr,
 	} else {
 		u_int inc = 1, card_offset, flags;
 
-		if (addr > CISTPL_MAX_CIS_SIZE)
+		if (addr > CISTPL_MAX_CIS_SIZE) {
 			dev_dbg(&s->dev,
 				"attempt to read CIS mem at addr %#x", addr);
+			memset(ptr, 0xff, len);
+			return -1;
+		}
 
 		flags = MAP_ACTIVE | ((cis_width) ? MAP_16BIT : 0);
 		if (attr) {

