Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab3EYUAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 16:00:22 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:40803 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763Ab3EYUAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 16:00:21 -0400
Message-ID: <51A11851.2010303@colorfullife.com>
Date: Sat, 25 May 2013 22:00:17 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] ipc/sem.c: fix lockup, restore FIFO behavior
References: <1369495011-2586-1-git-send-email-manfred@colorfullife.com> <51A0FB23.3050301@redhat.com> <1369506721.2065.10.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1369506721.2065.10.camel@buesod1.americas.hpqcorp.net>
Content-Type: multipart/mixed;
 boundary="------------090106010201010108050404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090106010201010108050404
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/25/2013 08:32 PM, Davidlohr Bueso wrote:
> Yep, could you please explain what benefits you see in keeping FIFO order?
a) It's user space visible.

b) It's a well-defined behavior that might even make sense for some 
applications.
     Right now, a 2 semop operation with "+1, then -2" is priorized over 
a semop with "-1".

And: It doesn't cost much:
- no impact for users that use only single-op operations.
- no impact for users that use only multi-op operations
- for users that use both types: In the worst case some linked list 
splicing.

Actually, the code is probably faster because wait-for-zero ops are only 
scanned when the semaphore values are 0.

>> Acked-by: Rik van Riel <riel@redhat.com>
>>
>>> - simpler check_restart logic.
>>> - Efficient handling of wait-for-zero semops, both simple and complex.
>>> - Fewer restarts in update_queue(), because pending wait-for-zero do not
>>>     force a restart anymore.
>>>
>>> Other changes:
>>> - try_atomic_semop() also performs the semop. Thus rename the function.
>>>
>>> It passes tests with qemu, but not boot-tested due to EFI problems.
> I think this still needs a *lot* of testing - I don't have my Oracle
> workload available right now, but I will definitely see how this patch
> behaves on it. That said, I believe Oracle is are already quite happy
> with the sem improvements.
Ah, ok.
The change is good for one application and the risk of breaking other 
apps is considered as negligible.

>
> Furthermore, this patch is way too invasive for considering it for 3.10
> - I like Rik's patch better because it simply addresses the issue and
> nothing more.
I would disagree:
My patch is testable - with it applied, linux-3.0.10 should behave 
exactly as linux-3.0.9.
Except the scalability - the new sem_lock from Rik is great.

My problem with Rik's patch is that it is untestable:
It changes the behavior and we must hope that nothing breaks.

Actually, the latest patch makes it a bit worse:
> @@ -720,16 +718,11 @@ static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
>   
>   		unlink_queue(sma, q);
>   
> -		if (error) {
> -			restart = 0;
> -		} else {
> -			semop_completed = 1;
> -			restart = check_restart(sma, q);
> -		}
> +		semop_completed = 1;
> +		if (check_restart(sma, q))
> +			*restart = 1;
>   
>   		wake_up_sem_queue_prepare(pt, q, error);
> -		if (restart)
> -			goto again;
If check_restart returns "1", then the current (3.0.10-rc1) code 
restarts immediately ("goto a again").
Now the rest of the queue is processed completely and only afterwards it 
is scanned again.

This means that wait-for-zero now succeeds only if a semaphore value 
stays zero.
For 3.0.9, it was sufficient if the value was temporarily zero.
Before the change, complex wait-for-zero would work, only simple 
wait-for-zero would be starved.
Now all operations are starved.

I've attached a test case:
     ./test5.sh
linux-3.0.9 completes all operations
With Rik's patch, the wait-for-zero remains running.

--
     Manfred

P.S.:
Btw, I found some code that uses a semop with 2 ops:
http://publib.boulder.ibm.com/infocenter/iseries/v5r3/index.jsp?topic=%2Fapis%2Fapiexusmem.htm

--------------090106010201010108050404
Content-Type: text/plain; charset=UTF-8;
 name="change.c"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="change.c"

