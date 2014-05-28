Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaE1Tn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 15:43:27 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:35626 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbaE1TnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 15:43:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140528183954.GA18016@ZenIV.linux.org.uk>
References: <CA+55aFxq-=xyNOLKQhS5kwy5FKZ=Jp2XSRnyZLU9e8neBLk_2A@mail.gmail.com>
	<20140527014054.GR18016@ZenIV.linux.org.uk>
	<20140527031415.GS18016@ZenIV.linux.org.uk>
	<20140527040026.GT18016@ZenIV.linux.org.uk>
	<20140527070409.GA1801@lahna.fi.intel.com>
	<20140528031955.GW18016@ZenIV.linux.org.uk>
	<20140528073751.GB1757@lahna.fi.intel.com>
	<20140528115701.GY18016@ZenIV.linux.org.uk>
	<20140528131136.GA1643@lahna.fi.intel.com>
	<20140528141937.GZ18016@ZenIV.linux.org.uk>
	<20140528183954.GA18016@ZenIV.linux.org.uk>
Date: Wed, 28 May 2014 12:43:24 -0700
X-Google-Sender-Auth: qRzkeTqR8H5oWsYtamrnY26_bD4
Message-ID: <CA+55aFwmoevoA3h5AZhqtHC0kEJegb0crT_jYvXWWD3UWZt9Aw@mail.gmail.com>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s! [systemd-udevd:1667]
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e0122a6868867c404fa7b06f7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0122a6868867c404fa7b06f7
Content-Type: text/plain; charset=UTF-8

On Wed, May 28, 2014 at 11:39 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> OK, the warnings about averting your eyes very much apply; the thing below
> definitely needs more massage before it becomes acceptable

I've been looking at the this too, and I have to say, I absolutely
hate your DCACHE_MAY_FREE logic. It makes it really hard to follow
what the heck is happening across threads.

So just to understand the code, how about this (UNTESTED!) patch? It
gets rid of the DCACHE_MAY_FREE logic entirely, and makes the rules
imho much more straightforward:

 - whoever calls "dentry_kill()" first is the one that frees things.
 - dentry_kill() does *not* touch the shrink list at all. In fact,
*nothing* touches the shrink list, except for the shrinker.
 - the shrinkers remove entries from their own lists
 - the shrinker list logic depends on the actual freeing of the dentry
to be delayed until the RCU grace period (already true for RCU-lookup
dentries)

In other words, that whole "may-free" thing goes away, the whole
shrink-list locking issues go away, there are no subtle rules. Nobody
else ever touches the shrink-list entries than the entity walking the
shrink-lists. Once DCACHE_SHRINK_LIST is set, nobody else is

