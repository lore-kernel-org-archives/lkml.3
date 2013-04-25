Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab3DYPF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:05:56 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:43074 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286Ab3DYPFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:05:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAJsYZ5mpukCM6TpFb27tJt6G7ZufugEP4kx8wzGxhRwAO46cCw@mail.gmail.com>
References: <CAJsYZ5kk=J_Sc7w5dbMbkWWv8dXEU0ojKjEKNqH=Q6Tf2f7mQg@mail.gmail.com>
	<20130422142218.GA26760@mwanda>
	<CAG6tG3xc3RHD7sZXaEbg1vLRhFj+6d1wY=us4BfxBfi5y0o4zg@mail.gmail.com>
	<CAJsYZ5nQg9g73r5yLicq6gAGbKEXVAFqtF2av=heeNtrNSPSWg@mail.gmail.com>
	<CAG6tG3zcOdkA5QOBhaDzmMvcFSCwbfRAyKuRwXdn6ipOJhTVZQ@mail.gmail.com>
	<CAJsYZ5mpukCM6TpFb27tJt6G7ZufugEP4kx8wzGxhRwAO46cCw@mail.gmail.com>
Date: Thu, 25 Apr 2013 11:05:53 -0400
Message-ID: <CAG6tG3wrHKTJBOu69XiV6BAPfvmK-QqJkBVpzkmkrLdLV5jRwQ@mail.gmail.com>
Subject: Re: [BUG] staging: android: ashmem: Deadlock during ashmem_shrink
From: Robert Love <rlove@google.com>
To: Shankar Brahadeeswaran <shankoo77@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Bringert <bringert@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, devel@driverdev.osuosl.org,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anjana V Kumar <anjanavk12@gmail.com>
Content-Type: multipart/mixed; boundary=001a11c27e323ffcba04db30c18e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c27e323ffcba04db30c18e
Content-Type: text/plain; charset=UTF-8

On Thu, Apr 25, 2013 at 9:54 AM, Shankar Brahadeeswaran
<shankoo77@gmail.com> wrote:

> Also, there are other places in the code where ashmem_mutex is held and memory
> allocation functions are called, ex:- range_alloc, calls kmem_cache_zalloc
>
> Since ashmem_shrink holds the ashmem_mutex, any where from ashmem driver
> if a memory allocation function is called with the ashmem_mutex held
> && if there is a low memory condition that leads to shrinkers being called
> we'll hit the deadlock.

The usual way this is solved is by checking the gfp_mask in the
shrinker code and bailing out (like we do now) for certain masks. So
e.g. the kmem_cache_zalloc in range_alloc is fixed by changing the
mask to GFP_FS.

> I'm trying to see if the ashmem_shrink should really hold the ashmem_mutex,
> but looks like its necessary.

Yes, it needs to hold ashmem_mutex.

There's no reason we have to run ashmem_shrink, though. See attached (untested).

      Robert

--001a11c27e323ffcba04db30c18e
Content-Type: application/octet-stream; name="ashmem-lock-fix-rlove-2.patch"
Content-Disposition: attachment; filename="ashmem-lock-fix-rlove-2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hfy2cnd20

QXZvaWQgcmVjdXJzaW5nIGludG8gYXNobWVtX3NocmluayBmcm9tIHdpdGhpbiBhc2htZW0gaXRz
ZWxmLgoKU2lnbmVkLW9mZi1ieTogUm9iZXJ0IExvdmUgPHJsb3ZlQHJsb3ZlLm9yZz4KCiBhc2ht
ZW0uYyB8ICAgIDYgKysrKystCiAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pCgotLS0gbGludXgtYmFzZS9kcml2ZXJzL3N0YWdpbmcvYW5kcm9pZC9hc2htZW0u
YwkyMDEzLTA0LTI1IDEwOjU4OjMzLjI1MTQ2OTQ3MiAtMDQwMAorKysgbGludXgvZHJpdmVycy9z
dGFnaW5nL2FuZHJvaWQvYXNobWVtLmMJMjAxMy0wNC0yNSAxMTowMjoyOS40MjA2NDQyNzggLTA0
MDAKQEAgLTM2MSw3ICszNjEsMTEgQEAKIAlpZiAoIXNjLT5ucl90b19zY2FuKQogCQlyZXR1cm4g
bHJ1X2NvdW50OwogCi0JbXV0ZXhfbG9jaygmYXNobWVtX211dGV4KTsKKwkvKiBhdm9pZCByZWN1
cnNpbmcgaW50byB0aGlzIGNvZGUgZnJvbSB3aXRoaW4gYXNobWVtIGl0c2VsZiAqLworCWlmICgh
bXV0ZXhfdHJ5bG9jaygmYXNobWVtX211dGV4KSkgeworCQlyZXR1cm4gLTE7CisJfQorCiAJbGlz
dF9mb3JfZWFjaF9lbnRyeV9zYWZlKHJhbmdlLCBuZXh0LCAmYXNobWVtX2xydV9saXN0LCBscnUp
IHsKIAkJc3RydWN0IGlub2RlICppbm9kZSA9IHJhbmdlLT5hc21hLT5maWxlLT5mX2RlbnRyeS0+
ZF9pbm9kZTsKIAkJbG9mZl90IHN0YXJ0ID0gcmFuZ2UtPnBnc3RhcnQgKiBQQUdFX1NJWkU7Cg==
--001a11c27e323ffcba04db30c18e--
