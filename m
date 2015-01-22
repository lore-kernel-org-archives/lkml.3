Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbbAVSQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:16:04 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:64618 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbbAVSQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:16:01 -0500
Message-ID: <54C13E5B.3020208@colorfullife.com>
Date: Thu, 22 Jan 2015 19:15:55 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ethan Zhao <ethan.kernel@gmail.com>
CC: Stephen Smalley <sds@tycho.nsa.gov>, Ethan Zhao <ethan.zhao@oracle.com>,
        james.l.morris@oracle.com, serge@hallyn.com,
        Eric Paris <eparis@parisplace.org>, Paul Moore <paul@paul-moore.com>,
        selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Selinux/hooks.c: Fix a NULL pointer dereference caused
 by semop()
References: <1421745518-18790-1-git-send-email-ethan.zhao@oracle.com> <54BE61F0.202@tycho.nsa.gov> <CABawtvPrhVWV3bC-=wygqfHJzctvrmd1WxDD1ciuLE7F7-_yaQ@mail.gmail.com> <54BF3971.2090003@colorfullife.com> <CABawtvO3PdKhmeH_H1v_tQxmgOBQrnLGNayTE1=EbcxJbtwAzQ@mail.gmail.com>
In-Reply-To: <CABawtvO3PdKhmeH_H1v_tQxmgOBQrnLGNayTE1=EbcxJbtwAzQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050406030403000908020209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050406030403000908020209
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/22/2015 03:44 AM, Ethan Zhao wrote:
> On Wed, Jan 21, 2015 at 1:30 PM, Manfred Spraul
> <manfred@colorfullife.com> wrote:
>> On 01/21/2015 04:53 AM, Ethan Zhao wrote:
>>> On Tue, Jan 20, 2015 at 10:10 PM, Stephen Smalley <sds@tycho.nsa.gov>
>>> wrote:
>>>> On 01/20/2015 04:18 AM, Ethan Zhao wrote:
>>>>>        sys_semget()
>>>>>        ->newary()
>>>>>            ->security_sem_alloc()
>>>>>              ->sem_alloc_security()
>>>>>                    selinux_sem_alloc_security()
>>>>>                    ->ipc_alloc_security() {
>>>>>                      ->rc = avc_has_perm()
>>>>>                                 if (rc) {
>>>>>
>>>>> ipc_free_security(&sma->sem_perm);
>>>>>                                         return rc;
>>>> We free the security structure here to avoid a memory leak on a
>>>> failed/denied semaphore set creation.  In this situation, we return an
>>>> error to the caller (ultimately to newary), it does an
>>>> ipc_rcu_putref(sma, ipc_rcu_free), and it returns an error to the
>>>> caller.  Thus, it never calls ipc_addid() and the semaphore set is not
>>>> created.  So how then can you call semtimedop() on it?
>>> Seems it wouldn't happen after commit
>>> e8577d1f0329d4842e8302e289fb2c22156abef4 ?
>> That was my first guess when I read the bug report - but it can't be the
>> fix, because security_sem_alloc() is before the ipc_addid(), with or without
>> the patch.
>>
>> thread A:
>>              thread B:
>>
>> semtimedop()
>> -> sem_obtain_object_check()
>>              semctl(IPC_RMID)
>>              -> freeary()
>>              -> ipc_rcu_putref()
>>              -> call_rcu()
>> -> somehow a grace period
>>              -> sem_rcu_free()
>>              -> security_sem_free()
>>
>> Perhaps: modify ipc_free_security() to hexdump perm and a few more bytes if
>> the pointer is NULL?
> I tried to ask for vmcore and do more analysis, basically, the race condition
> still exists and open a hole to be DoS.
Is the issue reproducable?
If yes, can you try something like the attached patch?
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -5129,6 +5129,8 @@ static int ipc_has_perm(struct kern_ipc_perm
> *ipc_perms,
>         u32 sid = current_sid();
>
>         isec = ipc_perms->security;
> +     if (!isec)
> +             return -EACCES;
>
>         ad.type = LSM_AUDIT_DATA_IPC;
>         ad.u.ipc_id = ipc_perms->key;
ipc_has_perm() runs without any spinlocks/semaphores, only rcu_read_lock().
Testing for ipc_perms->security!=NULL does solve the issue that 
ipc_perm->key could be an access to kfree'd memory: Nothing prevents 
that the kfree could happen just after the test.

I.e.: The patch can't be the right solution.

--
     Manfred

--------------050406030403000908020209
Content-Type: text/plain; charset=UTF-8;
 name="patch-sem_ipc_has_perm"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="patch-sem_ipc_has_perm"

ZGlmZiAtLWdpdCBhL2lwYy9zZW0uYyBiL2lwYy9zZW0uYwppbmRleCA2MTE1MTQ2Li44MDM3
MWRjIDEwMDY0NAotLS0gYS9pcGMvc2VtLmMKKysrIGIvaXBjL3NlbS5jCkBAIC0yNDgsNiAr
MjQ4LDcgQEAgc3RhdGljIHZvaWQgc2VtX3JjdV9mcmVlKHN0cnVjdCByY3VfaGVhZCAqaGVh
ZCkKIAlzdHJ1Y3QgaXBjX3JjdSAqcCA9IGNvbnRhaW5lcl9vZihoZWFkLCBzdHJ1Y3QgaXBj
X3JjdSwgcmN1KTsKIAlzdHJ1Y3Qgc2VtX2FycmF5ICpzbWEgPSBpcGNfcmN1X3RvX3N0cnVj
dChwKTsKIAorcHJfaW5mbygic2VtX3JjdV9mcmVlOiBzbWEgJXBcbiIsc21hKTsKIAlzZWN1
cml0eV9zZW1fZnJlZShzbWEpOwogCWlwY19yY3VfZnJlZShoZWFkKTsKIH0KQEAgLTUyOSw2
ICs1MzAsNyBAQCBzdGF0aWMgaW50IG5ld2FyeShzdHJ1Y3QgaXBjX25hbWVzcGFjZSAqbnMs
IHN0cnVjdCBpcGNfcGFyYW1zICpwYXJhbXMpCiAJc21hLT5zZW1fbnNlbXMgPSBuc2VtczsK
IAlzbWEtPnNlbV9jdGltZSA9IGdldF9zZWNvbmRzKCk7CiAKK3ByX2luZm8oIm5ld2FyeTog
c21hICVwIGJlY29tZXMgdmlzaWJsZVxuIixzbWEpOwogCWlkID0gaXBjX2FkZGlkKCZzZW1f
aWRzKG5zKSwgJnNtYS0+c2VtX3Blcm0sIG5zLT5zY19zZW1tbmkpOwogCWlmIChpZCA8IDAp
IHsKIAkJaXBjX3JjdV9wdXRyZWYoc21hLCBzZW1fcmN1X2ZyZWUpOwpAQCAtMTExOCw2ICsx
MTIwLDcgQEAgc3RhdGljIHZvaWQgZnJlZWFyeShzdHJ1Y3QgaXBjX25hbWVzcGFjZSAqbnMs
IHN0cnVjdCBrZXJuX2lwY19wZXJtICppcGNwKQogCiAJLyogUmVtb3ZlIHRoZSBzZW1hcGhv
cmUgc2V0IGZyb20gdGhlIElEUiAqLwogCXNlbV9ybWlkKG5zLCBzbWEpOworcHJfaW5mbygi
ZnJlZWFyeTogc21hICVwIHVubGlua2VkXG4iLHNtYSk7CiAJc2VtX3VubG9jayhzbWEsIC0x
KTsKIAlyY3VfcmVhZF91bmxvY2soKTsKIApAQCAtMTg2MCw2ICsxODYzLDkgQEAgU1lTQ0FM
TF9ERUZJTkU0KHNlbXRpbWVkb3AsIGludCwgc2VtaWQsIHN0cnVjdCBzZW1idWYgX191c2Vy
ICosIHRzb3BzLAogCWlmIChpcGNwZXJtcyhucywgJnNtYS0+c2VtX3Blcm0sIGFsdGVyID8g
U19JV1VHTyA6IFNfSVJVR08pKQogCQlnb3RvIG91dF9yY3Vfd2FrZXVwOwogCisJaWYgKHNt
YS0+c2VtX3Blcm0uc2VjdXJpdHkgPT0gTlVMTCkgeworCQlwcl9pbmZvKCJzbWEgJXA6IHNl
bV9wZXJtLnNlY3VyaXR5ID09IE5VTExcbiIsIHNtYSk7CisJfQogCWVycm9yID0gc2VjdXJp
dHlfc2VtX3NlbW9wKHNtYSwgc29wcywgbnNvcHMsIGFsdGVyKTsKIAlpZiAoZXJyb3IpCiAJ
CWdvdG8gb3V0X3JjdV93YWtldXA7CmRpZmYgLS1naXQgYS9zZWN1cml0eS9zZWxpbnV4L2hv
b2tzLmMgYi9zZWN1cml0eS9zZWxpbnV4L2hvb2tzLmMKaW5kZXggNmRhNzUzMi4uMTQ5OTc4
NyAxMDA2NDQKLS0tIGEvc2VjdXJpdHkvc2VsaW51eC9ob29rcy5jCisrKyBiL3NlY3VyaXR5
L3NlbGludXgvaG9va3MuYwpAQCAtNTA4OCw2ICs1MDg4LDcgQEAgc3RhdGljIGludCBpcGNf
YWxsb2Nfc2VjdXJpdHkoc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrLAogCWlzZWMtPnNjbGFz
cyA9IHNjbGFzczsKIAlpc2VjLT5zaWQgPSBzaWQ7CiAJcGVybS0+c2VjdXJpdHkgPSBpc2Vj
OworcHJfaW5mbygiaXBjX2FsbG9jX3NlY3VyaXR5IGZvciBwZXJtICVwLlxuIiwgcGVybSk7
CiAKIAlyZXR1cm4gMDsKIH0KQEAgLTUwOTYsNiArNTA5Nyw3IEBAIHN0YXRpYyB2b2lkIGlw
Y19mcmVlX3NlY3VyaXR5KHN0cnVjdCBrZXJuX2lwY19wZXJtICpwZXJtKQogewogCXN0cnVj
dCBpcGNfc2VjdXJpdHlfc3RydWN0ICppc2VjID0gcGVybS0+c2VjdXJpdHk7CiAJcGVybS0+
c2VjdXJpdHkgPSBOVUxMOworcHJfaW5mbygiaXBjX2ZyZWVfc2VjdXJpdHkgZm9yIHBlcm0g
JXAuXG4iLCBwZXJtKTsKIAlrZnJlZShpc2VjKTsKIH0KIApAQCAtNTEyOSw2ICs1MTMxLDEy
IEBAIHN0YXRpYyBpbnQgaXBjX2hhc19wZXJtKHN0cnVjdCBrZXJuX2lwY19wZXJtICppcGNf
cGVybXMsCiAJdTMyIHNpZCA9IGN1cnJlbnRfc2lkKCk7CiAKIAlpc2VjID0gaXBjX3Blcm1z
LT5zZWN1cml0eTsKKwlpZiAoaXNlYyA9PSBOVUxMKSB7CisJCXN0cnVjdCBzZW1fYXJyYXkg
KnNtYSA9IGNvbnRhaW5lcl9vZihpcGNfcGVybXMsIHN0cnVjdCBzZW1fYXJyYXksIHNlbV9w
ZXJtKTsKKworCQlwcl9pbmZvKCJzbWEgJXAsIHNlbV9iYXNlICVwLCBkZWxldGVkICVkIHdp
dGggTlVMTCBpc2VjXG4iLAorCQkJCQlzbWEsIHNtYS0+c2VtX2Jhc2UsIHNtYS0+c2VtX3Bl
cm0uZGVsZXRlZCk7CisJfQogCiAJYWQudHlwZSA9IExTTV9BVURJVF9EQVRBX0lQQzsKIAlh
ZC51LmlwY19pZCA9IGlwY19wZXJtcy0+a2V5Owo=
--------------050406030403000908020209--
