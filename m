Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971Ab3IGCYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 22:24:18 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:34676 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab3IGCYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 22:24:16 -0400
Message-ID: <522A8E41.3060607@hp.com>
Date: Fri, 06 Sep 2013 22:24:01 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v3 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
References: <1378483738-10129-1-git-send-email-Waiman.Long@hp.com> <1378483738-10129-2-git-send-email-Waiman.Long@hp.com> <CA+55aFw8UuEmKsSdGZPUmcekZheNimEt4U81i7Bz0LipGzsFmg@mail.gmail.com>
In-Reply-To: <CA+55aFw8UuEmKsSdGZPUmcekZheNimEt4U81i7Bz0LipGzsFmg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2013 04:52 PM, Linus Torvalds wrote:
> On Fri, Sep 6, 2013 at 9:08 AM, Waiman Long<Waiman.Long@hp.com>  wrote:
>> This patch will replace the writer's write_seqlock/write_sequnlock
>> sequence of the rename_lock of the callers of the prepend_path() and
>> __dentry_path() functions with the reader's read_seqbegin/read_seqretry
>> sequence within these 2 functions.
> Ok, this actually looks really good.
>
> I do have one comment, from just reading the patch:
>
> I would really like the stuff inside the
>
>     restart:
>        bptr = *buffer;
>        blen = *buflen;
>        if (retry_cnt) {
>              seq = read_seqbegin(&rename_lock);
>              rcu_read_lock();
>        } else
>              write_seqlock(&rename_lock);
>
>        ... guts of path generation ...
>
>        if (retry_cnt) {
>              retry_cnt--;
>              rcu_read_unlock();
>              if (read_seqretry(&rename_lock, seq))
>                    goto restart;
>        } else
>              write_sequnlock(&rename_lock);
>
> could possible be done as a separate function?
>
> Alternatively (or perhaps additionally), maybe the locking could be
> done as an inline function too (taking the retry count as an argument)
> to make things a bit more easy to understand.

I would prefer putting the begin and end blocks into 2 helper inlined 
helper functions to make code easier to look at. I will work on this 
over the weekend.

-Longman

