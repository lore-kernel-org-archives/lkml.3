Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab3LLE54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 23:57:56 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64806 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750917Ab3LLE5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 23:57:55 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] Driver core: Fix device_add_attrs() error code path
Date: Thu, 12 Dec 2013 06:11:02 +0100
Message-ID: <1902491.UTh5DYb76O@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

If the addition of dev_attr_online fails, device_add_attrs() should
remove device attribute groups as well as type and class attribute
groups before returning an error code.  Make that happen.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/base/core.c
===================================================================
--- linux-pm.orig/drivers/base/core.c
+++ linux-pm/drivers/base/core.c
@@ -491,11 +491,13 @@ static int device_add_attrs(struct devic
 	if (device_supports_offline(dev) && !dev->offline_disabled) {
 		error = device_create_file(dev, &dev_attr_online);
 		if (error)
-			goto err_remove_type_groups;
+			goto err_remove_dev_groups;
 	}
 
 	return 0;
 
+ err_remove_dev_groups:
+ 	device_remove_groups(dev, dev->groups);
  err_remove_type_groups:
 	if (type)
 		device_remove_groups(dev, type->groups);

