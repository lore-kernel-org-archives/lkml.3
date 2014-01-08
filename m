Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbaAHKit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:38:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaAHKiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:38:46 -0500
Date: Wed, 8 Jan 2014 11:38:43 +0100
From: Jan Kara <jack@suse.cz>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>,
        Linus <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V3] mm readahead: Fix the readahead fail in case of
 empty numa node
Message-ID: <20140108103843.GA8256@quack.suse.cz>
References: <1389003715-29733-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
 <20140106105620.GC3312@quack.suse.cz>
 <52CD0E2F.8000903@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CD0E2F.8000903@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 08-01-14 14:07:03, Raghavendra K T wrote:
> On 01/06/2014 04:26 PM, Jan Kara wrote:
> >On Mon 06-01-14 15:51:55, Raghavendra K T wrote:
> >>Currently, max_sane_readahead returns zero on the cpu with empty numa node,
> >>fix this by checking for potential empty numa node case during calculation.
> >>We also limit the number of readahead pages to 4k.
> >>
> >>Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> >>---
> >>The current patch limits the readahead into 4k pages (16MB was suggested
> >>by Linus).  and also handles the case of memoryless cpu issuing readahead
> >>failures.  We still do not consider [fm]advise() specific calculations
> >>here.  I have dropped the iterating over numa node to calculate free page
> >>idea.  I do not have much idea whether there is any impact on big
> >>streaming apps..  Comments/suggestions ?
> >   As you say I would be also interested what impact this has on a streaming
> >application. It should be rather easy to check - create 1 GB file, drop
> >caches. Then measure how long does it take to open the file, call fadvise
> >FADV_WILLNEED, read the whole file (for a kernel with and without your
> >patch). Do several measurements so that we get some meaningful statistics.
> >Resulting numbers can then be part of the changelog. Thanks!
> >
> 
> Hi Honza,
> 
> Thanks for the idea. (sorry for the delay, spent my own time to do some
> fadvise and other benchmarking). Here is the result on my x240 machine
> with 32 cpu (w/ HT) 128GB ram.
> 
> Below test was for 1gb test file as per suggestion.
> 
> x base_result
> + patched_result
>     N           Min           Max        Median           Avg        Stddev
> x  12         7.217         7.444        7.2345     7.2603333    0.06442802
> +  12          7.24         7.431         7.243     7.2684167   0.059649672
> 
> From the result we could see that there is not much impact with the
> patch.
> I shall include the result in changelog when I resend/next version
> depending on the others' comment.
> 
> ---
> test file looked something like this:
> 
> char buf[4096];
> 
> int main()
> {
> int fd = open("testfile", O_RDONLY);
> unsigned long read_bytes = 0;
> int sz;
> posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED);
  Hum, but this call should have rather been:
struct stat st;

fstat(fd, &st);
posix_fadvise(fd, 0, st.st_size, POSIX_FADV_WILLNEED);

The posix_fadvise() call you had doesn't do anything...

								Honza

> do {
> 	sz = read(fd, buf, 4096);
> 	read_bytes += sz;
> } while (sz > 0);
> 
> close(fd);
> printf (" Total bytes read = %lu \n", read_bytes);
> return 0;
> }
> 
> 
> 
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
