Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbaAHImP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:42:15 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:37430 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198AbaAHImC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:42:02 -0500
Message-ID: <52CD1113.2070003@linux.vnet.ibm.com>
Date: Wed, 08 Jan 2014 14:19:23 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, jack@suse.cz,
        Linus <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V3] mm readahead: Fix the readahead fail in case of
 empty numa node
References: <1389003715-29733-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140106141300.4e1c950d45c614d6c29bdd8f@linux-foundation.org>
In-Reply-To: <20140106141300.4e1c950d45c614d6c29bdd8f@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010808-2000-0000-0000-00000F382BE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 03:43 AM, Andrew Morton wrote:
> On Mon,  6 Jan 2014 15:51:55 +0530 Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:
>
>> +	/*
>> +	 * Readahead onto remote memory is better than no readahead when local
>> +	 * numa node does not have memory. We sanitize readahead size depending
>> +	 * on free memory in the local node but limiting to 4k pages.
>> +	 */
>> +	return local_free_page ? min(sane_nr, local_free_page / 2) : sane_nr;
>>   }
>
> So if the local node has two free pages, we do just one page of
> readahead.
>
> Then the local node has one free page and we do zero pages readahead.
>
> Assuming that bug(!) is fixed, the local node now has zero free pages
> and we suddenly resume doing large readahead.
>
> This transition from large readahead to very small readahead then back
> to large readahead is illogical, surely?
>
>

Hi Andrew, Thanks for having a look at this.

You are correct that there is a transition from small readahead to
large once we have zero free pages.
I am not sure I can defend well, but 'll give a try :).

Hoping that we have evenly distributed cpu/memory load, if we have very
less free+inactive memory may be we are in really bad shape already.

But in the case where we have a situation like below [1] (cpu does not 
have any local memory node populated) I had mentioned
earlier where we will have to depend on remote node always,
is it not that sanitized readahead onto remote memory seems better?

But having said that I am not able to get an idea of sane implementation
to solve this readahead failure bug overcoming the anomaly you pointed
:(.  hints/ideas.. ?? please let me know.


[1]: IBM P730
----------------------------------
# numactl -H
available: 2 nodes (0-1)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 
23 24 25 26 27 28 29 30 31
node 0 size: 0 MB
node 0 free: 0 MB
node 1 cpus:
node 1 size: 12288 MB
node 1 free: 10440 MB
node distances:
node   0   1
0:  10  40
1:  40  10

