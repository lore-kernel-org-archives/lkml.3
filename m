Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbaFQDpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 23:45:49 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:23309 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbaFQDps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 23:45:48 -0400
Message-ID: <539FB9E6.2030601@hp.com>
Date: Mon, 16 Jun 2014 23:45:42 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH] mm, thp: move invariant bug check out of loop in __split_huge_page_map
References: <1402947348-60655-1-git-send-email-Waiman.Long@hp.com> <20140616204934.GA14208@node.dhcp.inet.fi> <20140616205946.GB14208@node.dhcp.inet.fi>
In-Reply-To: <20140616205946.GB14208@node.dhcp.inet.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 04:59 PM, Kirill A. Shutemov wrote:
> On Mon, Jun 16, 2014 at 11:49:34PM +0300, Kirill A. Shutemov wrote:
>> On Mon, Jun 16, 2014 at 03:35:48PM -0400, Waiman Long wrote:
>>> In the __split_huge_page_map() function, the check for
>>> page_mapcount(page) is invariant within the for loop. Because of the
>>> fact that the macro is implemented using atomic_read(), the redundant
>>> check cannot be optimized away by the compiler leading to unnecessary
>>> read to the page structure.
> And atomic_read() is *not* atomic operation. It's implemented as
> dereferencing though cast to volatile, which suppress compiler
> optimization, but doesn't affect what CPU can do with the variable.
>
> So I doubt difference will be measurable anywhere.
>

Because it is treated as an volatile object, the compiler will have to 
reread the value of the relevant page structure field in every iteration 
of the loop (512 for x86) when pmd_write(*pmd) is true. I saw some 
slight improvement (about 2%) of a microbench that I wrote to break up 
1000 THPs with 1000 forked processes.

-Longman
