Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaAHI3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:29:46 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:37737 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbaAHI3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:29:43 -0500
Message-ID: <52CD0E2F.8000903@linux.vnet.ibm.com>
Date: Wed, 08 Jan 2014 14:07:03 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>,
        Linus <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V3] mm readahead: Fix the readahead fail in case of
 empty numa node
References: <1389003715-29733-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140106105620.GC3312@quack.suse.cz>
In-Reply-To: <20140106105620.GC3312@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010808-0260-0000-0000-000004311429
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 04:26 PM, Jan Kara wrote:
> On Mon 06-01-14 15:51:55, Raghavendra K T wrote:
>> Currently, max_sane_readahead returns zero on the cpu with empty numa node,
>> fix this by checking for potential empty numa node case during calculation.
>> We also limit the number of readahead pages to 4k.
>>
>> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>> ---
>> The current patch limits the readahead into 4k pages (16MB was suggested
>> by Linus).  and also handles the case of memoryless cpu issuing readahead
>> failures.  We still do not consider [fm]advise() specific calculations
>> here.  I have dropped the iterating over numa node to calculate free page
>> idea.  I do not have much idea whether there is any impact on big
>> streaming apps..  Comments/suggestions ?
>    As you say I would be also interested what impact this has on a streaming
> application. It should be rather easy to check - create 1 GB file, drop
> caches. Then measure how long does it take to open the file, call fadvise
> FADV_WILLNEED, read the whole file (for a kernel with and without your
> patch). Do several measurements so that we get some meaningful statistics.
> Resulting numbers can then be part of the changelog. Thanks!
>

Hi Honza,

Thanks for the idea. (sorry for the delay, spent my own time to do some
fadvise and other benchmarking). Here is the result on my x240 machine
with 32 cpu (w/ HT) 128GB ram.

Below test was for 1gb test file as per suggestion.

x base_result
+ patched_result
     N           Min           Max        Median           Avg        Stddev
x  12         7.217         7.444        7.2345     7.2603333    0.06442802
+  12          7.24         7.431         7.243     7.2684167   0.059649672

 From the result we could see that there is not much impact with the
patch.
I shall include the result in changelog when I resend/next version
depending on the others' comment.

---
test file looked something like this:

char buf[4096];

int main()
{
int fd = open("testfile", O_RDONLY);
unsigned long read_bytes = 0;
int sz;
posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED);

do {
	sz = read(fd, buf, 4096);
	read_bytes += sz;
} while (sz > 0);

close(fd);
printf (" Total bytes read = %lu \n", read_bytes);
return 0;
}





