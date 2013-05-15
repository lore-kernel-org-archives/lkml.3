Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab3EOTm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:42:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451Ab3EOTmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:42:25 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=FdA93o-vacgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=RPXN6yAvhE4A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=iaOBL08tWKJV51MUiDIA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=pjO6vkfj0npZV7_Pc40A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130515194223.998976932@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 15 May 2013 15:39:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/4] tracing: Fix leaks of filter preds
References: <20130515193922.094868872@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Fix-leaks-of-filter-preds.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Special preds are created when folding a series of preds that
can be done in serial. These are allocated in an ops field of
the pred structure. But they were never freed, causing memory
leaks.

This was discovered using the kmemleak checker:

unreferenced object 0xffff8800797fd5e0 (size 32):
  comm "swapper/0", pid 1, jiffies 4294690605 (age 104.608s)
  hex dump (first 32 bytes):
    00 00 01 00 03 00 05 00 07 00 09 00 0b 00 0d 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814b52af>] kmemleak_alloc+0x73/0x98
    [<ffffffff8111ff84>] kmemleak_alloc_recursive.constprop.42+0x16/0x18
    [<ffffffff81120e68>] __kmalloc+0xd7/0x125
    [<ffffffff810d47eb>] kcalloc.constprop.24+0x2d/0x2f
    [<ffffffff810d4896>] fold_pred_tree_cb+0xa9/0xf4
    [<ffffffff810d3781>] walk_pred_tree+0x47/0xcc
    [<ffffffff810d5030>] replace_preds.isra.20+0x6f8/0x72f
    [<ffffffff810d50b5>] create_filter+0x4e/0x8b
    [<ffffffff81b1c30d>] ftrace_test_event_filter+0x5a/0x155
    [<ffffffff8100028d>] do_one_initcall+0xa0/0x137
    [<ffffffff81afbedf>] kernel_init_freeable+0x14d/0x1dc
    [<ffffffff814b24b7>] kernel_init+0xe/0xdb
    [<ffffffff814d539c>] ret_from_fork+0x7c/0xb0
    [<ffffffffffffffff>] 0xffffffffffffffff

Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: stable@vger.kernel.org # 2.6.39+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index a636117..e1b653f 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -750,7 +750,11 @@ static int filter_set_pred(struct event_filter *filter,
=20
 static void __free_preds(struct event_filter *filter)
 {
+	int i;
+
 	if (filter->preds) {
+		for (i =3D 0; i < filter->n_preds; i++)
+			kfree(filter->preds[i].ops);
 		kfree(filter->preds);
 		filter->preds =3D NULL;
 	}
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRk+UgAAoJEOdOSU1xswtMDFwIAJkJpnuzYEvlbWAIoynQ3DAR
/j8TeuBI3bmMfBGmjGyMhYIwvfJs/fFUUhdq+IWepnT7kK635lKBNatutxXnyecI
2OoKZSMYHN97f7KbHhSBfztSo+rb8pkKB/8xEovNUVT2I6s78q4t54F+LcRgUkTE
hhXZgbymkEjRb7CWkBULDZVyW5xYS69faLNXJwrUEF1iB9kbeHTwB0KIsoSL45Pk
go1Cc8iPJNsTjT5NnHK7KHqN7LkJ76i50U+ReljA9ddu+ma/FVNGpWgsfyb15g2F
BgtyZS5W+OCV0FjegFBKOJfaVTulEHfWOW2DDZ0GLqxp9pdOe25zS5TRjcsmkFo=
=Z8tW
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
