Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab3GJX5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 19:57:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36022 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741Ab3GJX5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 19:57:52 -0400
Message-ID: <51DDF4DF.4000902@zytor.com>
Date: Wed, 10 Jul 2013 16:57:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIFPDvG5rZW5iZXJn?= 
	<christian.suenkenberg@student.kit.edu>
CC: Jonas Heinrich <onny@project-insanity.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [Bisected] 3.7-rc1 can't resume (still present in 3.9)
References: <20130218155439.GA902@onny> <cfd96a3d-5834-4687-b9de-9f044f43b588@email.android.com> <20130223131856.GA682@onny> <51293A8B.5060107@zytor.com> <20130320143257.GA473@onny> <20130501170118.GB488@onny> <518151DD.106@zytor.com> <51DDC972.3010005@student.kit.edu>
In-Reply-To: <51DDC972.3010005@student.kit.edu>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/mixed;
 boundary="------------050607090100060900020301"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050607090100060900020301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 07/10/2013 01:52 PM, Christian Sünkenberg wrote:
> Hello,
> 
> On 05/01/2013 07:33 PM, H. Peter Anvin wrote:
>> On 05/01/2013 10:01 AM, Jonas Heinrich wrote:
>>> Hello, I tried the newest kernel, 3.9 today but the bug is still
>>> present. Applying the attached patch solves the bug for me.
>>>
>>> Best regards, Jonas Heinrich
>>
>> Okay... WTF is going on here?  Does pmode_behavior just not get set up
>> correctly?  Since it seems you can get it to wake up with your patch,
>> perhaps we can get read out the value of pmode_behavior and print it...
> 
> indeed, arch/x86/kernel/acpi/sleep.c tries an rdmsr_safe(MSR_EFER, ...)
> and sets WAKEUP_BEHAVIOR_RESTORE_EFER bit on success, however,
> on 90 nm Pentium M (Family 6, Model 13), reading an invalid MSR
> is not guaranteed to trap, see Erratum X4 in "Intel® Pentium® M
> Processor on 90 nm Process with 2-MB L2 Cache and Intel® Processor A100
> and A110 on 90 nm process with 512-KB L2 Cache Specification Update".
> On Jonas' T43, which has an affected Pentium M without EFER,
> rdmsr_safe(MSR_EFER, ...) succeeds and WAKEUP_BEHAVIOR_RESTORE_EFER
> gets set, while on resume the corresponding wrmsr traps and thus resume
> fails.
> 
> The pre-3.7 code snippet incidentally catched this by not restoring
> EFER when it would be restored to all 0s.
> 

That does seem like a reasonable explanation.

Does this patch fix the problem?  (Comment blatantly ripped off from
your email message.)

	-hpa



--------------050607090100060900020301
Content-Type: text/plain; charset=UTF-8;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="diff"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9hY3BpL3NsZWVwLmMgYi9hcmNoL3g4Ni9r
ZXJuZWwvYWNwaS9zbGVlcC5jCmluZGV4IGI0NDU3N2IuLjkyN2M1Y2UgMTAwNjQ0Ci0tLSBh
L2FyY2gveDg2L2tlcm5lbC9hY3BpL3NsZWVwLmMKKysrIGIvYXJjaC94ODYva2VybmVsL2Fj
cGkvc2xlZXAuYwpAQCAtNDgsOSArNDgsMjAgQEAgaW50IGFjcGlfc3VzcGVuZF9sb3dsZXZl
bCh2b2lkKQogI2lmbmRlZiBDT05GSUdfNjRCSVQKIAluYXRpdmVfc3RvcmVfZ2R0KChzdHJ1
Y3QgZGVzY19wdHIgKikmaGVhZGVyLT5wbW9kZV9nZHQpOwogCisJLyoKKwkgKiBXZSBoYXZl
IHRvIGNoZWNrIHRoYXQgd2UgY2FuIHdyaXRlIGJhY2sgdGhlIHZhbHVlLCBhbmQgbm90CisJ
ICoganVzdCByZWFkIGl0LiAgQXQgbGVhc3Qgb24gOTAgbm0gUGVudGl1bSBNIChGYW1pbHkg
NiwgTW9kZWwKKwkgKiAxMyksIHJlYWRpbmcgYW4gaW52YWxpZCBNU1IgaXMgbm90IGd1YXJh
bnRlZWQgdG8gdHJhcCwgc2VlCisJICogRXJyYXR1bSBYNCBpbiAiSW50ZWwgUGVudGl1bSBN
IFByb2Nlc3NvciBvbiA5MCBubSBQcm9jZXNzCisJICogd2l0aCAyLU1CIEwyIENhY2hlIGFu
ZCBJbnRlbMKuIFByb2Nlc3NvciBBMTAwIGFuZCBBMTEwIG9uIDkwCisJICogbm0gcHJvY2Vz
cyB3aXRoIDUxMi1LQiBMMiBDYWNoZSBTcGVjaWZpY2F0aW9uIFVwZGF0ZSIuCisJICovCiAJ
aWYgKCFyZG1zcl9zYWZlKE1TUl9FRkVSLAogCQkJJmhlYWRlci0+cG1vZGVfZWZlcl9sb3cs
Ci0JCQkmaGVhZGVyLT5wbW9kZV9lZmVyX2hpZ2gpKQorCQkJJmhlYWRlci0+cG1vZGVfZWZl
cl9oaWdoKSAmJgorCSAgICAhd3Jtc3Jfc2FmZShNU1JfRUZFUiwKKwkJCWhlYWRlci0+cG1v
ZGVfZWZlcl9sb3csCisJCQloZWFkZXItPnBtb2RlX2VmZXJfaGlnaCkpCiAJCWhlYWRlci0+
cG1vZGVfYmVoYXZpb3IgfD0gKDEgPDwgV0FLRVVQX0JFSEFWSU9SX1JFU1RPUkVfRUZFUik7
CiAjZW5kaWYgLyogIUNPTkZJR182NEJJVCAqLwogCg==
--------------050607090100060900020301--
