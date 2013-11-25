Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab3KYTx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:53:29 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:32975 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab3KYTxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:53:24 -0500
MIME-Version: 1.0
In-Reply-To: <52939151.8030908@akamai.com>
References: <CAJusiZXq0CPHNvNCKCRp=XZ8UO9gFKVsU3cTEON5BCHDxrqFZQ@mail.gmail.com>
	<52939151.8030908@akamai.com>
Date: Mon, 25 Nov 2013 11:53:24 -0800
Message-ID: <CAJusiZWCrDovv_w29LeFA6m61CdWs4Ljxhwf_chNpNVGvmUKLA@mail.gmail.com>
Subject: Re: disappearing listen()ed SO_REUSEPORT sockets across fork() when
 using epoll
From: Shawn Landden <shawnlandden@gmail.com>
To: Jason Baron <jbaron@akamai.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tom Herbert <therbert@google.com>
Content-Type: multipart/mixed; boundary=047d7bdc131e7f0a7104ec05b73a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bdc131e7f0a7104ec05b73a
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Nov 25, 2013 at 10:05 AM, Jason Baron <jbaron@akamai.com> wrote:
> On 11/22/2013 12:53 PM, Shawn Landden wrote:
>> Hello, when running the attached program on 3.12 child processes
>> are missing a socket fd opened, set with SO_REUSEPORT, listen()ed to,
>> and added to epoll_ctl().
>>
>> This is the output I get when pointing "wget http://localhost:5555/"
>> at the attached program:
>>
>> main PID 31591
>> PID 31634 started
>> PID 31634 accept()ed connection
>> PID 31635 started
>> PID 31636 started
>> PID 31635 accept() failed: Bad file descriptor
>> PID 31636 accept() failed: Bad file descriptor
>> PID 31634 accept()ed connection
>> PID 31634 accept()ed connection
>> PID 31634 accept()ed connection
>> PID 31634 accept()ed connection
>>
>>
>> While I would expect something like:
>>
>> main PID 31591
>> PID 31634 started
>> PID 31634 accept()ed connection
>> PID 31635 started
>> PID 31636 started
>> PID 31635 accept()ed connection
>> PID 31636 accept()ed connection
>>
>> -more new processes, but inversely proportional to number of listening processes
>> -accept() always returns successfully
>>
>>
>
> The 'close(sockfd);' looks to be racing with the accept() calls. Removing seems
> to get the result you are looking for.
Interesting. That works, but it shouldn't. The close() is operating in
the parent, so it shouldn't affect the child,
there is a leak here of process separation.

New version with pid set to volatile, and making sure that we are in the parent.
>
> Thanks,
>
> -Jason
>



-- 

---
Shawn Landden
+1 360 389 3001 (SMS preferred)

