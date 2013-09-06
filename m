Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3IFVuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 17:50:03 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44953 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab3IFVuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 17:50:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130906202022.GA353@x4>
References: <alpine.LNX.2.00.1309061202050.26934@pobox.suse.cz>
	<20130906202022.GA353@x4>
Date: Fri, 6 Sep 2013 23:50:00 +0200
Message-ID: <CANq1E4Rf4c4zj1mD1aPr93Q2_M65DCEJhuLqcBWa5uH9tcKuWA@mail.gmail.com>
Subject: Re: [GIT] HID for 3.12 merge window
From: David Herrmann <dh.herrmann@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: multipart/mixed; boundary=089e01493b542f7c1804e5be058e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01493b542f7c1804e5be058e
Content-Type: text/plain; charset=ISO-8859-1

Hi

On Fri, Sep 6, 2013 at 10:20 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On 2013.09.06 at 14:00 +0200, Jiri Kosina wrote:
>>
>> David Herrmann (12):
> ...
>>       HID: wiimote: add support for Guitar-Hero drums
>
>  commit 61e00655e9cb82e034eb72b95a51072e718d14a7
>  Author: David Herrmann <dh.herrmann@gmail.com>
>  Date:   Mon Aug 26 19:14:46 2013 +0200
>
>      Input: introduce BTN/ABS bits for drums and guitars
>
> The commit above breaks my Logitech mouse. The mouse cursor just sits in
> the middle of the screen and doesn't react to movements. dmesg is
> normal, but Xorg.0.log says:

Ok, the issue is the kernel assumes ABS_MAX to be a power-of-2 minus 1
(used as mask). That wasn't really obvious to me. Attached is a patch
which should fix that. Could you apply it on top of linus/master and
give it a try?

@Dmitry: The IOC_NR part of the definition of EVIOCSABS() is now
bigger than 1-byte. I need to check how that affects the 'E' part. Any
idea what to do here?

Thanks
David

Patch is also attached as I doubt that inlining it works in that
stupid web-client:

>From 653fe4d46ad368cdbf9b56a559a8468bd6f5cb3c Mon Sep 17 00:00:00 2001
From: David Herrmann <dh.herrmann@gmail.com>
Date: Fri, 6 Sep 2013 23:46:08 +0200
Subject: [PATCH] Input: evdev: don't assume ABS_MAX to be a power-of-2 minus 1

ABS_MAX is no longer a full mask. Hence, don't use it directly to get any
parameter for ioctls. Furthermore, the parameter-region and
ioctl-definition overlap, so even bumping ABS_MAX to 0x7f wouldn't help.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/input/evdev.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index d2b34fb..82e0073 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -939,12 +939,13 @@ static long evdev_do_ioctl(struct file *file,
unsigned int cmd,
  _IOC_NR(cmd) & EV_MAX, size,
  p, compat_mode);

