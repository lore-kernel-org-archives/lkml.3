Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751080Ab3HSGzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 02:55:07 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:38865 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3HSGzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 02:55:05 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: getarunks@gmail.com
Date: Mon, 19 Aug 2013 12:25:04 +0530
X-Google-Sender-Auth: LGT3N01yi3lb0a_SVoFt8CsxQxI
Message-ID: <CAKZGPANS-NVTy7p69xcrgK3ggUHAtLi2ad8UgwsYdeEHbj3gMw@mail.gmail.com>
Subject: [PATCH] SeqFile: Fix overflow condition
From: Arun KS <arunks.linux@gmail.com>
To: viro@zeniv.linux.org.uk, Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Bruce Fields <bfields@fieldses.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        vinayak menon <vinayakm.list@gmail.com>,
        Nagachandra P <nagachandra@gmail.com>, Vikram MP <mp.vikram@gmail.com>
Content-Type: multipart/mixed; boundary=089e013d061683119f04e4476bad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e013d061683119f04e4476bad
Content-Type: text/plain; charset=ISO-8859-1

>From 23986a85b9efe7bc3ffc0887b8d17cdf2fbab4f2 Mon Sep 17 00:00:00 2001
From: Arun KS <arun.ks@broadcom.com>
Date: Mon, 19 Aug 2013 12:06:33 +0530
Subject: SeqFile: Fix overflow condition

seq_path()/seq_commit() is treating a d_path() failure as an overflow
condition, but it isn't.

