Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaKLNIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:08:12 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:37112 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaKLNIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:08:10 -0500
MIME-Version: 1.0
In-Reply-To: <20141110144954.GC10422@katana>
References: <CAAVjN7cpGzokOntyyGVBksdvAw7rGt8zvggpCeMqr+g1yHEyzg@mail.gmail.com>
	<20141110144954.GC10422@katana>
Date: Wed, 12 Nov 2014 05:08:09 -0800
Message-ID: <CAAVjN7fsZC6V7bsJQLNmEx=yOmvsDn2ZwfOHNLd_=_jAbYB2dA@mail.gmail.com>
Subject: Re: [PATCH] i2c: mpc: Report correct I2C error codes on Freescale MPC
 i2c bus driver
From: Danielle Costantino <danielle.costantino@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e0122a3fa5a2d5e0507a916b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0122a3fa5a2d5e0507a916b8
Content-Type: text/plain; charset=UTF-8

From: Danielle Costantino <danielle.costantino@gmail.com>
Subject: [PATCH v2] i2c: mpc: report correct I2C error return codes

This patch enforces correct I2C error returned codes from Freescale's
MPC i2c bus driver, allowing for proper user-space/kernel error
handling.

Signed-off-by: Danielle Costantino <danielle.costantino@gmail.com>

diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index 0edf630..4c5d7d9 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -124,7 +124,7 @@
 static int i2c_wait(struct mpc_i2c *i2c, unsigned timeout, int writing)
 {
  unsigned long orig_jiffies = jiffies;
- u32 x;
+ u32 cmd_err;
  int result = 0;

  if (!i2c->irq) {
@@ -133,11 +133,11 @@
  if (time_after(jiffies, orig_jiffies + timeout)) {
  dev_dbg(i2c->dev, "timeout\n");
  writeccr(i2c, 0);
- result = -EIO;
+ result = -ETIMEDOUT;
  break;
  }
  }
- x = readb(i2c->base + MPC_I2C_SR);
+ cmd_err = readb(i2c->base + MPC_I2C_SR);
  writeb(0, i2c->base + MPC_I2C_SR);
  } else {
  /* Interrupt mode */
@@ -150,28 +150,28 @@
  result = -ETIMEDOUT;
  }

- x = i2c->interrupt;
+ cmd_err = i2c->interrupt;
  i2c->interrupt = 0;
  }

  if (result < 0)
  return result;

