Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab3KASyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:54:11 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:33058 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3KASyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:54:09 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC 4/9] of/irq: Refactor interrupt-map parsing
To: Olof Johansson <olof@lixom.net>
Cc: devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20131101175317.A812AC40868@trevor.secretlab.ca>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org> <1381869563-16083-5-git-send-email-grant.likely@linaro.org> <CAOesGMj03kgJXttm80pHvPYeqg5hOaeOJAJ4DA8tf5LxqdArrQ@mail.gmail.com> <CACxGe6uE+KvycQq3XBavRcvprff6PhBaxX54W_Cb1cfuVpMXvQ@mail.gmail.com> <20131031185714.GA12646@quad.lixom.net> <20131101175317.A812AC40868@trevor.secretlab.ca>
Date: Fri, 01 Nov 2013 11:54:01 -0700
Message-Id: <20131101185401.B298FC40868@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Nov 2013 10:53:17 -0700, Grant Likely <grant.likely@linaro.org> wrote:
> On Thu, 31 Oct 2013 11:57:14 -0700, Olof Johansson <olof@lixom.net> wrote:
> > On Wed, Oct 30, 2013 at 02:25:21PM -0700, Grant Likely wrote:
> > > (Sorry for HTML mail)
> > > 
> > > Can you put #define DEBUG at the top of drivers/of/irq.c and send me the
> > > log output from before and after the commit?
> > 
> > Here you go, quite verbose log below.
> > 
> > Looks like we're tripping the "no reg passed in" checks, not sure if related.
> 
> I think I've found the bug. See if this helps...

That one was broken. Try this instead.

>From bcbffc3d16f49451ef505dc021480aa061465a15 Mon Sep 17 00:00:00 2001
From: Grant Likely <grant.likely@linaro.org>
Date: Fri, 1 Nov 2013 10:50:50 -0700
Subject: [PATCH] of: Fixup interrupt parsing failure.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/irq.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 8cc62b4a7988..422f253b61c1 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -97,7 +97,7 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 	struct device_node *ipar, *tnode, *old = NULL, *newpar = NULL;
 	__be32 initial_match_array[8];
 	const __be32 *match_array = initial_match_array;
-	const __be32 *tmp, *imap, *imask, dummy_imask[] = { ~0, ~0, ~0, ~0, ~0 };
+	const __be32 *tmp, *imap, *imask, dummy_imask[] = { ~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0 };
 	u32 intsize = 1, addrsize, newintsize = 0, newaddrsize = 0;
 	int imaplen, match, i;
 
@@ -147,18 +147,9 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 
 	pr_debug(" -> addrsize=%d\n", addrsize);
 
-	/* If we were passed no "reg" property and we attempt to parse
-	 * an interrupt-map, then #address-cells must be 0.
-	 * Fail if it's not.
-	 */
-	if (addr == NULL && addrsize != 0) {
-		pr_debug(" -> no reg passed in when needed !\n");
-		return -EINVAL;
-	}
-
-	/* Precalculate the match array - this simplifies match loop */
+	/* Precalculate the initial match array to simplify match loop */
 	for (i = 0; i < addrsize; i++)
-		initial_match_array[i] = addr[i];
+		initial_match_array[i] = addr ? addr[i] : 0;
 	for (i = 0; i < intsize; i++)
 		initial_match_array[addrsize + i] = cpu_to_be32(out_irq->args[i]);
 
@@ -174,6 +165,15 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
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

