Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3EJWkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 18:40:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20360 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3EJWkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 18:40:24 -0400
Date: Fri, 10 May 2013 15:40:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ttyprintk: Fix NULL pointer deref by setting tty_port ops
 after initializing port
Message-ID: <20130510224013.GA5706@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_port_init() zeroes out the tty port, which means that we have to set the
ops pointer /after/, not before this call.  Otherwise, tty_port_open will crash
when it tries to deref ops, which is now a NULL pointer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 drivers/char/ttyprintk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
index 4945bd3..d5d2e4a 100644
--- a/drivers/char/ttyprintk.c
+++ b/drivers/char/ttyprintk.c
@@ -179,7 +179,6 @@ static int __init ttyprintk_init(void)
 {
 	int ret = -ENOMEM;
 
-	tpk_port.port.ops = &null_ops;
 	mutex_init(&tpk_port.port_write_mutex);
 
 	ttyprintk_driver = tty_alloc_driver(1,
@@ -190,6 +189,7 @@ static int __init ttyprintk_init(void)
 		return PTR_ERR(ttyprintk_driver);
 
 	tty_port_init(&tpk_port.port);
+	tpk_port.port.ops = &null_ops;
 
 	ttyprintk_driver->driver_name = "ttyprintk";
 	ttyprintk_driver->name = "ttyprintk";
