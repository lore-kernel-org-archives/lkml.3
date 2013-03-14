Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab3CNQ0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:26:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab3CNQ0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:26:09 -0400
Date: Thu, 14 Mar 2013 17:24:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ming Lei <tom.leiming@gmail.com>, Shaohua Li <shli@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: +
	atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive
	.patch added to -mm tree
Message-ID: <20130314162413.GA21344@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ming Lei <tom.leiming@gmail.com>
> Subject: atomic: improve atomic_inc_unless_negative/atomic_dec_unless_positive
>
> Generally, both atomic_inc_unless_negative() and
> atomic_dec_unless_positive() need at least two atomic_cmpxchg() to
> complete the atomic operation.  In fact, the 1st atomic_cmpxchg() is just
> used to read current value of the atomic variable at most times.

Agreed, this looks ugly...

But can't we make a simpler patch and keep the code simple/readable ?

Oleg.

--- x/include/linux/atomic.h
+++ x/include/linux/atomic.h
@@ -64,7 +64,7 @@ static inline int atomic_inc_not_zero_hi
 static inline int atomic_inc_unless_negative(atomic_t *p)
 {
 	int v, v1;
-	for (v = 0; v >= 0; v = v1) {
+	for (v = atomic_read(p); v >= 0; v = v1) {
 		v1 = atomic_cmpxchg(p, v, v + 1);
 		if (likely(v1 == v))
 			return 1;
@@ -77,7 +77,7 @@ static inline int atomic_inc_unless_nega
 static inline int atomic_dec_unless_positive(atomic_t *p)
 {
 	int v, v1;
-	for (v = 0; v <= 0; v = v1) {
+	for (v = atomic_read(p); v <= 0; v = v1) {
 		v1 = atomic_cmpxchg(p, v, v - 1);
 		if (likely(v1 == v))
 			return 1;

