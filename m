Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbaBUMti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:49:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46784 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbaBUMtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 019/121] pinctrl: protect pinctrl_list add
Date: Fri, 21 Feb 2014 12:47:23 +0000
Message-Id: <1392986945-9693-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 7b320cb1ed2dbd2c5f2a778197baf76fd6bf545a upstream.

We have few fedora bug reports about list corruption on pinctrl,
for example:
https://bugzilla.redhat.com/show_bug.cgi?id=1051918

Most likely corruption happen due lack of protection of pinctrl_list
when adding new nodes to it. Patch corrects that.

Fixes: 42fed7ba44e ("pinctrl: move subsystem mutex to pinctrl_dev struct")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pinctrl/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 2a00239..dbcf284 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -827,7 +827,9 @@ static struct pinctrl *create_pinctrl(struct device *dev)
 	kref_init(&p->users);
 
 	/* Add the pinctrl handle to the global list */
+	mutex_lock(&pinctrl_list_mutex);
 	list_add_tail(&p->node, &pinctrl_list);
+	mutex_unlock(&pinctrl_list_mutex);
 
 	return p;
 }
-- 
1.9.0

