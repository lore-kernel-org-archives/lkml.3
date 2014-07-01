Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbaGAUEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:04:52 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:60883 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758707AbaGAUEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:04:50 -0400
Message-ID: <1404245087.2010.15.camel@x220>
Subject: Re: [PATCH] direct-io: squelch maybe-uninitialized warning in
 do_direct_IO()
From: Paul Bolle <pebolle@tiscali.nl>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 01 Jul 2014 22:04:47 +0200
In-Reply-To: <1403553248-16536-1-git-send-email-markus.mayer@linaro.org>
References: <1403323139-12858-1-git-send-email-jason@lakedaemon.net>
	 <1403553248-16536-1-git-send-email-markus.mayer@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jul 2014 20:04:47.0873 (UTC) FILETIME=[B5A58F10:01CF9567]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 12:54 -0700, Markus Mayer wrote:
> I did a bit of digging on this and I am wondering if the initialization
> of "to" and "from" to 0 should instead be done in dio_get_page().
> 
> The warning is caused by the return in dio_get_page():
> 
> 		ret = dio_refill_pages(dio, sdio);
> 		if (ret)
> 			return ERR_PTR(ret);
> 
> This code path would leave "to" and "from" uninitialized (even though the
> caller currently never uses the variables in that case).
> 
> If both variables are initialized to 0 in dio_get_page(), it would
> guarantee that any future callers of dio_get_page() also get to take
> advantage of the initialization. If, however, the variables are only
> initialized in do_direct_IO(), other callers would have to take care of
> this themselves (or the same warnings will pop up there).
> 
> There aren't currently any other callers to dio_get_page(), so the
> choice is probably not a terribly critical one right now, but I wanted
> to at least point this out.

I peeked at this a bit too.

Maybe it's better to move initializing "to" and "from" out of
dio_get_page(). That _might_ make it easier for both the the reader and
the compiler to understand what's going on. Something like this:

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 98040ba388ac..2f024fc16a07 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -198,9 +198,8 @@ static inline int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
  * L1 cache.
  */
 static inline struct page *dio_get_page(struct dio *dio,
-		struct dio_submit *sdio, size_t *from, size_t *to)
+		struct dio_submit *sdio)
 {
-	int n;
 	if (dio_pages_present(sdio) == 0) {
 		int ret;
 
@@ -209,10 +208,7 @@ static inline struct page *dio_get_page(struct dio *dio,
 			return ERR_PTR(ret);
 		BUG_ON(dio_pages_present(sdio) == 0);
 	}
-	n = sdio->head++;
-	*from = n ? 0 : sdio->from;
-	*to = (n == sdio->tail - 1) ? sdio->to : PAGE_SIZE;
-	return dio->pages[n];
+	return dio->pages[sdio->head];
 }
 
 /**
@@ -911,11 +907,15 @@ static int do_direct_IO(struct dio *dio, struct dio_submit *sdio,
 	while (sdio->block_in_file < sdio->final_block_in_request) {
 		struct page *page;
 		size_t from, to;
-		page = dio_get_page(dio, sdio, &from, &to);
+
+		page = dio_get_page(dio, sdio);
 		if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
 			goto out;
 		}
+		from = sdio->head ? 0 : sdio->from;
+		to = (sdio->head == sdio->tail - 1) ? sdio->to : PAGE_SIZE;
+		sdio->head++;
 
 		while (from < to) {
 			unsigned this_chunk_bytes;	/* # of bytes mapped */

This at least silences GCC.

But do_direct_IO() and friends are complicated enough that I'll have to
look at them for another day or two (or many, many more) before I'm
confident that this doesn't actually change anything.


Paul Bolle

