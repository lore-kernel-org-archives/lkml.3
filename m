Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaHXQEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 12:04:16 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:50427 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaHXQEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 12:04:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140821162554.GA884@ravnborg.org>
References: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
	<20140821162554.GA884@ravnborg.org>
Date: Sun, 24 Aug 2014 18:04:10 +0200
Message-ID: <CA+rthh8bS9Rj-NmqV6o5CVVMLO3KfsZS9MSQk3uCAqx1TmyQGw@mail.gmail.com>
Subject: Re: [PATCHv3 0/9] Mark literal strings in __init / __exit code
From: Mathias Krause <minipli@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=e89a8f839eef99741b050162386f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f839eef99741b050162386f
Content-Type: text/plain; charset=UTF-8

On 21 August 2014 18:25, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Thu, Aug 21, 2014 at 02:23:03PM +0200, Mathias Krause wrote:
>> This is v3 of the patch series initially posted here:
>>
>>   https://lkml.org/lkml/2014/6/22/149
>>
>> This series tries to address the problem of dangling strings of __init
>> functions after initialization, as well as __exit strings for code not
>> even included in the final kernel image. The code might get freed, but
>> the format strings are not, as they're in the wrong section.
>
> What potential are we looking at here?

I tried to address that a few lines later in that email, also in the
individual patches. Let me quote the relevant lines here again:

>> The changes to arch/x86/ already
>> lead to moving ~3kb of memory from .rodata to .init.rodata.

>> To show that there's actual more value to it: A hacked up script, dully
>> changing pr_<level> to pi_<level> for __init functions under arch/x86/
>> is able to move ~8kB of r/o data into the .init section (partly already
>> covered by the patches of this series). The script, though, is dump. It
>> does not handle any of the printk() calls, nor does it handle panic()
>> calls or other strings used only in initialization code. So there's more
>> to squeeze out.

> Anything less than a page in size would likely not matter as this
> is the granularity we look into.

This is not true. The goal is not to increase the size of an .init
section but to decrease the size of the .text and .rodata sections.
For these even minor changes can lead to an additional free page if
that decrease makes the size of the .text / .rodata section cross a
page boundary. Thereby even small moves to the .init section like
format strings used only during initialization might make this happen.

> And the code needs to be built-in - which most drivers are not.

This, again, is not true. In fact, quite the opposite is true as
modules can benefit from it much better as the small reduction of
.text / .rodata sizes are not summed up but accounted per module. If
such a small decrease makes the .text / .rodata section cross a page
boundary, a whole page can be saved.

> So is it really worth it?

I took the hacky script mentioned in the first email (now also
attached, init_str.awk), let it ran over the whole kernel, fixed the
fall-out and did an allmodconfig build. Beside the script being far
from perfect (it catches a few false positives and, more important,
only covers a fraction of the potential strings -- only the pr_*()
macros) it already leads to 24 modules requiring a page less during
run-time because of the afore mentioned page crossing. It includes
popular modules like hid.ko and ipv6.ko, so almost anybody would
benefit from it. But as the page crossing effect depends on the
particular kernel configuration and toolchain setup, fell free to do
your own tests. The script doing the measurement is attached, too
(mod_info.sh)

> The places that already moves the string to __init/__exit should maybe
> be droopped to avoid the complication.

...or just be changed to hide the "magic".


Thanks,
Mathias

--e89a8f839eef99741b050162386f
Content-Type: application/x-awk; name="init_str.awk"
Content-Disposition: attachment; filename="init_str.awk"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hz8jvpc80

