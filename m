Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab3HTFZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 01:25:43 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:62074 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3HTFZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 01:25:41 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: getarunks@gmail.com
Date: Tue, 20 Aug 2013 10:55:40 +0530
X-Google-Sender-Auth: iHJBDKAcFDbDLCVV8GmLIiIkyn0
Message-ID: <CAKZGPANQz5-uyf=uSp_0HxBq1_uH053H0XOohpAaWsbeoy7zhw@mail.gmail.com>
Subject: [PATCH v1] seq_file: Fix overflow condition in seq_commit
From: Arun KS <arunks.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, Matthew Wilcox <matthew@wil.cx>,
        Bruce Fields <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, vinayak menon <vinayakm.list@gmail.com>,
        Nagachandra P <nagachandra@gmail.com>, Vikram MP <mp.vikram@gmail.com>
Content-Type: multipart/mixed; boundary=047d7b343f1aa22de604e45a4906
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b343f1aa22de604e45a4906
Content-Type: text/plain; charset=ISO-8859-1

>From 932a134abeac597f18c86c513704709ad154994b Mon Sep 17 00:00:00 2001
From: Arun KS <arun.ks@broadcom.com>
Date: Mon, 19 Aug 2013 12:06:33 +0530
Subject: seq_file: Fix overflow condition in seq_commit

seq_path()/seq_commit() is treating a d_path() failure as an overflow
condition, but it isn't.

seq_read handles overflow by reallocating more buffer. And this
continues in a loop utill we increase the size of seq buf beyond
KMALLOC_MAX_SIZE and hence a WARN_ON.

[  363.192565] ------------[ cut here ]------------
[  363.199462] WARNING: at mm/slab_common.c:377 kmalloc_slab+0x34/0x9c()
[  363.208557] Modules linked in:
[  363.212219] CPU: 1 PID: 1742 Comm: Binder_2 Tainted: G        W3.10.0+ #17
[  363.222930] [<c00151c4>] (unwind_backtrace+0x0/0x11c)
from[<c0011a24>] (show_stack+0x10/0x14)
[  363.235229] [<c0011a24>] (show_stack+0x10/0x14) from
[<c0059fb0>](warn_slowpath_common+0x4c/0x68)
[  363.247253] [<c0059fb0>] (warn_slowpath_common+0x4c/0x68)
from[<c0059fe4>] (warn_slowpath_null+0x18/0x1c)
[  363.259307] [<c0059fe4>] (warn_slowpath_null+0x18/0x1c)
from[<c00fa400>] (kmalloc_slab+0x34/0x9c)
[  363.270812] [<c00fa400>] (kmalloc_slab+0x34/0x9c) from
[<c010ec20>](__kmalloc+0x14/0x1fc)
[  363.281433] [<c010ec20>] (__kmalloc+0x14/0x1fc) from
[<c012ef70>](seq_read+0x24c/0x438)
[  363.291992] [<c012ef70>] (seq_read+0x24c/0x438) from
[<c011389c>](vfs_read+0xac/0x124)
[  363.302398] [<c011389c>] (vfs_read+0xac/0x124) from
[<c0113a38>](SyS_read+0x3c/0x60)
[  363.312591] [<c0113a38>] (SyS_read+0x3c/0x60) from
[<c000e180>](ret_fast_syscall+0x0/0x48)
[  363.323303] ---[ end trace 46c6467e2db7bcd4 ]---

Pass -ENOBUFS to seq_commit to signal an overflow condition and a
negative value for all other errors.

