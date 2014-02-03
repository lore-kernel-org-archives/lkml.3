Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaBCLgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 06:36:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaBCLgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 06:36:51 -0500
Date: Mon, 3 Feb 2014 12:39:01 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: protect pinctrl_list add
Message-ID: <20140203113900.GD1725@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have few fedora bug reports about list corruption on pinctrl,
for example:
https://bugzilla.redhat.com/show_bug.cgi?id=1051918

Most likely corruption happen due lack of protection of pinctrl_list
when adding new nodes to it. Patch corrects that.

Fixes: 57b676f9c1b ("pinctrl: fix and simplify locking")
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
I only compile tested patch, also did not get test results from bug
reporters yet. But I'm pretty confident that patch fixes the problem
and does not cause any other deadlock.

 drivers/pinctrl/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 5ee61a4..cab020a 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -851,7 +851,9 @@ static struct pinctrl *create_pinctrl(struct device *dev)
 	kref_init(&p->users);
 
 	/* Add the pinctrl handle to the global list */
+	mutex_lock(&pinctrl_list_mutex);
 	list_add_tail(&p->node, &pinctrl_list);
+	mutex_unlock(&pinctrl_list_mutex);
 
 	return p;
 }
-- 
1.7.11.7

