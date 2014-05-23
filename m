Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaEWRPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:15:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683AbaEWRPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:15:06 -0400
Date: Fri, 23 May 2014 19:14:26 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, peterz@infradead.org,
        LKML <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 7/7] perf: Add dcacheline sort
Message-ID: <20140523171426.GG1074@krava>
References: <1400526833-141779-1-git-send-email-dzickus@redhat.com>
 <1400526833-141779-8-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400526833-141779-8-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 03:13:53PM -0400, Don Zickus wrote:
> In perf's 'mem-mode', one can get access to a whole bunch of details specific to a
> particular sample instruction.  A bunch of those details relate to the data
> address.
> 
> One interesting thing you can do with data addresses is to convert them into a unique
> cacheline they belong too.  Organizing these data cachelines into similar groups and sorting
> them can reveal cache contention.
> 
> This patch creates an alogorithm based on various sample details that can help group
> entries together into data cachelines and allows 'perf report' to sort on it.
> 
> The algorithm relies on having proper mmap2 support in the kernel to help determine
> if the memory map the data address belongs to is private to a pid or globally shared.
> 
> The alogortithm is as follows:
> 
> o group cpumodes together
> o group entries with discovered maps together
> o sort on major, minor, inode and inode generation numbers
> o if userspace anon, then sort on pid
> o sort on cachelines based on data addresses
> 
> The 'dcacheline' sort option in 'perf report' only works in 'mem-mode'.
> 
> Sample output:
> 
>  #
>  # Samples: 206  of event 'cpu/mem-loads/pp'
>  # Total weight : 2534
>  # Sort order   : dcacheline,pid
>  #
>  # Overhead       Samples                                                          Data Cacheline       Command:  Pid
>  # ........  ............  ......................................................................  ..................
>  #
>     13.22%             1  [k] 0xffff88042f08ebc0                                                       swapper:    0
>      9.27%             1  [k] 0xffff88082e8cea80                                                       swapper:    0
>      3.59%             2  [k] 0xffffffff819ba180                                                       swapper:    0
>      0.32%             1  [k] arch_trigger_all_cpu_backtrace_handler_na.23901+0xffffffffffffffe0       swapper:    0
>      0.32%             1  [k] timekeeper_seq+0xfffffffffffffff8                                        swapper:    0
> 
> Note:  Added a '+1' to symlen size in hists__calc_col_len to prevent the next column
> from prematurely tabbing over and mis-aligning.  Not sure what the problem is.

I think thats the extra '+' sign ;-) so +1 seems ok

jirka
