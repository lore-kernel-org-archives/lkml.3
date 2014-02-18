Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaBRWNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:13:00 -0500
Received: from shelob.surriel.com ([74.92.59.67]:50179 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaBRWM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:12:57 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        chegu_vinod@hp.com, aarcange@redhat.com, akpm@linux-foundation.org
Subject: [PATCH -mm 0/3] fix numa vs kvm scalability issue
Date: Tue, 18 Feb 2014 17:12:43 -0500
Message-Id: <1392761566-24834-1-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NUMA scanning code can end up iterating over many gigabytes
of unpopulated memory, especially in the case of a freshly started
KVM guest with lots of memory.

This results in the mmu notifier code being called even when
there are no mapped pages in a virtual address range. The amount
of time wasted can be enough to trigger soft lockup warnings
with very large (>2TB) KVM guests.

This patch moves the mmu notifier call to the pmd level, which
represents 1GB areas of memory on x86-64. Furthermore, the mmu
notifier code is only called from the address in the PMD where
present mappings are first encountered.

The hugetlbfs code is left alone for now; hugetlb mappings are
not relocatable, and as such are left alone by the NUMA code,
and should never trigger this problem to begin with.

The series also adds a cond_resched to task_numa_work, to
fix another potential latency issue.