IyBSZW1hcms6IFRoaXMgc2NyaXB0IHN0dW1ibGVzIG92ZXIgI2RlZmluZXMgd2l0aCB1bmJhbGFu
Y2VkIGJyYWNlcywgZS5nLiBpbgojIGtlcm5lbC90cmFjZS90cmFjZV9ldmVudHMuYzoKIyB8ICNk
ZWZpbmUgZG9fZm9yX2VhY2hfZXZlbnRfZmlsZSh0ciwgZmlsZSkJCQlcCiMgfCAJbGlzdF9mb3Jf
ZWFjaF9lbnRyeSh0ciwgJmZ0cmFjZV90cmFjZV9hcnJheXMsIGxpc3QpIHsJXAojIHwgCQlsaXN0
X2Zvcl9lYWNoX2VudHJ5KGZpbGUsICZ0ci0+ZXZlbnRzLCBsaXN0KQojIHRoZSBvcGVuaW5nIGJy
YWNlIGlzIG1pc3NpbmcgaXRzIGNsb3NpbmcgY291bnRlcnBhcnQuCgpCRUdJTiB7CglCUkFDRVMg
PSAwOyBJTklUID0gMDsgRVhJVCA9IDA7IERFQlVHID0gMAp9Cgovey8gewoJQlJBQ0VTKysKCWlm
IChERUJVRykgcHJpbnRmICJ7e3s6IEJSQUNFUyA9ICVkLCBJTklUID0gJWQsIEVYSVQgPSAlZFxu
IiwgQlJBQ0VTLCBJTklULCBFWElUCn0KL30vIHsKCUJSQUNFUy0tCglpZiAoQlJBQ0VTID09IDAp
IHsKCQlJTklUID0gMAoJCUVYSVQgPSAwCgl9CglpZiAoREVCVUcpIHByaW50ZiAifX19OiBCUkFD
RVMgPSAlZCwgSU5JVCA9ICVkLCBFWElUID0gJWRcbiIsIEJSQUNFUywgSU5JVCwgRVhJVAp9Cgov
XDxfX2luaXRcPi8gewoJSU5JVCA9IDEKCWlmIChERUJVRykgcHJpbnRmICIqaSo6IEJSQUNFUyA9
ICVkLCBJTklUID0gJWQsIEVYSVQgPSAlZFxuIiwgQlJBQ0VTLCBJTklULCBFWElUCn0KL1w8X19l
eGl0XD4vIHsKCUVYSVQgPSAxCglpZiAoREVCVUcpIHByaW50ZiAiKmUqOiBCUkFDRVMgPSAlZCwg
SU5JVCA9ICVkLCBFWElUID0gJWRcbiIsIEJSQUNFUywgSU5JVCwgRVhJVAp9CgovXDxwcl8oZW1l
cmd8YWxlcnR8Y3JpdHxlcnJ8d2FybmluZ3x3YXJufG5vdGljZXxpbmZvfGNvbnR8ZGV2ZWx8ZGVi
dWcpLyB7CglpZiAoREVCVUcpIHByaW50ZiAiKnAqOiBCUkFDRVMgPSAlZCwgSU5JVCA9ICVkLCBF
WElUID0gJWRcbiIsIEJSQUNFUywgSU5JVCwgRVhJVAoJaWYgKElOSVQpIHByaW50ZiAic2VkIC1p
ICclZHMvcHJfL3BpXy8nICVzXG4iLCBOUiwgRklMRU5BTUUKCWlmIChFWElUKSBwcmludGYgInNl
ZCAtaSAnJWRzL3ByXy9wZV8vJyAlc1xuIiwgTlIsIEZJTEVOQU1FCn0K
--e89a8f839eef99741b050162386f
Content-Type: application/x-sh; name="mod_info.sh"
Content-Disposition: attachment; filename="mod_info.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hz8k0ndh1

