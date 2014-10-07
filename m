Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbaJGWQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 18:16:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:21709 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaJGWQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 18:16:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,673,1406617200"; 
   d="scan'208";a="614795750"
Message-ID: <54346623.6000309@intel.com>
Date: Tue, 07 Oct 2014 15:16:03 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mgorman@suse.de
Subject: Re: [PATCH 0/5] mm: poison critical mm/ structs
References: <1412041639-23617-1-git-send-email-sasha.levin@oracle.com> <20141001140725.fd7f1d0cf933fbc2aa9fc1b1@linux-foundation.org> <542C749B.1040103@oracle.com> <alpine.LSU.2.11.1410020154500.6444@eggly.anvils> <542D680E.8010909@oracle.com>
In-Reply-To: <542D680E.8010909@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 07:58 AM, Sasha Levin wrote:
>> > What does this add on top of slab poisoning?  Some checks in some
>> > mm places while the object is active, I guess: why not base those
>> > on slab poisoning?  And add them in as appropriate to the problem
>> > at hand, when a problem is seen.
> The extra you're getting is detecting corruption that happened
> inside the object rather than around it.

Isn't this more akin to redzoning that poisoning?

I'm not sure I follow the logic here.  The poison is inside the object,
but it's now at the edges.  With slub at least, you get a redzone right
after the object(s):

	{ OBJ } | REDZONE | { OBJ } | REDZONE | ...

With this patch, you'd get something along these lines:

	{ POISON | OBJ | POISON } { POISON | OBJ | POISON }  ...

So if somebody overflows OBJ, they'll hit the redzone/poison in either
case.  If they're randomly scribbling on memory, their likelihood of
hitting the redzone/poison is proportional to the size of the
redzone/poison.

The only place this really helps is if someone overflows from a
non-redzoned page or structure in to the beginning of a slub redzoned
one.  The fact that the redzone is at the end means we'll miss it.

But, all that means is that we should probably add redzones to the
beginning of slub objects, not just the end.  That doesn't help us with
'struct page' of course, but it does for the mm_struct and vma.
