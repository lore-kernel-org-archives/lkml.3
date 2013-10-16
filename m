Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761054Ab3JPXUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 19:20:46 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:45011 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759267Ab3JPXUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 19:20:44 -0400
MIME-Version: 1.0
In-Reply-To: <CACz4_2edu+99ZQPOML=C9HOLtde699K450xOeCgK524MhsqODA@mail.gmail.com>
References: <20131015001201.GC3432@hippobay.mtv.corp.google.com>
 <20131015100213.A0189E0090@blue.fi.intel.com> <CACz4_2er-_Xa8oRo_JJTC+HZtDTAcjJ+cNTjrXLhN0Dm7BtXFQ@mail.gmail.com>
 <20131016122611.69CA0E0090@blue.fi.intel.com> <CACz4_2edu+99ZQPOML=C9HOLtde699K450xOeCgK524MhsqODA@mail.gmail.com>
From: Ning Qu <quning@google.com>
Date: Wed, 16 Oct 2013 16:20:23 -0700
Message-ID: <CACz4_2faZ7fvUJMRWVCA72-oj0VsVNMRniwwD=-fWi6B51UvBg@mail.gmail.com>
Subject: Re: [PATCH 02/12] mm, thp, tmpfs: support to add huge page into page
 cache for tmpfs
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consider this fixed. I have extracted the common function and the new
shmem_insert_page_page_cache function looks like this:

       spin_lock_irq(&mapping->tree_lock);
       error = __add_to_page_cache_locked(page, mapping, index);

       if (!error)
            __mod_zone_page_state(page_zone(page), NR_SHMEM, nr);

        radix_tree_preload_end();
        spin_unlock_irq(&mapping->tree_lock);

        if (error)
                page_cache_release(page);

        return error;
Best wishes,
-- 
Ning Qu (ÇúÄþ) | Software Engineer | quning@google.com | +1-408-418-6066


On Wed, Oct 16, 2013 at 10:49 AM, Ning Qu <quning@google.com> wrote:
> Yes, I guess I can if I just put whatever inside the spin lock into a
> common function. Thanks!
> Best wishes,
> --
> Ning Qu (ÇúÄþ) | Software Engineer | quning@google.com | +1-408-418-6066
>
>
> On Wed, Oct 16, 2013 at 5:26 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
>> Ning Qu wrote:
>>> Yes, I can try. The code is pretty much similar with some minor difference.
>>>
>>> One thing I can do is to move the spin lock part (together with the
>>> corresponding err handling into a common function.
>>>
>>> The only problem I can see right now is we need the following
>>> additional line for shm:
>>>
>>> __mod_zone_page_state(page_zone(page), NR_SHMEM, nr);
>>>
>>> Which means we need to tell if it's coming from shm or not, is that OK
>>> to add additional parameter just for that? Or is there any other
>>> better way we can infer that information? Thanks!
>>
>> I think you can account NR_SHMEM after common code succeed, don't you?
>>
>> --
>>  Kirill A. Shutemov
