Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab3DWSGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:06:08 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:35666 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab3DWSGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:06:06 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1366738610.1802.9.camel@buesod1.americas.hpqcorp.net>
References: <20130423122905.33ac0d3c@annuminas.surriel.com>
	<1366738610.1802.9.camel@buesod1.americas.hpqcorp.net>
Date: Tue, 23 Apr 2013 20:06:04 +0200
Message-ID: <CA+icZUVw4HR8WT-9AmBMW0A9+iH04_ByZeuQo=TUqd9ZYNKhgQ@mail.gmail.com>
Subject: Re: [PATCH -mm] ipc,sem: fix locking in semctl_main
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Emmanuel Benisty <benisty.e@gmail.com>
Content-Type: multipart/mixed; boundary=f46d044286caea636e04db0b091b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d044286caea636e04db0b091b
Content-Type: text/plain; charset=UTF-8

On Tue, Apr 23, 2013 at 7:36 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> On Tue, 2013-04-23 at 12:29 -0400, Rik van Riel wrote:
>> Andrew, here is the patch I promised :)
>>
>> Everywhere else in the code, we check sma->sem_perm.deleted under
>> the semaphore array lock, so we should do teh same here.
>> The easy fix is to simply not drop and re-take the lock, but keep
>> it locked.
>>
>
> CCing Linus, Sedat and Emmanuel.
>
> This looks very much like a patch I asked Sedat to test during the
> weekend, which according to him didn't solve his issue. The patch is
> correct in any case.
>

Your patch looked a bit different (checked for ipc-lock already taken,
both patches - original and refreshed againt -next attached).

- Sedat -

>> This patch can be folded into ipcsem-fine-grained-locking-for-semtimedop.patch
>>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
>
> Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
>
>> ---
>>  ipc/sem.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/ipc/sem.c b/ipc/sem.c
>> index 5711616..efdaee6 100644
>> --- a/ipc/sem.c
>> +++ b/ipc/sem.c
>> @@ -1243,10 +1243,9 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
>>                               err = -EIDRM;
>>                               goto out_free;
>>                       }
>> -                     sem_unlock(sma, -1);
>> -             }
>> +             } else
>> +                     sem_lock(sma, NULL, -1);
>>
>> -             sem_lock(sma, NULL, -1);
>>               for (i = 0; i < sma->sem_nsems; i++)
>>                       sem_io[i] = sma->sem_base[i].semval;
>>               sem_unlock(sma, -1);
>
>

--f46d044286caea636e04db0b091b
Content-Type: application/octet-stream; name="ipc-fix.patch"
Content-Disposition: attachment; filename="ipc-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hfvdwz950

RnJvbTogRGF2aWRsb2hyIEJ1ZXNvIDxkYXZpZGxvaHIuYnVlc29AaHAuY29tPiANCg0KU3ViamVj
dDogaXBjOiBzZW06IENoZWNrIGlmIHRoZSBpcGMgbG9jayBoYXMgYmVlbiBhbHJlYWR5IHRha2Vu
DQoNCk9yaWdpbmFsIHBhdGNoIGZyb20gWzFdLg0KDQpbMV0gaHR0cDovL21hcmMuaW5mby8/dD0x
MzY2MzE0NTc5MDAwMDUmcj0xJnc9Mg0KDQpkaWZmIC0tZ2l0IGEvaXBjL3NlbS5jIGIvaXBjL3Nl
bS5jDQppbmRleCA1NzExNjE2Li4xZGZjM2MxIDEwMDY0NA0KLS0tIGEvaXBjL3NlbS5jDQorKysg
Yi9pcGMvc2VtLmMNCkBAIC0xMjQzLDEwICsxMjQzLDExIEBAIHN0YXRpYyBpbnQgc2VtY3RsX21h
aW4oc3RydWN0IGlwY19uYW1lc3BhY2UgKm5zLCBpbnQgc2VtaWQsIGludCBzZW1udW0sDQogCQkJ
CWVyciA9IC1FSURSTTsNCiAJCQkJZ290byBvdXRfZnJlZTsNCiAJCQl9DQotCQkJc2VtX3VubG9j
ayhzbWEsIC0xKTsNCiAJCX0NCiANCi0JCXNlbV9sb2NrKHNtYSwgTlVMTCwgLTEpOw0KKwkJLyog
aGFzIHRoZSBpcGMgbG9jayBhbHJlYWR5IGJlZW4gdGFrZW4/ICovDQorCQlpZihuc2VtcyA8PSBT
RU1NU0xfRkFTVCkNCisJCQlzZW1fbG9jayhzbWEsIE5VTEwsIC0xKTsNCiAJCWZvciAoaSA9IDA7
IGkgPCBzbWEtPnNlbV9uc2VtczsgaSsrKQ0KIAkJCXNlbV9pb1tpXSA9IHNtYS0+c2VtX2Jhc2Vb
aV0uc2VtdmFsOw0KIAkJc2VtX3VubG9jayhzbWEsIC0xKTsNCg==
--f46d044286caea636e04db0b091b
Content-Type: application/octet-stream; name="ipc-fix-v2.patch"
Content-Disposition: attachment; filename="ipc-fix-v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hfvdx1hx1

