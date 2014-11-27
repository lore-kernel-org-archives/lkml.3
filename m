Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbaK0RK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:10:29 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:59785 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaK0RK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:10:28 -0500
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, dahi@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com, mst@redhat.com,
        tglx@linutronix.de, David.Laight@ACULAB.COM
Subject: [PATCH RFC 0/2] Reenable might_sleep() checks for might_fault() when atomic
Date: Thu, 27 Nov 2014 18:10:15 +0100
Message-Id: <1417108217-42687-1-git-send-email-dahi@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com>
References: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112717-0005-0000-0000-00000240EBE1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple prototype to enable might_sleep() checks in might_fault(), avoiding false
positives for scenarios involving explicit pagefault_disable().

So this should work:
	spin_lock(&lock); /* also if left away */
	pagefault_disable()
	rc = copy_to_user(...)
	pagefault_enable();
	spin_unlock(&lock); /*

And this should report a warning again:
	spin_lock(&lock);
	rc = copy_to_user(...);
	spin_unlock(&lock);

Still missing:
- Split of preempt documentation update + preempt_active define reshuffle
- Debug version to test for over/underflows
- Change documentation of user access methods to reflect the real behavior
- Don't touch the preempt counter, only the pagefault disable counter (future
  work)

David Hildenbrand (2):
  preempt: track pagefault_disable() calls in the preempt counter
  mm, sched: trigger might_sleep() in might_fault() when pagefaults are
    disabled

 include/linux/kernel.h       |  9 +++++++--
 include/linux/preempt_mask.h | 24 +++++++++++++++++++-----
 include/linux/uaccess.h      | 21 ++++++++++++++-------
 mm/memory.c                  | 15 ++++-----------
 4 files changed, 44 insertions(+), 25 deletions(-)

-- 
1.8.5.5