It does require that the dentry shrinking code always hold the RCU
lock for reading, because others may actually be doing the final
dput() while the thing is on the shrinking list (and holding the RCU
lock is what protects the entry from actually being free'd).

NOTE! I don't claim that this fixes anything, but I do think that it
makes that whole cross-thread complexity of that DCACHE_MAY_FREE go
away. I think it's easier to understand, and it removes code in the
process. Comments?

             Linus

--089e0122a6868867c404fa7b06f7
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hvr1ifi60

IGZzL2RjYWNoZS5jICAgICAgICAgICAgfCAzMiArKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0t
LS0tLQogaW5jbHVkZS9saW51eC9kY2FjaGUuaCB8ICAyIC0tCiAyIGZpbGVzIGNoYW5nZWQsIDE0
IGluc2VydGlvbnMoKyksIDIwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2RjYWNoZS5j
IGIvZnMvZGNhY2hlLmMKaW5kZXggNDJhZTAxZWVmYzA3Li42ODIxNDc5YTM3OGUgMTAwNjQ0Ci0t
LSBhL2ZzL2RjYWNoZS5jCisrKyBiL2ZzL2RjYWNoZS5jCkBAIC0yNDgsMTEgKzI0OCw3IEBAIHN0
YXRpYyB2b2lkIF9fZF9mcmVlKHN0cnVjdCByY3VfaGVhZCAqaGVhZCkKIAogc3RhdGljIHZvaWQg
ZGVudHJ5X2ZyZWUoc3RydWN0IGRlbnRyeSAqZGVudHJ5KQogewotCS8qIGlmIGRlbnRyeSB3YXMg
bmV2ZXIgdmlzaWJsZSB0byBSQ1UsIGltbWVkaWF0ZSBmcmVlIGlzIE9LICovCi0JaWYgKCEoZGVu
dHJ5LT5kX2ZsYWdzICYgRENBQ0hFX1JDVUFDQ0VTUykpCi0JCV9fZF9mcmVlKCZkZW50cnktPmRf
dS5kX3JjdSk7Ci0JZWxzZQotCQljYWxsX3JjdSgmZGVudHJ5LT5kX3UuZF9yY3UsIF9fZF9mcmVl
KTsKKwljYWxsX3JjdSgmZGVudHJ5LT5kX3UuZF9yY3UsIF9fZF9mcmVlKTsKIH0KIAogLyoqCkBA
IC00NTMsMTIgKzQ0OSwxMSBAQCBkZW50cnlfa2lsbChzdHJ1Y3QgZGVudHJ5ICpkZW50cnksIGlu
dCB1bmxvY2tfb25fZmFpbHVyZSkKIHsKIAlzdHJ1Y3QgaW5vZGUgKmlub2RlOwogCXN0cnVjdCBk
ZW50cnkgKnBhcmVudCA9IE5VTEw7Ci0JYm9vbCBjYW5fZnJlZSA9IHRydWU7CiAKLQlpZiAodW5s
aWtlbHkoZGVudHJ5LT5kX2ZsYWdzICYgRENBQ0hFX0RFTlRSWV9LSUxMRUQpKSB7Ci0JCWNhbl9m
cmVlID0gZGVudHJ5LT5kX2ZsYWdzICYgRENBQ0hFX01BWV9GUkVFOworCS8qIERpZCBzb21lYm9k
eSBlbHNlIGFscmVhZHkgZnJlZSBpdD8gKi8KKwlpZiAoX19sb2NrcmVmX2lzX2RlYWQoJmRlbnRy
eS0+ZF9sb2NrcmVmKSkgewogCQlzcGluX3VubG9jaygmZGVudHJ5LT5kX2xvY2spOwotCQlnb3Rv
IG91dDsKKwkJcmV0dXJuIE5VTEw7CiAJfQogCiAJaW5vZGUgPSBkZW50cnktPmRfaW5vZGU7CkBA
IC01MTQsMTUgKzUwOSw3IEBAIHJlbG9jazoKIAlpZiAoZGVudHJ5LT5kX29wICYmIGRlbnRyeS0+
ZF9vcC0+ZF9yZWxlYXNlKQogCQlkZW50cnktPmRfb3AtPmRfcmVsZWFzZShkZW50cnkpOwogCi0J
c3Bpbl9sb2NrKCZkZW50cnktPmRfbG9jayk7Ci0JaWYgKGRlbnRyeS0+ZF9mbGFncyAmIERDQUNI
RV9TSFJJTktfTElTVCkgewotCQlkZW50cnktPmRfZmxhZ3MgfD0gRENBQ0hFX01BWV9GUkVFOwot
CQljYW5fZnJlZSA9IGZhbHNlOwotCX0KLQlzcGluX3VubG9jaygmZGVudHJ5LT5kX2xvY2spOwot
b3V0OgotCWlmIChsaWtlbHkoY2FuX2ZyZWUpKQotCQlkZW50cnlfZnJlZShkZW50cnkpOworCWRl
bnRyeV9mcmVlKGRlbnRyeSk7CiAJcmV0dXJuIHBhcmVudDsKIH0KIApAQCAtOTIxLDkgKzkwOCwx
MSBAQCBsb25nIHBydW5lX2RjYWNoZV9zYihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCB1bnNpZ25l
ZCBsb25nIG5yX3RvX3NjYW4sCiAJTElTVF9IRUFEKGRpc3Bvc2UpOwogCWxvbmcgZnJlZWQ7CiAK
KwlyY3VfcmVhZF9sb2NrKCk7CiAJZnJlZWQgPSBsaXN0X2xydV93YWxrX25vZGUoJnNiLT5zX2Rl
bnRyeV9scnUsIG5pZCwgZGVudHJ5X2xydV9pc29sYXRlLAogCQkJCSAgICAgICAmZGlzcG9zZSwg
Jm5yX3RvX3NjYW4pOwogCXNocmlua19kZW50cnlfbGlzdCgmZGlzcG9zZSk7CisJcmN1X3JlYWRf
dW5sb2NrKCk7CiAJcmV0dXJuIGZyZWVkOwogfQogCkBAIC05NjIsMTEgKzk1MSwxMyBAQCB2b2lk
IHNocmlua19kY2FjaGVfc2Ioc3RydWN0IHN1cGVyX2Jsb2NrICpzYikKIAlkbyB7CiAJCUxJU1Rf
SEVBRChkaXNwb3NlKTsKIAorCQlyY3VfcmVhZF9sb2NrKCk7CiAJCWZyZWVkID0gbGlzdF9scnVf
d2Fsaygmc2ItPnNfZGVudHJ5X2xydSwKIAkJCWRlbnRyeV9scnVfaXNvbGF0ZV9zaHJpbmssICZk
aXNwb3NlLCBVSU5UX01BWCk7CiAKIAkJdGhpc19jcHVfc3ViKG5yX2RlbnRyeV91bnVzZWQsIGZy
ZWVkKTsKIAkJc2hyaW5rX2RlbnRyeV9saXN0KCZkaXNwb3NlKTsKKwkJcmN1X3JlYWRfdW5sb2Nr
KCk7CiAJfSB3aGlsZSAoZnJlZWQgPiAwKTsKIH0KIEVYUE9SVF9TWU1CT0woc2hyaW5rX2RjYWNo
ZV9zYik7CkBAIC0xMjMwLDEzICsxMjIxLDE2IEBAIHZvaWQgc2hyaW5rX2RjYWNoZV9wYXJlbnQo
c3RydWN0IGRlbnRyeSAqcGFyZW50KQogCQlkYXRhLnN0YXJ0ID0gcGFyZW50OwogCQlkYXRhLmZv
dW5kID0gMDsKIAorCQlyY3VfcmVhZF9sb2NrKCk7CiAJCWRfd2FsayhwYXJlbnQsICZkYXRhLCBz
ZWxlY3RfY29sbGVjdCwgTlVMTCk7CiAJCWlmICghZGF0YS5mb3VuZCkKIAkJCWJyZWFrOwogCiAJ
CXNocmlua19kZW50cnlfbGlzdCgmZGF0YS5kaXNwb3NlKTsKKwkJcmN1X3JlYWRfdW5sb2NrKCk7
CiAJCWNvbmRfcmVzY2hlZCgpOwogCX0KKwlyY3VfcmVhZF91bmxvY2soKTsKIH0KIEVYUE9SVF9T
WU1CT0woc2hyaW5rX2RjYWNoZV9wYXJlbnQpOwogCkBAIC0xMzM4LDExICsxMzMyLDEzIEBAIGlu
dCBjaGVja19zdWJtb3VudHNfYW5kX2Ryb3Aoc3RydWN0IGRlbnRyeSAqZGVudHJ5KQogCQlkYXRh
LnN0YXJ0ID0gZGVudHJ5OwogCQlkYXRhLmZvdW5kID0gMDsKIAorCQlyY3VfcmVhZF9sb2NrKCk7
CiAJCWRfd2FsayhkZW50cnksICZkYXRhLCBjaGVja19hbmRfY29sbGVjdCwgY2hlY2tfYW5kX2Ry
b3ApOwogCQlyZXQgPSBkYXRhLmZvdW5kOwogCiAJCWlmICghbGlzdF9lbXB0eSgmZGF0YS5kaXNw
b3NlKSkKIAkJCXNocmlua19kZW50cnlfbGlzdCgmZGF0YS5kaXNwb3NlKTsKKwkJcmN1X3JlYWRf
dW5sb2NrKCk7CiAKIAkJaWYgKHJldCA8PSAwKQogCQkJYnJlYWs7CmRpZmYgLS1naXQgYS9pbmNs
dWRlL2xpbnV4L2RjYWNoZS5oIGIvaW5jbHVkZS9saW51eC9kY2FjaGUuaAppbmRleCAzYzdlYzMy
N2ViZDIuLjNiOWJmZGI4M2JhNiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9kY2FjaGUuaAor
KysgYi9pbmNsdWRlL2xpbnV4L2RjYWNoZS5oCkBAIC0yMjEsOCArMjIxLDYgQEAgc3RydWN0IGRl
bnRyeV9vcGVyYXRpb25zIHsKICNkZWZpbmUgRENBQ0hFX1NZTUxJTktfVFlQRQkJMHgwMDMwMDAw
MCAvKiBTeW1saW5rICovCiAjZGVmaW5lIERDQUNIRV9GSUxFX1RZUEUJCTB4MDA0MDAwMDAgLyog
T3RoZXIgZmlsZSB0eXBlICovCiAKLSNkZWZpbmUgRENBQ0hFX01BWV9GUkVFCQkJMHgwMDgwMDAw
MAotCiBleHRlcm4gc2VxbG9ja190IHJlbmFtZV9sb2NrOwogCiBzdGF0aWMgaW5saW5lIGludCBk
bmFtZV9leHRlcm5hbChjb25zdCBzdHJ1Y3QgZGVudHJ5ICpkZW50cnkpCg==
--089e0122a6868867c404fa7b06f7--
