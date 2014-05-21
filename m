Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaEUCqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:46:23 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51682 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaEUCqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:46:21 -0400
Message-ID: <537C137B.2000007@gmail.com>
Date: Tue, 20 May 2014 19:46:19 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: Re: [PATCH 2/3] of: Make of_find_node_by_path() handle /aliases
References: <1399993115-21552-1-git-send-email-grant.likely@linaro.org> <1399993115-21552-3-git-send-email-grant.likely@linaro.org> <53757D25.1060005@gmail.com> <20140516105444.C1DB7C42277@trevor.secretlab.ca> <20140518092730.109AAC40B8A@trevor.secretlab.ca> <537C1252.3090900@gmail.com>
In-Reply-To: <537C1252.3090900@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/2014 7:41 PM, Frank Rowand wrote:



< snip >



> I will reply to this email with an additional patch that restores the

> original behavior.



< snip >



From: Frank Rowand <frank.rowand@sonymobile.com>

If __of_find_node_by_path() returns parent when the remaining portion of the
path is "/" then the behavior of of_find_node_by_path() has changed.

Previously, adding an extraneous "/" on the end of a path would result
in of_find_node_by_path() not finding a match.

Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
---
 drivers/of/base.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: b/drivers/of/base.c
===================================================================
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -778,7 +778,7 @@ static struct device_node *__of_find_nod
 	int len = strchrnul(path, '/') - path;
 
 	if (!len)
-		return parent;
+		return NULL;
 
 	for_each_child_of_node(parent, child) {
 		const char *name = strrchr(child->full_name, '/');
@@ -813,6 +813,17 @@ struct device_node *of_find_node_by_path
 	struct property *pp;
 	unsigned long flags;
 
+	if (strcmp(path, "/") == 0) {
+		raw_spin_lock_irqsave(&devtree_lock, flags);
+		for (; np; np = np->allnext) {
+			if (np->full_name && (of_node_cmp(np->full_name, path) == 0)
+			    && of_node_get(np))
+				break;
+		}
+		raw_spin_unlock_irqrestore(&devtree_lock, flags);
+		return np;
+	}
+
 	/* The path could begin with an alias */
 	if (*path != '/') {
 		char *p = strchrnul(path, '/');
