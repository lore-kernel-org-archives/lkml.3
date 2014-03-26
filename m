Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbaCZVkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 17:40:04 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33817 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbaCZVkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 17:40:02 -0400
Message-ID: <5333492D.2030300@oracle.com>
Date: Wed, 26 Mar 2014 17:39:57 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>
Subject: Re: mm: BUG: Bad page state in process ksmd
References: <5332EE97.4050604@oracle.com> <20140326125525.4e8090096f647f654eb7329d@linux-foundation.org>
In-Reply-To: <20140326125525.4e8090096f647f654eb7329d@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 03:55 PM, Andrew Morton wrote:
> On Wed, 26 Mar 2014 11:13:27 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
>> Out of curiosity, is there a reason not to do bad flag checks when actually
>> setting flag? Obviously it'll be slower but it'll be easier catching these
>> issues.
>
> Tricky.  Each code site must determine what are and are not valid page
> states depending upon the current context.  The one place where we've
> made that effort is at the point where a page is returned to the free
> page pool.  Any other sites would require similar amounts of effort and
> each one would be different from all the others.
>
> We do this in a small way all over the place, against individual page
> flags.  grep PageLocked */*.c.

What if we define generic page types and group page flags under them?
It would be easier to put these checks in key sites around the code
and no need to fully customize them to each site.

For exmaple, swap_readpage() is doing this:

         VM_BUG_ON_PAGE(!PageLocked(page), page);
         VM_BUG_ON_PAGE(PageUptodate(page), page);

But what if instead of that we'd do:

	VM_BUG_ON_PAGE(!PageSwap(page), page);

Where PageSwap would test "not locked", "uptodate", and in addition
a set of "sanity" flags which it didn't make sense to test individually
everywhere (PageError()? PageReclaim()?).

I can add the infrastructure if that sounds good (and people promise to
work with me on defining page types). I'd be happy to do all the testing
involved in getting this to work right.


Thanks,
Sasha
