Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3I0QFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:05:11 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33408 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3I0QFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:05:05 -0400
MIME-Version: 1.0
In-Reply-To: <5245845F.5090100@redhat.com>
References: <524572BF.5060407@redhat.com> <5245845F.5090100@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 27 Sep 2013 10:04:44 -0600
Message-ID: <CAErSpo74E-EKJN16A44UEGraZ9NE09a5q2_zQrkMuOANtQx0rQ@mail.gmail.com>
Subject: Re: Crash of 3.12-rc2 BUG: unable to handle kernel NULL pointer dereference
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: multipart/mixed; boundary=089e0111d9b855989804e75fa6ba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0111d9b855989804e75fa6ba
Content-Type: text/plain; charset=ISO-8859-1

[+cc Thomas, Russell]

On Fri, Sep 27, 2013 at 7:13 AM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
> Dne 27.9.2013 13:57, Zdenek Kabelac napsal(a):
>
>> Hi
>>
>>
>> I'm trying to use -rc2 kernel however I'm getting quite often regular
>> kernel
>> panic:
>>
>> Here is a BUG trace from kvm running this kernel:
>> (I'm building kernel with some kernel debug checks)
>> (Kernel is used in 64bit qemu and running 32bit Debian environment)
>> linux-vanilla git: 4b97280675f45c1650ee4e388bd711ecbb18c4b4
>> (on top of that there are few minor unrelated patches)
>>
>>
>> [  235.631952] loop: module loaded
>> [  235.971853] bio: create slab <bio-1> at 1
>> [  237.355014] bio: create slab <bio-2> at 2
>> [  237.671371] BUG: unable to handle kernel NULL pointer dereference at
>> 0000000000000018
>> [  237.674537] IP: [<ffffffff8105a008>]
>> get_next_timer_interrupt+0x168/0x250
>> [  237.674537] PGD 16939067 PUD 14257067 PMD 0
>> [  237.674537] Oops: 0000 [#1] PREEMPT SMP
>> [  237.674537] Modules linked in: loop dm_thin_pool dm_persistent_data
>
>
>
> Here is the same trace from my native  HW   Lenovo T61:
>
> I'm suspecting new debug option:
>  CONFIG_DEBUG_KOBJECT_RELEASE which I've recently enabled)
>
> I've also noticed there are much older reports for this problem:
> i.e. https://lkml.org/lkml/2013/3/9/3
>
> I can trigger this bug very easily (makes 3.12-rc2 unusable for my desktop)

Yep, I see this crash 100% of the time with v3.12-rc2 and
CONFIG_DEBUG_KOBJECT_RELEASE=y with this qemu invocation and attached
q35-chipset.cfg:

/usr/local/bin/qemu-system-x86_64 -M q35 -readconfig ./q35-chipset.cfg
-enable-kvm -m 512 -drive file=ubuntu.img,if=none,id=mydisk -device
ide-drive,drive=mydisk,bus=ide.0 -nographic -monitor
telnet:localhost:7001,server,nowait,nodelay -kernel
~/linux/arch/x86/boot/bzImage -append "console=ttyS0,115200n8
root=/dev/sda1 ignore_loglevel printk.time=n"

--089e0111d9b855989804e75fa6ba
Content-Type: application/octet-stream; name="q35-chipset.cfg"
Content-Disposition: attachment; filename="q35-chipset.cfg"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hm3log5j0

IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIwojCiMgcWVtdSAtTSBxMzUgY3JlYXRlcyBhIGJhcmUgbWFjaGluZSB3aXRoIGp1c3Qg
dGhlIHZlcnkgZXNzZW50aWFsCiMgY2hpcHNldCBkZXZpY2VzIGJlaW5nIHByZXNlbnQ6CiMKIyAg
ICAgMDAuMCAtIEhvc3QgYnJpZGdlCiMgICAgIDFmLjAgLSBJU0EgYnJpZGdlIC8gTFBDCiMgICAg
IDFmLjIgLSBTQVRBIChBSENJKSBjb250cm9sbGVyCiMgICAgIDFmLjMgLSBTTUJ1cyBjb250cm9s
bGVyCiMKIyBUaGlzIGNvbmZpZyBmaWxlIGRvY3VtZW50cyB0aGUgb3RoZXIgZGV2aWNlcyBhbmQg
aG93IHRoZXkgYXJlCiMgY3JlYXRlZC4gIFlvdSBjYW4gc2ltcGx5IHVzZSAiLXJlYWRjb25maWcg
JHRoaXNmaWxlIiB0byBjcmVhdGUKIyB0aGVtIGFsbC4gIEhlcmUgaXMgYSBvdmVydmlldzoKIwoj
ICAgICAxOS4wIC0gRXRoZXJuZXQgY29udHJvbGxlciAobm90IGNyZWF0ZWQsIG91ciBlMTAwMCBl
bXVsYXRpb24KIyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRvZXNuJ3QgZW11bGF0
ZSB0aGUgaWNoOSBkZXZpY2UpLgojICAgICAxYS4qIC0gVVNCIENvbnRyb2xsZXIgIzIgKGVoY2kg
KyB1aGNpIGNvbXBhbmlvbnMpCiMgICAgIDFiLjAgLSBIRCBBdWRpbyBDb250cm9sbGVyCiMgICAg
IDFjLiogLSBQQ0kgRXhwcmVzcyBQb3J0cwojICAgICAxZC4qIC0gVVNCIENvbnRyb2xsZXIgIzEg
KGVoY2kgKyB1aGNpIGNvbXBhbmlvbnMsCiMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
InFlbXUgLU0gcTM1IC11c2IiIGNyZWF0ZXMgdGhlc2UgdG9vKQojICAgICAxZS4wIC0gUENJIEJy
aWRnZQojCgpbZGV2aWNlICJpY2g5LWVoY2ktMiJdCiAgZHJpdmVyID0gImljaDktdXNiLWVoY2ky
IgogIG11bHRpZnVuY3Rpb24gPSAib24iCiAgYnVzID0gInBjaWUuMCIKICBhZGRyID0gIjFhLjci
CgpbZGV2aWNlICJpY2g5LXVoY2ktNCJdCiAgZHJpdmVyID0gImljaDktdXNiLXVoY2k0IgogIG11
bHRpZnVuY3Rpb24gPSAib24iCiAgYnVzID0gInBjaWUuMCIKICBhZGRyID0gIjFhLjAiCiAgbWFz
dGVyYnVzID0gImljaDktZWhjaS0yLjAiCiAgZmlyc3Rwb3J0ID0gIjAiCgpbZGV2aWNlICJpY2g5
LXVoY2ktNSJdCiAgZHJpdmVyID0gImljaDktdXNiLXVoY2k1IgogIG11bHRpZnVuY3Rpb24gPSAi
b24iCiAgYnVzID0gInBjaWUuMCIKICBhZGRyID0gIjFhLjEiCiAgbWFzdGVyYnVzID0gImljaDkt
ZWhjaS0yLjAiCiAgZmlyc3Rwb3J0ID0gIjIiCgpbZGV2aWNlICJpY2g5LXVoY2ktNiJdCiAgZHJp
dmVyID0gImljaDktdXNiLXVoY2k2IgogIG11bHRpZnVuY3Rpb24gPSAib24iCiAgYnVzID0gInBj
aWUuMCIKICBhZGRyID0gIjFhLjIiCiAgbWFzdGVyYnVzID0gImljaDktZWhjaS0yLjAiCiAgZmly
c3Rwb3J0ID0gIjQiCgoKW2RldmljZSAiaWNoOS1oZGEtYXVkaW8iXQogIGRyaXZlciA9ICJpY2g5
LWludGVsLWhkYSIKICBidXMgPSAicGNpZS4wIgogIGFkZHIgPSAiMWIuMCIKCgpbZGV2aWNlICJp
Y2g5LXBjaWUtcG9ydC0xIl0KICBkcml2ZXIgPSAiaW9oMzQyMCIKICBtdWx0aWZ1bmN0aW9uID0g
Im9uIgogIGJ1cyA9ICJwY2llLjAiCiAgYWRkciA9ICIxYy4wIgogIHBvcnQgPSAiMSIKICBjaGFz
c2lzID0gIjEiCgpbZGV2aWNlICJpY2g5LXBjaWUtcG9ydC0yIl0KICBkcml2ZXIgPSAiaW9oMzQy
MCIKICBtdWx0aWZ1bmN0aW9uID0gIm9uIgogIGJ1cyA9ICJwY2llLjAiCiAgYWRkciA9ICIxYy4x
IgogIHBvcnQgPSAiMiIKICBjaGFzc2lzID0gIjIiCgpbZGV2aWNlICJpY2g5LXBjaWUtcG9ydC0z
Il0KICBkcml2ZXIgPSAiaW9oMzQyMCIKICBtdWx0aWZ1bmN0aW9uID0gIm9uIgogIGJ1cyA9ICJw
Y2llLjAiCiAgYWRkciA9ICIxYy4yIgogIHBvcnQgPSAiMyIKICBjaGFzc2lzID0gIjMiCgpbZGV2
aWNlICJpY2g5LXBjaWUtcG9ydC00Il0KICBkcml2ZXIgPSAiaW9oMzQyMCIKICBtdWx0aWZ1bmN0
aW9uID0gIm9uIgogIGJ1cyA9ICJwY2llLjAiCiAgYWRkciA9ICIxYy4zIgogIHBvcnQgPSAiNCIK
ICBjaGFzc2lzID0gIjQiCgpbZGV2aWNlICJhdWRpbyJdCiAgZHJpdmVyID0gImljaDktaW50ZWwt
aGRhIgogIGJ1cyA9ICJpY2g5LXBjaWUtcG9ydC0xIgogIGFkZHIgPSAiMC4wIgoKW2RldmljZSAi
aWNoOS1laGNpLTEiXQogIGRyaXZlciA9ICJpY2g5LXVzYi1laGNpMSIKICBtdWx0aWZ1bmN0aW9u
ID0gIm9uIgogIGJ1cyA9ICJwY2llLjAiCiAgYWRkciA9ICIxZC43IgoKW2RldmljZSAiaWNoOS11
aGNpLTEiXQogIGRyaXZlciA9ICJpY2g5LXVzYi11aGNpMSIKICBtdWx0aWZ1bmN0aW9uID0gIm9u
IgogIGJ1cyA9ICJwY2llLjAiCiAgYWRkciA9ICIxZC4wIgogIG1hc3RlcmJ1cyA9ICJpY2g5LWVo
Y2ktMS4wIgogIGZpcnN0cG9ydCA9ICIwIgoKW2RldmljZSAiaWNoOS11aGNpLTIiXQogIGRyaXZl
ciA9ICJpY2g5LXVzYi11aGNpMiIKICBtdWx0aWZ1bmN0aW9uID0gIm9uIgogIGJ1cyA9ICJwY2ll
LjAiCiAgYWRkciA9ICIxZC4xIgogIG1hc3RlcmJ1cyA9ICJpY2g5LWVoY2ktMS4wIgogIGZpcnN0
cG9ydCA9ICIyIgoKW2RldmljZSAiaWNoOS11aGNpLTMiXQogIGRyaXZlciA9ICJpY2g5LXVzYi11
aGNpMyIKICBtdWx0aWZ1bmN0aW9uID0gIm9uIgogIGJ1cyA9ICJwY2llLjAiCiAgYWRkciA9ICIx
ZC4yIgogIG1hc3RlcmJ1cyA9ICJpY2g5LWVoY2ktMS4wIgogIGZpcnN0cG9ydCA9ICI0IgoKCltk
ZXZpY2UgImljaDktcGNpLWJyaWRnZSJdCiAgZHJpdmVyID0gImk4MjgwMWIxMS1icmlkZ2UiCiAg
YnVzID0gInBjaWUuMCIKICBhZGRyID0gIjFlLjAiCgpbZGV2aWNlICJ4aGNpIl0KICBkcml2ZXIg
PSAibmVjLXVzYi14aGNpIgogIGJ1cyA9ICJpY2g5LXBjaWUtcG9ydC0yIgogIGFkZHIgPSAiMC4w
Igo=
--089e0111d9b855989804e75fa6ba--
