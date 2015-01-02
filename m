Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbbABSGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:06:52 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34099 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbbABSGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:06:50 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        James Hogan <james.hogan@imgtec.com>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: parisc: kernel: sys_parisc:  Remove some unused functions
Date: Fri,  2 Jan 2015 19:09:50 +0100
Message-Id: <1420222190-32621-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
parisc_personality() parisc_fallocate() parisc_sync_file_range()
parisc_fadvise64_64() parisc_readahead() parisc_pwrite64() parisc_pread64()
parisc_ftruncate64() parisc_truncate64()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/parisc/kernel/sys_parisc.c |   81 ---------------------------------------
 1 file changed, 81 deletions(-)

diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index e1ffea2..65ab69d 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -283,18 +283,6 @@ asmlinkage unsigned long sys_mmap(unsigned long addr, unsigned long len,
 /* Fucking broken ABI */
 
 #ifdef CONFIG_64BIT
-asmlinkage long parisc_truncate64(const char __user * path,
-					unsigned int high, unsigned int low)
-{
-	return sys_truncate(path, (long)high << 32 | low);
-}
-
-asmlinkage long parisc_ftruncate64(unsigned int fd,
-					unsigned int high, unsigned int low)
-{
-	return sys_ftruncate(fd, (long)high << 32 | low);
-}
-
 /* stubs for the benefit of the syscall_table since truncate64 and truncate 
  * are identical on LP64 */
 asmlinkage long sys_truncate64(const char __user * path, unsigned long length)
@@ -309,62 +297,8 @@ asmlinkage long sys_fcntl64(unsigned int fd, unsigned int cmd, unsigned long arg
 {
 	return sys_fcntl(fd, cmd, arg);
 }
-#else
-
-asmlinkage long parisc_truncate64(const char __user * path,
-					unsigned int high, unsigned int low)
-{
-	return sys_truncate64(path, (loff_t)high << 32 | low);
-}
-
-asmlinkage long parisc_ftruncate64(unsigned int fd,
-					unsigned int high, unsigned int low)
-{
-	return sys_ftruncate64(fd, (loff_t)high << 32 | low);
-}
 #endif
 
-asmlinkage ssize_t parisc_pread64(unsigned int fd, char __user *buf, size_t count,
-					unsigned int high, unsigned int low)
-{
-	return sys_pread64(fd, buf, count, (loff_t)high << 32 | low);
-}
-
-asmlinkage ssize_t parisc_pwrite64(unsigned int fd, const char __user *buf,
-			size_t count, unsigned int high, unsigned int low)
-{
-	return sys_pwrite64(fd, buf, count, (loff_t)high << 32 | low);
-}
-
-asmlinkage ssize_t parisc_readahead(int fd, unsigned int high, unsigned int low,
-		                    size_t count)
-{
-	return sys_readahead(fd, (loff_t)high << 32 | low, count);
-}
-
-asmlinkage long parisc_fadvise64_64(int fd,
-			unsigned int high_off, unsigned int low_off,
-			unsigned int high_len, unsigned int low_len, int advice)
-{
-	return sys_fadvise64_64(fd, (loff_t)high_off << 32 | low_off,
-			(loff_t)high_len << 32 | low_len, advice);
-}
-
-asmlinkage long parisc_sync_file_range(int fd,
-			u32 hi_off, u32 lo_off, u32 hi_nbytes, u32 lo_nbytes,
-			unsigned int flags)
-{
-	return sys_sync_file_range(fd, (loff_t)hi_off << 32 | lo_off,
-			(loff_t)hi_nbytes << 32 | lo_nbytes, flags);
-}
-
-asmlinkage long parisc_fallocate(int fd, int mode, u32 offhi, u32 offlo,
-				u32 lenhi, u32 lenlo)
-{
-        return sys_fallocate(fd, mode, ((u64)offhi << 32) | offlo,
-                             ((u64)lenhi << 32) | lenlo);
-}
-
 asmlinkage unsigned long sys_alloc_hugepages(int key, unsigned long addr, unsigned long len, int prot, int flag)
 {
 	return -ENOMEM;
@@ -374,18 +308,3 @@ asmlinkage int sys_free_hugepages(unsigned long addr)
 {
 	return -EINVAL;
 }
-
-long parisc_personality(unsigned long personality)
-{
-	long err;
-
-	if (personality(current->personality) == PER_LINUX32
-	    && personality(personality) == PER_LINUX)
-		personality = (personality & ~PER_MASK) | PER_LINUX32;
-
-	err = sys_personality(personality);
-	if (personality(err) == PER_LINUX32)
-		err = (err & ~PER_MASK) | PER_LINUX;
-
-	return err;
-}
-- 
1.7.10.4

