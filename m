Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaLDVaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:30:16 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:58606 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaLDVaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:30:14 -0500
Subject: [PATCH 3/5] pcmcia: Fix requery
From: Alan Cox <alan@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-pcmica@lists.infradead.org
Date: Thu, 04 Dec 2014 21:30:00 +0000
Message-ID: <20141204212933.1351.53861.stgit@localhost.localdomain>
In-Reply-To: <20141204212746.1351.89165.stgit@localhost.localdomain>
References: <20141204212746.1351.89165.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The requery logic goes off and attempts to read the CIS of empty slots. In
most cases this happens not to do any harm - but not all!

Add the missing check and also a WARN() to catch any other offenders.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/pcmcia/cistpl.c |    2 +-
 drivers/pcmcia/ds.c     |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
index 4ff725c..8b3b492 100644
--- a/drivers/pcmcia/cistpl.c
+++ b/drivers/pcmcia/cistpl.c
@@ -1386,7 +1386,7 @@ int pccard_validate_cis(struct pcmcia_socket *s, unsigned int *info)
 	if (!s)
 		return -EINVAL;
 
-	if (s->functions) {
+	if (s->functions || !(s->state & SOCKET_PRESENT)) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 757119b..d3baf0b 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -667,6 +667,9 @@ static void pcmcia_requery(struct pcmcia_socket *s)
 {
 	int has_pfc;
 
+	if (!(s->state & SOCKET_PRESENT))
+		return;
+
 	if (s->functions == 0) {
 		pcmcia_card_add(s);
 		return;

