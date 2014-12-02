Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaLBH1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:27:32 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:39530 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaLBH1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:27:17 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 03/10] mm: Convert p[te|md]_numa users to p[te|md]_protnone_numa
In-Reply-To: <1417473762.7182.8.camel@kernel.crashing.org>
References: <1416578268-19597-1-git-send-email-mgorman@suse.de> <1416578268-19597-4-git-send-email-mgorman@suse.de> <1417473762.7182.8.camel@kernel.crashing.org>
User-Agent: Notmuch/0.19+2~g32855b9 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Tue, 02 Dec 2014 12:57:00 +0530
Message-ID: <87k32ah5q3.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120207-0033-0000-0000-0000031B1BB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> On Fri, 2014-11-21 at 13:57 +0000, Mel Gorman wrote:
>> Convert existing users of pte_numa and friends to the new helper. Note
>> that the kernel is broken after this patch is applied until the other
>> page table modifiers are also altered. This patch layout is to make
>> review easier.
>
> Aneesh, the removal of the DSISR_PROTFAULT checks, I wonder if we might
> break something here ... (I know, I asked for them to be removed :-)
>

That is the reason I converted that to a WARN_ON in later patch. 

> IE, we basically bounce all protection checks to the "normal" VMA
> protection checking, so far so good...
>
> But what about the subpage protection stuff ? Will that still work ?
>

I did look at that before. So if we had subpage access limitted, when we
take a fault for that subpage, we bail out early in hash_page_mm. (with
rc = 2). low_hash_fault handle that case directly. We will not end up
calling do_page_fault.

Now, hash_preload can possibly insert an hpte in hash page table even if
the access is not allowed by the pte permissions. But i guess even that
is ok. because we will fault again, end-up calling hash_page_mm where we
handle that part correctly.

-aneesh

