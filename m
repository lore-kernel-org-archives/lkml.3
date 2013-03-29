Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab3C2XQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 19:16:05 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:41084 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab3C2XQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 19:16:03 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyT6jxC=+jfORJkymo4Eagzpz-SajmnCO_PjGAPE6o25A@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
	<CA+55aFyKhgwYUMGs8MBLY5WDXhHwXP3dLWs40ayCYfgiwwncsQ@mail.gmail.com>
	<CA+55aFyT6jxC=+jfORJkymo4Eagzpz-SajmnCO_PjGAPE6o25A@mail.gmail.com>
Date: Fri, 29 Mar 2013 16:16:01 -0700
X-Google-Sender-Auth: moEl-vZ4xaaGLXl2iuvbQ7nHIUk
Message-ID: <CA+55aFygTH-tqhL1=FY32+HkjfqqpkX-nvb1c5f3V6S-iykS8A@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Emmanuel Benisty <benisty.e@gmail.com>
Content-Type: multipart/mixed; boundary=047d7b3a805e5fbd3404d9187486
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b3a805e5fbd3404d9187486
Content-Type: text/plain; charset=UTF-8

On Fri, Mar 29, 2013 at 2:12 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I dunno. I'm still not sure this is triggerable, but it looks bad. But
> both the semaphore case and the msg cases seem to be solvable by
> moving the unlock down, and shm seem to have no getref/putref users to
> race with, so this (whitespace-damaged) patch *may* be sufficient:

Well, the patch doesn't seem to cause any problems, at least neither
lockdep nor spinlock sleep debugging complains. I have no idea whether
it actually fixes any problems, though.

I do wonder if this might explain the problem Emmanuel saw. A double
free of a RCU-freeable object would possibly result in exactly the
kind of mess that Emmanuel reported with the semaphore scalability
patches.

Emmanuel, can you try the attached patch? I think it applies cleanly
on top of the scalability series too without any changes, but I didn't
check if the patches perhaps changed some of the naming or something.

              Linus

--047d7b3a805e5fbd3404d9187486
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hevyypa01

IGlwYy9tc2cuYyB8IDIgKy0KIGlwYy9zZW0uYyB8IDIgKy0KIDIgZmlsZXMgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2lwYy9tc2cuYyBiL2lw
Yy9tc2cuYwppbmRleCAzMWNkMWJmNmFmMjcuLjMzOGQ4ZTJiNTg5YiAxMDA2NDQKLS0tIGEvaXBj
L21zZy5jCisrKyBiL2lwYy9tc2cuYwpAQCAtMjg0LDcgKzI4NCw2IEBAIHN0YXRpYyB2b2lkIGZy
ZWVxdWUoc3RydWN0IGlwY19uYW1lc3BhY2UgKm5zLCBzdHJ1Y3Qga2Vybl9pcGNfcGVybSAqaXBj
cCkKIAlleHB1bmdlX2FsbChtc3EsIC1FSURSTSk7CiAJc3Nfd2FrZXVwKCZtc3EtPnFfc2VuZGVy
cywgMSk7CiAJbXNnX3JtaWQobnMsIG1zcSk7Ci0JbXNnX3VubG9jayhtc3EpOwogCiAJdG1wID0g
bXNxLT5xX21lc3NhZ2VzLm5leHQ7CiAJd2hpbGUgKHRtcCAhPSAmbXNxLT5xX21lc3NhZ2VzKSB7
CkBAIC0yOTcsNiArMjk2LDcgQEAgc3RhdGljIHZvaWQgZnJlZXF1ZShzdHJ1Y3QgaXBjX25hbWVz
cGFjZSAqbnMsIHN0cnVjdCBrZXJuX2lwY19wZXJtICppcGNwKQogCWF0b21pY19zdWIobXNxLT5x
X2NieXRlcywgJm5zLT5tc2dfYnl0ZXMpOwogCXNlY3VyaXR5X21zZ19xdWV1ZV9mcmVlKG1zcSk7
CiAJaXBjX3JjdV9wdXRyZWYobXNxKTsKKwltc2dfdW5sb2NrKG1zcSk7CiB9CiAKIC8qCmRpZmYg
LS1naXQgYS9pcGMvc2VtLmMgYi9pcGMvc2VtLmMKaW5kZXggNThkMzFmMWMxZWI1Li4xY2YwMjRi
OWVhYzAgMTAwNjQ0Ci0tLSBhL2lwYy9zZW0uYworKysgYi9pcGMvc2VtLmMKQEAgLTc2NiwxMiAr
NzY2LDEyIEBAIHN0YXRpYyB2b2lkIGZyZWVhcnkoc3RydWN0IGlwY19uYW1lc3BhY2UgKm5zLCBz
dHJ1Y3Qga2Vybl9pcGNfcGVybSAqaXBjcCkKIAogCS8qIFJlbW92ZSB0aGUgc2VtYXBob3JlIHNl
dCBmcm9tIHRoZSBJRFIgKi8KIAlzZW1fcm1pZChucywgc21hKTsKLQlzZW1fdW5sb2NrKHNtYSk7
CiAKIAl3YWtlX3VwX3NlbV9xdWV1ZV9kbygmdGFza3MpOwogCW5zLT51c2VkX3NlbXMgLT0gc21h
LT5zZW1fbnNlbXM7CiAJc2VjdXJpdHlfc2VtX2ZyZWUoc21hKTsKIAlpcGNfcmN1X3B1dHJlZihz
bWEpOworCXNlbV91bmxvY2soc21hKTsKIH0KIAogc3RhdGljIHVuc2lnbmVkIGxvbmcgY29weV9z
ZW1pZF90b191c2VyKHZvaWQgX191c2VyICpidWYsIHN0cnVjdCBzZW1pZDY0X2RzICppbiwgaW50
IHZlcnNpb24pCg==
--047d7b3a805e5fbd3404d9187486--
