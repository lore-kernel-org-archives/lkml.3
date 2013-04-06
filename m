Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab3DFKOR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 06:14:17 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:34292 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828Ab3DFKOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 06:14:15 -0400
Message-ID: <515FF3CC.80106@gmail.com>
Date: Sat, 06 Apr 2013 12:07:08 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] fsfreeze: avoid to return zero in __get_user_pages
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of VM_FAULT_RETRY, __get_user_pages returns the number
of pages alredy gotten, but there isn't a check if this number is
zero. Instead, we have to return a proper error code so we can avoid
a possible extra call of __get_user_pages. There are several
places where get_user_pages is called inside a loop until all the
pages requested are gotten or an error code is returned.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 mm/memory.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 494526a..cca14ed 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1858,7 +1858,7 @@ long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 				if (ret & VM_FAULT_RETRY) {
 					if (nonblocking)
 						*nonblocking = 0;
-					return i;
+					return i ? i : -ERESTARTSYS;
 				}
 
 				/*
-- 
1.7.3.4
