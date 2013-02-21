Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3BUGTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 01:19:42 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:37672 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3BUGTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 01:19:41 -0500
MIME-Version: 1.0
From: Lianwei Wang <lianwei.wang@gmail.com>
Date: Thu, 21 Feb 2013 14:19:21 +0800
Message-ID: <CAJFUiJhxqWeQ9PiinpRYCUF8U_3dpaAdvsEKHW2i-QqZ=vkYsQ@mail.gmail.com>
Subject: PATCH: freezer: add fake signal clearing back when thaw task
To: linux-kernel@vger.kernel.org, tj@kernel.org
Content-Type: multipart/mixed; boundary=e89a8fb204865e3a4704d6360f5c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8fb204865e3a4704d6360f5c
Content-Type: text/plain; charset=ISO-8859-1

Hi Tejun Heo and all,

The commit of "34b087e freezer: kill unused
set_freezable_with_signal()" remove recalc_sigpending*() calls in
freezer, so the user tasks get TIF_SIGPENDING fake signal that is set
when freezing userspace process. It left the fake signal to userspcae
which cause the userspace task that wait_event_freezable and friends
return a wrong ERESTARTSYS. This is not good because it waste cpu time
to handle the fake signal.

Can we just call the recalc_sigpending to clear the fake signal for
userspace tasks? as below patch do:

>From 176fccee178bc0185d92853dd2f521c9166b0853 Mon Sep 17 00:00:00 2001
From: Lianwei Wang <lianwei.wang@gmail.com>
Date: Mon, 21 Jan 2013 18:21:26 +0800
Subject: [PATCH] freezer: add fake signal clearing back when thaw task

The fake TIF_SIGPENDING is set during freeze userspace process, but it
is not cleared when thaw tasks after below commit:
  34b087e freezer: kill unused set_freezable_with_signal()

This will cause the userspace task that wait_event_freezable and friends
return a wrong ERESTARTSYS. This is not good because it waste cpu time to
handle the fake signal.

Try to clear the TIF_SIGPENDING flag for userspace apps when wakeup the
frozen task to fix this issue.

Change-Id: I91c90ad2ee9a46c42e3b39a7384ec81e97bc0394
Signed-off-by: Lianwei Wang <lianwei.wang@gmail.com>
---
 kernel/freezer.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index c38893b..09557f6 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -46,6 +46,16 @@ bool freezing_slow_path(struct task_struct *p)
 }
 EXPORT_SYMBOL(freezing_slow_path);

