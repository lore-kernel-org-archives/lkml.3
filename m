Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965606Ab3CZP7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:59:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54482 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965643Ab3CZP7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:59:06 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVMukhkriwZUEeZN6XWcogUmGE67WkNYv7mZ7pqdRHM47Q@mail.gmail.com>
References: <1363793126-11510-1-git-send-email-ming.lei@canonical.com>
	<1363793126-11510-2-git-send-email-ming.lei@canonical.com>
	<514A7340.5040409@huawei.com>
	<CACVXFVN7urpLM+Q-3o9=hYQLM=544WTXh+BnSo9fBM+d07oapQ@mail.gmail.com>
	<514A7E72.2090200@huawei.com>
	<CACVXFVMS644BpX7voMHS-xXoRs9-G4y96=ubk_NAj6KDTy1ENQ@mail.gmail.com>
	<514BF0BE.1070907@huawei.com>
	<CACVXFVOAFqVoNP-igJ-WeaJ+rKF-gREcHqspHWOkz4EJ9Gn94w@mail.gmail.com>
	<51514EA9.8080801@huawei.com>
	<CACVXFVPLkaoowZJZdrg3nkm7ymismJ6W=_BzgyroKJOxJYPODA@mail.gmail.com>
	<CACVXFVMukhkriwZUEeZN6XWcogUmGE67WkNYv7mZ7pqdRHM47Q@mail.gmail.com>
Date: Tue, 26 Mar 2013 23:59:03 +0800
Message-ID: <CACVXFVNRuACjqqD56gu98_+p44k5OYm2Zoc59-2bB8Eit8u-qg@mail.gmail.com>
Subject: Re: [PATCH 1/2] sysfs: fix race between readdir and lseek
From: Ming Lei <ming.lei@canonical.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: multipart/mixed; boundary=047d7b3433941dd23004d8d600cd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b3433941dd23004d8d600cd
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Mar 26, 2013 at 10:03 PM, Ming Lei <ming.lei@canonical.com> wrote:
>
> If you mean the test code on link[1], I can't reproduce the
> warning with the two sysfs fix patches in 4 hours's test.
>
> [1], https://patchwork.kernel.org/patch/2160771/

You are right, looks it is not a problem just in theory, and I can
reproduce it now with your test code by the following steps:

- load all modules
- run your test code on the directory of '/sys/module'
- then can observe the use after free after minutes(a bit easier to
add below debug code[1])

Previously, I can't reproduce because I just test on one specific
unused module directory.

[1], debug code
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -280,6 +280,11 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 	 * sd->s_parent won't change beneath us.
 	 */
 	parent_sd = sd->s_parent;
+	if(!(sd->s_flags & SYSFS_FLAG_REMOVED)) {
+		printk("%s-%d sysfs_dirent use after free: %s-%s\n",
+			__func__, __LINE__, parent_sd->s_name, sd->s_name);
+		dump_stack();
+	}


The below patch(also attached) can fix the issue.
--
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 79a0fd2..484f25e 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1022,6 +1022,7 @@ static int sysfs_readdir(struct file * filp,
void * dirent, filldir_t filldir)
 	enum kobj_ns_type type;
 	const void *ns;
 	ino_t ino;
+	loff_t off;

 	type = sysfs_ns_type(parent_sd);
 	ns = sysfs_info(dentry->d_sb)->ns[type];
@@ -1044,6 +1045,7 @@ static int sysfs_readdir(struct file * filp,
void * dirent, filldir_t filldir)
 			return 0;
 	}
 	mutex_lock(&sysfs_mutex);
+	off = filp->f_pos;
 	for (pos = sysfs_dir_pos(ns, parent_sd, filp->f_pos, pos);
 	     pos;
 	     pos = sysfs_dir_next_pos(ns, parent_sd, filp->f_pos, pos)) {
@@ -1055,19 +1057,24 @@ static int sysfs_readdir(struct file * filp,
void * dirent, filldir_t filldir)
 		len = strlen(name);
 		ino = pos->s_ino;
 		type = dt_type(pos);
-		filp->f_pos = pos->s_hash;
+		off = filp->f_pos = pos->s_hash;
 		filp->private_data = sysfs_get(pos);

 		mutex_unlock(&sysfs_mutex);
-		ret = filldir(dirent, name, len, filp->f_pos, ino, type);
+		ret = filldir(dirent, name, len, off, ino, type);
 		mutex_lock(&sysfs_mutex);
 		if (ret < 0)
 			break;
 	}
 	mutex_unlock(&sysfs_mutex);
-	if ((filp->f_pos > 1) && !pos) { /* EOF */
-		filp->f_pos = INT_MAX;
+
+	/* don't reference last entry if its refcount is dropped */
+	if (!pos) {
 		filp->private_data = NULL;
+
+		/* EOF and not changed as 0 or 1 in read/write path */
+		if (off == filp->f_pos && off > 1)
+			filp->f_pos = INT_MAX;
 	}
 	return 0;
 }



Thanks,
--
Ming Lei

--047d7b3433941dd23004d8d600cd
Content-Type: application/octet-stream; name="sysfs-fix-readdir-v5.patch"
Content-Disposition: attachment; filename="sysfs-fix-readdir-v5.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_her8y7eb0

