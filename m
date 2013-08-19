Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab3HSLcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:32:39 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:64202 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3HSLci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:32:38 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: getarunks@gmail.com
Date: Mon, 19 Aug 2013 17:02:37 +0530
X-Google-Sender-Auth: PR1CC-_KT82LIyGb6s-nB4H8ZTg
Message-ID: <CAKZGPAOwpEcxxZJUbmUVL1J+enXGhFbbvyZ7L3uWDkPbwKnbyQ@mail.gmail.com>
Subject: [PATCH] SeqFile: Fix overflow condition
From: Arun KS <arunks.linux@gmail.com>
To: viro@zeniv.linux.org.uk, Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Bruce Fields <bfields@fieldses.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        vinayak menon <vinayakm.list@gmail.com>,
        Nagachandra P <nagachandra@gmail.com>, Vikram MP <mp.vikram@gmail.com>
Content-Type: multipart/mixed; boundary=089e013a282c2473b204e44b4c53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e013a282c2473b204e44b4c53
Content-Type: text/plain; charset=ISO-8859-1

>From 27f50827e5e81f2a30544b72c1d54c3ee86835cf Mon Sep 17 00:00:00 2001
From: Arun KS <arun.ks@broadcom.com>
Date: Mon, 19 Aug 2013 12:06:33 +0530
Subject: SeqFile: Fix overflow condition

seq_path()/seq_commit() is treating a d_path() failure as an overflow
condition, but it isn't.

Signed-off-by: Arun KS <arun.ks@broadcom.com>
---
 fs/seq_file.c            |    6 +++---
 include/linux/seq_file.h |   12 +++++++-----
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
1.7.6

--089e013a282c2473b204e44b4c53
Content-Type: application/octet-stream; 
	name="0001-SeqFile-Fix-overflow-condition.patch"
Content-Disposition: attachment; 
	filename="0001-SeqFile-Fix-overflow-condition.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkjlteop1

RnJvbSAyN2Y1MDgyN2U1ZTgxZjJhMzA1NDRiNzJjMWQ1NGMzZWU4NjgzNWNmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBcnVuIEtTIDxhcnVuLmtzQGJyb2FkY29tLmNvbT4KRGF0ZTog
TW9uLCAxOSBBdWcgMjAxMyAxMjowNjozMyArMDUzMApTdWJqZWN0OiBTZXFGaWxlOiBGaXggb3Zl
cmZsb3cgY29uZGl0aW9uCgpzZXFfcGF0aCgpL3NlcV9jb21taXQoKSBpcyB0cmVhdGluZyBhIGRf
cGF0aCgpIGZhaWx1cmUgYXMgYW4gb3ZlcmZsb3cKY29uZGl0aW9uLCBidXQgaXQgaXNuJ3QuCgpT
aWduZWQtb2ZmLWJ5OiBBcnVuIEtTIDxhcnVuLmtzQGJyb2FkY29tLmNvbT4KLS0tCiBmcy9zZXFf
ZmlsZS5jICAgICAgICAgICAgfCAgICA2ICsrKy0tLQogaW5jbHVkZS9saW51eC9zZXFfZmlsZS5o
IHwgICAxMiArKysrKysrLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwg
OCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zZXFfZmlsZS5jIGIvZnMvc2VxX2ZpbGUu
YwppbmRleCAzMTM1YzI1Li42YTMzZjljIDEwMDY0NAotLS0gYS9mcy9zZXFfZmlsZS5jCisrKyBi
L2ZzL3NlcV9maWxlLmMKQEAgLTQ2Myw3ICs0NjMsNyBAQCBpbnQgc2VxX3BhdGgoc3RydWN0IHNl
cV9maWxlICptLCBjb25zdCBzdHJ1Y3QgcGF0aCAqcGF0aCwgY29uc3QgY2hhciAqZXNjKQogewog
CWNoYXIgKmJ1ZjsKIAlzaXplX3Qgc2l6ZSA9IHNlcV9nZXRfYnVmKG0sICZidWYpOwotCWludCBy
ZXMgPSAtMTsKKwlpbnQgcmVzID0gLUVOT0JVRlM7CiAKIAlpZiAoc2l6ZSkgewogCQljaGFyICpw
ID0gZF9wYXRoKHBhdGgsIGJ1Ziwgc2l6ZSk7CkBAIC00ODcsNyArNDg3LDcgQEAgaW50IHNlcV9w
YXRoX3Jvb3Qoc3RydWN0IHNlcV9maWxlICptLCBjb25zdCBzdHJ1Y3QgcGF0aCAqcGF0aCwKIHsK
IAljaGFyICpidWY7CiAJc2l6ZV90IHNpemUgPSBzZXFfZ2V0X2J1ZihtLCAmYnVmKTsKLQlpbnQg
cmVzID0gLUVOQU1FVE9PTE9ORzsKKwlpbnQgcmVzID0gLUVOT0JVRlM7CiAKIAlpZiAoc2l6ZSkg
ewogCQljaGFyICpwOwpAQCAtNTE2LDcgKzUxNiw3IEBAIGludCBzZXFfZGVudHJ5KHN0cnVjdCBz
ZXFfZmlsZSAqbSwgc3RydWN0IGRlbnRyeSAqZGVudHJ5LCBjb25zdCBjaGFyICplc2MpCiB7CiAJ
Y2hhciAqYnVmOwogCXNpemVfdCBzaXplID0gc2VxX2dldF9idWYobSwgJmJ1Zik7Ci0JaW50IHJl
cyA9IC0xOworCWludCByZXMgPSAtRU5PQlVGUzsKIAogCWlmIChzaXplKSB7CiAJCWNoYXIgKnAg
PSBkZW50cnlfcGF0aChkZW50cnksIGJ1Ziwgc2l6ZSk7CmRpZmYgLS1naXQgYS9pbmNsdWRlL2xp
bnV4L3NlcV9maWxlLmggYi9pbmNsdWRlL2xpbnV4L3NlcV9maWxlLmgKaW5kZXggNGUzMmVkYy4u
NDNmNTFhMCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9zZXFfZmlsZS5oCisrKyBiL2luY2x1
ZGUvbGludXgvc2VxX2ZpbGUuaApAQCAtNyw2ICs3LDcgQEAKICNpbmNsdWRlIDxsaW51eC9tdXRl
eC5oPgogI2luY2x1ZGUgPGxpbnV4L2NwdW1hc2suaD4KICNpbmNsdWRlIDxsaW51eC9ub2RlbWFz
ay5oPgorI2luY2x1ZGUgPGxpbnV4L2Vycm5vLmg+CiAKIHN0cnVjdCBzZXFfb3BlcmF0aW9uczsK
IHN0cnVjdCBmaWxlOwpAQCAtNjYsMTYgKzY3LDE3IEBAIHN0YXRpYyBpbmxpbmUgc2l6ZV90IHNl
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
bS0+Y291bnQgPSBtLT5zaXplOwogCX0KIH0KIAotLSAKMS43LjYKCg==
--089e013a282c2473b204e44b4c53--
