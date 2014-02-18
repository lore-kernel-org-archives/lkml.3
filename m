Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaBRWXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:23:48 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:49670 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaBRWXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:23:46 -0500
Date: Tue, 18 Feb 2014 14:23:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        Linus <torvalds@linux-foundation.org>, nacc@linux.vnet.ibm.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6 ] mm readahead: Fix readahead fail for memoryless cpu
 and limit readahead pages
In-Reply-To: <1392708338-19685-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1402181421590.20772@chino.kir.corp.google.com>
References: <1392708338-19685-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014, Raghavendra K T wrote:

> Currently max_sane_readahead() returns zero on the cpu having no local memory node
> which leads to readahead failure. Fix the readahead failure by returning
> minimum of (requested pages, 512). Users running application on a memory-less cpu
> which needs readahead such as streaming application see considerable boost in the
> performance.
> 
> Result:
> fadvise experiment with FADV_WILLNEED on a PPC machine having memoryless CPU
> with 1GB testfile ( 12 iterations) yielded around 46.66% improvement.
> 
> fadvise experiment with FADV_WILLNEED on a x240 machine with 1GB testfile
> 32GB* 4G RAM  numa machine ( 12 iterations) showed no impact on the normal
> NUMA cases w/ patch.
> 
> Kernel     Avg  Stddev
> base	7.4975	3.92%
> patched	7.4174  3.26%
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> [Andrew: making return value PAGE_SIZE independent]
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

So this replaces 
mm-readaheadc-fix-readahead-fail-for-no-local-memory-and-limit-readahead-pages.patch 
in -mm correct?

> ---
>  I would like to thank Honza, David for their valuable suggestions and 
>  patiently reviewing the patches.
> 
>  Changes in V6:
>   - Just limit the readahead to 2MB on 4k pages system as suggested by Linus.
>  and make it independent of PAGE_SIZE. 
> 

I'm not sure I understand why we want to be independent of PAGE_SIZE since 
we're still relying on PAGE_CACHE_SIZE.  Don't you mean to do

#define MAX_READAHEAD	((512*PAGE_SIZE)/PAGE_CACHE_SIZE)

instead?