ZGlmZiAtLWdpdCBhL2ZzL3N5c2ZzL2Rpci5jIGIvZnMvc3lzZnMvZGlyLmMKaW5kZXggNzlhMGZk
Mi4uNDg0ZjI1ZSAxMDA2NDQKLS0tIGEvZnMvc3lzZnMvZGlyLmMKKysrIGIvZnMvc3lzZnMvZGly
LmMKQEAgLTEwMjIsNiArMTAyMiw3IEBAIHN0YXRpYyBpbnQgc3lzZnNfcmVhZGRpcihzdHJ1Y3Qg
ZmlsZSAqIGZpbHAsIHZvaWQgKiBkaXJlbnQsIGZpbGxkaXJfdCBmaWxsZGlyKQogCWVudW0ga29i
al9uc190eXBlIHR5cGU7CiAJY29uc3Qgdm9pZCAqbnM7CiAJaW5vX3QgaW5vOworCWxvZmZfdCBv
ZmY7CiAKIAl0eXBlID0gc3lzZnNfbnNfdHlwZShwYXJlbnRfc2QpOwogCW5zID0gc3lzZnNfaW5m
byhkZW50cnktPmRfc2IpLT5uc1t0eXBlXTsKQEAgLTEwNDQsNiArMTA0NSw3IEBAIHN0YXRpYyBp
bnQgc3lzZnNfcmVhZGRpcihzdHJ1Y3QgZmlsZSAqIGZpbHAsIHZvaWQgKiBkaXJlbnQsIGZpbGxk
aXJfdCBmaWxsZGlyKQogCQkJcmV0dXJuIDA7CiAJfQogCW11dGV4X2xvY2soJnN5c2ZzX211dGV4
KTsKKwlvZmYgPSBmaWxwLT5mX3BvczsKIAlmb3IgKHBvcyA9IHN5c2ZzX2Rpcl9wb3MobnMsIHBh
cmVudF9zZCwgZmlscC0+Zl9wb3MsIHBvcyk7CiAJICAgICBwb3M7CiAJICAgICBwb3MgPSBzeXNm
c19kaXJfbmV4dF9wb3MobnMsIHBhcmVudF9zZCwgZmlscC0+Zl9wb3MsIHBvcykpIHsKQEAgLTEw
NTUsMTkgKzEwNTcsMjQgQEAgc3RhdGljIGludCBzeXNmc19yZWFkZGlyKHN0cnVjdCBmaWxlICog
ZmlscCwgdm9pZCAqIGRpcmVudCwgZmlsbGRpcl90IGZpbGxkaXIpCiAJCWxlbiA9IHN0cmxlbihu
YW1lKTsKIAkJaW5vID0gcG9zLT5zX2lubzsKIAkJdHlwZSA9IGR0X3R5cGUocG9zKTsKLQkJZmls
cC0+Zl9wb3MgPSBwb3MtPnNfaGFzaDsKKwkJb2ZmID0gZmlscC0+Zl9wb3MgPSBwb3MtPnNfaGFz
aDsKIAkJZmlscC0+cHJpdmF0ZV9kYXRhID0gc3lzZnNfZ2V0KHBvcyk7CiAKIAkJbXV0ZXhfdW5s
b2NrKCZzeXNmc19tdXRleCk7Ci0JCXJldCA9IGZpbGxkaXIoZGlyZW50LCBuYW1lLCBsZW4sIGZp
bHAtPmZfcG9zLCBpbm8sIHR5cGUpOworCQlyZXQgPSBmaWxsZGlyKGRpcmVudCwgbmFtZSwgbGVu
LCBvZmYsIGlubywgdHlwZSk7CiAJCW11dGV4X2xvY2soJnN5c2ZzX211dGV4KTsKIAkJaWYgKHJl
dCA8IDApCiAJCQlicmVhazsKIAl9CiAJbXV0ZXhfdW5sb2NrKCZzeXNmc19tdXRleCk7Ci0JaWYg
KChmaWxwLT5mX3BvcyA+IDEpICYmICFwb3MpIHsgLyogRU9GICovCi0JCWZpbHAtPmZfcG9zID0g
SU5UX01BWDsKKworCS8qIGRvbid0IHJlZmVyZW5jZSBsYXN0IGVudHJ5IGlmIGl0cyByZWZjb3Vu
dCBpcyBkcm9wcGVkICovCisJaWYgKCFwb3MpIHsKIAkJZmlscC0+cHJpdmF0ZV9kYXRhID0gTlVM
TDsKKworCQkvKiBFT0YgYW5kIG5vdCBjaGFuZ2VkIGFzIDAgb3IgMSBpbiByZWFkL3dyaXRlIHBh
dGggKi8KKwkJaWYgKG9mZiA9PSBmaWxwLT5mX3BvcyAmJiBvZmYgPiAxKQorCQkJZmlscC0+Zl9w
b3MgPSBJTlRfTUFYOwogCX0KIAlyZXR1cm4gMDsKIH0K
--047d7b3433941dd23004d8d600cd--
