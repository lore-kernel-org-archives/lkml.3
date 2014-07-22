Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbaGVTEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:04:05 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:51847 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbaGVTD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:03:59 -0400
Message-ID: <1406055834.23587.1.camel@gmail.com>
Subject: [RFC] 3.16-rc6 -- fs/direct-io.c:1011 from and to uninitialized.
From: Ian Kumlien <ian.kumlien@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Jul 2014 21:03:54 +0200
Content-Type: multipart/mixed; boundary="=-AUaWtOygmYJMXQhvtnEa"
X-Mailer: Evolution 3.12.4 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AUaWtOygmYJMXQhvtnEa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

This is a resend, try two... 

---
Hi,

While playing around compiling the kernel i noticed the following:
fs/direct-io.c: In function ‘do_blockdev_direct_IO’:
fs/direct-io.c:1022:29: warning: ‘from’ may be used uninitialized in
this function [-Wmaybe-uninitialized]
    ret = submit_page_section(dio, sdio, page,
                             ^
fs/direct-io.c:913:10: note: ‘from’ was declared here
   size_t from, to;
          ^
fs/direct-io.c:1011:12: warning: ‘to’ may be used uninitialized in this
function [-Wmaybe-uninitialized]
    u = (to - from) >> blkbits;
            ^
fs/direct-io.c:913:16: note: ‘to’ was declared here
   size_t from, to;
                ^
---


And while the fix is simple, something along the lines of:
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 98040ba..64a8286 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -910,7 +910,7 @@ static int do_direct_IO(struct dio *dio, struct
dio_submit *sdi
 
        while (sdio->block_in_file < sdio->final_block_in_request) {
                struct page *page;
-               size_t from, to;
+               size_t from, to = {0};
                page = dio_get_page(dio, sdio, &from, &to);
                if (IS_ERR(page)) {
                        ret = PTR_ERR(page);
---

I however don't know if it's in the correct C standard, it compiles fine
though... (or if this is more gcc speific)




--=-AUaWtOygmYJMXQhvtnEa
Content-Disposition: attachment; filename="direct-io-init.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name="direct-io-init.patch"; charset="UTF-8"

Y29tbWl0IGY5NGQwNWNlMTBkODY5YzQxOGQzMjcxYmQwMjhmYzMzYmZkMjVlNmYKQXV0aG9yOiBJ
YW4gS3VtbGllbiA8aWFuLmt1bWxpZW5AZ21haWwuY29tPgpEYXRlOiAgIFR1ZSBKdWwgMjIgMjA6
NTc6NTAgMjAxNCArMDIwMAoKICAgIEluaXRpYWxpemUgdGhlIHRvIGFuZCBmcm9tIGZpZWxkcwog
ICAgCiAgICBXaGlsZSBjb21wbGlsaW5nIHRoZSAzLjE2LXJjNiBrZXJuZWwgSSBzYXcgdGhpczoK
ICAgIGZzL2RpcmVjdC1pby5jOiBJbiBmdW5jdGlvbiDigJhkb19ibG9ja2Rldl9kaXJlY3RfSU/i
gJk6CiAgICBmcy9kaXJlY3QtaW8uYzoxMDIyOjI5OiB3YXJuaW5nOiDigJhmcm9t4oCZIG1heSBi
ZSB1c2VkIHVuaW5pdGlhbGl6ZWQgaW4gdGhpcyBmdW5jdGlvbiBbLVdtYXliZS11bmluaXRpYWxp
emVkXQogICAgICAgIHJldCA9IHN1Ym1pdF9wYWdlX3NlY3Rpb24oZGlvLCBzZGlvLCBwYWdlLAog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBeCiAgICBmcy9kaXJlY3QtaW8uYzo5MTM6
MTA6IG5vdGU6IOKAmGZyb23igJkgd2FzIGRlY2xhcmVkIGhlcmUKICAgICAgIHNpemVfdCBmcm9t
LCB0bzsKICAgICAgICAgICAgICBeCiAgICBmcy9kaXJlY3QtaW8uYzoxMDExOjEyOiB3YXJuaW5n
OiDigJh0b+KAmSBtYXkgYmUgdXNlZCB1bmluaXRpYWxpemVkIGluIHRoaXMgZnVuY3Rpb24gWy1X
bWF5YmUtdW5pbml0aWFsaXplZF0KICAgICAgICB1ID0gKHRvIC0gZnJvbSkgPj4gYmxrYml0czsK
ICAgICAgICAgICAgICAgIF4KICAgIGZzL2RpcmVjdC1pby5jOjkxMzoxNjogbm90ZTog4oCYdG/i
gJkgd2FzIGRlY2xhcmVkIGhlcmUKICAgICAgIHNpemVfdCBmcm9tLCB0bzsKICAgICAgICAgICAg
ICAgICAgICBeCiAgICAtLS0KICAgIAogICAgVGhpcyBzbWFsbCBjaGFuZ2VzIG1ha2VzIHN1cmUg
dGhhdCB0aGUgdmFsdWVzIGFyZSBpbml0aWFsaXplZC4KICAgIAogICAgU2lnbmVkLW9mZi1ieTog
SWFuIEt1bWxpZW4gPGlhbi5rdW1saWVuQGdtYWlsLmNvbT4KCmRpZmYgLS1naXQgYS9mcy9kaXJl
Y3QtaW8uYyBiL2ZzL2RpcmVjdC1pby5jCmluZGV4IDk4MDQwYmEuLjY0YTgyODYgMTAwNjQ0Ci0t
LSBhL2ZzL2RpcmVjdC1pby5jCisrKyBiL2ZzL2RpcmVjdC1pby5jCkBAIC05MTAsNyArOTEwLDcg
QEAgc3RhdGljIGludCBkb19kaXJlY3RfSU8oc3RydWN0IGRpbyAqZGlvLCBzdHJ1Y3QgZGlvX3N1
Ym1pdCAqc2RpbywKIAogICAgICAgIHdoaWxlIChzZGlvLT5ibG9ja19pbl9maWxlIDwgc2Rpby0+
ZmluYWxfYmxvY2tfaW5fcmVxdWVzdCkgewogICAgICAgICAgICAgICAgc3RydWN0IHBhZ2UgKnBh
Z2U7Ci0gICAgICAgICAgICAgICBzaXplX3QgZnJvbSwgdG87CisgICAgICAgICAgICAgICBzaXpl
X3QgZnJvbSwgdG8gPSB7MH07CiAgICAgICAgICAgICAgICBwYWdlID0gZGlvX2dldF9wYWdlKGRp
bywgc2RpbywgJmZyb20sICZ0byk7CiAgICAgICAgICAgICAgICBpZiAoSVNfRVJSKHBhZ2UpKSB7
CiAgICAgICAgICAgICAgICAgICAgICAgIHJldCA9IFBUUl9FUlIocGFnZSk7Cg==


--=-AUaWtOygmYJMXQhvtnEa--

