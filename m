Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab3GZEM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 00:12:29 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:46334 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3GZEMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 00:12:25 -0400
Date: Thu, 25 Jul 2013 23:12:20 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 5/5] initmpfs v2: Use initramfs if rootfstype= or root=
 specified.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Stephen Warren <swarren@nvidia.com>
In-Reply-To: <20130719125718.2227f52ccf642dda060f0ae8@linux-foundation.org>
	(from akpm@linux-foundation.org on Fri Jul 19 14:57:18 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1374811940.3031.15@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 02:57:18 PM, Andrew Morton wrote:
> On Tue, 16 Jul 2013 16:45:39 -0700 (PDT) Rob Landley  
> <rob@landley.net> wrote:
> 
> > Command line option rootfstype=ramfs to obtain old initramfs  
> behavior,
> > and use ramfs instead of tmpfs for stub when root= defined (for  
> cosmetic
> > reasons).
> 
> Could we get a Documentation/kernel-parameters.txt update please?

Sorry for the delay, traveling. Behind on email...

"rootfstype" is already documented in kernel parameters:

         rootfstype=     [KNL] Set root filesystem type

I just applied the existing definition to initramfs now that it has  
more than one filesystem option there. Do you want me to add a special  
case here to say that rootfstype= still works when the root filesystem  
is initramfs? Or would it instead make more sense to add:

Signed-off-by: Rob Landley <rob@landley.net>

Document that rootfstype= applies to initmpfs too.

--- a/Documentation/filesystems/ramfs-rootfs-initramfs.txt
+++ b/Documentation/filesystems/ramfs-rootfs-initramfs.txt
@@ -79,6 +79,9 @@ to just make sure certain lists can't become empty.
  Most systems just mount another filesystem over rootfs and ignore  
it.  The
  amount of space an empty instance of ramfs takes up is tiny.

+If CONFIG_TMPFS is enabled, rootfs will use tmpfs instead of ramfs by  
default.
+To force ramfs, add "rootfstype=ramfs" to the kernel command line.
+
  What is initramfs?
  ------------------


(What I _didn't_ do yet is hook up rootflags= to initmpfs, so you can  
specify size= as something other than 50%. Partly because if you have  
an empty cpio archive and the rootflags= applies to ext3 or something,  
those flags could potentially confuse tmpfs with unknown options and  
throw errors. And partly because mount -o remount,size=20% works fine  
after the fact, so it's not time critical and I easily can do a  
follow-up patch. The one potential downside is if you want to have a  
cpio archive eat more than 50% of the kernel's memory, it'll fail to  
extract into tmpfs with the size limits. But the rootfstype=ramfs  
downgrade also works around that for now...)

There are a number of follow up patches I could do, but the basic  
functionality doesn't depend on them...

Rob