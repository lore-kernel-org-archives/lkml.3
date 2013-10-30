Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab3J3NfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:35:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab3J3NfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:35:17 -0400
Message-ID: <52710B09.6090302@redhat.com>
Date: Wed, 30 Oct 2013 09:35:05 -0400
From: Doug Ledford <dledford@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Ingo Molnar <mingo@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
References: <201310300525.r9U5Pdqo014902@ib.usersys.redhat.com> <20131030110214.GA10220@localhost.localdomain>
In-Reply-To: <20131030110214.GA10220@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 07:02 AM, Neil Horman wrote:

> That does makes sense, but it then begs the question, whats the advantage of
> having multiple alu's at all?

There's lots of ALU operations that don't operate on the flags or other 
entities that can be run in parallel.

> If they're just going to serialize on the
> updating of the condition register, there doesn't seem to be much advantage in
> having multiple alu's at all, especially if a common use case (parallelizing an
> operation on a large linear dataset) resulted in lower performance.
>
> /me wonders if rearranging the instructions into this order:
> adcq 0*8(src), res1
> adcq 1*8(src), res2
> adcq 2*8(src), res1
>
> would prevent pipeline stalls.  That would be interesting data, and (I think)
> support your theory, Doug.  I'll give that a try

Just to avoid spending too much time on various combinations, here are 
the methods I've tried:

Original code
2 chains doing interleaved memory accesses
2 chains doing serial memory accesses (as above)
4 chains doing serial memory accesses
4 chains using 32bit values in 64bit registers so you can always use add 
instead of adc and never need the carry flag

And I've done all of the above with simple prefetch and smart prefetch.

In all cases, the result is basically that the add method doesn't matter 
much in the grand scheme of things, but the prefetch does, and smart 
prefetch always beat simple prefetch.

My simple prefetch was to just go into the main while() loop for the 
csum operation and always prefetch 5*64 into the future.

My smart prefetch looks like this:

static inline void prefetch_line(unsigned long *cur_line,
                                  unsigned long *end_line,
                                  size_t size)
{
         size_t fetched = 0;

         while (*cur_line <= *end_line && fetched < size) {
                 prefetch((void *)*cur_line);
                 *cur_line += cache_line_size();
                 fetched += cache_line_size();
         }
}

static unsigned do_csum(const unsigned char *buff, unsigned len)
{
	...
         unsigned long cur_line = (unsigned long)buff & 
~(cache_line_size() - 1);
         unsigned long end_line = ((unsigned long)buff + len) & 
~(cache_line_size() - 1);

	...
         /* Don't bother to prefetch the first line, we'll end up 
stalling on
          * it anyway, but go ahead and start the prefetch on the next 3 */
         cur_line += cache_line_size();
         prefetch_line(&cur_line, &end_line, cache_line_size() * 3);
         odd = 1 & (unsigned long) buff;
         if (unlikely(odd)) {
                 result = *buff << 8;
	...
                 count >>= 1;            /* nr of 32-bit words.. */

                 /* prefetch line #4 ahead of main loop */
                 prefetch_line(&cur_line, &end_line, cache_line_size());

                 if (count) {
		...
                         while (count64) {
                                 /* we are now prefetching line #5 ahead of
                                  * where we are starting, and will stay 5
                                  * ahead throughout the loop, at least 
until
                                  * we get to the end line and then 
we'll stop
                                  * prefetching */
                                 prefetch_line(&cur_line, &end_line, 64);
                                 ADDL_64;
                                 buff += 64;
                                 count64--;
                         }

                         ADDL_64_FINISH;


I was going to tinker today and tomorrow with this function once I get a 
toolchain that will compile it (I reinstalled all my rhel6 hosts as f20 
and I'm hoping that does the trick, if not I need to do more work):

#define ADCXQ_64                                        \
         asm("xorq %[res1],%[res1]\n\t"                  \
             "adcxq 0*8(%[src]),%[res1]\n\t"             \
             "adoxq 1*8(%[src]),%[res2]\n\t"             \
             "adcxq 2*8(%[src]),%[res1]\n\t"             \
             "adoxq 3*8(%[src]),%[res2]\n\t"             \
             "adcxq 4*8(%[src]),%[res1]\n\t"             \
             "adoxq 5*8(%[src]),%[res2]\n\t"             \
             "adcxq 6*8(%[src]),%[res1]\n\t"             \
             "adoxq 7*8(%[src]),%[res2]\n\t"             \
             "adcxq %[zero],%[res1]\n\t"                 \
             "adoxq %[zero],%[res2]\n\t"                 \
             : [res1] "=r" (result1),                    \
               [res2] "=r" (result2)                     \
             : [src] "r" (buff), [zero] "r" (zero),      \
               "[res1]" (result1), "[res2]" (result2))

and then I also wanted to try using both xmm and ymm registers and doing 
64bit adds with 32bit numbers across multiple xmm/ymm registers as that 
should parallel nicely.  David, you mentioned you've tried this, how did 
your experiment turn out and what was your method?  I was planning on 
doing regular full size loads into one xmm/ymm register, then using 
pshufd/vshufd to move the data into two different registers, then 
summing into a fourth register, and possible running two of those 
pipelines in parallel.

