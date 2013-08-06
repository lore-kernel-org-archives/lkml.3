Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab3HFHas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 03:30:48 -0400
Received: from intranet.asianux.com ([58.214.24.6]:4796 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab3HFHaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 03:30:46 -0400
X-Spam-Score: -100.8
Message-ID: <5200A5E6.9020803@asianux.com>
Date: Tue, 06 Aug 2013 15:29:42 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>, xi.wang@gmail.com,
        nicolas.dichtel@6wind.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/sysctl_binary.c: improve the usage of return value
 'result'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the usage of return value 'result', so not only can make code
clearer to readers, but also can improve the performance.

Assign the return error code only when error occurs, so can save some
instructions (some of them are inside looping).

Rewrite the sysctl_getname() to make code clearer to readers, and also
can save some instructions (it is mainly related with the usage of the
variable 'result').

Remove useless variable 'result' for sysctl() and compat sysctl(), when
do_sysctl() fails, it is meaningless to assign 'oldlenp ' with original
same value.

Also modify the related code to pass "./scripts/checkpatch.pl" checking.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/sysctl_binary.c |  142 ++++++++++++++++++++++++------------------------
 1 files changed, 72 insertions(+), 70 deletions(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index b609213..26d7fc0 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -941,15 +941,17 @@ static ssize_t bin_string(struct file *file,
 		copied = result;
 		lastp = oldval + copied - 1;
 
-		result = -EFAULT;
-		if (get_user(ch, lastp))
+		if (get_user(ch, lastp)) {
+			result = -EFAULT;
 			goto out;
+		}
 
 		/* Trim off the trailing newline */
 		if (ch == '\n') {
-			result = -EFAULT;
-			if (put_user('\0', lastp))
+			if (put_user('\0', lastp)) {
+				result = -EFAULT;
 				goto out;
+			}
 			copied -= 1;
 		}
 	}
@@ -974,10 +976,11 @@ static ssize_t bin_intvec(struct file *file,
 	char *buffer;
 	ssize_t result;
 
-	result = -ENOMEM;
 	buffer = kmalloc(BUFSZ, GFP_KERNEL);
-	if (!buffer)
+	if (!buffer) {
+		result = -ENOMEM;
 		goto out;
+	}
 
 	if (oldval && oldlen) {
 		unsigned __user *vec = oldval;
@@ -999,9 +1002,10 @@ static ssize_t bin_intvec(struct file *file,
 			while (isspace(*str))
 				str++;
 			
-			result = -EFAULT;
-			if (put_user(value, vec + i))
+			if (put_user(value, vec + i)) {
+				result = -EFAULT;
 				goto out_kfree;
+			}
 
 			copied += sizeof(*vec);
 			if (!isdigit(*str))
@@ -1020,10 +1024,10 @@ static ssize_t bin_intvec(struct file *file,
 		for (i = 0; i < length; i++) {
 			unsigned long value;
 
-			result = -EFAULT;
-			if (get_user(value, vec + i))
+			if (get_user(value, vec + i)) {
+				result = -EFAULT;
 				goto out_kfree;
-
+			}
 			str += snprintf(str, end - str, "%lu\t", value);
 		}
 
@@ -1045,10 +1049,11 @@ static ssize_t bin_ulongvec(struct file *file,
 	char *buffer;
 	ssize_t result;
 
-	result = -ENOMEM;
 	buffer = kmalloc(BUFSZ, GFP_KERNEL);
-	if (!buffer)
+	if (!buffer) {
+		result = -ENOMEM;
 		goto out;
+	}
 
 	if (oldval && oldlen) {
 		unsigned long __user *vec = oldval;
@@ -1070,9 +1075,10 @@ static ssize_t bin_ulongvec(struct file *file,
 			while (isspace(*str))
 				str++;
 			
-			result = -EFAULT;
-			if (put_user(value, vec + i))
+			if (put_user(value, vec + i)) {
+				result = -EFAULT;
 				goto out_kfree;
+			}
 
 			copied += sizeof(*vec);
 			if (!isdigit(*str))
@@ -1091,10 +1097,10 @@ static ssize_t bin_ulongvec(struct file *file,
 		for (i = 0; i < length; i++) {
 			unsigned long value;
 
-			result = -EFAULT;
-			if (get_user(value, vec + i))
+			if (get_user(value, vec + i)) {
+				result = -EFAULT;
 				goto out_kfree;
-
+			}
 			str += snprintf(str, end - str, "%lu\t", value);
 		}
 
@@ -1128,10 +1134,10 @@ static ssize_t bin_uuid(struct file *file,
 
 		/* Convert the uuid to from a string to binary */
 		for (i = 0; i < 16; i++) {
-			result = -EIO;
-			if (!isxdigit(str[0]) || !isxdigit(str[1]))
+			if (!isxdigit(str[0]) || !isxdigit(str[1])) {
+				result = -EIO;
 				goto out;
-
+			}
 			uuid[i] = (hex_to_bin(str[0]) << 4) |
 					hex_to_bin(str[1]);
 			str += 2;
@@ -1142,10 +1148,10 @@ static ssize_t bin_uuid(struct file *file,
 		if (oldlen > 16)
 			oldlen = 16;
 
-		result = -EFAULT;
-		if (copy_to_user(oldval, uuid, oldlen))
+		if (copy_to_user(oldval, uuid, oldlen)) {
+			result = -EFAULT;
 			goto out;
-
+		}
 		copied = oldlen;
 	}
 	result = copied;
@@ -1170,25 +1176,25 @@ static ssize_t bin_dn_node_address(struct file *file,
 		buf[result] = '\0';
 
 		/* Convert the decnet address to binary */
-		result = -EIO;
 		nodep = strchr(buf, '.');
-		if (!nodep)
+		if (!nodep) {
+			result = -EIO;
 			goto out;
+		}
 		++nodep;
 
 		area = simple_strtoul(buf, NULL, 10);
 		node = simple_strtoul(nodep, NULL, 10);
-
-		result = -EIO;
-		if ((area > 63)||(node > 1023))
+		if ((area > 63) || (node > 1023)) {
+			result = -EIO;
 			goto out;
-
+		}
 		dnaddr = cpu_to_le16((area << 10) | node);
 
-		result = -EFAULT;
-		if (put_user(dnaddr, (__le16 __user *)oldval))
+		if (put_user(dnaddr, (__le16 __user *)oldval)) {
+			result = -EFAULT;
 			goto out;
-
+		}
 		copied = sizeof(dnaddr);
 	}
 
@@ -1197,14 +1203,14 @@ static ssize_t bin_dn_node_address(struct file *file,
 		char buf[15];
 		int len;
 
-		result = -EINVAL;
-		if (newlen != sizeof(dnaddr))
+		if (newlen != sizeof(dnaddr)) {
+			result = -EINVAL;
 			goto out;
-
-		result = -EFAULT;
-		if (get_user(dnaddr, (__le16 __user *)newval))
+		}
+		if (get_user(dnaddr, (__le16 __user *)newval)) {
+			result = -EFAULT;
 			goto out;
-
+		}
 		len = snprintf(buf, sizeof(buf), "%hu.%hu",
 				le16_to_cpu(dnaddr) >> 10,
 				le16_to_cpu(dnaddr) & 0x3ff);
@@ -1276,19 +1282,20 @@ repeat:
 
 static char *sysctl_getname(const int *name, int nlen, const struct bin_table **tablep)
 {
-	char *tmp, *result;
-
-	result = ERR_PTR(-ENOMEM);
-	tmp = __getname();
-	if (tmp) {
-		const struct bin_table *table = get_sysctl(name, nlen, tmp);
-		result = tmp;
-		*tablep = table;
-		if (IS_ERR(table)) {
-			__putname(tmp);
-			result = ERR_CAST(table);
-		}
+	char *result;
+	const struct bin_table *table;
+
+	result = __getname();
+	if (!result)
+		return ERR_PTR(-ENOMEM);
+
+	table = get_sysctl(name, nlen, result);
+	if (IS_ERR(table)) {
+		__putname(result);
+		return ERR_CAST(table);
 	}
+	*tablep = table;
+
 	return result;
 }
 
@@ -1303,9 +1310,10 @@ static ssize_t binary_sysctl(const int *name, int nlen,
 	int flags;
 
 	pathname = sysctl_getname(name, nlen, &table);
-	result = PTR_ERR(pathname);
-	if (IS_ERR(pathname))
+	if (IS_ERR(pathname)) {
+		result = PTR_ERR(pathname);
 		goto out;
+	}
 
 	/* How should the sysctl be accessed? */
 	if (oldval && oldlen && newval && newlen) {
@@ -1321,10 +1329,10 @@ static ssize_t binary_sysctl(const int *name, int nlen,
 
 	mnt = task_active_pid_ns(current)->proc_mnt;
 	file = file_open_root(mnt->mnt_root, mnt, pathname, flags);
-	result = PTR_ERR(file);
-	if (IS_ERR(file))
+	if (IS_ERR(file)) {
+		result = PTR_ERR(file);
 		goto out_putname;
-
+	}
 	result = table->convert(file, oldval, oldlen, newval, newlen);
 
 	fput(file);
@@ -1420,7 +1428,6 @@ SYSCALL_DEFINE1(sysctl, struct __sysctl_args __user *, args)
 {
 	struct __sysctl_args tmp;
 	size_t oldlen = 0;
-	ssize_t result;
 
 	if (copy_from_user(&tmp, args, sizeof(tmp)))
 		return -EFAULT;
@@ -1431,18 +1438,16 @@ SYSCALL_DEFINE1(sysctl, struct __sysctl_args __user *, args)
 	if (tmp.oldlenp && get_user(oldlen, tmp.oldlenp))
 		return -EFAULT;
 
-	result = do_sysctl(tmp.name, tmp.nlen, tmp.oldval, oldlen,
+	oldlen = do_sysctl(tmp.name, tmp.nlen, tmp.oldval, oldlen,
 			   tmp.newval, tmp.newlen);
 
-	if (result >= 0) {
-		oldlen = result;
-		result = 0;
-	}
+	if ((ssize_t)oldlen < 0)
+		return (ssize_t)oldlen;
 
 	if (tmp.oldlenp && put_user(oldlen, tmp.oldlenp))
 		return -EFAULT;
 
-	return result;
+	return 0;
 }
 
 
@@ -1463,7 +1468,6 @@ COMPAT_SYSCALL_DEFINE1(sysctl, struct compat_sysctl_args __user *, args)
 	struct compat_sysctl_args tmp;
 	compat_size_t __user *compat_oldlenp;
 	size_t oldlen = 0;
-	ssize_t result;
 
 	if (copy_from_user(&tmp, args, sizeof(tmp)))
 		return -EFAULT;
@@ -1475,19 +1479,17 @@ COMPAT_SYSCALL_DEFINE1(sysctl, struct compat_sysctl_args __user *, args)
 	if (compat_oldlenp && get_user(oldlen, compat_oldlenp))
 		return -EFAULT;
 
-	result = do_sysctl(compat_ptr(tmp.name), tmp.nlen,
+	oldlen = do_sysctl(compat_ptr(tmp.name), tmp.nlen,
 			   compat_ptr(tmp.oldval), oldlen,
 			   compat_ptr(tmp.newval), tmp.newlen);
 
-	if (result >= 0) {
-		oldlen = result;
-		result = 0;
-	}
+	if ((ssize_t)oldlen < 0)
+		return (ssize_t)oldlen;
 
 	if (compat_oldlenp && put_user(oldlen, compat_oldlenp))
 		return -EFAULT;
 
-	return result;
+	return 0;
 }
 
 #endif /* CONFIG_COMPAT */
-- 
1.7.7.6

