Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3AWMKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 07:10:06 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:51759 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab3AWMKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 07:10:04 -0500
MIME-Version: 1.0
In-Reply-To: <2553.1358890098@turing-police.cc.vt.edu>
References: <3544.1358774694@turing-police.cc.vt.edu>
	<CAJd=RBBBbv07aoOTF=PNy1FpCyuRV7fnQEGX_DXEYFSSknKtqQ@mail.gmail.com>
	<2553.1358890098@turing-police.cc.vt.edu>
Date: Wed, 23 Jan 2013 20:10:03 +0800
Message-ID: <CAJd=RBCHRDzyjY_hOZCj6rHBXzb3f5wWxdqXYuLbQXLe2n4JeA@mail.gmail.com>
Subject: Re: next-20130117 - kernel BUG with aio
From: Hillf Danton <dhillf@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Benjamin LaHaise <bcrl@kvack.org>,
        Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 5:28 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Tue, 22 Jan 2013 21:43:27 +0800, Hillf Danton said:
>> On Mon, Jan 21, 2013 at 9:24 PM, Valdis Kletnieks
>> <Valdis.Kletnieks@vt.edu> wrote:
>> > Am seeing a reproducible BUG in the kernel with next-20130117
>> > whenever I fire up VirtualBox.  Unfortunately, I hadn't done that
>> > in a while, so the last 'known good' kernel was next-20121203.
>> >
>> > I'm strongly suspecting one of Kent Overstreet's 32 patches against aio,
>> > because 'git blame' shows those landing on Jan 12, and not much else
>> > happening to fs/aio.c in ages.
>> >
>> Take a try?
>> ---
>> --- a/fs/aio.c        Tue Jan 22 21:37:54 2013
>> +++ b/fs/aio.c        Tue Jan 22 21:43:58 2013
>> @@ -683,6 +683,9 @@ static inline void kioctx_ring_unlock(st
>>  {
>>       struct aio_ring *ring;
>>
>> +     if (!ctx)
>> +             return;
>> +
>>       smp_wmb();
>>       /* make event visible before updating tail */
>
> Well, things are improved - at least now it doesn't BUG :)

Good news ;)

>
> [  534.879083] ------------[ cut here ]------------
> [  534.879094] WARNING: at fs/aio.c:336 put_ioctx+0x1cb/0x252()
> [  534.879121] Call Trace:
> [  534.879129]  [<ffffffff8102f5ad>] warn_slowpath_common+0x7e/0x97
> [  534.879133]  [<ffffffff8102f5db>] warn_slowpath_null+0x15/0x17
> [  534.879137]  [<ffffffff811521f0>] put_ioctx+0x1cb/0x252
> [  534.879142]  [<ffffffff8105bee3>] ? __wake_up+0x3f/0x48
> [  534.879146]  [<ffffffff8115229e>] ? kill_ioctx_work+0x27/0x2b
> [  534.879150]  [<ffffffff811531a5>] sys_io_destroy+0x40/0x50
> [  534.879156]  [<ffffffff8161b112>] system_call_fastpath+0x16/0x1b
> [  534.879159] ---[ end trace a2c46a8bc9058404 ]---
>
> Hopefully that tells you and Kent something. :)

Try again?
---

--- a/fs/aio.c	Tue Jan 22 21:37:54 2013
+++ b/fs/aio.c	Wed Jan 23 20:06:14 2013
@@ -683,6 +683,9 @@ static inline void kioctx_ring_unlock(st
 {
 	struct aio_ring *ring;

+	if (!ctx)
+		return;
+
 	smp_wmb();
 	/* make event visible before updating tail */

@@ -723,6 +726,7 @@ void batch_complete_aio(struct batch_com
 	n = rb_first(&batch->kiocb);
 	while (n) {
 		struct kiocb *req = container_of(n, struct kiocb, ki_node);
+		int cancelled = 0;

 		if (n->rb_right) {
 			n->rb_right->__rb_parent_color = n->__rb_parent_color;
@@ -736,13 +740,8 @@ void batch_complete_aio(struct batch_com

 		if (unlikely(xchg(&req->ki_cancel,
 				  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {
-			/*
-			 * Can't use the percpu reqs_available here - could race
-			 * with free_ioctx()
-			 */
-			atomic_inc(&req->ki_ctx->reqs_available);
-			aio_put_req(req);
-			continue;
+			cancelled = 1;
+			goto lock;
 		}

 		if (unlikely(req->ki_eventfd != eventfd)) {
@@ -759,6 +758,7 @@ void batch_complete_aio(struct batch_com
 			req->ki_eventfd = NULL;
 		}

+	lock:
 		if (unlikely(req->ki_ctx != ctx)) {
 			if (ctx)
 				kioctx_ring_unlock(ctx, tail);
@@ -767,7 +767,12 @@ void batch_complete_aio(struct batch_com
 			tail = kioctx_ring_lock(ctx);
 		}

-		tail = kioctx_ring_put(ctx, req, tail);
+		if (cancelled) {
+			if (++tail >= ctx->nr)
+				tail = 0;
+		} else
+			tail = kioctx_ring_put(ctx, req, tail);
+
 		aio_put_req(req);
 	}

--