LyoKICogQ29weXJpZ2h0IChDKSAxOTk5IGJ5IE1hbmZyZWQgU3ByYXVsLgogKiAKICogUmVk
aXN0cmlidXRpb24gb2YgdGhpcyBmaWxlIGlzIHBlcm1pdHRlZCB1bmRlciB0aGUgdGVybXMg
b2YgdGhlIEdOVSAKICogR2VuZXJhbCBQdWJsaWMgTGljZW5zZSAoR1BMKQogKiAkSGVhZGVy
OiAvaG9tZS9tYW5mcmVkL2N2cy10cmVlL21hbmZyZWQvaXBjc2VtL2RlYy5jLHYgMS41IDIw
MDMvMDYvMTcgMTY6MTY6NTUgbWFuZnJlZCBFeHAgJAogKi8KCiNpbmNsdWRlIDxzeXMvdHlw
ZXMuaD4KI2luY2x1ZGUgPHN5cy9zZW0uaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVk
ZSA8c3RkbGliLmg+CiNpbmNsdWRlIDxzdGRpby5oPgojaW5jbHVkZSA8ZXJybm8uaD4KI2lu
Y2x1ZGUgPHN0cmluZy5oPgojaW5jbHVkZSA8YXNzZXJ0Lmg+CgojZGVmaW5lIFRSVUUJMQoj
ZGVmaW5lIEZBTFNFCTAKCnVuaW9uIHNlbXVuIHsKCWludCB2YWw7CglzdHJ1Y3Qgc2VtaWRf
ZHMgKmJ1ZjsKCXVuc2lnbmVkIHNob3J0IGludCAqYXJyYXk7CglzdHJ1Y3Qgc2VtaW5mbyog
X19idWY7Cn07CgoKaW50IG1haW4oaW50IGFyZ2MsY2hhcioqIGFyZ3YpCnsKCWludCBpZDsK
CWludCBrZXk7CglpbnQgcmVzOwoJaW50ICpucjsKCWludCAqdmFsOwoJaW50IGk7CglpbnQg
c2VtczsKCglwcmludGYoImNoYW5nZSA8aWQ+IDxzZW1udW0+IDxjaGFuZ2U+IFsuLi5dXG4i
KTsKCWlmKGFyZ2MgPCA0IHx8ICgoYXJnYyAlIDIpID09IDEpKSB7CgkJcHJpbnRmKCJJbnZh
bGlkIHBhcmFtZXRlcnMuXG4iKTsKCQlyZXR1cm4gMTsKCX0KCQoJa2V5ID0gYXRvaShhcmd2
WzFdKTsKCWlmKGtleSA9PSAwKSB7CgkJcHJpbnRmKCJJbnZhbGlkIHBhcmFtZXRlcnM6IEtl
eSBpbnZhbGlkLlxuIik7CgkJcmV0dXJuIDE7Cgl9CglpZiAoa2V5ID4gMCkgewoJCWlkID0g
c2VtZ2V0KGtleSwxLDApOwoJCWlmKGlkID09IC0xKSB7CgkJCXByaW50ZigiIGZpbmRrZXko
KSBmYWlsZWQuXG4iKTsKCQkJcmV0dXJuIDE7CgkJfQoJfSBlbHNlIHsKCQlpZCA9IC1rZXk7
CgkJcHJpbnRmKCIgZmluZGtleSgpIGJ5cGFzc2VkLCB1c2luZyBpZCAlZC5cbiIsIGlkKTsK
CX0KCXNlbXMgPSAoYXJnYy0yKS8yOwoJbnI9KGludCopbWFsbG9jKHNpemVvZihpbnQpKnNl
bXMpOwoJdmFsPShpbnQqKW1hbGxvYyhzaXplb2YoaW50KSpzZW1zKTsKCWlmICghbnIgfHwg
IXZhbCkgewoJCXByaW50ZigiTWFsbG9jIGZhaWxlZC5cbiIpOwoJCXJldHVybiAxOwoJfQoJ
cHJpbnRmKCJwaWQgJWQ6IGNoYW5naW5nICVkIHNlbWFwaG9yZXM6XG4iLGdldHBpZCgpLCBz
ZW1zKTsKCWZvciAoaT0wO2k8c2VtcztpKyspIHsKCQlucltpXSA9IGF0b2koYXJndlsyKzIq
aV0pOwoJCXZhbFtpXSA9IGF0b2koYXJndlszKzIqaV0pOwoJCXByaW50ZigiICAgICAgIHNl
bSAlM2QgYnkgJTJkXG4iLG5yW2ldLHZhbFtpXSk7Cgl9CgoKCXsKCQlzdHJ1Y3Qgc2VtYnVm
ICpzb3A7CgoJCXNvcCA9IG1hbGxvYyhzaXplb2YoKnNvcCkqc2Vtcyk7CgkJaWYgKCFzb3Ap
IHsKCQkJcHJpbnRmKCJtYWxsb2MoKSBmYWlsZWQuXG4iKTsKCQkJcmV0dXJuIDE7CgkJfQoJ
CWZvciAoaT0wO2k8c2VtcztpKyspIHsKCQkJc29wW2ldLnNlbV9udW09bnJbaV07CgkJCXNv
cFtpXS5zZW1fb3A9dmFsW2ldOwoJCQlzb3BbaV0uc2VtX2ZsZz0wOwoJCX0KCgkJcmVzID0g
c2Vtb3AoaWQsc29wLHNlbXMpOwoJCWlmKHJlcz09LTEpIHsKCQkJcHJpbnRmKCJwaWQgJWQ6
IHNlbW9wKCkgZmFpbGVkLCBlcnJubyAlZC5cbiIsIGdldHBpZCgpLCBlcnJubyk7CgkJCXJl
dHVybiAxOwoJCX0KCX0KCXByaW50ZigicGlkICVkOiBzZW1vcCgpIHN1Y2Nlc3NmdWwuXG4i
LCBnZXRwaWQoKSk7CglyZXR1cm4gMDsKfQo=
--------------090106010201010108050404
Content-Type: text/plain; charset=UTF-8;
 name="createary.c"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="createary.c"

