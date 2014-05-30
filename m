Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030277AbaE3UFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:05:33 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:58250 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030248AbaE3UF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:05:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jan Kara <jack@suse.cz>
Subject: [RFC 21/32] udf: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:45 +0200
Message-Id: <1401480116-1973111-22-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:8vZo5qoZae4kUvnPEvcLaxrlGxvw/1w2XjBOmYn/bFk
 vh5ZWgef+hSJFaSprfUsh5sdukhcwUrm+d1WJEMF0AOZBUCASY
 NA6ellJGdas+7Fjf2+U+4oaxNR2mo8/qZKjGG0LbYCOLyLkwrN
 iyu2UW+YI0hwVgic6iuhzfRnE3ZlOpXEfoP4uBeA/a8RQZOgIp
 OqeCUINFHQSOizTzpc4TCBq8fdj/qSL9X/+B93jpSJSyMi3r96
 r1ZakpJ9VSDs9dpYTplXw+0wjSuIWoLJAUhL0LQ5cFANZHfy/Z
 hZeejr2f42x3N7G1XQRbl3S+06EYxkEDf0hyk2QbbU4POonWUd
 fvnvIoCnsDDmmmA+nhZzzfyVRDboC5WD22ife6m7B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

udf uses 16-bit year numbers for inode timestamps, which will work
for the 15000 years, but the VFS uses struct timespec for timestamps,
and the Linux udf implementation internally uses a time_t, both of
which are only good until 2038 on 32-bit CPUs.

This gets us one small step closer to lifting the VFS limit by using
struct inode_time in udf, but the implementation still depends on
the 'year_seconds' array that needs to be extended or replaced by
an algorithm that calculates the correct time for every year.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/udf_i.h   | 2 +-
 fs/udf/udf_sb.h  | 2 +-
 fs/udf/udfdecl.h | 7 ++++---
 fs/udf/udftime.c | 7 ++++---
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
index b5cd8ed..ba12313 100644
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -27,7 +27,7 @@ struct udf_ext_cache {
  */
 
 struct udf_inode_info {
-	struct timespec		i_crtime;
+	struct inode_time	i_crtime;
 	/* Physical address of inode */
 	struct kernel_lb_addr		i_location;
 	__u64			i_unique;
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 1f32c7b..20ab0ca 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -135,7 +135,7 @@ struct udf_sb_info {
 	rwlock_t		s_cred_lock;
 
 	/* Root Info */
-	struct timespec		s_record_time;
+	struct inode_time	s_record_time;
 
 	/* Fileset Info */
 	__u16			s_serial_number;
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index be7dabb..88320da 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -237,8 +237,9 @@ extern struct long_ad *udf_get_filelongad(uint8_t *, int, uint32_t *, int);
 extern struct short_ad *udf_get_fileshortad(uint8_t *, int, uint32_t *, int);
 
 /* udftime.c */
-extern struct timespec *udf_disk_stamp_to_time(struct timespec *dest,
-						struct timestamp src);
-extern struct timestamp *udf_time_to_disk_stamp(struct timestamp *dest, struct timespec src);
+extern struct inode_time *udf_disk_stamp_to_time(struct inode_time *dest,
+						 struct timestamp src);
+extern struct timestamp *udf_time_to_disk_stamp(struct timestamp *dest,
+						struct inode_time src);
 
 #endif				/* __UDF_DECL_H */
diff --git a/fs/udf/udftime.c b/fs/udf/udftime.c
index 1f11483..1ab6fe7 100644
--- a/fs/udf/udftime.c
+++ b/fs/udf/udftime.c
@@ -60,6 +60,7 @@ static const unsigned short int __mon_yday[2][13] = {
 #define SPD			0x15180	/*3600*24 */
 #define SPY(y, l, s)		(SPD * (365 * y + l) + s)
 
+/* FIXME: convert this to a 64-bit type */
 static time_t year_seconds[MAX_YEAR_SECONDS] = {
 /*1970*/ SPY(0,   0, 0), SPY(1,   0, 0), SPY(2,   0, 0), SPY(3,   1, 0),
 /*1974*/ SPY(4,   1, 0), SPY(5,   1, 0), SPY(6,   1, 0), SPY(7,   2, 0),
@@ -86,8 +87,8 @@ extern struct timezone sys_tz;
 #define SECS_PER_HOUR	(60 * 60)
 #define SECS_PER_DAY	(SECS_PER_HOUR * 24)
 
-struct timespec *
-udf_disk_stamp_to_time(struct timespec *dest, struct timestamp src)
+struct inode_time *
+udf_disk_stamp_to_time(struct inode_time *dest, struct timestamp src)
 {
 	int yday;
 	u16 typeAndTimezone = le16_to_cpu(src.typeAndTimezone);
@@ -119,7 +120,7 @@ udf_disk_stamp_to_time(struct timespec *dest, struct timestamp src)
 }
 
 struct timestamp *
-udf_time_to_disk_stamp(struct timestamp *dest, struct timespec ts)
+udf_time_to_disk_stamp(struct timestamp *dest, struct inode_time ts)
 {
 	long int days, rem, y;
 	const unsigned short int *ip;
-- 
1.8.3.2

