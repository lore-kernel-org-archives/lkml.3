Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaLQWaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 17:30:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaLQWaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 17:30:11 -0500
Date: Wed, 17 Dec 2014 14:30:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Petr Cermak <petrcermak@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Primiano Tucci <primiano@chromium.org>
Subject: Re: [PATCH 2/2] task_mmu: Add user-space support for resetting
 mm->hiwater_rss (peak RSS)
Message-Id: <20141217143010.ccf73cbd544ade86bb4dec3f@linux-foundation.org>
In-Reply-To: <1418663733-15949-1-git-send-email-petrcermak@chromium.org>
References: <1418223544-11382-1-git-send-email-petrcermak@chromium.org>
	<1418663733-15949-1-git-send-email-petrcermak@chromium.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2014 17:15:33 +0000 Petr Cermak <petrcermak@chromium.org> wrote:

> Peak resident size of a process can be reset by writing "5" to
> /proc/pid/clear_refs. The driving use-case for this would be getting the
> peak RSS value, which can be retrieved from the VmHWM field in
> /proc/pid/status, per benchmark iteration or test scenario.

The term "reset" is ambiguous - it often means "reset it to zero".

This?

--- a/Documentation/filesystems/proc.txt~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix
+++ a/Documentation/filesystems/proc.txt
@@ -488,7 +488,8 @@ To clear the bits for the file mapped pa
 To clear the soft-dirty bit
     > echo 4 > /proc/PID/clear_refs
 
-To reset the peak resident set size ("high water mark")
+To reset the peak resident set size ("high water mark") to the process's
+current value:
     > echo 5 > /proc/PID/clear_refs
 
 Any other value written to /proc/PID/clear_refs will have no effect.
--- a/fs/proc/task_mmu.c~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix
+++ a/fs/proc/task_mmu.c
@@ -859,7 +859,7 @@ static ssize_t clear_refs_write(struct f
 	if (type == CLEAR_REFS_MM_HIWATER_RSS) {
 		/*
 		 * Writing 5 to /proc/pid/clear_refs resets the peak resident
-		 * set size.
+		 * set size to this mm's current rss value.
 		 */
 		down_write(&mm->mmap_sem);
 		reset_mm_hiwater_rss(mm);
_

