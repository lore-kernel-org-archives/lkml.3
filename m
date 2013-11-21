Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab3KUOcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:32:52 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:50065 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab3KUOcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:32:06 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 08/10] staging/lustre/libcfs: remove lwt code
Date: Thu, 21 Nov 2013 22:28:29 +0800
Message-Id: <1385044111-3129-9-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
References: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was never enabled.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/libcfs_ioctl.h     |    3 -
 .../lustre/include/linux/libcfs/linux/kp30.h       |   96 -------
 drivers/staging/lustre/lustre/libcfs/lwt.c         |  266 --------------------
 drivers/staging/lustre/lustre/libcfs/module.c      |   53 +---
 4 files changed, 3 insertions(+), 415 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/libcfs/lwt.c

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_ioctl.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_ioctl.h
index 315743e..dd1a1f1 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_ioctl.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_ioctl.h
@@ -113,9 +113,6 @@ struct libcfs_ioctl_handler {
 #define IOC_LIBCFS_PANIC		   _IOWR('e', 30, long)
 #define IOC_LIBCFS_CLEAR_DEBUG	     _IOWR('e', 31, long)
 #define IOC_LIBCFS_MARK_DEBUG	      _IOWR('e', 32, long)
-#define IOC_LIBCFS_LWT_CONTROL	     _IOWR('e', 33, long)
-#define IOC_LIBCFS_LWT_SNAPSHOT	    _IOWR('e', 34, long)
-#define IOC_LIBCFS_LWT_LOOKUP_STRING       _IOWR('e', 35, long)
 #define IOC_LIBCFS_MEMHOG		  _IOWR('e', 36, long)
 #define IOC_LIBCFS_PING_TEST	       _IOWR('e', 37, long)
 /* lnet ioctls */
diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
index 3a883f8..ba14c31 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
@@ -77,102 +77,6 @@
 	module_param(name, type, perm);\
 	MODULE_PARM_DESC(name, desc)
 
-/******************************************************************************/
-/* Light-weight trace
- * Support for temporary event tracing with minimal Heisenberg effect. */
-#define LWT_SUPPORT  0
-
-#define LWT_MEMORY   (16<<20)
-
-#ifndef KLWT_SUPPORT
-#  if !defined(BITS_PER_LONG)
-#   error "BITS_PER_LONG not defined"
-#  endif
-
-/* kernel hasn't defined this? */
-typedef struct {
-	long long   lwte_when;
-	char       *lwte_where;
-	void       *lwte_task;
-	long	lwte_p1;
-	long	lwte_p2;
-	long	lwte_p3;
-	long	lwte_p4;
-# if BITS_PER_LONG > 32
-	long	lwte_pad;
-# endif
-} lwt_event_t;
-#endif /* !KLWT_SUPPORT */
-
-#if LWT_SUPPORT
-#  if !KLWT_SUPPORT
-
-typedef struct _lwt_page {
-	struct list_head	       lwtp_list;
-	struct page	     *lwtp_page;
-	lwt_event_t	     *lwtp_events;
-} lwt_page_t;
-
-typedef struct {
-	int		lwtc_current_index;
-	lwt_page_t	*lwtc_current_page;
-} lwt_cpu_t;
-
-extern int       lwt_enabled;
-extern lwt_cpu_t lwt_cpus[];
-
-/* Note that we _don't_ define LWT_EVENT at all if LWT_SUPPORT isn't set.
- * This stuff is meant for finding specific problems; it never stays in
- * production code... */
-
-#define LWTSTR(n)       #n
-#define LWTWHERE(f,l)   f ":" LWTSTR(l)
-#define LWT_EVENTS_PER_PAGE (PAGE_CACHE_SIZE / sizeof (lwt_event_t))
-
-#define LWT_EVENT(p1, p2, p3, p4)				       \
-do {								    \
-	unsigned long    flags;					 \
-	lwt_cpu_t       *cpu;					   \
-	lwt_page_t      *p;					     \
-	lwt_event_t     *e;					     \
-									\
-	if (lwt_enabled) {					      \
-		local_irq_save (flags);				 \
-									\
-		cpu = &lwt_cpus[smp_processor_id()];		    \
-		p = cpu->lwtc_current_page;			     \
-		e = &p->lwtp_events[cpu->lwtc_current_index++];	 \
-									\
-		if (cpu->lwtc_current_index >= LWT_EVENTS_PER_PAGE) {   \
-			cpu->lwtc_current_page =			\
-				list_entry (p->lwtp_list.next,      \
-						lwt_page_t, lwtp_list); \
-			cpu->lwtc_current_index = 0;		    \
-		}						       \
-									\
-		e->lwte_when  = get_cycles();			   \
-		e->lwte_where = LWTWHERE(__FILE__,__LINE__);	    \
-		e->lwte_task  = current;				\
-		e->lwte_p1    = (long)(p1);			     \
-		e->lwte_p2    = (long)(p2);			     \
-		e->lwte_p3    = (long)(p3);			     \
-		e->lwte_p4    = (long)(p4);			     \
-									\
-		local_irq_restore (flags);			      \
-	}							       \
-} while (0)
-
-#endif /* !KLWT_SUPPORT */
-
-extern int  lwt_init (void);
-extern void lwt_fini (void);
-extern int  lwt_lookup_string (int *size, char *knlptr,
-			       char *usrptr, int usrsize);
-extern int  lwt_control (int enable, int clear);
-extern int  lwt_snapshot (cfs_cycles_t *now, int *ncpu, int *total_size,
-			  void *user_ptr, int user_size);
-#endif /* LWT_SUPPORT */
-
 /* ------------------------------------------------------------------ */
 
 # define LI_POISON 0x5a5a5a5a
diff --git a/drivers/staging/lustre/lustre/libcfs/lwt.c b/drivers/staging/lustre/lustre/libcfs/lwt.c
deleted file mode 100644
index b631f7d..0000000
--- a/drivers/staging/lustre/lustre/libcfs/lwt.c
+++ /dev/null
@@ -1,266 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2008, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * libcfs/libcfs/lwt.c
- *
- * Author: Eric Barton <eeb@clusterfs.com>
- */
-
-#define DEBUG_SUBSYSTEM S_LNET
-
-#include <linux/libcfs/libcfs.h>
-
-#if LWT_SUPPORT
-
-#if !KLWT_SUPPORT
-int	 lwt_enabled;
-lwt_cpu_t   lwt_cpus[NR_CPUS];
-#endif
-
-int	 lwt_pages_per_cpu;
-
-/* NB only root is allowed to retrieve LWT info; it's an open door into the
- * kernel... */
-
-int
-lwt_lookup_string (int *size, char *knl_ptr,
-		   char *user_ptr, int user_size)
-{
-	int   maxsize = 128;
-
-	/* knl_ptr was retrieved from an LWT snapshot and the caller wants to
-	 * turn it into a string.  NB we can crash with an access violation
-	 * trying to determine the string length, so we're trusting our
-	 * caller... */
-
-	if (!cfs_capable(CFS_CAP_SYS_ADMIN))
-		return (-EPERM);
-
-	if (user_size > 0 &&
-	    maxsize > user_size)
-		maxsize = user_size;
-
-	*size = strnlen (knl_ptr, maxsize - 1) + 1;
-
-	if (user_ptr != NULL) {
-		if (user_size < 4)
-			return (-EINVAL);
-
-		if (copy_to_user (user_ptr, knl_ptr, *size))
-			return (-EFAULT);
-
-		/* Did I truncate the string?  */
-		if (knl_ptr[*size - 1] != 0)
-			copy_to_user (user_ptr + *size - 4, "...", 4);
-	}
-
-	return (0);
-}
-
-int
-lwt_control (int enable, int clear)
-{
-	lwt_page_t  *p;
-	int	  i;
-	int	  j;
-
-	if (!cfs_capable(CFS_CAP_SYS_ADMIN))
-		return (-EPERM);
-
-	if (!enable) {
-		LWT_EVENT(0,0,0,0);
-		lwt_enabled = 0;
-		mb();
-		/* give people some time to stop adding traces */
-		schedule_timeout(10);
-	}
-
-	for (i = 0; i < num_online_cpus(); i++) {
-		p = lwt_cpus[i].lwtc_current_page;
-
-		if (p == NULL)
-			return (-ENODATA);
-
-		if (!clear)
-			continue;
-
-		for (j = 0; j < lwt_pages_per_cpu; j++) {
-			memset (p->lwtp_events, 0, PAGE_CACHE_SIZE);
-
-			p = list_entry (p->lwtp_list.next,
-					    lwt_page_t, lwtp_list);
-		}
-	}
-
-	if (enable) {
-		lwt_enabled = 1;
-		mb();
-		LWT_EVENT(0,0,0,0);
-	}
-
-	return (0);
-}
-
-int
-lwt_snapshot (cfs_cycles_t *now, int *ncpu, int *total_size,
-	      void *user_ptr, int user_size)
-{
-	const int    events_per_page = PAGE_CACHE_SIZE / sizeof(lwt_event_t);
-	const int    bytes_per_page = events_per_page * sizeof(lwt_event_t);
-	lwt_page_t  *p;
-	int	  i;
-	int	  j;
-
-	if (!cfs_capable(CFS_CAP_SYS_ADMIN))
-		return (-EPERM);
-
-	*ncpu = num_online_cpus();
-	*total_size = num_online_cpus() * lwt_pages_per_cpu *
-		bytes_per_page;
-	*now = get_cycles();
-
-	if (user_ptr == NULL)
-		return (0);
-
-	for (i = 0; i < num_online_cpus(); i++) {
-		p = lwt_cpus[i].lwtc_current_page;
-
-		if (p == NULL)
-			return (-ENODATA);
-
-		for (j = 0; j < lwt_pages_per_cpu; j++) {
-			if (copy_to_user(user_ptr, p->lwtp_events,
-					     bytes_per_page))
-				return (-EFAULT);
-
-			user_ptr = ((char *)user_ptr) + bytes_per_page;
-			p = list_entry(p->lwtp_list.next,
-					   lwt_page_t, lwtp_list);
-		}
-	}
-
-	return (0);
-}
-
-int
-lwt_init ()
-{
-	int     i;
-	int     j;
-
-	for (i = 0; i < num_online_cpus(); i++)
-		if (lwt_cpus[i].lwtc_current_page != NULL)
-			return (-EALREADY);
-
-	LASSERT (!lwt_enabled);
-
-	/* NULL pointers, zero scalars */
-	memset (lwt_cpus, 0, sizeof (lwt_cpus));
-	lwt_pages_per_cpu =
-		LWT_MEMORY / (num_online_cpus() * PAGE_CACHE_SIZE);
-
-	for (i = 0; i < num_online_cpus(); i++)
-		for (j = 0; j < lwt_pages_per_cpu; j++) {
-			struct page *page = alloc_page (GFP_KERNEL);
-			lwt_page_t  *lwtp;
-
-			if (page == NULL) {
-				CERROR ("Can't allocate page\n");
-				lwt_fini ();
-				return (-ENOMEM);
-			}
-
-			LIBCFS_ALLOC(lwtp, sizeof (*lwtp));
-			if (lwtp == NULL) {
-				CERROR ("Can't allocate lwtp\n");
-				__free_page(page);
-				lwt_fini ();
-				return (-ENOMEM);
-			}
-
-			lwtp->lwtp_page = page;
-			lwtp->lwtp_events = page_address(page);
-			memset (lwtp->lwtp_events, 0, PAGE_CACHE_SIZE);
-
-			if (j == 0) {
-				INIT_LIST_HEAD (&lwtp->lwtp_list);
-				lwt_cpus[i].lwtc_current_page = lwtp;
-			} else {
-				list_add (&lwtp->lwtp_list,
-				    &lwt_cpus[i].lwtc_current_page->lwtp_list);
-			}
-		}
-
-	lwt_enabled = 1;
-	mb();
-
-	LWT_EVENT(0,0,0,0);
-
-	return (0);
-}
-
-void
-lwt_fini ()
-{
-	int    i;
-
-	lwt_control(0, 0);
-
-	for (i = 0; i < num_online_cpus(); i++)
-		while (lwt_cpus[i].lwtc_current_page != NULL) {
-			lwt_page_t *lwtp = lwt_cpus[i].lwtc_current_page;
-
-			if (list_empty (&lwtp->lwtp_list)) {
-				lwt_cpus[i].lwtc_current_page = NULL;
-			} else {
-				lwt_cpus[i].lwtc_current_page =
-					list_entry (lwtp->lwtp_list.next,
-							lwt_page_t, lwtp_list);
-
-				list_del (&lwtp->lwtp_list);
-			}
-
-			__free_page (lwtp->lwtp_page);
-			LIBCFS_FREE (lwtp, sizeof (*lwtp));
-		}
-}
-
-EXPORT_SYMBOL(lwt_enabled);
-EXPORT_SYMBOL(lwt_cpus);
-
-EXPORT_SYMBOL(lwt_init);
-EXPORT_SYMBOL(lwt_fini);
-EXPORT_SYMBOL(lwt_lookup_string);
-EXPORT_SYMBOL(lwt_control);
-EXPORT_SYMBOL(lwt_snapshot);
-#endif
diff --git a/drivers/staging/lustre/lustre/libcfs/module.c b/drivers/staging/lustre/lustre/libcfs/module.c
index f3108c7..463b3e17 100644
--- a/drivers/staging/lustre/lustre/libcfs/module.c
+++ b/drivers/staging/lustre/lustre/libcfs/module.c
@@ -235,41 +235,6 @@ static int libcfs_ioctl_int(struct cfs_psdev_file *pfile,unsigned long cmd,
 			return -EINVAL;
 		libcfs_debug_mark_buffer(data->ioc_inlbuf1);
 		return 0;
-#if LWT_SUPPORT
-	case IOC_LIBCFS_LWT_CONTROL:
-		err = lwt_control ((data->ioc_flags & 1) != 0,
-				   (data->ioc_flags & 2) != 0);
-		break;
-
-	case IOC_LIBCFS_LWT_SNAPSHOT: {
-		cfs_cycles_t   now;
-		int	    ncpu;
-		int	    total_size;
-
-		err = lwt_snapshot (&now, &ncpu, &total_size,
-				    data->ioc_pbuf1, data->ioc_plen1);
-		data->ioc_u64[0] = now;
-		data->ioc_u32[0] = ncpu;
-		data->ioc_u32[1] = total_size;
-
-		/* Hedge against broken user/kernel typedefs (e.g. cycles_t) */
-		data->ioc_u32[2] = sizeof(lwt_event_t);
-		data->ioc_u32[3] = offsetof(lwt_event_t, lwte_where);
-
-		if (err == 0 &&
-		    libcfs_ioctl_popdata(arg, data, sizeof (*data)))
-			err = -EFAULT;
-		break;
-	}
-
-	case IOC_LIBCFS_LWT_LOOKUP_STRING:
-		err = lwt_lookup_string (&data->ioc_count, data->ioc_pbuf1,
-					 data->ioc_pbuf2, data->ioc_plen2);
-		if (err == 0 &&
-		    libcfs_ioctl_popdata(arg, data, sizeof (*data)))
-			err = -EFAULT;
-		break;
-#endif
 	case IOC_LIBCFS_MEMHOG:
 		if (pfile->private_data == NULL) {
 			err = -EINVAL;
@@ -392,17 +357,10 @@ static int init_libcfs_module(void)
 	if (rc != 0)
 		goto cleanup_debug;
 
-#if LWT_SUPPORT
-	rc = lwt_init();
-	if (rc != 0) {
-		CERROR("lwt_init: error %d\n", rc);
-		goto cleanup_debug;
-	}
-#endif
 	rc = misc_register(&libcfs_dev);
 	if (rc) {
 		CERROR("misc_register: error %d\n", rc);
-		goto cleanup_lwt;
+		goto cleanup_cpu;
 	}
 
 	rc = cfs_wi_startup();
@@ -441,10 +399,8 @@ static int init_libcfs_module(void)
 	cfs_wi_shutdown();
  cleanup_deregister:
 	misc_deregister(&libcfs_dev);
- cleanup_lwt:
-#if LWT_SUPPORT
-	lwt_fini();
-#endif
+cleanup_cpu:
+	cfs_cpu_fini();
  cleanup_debug:
 	libcfs_debug_cleanup();
 	return rc;
@@ -471,9 +427,6 @@ static void exit_libcfs_module(void)
 	if (rc)
 		CERROR("misc_deregister error %d\n", rc);
 
-#if LWT_SUPPORT
-	lwt_fini();
-#endif
 	cfs_cpu_fini();
 
 	if (atomic_read(&libcfs_kmemory) != 0)
-- 
1.7.9.5

