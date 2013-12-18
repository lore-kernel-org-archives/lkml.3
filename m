Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab3LRWVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:21:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab3LRWVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 17:21:05 -0500
Message-ID: <52B21FC7.7070905@redhat.com>
Date: Wed, 18 Dec 2013 17:20:55 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Chao Yang <chayang@redhat.com>,
        linux-mm@kvack.org, aarcange@redhat.com, mgorman@suse.de,
        Veaceslav Falico <vfalico@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        David Rientjes <rientjes@google.com>,
        Michel Lespinasse <walken@google.com>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm,numa,THP: initialize hstate for THP page size
References: <20131218170314.1e57bea7@cuia.bos.redhat.com> <20131218140830.924fa0a3bab0d497db5e256c@linux-foundation.org>
In-Reply-To: <20131218140830.924fa0a3bab0d497db5e256c@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 05:08 PM, Andrew Morton wrote:
> On Wed, 18 Dec 2013 17:03:14 -0500 Rik van Riel <riel@redhat.com> wrote:
>
>> When hugetlbfs is started with a non-default page size, it is
>> possible that no hstate is initialized for the page sized used
>> by transparent huge pages.
>>
>> This causes copy_huge_page to crash on a null pointer. Make
>> sure we always have an hstate initialized for the page sized
>> used by THP.
>>
>
> A bit more context is needed here please - so that people can decide
> which kernel version(s) need patching.

That is a good question.

Looking at the git log, this might go back to 2008,
when the hugepagesz and default_hugepagesz boot
options were introduced.

Of course, back then there was no way to use 2MB
pages together with 1GB pages.

That did not come until transparent huge pages were
introduced back in 2011.  It looks like the transparent
huge page code avoids the bug (accidentally?) by calling
copy_user_huge_page when COWing a THP, instead of
copy_huge_page, this avoids iterating over hstates[].

That means it should not be possible for the bug to
have been triggered until the numa balancing code
got merged.

