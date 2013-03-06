Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab3CFRIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 12:08:43 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:51644 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3CFRIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 12:08:42 -0500
Date: Tue, 5 Mar 2013 19:37:27 -0500
From: Andrew Shewmaker <agshew@gmail.com>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        ric.masonn@gmail.com
Subject: Re: [PATCH v4 001/002] mm: limit growth of 3% hardcoded other user
 reserve
Message-ID: <20130306003727.GA2072@localhost.localdomain>
References: <20130305233811.GA1948@localhost.localdomain>
 <513683D5.1080401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513683D5.1080401@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 07:46:29AM +0800, Simon Jeons wrote:
> On 03/06/2013 07:38 AM, Andrew Shewmaker wrote:
> >Limit the growth of the memory reserved for other processes
> >to the smaller of 3% or 8MB.
> >
> >This affects only OVERCOMMIT_NEVER.
> >
> >Signed-off-by: Andrew Shewmaker <agshew@gmail.com>
> 
> Please add changelog, otherwise it's for other guys to review.
> 

Sorry, I'll be sure to include one in the future. And it 
looks like I do need a v5 ... I think this needs to 
be tunable like the admin reserve. The default certainly 
needs to be higher since this reserve is only for 
OVERCOMMIT_NEVER mode and 8MB is too little to allow
the user to recover. I was thinking of OVERCOMMIT_GUESS 
mode when I chose it.

v4:
 * Rebased onto v3.8-mmotm-2013-03-01-15-50
 * No longer assumes 4kb pages
 * Code duplicated for nommu

v3:
 * New patch summary because it wasn't unique
   New is "mm: limit growth of 3% hardcoded other user reserve"
   Old was "mm: tuning hardcoded reserve memory"
 * Limits growth to min(3% process size, some constant k)
   as Alan Cox suggested. I chose k=2000 pages (8MB) to allow
   recovery with sshd or login, bash, and top or kill

v2:
 * Rebased onto v3.8-mmotm-2013-02-19-17-20

v1:
 * Based on 3.8
 * Remove hardcoded 3% other user reserve in OVERCOMMIT_NEVER mode

> >
> >---
> >
> >Rebased onto v3.8-mmotm-2013-03-01-15-50
> >
> >No longer assumes 4kb pages.
> >Code duplicated for nommu.
> >
> >diff --git a/mm/mmap.c b/mm/mmap.c
> >index 49dc7d5..4eb2b1a 100644
> >--- a/mm/mmap.c
> >+++ b/mm/mmap.c
> >@@ -184,9 +184,11 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
> >  	allowed += total_swap_pages;
> >  	/* Don't let a single process grow too big:
> >-	   leave 3% of the size of this process for other processes */
> >+	 * leave the smaller of 3% of the size of this process
> >+         * or 8MB for other processes
> >+         */
> >  	if (mm)
> >-		allowed -= mm->total_vm / 32;
> >+		allowed -= min(mm->total_vm / 32, 1 << (23 - PAGE_SHIFT));
> >  	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
> >  		return 0;
> >diff --git a/mm/nommu.c b/mm/nommu.c
> >index f5d57a3..a93d214 100644
> >--- a/mm/nommu.c
> >+++ b/mm/nommu.c
> >@@ -1945,9 +1945,11 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
> >  	allowed += total_swap_pages;
> >  	/* Don't let a single process grow too big:
> >-	   leave 3% of the size of this process for other processes */
> >+	 * leave the smaller of 3% of the size of this process
> >+         * or 8MB for other processes
> >+         */
> >  	if (mm)
> >-		allowed -= mm->total_vm / 32;
> >+		allowed -= min(mm->total_vm / 32, 1 << (23 - PAGE_SHIFT));
> >  	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
> >  		return 0;
> 