--047d7bdc131e7f0a7104ec05b73a
Content-Type: text/x-csrc; charset=US-ASCII; name="epoll_test.c"
Content-Disposition: attachment; filename="epoll_test.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hog4tnb10

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzeXMvdHlwZXMuaD4KI2luY2x1ZGUgPHN5cy9z
b2NrZXQuaD4KI2luY2x1ZGUgPG5ldGluZXQvaW4uaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgojaW5j
bHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzeXMvZXBvbGwuaD4KCmludCBtYWluKCBpbnQgYXJn
YywgY2hhciAqYXJndltdKSB7CiAgICAgICAgaW50IHNvY2tmZCwgZXBvbGxmZCwgYWNjZXB0ZmQs
IHBvcnRubzsKICAgICAgICBzdHJ1Y3QgZXBvbGxfZXZlbnQgZXZlbnQgPSB7RVBPTExJTiwgTlVM
TH0sIGdvdGV2ZW50OwogICAgICAgIGNoYXIgYnVmZmVyWzI1Nl07CiAgICAgICAgc3RydWN0IHNv
Y2thZGRyX2luIHNlcnZfYWRkcjsKICAgICAgICBpbnQgIG47Cgl2b2xhdGlsZSBwaWRfdCBwaWQ7
CgogICAgICAgIHByaW50ZigibWFpbiBQSUQgJWRcbiIsIGdldHBpZCgpKTsKCiAgICAgICAgbWVt
c2V0KChjaGFyICopICZzZXJ2X2FkZHIsIDAsIHNpemVvZihzZXJ2X2FkZHIpKTsKICAgICAgICBw
b3J0bm8gPSA1NTU1OwogICAgICAgIHNlcnZfYWRkci5zaW5fZmFtaWx5ID0gQUZfSU5FVDsKICAg
ICAgICBzZXJ2X2FkZHIuc2luX2FkZHIuc19hZGRyID0gSU5BRERSX0FOWTsKICAgICAgICBzZXJ2
X2FkZHIuc2luX3BvcnQgPSBodG9ucyhwb3J0bm8pOwoKICAgICAgICBpZiAoKHNvY2tmZCA9IHNv
Y2tldChBRl9JTkVULCBTT0NLX1NUUkVBTSwgMCkpIDwgMCkKCQlyZXR1cm4gcHJpbnRmKCJzb2Nr
ZXQoKSBmYWlsZWQ6ICVtXG4iKTsKCiAgICAgICAgaW50IG9wdHZhbCA9IDE7CiAgICAgICAgaWYg
KChzZXRzb2Nrb3B0KHNvY2tmZCwgU09MX1NPQ0tFVCwgU09fUkVVU0VQT1JULCAmb3B0dmFsLCBz
aXplb2Yob3B0dmFsKSkpIDwgMCkKICAgICAgICAgICAgICAgIHJldHVybiBwcmludGYoInNldHNv
Y2tvcHQoKSBmYWlsZWQ6ICVtIik7CgogICAgICAgIGlmIChiaW5kKHNvY2tmZCwgKHN0cnVjdCBz
b2NrYWRkciAqKSAmc2Vydl9hZGRyLAogICAgICAgICAgICAgICAgICAgICAgICAgIHNpemVvZihz
ZXJ2X2FkZHIpKSA8IDApCgkJcmV0dXJuIHByaW50ZigiYmluZCgpIGZhaWxlZDogJW1cbiIpOwoK
ICAgICAgICBpZiAobGlzdGVuKHNvY2tmZCwgU09NQVhDT05OKSA8IDApCgkJcmV0dXJuIHByaW50
ZigibGlzdGVuKCkgZmFpbGVkOiAlbVxuIik7CgoJaWYgKChlcG9sbGZkID0gZXBvbGxfY3JlYXRl
MSgwKSkgPCAwKQoJICAgICAgICByZXR1cm4gcHJpbnRmKCJlcG9sbF9jcmVhdGUxKCkgZmFpbGVk
OiAlbVxuIik7CgogICAgICAgIGlmIChlcG9sbF9jdGwoZXBvbGxmZCwgIEVQT0xMX0NUTF9BREQs
IHNvY2tmZCwgJmV2ZW50KSA8IDApCiAgICAgICAgICAgICAgICByZXR1cm4gcHJpbnRmKCJlcG9s
bF9jdGwoKSBmYWlsZWQ6ICVtXG4iKTsKCiAgICAgICAgd2hpbGUgKDEpIHsKICAgICAgICAgICAg
ICAgIGlmIChlcG9sbF93YWl0KGVwb2xsZmQsICZnb3RldmVudCwgMSwgLTEpICE9IDEpCiAgICAg
ICAgICAgICAgICAgICAgICAgIHJldHVybiBwcmludGYoImVwb2xsX3dhaXQoKSBmYWlsZWQ6ICVt
XG4iKTsKCiAgICAgICAgICAgICAgICBwaWQgPSBmb3JrKCk7CiAgICAgICAgICAgICAgICBpZiAo
cGlkID09IDApIHsKICAgICAgICAgICAgICAgICAgICAgICAgcHJpbnRmKCJQSUQgJWQgc3RhcnRl
ZFxuIiwgZ2V0cGlkKCkpOwogICAgICAgICAgICAgICAgICAgICAgICB3aGlsZSgxKSB7CiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHNvY2thZGRyX2luIGNsaV9hZGRyOwog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNvY2tsZW5fdCBjbGlfc2l6ZSA9IHNpemVv
ZiBjbGlfYWRkcjsKCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKChhY2NlcHRm
ZCA9IGFjY2VwdChzb2NrZmQsIChzdHJ1Y3Qgc29ja2FkZHIgKikmY2xpX2FkZHIsIAogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICZjbGlfc2l6
ZSkpIDwgMCkgewoJICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwcmludGYoIlBJRCAl
ZCBhY2NlcHQoKSBmYWlsZWQ6ICVtXG4iLCBnZXRwaWQoKSk7CgkgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHNsZWVwKDYwKTsKCSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
cmV0dXJuIDE7CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfQoKICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBwcmludGYoIlBJRCAlZCBhY2NlcHQoKWVkIGNvbm5lY3Rpb25c
biIsIGdldHBpZCgpKTsKCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGNsb3Nl
KGFjY2VwdGZkKSA8IDApCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBy
ZXR1cm4gcHJpbnRmKCJjbG9zZSgpIGZhaWxlZDogJW1cbiIpOwogICAgICAgICAgICAgICAgICAg
ICAgICB9CiAgICAgICAgICAgICAgICB9IGVsc2UgaWYgKHBpZCA+IDApCiAgICAgICAgICAgICAg
ICAJY2xvc2Uoc29ja2ZkKTsKICAgICAgICB9Cn0K
--047d7bdc131e7f0a7104ec05b73a--
