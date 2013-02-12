Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab3BLUfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:35:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3BLUfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 04/61] regulator: clear state each invocation of of_regulator_match
Date: Tue, 12 Feb 2013 12:34:24 -0800
Message-Id: <20130212203418.622561422@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit a2f95c363701deba2205f81929b40222ea6f4f80 upstream.

of_regulator_match() saves some dynamcially allocated state into the
match table that's passed to it. By implementation and not contract, for
each match table entry, if non-NULL state is already present,
of_regulator_match() will not overwrite it. of_regulator_match() is
typically called each time a regulator is probe()d. This means it is
called with the same match table over and over again if a regulator
triggers deferred probe. This results in stale, kfree()d data being left
in the match table from probe to probe, which causes a variety of crashes
or use of invalid data.

Explicitly free all output state from of_regulator_match() before
generating new results in order to avoid this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/of_regulator.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -120,6 +120,12 @@ int of_regulator_match(struct device *de
 	if (!dev || !node)
 		return -EINVAL;
 
+	for (i = 0; i < num_matches; i++) {
+		struct of_regulator_match *match = &matches[i];
+		match->init_data = NULL;
+		match->of_node = NULL;
+	}
+
 	for_each_child_of_node(node, child) {
 		name = of_get_property(child,
 					"regulator-compatible", NULL);


