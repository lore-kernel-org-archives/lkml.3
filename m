Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073Ab3HSGuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 02:50:44 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:57374 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3HSGum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 02:50:42 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: getarunks@gmail.com
In-Reply-To: <20130812144943.a09d6251bc20f8c3d0a6e8d8@linux-foundation.org>
References: <CAKZGPANjwYxoAtO068UN1iMuMZPtkbjACz8C3yHjZMr5BkM63A@mail.gmail.com>
	<20130812144943.a09d6251bc20f8c3d0a6e8d8@linux-foundation.org>
Date: Mon, 19 Aug 2013 12:20:41 +0530
X-Google-Sender-Auth: 5l6RuWndpvxw1ErfOfu_1DLNAHs
Message-ID: <CAKZGPAPkxBMiJZrHyUKgUSZ3O5D5jxqFg6yEr-PYza-7cKx8ag@mail.gmail.com>
Subject: Re: Seq File: Return error if d_path fails
From: Arun KS <arunks.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, Matthew Wilcox <matthew@wil.cx>,
        Bruce Fields <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, vinayak menon <vinayakm.list@gmail.com>,
        Nagachandra P <nagachandra@gmail.com>, Vikram MP <mp.vikram@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Aug 13, 2013 at 3:19 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 8 Aug 2013 19:03:31 +0530 Arun KS <arunks.linux@gmail.com> wrote:
>
>> >From 2558382c8a030f7261e47977ac62412cd78e6d38 Mon Sep 17 00:00:00 2001
>> From: Arun KS <arun.ks@broadcom.com>
>> Date: Thu, 8 Aug 2013 18:23:04 +0530
>> Subject: Seq File: Return error if d_path fails
>>
>> Return error if d_path fails in seq_path funciton. If we do not return
>> from here,
>> seq_commit sets seq_file state as overflow. And this continues in a
>> loop utill we
>> increase the size of seq buf beyond KMALLOC_MAX_SIZE.
>>
>> ...
>>
>> --- a/fs/seq_file.c
>> +++ b/fs/seq_file.c
>> @@ -471,7 +471,8 @@ int seq_path(struct seq_file *m, const struct path
>> *path, const char *esc)
>>                         char *end = mangle_path(buf, p, esc);
>>                         if (end)
>>                                 res = end - buf;
>> -               }
>> +               } else
>> +                       return PTR_ERR(p);
>>         }
>>         seq_commit(m, res);
>
> hm, does that really fix the bug?  Isn't the core problem the word "or":
>
> /**
>  * seq_commit - commit data to the buffer
>  * @m: the seq_file handle
>  * @num: the number of bytes to commit
>  *
>  * Commit @num bytes of data written to a buffer previously acquired
>  * by seq_buf_get.  To signal an error condition, or that the data
>                                                   ^^
>  * didn't fit in the available space, pass a negative @num value.
>  */
>
> seq_path()/seq_commit() is treating a d_path() failure as an overflow
> condition, but it isn't.
>
I ll send a new patch.

Thanks,
Arun
