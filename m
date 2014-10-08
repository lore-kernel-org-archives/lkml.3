Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaJHQoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:44:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38726 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJHQoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:44:11 -0400
Message-ID: <543569CD.4060309@oracle.com>
Date: Wed, 08 Oct 2014 12:43:57 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mgorman@suse.de
Subject: Re: [PATCH 0/5] mm: poison critical mm/ structs
References: <1412041639-23617-1-git-send-email-sasha.levin@oracle.com> <20141001140725.fd7f1d0cf933fbc2aa9fc1b1@linux-foundation.org> <542C749B.1040103@oracle.com> <alpine.LSU.2.11.1410020154500.6444@eggly.anvils> <542D680E.8010909@oracle.com> <54346623.6000309@intel.com>
In-Reply-To: <54346623.6000309@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 06:16 PM, Dave Hansen wrote:
> On 10/02/2014 07:58 AM, Sasha Levin wrote:
>>>> What does this add on top of slab poisoning?  Some checks in some
>>>> mm places while the object is active, I guess: why not base those
>>>> on slab poisoning?  And add them in as appropriate to the problem
>>>> at hand, when a problem is seen.
>> The extra you're getting is detecting corruption that happened
>> inside the object rather than around it.
> 
> Isn't this more akin to redzoning that poisoning?
> 
> I'm not sure I follow the logic here.  The poison is inside the object,
> but it's now at the edges.  With slub at least, you get a redzone right
> after the object(s):
> 
> 	{ OBJ } | REDZONE | { OBJ } | REDZONE | ...
> 
> With this patch, you'd get something along these lines:
> 
> 	{ POISON | OBJ | POISON } { POISON | OBJ | POISON }  ...
> 
> So if somebody overflows OBJ, they'll hit the redzone/poison in either
> case.  If they're randomly scribbling on memory, their likelihood of
> hitting the redzone/poison is proportional to the size of the
> redzone/poison.
> 
> The only place this really helps is if someone overflows from a
> non-redzoned page or structure in to the beginning of a slub redzoned
> one.  The fact that the redzone is at the end means we'll miss it.
> 
> But, all that means is that we should probably add redzones to the
> beginning of slub objects, not just the end.  That doesn't help us with
> 'struct page' of course, but it does for the mm_struct and vma.

This patchset is based on an actual issue we're seeing where the vma
gets corrupted without triggering any of the slub redzones.

Testing this patchset locally confirmed that while slub redzones stay
intact, the poison fields get overwritten - so now we're able to catch
the corruption after it happened.

I'm not sure what's the scenario that causes that, but once we figure
that out I could have a better response to your question...


Thanks,
Sasha

