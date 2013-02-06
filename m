Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab3BFSwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:52:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862Ab3BFSwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:52:20 -0500
Date: Wed, 6 Feb 2013 19:52:05 +0100
From: Jan Kara <jack@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] printk: Avoid softlockups in console_unlock()
Message-ID: <20130206185205.GA11254@quack.suse.cz>
References: <1360016230-26696-1-git-send-email-jack@suse.cz>
 <20130205123838.146a5371.akpm@linux-foundation.org>
 <20130206142346.GF6330@quack.suse.cz>
 <alpine.DEB.2.02.1302060958150.26828@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1302060958150.26828@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 06-02-13 09:58:48, David Rientjes wrote:
> On Wed, 6 Feb 2013, Jan Kara wrote:
> 
> >   Yes, I noticed that thread just yesterday and also though that using
> > similar trick might be viable. I'll experiment if we could use the same
> > method for handling lockup problems I hit. Steven seems to have already
> > tweaked PRINTK_PENDING stuff to be usable more easily...
> > 
> 
> Are these new build failures in linux-next coming from this patch?
> 
> kernel/printk.c: In function 'console_unlock':
> kernel/printk.c:2156:18: error: 'printk_work' undeclared (first use in this function)
> kernel/printk.c:2156:18: note: each undeclared identifier is reported only once for each function it appears in
> kernel/printk.c: At top level:
> kernel/printk.c:2167:13: warning: 'printk_worker' defined but not used [-Wunused-function]
  Yes, I already sent a patch to fix these (attached if you need it).
Thanks for notice.

							Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--HlL+5n6rz5pIUxbD
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-printk-Fixup-compilation-with-CONFIG_PRINTK.patch"

>From 313ba66418472fa532faf8c61e8981bd7b29950e Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 6 Feb 2013 14:07:01 +0100
Subject: [PATCH] printk: Fixup compilation with !CONFIG_PRINTK

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 80172f7..484fdb4 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -246,10 +246,6 @@ static enum log_flags console_prev;
 static u64 clear_seq;
 static u32 clear_idx;
 
-/* Worker to print accumulated data to console when there's too much of it */
-static void printk_worker(struct work_struct *work);
-static DECLARE_WORK(printk_work, printk_worker);
-
 #define PREFIX_MAX		32
 #define LOG_LINE_MAX		1024 - PREFIX_MAX
 
@@ -2154,6 +2150,10 @@ skip:
 	return retry;
 }
 
+/* Worker to print accumulated data to console when there's too much of it */
+static void printk_worker(struct work_struct *work);
+static DECLARE_WORK(printk_work, printk_worker);
+
 void console_unlock(void)
 {
 	if (__console_unlock()) {
-- 
1.7.1


--HlL+5n6rz5pIUxbD--
