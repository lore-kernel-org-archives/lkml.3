Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaLGVQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 16:16:48 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:39267 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaLGVQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 16:16:46 -0500
Message-ID: <5484C3B9.2030909@de.ibm.com>
Date: Sun, 07 Dec 2014 22:16:41 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the access_once tree
References: <20141205213224.2dcc20e9@canb.auug.org.au> <5484BF4D.1020809@de.ibm.com>
In-Reply-To: <5484BF4D.1020809@de.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------010107050306070606060403"
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120721-0013-0000-0000-00000220095C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010107050306070606060403
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Am 07.12.2014 um 21:57 schrieb Christian Borntraeger:
> Am 05.12.2014 um 11:32 schrieb Stephen Rothwell:
>> Hi Christian,
>>
>> After merging the access_once tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> In file included from include/linux/compiler.h:189:0,
>>                  from include/uapi/linux/stddef.h:1,
>>                  from include/linux/stddef.h:4,
>>                  from include/uapi/linux/posix_types.h:4,
>>                  from include/linux/fdtable.h:8,
>>                  from security/apparmor/domain.c:16:
>> include/linux/types.h:14:9: error: unknown type name '__kernel_fd_set'
>>  typedef __kernel_fd_set  fd_set;
>>          ^
>>
>> And many more :-(
>>
>> Presumably caused by commit b06f66134856 ("kernel: Provide READ_ONCE
>> and ASSIGN_ONCE") which added types.h into compiler.h, but I am not
>> sure.  It could be an interaction with something else in linux-next, of
>> course.
>>
>> I have dropped the access_once tree for today, sorry.
>>
> 
> Interesting, I double checked with defconfig and cross compilation. But yes, using allmodconfig fails.
> I have changed that to uapi/linux/types.h and __u<xx>. This seems to fix it as it only adds a small set of types.
> 
> Can you re-add?
> 
> Christian
> 

I also did an additional check and merged this tree with linux-next/master. This introduced a new problem.
The fix is simple, see patch. But I am not sure how to add that to next (via my tree), since this change is only in next.

Christian

--------------010107050306070606060403
Content-Type: text/x-patch;
 name="0001-x86-xen-p2m-Replace-ACCESS_ONCE-with-READ_ONCE.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-xen-p2m-Replace-ACCESS_ONCE-with-READ_ONCE.patch"

>From ef62db716c9edb1343c00eae45ad8f6c0c1c9255 Mon Sep 17 00:00:00 2001
From: Christian Borntraeger <borntraeger@de.ibm.com>
Date: Sun, 7 Dec 2014 22:01:59 +0100
Subject: [PATCH] x86/xen/p2m: Replace ACCESS_ONCE with READ_ONCE

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) step
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)

Change the p2m code to replace ACCESS_ONCE with READ_ONCE.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/x86/xen/p2m.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 8b5db51..08ddf91 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -554,7 +554,7 @@ static bool alloc_p2m(unsigned long pfn)
 		mid_mfn = NULL;
 	}
 
-	p2m_pfn = pte_pfn(ACCESS_ONCE(*ptep));
+	p2m_pfn = pte_pfn(READ_ONCE(*ptep));
 	if (p2m_pfn == PFN_DOWN(__pa(p2m_identity)) ||
 	    p2m_pfn == PFN_DOWN(__pa(p2m_missing))) {
 		/* p2m leaf page is missing */
-- 
1.8.5.5


--------------010107050306070606060403--

