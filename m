Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab3B1PKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:10:07 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:60109 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3B1PKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 10:10:01 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA7Yzrx_=k9HB-D5v=7gsmn1ZyNb7YpzwDW-1j35Bbrs4Q@mail.gmail.com>
References: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
	<CA+5PVA5wtZipQRTPfvbh1U8gjDMaW0095EsNz==Co+iww3YN1g@mail.gmail.com>
	<CA+5PVA5vvw-JyODTtRwVhQSEiGrt=3wzDoCmeButEMTZxWAhbA@mail.gmail.com>
	<CA+5PVA5za2stXYxQ_Tu3D6Lbif94cqK_5wvPXFhUpvsh_DOXVg@mail.gmail.com>
	<CA+5PVA6CQ0YrSGkXPGtmzB9BgabXyiRnMSMKYDCJM+OuF5t6gQ@mail.gmail.com>
	<CADnq5_PqAAhQZ-4Fd0UNoT5aEhUDdtu4n+1qXYucXsnyi0sQwQ@mail.gmail.com>
	<CA+5PVA7Yzrx_=k9HB-D5v=7gsmn1ZyNb7YpzwDW-1j35Bbrs4Q@mail.gmail.com>
Date: Thu, 28 Feb 2013 10:09:59 -0500
Message-ID: <CADnq5_OadSJ1thVEvfQVfTZ3De0vivVjnCKwepVxabs6i6ivLQ@mail.gmail.com>
Subject: Re: [git pull] drm merge for 3.9-rc1
From: Alex Deucher <alexdeucher@gmail.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: multipart/mixed; boundary=e89a8f921936d0487704d6ca48f9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f921936d0487704d6ca48f9
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Feb 28, 2013 at 8:44 AM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Thu, Feb 28, 2013 at 8:38 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
>> On Wed, Feb 27, 2013 at 8:14 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>>> On Wed, Feb 27, 2013 at 7:01 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>>>> On Wed, Feb 27, 2013 at 3:20 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>>>>> On Wed, Feb 27, 2013 at 11:34 AM, Josh Boyer <jwboyer@gmail.com> wrote:
>>>>>> On Mon, Feb 25, 2013 at 7:05 PM, Dave Airlie <airlied@linux.ie> wrote:
>>>>>>> Alex Deucher (29):
>>>>>>>       drm/radeon: halt engines before disabling MC (6xx/7xx)
>>>>>>>       drm/radeon: halt engines before disabling MC (evergreen)
>>>>>>>       drm/radeon: halt engines before disabling MC (cayman/TN)
>>>>>>>       drm/radeon: halt engines before disabling MC (si)
>>>>>>>       drm/radeon: use the reset mask to determine if rings are hung
>>>>>>
>>>>>> Something in this series of commits is causing the GPU to hang on reboot
>>>>>> on my Dell XPS 8300 machine.  That has a:
>>>>>>
>>>>>> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee
>>>>>> ATI Caicos [Radeon HD 6450]
>>>>>>
>>>>>> card in it.  After reboots, I get a screen that looks like this:
>>>>>>
>>>>>> http://t.co/tPnT6xQZUK
>>>>>>
>>>>>> I can hit it fairly consistently after a few reboots, so I tried doing a
>>>>>> git bisect on the radeon driver and it came down to:
>>>>>>
>>>>>> ca57802e521de54341efc8a56f70571f79ffac72 is the first bad commit
>>>>>
>>>>> So I don't think that's actually the cause of the problem.  Or at least
>>>>> not that alone.  I reverted it on top of Linus' latest tree and I still
>>>>> get the lockups.
>>>>
>>>> Actually, git bisect does seem to have gotten it correct.  Once I
>>>> actually tested the revert of just that on top of Linus' tree (commit
>>>> d895cb1af1), things seem to be working much better.  I've rebooted a
>>>> dozen times without a lockup.  The most I've seen it take on a kernel
>>>> with that commit included is 3 reboots, so that's definitely at least an
>>>> improvement.
>>>
>>> I give up.  GPU issues are not my thing.  2 reboots after I sent that it
>>> gave me pretty rainbow static again.  So it might have been an
>>> improvement, but revert it is not a solution.
>>>
>>> Looking at there rest of the commits, the whole GPU rework might be
>>> suspect, but I clearly have no clue.
>>
>> GPUs are tricky beasts :)
>
> Understatement ;).
>
>> ca57802e521de54341efc8a56f70571f79ffac72 mostly likely wasn't the
>> problem anyway since it only affects 6xx/7xx and your card is handled
>> by the evergreen code.  I'll put together some patches to help narrow
>> down the problem.
>
> Yeah, that's the biggest problem I have, not knowing which functions are
> actually being executed for this card.  It looks like a combination of
> stuff in evergreen.c and ni.c, but I have no idea.
>
> Patches would be great.  If nothing else, I'm really good at building
> kernels and rebooting by now.

Two possible fixes attached.  The first attempts a full reset of all
blocks if the MC (memory controller) is hung.  That may work better
than just resetting the MC.  The second just disables MC reset.  I'm
not sure we can reliably tell if it's busy due to display requests
hitting the MC periodically which would lead to needlessly resetting
it possibly leading to failures like you are seeing.

Alex

--e89a8f921936d0487704d6ca48f9
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-XXX-try-a-full-reset-if-the-MC-is-busy.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-XXX-try-a-full-reset-if-the-MC-is-busy.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdq1ud4k0

