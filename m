Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934922Ab3GWWzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:55:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934490Ab3GWW1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 016/103] powerpc/perf: Check that events only include valid bits on Power8
Date: Tue, 23 Jul 2013 15:25:27 -0700
Message-Id: <20130723220420.394277885@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <michael@ellerman.id.au>

commit d8bec4c9cd58f6d3679e09b7293851fb92ad7557 upstream.

A mistake we have made in the past is that we pull out the fields we
need from the event code, but don't check that there are no unknown bits
set. This means that we can't ever assign meaning to those unknown bits
in future.

Although we have once again failed to do this at release, it is still
early days for Power8 so I think we can still slip this in and get away
with it.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/perf/power8-pmu.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -109,6 +109,16 @@
 #define EVENT_IS_MARKED		(EVENT_MARKED_MASK << EVENT_MARKED_SHIFT)
 #define EVENT_PSEL_MASK		0xff	/* PMCxSEL value */
 
+#define EVENT_VALID_MASK	\
+	((EVENT_THRESH_MASK    << EVENT_THRESH_SHIFT)		|	\
+	 (EVENT_SAMPLE_MASK    << EVENT_SAMPLE_SHIFT)		|	\
+	 (EVENT_CACHE_SEL_MASK << EVENT_CACHE_SEL_SHIFT)	|	\
+	 (EVENT_PMC_MASK       << EVENT_PMC_SHIFT)		|	\
+	 (EVENT_UNIT_MASK      << EVENT_UNIT_SHIFT)		|	\
+	 (EVENT_COMBINE_MASK   << EVENT_COMBINE_SHIFT)		|	\
+	 (EVENT_MARKED_MASK    << EVENT_MARKED_SHIFT)		|	\
+	  EVENT_PSEL_MASK)
+
 /* MMCRA IFM bits - POWER8 */
 #define	POWER8_MMCRA_IFM1		0x0000000040000000UL
 #define	POWER8_MMCRA_IFM2		0x0000000080000000UL
@@ -212,6 +222,9 @@ static int power8_get_constraint(u64 eve
 
 	mask = value = 0;
 
+	if (event & ~EVENT_VALID_MASK)
+		return -1;
+
 	pmc   = (event >> EVENT_PMC_SHIFT)       & EVENT_PMC_MASK;
 	unit  = (event >> EVENT_UNIT_SHIFT)      & EVENT_UNIT_MASK;
 	cache = (event >> EVENT_CACHE_SEL_SHIFT) & EVENT_CACHE_SEL_MASK;


