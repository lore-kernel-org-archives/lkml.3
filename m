Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaJPRmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:42:18 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:43998 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaJPRmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:42:17 -0400
MIME-Version: 1.0
In-Reply-To: <1413480303.6702.7.camel@perches.com>
References: <1413479722-29247-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1413480303.6702.7.camel@perches.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Thu, 16 Oct 2014 19:41:55 +0200
Message-ID: <CAFo99gbGrGXz+gYQn0hAPKxN73BLLWhaUPVN0DVq6-3PiFzOSw@mail.gmail.com>
Subject: Re: [PATCH 3v] char: hw_random: core.c: Changed from using strncat to strlcat
To: Joe Perches <joe@perches.com>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Torsten Duwe <duwe@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Jason Cooper <jason@lakedaemon.net>, Amit Shah <amit.shah@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-16 19:25 GMT+02:00 Joe Perches <joe@perches.com>:
> On Thu, 2014-10-16 at 19:15 +0200, Rickard Strandqvist wrote:
>> The buf is used to hold the list of hwrng devices registered.
>> The old code ensures we don't walk off the end of buf as we
>> fill it, but it's unnecessarily complicated and thus difficult
>> to maintain. Simplify it by using strlcat.
>> We also ensure the string within buf is NULL terminated
>> so the final strlen is ok.
> []
>> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> []
>> @@ -289,16 +288,13 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
>>               return -ERESTARTSYS;
>>       buf[0] = '\0';
>>       list_for_each_entry(rng, &rng_list, list) {
>> -             strncat(buf, rng->name, PAGE_SIZE - ret - 1);
>> -             ret += strlen(rng->name);
>> -             strncat(buf, " ", PAGE_SIZE - ret - 1);
>> -             ret++;
>> +             strlcat(buf, rng->name, PAGE_SIZE);
>> +             strlcat(buf, " ", PAGE_SIZE);
>>       }
>> -     strncat(buf, "\n", PAGE_SIZE - ret - 1);
>> -     ret++;
>> +     strlcat(buf, "\n", PAGE_SIZE);
>>       mutex_unlock(&rng_mutex);
>>
>> -     return ret;
>> +     return strlen(buf);
>>  }
>>
>>  static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
>
> Rickard, can you please use some optimizations here
> (and elsewhere) so that strlcat doesn't always have
> to strlen the first string and the return doesn't
> have to do the strlen too?
>
> You could use a temporary for the returned length
> of the strlcat so that if it's shorter than
> the buffer, the next strlcat can start at the
> appropriate known position instead of having
> to do the initial strlen again and again.
>


Hi Joe

Yes that did not take advantage last strlcat was foolish.

But the others, I am very hesitant about. Because strlcat like
snprintf and strlcpy returns the length that would be copied rather
than what is actually copied. Hence such a code to be even more
complex than before.


Kind regards
Rickard Strandqvist
