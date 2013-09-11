Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab3IKXIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:08:22 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54141 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3IKXIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:08:21 -0400
Message-ID: <5230F7DD.90905@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 16:08:13 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cl@linux.com
Subject: Re: [RFC][PATCH] mm: percpu pages: up batch size to fix arithmetic??
 errror
References: <20130911220859.EB8204BB@viggo.jf.intel.com>
In-Reply-To: <20130911220859.EB8204BB@viggo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091123-9332-0000-0000-00000163113B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 03:08 PM, Dave Hansen wrote:
> I really don't know where the:
>
> 	batch /= 4;             /* We effectively *= 4 below */
> 	...
> 	batch = rounddown_pow_of_two(batch + batch/2) - 1;
>
> came from.  The round down code at *MOST* does a *= 1.5, but
> *averages* out to be just under 1.
>
> On a system with 128GB in a zone, this means that we've got
> (you can see in /proc/zoneinfo for yourself):
>
>                high:  186 (744kB)
>                batch: 31  (124kB)
>
> That 124kB is almost precisely 1/4 of the "1/2 of a meg" that we
> were shooting for.  We're under-sizing the batches by about 4x.
> This patch kills the /=4.
>
> ---
> diff -puN mm/page_alloc.c~debug-pcp-sizes-1 mm/page_alloc.c
> --- linux.git/mm/page_alloc.c~debug-pcp-sizes-1	2013-09-11 14:41:08.532445664 -0700
> +++ linux.git-davehans/mm/page_alloc.c	2013-09-11 15:03:47.403912683 -0700
> @@ -4103,7 +4103,6 @@ static int __meminit zone_batchsize(stru
>   	batch = zone->managed_pages / 1024;
>   	if (batch * PAGE_SIZE > 512 * 1024)
>   		batch = (512 * 1024) / PAGE_SIZE;
> -	batch /= 4;		/* We effectively *= 4 below */
>   	if (batch < 1)
>   		batch = 1;
>
> _
>

Looking back at the first git commit (way before my time), it appears 
that the percpu pagesets initially had a ->high and ->low (now removed), 
set to batch*6 and batch*2 respectively. I assume the idea was to keep 
the number of pages in the percpu pagesets around batch*4, hence the 
comment.

So we have this variable called "batch", and the code is trying to store 
the _average_ number of pcp pages we want into it (not the batchsize), 
and then we divide our "average" goal by 4 to get a batchsize. All the 
comments refer to the size of the pcp pagesets, not to the pcp pageset 
batchsize.

Looking further, in current code we don't refill the pcp pagesets unless 
they are completely empty (->low was removed a while ago), and then we 
only add ->batch pages.

Has anyone looked at what type of average pcp sizing the current code 
results in?

