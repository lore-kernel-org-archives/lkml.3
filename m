Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032Ab3DDMez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:34:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64421 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759715Ab3DDMcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:32:45 -0400
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH 3/8] staging: android: binder: fix binder interface for 64bit compat layer
Date: Thu,  4 Apr 2013 13:32:33 +0100
Message-Id: <1365078758-28674-4-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
References: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The changes in this patch will fix the binder interface for use on 64bit
machines and stand as the base of the 64bit compat support. The changes
apply to the structures that are passed between the kernel and
userspace.

Most of the  changes applied mirror the change to struct binder_version
where there is no need for a 64bit wide protocol_version(on 64bit
machines). The change inlines with the existing 32bit userspace(the
structure has the same size) and simplifies the compat layer such that
the same handler can service the BINDER_VERSION ioctl.

Other changes fix the function prototypes for binder_thread_read/write
and make use of kernel types as well as user-exportable ones.

The changes do not affect existing 32bit ABI.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/binder.c |    6 +++---
 drivers/staging/android/binder.h |   16 ++++++++--------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 5794cf6..caa6dde 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -1700,7 +1700,7 @@ err_no_context_mgr_node:
 }
 
 int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
-			void __user *buffer, int size, signed long *consumed)
+			void __user *buffer, size_t size, size_t *consumed)
 {
 	unsigned int cmd;
 	void __user *ptr = buffer + *consumed;
@@ -2080,8 +2080,8 @@ static int binder_has_thread_work(struct binder_thread *thread)
 
 static int binder_thread_read(struct binder_proc *proc,
 			      struct binder_thread *thread,
-			      void  __user *buffer, int size,
-			      signed long *consumed, int non_block)
+			      void  __user *buffer, size_t size,
+			      size_t *consumed, int non_block)
 {
 	void __user *ptr = buffer + *consumed;
 	void __user *end = buffer + size;
diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
index dbe81ce..8012921 100644
--- a/drivers/staging/android/binder.h
+++ b/drivers/staging/android/binder.h
@@ -48,13 +48,13 @@ enum {
  */
 struct flat_binder_object {
 	/* 8 bytes for large_flat_header. */
-	unsigned long		type;
-	unsigned long		flags;
+	__u32		type;
+	__u32		flags;
 
 	/* 8 bytes of data. */
 	union {
 		void __user	*binder;	/* local object */
-		signed long	handle;		/* remote object */
+		__s32	    handle;		/* remote object */
 	};
 
 	/* extra data associated with local object */
@@ -67,18 +67,18 @@ struct flat_binder_object {
  */
 
 struct binder_write_read {
-	signed long	write_size;	/* bytes to write */
-	signed long	write_consumed;	/* bytes consumed by driver */
+	size_t  write_size;	/* bytes to write */
+	size_t  write_consumed;	/* bytes consumed by driver */
 	unsigned long	write_buffer;
-	signed long	read_size;	/* bytes to read */
-	signed long	read_consumed;	/* bytes consumed by driver */
+	size_t  read_size;	/* bytes to read */
+	size_t  read_consumed;	/* bytes consumed by driver */
 	unsigned long	read_buffer;
 };
 
 /* Use with BINDER_VERSION, driver fills in fields. */
 struct binder_version {
 	/* driver protocol version -- increment with incompatible change */
-	signed long	protocol_version;
+	__s32       protocol_version;
 };
 
 /* This is the current protocol version. */
-- 
1.7.9.5

