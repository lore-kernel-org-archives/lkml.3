Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3LSAnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:43:10 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41703 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3LSAnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:43:08 -0500
Message-ID: <52B240C8.5070805@oracle.com>
Date: Wed, 18 Dec 2013 19:41:44 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Hugh Dickins <hughd@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] mm/rmap: fix BUG at rmap_walk
References: <1387412195-26498-1-git-send-email-liwanp@linux.vnet.ibm.com> <20131218162858.6ec808c067baf4644532e110@linux-foundation.org>
In-Reply-To: <20131218162858.6ec808c067baf4644532e110@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 07:28 PM, Andrew Morton wrote:
> On Thu, 19 Dec 2013 08:16:35 +0800 Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:
>
>> page_get_anon_vma() called in page_referenced_anon() will lock and
>> increase the refcount of anon_vma, page won't be locked for anonymous
>> page. This patch fix it by skip check anonymous page locked.
>>
>> [  588.698828] kernel BUG at mm/rmap.c:1663!
>
> Why is all this suddenly happening.  Did we change something, or did a
> new test get added to trinity?

Dave has improved mmap testing in trinity, maybe it's related?

> Or if there is no reason why the page must be locked for
> rmap_walk_ksm() and rmap_walk_file(), let's just remove rmap_walk()'s
> VM_BUG_ON()?  And rmap_walk_ksm()'s as well - it's duplicative anyway.

IMO, removing all these VM_BUG_ON()s (which is happening quite often recently) will
lead to having bugs sneak by causing obscure undetected corruption instead of
being very obvious through a BUG.

I know it might be silly, but if we're removing a lot of these - can we "balance"
it back by asking people to introduce new VM_BUG_ON()s, along with a short comment
explaining why to places where these assumptions are going unchecked and are obvious
to them but not to many others?

I'll be more than happy to fuzz through patches that do that to make sure
we catch corner cases.


Thanks,
Sasha

