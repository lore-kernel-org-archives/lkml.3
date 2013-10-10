Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3JJHER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:04:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:58702 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab3JJHEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:04:15 -0400
Message-ID: <1381388635.4330.37.camel@pasglop>
Subject: [PATCH] sysfs/bin: Fix size handling overflow for bin_attribute
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 10 Oct 2013 18:03:55 +1100
In-Reply-To: <1381378788.4330.30.camel@pasglop>
References: <1381378788.4330.30.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at the code, I noticed that bin_attribute read() and write()
ops copy the inode size into an int for futher comparisons.

Some bin_attributes can be fairly large. For example, pci creates some for
BARs set to the BAR size and giant BARs are around the corner, so this is
going to break something somewhere eventually.

Let's use the right type.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

I noticed that while messing around with my "xscom" file which I had
originally set to be LONG_MAX :-)

I eventually decided to use an i_size of 0 instead which seems to be
the way that sort of "special" file tend to be done (it's a bridge to
a special sideband bus in the system which has a sparse addressing which
is splattered all over 64 bits though I've somewhat "compressed" it to 63
for the sake of sysfs).

Note that I noticed that late and don't have a good test case for it,
but code inspection didn't seem to show anything else cropping i_size. 

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index c590cab..373ddcf 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -69,7 +69,7 @@ static ssize_t
 read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 {
 	struct bin_buffer *bb = file->private_data;
-	int size = file_inode(file)->i_size;
+	loff_t size = file_inode(file)->i_size;
 	loff_t offs = *off;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
 	char *temp;
@@ -139,7 +139,7 @@ static ssize_t write(struct file *file, const char __user *userbuf,
 		     size_t bytes, loff_t *off)
 {
 	struct bin_buffer *bb = file->private_data;
-	int size = file_inode(file)->i_size;
+	loff_t size = file_inode(file)->i_size;
 	loff_t offs = *off;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
 	char *temp;


