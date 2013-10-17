Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761599Ab3JQAn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 20:43:58 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:60277 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760835Ab3JQAn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 20:43:57 -0400
Date: Wed, 16 Oct 2013 17:43:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] mm, vmpressure: add high level
Message-ID: <alpine.DEB.2.02.1310161738410.10147@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vmpressure has two important levels: medium and critical.  Medium is 
defined at 60% and critical is defined at 95%.

We have a customer who needs a notification at a higher level than medium, 
which is slight to moderate reclaim activity, and before critical to start 
throttling incoming requests to save memory and avoid oom.

This patch adds the missing link: a high level defined at 80%.

In the future, it would probably be better to allow the user to specify an 
integer ratio for the notification rather than relying on arbitrarily 
specified levels.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/vmpressure.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -46,6 +46,7 @@ static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
  * unsuccessful reclaims there were.
  */
 static const unsigned int vmpressure_level_med = 60;
+static const unsigned int vmpressure_level_high = 80;
 static const unsigned int vmpressure_level_critical = 95;
 
 /*
@@ -88,6 +89,7 @@ static struct vmpressure *vmpressure_parent(struct vmpressure *vmpr)
 enum vmpressure_levels {
 	VMPRESSURE_LOW = 0,
 	VMPRESSURE_MEDIUM,
+	VMPRESSURE_HIGH,
 	VMPRESSURE_CRITICAL,
 	VMPRESSURE_NUM_LEVELS,
 };
@@ -95,6 +97,7 @@ enum vmpressure_levels {
 static const char * const vmpressure_str_levels[] = {
 	[VMPRESSURE_LOW] = "low",
 	[VMPRESSURE_MEDIUM] = "medium",
+	[VMPRESSURE_HIGH] = "high",
 	[VMPRESSURE_CRITICAL] = "critical",
 };
 
@@ -102,6 +105,8 @@ static enum vmpressure_levels vmpressure_level(unsigned long pressure)
 {
 	if (pressure >= vmpressure_level_critical)
 		return VMPRESSURE_CRITICAL;
+	else if (pressure >= vmpressure_level_high)
+		return VMPRESSURE_HIGH;
 	else if (pressure >= vmpressure_level_med)
 		return VMPRESSURE_MEDIUM;
 	return VMPRESSURE_LOW;
