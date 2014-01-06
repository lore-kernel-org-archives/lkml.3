Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbaAFQmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:42:39 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:53951 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbaAFQmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:42:36 -0500
Date: Mon, 6 Jan 2014 17:43:19 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, fengguang.wu@intel.com, devel@openvz.org
Subject: Re: [PATCH 07/11] fuse: restructure fuse_readpage()
Message-ID: <20140106164319.GF16230@tucsk.piliscsaba.szeredi.hu>
References: <20131010130718.10089.6736.stgit@dhcp-10-30-17-2.sw.ru>
 <20131010131113.10089.57270.stgit@dhcp-10-30-17-2.sw.ru>
 <20131112171707.GB10813@tucsk.piliscsaba.szeredi.hu>
 <52B45A30.10808@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B45A30.10808@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 06:54:40PM +0400, Maxim Patlasov wrote:
> Hi Miklos,
> 
> Sorry for delay, see please inline comments below.
> 
> On 11/12/2013 09:17 PM, Miklos Szeredi wrote:
> >On Thu, Oct 10, 2013 at 05:11:25PM +0400, Maxim Patlasov wrote:
> >>Move the code filling and sending read request to a separate function. Future
> >>patches will use it for .write_begin -- partial modification of a page
> >>requires reading the page from the storage very similarly to what fuse_readpage
> >>does.
> >>
> >>Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
> >>---
> >>  fs/fuse/file.c |   55 +++++++++++++++++++++++++++++++++++++------------------
> >>  1 file changed, 37 insertions(+), 18 deletions(-)
> >>
> >>diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> >>index b4d4189..77eb849 100644
> >>--- a/fs/fuse/file.c
> >>+++ b/fs/fuse/file.c
> >>@@ -700,21 +700,14 @@ static void fuse_short_read(struct fuse_req *req, struct inode *inode,
> >>  	}
> >>  }
> >>-static int fuse_readpage(struct file *file, struct page *page)
> >>+static int __fuse_readpage(struct file *file, struct page *page, size_t count,
> >>+			   int *err, struct fuse_req **req_pp, u64 *attr_ver_p)
> >Signature of this helper looks really ugly.  A quick look tells me that neither
> >caller actually needs 'req'.
> 
> fuse_readpage() passes 'req' to fuse_short_read(). And the latter
> uses req->pages[] to nullify a part of request.

I don't get it.  __fuse_readpage() itself call's fuse_short_read(), not callers
of __fuse_readpage().  Or do they?

> 
> >And fuse_get_attr_version() can be moved to the
> >one caller that needs it.
> 
> Yes, it's doable. But this would make attr_version mechanism less
> efficient (under some loads): suppose the file on server was
> truncated externally, then fuse_readpage() acquires
> fc->attr_version, then some innocent write bumps fc->attr_version
> while we're waiting for fuse writeback, then fuse_read_update_size()
> would noop. In the other words, it's beneficial to keep the time
> interval between acquiring fc->attr_version and subsequent
> comparison as short as possible.

Okay, lets try to keep this the way it is.  I don't like it very much, but I
fear changing user visible behavior.

Thanks,
Miklos
