Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab3CODqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 23:46:46 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:36120 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3CODqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 23:46:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130314162413.GA21344@redhat.com>
References: <20130314162413.GA21344@redhat.com>
Date: Fri, 15 Mar 2013 11:46:44 +0800
Message-ID: <CACVXFVP+fGeWS3xwBfaQDFaH7=e_4CbgCru9DJczB2vyWuUL1g@mail.gmail.com>
Subject: Re: + atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive
 .patch added to -mm tree
From: Ming Lei <tom.leiming@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 12:24 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> From: Ming Lei <tom.leiming@gmail.com>
>> Subject: atomic: improve atomic_inc_unless_negative/atomic_dec_unless_positive
>>
>> Generally, both atomic_inc_unless_negative() and
>> atomic_dec_unless_positive() need at least two atomic_cmpxchg() to
>> complete the atomic operation.  In fact, the 1st atomic_cmpxchg() is just
>> used to read current value of the atomic variable at most times.
>
> Agreed, this looks ugly...
>
> But can't we make a simpler patch and keep the code simple/readable ?
>
> Oleg.
>
> --- x/include/linux/atomic.h
> +++ x/include/linux/atomic.h
> @@ -64,7 +64,7 @@ static inline int atomic_inc_not_zero_hi
>  static inline int atomic_inc_unless_negative(atomic_t *p)
>  {
>         int v, v1;
> -       for (v = 0; v >= 0; v = v1) {
> +       for (v = atomic_read(p); v >= 0; v = v1) {
>                 v1 = atomic_cmpxchg(p, v, v + 1);

Unfortunately, the above will exchange the current value even though
it is negative, so it isn't correct.

>                 if (likely(v1 == v))
>                         return 1;
> @@ -77,7 +77,7 @@ static inline int atomic_inc_unless_nega
>  static inline int atomic_dec_unless_positive(atomic_t *p)
>  {
>         int v, v1;
> -       for (v = 0; v <= 0; v = v1) {
> +       for (v = atomic_read(p); v <= 0; v = v1) {
>                 v1 = atomic_cmpxchg(p, v, v - 1);

Similar with above.

>                 if (likely(v1 == v))
>                         return 1;
>


Thanks,
-- 
Ming Lei
