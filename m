Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbbAUEgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 23:36:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41489 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbbAUEgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 23:36:44 -0500
Date: Wed, 21 Jan 2015 04:36:38 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Paul Moore <pmoore@redhat.com>, Sabrina Dubroca <sd@queasysnail.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150121043637.GO29656@ZenIV.linux.org.uk>
References: <20150120165655.GA10904@kria>
 <20150120232726.GA16913@kria>
 <1517211.UYLV49hvpg@sifl>
 <1528536.jyty2pu4Mz@sifl>
 <20150121004117.GM29656@ZenIV.linux.org.uk>
 <54BF1292.2080902@roeck-us.net>
 <20150121033600.GN29656@ZenIV.linux.org.uk>
 <54BF2496.4000807@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BF2496.4000807@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 08:01:26PM -0800, Guenter Roeck wrote:
> With this patch:
> 
> sys_mkdir .:40775 returned -17
> sys_mkdir usr:40775 returned 0
> sys_mkdir usr/lib:40775 returned 0
> sys_mkdir usr/share:40755 returned 0
> sys_mkdir usr/share/udhcpc:40755 returned 0
> sys_mkdir usr/bin:40775 returned 0
> sys_mkdir usr/sbin:40775 returned 0
> sys_mkdir mnt:40775 returned 0
> sys_mkdir proc:40775 returned 0
> sys_mkdir root:40775 returned 0
> sys_mkdir lib:40775 returned 0
> sys_mkdir lib/modules:40775 returned 0
> ...
> 
> and the problem is fixed.

... except that it simply confirms that something's fishy with getname_kernel()
of ->name of struct filename returned by getname().  IOW, I still do not
understand the mechanism of breakage there.

Another thing I really do not understand is
+               if (inode->i_ino) {
+                       /* valid inode number, use that for the comparison */
+                       if (n->ino != inode->i_ino ||
+                           n->dev != inode->i_sb->s_dev)
+                               continue;
in __audit_inode().  We don't *have* dentries with dentry->d_inode->i_ino == 0.
Ever.  WTF is that about?  Paul?
