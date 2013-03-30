Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab3C3Edf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 00:33:35 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:38633 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab3C3Ede (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 00:33:34 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzqzHa_6bHrqaa+6k3PZiibuJuDd1VwVD7jL047BjR=hA@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
	<CA+55aFyKhgwYUMGs8MBLY5WDXhHwXP3dLWs40ayCYfgiwwncsQ@mail.gmail.com>
	<CA+55aFyT6jxC=+jfORJkymo4Eagzpz-SajmnCO_PjGAPE6o25A@mail.gmail.com>
	<CA+55aFygTH-tqhL1=FY32+HkjfqqpkX-nvb1c5f3V6S-iykS8A@mail.gmail.com>
	<CA+i8gK+NTCK6OUzobvxPj+UaCO-iit-ww9VGNzmdqDfRC_+SuA@mail.gmail.com>
	<1364609309.1818.8.camel@buesod1.americas.hpqcorp.net>
	<CA+i8gK+LP_4SU8GwLMau0QvyGswZ5sKqOYnJVPZNWXZY_W9dEA@mail.gmail.com>
	<CA+55aFzqzHa_6bHrqaa+6k3PZiibuJuDd1VwVD7jL047BjR=hA@mail.gmail.com>
Date: Sat, 30 Mar 2013 11:33:30 +0700
Message-ID: <CA+i8gKL3PCBW_KxkYSOKE7-PHdHVsP6eLUBTuYRtunBheALJMg@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Content-Type: multipart/mixed; boundary=bcaec51b12f9d07b7804d91ce3f3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec51b12f9d07b7804d91ce3f3
Content-Type: text/plain; charset=UTF-8

On Sat, Mar 30, 2013 at 10:46 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Mar 29, 2013 at 8:02 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>>
>> Then I start building a random package and the problems start. They
>> may also happen without compiling but this seems to trigger the bug
>> quite quickly.
>
> I suspect it's about preemption, and the build just results in enough
> scheduling load that you start hitting whatever race there is.
>
>> Anyway, some progress here, I hope: dmesg seems to be
>> willing to reveal some secrets (using some pastebin service since this
>> is pretty big):
>>
>> https://gist.github.com/anonymous/5275120
>
> That looks like exactly the exit_sem() bug that Davidlohr was talking
> about, where the
>
>                 /* exit_sem raced with IPC_RMID, nothing to do */
>                 if (IS_ERR(sma))
>                         continue;
>
> should be moved to *before* the
>
>                 sem_lock(sma, NULL, -1);
>
> call. And apparently the bug I had found is already fixed in -next.

I just tried the 7 original patches + the 2 one liners from -next +
modified Linus' patch (attached) on the top of 3.9-rc4 using
PREEMPT_NONE and after moving sem_lock(sma, NULL, -1) as explained
above. I was building two packages at the same time, went away for 30
seconds, came back and everything froze as soon as I touched the
laptop's touchpad. Maybe a coincidence but anyway... Another shot in
the dark, I had this weird message when trying to build gcc:
semop(2): encountered an error: Identifier removed

--bcaec51b12f9d07b7804d91ce3f3
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hewa01fi0

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
dCBmcm9tIHRoZSBJRFIgKi8KIAlzZW1fcm1pZChucywgc21hKTsKLQlzZW1fdW5sb2NrKHNtYSwg
LTEpOwogCiAJd2FrZV91cF9zZW1fcXVldWVfZG8oJnRhc2tzKTsKIAlucy0+dXNlZF9zZW1zIC09
IHNtYS0+c2VtX25zZW1zOwogCXNlY3VyaXR5X3NlbV9mcmVlKHNtYSk7CiAJaXBjX3JjdV9wdXRy
ZWYoc21hKTsKKwlzZW1fdW5sb2NrKHNtYSwgLTEpOwogfQogCiBzdGF0aWMgdW5zaWduZWQgbG9u
ZyBjb3B5X3NlbWlkX3RvX3VzZXIodm9pZCBfX3VzZXIgKmJ1Ziwgc3RydWN0IHNlbWlkNjRfZHMg
KmluLCBpbnQgdmVyc2lvbikK
--bcaec51b12f9d07b7804d91ce3f3--