RnJvbSA5YTY0OGIwNDQ3NGVkMjMwNjAxYzNjM2U4MTZjYjI4MWViYWFkNjA0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IFRodSwgMjggRmViIDIwMTMgMDk6NTY6NDggLTA1MDAKU3ViamVjdDogW1BBVENI
XSBkcm0vcmFkZW9uOiBYWFggdHJ5IGEgZnVsbCByZXNldCBpZiB0aGUgTUMgaXMgYnVzeQoKU2Vl
IGlmIHRoaXMgaGVscHMuCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5k
ZXVjaGVyQGFtZC5jb20+Ci0tLQogZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ldmVyZ3JlZW4uYyB8
ICAgIDYgKysrKysrCiAxIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2V2ZXJncmVlbi5jIGIv
ZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ldmVyZ3JlZW4uYwppbmRleCAzYzM4ZWE0Li5iYmNhYzEx
IDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2V2ZXJncmVlbi5jCisrKyBiL2Ry
aXZlcnMvZ3B1L2RybS9yYWRlb24vZXZlcmdyZWVuLmMKQEAgLTI0MzgsNiArMjQzOCwxMiBAQCBz
dGF0aWMgdTMyIGV2ZXJncmVlbl9ncHVfY2hlY2tfc29mdF9yZXNldChzdHJ1Y3QgcmFkZW9uX2Rl
dmljZSAqcmRldikKIAlpZiAodG1wICYgTDJfQlVTWSkKIAkJcmVzZXRfbWFzayB8PSBSQURFT05f
UkVTRVRfVk1DOwogCisJLyogcmVzZXQgZXZlcnl0aGluZyBpZiB3ZSBhdHRlbXB0IHRvIHJlc2V0
IHRoZSBNQyAqLworCWlmIChyZXNldF9tYXNrICYgUkFERU9OX1JFU0VUX01DKSB7CisJCWRldl9p
bmZvKHJkZXYtPmRldiwgIk1DIGJ1c3k6IDB4JTA4WCwgcmVzZXR0aW5nIEFMTFxuIiwgcmVzZXRf
bWFzayk7CisJCXJlc2V0X21hc2sgPSAweGZmZmZmZmZmOworCX0KKwogCXJldHVybiByZXNldF9t
YXNrOwogfQogCi0tIAoxLjcuNy41Cgo=
--e89a8f921936d0487704d6ca48f9
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-XXX-skip-MC-reset-as-it-s-probably-not-hu.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-XXX-skip-MC-reset-as-it-s-probably-not-hu.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdq1ukp91

RnJvbSA4MzRjMjZhYjAyZTM1ODFlYTk3YjM5YTkwZmMwNjM3ZTdiZWNmYTY3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IFRodSwgMjggRmViIDIwMTMgMTA6MDM6MDggLTA1MDAKU3ViamVjdDogW1BBVENI
XSBkcm0vcmFkZW9uOiBYWFggc2tpcCBNQyByZXNldCBhcyBpdCdzIHByb2JhYmx5IG5vdCBodW5n
CgpUaGUgTUMgaXMgbW9zdGx5IGxpa2VseSBidXN5IChlLmcuLCBkaXNwbGF5IHJlcXVlc3RzKSwg
bm90IGh1bmcKc28gbm8gbmVlZCB0byByZXNldCBpdC4gIERvaW5nIGFuIE1DIHJlc2V0IGlzIHRy
aWNreSBhbmQgbm90CnBhcnRpY3VsYXJseSByZWxpYWJsZS4KClNpZ25lZC1vZmYtYnk6IEFsZXgg
RGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4KLS0tCiBkcml2ZXJzL2dwdS9kcm0v
cmFkZW9uL2V2ZXJncmVlbi5jIHwgICAgNiArKysrKysKIDEgZmlsZXMgY2hhbmdlZCwgNiBpbnNl
cnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9y
YWRlb24vZXZlcmdyZWVuLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2V2ZXJncmVlbi5jCmlu
ZGV4IDNjMzhlYTQuLjBmMTVhZGEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24v
ZXZlcmdyZWVuLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ldmVyZ3JlZW4uYwpAQCAt
MjQzOCw2ICsyNDM4LDEyIEBAIHN0YXRpYyB1MzIgZXZlcmdyZWVuX2dwdV9jaGVja19zb2Z0X3Jl
c2V0KHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2KQogCWlmICh0bXAgJiBMMl9CVVNZKQogCQly
ZXNldF9tYXNrIHw9IFJBREVPTl9SRVNFVF9WTUM7CiAKKwkvKiBTa2lwIE1DIHJlc2V0IGFzIGl0
J3MgbW9zdGx5IGxpa2VseSBub3QgaHVuZywganVzdCBidXN5ICovCisJaWYgKHJlc2V0X21hc2sg
JiBSQURFT05fUkVTRVRfTUMpIHsKKwkJZGV2X2luZm8ocmRldi0+ZGV2LCAiTUMgYnVzeTogMHgl
MDhYLCBjbGVhcmluZy5cbiIsIHJlc2V0X21hc2spOworCQlyZXNldF9tYXNrICY9IH5SQURFT05f
UkVTRVRfTUM7CisJfQorCiAJcmV0dXJuIHJlc2V0X21hc2s7CiB9CiAKLS0gCjEuNy43LjUKCg==
--e89a8f921936d0487704d6ca48f9--
