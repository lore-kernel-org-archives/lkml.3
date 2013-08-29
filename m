Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab3H2TmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:42:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab3H2TmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:42:10 -0400
Date: Thu, 29 Aug 2013 12:42:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build warnings after merge of the akpm-current tree
Message-Id: <20130829124208.7b97594d8a8723d45d1bad34@linux-foundation.org>
In-Reply-To: <521F2F7E.8010702@parallels.com>
References: <20130829194741.ff75bb1ce06207d5d3a703de@canb.auug.org.au>
	<521F2F7E.8010702@parallels.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Aug 2013 15:24:46 +0400 Maxim Patlasov <mpatlasov@parallels.com> wrote:

> Hi Stephen,
> 
> 08/29/2013 01:47 PM, Stephen Rothwell __________:
> > Hi Andrew,
> >
> > After merging the akpm tree, today's linux-next build (sparc64 defconfig
> > and others) produced these warnings:
> >
> > mm/page-writeback.c: In function 'balance_dirty_pages_ratelimited':
> > mm/page-writeback.c:1450:13: warning: 'bdi_thresh' may be used uninitialized in this function [-Wuninitialized]
> > mm/page-writeback.c:1372:16: note: 'bdi_thresh' was declared here
> > mm/page-writeback.c:1226:16: warning: 'bdi_dirty' may be used uninitialized in this function [-Wuninitialized]
> > mm/page-writeback.c:1369:16: note: 'bdi_dirty' was declared here
> >
> > Possibly introduced by commit 34c547af1e23 ("mm/page-writeback.c: add
> > strictlimit feature"), but I am not sure anything can be done about them.
> >
> 
> This looks as gcc glitch. So far as I didn't observe the warnings, the 
> version of gcc does matter. May be moving the definitions of the two 
> variables into for(;;){...} would help. Could you please give it a try?

Shuffling the definitions around won't help.  To fix this we'll need to
add more code and I hate adding runtime overhead to address
compile-time issues.  So...

--- a/mm/page-writeback.c~a
+++ a/mm/page-writeback.c
@@ -1366,10 +1366,8 @@ static void balance_dirty_pages(struct a
 {
 	unsigned long nr_reclaimable;	/* = file_dirty + unstable_nfs */
 	unsigned long nr_dirty;  /* = file_dirty + writeback + unstable_nfs */
-	unsigned long bdi_dirty;
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
-	unsigned long bdi_thresh;
 	long period;
 	long pause;
 	long max_pause;
@@ -1385,8 +1383,10 @@ static void balance_dirty_pages(struct a
 
 	for (;;) {
 		unsigned long now = jiffies;
-		unsigned long dirty;
+		unsigned long uninitialized_var(bdi_thresh);
 		unsigned long thresh;
+		unsigned long uninitialized_var(bdi_dirty);
+		unsigned long dirty;
 		unsigned long bg_thresh;
 
 		/*
_


