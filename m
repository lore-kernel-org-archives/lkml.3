Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbaEOWgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 18:36:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475AbaEOWgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 18:36:21 -0400
Date: Thu, 15 May 2014 15:36:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Jianyu Zhan <nasa4836@gmail.com>, iamjoonsoo.kim@lge.com,
        aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com,
        aarcange@redhat.com, steve.capper@linaro.org, davidlohr@hp.com,
        kirill.shutemov@linux.intel.com, dave.hansen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm, hugetlb: move the error handle logic out of normal
 code path
Message-Id: <20140515153620.344fe054b6b8d054a28fbf82@linux-foundation.org>
In-Reply-To: <20140515090142.GB3938@dhcp22.suse.cz>
References: <1400051459-20578-1-git-send-email-nasa4836@gmail.com>
	<20140515090142.GB3938@dhcp22.suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 11:01:42 +0200 Michal Hocko <mhocko@suse.cz> wrote:

> On Wed 14-05-14 15:10:59, Jianyu Zhan wrote:
> > alloc_huge_page() now mixes normal code path with error handle logic.
> > This patches move out the error handle logic, to make normal code
> > path more clean and redue code duplicate.
> 
> I don't know. Part of the function returns and cleans up on its own and
> other part relies on clean up labels. This is not so much nicer than the
> previous state.

That's actually a common pattern:

foo()
{
	if (check which doesn't change any state)
		return -Efoo;
	if (another check which doesn't change any state)
		return -Ebar;

	do_something_which_changes_state()
	
	if (another check)
		goto undo_that_state_chage;
	...

undo_that_state_change:
	...
}


This ties into the main reason why we use all these gotos: to support
evolution of the code.  With multiple return points we risk later
adding resource leaks and locking errors.  Plus the code becomes more
and more duplicative and spaghettified.


