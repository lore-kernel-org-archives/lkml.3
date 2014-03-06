Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaCFWdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 17:33:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaCFWdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 17:33:10 -0500
Date: Thu, 6 Mar 2014 17:31:37 -0500
From: Rik van Riel <riel@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, mgorman@suse.de,
        hhuang@redhat.com, knoel@redhat.com, aarcange@redhat.com
Subject: [PATCH -mm] mm,numa,mprotect: always continue after finding a
 stable thp page
Message-ID: <20140306173137.6a23a0b2@cuia.bos.redhat.com>
In-Reply-To: <5318E4BC.50301@oracle.com>
References: <5318E4BC.50301@oracle.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Mar 2014 16:12:28 -0500
Sasha Levin <sasha.levin@oracle.com> wrote:

> While fuzzing with trinity inside a KVM tools guest running latest -next kernel I've hit the
> following spew. This seems to be introduced by your patch "mm,numa: reorganize change_pmd_range()".

That patch should not introduce any functional changes, except for
the VM_BUG_ON that catches the fact that we fell through to the 4kB
pte handling code, despite having just handled a THP pmd...

Does this patch fix the issue?

Mel, am I overlooking anything obvious? :)

---8<---

Subject: mm,numa,mprotect: always continue after finding a stable thp page

When turning a thp pmds into a NUMA one, change_huge_pmd will
return 0 when the pmd already is a NUMA pmd.

However, change_pmd_range would fall through to the code that
handles 4kB pages, instead of continuing on to the next pmd.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
---
 mm/mprotect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 61f0a07..4746608 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -138,8 +138,8 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 						pages += HPAGE_PMD_NR;
 						nr_huge_updates++;
 					}
-					continue;
 				}
+				continue;
 			}
 			/* fall through, the trans huge pmd just split */
 		}
