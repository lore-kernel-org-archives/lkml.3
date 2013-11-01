Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3KASPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:15:50 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:45792 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab3KASPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:15:47 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC 4/9] of/irq: Refactor interrupt-map parsing
To: Olof Johansson <olof@lixom.net>
Cc: devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20131031185714.GA12646@quad.lixom.net>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org> <1381869563-16083-5-git-send-email-grant.likely@linaro.org> <CAOesGMj03kgJXttm80pHvPYeqg5hOaeOJAJ4DA8tf5LxqdArrQ@mail.gmail.com> <CACxGe6uE+KvycQq3XBavRcvprff6PhBaxX54W_Cb1cfuVpMXvQ@mail.gmail.com> <20131031185714.GA12646@quad.lixom.net>
Date: Fri, 01 Nov 2013 10:53:17 -0700
Message-Id: <20131101175317.A812AC40868@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Oct 2013 11:57:14 -0700, Olof Johansson <olof@lixom.net> wrote:
> On Wed, Oct 30, 2013 at 02:25:21PM -0700, Grant Likely wrote:
> > (Sorry for HTML mail)
> > 
> > Can you put #define DEBUG at the top of drivers/of/irq.c and send me the
> > log output from before and after the commit?
> 
> Here you go, quite verbose log below.
> 
> Looks like we're tripping the "no reg passed in" checks, not sure if related.

I think I've found the bug. See if this helps...

>From 54a6d89d63361f8117ff69e4b65efabb12b897c7 Mon Sep 17 00:00:00 2001
From: Grant Likely <grant.likely@linaro.org>
Date: Fri, 1 Nov 2013 10:50:50 -0700
Subject: [PATCH] of: Fixup interrupt parsing failure.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/irq.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 8cc62b4a7988..c3427c8579a2 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -17,7 +17,7 @@
  * device tree to actual irq numbers on an interrupt controller
  * driver.
  */
-
+#define DEBUG
 #include <linux/errno.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -97,7 +97,7 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 	struct device_node *ipar, *tnode, *old = NULL, *newpar = NULL;
 	__be32 initial_match_array[8];
 	const __be32 *match_array = initial_match_array;
-	const __be32 *tmp, *imap, *imask, dummy_imask[] = { ~0, ~0, ~0, ~0, ~0 };
+	const __be32 *tmp, *imap, *imask, dummy_imask[] = { ~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0 };
 	u32 intsize = 1, addrsize, newintsize = 0, newaddrsize = 0;
 	int imaplen, match, i;
 
@@ -147,21 +147,14 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 
 	pr_debug(" -> addrsize=%d\n", addrsize);
 
-	/* If we were passed no "reg" property and we attempt to parse
-	 * an interrupt-map, then #address-cells must be 0.
-	 * Fail if it's not.
-	 */
-	if (addr == NULL && addrsize != 0) {
-		pr_debug(" -> no reg passed in when needed !\n");
-		return -EINVAL;
+	if (addrsize && addr) {
+		/* Precalculate the initial match array to simplify match loop */
+		for (i = 0; i < addrsize; i++)
+			initial_match_array[i] = addr[i];
+		for (i = 0; i < intsize; i++)
+			initial_match_array[addrsize + i] = cpu_to_be32(out_irq->args[i]);
 	}
 
-	/* Precalculate the match array - this simplifies match loop */
-	for (i = 0; i < addrsize; i++)
-		initial_match_array[i] = addr[i];
-	for (i = 0; i < intsize; i++)
-		initial_match_array[addrsize + i] = cpu_to_be32(out_irq->args[i]);
-
 	/* Now start the actual "proper" walk of the interrupt tree */
 	while (ipar != NULL) {
 		/* Now check if cursor is an interrupt-controller and if it is
@@ -174,6 +167,15 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 			return 0;
 		}
 
+		/* If we were passed no "reg" property and we attempt to parse
+		 * an interrupt-map, then #address-cells must be 0.
+		 * Fail if it's not.
+		 */
+		if (addrsize && !addr) {
+			pr_debug(" -> no reg passed in when needed !\n");
+			return -EINVAL;
+		}
+
 		/* Now look for an interrupt-map */
 		imap = of_get_property(ipar, "interrupt-map", &imaplen);
 		/* No interrupt map, check for an interrupt parent */
-- 
1.8.1.2