LyoKICogQ29weXJpZ2h0IChDKSAxOTk5IGJ5IE1hbmZyZWQgU3ByYXVsLgogKiAKICogUmVk
aXN0cmlidXRpb24gb2YgdGhpcyBmaWxlIGlzIHBlcm1pdHRlZCB1bmRlciB0aGUgdGVybXMg
b2YgdGhlIEdOVSAKICogR2VuZXJhbCBQdWJsaWMgTGljZW5zZSAoR1BMKQogKiAkSGVhZGVy
OiAvaG9tZS9tYW5mcmVkL2N2cy10cmVlL21hbmZyZWQvaXBjc2VtL2NyZWF0ZWFyeS5jLHYg
MS4zIDIwMDMvMDYvMTcgMTY6MTY6NTUgbWFuZnJlZCBFeHAgJAogKi8KCiNpbmNsdWRlIDxz
eXMvc2VtLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNs
dWRlIDxzdHJpbmcuaD4KCgppbnQgbWFpbihpbnQgYXJnYyxjaGFyKiogYXJndikKewoJaW50
IGlkLCBuc2VtcywgcmVzLCBwZXJtczsKCglwcmludGYoImNyZWF0ZWFyeSA8aWQ+IDxuc2Vt
cz4gWzxwZXJtcz5dXG4iKTsKCWlmKGFyZ2MgPCAzIHx8IGFyZ2MgPiA0KSB7CgkJcHJpbnRm
KCJJbnZhbGlkIHBhcmFtZXRlcnMuXG4iKTsKCQlyZXR1cm4gMTsKCX0KCWlkID0gYXRvaShh
cmd2WzFdKTsKCWlmKGlkIDw9IDApIHsKCQlwcmludGYoIkludmFsaWQgcGFyYW1ldGVycy5c
biIpOwoJCXJldHVybiAxOwoJfQoJbnNlbXMgPSBhdG9pKGFyZ3ZbMl0pOwoJaWYobnNlbXMg
PD0gMCkgewoJCXByaW50ZigiSW52YWxpZCBwYXJhbWV0ZXJzLlxuIik7CgkJcmV0dXJuIDE7
Cgl9CQoJaWYgKGFyZ2MgPiAzKSB7CgkJcGVybXMgPSBhdG9pKGFyZ3ZbM10pOwoJfSBlbHNl
IHsKCQlwZXJtcyA9IDA3Nzc7Cgl9CglyZXMgPSBzZW1nZXQoaWQsIG5zZW1zLCBwZXJtcyB8
IElQQ19DUkVBVCk7CglpZihyZXMgPT0gLTEpIHsKCQlwcmludGYoIiBjcmVhdGUgZmFpbGVk
LlxuIik7CgkJcmV0dXJuIDE7Cgl9CglyZXR1cm4gMDsKfQo=
--------------090106010201010108050404
Content-Type: text/plain; charset=UTF-8;
 name="Makefile"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Makefile"

T1VUX0ZJTEVTPWNyZWF0ZWFyeSByZW1vdmVhcnkgY2hhbmdlCgpDRkxBR1MgPSAtV2FsbCAt
ZyAtTzIgLXB0aHJlYWQKTEZMQUdTID0gLXN0YXRpYwojTEZMQUdTID0KCkNDPWdjYwpDUFA9
ZysrCgolOgklLmNwcAoJJChDUFApICQoQ0ZMQUdTKSAtbyAkQCAkPCAkKExGTEFHUykKCiU6
CSUuYwoJJChDQykgJChDRkxBR1MpIC1vICRAICQ8ICQoTEZMQUdTKQoKYWxsOiAkKE9VVF9G
SUxFUykKCmNsZWFuOgoJcm0gLWYgJChPVVRfRklMRVMpCglybSAtZiAqfgoK
--------------090106010201010108050404
Content-Type: text/plain; charset=UTF-8;
 name="removeary.c"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="removeary.c"

