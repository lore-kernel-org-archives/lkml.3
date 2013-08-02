Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030638Ab3HBKOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:14:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030600Ab3HBKMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:12:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [ 91/99] tty_port: Fix refcounting leak in tty_port_tty_hangup()
Date: Fri,  2 Aug 2013 18:08:44 +0800
Message-Id: <20130802100238.625266809@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gianluca Anzolin <gianluca@sottospazio.it>

commit 1d9e689c934bd5ecb0f273c6c65e0655c5cfee5f upstream.

The function tty_port_tty_hangup() could leak a reference to the tty_struct:

        struct tty_struct *tty = tty_port_tty_get(port);

        if (tty && (!check_clocal || !C_CLOCAL(tty))) {
                tty_hangup(tty);
                tty_kref_put(tty);
        }

If tty != NULL and the second condition is false we never call tty_kref_put and
the reference is leaked.

Fix by always calling tty_kref_put() which accepts a NULL argument.

The patch fixes a regression introduced by commit aa27a094.

Acked-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Gianluca Anzolin <gianluca@sottospazio.it>
Acked-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/tty_port.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -256,10 +256,9 @@ void tty_port_tty_hangup(struct tty_port
 {
 	struct tty_struct *tty = tty_port_tty_get(port);
 
-	if (tty && (!check_clocal || !C_CLOCAL(tty))) {
+	if (tty && (!check_clocal || !C_CLOCAL(tty)))
 		tty_hangup(tty);
-		tty_kref_put(tty);
-	}
+	tty_kref_put(tty);
 }
 EXPORT_SYMBOL_GPL(tty_port_tty_hangup);
 


