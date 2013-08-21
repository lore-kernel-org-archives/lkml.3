Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3HUNx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:53:57 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45824 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab3HUNxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:53:55 -0400
Message-ID: <5214C65C.8020908@oracle.com>
Date: Wed, 21 Aug 2013 09:53:32 -0400
From: konrad wilk <konrad.wilk@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Xen-devel@lists.xen.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
References: <5214C524.1050900@citrix.com>
In-Reply-To: <5214C524.1050900@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 8/21/2013 9:48 AM, David Vrabel wrote:
> All,
>
> 179ef71c (mm: save soft-dirty bits on swapped pages) introduces a new
> PTE bit on x86 _PTE_SWP_SOFT_DIRTY which has the same value as _PTE_PSE
> and _PTE_PAT.
>
> With a Xen PV guest, the use of the _PTE_PAT will result in the page
> having unexpected cachability which will introduce a range of subtle
> performance and correctness issues.  Xen programs the entry 4 in the PAT
> table with WC so a page that was previously WB will end up as WC.
Especially with filesystems which would end up using those pages (as the 
memory allocator
would recycle them) and with corruption in the filesystem. Took months 
to figure
that out.

>
> The use of this bit also appears to preclude the use of (transparent)
> huge pages by the application.  It is not clear if there is something
> else guaranteeing that that there will be no huge pages.
>
> To fix this regression I suggest one or more of:
>
> 1. If no other changes are made, at a mimimum, MEM_SOFT_DIRTY must
> require !XEN and possibly !TRANSPARENT_HUGEPAGE and !HUGETLBFS.  This
> would prevent this option being enabled on the majority of standard
> Linux distributions.
>
> 2. Find a different PTE bit to (re)use.
>
> 3. Avoid clearing the soft dirty bit when repopulating a swapped out page.
>
> 4. Redesign the soft dirty tracking to not require the use of
> architecture specific PTE bits.  e.g., by using a shadow set of
> structures for the soft dirty bit tracking.

Or revert this patch and in 3.12 fix it using one of the options above 
or other ones.
>
> David

