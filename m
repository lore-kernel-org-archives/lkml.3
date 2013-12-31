Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3LaK7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 05:59:51 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:54371 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab3LaK7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 05:59:49 -0500
Message-ID: <52C2A564.4040809@linux.vnet.ibm.com>
Date: Tue, 31 Dec 2013 16:37:16 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] mm readahead: Fix the readahead fail in case of empty
 numa node
References: <1386066977-17368-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20131203143841.11b71e387dc1db3a8ab0974c@linux-foundation.org> <529EE811.5050306@linux.vnet.ibm.com> <20131204004125.a06f7dfc.akpm@linux-foundation.org> <529EF0FB.2050808@linux.vnet.ibm.com> <20131204134838.a048880a1db9e9acd14a39e4@linux-foundation.org> <20131211224917.GF1163@quack.suse.cz> <20131211150522.4b853323e8b82f342f81b64d@linux-foundation.org> <CA+55aFy-e-uok1K9mSNTYS4bJJfHkxXofY7T1UVWgHOyXuE84A@mail.gmail.com>
In-Reply-To: <CA+55aFy-e-uok1K9mSNTYS4bJJfHkxXofY7T1UVWgHOyXuE84A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13123110-0260-0000-0000-00000428891C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2013 06:09 AM, Linus Torvalds wrote:
> On Wed, Dec 11, 2013 at 3:05 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>>
>> But I'm really struggling to think up an implementation!  The current
>> code looks only at the caller's node and doesn't seem to make much
>> sense.  Should we look at all nodes?  Hard to say without prior
>> knowledge of where those pages will be coming from.
>
> I really think we want to put an upper bound on the read-ahead, and
> I'm not convinced we need to try to be excessively clever about it. We
> also probably don't want to make it too expensive to calculate,
> because afaik this ends up being called for each file we open when we
> don't have pages in the page cache yet.
>
> The current function seems reasonable on a single-node system. Let's
> not kill it entirely just because it has some odd corner-case on
> multi-node systems.
>
> In fact, for all I care, I think it would be perfectly ok to just use
> a truly stupid hard limit ("you can't read-ahead more than 16MB" or
> whatever).
>
> What we do *not* want to allow is to have people call "readahead"
> functions and basically kill the machine because you now have a
> unkillable IO that is insanely big. So I'd much rather limit it too
> much than too little. And on absolutely no sane IO susbsystem does it
> make sense to read ahead insane amounts.
>
> So I'd rather limit it to something stupid and small, than to not
> limit things at all.
>
> Looking at the interface, for example, the natural thing to do for the
> "readahead()" system call, for example, is to just give it a size of
> ~0ul, and let the system limit things, becaue limiting things in useer
> space is just not reasonable.
>
> So I really do *not* think it's fine to just remove the limit entirely.
>

Very sorry for late reply (was on very loong vacation).

How about having 16MB limit only for remote readaheads and continuing
the rest as is, something like below:

#define MAX_REMOTE_READAHEAD    4096UL

unsigned long max_sane_readahead(unsigned long nr)
{

	unsigned long local_free_page = (node_page_state(numa_node_id(), 
NR_INACTIVE_FILE)
	+ node_page_state(numa_node_id(), NR_FREE_PAGES));
	unsigned long sane_nr = min(nr, MAX_REMOTE_READAHEAD);

	return (local_free_page ? min(nr, local_free_page / 2) : sane_nr);
}

or we can enforce 16MB limit for all the case too.

I 'll send a patch accordingly.

(readahead max will scale accordingly if we dont have 4k page size
  above).