LyoKICogQ29weXJpZ2h0IChDKSAxOTk5IGJ5IE1hbmZyZWQgU3ByYXVsLgogKiAKICogUmVk
aXN0cmlidXRpb24gb2YgdGhpcyBmaWxlIGlzIHBlcm1pdHRlZCB1bmRlciB0aGUgdGVybXMg
b2YgdGhlIEdOVSAKICogR2VuZXJhbCBQdWJsaWMgTGljZW5zZSAoR1BMKQogKiAkSGVhZGVy
OiAvaG9tZS9tYW5mcmVkL2N2cy10cmVlL21hbmZyZWQvaXBjc2VtL3JlbW92ZWFyeS5jLHYg
MS4zIDIwMDMvMDYvMTcgMTY6MTY6NTUgbWFuZnJlZCBFeHAgJAogKi8KCiNpbmNsdWRlIDxz
eXMvc2VtLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNs
dWRlIDxzdHJpbmcuaD4KCnVuaW9uIHNlbXVuIHsKCWludCB2YWw7CglzdHJ1Y3Qgc2VtaWRf
ZHMgKmJ1ZjsKCXVuc2lnbmVkIHNob3J0IGludCAqYXJyYXk7CglzdHJ1Y3Qgc2VtaW5mbyog
X19idWY7Cn07CgppbnQgbWFpbihpbnQgYXJnYyxjaGFyKiogYXJndikKewoJaW50IGlkOwoJ
aW50IHJlczsKCXVuaW9uIHNlbXVuIGFyZzsKCglwcmludGYoInJlbW92ZWFyeSA8aWQ+XG4i
KTsKCWlmKGFyZ2MgIT0gMikgewoJCXByaW50ZigiSW52YWxpZCBwYXJhbWV0ZXJzLlxuIik7
CgkJcmV0dXJuIDE7Cgl9CglpZCA9IGF0b2koYXJndlsxXSk7CglpZihpZCA8PSAwKSB7CgkJ
cHJpbnRmKCJJbnZhbGlkIHBhcmFtZXRlcnMuXG4iKTsKCQlyZXR1cm4gMTsKCX0KCXJlcyA9
IHNlbWdldChpZCwxLDApOwoJaWYocmVzID09IC0xKSB7CgkJcHJpbnRmKCIgb3BlbiBmYWls
ZWQuXG4iKTsKCQlyZXR1cm4gMTsKCX0KCWlkID0gcmVzOwoJcmVzID0gc2VtY3RsKGlkLDEs
SVBDX1JNSUQsYXJnKTsKCWlmKHJlcyA9PSAtMSkgewoJCXByaW50ZigiIHNlbWN0bCBmYWls
ZWQuXG4iKTsKCQlyZXR1cm4gMTsKCX0KcmV0dXJuIDA7Cn0K
--------------090106010201010108050404
Content-Type: application/x-shellscript;
 name="test5.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="test5.sh"

IyEvYmluL3NoCgouL2NyZWF0ZWFyeSAxIDUKZWNobyAiIEluY3JlYXNlIHNlbSAxIHRvIDEg
KGluaXQgYXMgbG9ja2VkKSIKLi9jaGFuZ2UgMSAxIDEKCmVjaG8gIlsxXSBxdWV1ZSB3YWl0
LWZvci16ZXJvIgouL2NoYW5nZSAxIDEgMCAyIDAmCnNsZWVwIDEKCmVjaG8gInF1ZXVlIG1h
c3RlciB0aHJlYWQiCi4vY2hhbmdlIDEgMSAtMiAyIDAmCnNsZWVwIDEKZWNobyAicXVldWUg
d29ya2VyIHRocmVhZHMiCi4vY2hhbmdlIDEgMSAwIDIgMSYKc2xlZXAgMQouL2NoYW5nZSAx
IDEgMCAyIC0xJgpzbGVlcCAxCi4vY2hhbmdlIDEgMSAwIDIgMSYKc2xlZXAgMQouL2NoYW5n
ZSAxIDEgMCAyIC0xJgpzbGVlcCAxCi4vY2hhbmdlIDEgMSAwIDIgMSYKc2xlZXAgMQoKZWNo
byAic3RhcnQgbWFzdGVyIgouL2NoYW5nZSAxIDEgMQoKZWNobyAibGludXgtMy4wLjk6IFsx
XSBzdWNjZWVkcy4iCmVjaG8gImxpbnV4LTMuMC4xMC1yYzE6IFsxXSBzbGVlcHMiCmpvYnMK
c2xlZXAgMwpqb2JzCgouL3JlbW92ZWFyeSAxCg==
--------------090106010201010108050404--
