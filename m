Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761777AbbA2KNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:13:16 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44740 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752832AbbA2JB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 048/176] ARM: mvebu: disable I/O coherency on non-SMP situations on Armada 370/375/38x/XP
Date: Wed, 28 Jan 2015 15:27:58 +0100
Message-Id: <39ca76b2961ca4667a8035c8bde1ee31a3466d7a.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e55355453600a33bb5ca4f71f2d7214875f3b061 upstream.

Enabling the hardware I/O coherency on Armada 370, Armada 375, Armada
38x and Armada XP requires a certain number of conditions:

 - On Armada 370, the cache policy must be set to write-allocate.

 - On Armada 375, 38x and XP, the cache policy must be set to
   write-allocate, the pages must be mapped with the shareable
   attribute, and the SMP bit must be set

Currently, on Armada XP, when CONFIG_SMP is enabled, those conditions
are met. However, when Armada XP is used in a !CONFIG_SMP kernel, none
of these conditions are met. With Armada 370, the situation is worse:
since the processor is single core, regardless of whether CONFIG_SMP
or !CONFIG_SMP is used, the cache policy will be set to write-back by
the kernel and not write-allocate.

Since solving this problem turns out to be quite complicated, and we
don't want to let users with a mainline kernel known to have
infrequent but existing data corruptions, this commit proposes to
simply disable hardware I/O coherency in situations where it is known
not to work.

And basically, the is_smp() function of the kernel tells us whether it
is OK to enable hardware I/O coherency or not, so this commit slightly
refactors the coherency_type() function to return
COHERENCY_FABRIC_TYPE_NONE when is_smp() is false, or the appropriate
type of the coherency fabric in the other case.

Thanks to this, the I/O coherency fabric will no longer be used at all
in !CONFIG_SMP configurations. It will continue to be used in
CONFIG_SMP configurations on Armada XP, Armada 375 and Armada 38x
(which are multiple cores processors), but will no longer be used on
Armada 370 (which is a single core processor).

In the process, it simplifies the implementation of the
coherency_type() function, and adds a missing call to of_node_put().

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Fixes: e60304f8cb7bb545e79fe62d9b9762460c254ec2 ("arm: mvebu: Add hardware I/O Coherency support")
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Link: https://lkml.kernel.org/r/1415871540-20302-3-git-send-email-thomas.petazzoni@free-electrons.com
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mach-mvebu/coherency.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/mach-mvebu/coherency.c b/arch/arm/mach-mvebu/coherency.c
index 58adf2fd9cfc..7e0529ba3bca 100644
--- a/arch/arm/mach-mvebu/coherency.c
+++ b/arch/arm/mach-mvebu/coherency.c
@@ -124,6 +124,29 @@ int __init coherency_init(void)
 {
 	struct device_node *np;
 
+	/*
+	 * The coherency fabric is needed:
+	 * - For coherency between processors on Armada XP, so only
+	 *   when SMP is enabled.
+	 * - For coherency between the processor and I/O devices, but
+	 *   this coherency requires many pre-requisites (write
+	 *   allocate cache policy, shareable pages, SMP bit set) that
+	 *   are only meant in SMP situations.
+	 *
+	 * Note that this means that on Armada 370, there is currently
+	 * no way to use hardware I/O coherency, because even when
+	 * CONFIG_SMP is enabled, is_smp() returns false due to the
+	 * Armada 370 being a single-core processor. To lift this
+	 * limitation, we would have to find a way to make the cache
+	 * policy set to write-allocate (on all Armada SoCs), and to
+	 * set the shareable attribute in page tables (on all Armada
+	 * SoCs except the Armada 370). Unfortunately, such decisions
+	 * are taken very early in the kernel boot process, at a point
+	 * where we don't know yet on which SoC we are running.
+	 */
+	if (!is_smp())
+		return 0;
+
 	np = of_find_matching_node(NULL, of_coherency_table);
 	if (np) {
 		struct resource res;
@@ -150,6 +173,9 @@ static int __init coherency_late_init(void)
 {
 	struct device_node *np;
 
+	if (!is_smp())
+		return 0;
+
 	np = of_find_matching_node(NULL, of_coherency_table);
 	if (np) {
 		bus_register_notifier(&platform_bus_type,
-- 
2.2.2

