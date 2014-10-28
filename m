Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaJ1W6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:58:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaJ1W6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:58:53 -0400
Date: Tue, 28 Oct 2014 15:58:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] binfmt_misc: add comments & debug logs
Message-Id: <20141028155853.8327ad332397c5b426e0aa46@linux-foundation.org>
In-Reply-To: <20141020235414.GA23349@vapier>
References: <1413759826-11958-1-git-send-email-vapier@gentoo.org>
	<1413845160-22497-1-git-send-email-vapier@gentoo.org>
	<1413845996.5407.2.camel@perches.com>
	<20141020235414.GA23349@vapier>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014 19:54:14 -0400 Mike Frysinger <vapier@gentoo.org> wrote:

> On 20 Oct 2014 15:59, Joe Perches wrote:
> > On Mon, 2014-10-20 at 18:45 -0400, Mike Frysinger wrote:
> > > diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> > []
> > > @@ -323,46 +343,113 @@ static Node *create_entry(const char __user *buffer, size_t count)
> > []
> > > +			if (e->mask) {
> > > +				int i;
> > > +				char *masked = kmalloc(e->size, GFP_USER);
> > 
> > Why GFP_USER?  Does it need it?
> 
> mostly a copy & paste from earlier in this func:
> 	e = kmalloc(memsize, GFP_USER);
> 
> the code is running process context and this buffer is only for
> debugging on behalf of the user (and is shortly freed there after), so
> GFP_USER seemed appropriate.  that said, i'm certainly not an expert
> here, so if the convention is to use GFP_KERNEL, it's easy enough to
> change.  the kmalloc API doesn't seem to provide guidance.

I can't see any reason to me using GFP_USER for these objects so how
about


From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/binfmt_misc.c: use GFP_KERNEL instead of GFP_USER

GFP_USER means "honour cpuset nodes-allowed beancounting".  These are
regular old kernel objects and there seems no reason to give them this
treatment.

Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_misc.c~fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user
+++ a/fs/binfmt_misc.c
@@ -308,7 +308,7 @@ static Node *create_entry(const char __u
 
 	err = -ENOMEM;
 	memsize = sizeof(Node) + count + 8;
-	e = kmalloc(memsize, GFP_USER);
+	e = kmalloc(memsize, GFP_KERNEL);
 	if (!e)
 		goto out;
 
@@ -416,7 +416,7 @@ static Node *create_entry(const char __u
 
 			if (e->mask) {
 				int i;
-				char *masked = kmalloc(e->size, GFP_USER);
+				char *masked = kmalloc(e->size, GFP_KERNEL);
 
 				print_hex_dump_bytes(
 					KBUILD_MODNAME ": register:  mask[decoded]: ",
_

