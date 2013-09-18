Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab3IRVXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:23:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab3IRVXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:23:01 -0400
Date: Wed, 18 Sep 2013 14:22:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frantisek Hrbata <fhrbata@redhat.com>
Cc: linux-kernel@vger.kernel.org, jstancek@redhat.com, keescook@chromium.org,
        peter.oberparleiter@de.ibm.com, rusty@rustcorp.com.au,
        linux-arch@vger.kernel.org, arnd@arndb.de, mgahagan@redhat.com,
        agospoda@redhat.com
Subject: Re: [PATCH v2 2/4] gcov: add support for gcc 4.7 gcov format
Message-Id: <20130918142259.8c504e7cfbc8318a0550a891@linux-foundation.org>
In-Reply-To: <1378305776-3644-3-git-send-email-fhrbata@redhat.com>
References: <1378305776-3644-1-git-send-email-fhrbata@redhat.com>
	<1378305776-3644-3-git-send-email-fhrbata@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Sep 2013 16:42:54 +0200 Frantisek Hrbata <fhrbata@redhat.com> wrote:

> The gcov in-memory format changed in gcc 4.7. The biggest change, which
> requires this special implementation, is that gcov_info no longer contains
> array of counters for each counter type for all functions and gcov_fn_info is
> not used for mapping of function's counters to these arrays(offset). Now each
> gcov_fn_info contans it's counters, which makes things a little bit easier.
> 
> This is heavily based on the previous gcc_3_4.c implementation and patches
> provided by Peter Oberparleiter. Specially the buffer gcda implementation for
> iterator.

A couple of little tweaks:

--- a/kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-47-gcov-format-fix
+++ a/kernel/gcov/gcc_4_7.c
@@ -254,11 +254,10 @@ struct gcov_info *gcov_info_dup(struct g
 	size_t fi_size; /* function info size */
 	size_t cv_size; /* counter values size */
 
-	dup = kmalloc(sizeof(struct gcov_info), GFP_KERNEL);
+	dup = kmemdup(info, sizeof(*dup), GFP_KERNEL);
 	if (!dup)
 		return NULL;
 
-	*dup = *info;
 	dup->next = NULL;
 	dup->filename = NULL;
 	dup->functions = NULL;
@@ -267,8 +266,8 @@ struct gcov_info *gcov_info_dup(struct g
 	if (!dup->filename)
 		goto err_free;
 
-	dup->functions = kzalloc(sizeof(struct gcov_fn_info *) *
-			info->n_functions, GFP_KERNEL);
+	dup->functions = kcalloc(sizeof(struct gcov_fn_info *),
+				 info->n_functions, GFP_KERNEL);
 	if (!dup->functions)
 		goto err_free;
 
_

