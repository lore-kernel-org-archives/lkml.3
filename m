Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3CATs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:48:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab3CATqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [ 26/30] dca: check against empty dca_domains list before unregister provider fix
Date: Fri,  1 Mar 2013 11:45:47 -0800
Message-Id: <20130301194530.850597040@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194527.988540148@linuxfoundation.org>
References: <20130301194527.988540148@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

In 3.0.67, commit 7a9a20ea77e7508c795dead9ab2f6c98a617762d (dca: check
against empty dca_domains list before unregister provider), upstream
commit c419fcfd071cf34ba00f9f65282583772d2655e7, added a fail path to
unregister_dca_provider. It added there also a call to
raw_spin_unlock_irqrestore. But in 3.0, the lock is not raw, so this
results in:
drivers/dca/dca-core.c: In function 'unregister_dca_provider':
drivers/dca/dca-core.c:413: warning: passing argument 1 of '_raw_spin_unlock_irqrestore' from incompatible pointer type

Fix it by calling spin_unlock_irqrestore properly.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dca/dca-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -410,7 +410,7 @@ void unregister_dca_provider(struct dca_
 	spin_lock_irqsave(&dca_lock, flags);
 
 	if (list_empty(&dca_domains)) {
-		raw_spin_unlock_irqrestore(&dca_lock, flags);
+		spin_unlock_irqrestore(&dca_lock, flags);
 		return;
 	}
 


