Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaBRWrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:47:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbaBRWrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.12 31/32] pinctrl: protect pinctrl_list add
Date: Tue, 18 Feb 2014 14:47:31 -0800
Message-Id: <20140218224500.993979012@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224500.101465031@linuxfoundation.org>
References: <20140218224500.101465031@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -837,7 +837,9 @@ static struct pinctrl *create_pinctrl(st
 	kref_init(&p->users);
 
 	/* Add the pinctrl handle to the global list */
+	mutex_lock(&pinctrl_list_mutex);
 	list_add_tail(&p->node, &pinctrl_list);
+	mutex_unlock(&pinctrl_list_mutex);
 
 	return p;
 }


