Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab3JKUfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:35:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758939Ab3JKTkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sooraj Ravindran Nair <soonair3@in.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 051/110] powerpc/perf: Fix handling of FAB events
Date: Fri, 11 Oct 2013 12:38:31 -0700
Message-Id: <20131011193813.375386944@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <michael@ellerman.id.au>

commit a53b27b3abeef406de92a2bb0ceb6fb4c3fb8fc4 upstream.

Commit 4df4899 "Add power8 EBB support" included a bug in the handling
of the FAB_CRESP_MATCH and FAB_TYPE_MATCH fields.

These values are pulled out of the event code using EVENT_THR_CTL_SHIFT,
however we were then or'ing that value directly into MMCR1.

This meant we were failing to set the FAB fields correctly, and also
potentially corrupting the value for PMC4SEL. Leading to no counts for
the FAB events and incorrect counts for PMC4.

The fix is simply to shift left the FAB value correctly before or'ing it
with MMCR1.

Reported-by: Sooraj Ravindran Nair <soonair3@in.ibm.com>
Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/perf/power8-pmu.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -194,6 +194,7 @@
 #define MMCR1_UNIT_SHIFT(pmc)		(60 - (4 * ((pmc) - 1)))
 #define MMCR1_COMBINE_SHIFT(pmc)	(35 - ((pmc) - 1))
 #define MMCR1_PMCSEL_SHIFT(pmc)		(24 - (((pmc) - 1)) * 8)
+#define MMCR1_FAB_SHIFT			36
 #define MMCR1_DC_QUAL_SHIFT		47
 #define MMCR1_IC_QUAL_SHIFT		46
 
@@ -367,8 +368,8 @@ static int power8_compute_mmcr(u64 event
 		 * the threshold bits are used for the match value.
 		 */
 		if (event_is_fab_match(event[i])) {
-			mmcr1 |= (event[i] >> EVENT_THR_CTL_SHIFT) &
-				  EVENT_THR_CTL_MASK;
+			mmcr1 |= ((event[i] >> EVENT_THR_CTL_SHIFT) &
+				  EVENT_THR_CTL_MASK) << MMCR1_FAB_SHIFT;
 		} else {
 			val = (event[i] >> EVENT_THR_CTL_SHIFT) & EVENT_THR_CTL_MASK;
 			mmcra |= val << MMCRA_THR_CTL_SHIFT;