Signed-off-by: Arun KS <arun.ks@broadcom.com>
---
 fs/seq_file.c            |  6 +++---
 include/linux/seq_file.h | 12 +++++++-----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 3135c25..6a33f9c 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -463,7 +463,7 @@ int seq_path(struct seq_file *m, const struct path
*path, const char *esc)
 {
  char *buf;
  size_t size = seq_get_buf(m, &buf);
- int res = -1;
+ int res = -ENOBUFS;

  if (size) {
  char *p = d_path(path, buf, size);
@@ -487,7 +487,7 @@ int seq_path_root(struct seq_file *m, const struct
path *path,
 {
  char *buf;
  size_t size = seq_get_buf(m, &buf);
- int res = -ENAMETOOLONG;
+ int res = -ENOBUFS;

  if (size) {
  char *p;
@@ -516,7 +516,7 @@ int seq_dentry(struct seq_file *m, struct dentry
*dentry, const char *esc)
 {
  char *buf;
  size_t size = seq_get_buf(m, &buf);
- int res = -1;
+ int res = -ENOBUFS;

  if (size) {
  char *p = dentry_path(dentry, buf, size);
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 4e32edc..43f51a0 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -7,6 +7,7 @@
 #include <linux/mutex.h>
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
+#include <linux/errno.h>

 struct seq_operations;
 struct file;
@@ -66,16 +67,17 @@ static inline size_t seq_get_buf(struct seq_file
*m, char **bufp)
  * @num: the number of bytes to commit
  *
  * Commit @num bytes of data written to a buffer previously acquired
- * by seq_buf_get.  To signal an error condition, or that the data
- * didn't fit in the available space, pass a negative @num value.
+ * by seq_buf_get.  To signal an overflow condition(data didn't fit
+ * in the available space), pass -ENOBUFS and for other errors pass a
+ * negative @num value.
  */
 static inline void seq_commit(struct seq_file *m, int num)
 {
- if (num < 0) {
- m->count = m->size;
- } else {
+ if (num >= 0) {
  BUG_ON(m->count + num > m->size);
  m->count += num;
+ } else if (num == -ENOBUFS)
+ m->count = m->size;
  }
 }

-- 
1.8.2

--047d7b343f1aa22de604e45a4906
Content-Type: application/octet-stream; 
	name="0001-seq_file-Fix-overflow-condition-in-seq_commit.patch"
Content-Disposition: attachment; 
	filename="0001-seq_file-Fix-overflow-condition-in-seq_commit.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkko52f40

RnJvbSA5MzJhMTM0YWJlYWM1OTdmMThjODZjNTEzNzA0NzA5YWQxNTQ5OTRiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBcnVuIEtTIDxhcnVuLmtzQGJyb2FkY29tLmNvbT4KRGF0ZTog
TW9uLCAxOSBBdWcgMjAxMyAxMjowNjozMyArMDUzMApTdWJqZWN0OiBzZXFfZmlsZTogRml4IG92
ZXJmbG93IGNvbmRpdGlvbiBpbiBzZXFfY29tbWl0CgpzZXFfcGF0aCgpL3NlcV9jb21taXQoKSBp
cyB0cmVhdGluZyBhIGRfcGF0aCgpIGZhaWx1cmUgYXMgYW4gb3ZlcmZsb3cKY29uZGl0aW9uLCBi
dXQgaXQgaXNuJ3QuCgpzZXFfcmVhZCBoYW5kbGVzIG92ZXJmbG93IGJ5IHJlYWxsb2NhdGluZyBt
b3JlIGJ1ZmZlci4gQW5kIHRoaXMKY29udGludWVzIGluIGEgbG9vcCB1dGlsbCB3ZSBpbmNyZWFz
ZSB0aGUgc2l6ZSBvZiBzZXEgYnVmIGJleW9uZApLTUFMTE9DX01BWF9TSVpFIGFuZCBoZW5jZSBh
IFdBUk5fT04uCgpbICAzNjMuMTkyNTY1XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0t
LS0tLS0KWyAgMzYzLjE5OTQ2Ml0gV0FSTklORzogYXQgbW0vc2xhYl9jb21tb24uYzozNzcga21h
bGxvY19zbGFiKzB4MzQvMHg5YygpClsgIDM2My4yMDg1NTddIE1vZHVsZXMgbGlua2VkIGluOgpb
ICAzNjMuMjEyMjE5XSBDUFU6IDEgUElEOiAxNzQyIENvbW06IEJpbmRlcl8yIFRhaW50ZWQ6IEcg
ICAgICAgIFczLjEwLjArICMxNwpbICAzNjMuMjIyOTMwXSBbPGMwMDE1MWM0Pl0gKHVud2luZF9i
YWNrdHJhY2UrMHgwLzB4MTFjKSBmcm9tWzxjMDAxMWEyND5dIChzaG93X3N0YWNrKzB4MTAvMHgx
NCkKWyAgMzYzLjIzNTIyOV0gWzxjMDAxMWEyND5dIChzaG93X3N0YWNrKzB4MTAvMHgxNCkgZnJv
bSBbPGMwMDU5ZmIwPl0od2Fybl9zbG93cGF0aF9jb21tb24rMHg0Yy8weDY4KQpbICAzNjMuMjQ3
MjUzXSBbPGMwMDU5ZmIwPl0gKHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NGMvMHg2OCkgZnJvbVs8
YzAwNTlmZTQ+XSAod2Fybl9zbG93cGF0aF9udWxsKzB4MTgvMHgxYykKWyAgMzYzLjI1OTMwN10g
WzxjMDA1OWZlND5dICh3YXJuX3Nsb3dwYXRoX251bGwrMHgxOC8weDFjKSBmcm9tWzxjMDBmYTQw
MD5dIChrbWFsbG9jX3NsYWIrMHgzNC8weDljKQpbICAzNjMuMjcwODEyXSBbPGMwMGZhNDAwPl0g
KGttYWxsb2Nfc2xhYisweDM0LzB4OWMpIGZyb20gWzxjMDEwZWMyMD5dKF9fa21hbGxvYysweDE0
LzB4MWZjKQpbICAzNjMuMjgxNDMzXSBbPGMwMTBlYzIwPl0gKF9fa21hbGxvYysweDE0LzB4MWZj
KSBmcm9tIFs8YzAxMmVmNzA+XShzZXFfcmVhZCsweDI0Yy8weDQzOCkKWyAgMzYzLjI5MTk5Ml0g
WzxjMDEyZWY3MD5dIChzZXFfcmVhZCsweDI0Yy8weDQzOCkgZnJvbSBbPGMwMTEzODljPl0odmZz
X3JlYWQrMHhhYy8weDEyNCkKWyAgMzYzLjMwMjM5OF0gWzxjMDExMzg5Yz5dICh2ZnNfcmVhZCsw
eGFjLzB4MTI0KSBmcm9tIFs8YzAxMTNhMzg+XShTeVNfcmVhZCsweDNjLzB4NjApClsgIDM2My4z
MTI1OTFdIFs8YzAxMTNhMzg+XSAoU3lTX3JlYWQrMHgzYy8weDYwKSBmcm9tIFs8YzAwMGUxODA+
XShyZXRfZmFzdF9zeXNjYWxsKzB4MC8weDQ4KQpbICAzNjMuMzIzMzAzXSAtLS1bIGVuZCB0cmFj
ZSA0NmM2NDY3ZTJkYjdiY2Q0IF0tLS0KClBhc3MgLUVOT0JVRlMgdG8gc2VxX2NvbW1pdCB0byBz
aWduYWwgYW4gb3ZlcmZsb3cgY29uZGl0aW9uIGFuZCBhCm5lZ2F0aXZlIHZhbHVlIGZvciBhbGwg
b3RoZXIgZXJyb3JzLgoKU2lnbmVkLW9mZi1ieTogQXJ1biBLUyA8YXJ1bi5rc0Bicm9hZGNvbS5j
b20+Ci0tLQogZnMvc2VxX2ZpbGUuYyAgICAgICAgICAgIHwgIDYgKysrLS0tCiBpbmNsdWRlL2xp
bnV4L3NlcV9maWxlLmggfCAxMiArKysrKysrLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTAgaW5z
ZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zZXFfZmlsZS5jIGIv
ZnMvc2VxX2ZpbGUuYwppbmRleCAzMTM1YzI1Li42YTMzZjljIDEwMDY0NAotLS0gYS9mcy9zZXFf
ZmlsZS5jCisrKyBiL2ZzL3NlcV9maWxlLmMKQEAgLTQ2Myw3ICs0NjMsNyBAQCBpbnQgc2VxX3Bh
dGgoc3RydWN0IHNlcV9maWxlICptLCBjb25zdCBzdHJ1Y3QgcGF0aCAqcGF0aCwgY29uc3QgY2hh
ciAqZXNjKQogewogCWNoYXIgKmJ1ZjsKIAlzaXplX3Qgc2l6ZSA9IHNlcV9nZXRfYnVmKG0sICZi
dWYpOwotCWludCByZXMgPSAtMTsKKwlpbnQgcmVzID0gLUVOT0JVRlM7CiAKIAlpZiAoc2l6ZSkg
ewogCQljaGFyICpwID0gZF9wYXRoKHBhdGgsIGJ1Ziwgc2l6ZSk7CkBAIC00ODcsNyArNDg3LDcg
QEAgaW50IHNlcV9wYXRoX3Jvb3Qoc3RydWN0IHNlcV9maWxlICptLCBjb25zdCBzdHJ1Y3QgcGF0
aCAqcGF0aCwKIHsKIAljaGFyICpidWY7CiAJc2l6ZV90IHNpemUgPSBzZXFfZ2V0X2J1ZihtLCAm
YnVmKTsKLQlpbnQgcmVzID0gLUVOQU1FVE9PTE9ORzsKKwlpbnQgcmVzID0gLUVOT0JVRlM7CiAK
IAlpZiAoc2l6ZSkgewogCQljaGFyICpwOwpAQCAtNTE2LDcgKzUxNiw3IEBAIGludCBzZXFfZGVu
dHJ5KHN0cnVjdCBzZXFfZmlsZSAqbSwgc3RydWN0IGRlbnRyeSAqZGVudHJ5LCBjb25zdCBjaGFy
ICplc2MpCiB7CiAJY2hhciAqYnVmOwogCXNpemVfdCBzaXplID0gc2VxX2dldF9idWYobSwgJmJ1
Zik7Ci0JaW50IHJlcyA9IC0xOworCWludCByZXMgPSAtRU5PQlVGUzsKIAogCWlmIChzaXplKSB7
CiAJCWNoYXIgKnAgPSBkZW50cnlfcGF0aChkZW50cnksIGJ1Ziwgc2l6ZSk7CmRpZmYgLS1naXQg
YS9pbmNsdWRlL2xpbnV4L3NlcV9maWxlLmggYi9pbmNsdWRlL2xpbnV4L3NlcV9maWxlLmgKaW5k
ZXggNGUzMmVkYy4uNDNmNTFhMCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9zZXFfZmlsZS5o
CisrKyBiL2luY2x1ZGUvbGludXgvc2VxX2ZpbGUuaApAQCAtNyw2ICs3LDcgQEAKICNpbmNsdWRl
IDxsaW51eC9tdXRleC5oPgogI2luY2x1ZGUgPGxpbnV4L2NwdW1hc2suaD4KICNpbmNsdWRlIDxs
aW51eC9ub2RlbWFzay5oPgorI2luY2x1ZGUgPGxpbnV4L2Vycm5vLmg+CiAKIHN0cnVjdCBzZXFf
b3BlcmF0aW9uczsKIHN0cnVjdCBmaWxlOwpAQCAtNjYsMTYgKzY3LDE3IEBAIHN0YXRpYyBpbmxp
bmUgc2l6ZV90IHNlcV9nZXRfYnVmKHN0cnVjdCBzZXFfZmlsZSAqbSwgY2hhciAqKmJ1ZnApCiAg
KiBAbnVtOiB0aGUgbnVtYmVyIG9mIGJ5dGVzIHRvIGNvbW1pdAogICoKICAqIENvbW1pdCBAbnVt
IGJ5dGVzIG9mIGRhdGEgd3JpdHRlbiB0byBhIGJ1ZmZlciBwcmV2aW91c2x5IGFjcXVpcmVkCi0g
KiBieSBzZXFfYnVmX2dldC4gIFRvIHNpZ25hbCBhbiBlcnJvciBjb25kaXRpb24sIG9yIHRoYXQg
dGhlIGRhdGEKLSAqIGRpZG4ndCBmaXQgaW4gdGhlIGF2YWlsYWJsZSBzcGFjZSwgcGFzcyBhIG5l
Z2F0aXZlIEBudW0gdmFsdWUuCisgKiBieSBzZXFfYnVmX2dldC4gIFRvIHNpZ25hbCBhbiBvdmVy
ZmxvdyBjb25kaXRpb24oZGF0YSBkaWRuJ3QgZml0CisgKiBpbiB0aGUgYXZhaWxhYmxlIHNwYWNl
KSwgcGFzcyAtRU5PQlVGUyBhbmQgZm9yIG90aGVyIGVycm9ycyBwYXNzIGEKKyAqIG5lZ2F0aXZl
IEBudW0gdmFsdWUuCiAgKi8KIHN0YXRpYyBpbmxpbmUgdm9pZCBzZXFfY29tbWl0KHN0cnVjdCBz
ZXFfZmlsZSAqbSwgaW50IG51bSkKIHsKLQlpZiAobnVtIDwgMCkgewotCQltLT5jb3VudCA9IG0t
PnNpemU7Ci0JfSBlbHNlIHsKKwlpZiAobnVtID49IDApIHsKIAkJQlVHX09OKG0tPmNvdW50ICsg
bnVtID4gbS0+c2l6ZSk7CiAJCW0tPmNvdW50ICs9IG51bTsKKwl9IGVsc2UgaWYgKG51bSA9PSAt
RU5PQlVGUykKKwkJbS0+Y291bnQgPSBtLT5zaXplOwogCX0KIH0KIAotLSAKMS44LjIKCg==
--047d7b343f1aa22de604e45a4906--
