Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab3KAWOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:14:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab3KAWIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 3.11 60/66] w1 - call request_module with w1 master mutex unlocked
Date: Fri,  1 Nov 2013 15:07:36 -0700
Message-Id: <20131101220651.414386649@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans-Frieder Vogt <hfvogt@gmx.net>

commit bc04d76d6942068f75c10790072280b847ec6f1f upstream.

request_module for w1 slave modules needs to be called with the w1
master mutex unlocked. Because w1_attach_slave_device gets always(?)
called with mutex locked, we need to temporarily unlock the w1 master
mutex for the loading of the w1 slave module.

Signed-off by: Hans-Frieder Vogt <hfvogt@gmx.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/w1/w1.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -680,7 +680,10 @@ static int w1_attach_slave_device(struct
 	atomic_set(&sl->refcnt, 0);
 	init_completion(&sl->released);
 
+	/* slave modules need to be loaded in a context with unlocked mutex */
+	mutex_unlock(&dev->mutex);
 	request_module("w1-family-0x%0x", rn->family);
+	mutex_lock(&dev->mutex);
 
 	spin_lock(&w1_flock);
 	f = w1_family_registered(rn->family);