- if ((_IOC_NR(cmd) & ~ABS_MAX) == _IOC_NR(EVIOCGABS(0))) {
+ if (_IOC_NR(cmd) >= _IOC_NR(EVIOCGABS(0)) &&
+    _IOC_NR(cmd) <= _IOC_NR(EVIOCGABS(ABS_MAX))) {

  if (!dev->absinfo)
  return -EINVAL;

- t = _IOC_NR(cmd) & ABS_MAX;
+ t = _IOC_NR(cmd) - _IOC_NR(EVIOCGABS(0));
  abs = dev->absinfo[t];

  if (copy_to_user(p, &abs, min_t(size_t,
@@ -957,12 +958,13 @@ static long evdev_do_ioctl(struct file *file,
unsigned int cmd,

  if (_IOC_DIR(cmd) == _IOC_WRITE) {

- if ((_IOC_NR(cmd) & ~ABS_MAX) == _IOC_NR(EVIOCSABS(0))) {
+ if (_IOC_NR(cmd) >= _IOC_NR(EVIOCSABS(0)) &&
+    _IOC_NR(cmd) <= _IOC_NR(EVIOCSABS(ABS_MAX))) {

  if (!dev->absinfo)
  return -EINVAL;

- t = _IOC_NR(cmd) & ABS_MAX;
+ t = _IOC_NR(cmd) - _IOC_NR(EVIOCSABS(0));

  if (copy_from_user(&abs, p, min_t(size_t,
  size, sizeof(struct input_absinfo))))
-- 
1.8.4

--089e01493b542f7c1804e5be058e
Content-Type: application/octet-stream; 
	name="0001-Input-evdev-don-t-assume-ABS_MAX-to-be-a-power-of-2-.patch"
Content-Disposition: attachment; 
	filename="0001-Input-evdev-don-t-assume-ABS_MAX-to-be-a-power-of-2-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hl9xsn0w0

RnJvbSA2NTNmZTRkNDZhZDM2OGNkYmY5YjU2YTU1OWE4NDY4YmQ2ZjVjYjNjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBIZXJybWFubiA8ZGguaGVycm1hbm5AZ21haWwuY29t
PgpEYXRlOiBGcmksIDYgU2VwIDIwMTMgMjM6NDY6MDggKzAyMDAKU3ViamVjdDogW1BBVENIXSBJ
bnB1dDogZXZkZXY6IGRvbid0IGFzc3VtZSBBQlNfTUFYIHRvIGJlIGEgcG93ZXItb2YtMiBtaW51
cyAxCgpBQlNfTUFYIGlzIG5vIGxvbmdlciBhIGZ1bGwgbWFzay4gSGVuY2UsIGRvbid0IHVzZSBp
dCBkaXJlY3RseSB0byBnZXQgYW55CnBhcmFtZXRlciBmb3IgaW9jdGxzLiBGdXJ0aGVybW9yZSwg
dGhlIHBhcmFtZXRlci1yZWdpb24gYW5kCmlvY3RsLWRlZmluaXRpb24gb3ZlcmxhcCwgc28gZXZl
biBidW1waW5nIEFCU19NQVggdG8gMHg3ZiB3b3VsZG4ndCBoZWxwLgoKUmVwb3J0ZWQtYnk6IE1h
cmt1cyBUcmlwcGVsc2RvcmYgPG1hcmt1c0B0cmlwcGVsc2RvcmYuZGU+ClNpZ25lZC1vZmYtYnk6
IERhdmlkIEhlcnJtYW5uIDxkaC5oZXJybWFubkBnbWFpbC5jb20+Ci0tLQogZHJpdmVycy9pbnB1
dC9ldmRldi5jIHwgMTAgKysrKysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygr
KSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2lucHV0L2V2ZGV2LmMgYi9k
cml2ZXJzL2lucHV0L2V2ZGV2LmMKaW5kZXggZDJiMzRmYi4uODJlMDA3MyAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9pbnB1dC9ldmRldi5jCisrKyBiL2RyaXZlcnMvaW5wdXQvZXZkZXYuYwpAQCAtOTM5
LDEyICs5MzksMTMgQEAgc3RhdGljIGxvbmcgZXZkZXZfZG9faW9jdGwoc3RydWN0IGZpbGUgKmZp
bGUsIHVuc2lnbmVkIGludCBjbWQsCiAJCQkJCQlfSU9DX05SKGNtZCkgJiBFVl9NQVgsIHNpemUs
CiAJCQkJCQlwLCBjb21wYXRfbW9kZSk7CiAKLQkJaWYgKChfSU9DX05SKGNtZCkgJiB+QUJTX01B
WCkgPT0gX0lPQ19OUihFVklPQ0dBQlMoMCkpKSB7CisJCWlmIChfSU9DX05SKGNtZCkgPj0gX0lP
Q19OUihFVklPQ0dBQlMoMCkpICYmCisJCSAgICBfSU9DX05SKGNtZCkgPD0gX0lPQ19OUihFVklP
Q0dBQlMoQUJTX01BWCkpKSB7CiAKIAkJCWlmICghZGV2LT5hYnNpbmZvKQogCQkJCXJldHVybiAt
RUlOVkFMOwogCi0JCQl0ID0gX0lPQ19OUihjbWQpICYgQUJTX01BWDsKKwkJCXQgPSBfSU9DX05S
KGNtZCkgLSBfSU9DX05SKEVWSU9DR0FCUygwKSk7CiAJCQlhYnMgPSBkZXYtPmFic2luZm9bdF07
CiAKIAkJCWlmIChjb3B5X3RvX3VzZXIocCwgJmFicywgbWluX3Qoc2l6ZV90LApAQCAtOTU3LDEy
ICs5NTgsMTMgQEAgc3RhdGljIGxvbmcgZXZkZXZfZG9faW9jdGwoc3RydWN0IGZpbGUgKmZpbGUs
IHVuc2lnbmVkIGludCBjbWQsCiAKIAlpZiAoX0lPQ19ESVIoY21kKSA9PSBfSU9DX1dSSVRFKSB7
CiAKLQkJaWYgKChfSU9DX05SKGNtZCkgJiB+QUJTX01BWCkgPT0gX0lPQ19OUihFVklPQ1NBQlMo
MCkpKSB7CisJCWlmIChfSU9DX05SKGNtZCkgPj0gX0lPQ19OUihFVklPQ1NBQlMoMCkpICYmCisJ
CSAgICBfSU9DX05SKGNtZCkgPD0gX0lPQ19OUihFVklPQ1NBQlMoQUJTX01BWCkpKSB7CiAKIAkJ
CWlmICghZGV2LT5hYnNpbmZvKQogCQkJCXJldHVybiAtRUlOVkFMOwogCi0JCQl0ID0gX0lPQ19O
UihjbWQpICYgQUJTX01BWDsKKwkJCXQgPSBfSU9DX05SKGNtZCkgLSBfSU9DX05SKEVWSU9DU0FC
UygwKSk7CiAKIAkJCWlmIChjb3B5X2Zyb21fdXNlcigmYWJzLCBwLCBtaW5fdChzaXplX3QsCiAJ
CQkJCXNpemUsIHNpemVvZihzdHJ1Y3QgaW5wdXRfYWJzaW5mbykpKSkKLS0gCjEuOC40Cgo=
--089e01493b542f7c1804e5be058e--