+static void fake_signal_clear(struct task_struct *p)
+{
+ unsigned long flags;
+
+ if (lock_task_sighand(p, &flags)) {
+     recalc_sigpending();
+     unlock_task_sighand(p, &flags);
+ }
+}
+
 /* Refrigerator is place where frozen processes are stored :-). */
 bool __refrigerator(bool check_kthr_stop)
 {
@@ -74,6 +84,10 @@ bool __refrigerator(bool check_kthr_stop)

  pr_debug("%s left refrigerator\n", current->comm);

+ if (!(current->flags & PF_KTHREAD))
+     if (test_tsk_thread_flag(current, TIF_SIGPENDING))
+         fake_signal_clear(current);
+
  /*
  * Restore saved task state before returning.  The mb'd version
  * needs to be used; otherwise, it might silently break
--
1.7.4.1

--e89a8fb204865e3a4704d6360f5c
Content-Type: application/octet-stream; 
	name="0001-freezer-add-fake-signal-clearing-back-when-thaw-task.patch"
Content-Disposition: attachment; 
	filename="0001-freezer-add-fake-signal-clearing-back-when-thaw-task.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdfirqyj0

RnJvbSAxNzZmY2NlZTE3OGJjMDE4NWQ5Mjg1M2RkMmY1MjFjOTE2NmIwODUzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaWFud2VpIFdhbmcgPGxpYW53ZWkud2FuZ0BnbWFpbC5jb20+
CkRhdGU6IE1vbiwgMjEgSmFuIDIwMTMgMTg6MjE6MjYgKzA4MDAKU3ViamVjdDogW1BBVENIXSBm
cmVlemVyOiBhZGQgZmFrZSBzaWduYWwgY2xlYXJpbmcgYmFjayB3aGVuIHRoYXcgdGFzawoKVGhl
IGZha2UgVElGX1NJR1BFTkRJTkcgaXMgc2V0IGR1cmluZyBmcmVlemUgdXNlcnNwYWNlIHByb2Nl
c3MsIGJ1dCBpdAppcyBub3QgY2xlYXJlZCB3aGVuIHRoYXcgdGFza3MgYWZ0ZXIgYmVsb3cgY29t
bWl0OgogIDM0YjA4N2UgZnJlZXplcjoga2lsbCB1bnVzZWQgc2V0X2ZyZWV6YWJsZV93aXRoX3Np
Z25hbCgpCgpUaGlzIHdpbGwgY2F1c2UgdGhlIHVzZXJzcGFjZSB0YXNrIHRoYXQgd2FpdF9ldmVu
dF9mcmVlemFibGUgYW5kIGZyaWVuZHMKcmV0dXJuIGEgd3JvbmcgRVJFU1RBUlRTWVMuIFRoaXMg
aXMgbm90IGdvb2QgYmVjYXVzZSBpdCB3YXN0ZSBjcHUgdGltZSB0bwpoYW5kbGUgdGhlIGZha2Ug
c2lnbmFsLgoKVHJ5IHRvIGNsZWFyIHRoZSBUSUZfU0lHUEVORElORyBmbGFnIGZvciB1c2Vyc3Bh
Y2UgYXBwcyB3aGVuIHdha2V1cCB0aGUKZnJvemVuIHRhc2sgdG8gZml4IHRoaXMgaXNzdWUuCgpD
aGFuZ2UtSWQ6IEk5MWM5MGFkMmVlOWE0NmM0MmUzYjM5YTczODRlYzgxZTk3YmMwMzk0ClNpZ25l
ZC1vZmYtYnk6IExpYW53ZWkgV2FuZyA8bGlhbndlaS53YW5nQGdtYWlsLmNvbT4KLS0tCiBrZXJu
ZWwvZnJlZXplci5jIHwgICAxNCArKysrKysrKysrKysrKwogMSBmaWxlcyBjaGFuZ2VkLCAxNCBp
bnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9mcmVlemVy
LmMgYi9rZXJuZWwvZnJlZXplci5jCmluZGV4IGMzODg5M2IuLjA5NTU3ZjYgMTAwNjQ0Ci0tLSBh
L2tlcm5lbC9mcmVlemVyLmMKKysrIGIva2VybmVsL2ZyZWV6ZXIuYwpAQCAtNDYsNiArNDYsMTYg
QEAgYm9vbCBmcmVlemluZ19zbG93X3BhdGgoc3RydWN0IHRhc2tfc3RydWN0ICpwKQogfQogRVhQ
T1JUX1NZTUJPTChmcmVlemluZ19zbG93X3BhdGgpOwogCitzdGF0aWMgdm9pZCBmYWtlX3NpZ25h
bF9jbGVhcihzdHJ1Y3QgdGFza19zdHJ1Y3QgKnApCit7CisJdW5zaWduZWQgbG9uZyBmbGFnczsK
KworCWlmIChsb2NrX3Rhc2tfc2lnaGFuZChwLCAmZmxhZ3MpKSB7CisJCXJlY2FsY19zaWdwZW5k
aW5nKCk7CisJCXVubG9ja190YXNrX3NpZ2hhbmQocCwgJmZsYWdzKTsKKwl9Cit9CisKIC8qIFJl
ZnJpZ2VyYXRvciBpcyBwbGFjZSB3aGVyZSBmcm96ZW4gcHJvY2Vzc2VzIGFyZSBzdG9yZWQgOi0p
LiAqLwogYm9vbCBfX3JlZnJpZ2VyYXRvcihib29sIGNoZWNrX2t0aHJfc3RvcCkKIHsKQEAgLTc0
LDYgKzg0LDEwIEBAIGJvb2wgX19yZWZyaWdlcmF0b3IoYm9vbCBjaGVja19rdGhyX3N0b3ApCiAK
IAlwcl9kZWJ1ZygiJXMgbGVmdCByZWZyaWdlcmF0b3JcbiIsIGN1cnJlbnQtPmNvbW0pOwogCisJ
aWYgKCEoY3VycmVudC0+ZmxhZ3MgJiBQRl9LVEhSRUFEKSkKKwkJaWYgKHRlc3RfdHNrX3RocmVh
ZF9mbGFnKGN1cnJlbnQsIFRJRl9TSUdQRU5ESU5HKSkKKwkJCWZha2Vfc2lnbmFsX2NsZWFyKGN1
cnJlbnQpOworCiAJLyoKIAkgKiBSZXN0b3JlIHNhdmVkIHRhc2sgc3RhdGUgYmVmb3JlIHJldHVy
bmluZy4gIFRoZSBtYidkIHZlcnNpb24KIAkgKiBuZWVkcyB0byBiZSB1c2VkOyBvdGhlcndpc2Us
IGl0IG1pZ2h0IHNpbGVudGx5IGJyZWFrCi0tIAoxLjcuNC4xCgo=
--e89a8fb204865e3a4704d6360f5c--
