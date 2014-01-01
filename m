Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaAAMOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 07:14:09 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:59530 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbaAAMOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 07:14:07 -0500
MIME-Version: 1.0
X-Google-Sender-Delegation: getarunks@gmail.com
Date: Wed, 1 Jan 2014 17:44:06 +0530
X-Google-Sender-Auth: L0AjgMcapoObZfhCD_jTEwKYiGI
Message-ID: <CAKZGPAMmtDNYQfMnujG9pozkn=xd8=9hoB++8avqxgbYomvhTQ@mail.gmail.com>
Subject: [PATCH] printk: flush conflicting continuation line
From: Arun KS <arunks.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, joe@perches.com, tj@kernel.org,
        fweisbec@gmail.com, paul.gortmaker@windriver.com
Content-Type: multipart/mixed; boundary=001a113306f214c15004eee79d52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a113306f214c15004eee79d52
Content-Type: text/plain; charset=ISO-8859-1

>From d751f9a0cb6329ae3171f6e1cb85e4a3aa792d73 Mon Sep 17 00:00:00 2001
From: Arun KS <arun.ks@broadcom.com>
Date: Wed, 1 Jan 2014 17:24:46 +0530
Subject: printk: flush conflicting continuation line

An earlier newline was missing and current print is from different task.
In this scenario flush the continuation line and store this line seperatly.

This patch fix the below scenario of timestamp interleaving,
<6>[   28.154370 ] read_word_reg : reg[0x 3], reg[0x 4]  data [0x 642]
<6>[   28.155428 ] uart disconnect
<6>[   31.947341 ] dvfs[cpufreq.c<275>]:plug-in cpu<1> done
<4>[   28.155445 ] UART detached : send switch state 201
<6>[   32.014112 ] read_reg : reg[0x 3] data[0x21]

Signed-off-by: Arun KS <getarunks@gmail.com>
Signed-off-by: Arun KS <arun.ks@broadcom.com>
---
 kernel/printk/printk.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index be7c86b..65ccaeb 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1604,7 +1604,10 @@ asmlinkage int vprintk_emit(int facility, int level,
  if (!(lflags & LOG_PREFIX))
  stored = cont_add(facility, level, text, text_len);
  cont_flush(LOG_NEWLINE);
- }
+ /* Flush conflicting buffer. An earlier newline was missing
+ * and current print is from different task */
+ } else if (cont.len && cont.owner != current)
+ cont_flush(LOG_NEWLINE);

  if (!stored)
  log_store(facility, level, lflags, 0,
-- 
1.7.6

--001a113306f214c15004eee79d52
Content-Type: application/octet-stream; 
	name="0001-printk-flush-conflicting-continuation-line.patch"
Content-Disposition: attachment; 
	filename="0001-printk-flush-conflicting-continuation-line.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hpwjqtzt0

RnJvbSBkNzUxZjlhMGNiNjMyOWFlMzE3MWY2ZTFjYjg1ZTRhM2FhNzkyZDczIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBcnVuIEtTIDxhcnVuLmtzQGJyb2FkY29tLmNvbT4KRGF0ZTog
V2VkLCAxIEphbiAyMDE0IDE3OjI0OjQ2ICswNTMwClN1YmplY3Q6IHByaW50azogZmx1c2ggY29u
ZmxpY3RpbmcgY29udGludWF0aW9uIGxpbmUKCkFuIGVhcmxpZXIgbmV3bGluZSB3YXMgbWlzc2lu
ZyBhbmQgY3VycmVudCBwcmludCBpcyBmcm9tIGRpZmZlcmVudCB0YXNrLgpJbiB0aGlzIHNjZW5h
cmlvIGZsdXNoIHRoZSBjb250aW51YXRpb24gbGluZSBhbmQgc3RvcmUgdGhpcyBsaW5lIHNlcGVy
YXRseS4KClRoaXMgcGF0Y2ggZml4IHRoZSBiZWxvdyBzY2VuYXJpbyBvZiB0aW1lc3RhbXAgaW50
ZXJsZWF2aW5nLAo8Nj5bICAgMjguMTU0MzcwIF0gcmVhZF93b3JkX3JlZyA6IHJlZ1sweCAzXSwg
cmVnWzB4IDRdICBkYXRhIFsweCA2NDJdCjw2PlsgICAyOC4xNTU0MjggXSB1YXJ0IGRpc2Nvbm5l
Y3QKPDY+WyAgIDMxLjk0NzM0MSBdIGR2ZnNbY3B1ZnJlcS5jPDI3NT5dOnBsdWctaW4gY3B1PDE+
IGRvbmUKPDQ+WyAgIDI4LjE1NTQ0NSBdIFVBUlQgZGV0YWNoZWQgOiBzZW5kIHN3aXRjaCBzdGF0
ZSAyMDEKPDY+WyAgIDMyLjAxNDExMiBdIHJlYWRfcmVnIDogcmVnWzB4IDNdIGRhdGFbMHgyMV0K
ClNpZ25lZC1vZmYtYnk6IEFydW4gS1MgPGdldGFydW5rc0BnbWFpbC5jb20+ClNpZ25lZC1vZmYt
Ynk6IEFydW4gS1MgPGFydW4ua3NAYnJvYWRjb20uY29tPgotLS0KIGtlcm5lbC9wcmludGsvcHJp
bnRrLmMgfCAgICA1ICsrKystCiAxIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvcHJpbnRrL3ByaW50ay5jIGIva2VybmVs
L3ByaW50ay9wcmludGsuYwppbmRleCBiZTdjODZiLi42NWNjYWViIDEwMDY0NAotLS0gYS9rZXJu
ZWwvcHJpbnRrL3ByaW50ay5jCisrKyBiL2tlcm5lbC9wcmludGsvcHJpbnRrLmMKQEAgLTE2MDQs
NyArMTYwNCwxMCBAQCBhc21saW5rYWdlIGludCB2cHJpbnRrX2VtaXQoaW50IGZhY2lsaXR5LCBp
bnQgbGV2ZWwsCiAJCQlpZiAoIShsZmxhZ3MgJiBMT0dfUFJFRklYKSkKIAkJCQlzdG9yZWQgPSBj
b250X2FkZChmYWNpbGl0eSwgbGV2ZWwsIHRleHQsIHRleHRfbGVuKTsKIAkJCWNvbnRfZmx1c2go
TE9HX05FV0xJTkUpOwotCQl9CisJCS8qIEZsdXNoIGNvbmZsaWN0aW5nIGJ1ZmZlci4gQW4gZWFy
bGllciBuZXdsaW5lIHdhcyBtaXNzaW5nCisJCSogYW5kIGN1cnJlbnQgcHJpbnQgaXMgZnJvbSBk
aWZmZXJlbnQgdGFzayAqLworCQl9IGVsc2UgaWYgKGNvbnQubGVuICYmIGNvbnQub3duZXIgIT0g
Y3VycmVudCkKKwkJCWNvbnRfZmx1c2goTE9HX05FV0xJTkUpOwogCiAJCWlmICghc3RvcmVkKQog
CQkJbG9nX3N0b3JlKGZhY2lsaXR5LCBsZXZlbCwgbGZsYWdzLCAwLAotLSAKMS43LjYKCg==
--001a113306f214c15004eee79d52--
