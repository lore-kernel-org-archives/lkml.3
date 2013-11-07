Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3KGDNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 22:13:06 -0500
Received: from mail.eperm.de ([89.247.134.16]:43972 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab3KGDND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 22:13:03 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, sandy harris <sandyinchina@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Thu, 07 Nov 2013 04:12:52 +0100
Message-ID: <3111582.KXT7xhOO8M@tauon>
User-Agent: KMail/4.11.2 (Linux/3.11.6-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20131106132635.GA25971@amd.pavel.ucw.cz>
References: <2579337.FPgJGgHYdz@tauon> <6186307.PQMXWdkvke@tauon> <20131106132635.GA25971@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 6. November 2013, 14:26:35 schrieb Pavel Machek:

Hi Pavel,

>Hi!
>
>> >I plugged that idea into my current Jitter RNG processing and
>> >disabled
>> >the other jitter measurements to get a clear, isolated picture.
>> >
>> >The result is also a white noise! And it is even quite fast.
>> 
>> After doing some more research on this approach, I have to admit that
>> the output not good (i.e. white noise) in all situations. Therefore,
>> I
>> dropped that (for now).
>
>Is there chance to extract at least some entropy from it? (Can you
>post the code you used for testing?) Because in this case we know
>where the entropy comes from, which is important for Ted.

The code is as follows -- it hooks into the framework of the RNG I 
already have, so the code folds the obtained data into one bit (use the 
following function as a drop-in replacement to my RNG code.

static __u64 jent_measure_jitter(struct rand_data *entropy_collector)
{
        __u64 starttime = 0;
        __u64 currtime = 0;
        __u64 counter = 0;
        __u64 data = 0;

        jent_get_ustime(&starttime);
        jent_get_ustime(&currtime);
        while(starttime == currtime)
        {
                jent_get_ustime(&currtime);
                counter++;
        }
        jent_fold_time(counter, &data, 1);
        return data;
}

Consider the following in addition:

static inline void jent_get_ustime(__u64 *out)
{
        __u64 tmp = 0;
        struct timeval time;
        if(gettimeofday(&time, NULL) == 0)
                tmp = time.tv_usec;
        *out = tmp;
}

For the kernel land, I implemented jent_get_ustime to be identical to 
do_gettimeofday().

The result is the following on my i7 2nd gen without using the Von-
Neumann unbias operation:

- user space: looks like good white noise based on the results of ent 
(Chi square, etc). When I print out the counter variable above and 
calculate the Shannon Entropy, I get about 1.5 bits, so we have 
variations. But when you look at the data manually, you see quite some 
streaks that alternate between two values. Here is an example:

4
6
10
2
3
2
3
4
4
4
4
4
5
3
4
5
4
4
4
5
4
4
5
4
4
5
4
4
5
4
4
5
4
4
4
5
4
4


- kernel space: the resulting binary string is not very good: the chi 
square is very bad. Moreover, the resulting data string is slightly 
skewed. The reason is simple by looking at the counter value which I 
obtained with another debugfs file: there are very very long streaks of 
the same or alternating values.

So, I guess you may get some entropy, but I am not sure how much.

Also, when I enlarge the timer value to look something like that:

        if(gettimeofday(&time, NULL) == 0)
                tmp = time.tv_usec>>3;

the counter value is not getting really better, it is still alternating 
between two or three values.


>
>Thanks,
>							Pavel


Ciao
Stephan