RnJvbTogRGF2aWRsb2hyIEJ1ZXNvIDxkYXZpZGxvaHIuYnVlc29AaHAuY29tPiAKClN1YmplY3Q6
IGlwYywgc2VtOiBDaGVjayBpZiB0aGUgaXBjIGxvY2sgaGFzIGJlZW4gYWxyZWFkeSB0YWtlbgoK
T3JpZ2luYWwgcGF0Y2ggZnJvbSBbMV0uCgpbIGRpbGVrczogdjI6IEFkYXB0ZWQgdG8gZml0IG5l
eHQtMjAxMzA0MTkgcGx1cyAzIGlwYy1zZW0tbmV4dCBwYXRjaGVzIGZyb20gWzJdIF0KClsxXSBo
dHRwOi8vbWFyYy5pbmZvLz90PTEzNjYzMTQ1NzkwMDAwNSZyPTEmdz0yClsyXSBodHRwOi8vbWFy
Yy5pbmZvLz9sPWxpbnV4LW5leHQmbT0xMzY2NDAyMzM2MDE5MTMmdz0yCgpkaWZmIC0tZ2l0IGEv
aXBjL3NlbS5jIGIvaXBjL3NlbS5jCmluZGV4IGFjYWRhOWYuLmQ5MGRhNDcgMTAwNjQ0Ci0tLSBh
L2lwYy9zZW0uYworKysgYi9pcGMvc2VtLmMKQEAgLTEyNTksMTAgKzEyNTksMTEgQEAgc3RhdGlj
IGludCBzZW1jdGxfbWFpbihzdHJ1Y3QgaXBjX25hbWVzcGFjZSAqbnMsIGludCBzZW1pZCwgaW50
IHNlbW51bSwKIAkJCQllcnIgPSAtRUlEUk07CiAJCQkJZ290byBvdXRfZnJlZTsKIAkJCX0KLQkJ
CXNlbV91bmxvY2soc21hLCAtMSk7CiAJCX0KIAotCQlzZW1fbG9jayhzbWEsIE5VTEwsIC0xKTsK
KwkJLyogaGFzIHRoZSBpcGMgbG9jayBhbHJlYWR5IGJlZW4gdGFrZW4/ICovCisJCWlmIChuc2Vt
cyA8PSBTRU1NU0xfRkFTVCkKKwkJCXNlbV9sb2NrKHNtYSwgTlVMTCwgLTEpOwogCQlmb3IgKGkg
PSAwOyBpIDwgc21hLT5zZW1fbnNlbXM7IGkrKykKIAkJCXNlbV9pb1tpXSA9IHNtYS0+c2VtX2Jh
c2VbaV0uc2VtdmFsOwogCQlzZW1fdW5sb2NrKHNtYSwgLTEpOwo=
--f46d044286caea636e04db0b091b--
