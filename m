Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab3KWU3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 15:29:39 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34453 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab3KWU3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 15:29:38 -0500
MIME-Version: 1.0
In-Reply-To: <CAL1ERfPExH3igteHko_iVxpG59wM+Xh0F-U1LWwZo0An0eMcGw@mail.gmail.com>
References: <1385158254-6304-1-git-send-email-ddstreet@ieee.org> <CAL1ERfPExH3igteHko_iVxpG59wM+Xh0F-U1LWwZo0An0eMcGw@mail.gmail.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Sat, 23 Nov 2013 15:29:16 -0500
X-Google-Sender-Auth: CVeCFuZQPM5TOpphjy5S4WqLw1g
Message-ID: <CALZtONDZdjsnYNGA2gC4pw5BfS+r2zm+bJzv8G9bBTOuquLHWw@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: reverse zswap_entry tree/refcount relationship
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Seth Jennings <sjennings@variantweb.net>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 9:23 PM, Weijie Yang <weijie.yang.kh@gmail.com> wrote:
> Hello Dan,
>
> On Sat, Nov 23, 2013 at 6:10 AM, Dan Streetman <ddstreet@ieee.org> wrote:
>> Currently, zswap_entry_put removes the entry from its tree if
>> the resulting refcount is 0.  Several places in code put an
>> entry's initial reference, but they also must remove the entry
>> from its tree first, which makes the tree removal in zswap_entry_put
>> redundant.
>>
>> I believe this has the refcount model backwards - the initial
>> refcount reference shouldn't be managed by multiple different places
>> in code, and the put function shouldn't be removing the entry
>> from the tree.  I think the correct model is for the tree to be
>> the owner of the initial entry reference.  This way, the only time
>> any code needs to put the entry is if it's also done a get previously.
>> The various places in code that remove the entry from the tree simply
>> do that, and the zswap_rb_erase function does the put of the initial
>> reference.
>>
>> This patch moves the initial referencing completely into the tree
>> functions - zswap_rb_insert gets the entry, while zswap_rb_erase
>> puts the entry.  The zswap_entry_get/put functions are still available
>> for any code that needs to use an entry outside of the tree lock.
>> Also, the zswap_entry_find_get function is renamed to zswap_rb_search_get
>> since the function behavior and return value is closer to zswap_rb_search
>> than zswap_entry_get.  All code that previously removed the entry from
>> the tree and put it now only remove the entry from the tree.
>>
>> The comment headers for most of the tree insert/search/erase functions
>> and the get/put functions are updated to clarify if the tree lock
>> needs to be held as well as when the caller needs to get/put an
>> entry (i.e. iff the caller is using the entry outside the tree lock).
>
> I do not like this patch idea, It breaks the zswap_rb_xxx() purity.
> I think zswap_rb_xxx() should only focus on rbtree operations.
>
> The current code might be redundant, but its logic is clear.
> So it is not essential need to be changed.

It makes absolutely no sense to include zswap_rb_erase() inside
zswap_entry_put() when it's clear that the entry will *never* (with
the writethrough patch) be on the rb tree when the final refcount is
put.

It does make sense, IMHO, for the tree to manage the initial refcount.

Alternately, if everyone agrees with you that the tree insert/remove
shouldn't manage the initial entry refcount, then it seems to me that
the zswap_rb_erase() call should be removed from zswap_entry_put() and
all places in the code that call zswap_rb_erase() need to also call
zswap_entry_put() for the initial refcount (which they already do).
