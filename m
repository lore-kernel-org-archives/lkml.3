Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab3FJNww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:52:52 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33370 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab3FJNwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:52:51 -0400
Date: Mon, 10 Jun 2013 21:52:44 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Linux Kernel <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: binfmt_misc broken
Message-ID: <Pine.LNX.4.64.1306102137560.3200@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



According to Documentation/binfmt_misc.txt, the 'magic' and 'mask' can be 
set by echoing it to /proc/sys/fs/binfmt_misc/register.

Here's the problem I can across while working on ARM.

# echo 
':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm-static:' 
>/proc/sys/fs/binfmt_misc/register

# cat /proc/sys/fs/binfmt_misc/arm
wrong ...
magic 7f454c46010101
mask ffffffffffffff

right ...
magic 7f454c4601010100000000000000000002002800
mask ffffffffffffff00fffffffffffffffffeffffff


binfmt_misc is truncating e->size, so once ARM's magic is loaded, 32-bit 
x86 can no longer run.

Here's a patch for it. It's looking for the delimiter ":" instead of \0. 
Now 32-bit x86 can run concurrent while qemu-arm is handling ARM's magic.

Thanks,
Jeff


--- linux/fs/binfmt_misc.c	2013-05-01 12:59:39.000000000 +0800
+++ linux/fs/binfmt_misc.c	2013-06-10 21:29:45.000000000 +0800
@@ -276,6 +276,7 @@
  	int memsize, err;
  	char *buf, *p;
  	char del;
+	int esize = 0;

  	/* some sanity checks */
  	err = -EINVAL;
@@ -323,6 +324,15 @@
  		e->offset = simple_strtoul(p, &p, 10);
  		if (*p++)
  			goto Einval;
+
+		while(*(p + esize) != ':' && esize < BINPRM_BUF_SIZE) {
+			if(*(p + esize) == '\\' && *(p + esize + 1) == 'x') {
+				esize +=3;
+			} else
+				esize++;
+		}
+		e->size = esize;
+
  		e->magic = p;
  		p = scanarg(p, del);
  		if (!p)
@@ -337,10 +347,6 @@
  		p[-1] = '\0';
  		if (!e->mask[0])
  			e->mask = NULL;
-		e->size = string_unescape_inplace(e->magic, UNESCAPE_HEX);
-		if (e->mask &&
-		    string_unescape_inplace(e->mask, UNESCAPE_HEX) != e->size)
-			goto Einval;
  		if (e->size + e->offset > BINPRM_BUF_SIZE)
  			goto Einval;
  	} else {
