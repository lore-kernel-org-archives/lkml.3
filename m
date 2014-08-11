Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaHKFtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:49:23 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:38374 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaHKFtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:49:22 -0400
MIME-Version: 1.0
In-Reply-To: <8738d3hfm4.fsf@x220.int.ebiederm.org>
References: <20140811024720.GA11337@devel.8.8.4.4>
	<8738d3hfm4.fsf@x220.int.ebiederm.org>
Date: Mon, 11 Aug 2014 14:43:37 +0900
Message-ID: <CAHb8M2CG8dKeONFieH+KkHSFYEvkT6av6UodDQFWCM6uMNjN_A@mail.gmail.com>
Subject: Re: [PATCH] proc: potential ERR_PTR dereference on proc_fill_cache()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, oleg <oleg@redhat.com>,
        eparis@redhat.com, rgb@redhat.com, tixxdz@opendz.org,
        adobriyan@gmail.com, bill.c.roberts@gmail.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-11 12:25 GMT+09:00 Eric W. Biederman <ebiederm@xmission.com>:
> Daeseok Youn <daeseok.youn@gmail.com> writes:
>
>> The d_hash_and_lookup() returns NULL or ERR_PTR on lookup
>> failure.
>
> Given that the only error condition can come from .d_hash and that proc
> does not implement .d_hash if we want to do something with error returns
> let's call BUG_ON. aka:
Yes, you're right. proc doesn't implement .d_hash, so my patch is not needed.
It couldn't return ERR_PTR(-error) without implementing .d_hash
This patch should be dropped.

>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index f50d4be..49bc09c 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1673,7 +1673,7 @@ bool proc_fill_cache(struct file *file, struct dir_context *ctx,
>         ino_t ino;
>
>         child = d_hash_and_lookup(dir, &qname);
> +       BUG_ON(IS_ERR(child))
>         if (!child) {
>                 child = d_alloc(dir, &qname);
>                 if (!child)
>                         goto end_instantiate;
>
> Or do you see something in d_hash_and_lookup that I am overlooking?
No.. I should check more carefully. sorry for that.

Thanks for review.

regards,
Daeseok Youn.

>
> Eric
>
>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  fs/proc/base.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> index f50d4be..49bc09c 100644
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -1673,7 +1673,7 @@ bool proc_fill_cache(struct file *file, struct dir_context *ctx,
>>       ino_t ino;
>>
>>       child = d_hash_and_lookup(dir, &qname);
>> -     if (!child) {
>> +     if (IS_ERR_OR_NULL(child)) {
>>               child = d_alloc(dir, &qname);
>>               if (!child)
>>                       goto end_instantiate;