- if (!(x & CSR_MCF)) {
+ if (!(cmd_err & CSR_MCF)) {
  dev_dbg(i2c->dev, "unfinished\n");
  return -EIO;
  }

- if (x & CSR_MAL) {
+ if (cmd_err & CSR_MAL) {
  dev_dbg(i2c->dev, "MAL\n");
- return -EIO;
+ return -EAGAIN;
  }

- if (writing && (x & CSR_RXAK)) {
+ if (writing && (cmd_err & CSR_RXAK)) {
  dev_dbg(i2c->dev, "No RXAK\n");
  /* generate stop */
  writeccr(i2c, CCR_MEN);
- return -EIO;
+ return -ENXIO;
  }
  return 0;
 }

On Mon, Nov 10, 2014 at 6:49 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Tue, Oct 21, 2014 at 12:05:44AM -0700, Danielle Costantino wrote:
>> From: Danielle Costantino <danielle.costantino@gmail.com>
>>
>> This patch enforces correct I2C error returned codes from Freescale's
>> MPC i2c bus driver, allowing for proper user-space/kernel error
>> handling.
>>
>> Signed-off-by: Danielle Costantino <danielle.costantino@gmail.com>
>
> Tabs converted to spaces here? Please resend properly.
>



-- 
- Danielle Costantino

--089e0122a3fa5a2d5e0507a916b8
Content-Type: text/x-patch; charset=US-ASCII; 
	name="i2c-mpc-report-correct-I2C-error-return-codes.patch"
Content-Disposition: attachment; 
	filename="i2c-mpc-report-correct-I2C-error-return-codes.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i2ep6hq31

RnJvbTogRGFuaWVsbGUgQ29zdGFudGlubyA8ZGFuaWVsbGUuY29zdGFudGlub0BnbWFpbC5jb20+
ClN1YmplY3Q6IFtQQVRDSCB2Ml0gaTJjOiBtcGM6IHJlcG9ydCBjb3JyZWN0IEkyQyBlcnJvciBy
ZXR1cm4gY29kZXMKClRoaXMgcGF0Y2ggZW5mb3JjZXMgY29ycmVjdCBJMkMgZXJyb3IgcmV0dXJu
ZWQgY29kZXMgZnJvbSBGcmVlc2NhbGUncwpNUEMgaTJjIGJ1cyBkcml2ZXIsIGFsbG93aW5nIGZv
ciBwcm9wZXIgdXNlci1zcGFjZS9rZXJuZWwgZXJyb3IKaGFuZGxpbmcuCgpTaWduZWQtb2ZmLWJ5
OiBEYW5pZWxsZSBDb3N0YW50aW5vIDxkYW5pZWxsZS5jb3N0YW50aW5vQGdtYWlsLmNvbT4KCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2kyYy9idXNzZXMvaTJjLW1wYy5jIGIvZHJpdmVycy9pMmMvYnVz
c2VzL2kyYy1tcGMuYwppbmRleCAwZWRmNjMwLi40YzVkN2Q5IDEwMDY0NAotLS0gYS9kcml2ZXJz
L2kyYy9idXNzZXMvaTJjLW1wYy5jCisrKyBiL2RyaXZlcnMvaTJjL2J1c3Nlcy9pMmMtbXBjLmMK
QEAgLTEyNCw3ICsxMjQsNyBAQAogc3RhdGljIGludCBpMmNfd2FpdChzdHJ1Y3QgbXBjX2kyYyAq
aTJjLCB1bnNpZ25lZCB0aW1lb3V0LCBpbnQgd3JpdGluZykKIHsKIAl1bnNpZ25lZCBsb25nIG9y
aWdfamlmZmllcyA9IGppZmZpZXM7Ci0JdTMyIHg7CisJdTMyIGNtZF9lcnI7CiAJaW50IHJlc3Vs
dCA9IDA7CiAKIAlpZiAoIWkyYy0+aXJxKSB7CkBAIC0xMzMsMTEgKzEzMywxMSBAQAogCQkJaWYg
KHRpbWVfYWZ0ZXIoamlmZmllcywgb3JpZ19qaWZmaWVzICsgdGltZW91dCkpIHsKIAkJCQlkZXZf
ZGJnKGkyYy0+ZGV2LCAidGltZW91dFxuIik7CiAJCQkJd3JpdGVjY3IoaTJjLCAwKTsKLQkJCQly
ZXN1bHQgPSAtRUlPOworCQkJCXJlc3VsdCA9IC1FVElNRURPVVQ7CiAJCQkJYnJlYWs7CiAJCQl9
CiAJCX0KLQkJeCA9IHJlYWRiKGkyYy0+YmFzZSArIE1QQ19JMkNfU1IpOworCQljbWRfZXJyID0g
cmVhZGIoaTJjLT5iYXNlICsgTVBDX0kyQ19TUik7CiAJCXdyaXRlYigwLCBpMmMtPmJhc2UgKyBN
UENfSTJDX1NSKTsKIAl9IGVsc2UgewogCQkvKiBJbnRlcnJ1cHQgbW9kZSAqLwpAQCAtMTUwLDI4
ICsxNTAsMjggQEAKIAkJCXJlc3VsdCA9IC1FVElNRURPVVQ7CiAJCX0KIAotCQl4ID0gaTJjLT5p
bnRlcnJ1cHQ7CisJCWNtZF9lcnIgPSBpMmMtPmludGVycnVwdDsKIAkJaTJjLT5pbnRlcnJ1cHQg
PSAwOwogCX0KIAogCWlmIChyZXN1bHQgPCAwKQogCQlyZXR1cm4gcmVzdWx0OwogCi0JaWYgKCEo
eCAmIENTUl9NQ0YpKSB7CisJaWYgKCEoY21kX2VyciAmIENTUl9NQ0YpKSB7CiAJCWRldl9kYmco
aTJjLT5kZXYsICJ1bmZpbmlzaGVkXG4iKTsKIAkJcmV0dXJuIC1FSU87CiAJfQogCi0JaWYgKHgg
JiBDU1JfTUFMKSB7CisJaWYgKGNtZF9lcnIgJiBDU1JfTUFMKSB7CiAJCWRldl9kYmcoaTJjLT5k
ZXYsICJNQUxcbiIpOwotCQlyZXR1cm4gLUVJTzsKKwkJcmV0dXJuIC1FQUdBSU47CiAJfQogCi0J
aWYgKHdyaXRpbmcgJiYgKHggJiBDU1JfUlhBSykpIHsKKwlpZiAod3JpdGluZyAmJiAoY21kX2Vy
ciAmIENTUl9SWEFLKSkgewogCQlkZXZfZGJnKGkyYy0+ZGV2LCAiTm8gUlhBS1xuIik7CiAJCS8q
IGdlbmVyYXRlIHN0b3AgKi8KIAkJd3JpdGVjY3IoaTJjLCBDQ1JfTUVOKTsKLQkJcmV0dXJuIC1F
SU87CisJCXJldHVybiAtRU5YSU87CiAJfQogCXJldHVybiAwOwogfQo=
--089e0122a3fa5a2d5e0507a916b8--