Signed-off-by: Arun KS <arun.ks@broadcom.com>
---
 fs/seq_file.c            |  6 +++---
 include/linux/seq_file.h | 11 ++++++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

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
index 4e32edc..7bfb540 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -66,16 +66,17 @@ static inline size_t seq_get_buf(struct seq_file
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

--089e013d061683119f04e4476bad
Content-Type: application/octet-stream; 
	name="0001-SeqFile-Fix-overflow-condition.patch"
Content-Disposition: attachment; 
	filename="0001-SeqFile-Fix-overflow-condition.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkjbtkli0

RnJvbSAyMzk4NmE4NWI5ZWZlN2JjM2ZmYzA4ODdiOGQxN2NkZjJmYmFiNGYyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBcnVuIEtTIDxhcnVuLmtzQGJyb2FkY29tLmNvbT4KRGF0ZTog
TW9uLCAxOSBBdWcgMjAxMyAxMjowNjozMyArMDUzMApTdWJqZWN0OiBTZXFGaWxlOiBGaXggb3Zl
cmZsb3cgY29uZGl0aW9uCgpzZXFfcGF0aCgpL3NlcV9jb21taXQoKSBpcyB0cmVhdGluZyBhIGRf
cGF0aCgpIGZhaWx1cmUgYXMgYW4gb3ZlcmZsb3cKY29uZGl0aW9uLCBidXQgaXQgaXNuJ3QuCgpT
aWduZWQtb2ZmLWJ5OiBBcnVuIEtTIDxhcnVuLmtzQGJyb2FkY29tLmNvbT4KLS0tCiBmcy9zZXFf
ZmlsZS5jICAgICAgICAgICAgfCAgNiArKystLS0KIGluY2x1ZGUvbGludXgvc2VxX2ZpbGUuaCB8
IDExICsrKysrKy0tLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgOCBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zZXFfZmlsZS5jIGIvZnMvc2VxX2ZpbGUuYwppbmRl
eCAzMTM1YzI1Li42YTMzZjljIDEwMDY0NAotLS0gYS9mcy9zZXFfZmlsZS5jCisrKyBiL2ZzL3Nl
cV9maWxlLmMKQEAgLTQ2Myw3ICs0NjMsNyBAQCBpbnQgc2VxX3BhdGgoc3RydWN0IHNlcV9maWxl
ICptLCBjb25zdCBzdHJ1Y3QgcGF0aCAqcGF0aCwgY29uc3QgY2hhciAqZXNjKQogewogCWNoYXIg
KmJ1ZjsKIAlzaXplX3Qgc2l6ZSA9IHNlcV9nZXRfYnVmKG0sICZidWYpOwotCWludCByZXMgPSAt
MTsKKwlpbnQgcmVzID0gLUVOT0JVRlM7CiAKIAlpZiAoc2l6ZSkgewogCQljaGFyICpwID0gZF9w
YXRoKHBhdGgsIGJ1Ziwgc2l6ZSk7CkBAIC00ODcsNyArNDg3LDcgQEAgaW50IHNlcV9wYXRoX3Jv
b3Qoc3RydWN0IHNlcV9maWxlICptLCBjb25zdCBzdHJ1Y3QgcGF0aCAqcGF0aCwKIHsKIAljaGFy
ICpidWY7CiAJc2l6ZV90IHNpemUgPSBzZXFfZ2V0X2J1ZihtLCAmYnVmKTsKLQlpbnQgcmVzID0g
LUVOQU1FVE9PTE9ORzsKKwlpbnQgcmVzID0gLUVOT0JVRlM7CiAKIAlpZiAoc2l6ZSkgewogCQlj
aGFyICpwOwpAQCAtNTE2LDcgKzUxNiw3IEBAIGludCBzZXFfZGVudHJ5KHN0cnVjdCBzZXFfZmls
ZSAqbSwgc3RydWN0IGRlbnRyeSAqZGVudHJ5LCBjb25zdCBjaGFyICplc2MpCiB7CiAJY2hhciAq
YnVmOwogCXNpemVfdCBzaXplID0gc2VxX2dldF9idWYobSwgJmJ1Zik7Ci0JaW50IHJlcyA9IC0x
OworCWludCByZXMgPSAtRU5PQlVGUzsKIAogCWlmIChzaXplKSB7CiAJCWNoYXIgKnAgPSBkZW50
cnlfcGF0aChkZW50cnksIGJ1Ziwgc2l6ZSk7CmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3Nl
cV9maWxlLmggYi9pbmNsdWRlL2xpbnV4L3NlcV9maWxlLmgKaW5kZXggNGUzMmVkYy4uN2JmYjU0
MCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9zZXFfZmlsZS5oCisrKyBiL2luY2x1ZGUvbGlu
dXgvc2VxX2ZpbGUuaApAQCAtNjYsMTYgKzY2LDE3IEBAIHN0YXRpYyBpbmxpbmUgc2l6ZV90IHNl
cV9nZXRfYnVmKHN0cnVjdCBzZXFfZmlsZSAqbSwgY2hhciAqKmJ1ZnApCiAgKiBAbnVtOiB0aGUg
bnVtYmVyIG9mIGJ5dGVzIHRvIGNvbW1pdAogICoKICAqIENvbW1pdCBAbnVtIGJ5dGVzIG9mIGRh
dGEgd3JpdHRlbiB0byBhIGJ1ZmZlciBwcmV2aW91c2x5IGFjcXVpcmVkCi0gKiBieSBzZXFfYnVm
X2dldC4gIFRvIHNpZ25hbCBhbiBlcnJvciBjb25kaXRpb24sIG9yIHRoYXQgdGhlIGRhdGEKLSAq
IGRpZG4ndCBmaXQgaW4gdGhlIGF2YWlsYWJsZSBzcGFjZSwgcGFzcyBhIG5lZ2F0aXZlIEBudW0g
dmFsdWUuCisgKiBieSBzZXFfYnVmX2dldC4gIFRvIHNpZ25hbCBhbiBvdmVyZmxvdyBjb25kaXRp
b24oZGF0YSBkaWRuJ3QgZml0CisgKiBpbiB0aGUgYXZhaWxhYmxlIHNwYWNlKSwgcGFzcyAtRU5P
QlVGUyBhbmQgZm9yIG90aGVyIGVycm9ycyBwYXNzIGEKKyAqIG5lZ2F0aXZlIEBudW0gdmFsdWUu
CiAgKi8KIHN0YXRpYyBpbmxpbmUgdm9pZCBzZXFfY29tbWl0KHN0cnVjdCBzZXFfZmlsZSAqbSwg
aW50IG51bSkKIHsKLQlpZiAobnVtIDwgMCkgewotCQltLT5jb3VudCA9IG0tPnNpemU7Ci0JfSBl
bHNlIHsKKwlpZiAobnVtID49IDApIHsKIAkJQlVHX09OKG0tPmNvdW50ICsgbnVtID4gbS0+c2l6
ZSk7CiAJCW0tPmNvdW50ICs9IG51bTsKKwl9IGVsc2UgaWYgKG51bSA9PSAtRU5PQlVGUykKKwkJ
bS0+Y291bnQgPSBtLT5zaXplOwogCX0KIH0KIAotLSAKMS44LjIKCg==
--089e013d061683119f04e4476bad--
