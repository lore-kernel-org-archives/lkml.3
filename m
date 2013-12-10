Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab3LJWWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:22:13 -0500
Received: from www.sr71.net ([198.145.64.142]:56613 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab3LJWWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:22:09 -0500
Message-ID: <52A793D0.4020306@sr71.net>
Date: Tue, 10 Dec 2013 14:21:04 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] [RFC] mm: slab: separate slab_page from 'struct page'
References: <20131210204641.3CB515AE@viggo.jf.intel.com> <00000142de5634af-f92870a7-efe2-45cd-b50d-a6fbdf3b353c-000000@email.amazonses.com> <52A78B55.8050500@sr71.net> <00000142de866123-cf1406b5-b7a3-4688-b46f-80e338a622a1-000000@email.amazonses.com>
In-Reply-To: <00000142de866123-cf1406b5-b7a3-4688-b46f-80e338a622a1-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 02:00 PM, Christoph Lameter wrote:
>> > We _need_ to share fields when the structure is handed between different
>> > subsystems and it needs to be consistent in both places.  For slab page
>> > at least, the only data that actually gets used consistently is
>> > page->flags.  It seems silly to bend over backwards just to share a
>> > single bitfield.
> If you get corruption in one field then you need to figure out which other
> subsystem could have accessed that field. Its not a single bitfield. There
> are numerous relationships between the fields in struct page.

I'm not saying that every 'struct page' user should get their own
complete structure.  I'm just saying that the *slabs* should get their
own structure.  Let's go through it field by field for the "normal"
'struct page' without debugging options:

page->flags: shared by everybody, needs to be consistent for things 	
		like memory error handling
mapping: unioned over by s_mem for slab
index: unioned over by freelist for sl[oua]b
_count: unioned over by lots of stuff by sl[oua]b
lru: unioned over by lots of stuff by sl[oua]b, including another
	list_head called 'list' which blk-mq.c is now using.
private: opaque storage anyway, but unioned over by sl[au]b

See? *EVERYTHING* is overridden by at least one of the sl?b allocators
except ->flags.  In other words, there *ARE* no relationships when it
comes to the sl?bs, except for page->flags.

