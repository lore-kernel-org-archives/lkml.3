Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056Ab3DASgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:36:20 -0400
Received: from ihemail4.lucent.com ([135.245.0.39]:45699 "EHLO
	ihemail4.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758607Ab3DASgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:36:19 -0400
X-Greylist: delayed 1230 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Apr 2013 14:36:19 EDT
Date: Mon, 1 Apr 2013 13:14:50 -0500 (CDT)
From: Ilija Hadzic <ihadzic@research.bell-labs.com>
X-X-Sender: ihadzic@umail
To: Michal Hocko <mhocko@suse.cz>
cc: Ilija Hadzic <ilijahadzic@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Marco Munderloh <munderl@tnt.uni-hannover.de>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: fix i_mapping and f_mapping initialization in
 drm_open in error path
In-Reply-To: <20130331103418.GA18476@dhcp22.suse.cz>
Message-ID: <Pine.GSO.4.64.1304011249370.27674@umail>
References: <20130326195601.GA5124@dhcp22.suse.cz>
 <CA+4h6Hnhm-Ox_5dRdBH3C9Lh_qVNac8_oL=3ruy75jBX7xp9OQ@mail.gmail.com>
 <20130331103418.GA18476@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-559023410-851401618-1364840090=:14318"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---559023410-851401618-1364840090=:14318
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed



On Sun, 31 Mar 2013, Michal Hocko wrote:

> On Sat 30-03-13 18:26:53, Ilija Hadzic wrote:
>> This looks a bit like a hack and it doesn't look right,
>> conceptually. If the call fails, it should restore things as if
>> nothing has ever happened and overwriting old_mapping is not going to
>> do the trick.
>
> OK, I thought this is what the patch does as it falls back to
> &inode->i_data which is the default mapping for all inodes or it uses
> what used to be in device mapping.
>
> I am obviously not familiar with the drm code but it feels a bit strange
> that the device mapping can be different than inode's resp. file's one

The reason for this is explained in commit message associated with
949c4a34.

In summary, the device's mapping is that of the inode associated with the
first opener. Before 949c4a34, subsequent openers would have to come in
through exactly the same inode that the first opener came in (otherwise 
the open call would fail). So if a user did something like: start X, 
remove /dev/dri/cardN file, mknod the same file again, the applications 
started after such an action would stop working. Also, using the GPU from 
chroot-ed environment was not possible if there was another opener from 
different root.

The 949c4a34, removed this restriction, but introduced a problem with 
VmWare GPU drivers, which fdb40a08. However, fdb40a08 introduced the bug 
that you have reported.

The problem that I have with your proposed fix is that if the first opener 
fails, it can set the device's mapping to that of the inode that was never 
used and never opened (and could even be removed later down the road).

> and even more confusing that inode and file are saved separately.
>

I was trying to quickly get out the patch that was safe in terms of 
introducing new breakage. So the "conservative" thing to do (without 
having to think through all possible scenarios) was to restore each of the 
three pointers from their own temporary variable. Thinking about it, you 
are probably right that file descriptor's and inode's mapping pointer are 
equal when open call is entered so we could use one variable. However, you 
still need a separate variable to store the device's mapping pointer 
because that one can be different.

Attached is a v2 of the patch, for reference. I would appreciate if the 
original reporter or you tested it in lieu of your proposed patch and let 
me know if it fixes your issue.

-- Ilija

---559023410-851401618-1364840090=:14318
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=0001-drm-correctly-restore-mappings-if-drm_open-fails.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.GSO.4.64.1304011314500.14318@umail>
Content-Description: 
Content-Disposition: attachment; filename=0001-drm-correctly-restore-mappings-if-drm_open-fails.patch

RnJvbSA3ZTNjODMyMTU4ZTI1NTJlNWUxMDZhNTg4ZTJiOWU2MWMzNWI2OGYy
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogSWxpamEgSGFkemlj
IDxpaGFkemljQHJlc2VhcmNoLmJlbGwtbGFicy5jb20+DQpEYXRlOiBTYXQs
IDMwIE1hciAyMDEzIDE4OjIwOjM1IC0wNDAwDQpTdWJqZWN0OiBbUEFUQ0hd
IGRybTogY29ycmVjdGx5IHJlc3RvcmUgbWFwcGluZ3MgaWYgZHJtX29wZW4g
ZmFpbHMNCg0KSWYgZmlyc3QgZHJtX29wZW4gZmFpbHMsIHRoZSBlcnJvci1o
YW5kbGluZyBwYXRoIHdpbGwNCmluY29ycmVjdGx5IHJlc3RvcmUgaW5vZGUn
cyBtYXBwaW5nIHRvIE5VTEwuIFRoaXMgY2FuDQpjYXVzZSB0aGUgY3Jhc2gg
bGF0ZXIgb24uIEZpeCBieSBzZXBhcmF0ZWx5IHN0b3JpbmcNCmF3YXkgbWFw
cGluZyBwb2ludGVycyB0aGF0IGRybV9vcGVuIGNhbiB0b3VjaCBhbmQNCnJl
c3RvcmUgZWFjaCBmcm9tIGl0cyBvd24gcmVzcGVjdGl2ZSB2YXJpYWJsZSBp
ZiB0aGUNCmNhbGwgZmFpbHMuDQoNClJlZmVyZW5jZToNCmh0dHA6Ly9saXN0
cy5mcmVlZGVza3RvcC5vcmcvYXJjaGl2ZXMvZHJpLWRldmVsLzIwMTMtTWFy
Y2gvMDM2NTY0Lmh0bWwNCg0KdjI6IHVzZSBvbmUgdmFyaWFibGUgdG8gc3Rv
cmUgZmlsZSBhbmQgaW5vZGUgbWFwcGluZw0KICAgIHNpbmNlIHRoZXkgYXJl
IHRoZSBzYW1lIGF0IHRoZSBmdW5jdGlvbiBlbnRyeTsgYWxzbw0KICAgIGZp
eCBzcGVsbGluZyBtaXN0YWtlcyBpbiBjb21taXQgbWVzc2FnZS4NCg0KUmVw
b3J0ZWQtYnk6IE1hcmNvIE11bmRlcmxvaCA8bXVuZGVybEB0bnQudW5pLWhh
bm5vdmVyLmRlPg0KU2lnbmVkLW9mZi1ieTogSWxpamEgSGFkemljIDxpaGFk
emljQHJlc2VhcmNoLmJlbGwtbGFicy5jb20+DQpDYzogTWljaGFsIEhvY2tv
IDxtaG9ja29Ac3VzZS5jej4NCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3Jn
DQoNClNpZ25lZC1vZmYtYnk6IElsaWphIEhhZHppYyA8aWhhZHppY0ByZXNl
YXJjaC5iZWxsLWxhYnMuY29tPg0KLS0tDQogZHJpdmVycy9ncHUvZHJtL2Ry
bV9mb3BzLmMgfCAgICA2ICsrKystLQ0KIDEgZmlsZXMgY2hhbmdlZCwgNCBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9ncHUvZHJtL2RybV9mb3BzLmMgYi9kcml2ZXJzL2dwdS9kcm0v
ZHJtX2ZvcHMuYw0KaW5kZXggMTNmZGNkMS4uNDI5ZTA3ZCAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvZ3B1L2RybS9kcm1fZm9wcy5jDQorKysgYi9kcml2ZXJz
L2dwdS9kcm0vZHJtX2ZvcHMuYw0KQEAgLTEyMyw2ICsxMjMsNyBAQCBpbnQg
ZHJtX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZp
bHApDQogCWludCByZXRjb2RlID0gMDsNCiAJaW50IG5lZWRfc2V0dXAgPSAw
Ow0KIAlzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqb2xkX21hcHBpbmc7DQorCXN0
cnVjdCBhZGRyZXNzX3NwYWNlICpvbGRfaW1hcHBpbmc7DQogDQogCW1pbm9y
ID0gaWRyX2ZpbmQoJmRybV9taW5vcnNfaWRyLCBtaW5vcl9pZCk7DQogCWlm
ICghbWlub3IpDQpAQCAtMTM3LDYgKzEzOCw3IEBAIGludCBkcm1fb3Blbihz
dHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlscCkNCiAJaWYg
KCFkZXYtPm9wZW5fY291bnQrKykNCiAJCW5lZWRfc2V0dXAgPSAxOw0KIAlt
dXRleF9sb2NrKCZkZXYtPnN0cnVjdF9tdXRleCk7DQorCW9sZF9pbWFwcGlu
ZyA9IGlub2RlLT5pX21hcHBpbmc7DQogCW9sZF9tYXBwaW5nID0gZGV2LT5k
ZXZfbWFwcGluZzsNCiAJaWYgKG9sZF9tYXBwaW5nID09IE5VTEwpDQogCQlk
ZXYtPmRldl9tYXBwaW5nID0gJmlub2RlLT5pX2RhdGE7DQpAQCAtMTU5LDgg
KzE2MSw4IEBAIGludCBkcm1fb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBz
dHJ1Y3QgZmlsZSAqZmlscCkNCiANCiBlcnJfdW5kbzoNCiAJbXV0ZXhfbG9j
aygmZGV2LT5zdHJ1Y3RfbXV0ZXgpOw0KLQlmaWxwLT5mX21hcHBpbmcgPSBv
bGRfbWFwcGluZzsNCi0JaW5vZGUtPmlfbWFwcGluZyA9IG9sZF9tYXBwaW5n
Ow0KKwlmaWxwLT5mX21hcHBpbmcgPSBvbGRfaW1hcHBpbmc7DQorCWlub2Rl
LT5pX21hcHBpbmcgPSBvbGRfaW1hcHBpbmc7DQogCWlwdXQoY29udGFpbmVy
X29mKGRldi0+ZGV2X21hcHBpbmcsIHN0cnVjdCBpbm9kZSwgaV9kYXRhKSk7
DQogCWRldi0+ZGV2X21hcHBpbmcgPSBvbGRfbWFwcGluZzsNCiAJbXV0ZXhf
dW5sb2NrKCZkZXYtPnN0cnVjdF9tdXRleCk7DQotLSANCjEuNy40LjENCg0K

---559023410-851401618-1364840090=:14318--
