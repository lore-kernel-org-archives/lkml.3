Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbaLBJAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:00:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45021 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaLBJAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:00:22 -0500
Date: Tue, 2 Dec 2014 11:59:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        SF Markus Elfring <elfring@users.sourceforge.net>,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: [patch] CodingStyle: add some more error handling guidelines
Message-ID: <20141202085950.GA13434@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1412020836040.1984@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I added a paragraph on choosing label names, and updated the example
code to use a better label name.  I also cleaned up the example code to
more modern style by moving the allocation out of the initializer and
changing the NULL check.

Perhaps the most common type of error handling bug in the kernel is "one
err bugs".  CodingStyle already says that we should "avoid nesting" by
using error labels and one err style error handling tends to have
multiple indent levels, so this was already bad style.  But I've added a
new paragraph explaining how to avoid one err bugs by using multiple
error labels which is, hopefully, more clear.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 9f28b14..9c8a234 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -392,7 +392,12 @@ The goto statement comes in handy when a function exits from multiple
 locations and some common work such as cleanup has to be done.  If there is no
 cleanup needed then just return directly.
 
-The rationale is:
+Choose label names which say what the goto does or why the goto exists.  An
+example of a good name could be "out_buffer:" if the goto frees "buffer".  Avoid
+using GW-BASIC names like "err1:" and "err2:".  Also don't name them after the
+goto location like "err_kmalloc_failed:"
+
+The rationale for using gotos is:
 
 - unconditional statements are easier to understand and follow
 - nesting is reduced
@@ -403,9 +408,10 @@ The rationale is:
 int fun(int a)
 {
 	int result = 0;
-	char *buffer = kmalloc(SIZE);
+	char *buffer;
 
-	if (buffer == NULL)
+	buffer = kmalloc(SIZE);
+	if (!buffer)
 		return -ENOMEM;
 
 	if (condition1) {
@@ -413,14 +419,25 @@ int fun(int a)
 			...
 		}
 		result = 1;
-		goto out;
+		goto out_buffer;
 	}
 	...
-out:
+out_buffer:
 	kfree(buffer);
 	return result;
 }
 
+A common type of bug to be aware of it "one err bugs" which look like this:
+
+err:
+	kfree(foo->bar);
+	kfree(foo);
+	return ret;
+
+The bug in this code is that on some exit paths "foo" is NULL.  Normally the
+fix for this is to split it up into two error labels "err_bar:" and "err_foo:".
+
+
 		Chapter 8: Commenting
 
 Comments are good, but there is also a danger of over-commenting.  NEVER