IyEvYmluL2Jhc2gKIyAKIyBVc2FnZToKIyAqIEdldCBtb2R1bGUgbWVtb3J5IGluZm9ybWF0aW9u
IHBlciBzZWdtZW50IChjb2RlLCByL28gZGF0YSwgZGF0YSk6CiMgICAkIG1vZF9pbmZvLnNoCiMK
IyAqIEdldCBudW1iZXIgb2YgcGFnZXMgcmVzaXN0ZW50IGFmdGVyIGluaXQ6CiMgICAkIG1vZF9p
bmZvLnNoIHwgZWdyZXAgJ15cLnxwYWdlcycgfCBzZWQgJy9rbzove047cyxcbi4qKCwgLDtzLCks
LH0nCiMKCkNPTkZJR19ERUJVR19TRVRfTU9EVUxFX1JPTlg9MApQQUdFX1NJWkU9MHgxMDAwClZF
UkJPU0U9MAoKZnVuY3Rpb24gZGVidWcoKSB7CglbICRWRVJCT1NFIC1lcSAxIF0gJiYgcHJpbnRm
ICIkQCIgPiYyCn0KCmZ1bmN0aW9uIGFsaWduKCkgewoJZWNobyAkWygkMSArICgkMiAtIDEpKSAm
IH4oJDIgLSAxKV0KfQoKZnVuY3Rpb24gZ2V0X3NlY3Rpb25zKCkgewoJcmVhZGVsZiAtU1cgJDEg
fCBlZ3JlcCAtdiAnIFwuaW5pdHwgXC5tb2RpbmZvJyB8IGdyZXAgIiQyIiB8IFwKCQlzZWQgLW4g
Jy9bWzpzcGFjZTpdXSpcWy4qXF0vcy8uKl0vL3AnCn0KCmZ1bmN0aW9uIGdldF9zaXplKCkgewoJ
bG9jYWwgc2VnbWVudF90b3RhbD0wCgoJdG90YWw9JChjYXQgJHRvdGFsX2ZpbGUpCgl3aGlsZSBy
ZWFkIG5hbWUgeCB4IHggc2l6ZSB4IHggeCB4IGFsaWduOyBkbwoJCXNpemU9MHgkc2l6ZQoJCSNl
Y2hvICJuYW1lOiAnJG5hbWUnIHNpemU6ICckc2l6ZScgYWxpZ246ICckYWxpZ24nIiA+JjIKCQlk
ZWJ1ZyAiJTMwcyAoJTZkfCUyZCk6IDB4JTA4eCAtPiAiICRuYW1lICQoZWNobyAkWyRzaXplXSkg
JGFsaWduICR0b3RhbAoJCXNlZ21lbnRfdG90YWw9JChhbGlnbiAkc2VnbWVudF90b3RhbCAkYWxp
Z24pCgkJc2VnbWVudF90b3RhbD0kWyRzZWdtZW50X3RvdGFsICsgJHNpemVdCgkJdG90YWw9JChh
bGlnbiAkdG90YWwgJGFsaWduKQoJCXRvdGFsPSRbJHRvdGFsICsgJHNpemVdCgkJZGVidWcgIjB4
JTA4eCAoJTZkKVxuIiAkdG90YWwgJHRvdGFsCglkb25lIDwgPChnZXRfc2VjdGlvbnMgJDEgIiQy
IikKCglpZiBbICRDT05GSUdfREVCVUdfU0VUX01PRFVMRV9ST05YIC1lcSAxIF07IHRoZW4KCQl0
b3RhbD0kKGFsaWduICR0b3RhbCAkUEFHRV9TSVpFKQoJZmkKCQoJZGVidWcgIiU0MnM6IDB4JTA4
eCAoJWQpXG4iICI9PT4gdG90YWwgaXMgbm93IiAkdG90YWwgJHRvdGFsCgoJZWNobyAkdG90YWwg
PiAkdG90YWxfZmlsZQoJZWNobyAkc2VnbWVudF90b3RhbAp9CgpbIC1yIC5jb25maWcgXSB8fCB7
IGVjaG8gImVycm9yOiBjYWxsIG1lIGluIGtlcm5lbCdzIG9iamRpciEiOyBleGl0IDE7IH0KCnRv
dGFsX2ZpbGU9JChta3RlbXAgLS10bXBkaXIgbW9kaW5mby1YWFhYWFhYKQpmb3IgaSBpbiAkKGZp
bmQgLW5hbWUgXCoua28pOyBkbwoJcHJpbnRmICIlczpcbiIgJGkKCgllY2hvIDAgPiAkdG90YWxf
ZmlsZQoJdGV4dD0kKGdldF9zaXplICRpICcgQVggJykKCXJvZGF0YT0kKGdldF9zaXplICRpICcg
QU1cP1NcPyAnKQoJZGF0YT0kKGdldF9zaXplICRpICcgV0EgJykKCXRvdGFsPSQoY2F0ICR0b3Rh
bF9maWxlKQoJdG90YWxfcGFnZXM9JFtgYWxpZ24gJHRvdGFsICRQQUdFX1NJWkVgIC8gJFBBR0Vf
U0laRV0KCglwcmludGYgIlx0ICAgIHRleHQ6IDB4JTA4eFxuIiAkdGV4dAoJcHJpbnRmICJcdCAg
cm9kYXRhOiAweCUwOHhcbiIgJHJvZGF0YQoJcHJpbnRmICJcdGRhdGErYnNzOiAweCUwOHhcbiIg
JGRhdGEKCXByaW50ZiAiXHQgICB0b3RhbDogMHglMDh4ICglZCBwYWdlcylcbiIgJHRvdGFsICR0
b3RhbF9wYWdlcwpkb25lCQpybSAkdG90YWxfZmlsZQo=
--e89a8f839eef99741b050162386f--
