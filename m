Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaKDMKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:10:23 -0500
Received: from 14.mo4.mail-out.ovh.net ([46.105.40.29]:34675 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752479AbaKDMKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:10:22 -0500
X-Greylist: delayed 4766 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2014 07:10:21 EST
From: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Subject: [PATCH v2] serial: 8250_dw: get index of serial line from DT aliases
Date: Tue,  4 Nov 2014 11:45:55 +0100
Message-Id: <1415097955-31966-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414681129-10578-1-git-send-email-julien.chauveau@neo-technologies.fr>
References: <1414681129-10578-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Ovh-Tracer-Id: 12648641030507331702
X-Ovh-Remote: 193.248.240.88 (laubervilliers-656-01-116-88.w193-248.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrgeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrgeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get index of serial line from device tree using function of_alias_get_id().
If no alias is found, the 8250 core takes care of incrementing the line number.

Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
---
Changes since v1:
- use int type to get the value from of_alias_get_id (fix always true condition)

 drivers/tty/serial/8250/8250_dw.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index beea6ca..d96fc78 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -258,6 +258,7 @@ static int dw8250_probe_of(struct uart_port *p,
 	struct uart_8250_port *up = up_to_u8250p(p);
 	u32			val;
 	bool has_ucv = true;
+	int id;
 
 	if (of_device_is_compatible(np, "cavium,octeon-3860-uart")) {
 #ifdef __BIG_ENDIAN
@@ -293,6 +294,11 @@ static int dw8250_probe_of(struct uart_port *p,
 	if (!of_property_read_u32(np, "reg-shift", &val))
 		p->regshift = val;
 
+	/* get index of serial line, if found in DT aliases */
+	id = of_alias_get_id(np, "serial");
+	if (id >= 0)
+		p->line = id;
+
 	/* clock got configured through clk api, all done */
 	if (p->uartclk)
 		return 0;
-- 
2.1.0

