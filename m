Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3C0RqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:46:25 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:58888 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3C0Rk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:40:27 -0400
MIME-Version: 1.0
In-Reply-To: <CANEJEGs1hpm9_bKgSuYsJtWSxvc3FjCd6ihYXhvVpEt2UdKV4w@mail.gmail.com>
References: <1364338202-10311-1-git-send-email-grundler@chromium.org>
	<CANEJEGs1hpm9_bKgSuYsJtWSxvc3FjCd6ihYXhvVpEt2UdKV4w@mail.gmail.com>
Date: Wed, 27 Mar 2013 10:40:25 -0700
X-Google-Sender-Auth: fmzgd323Rozt1jY-M5t8_qXh9_k
Message-ID: <CANEJEGtu-pMK+JRYYUjA47F5GqSRmNrR0KfTwHdXkMXNgLnpbQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: rewrite CLKDIV computation
From: Grant Grundler <grundler@chromium.org>
To: Grant Grundler <grundler@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Doug Anderson <dianders@chromium.org>,
        Will Newton <will.newton@gmail.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Bing Zhao <bzhao@marvell.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ashok Nagarajan <asnagarajan@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d043749e174d12504d8eb8891
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d043749e174d12504d8eb8891
Content-Type: text/plain; charset=UTF-8

Sorry - please ignore the previous version. Did not include a
copyright (implied to be mine...but it's not) nor license.

Same thing but with proper attribution.

cheers,
grant

On Tue, Mar 26, 2013 at 3:53 PM, Grant Grundler <grundler@chromium.org> wrote:
> I've attached the test program I wrote to compare the different
> flavors of CLKDIV computation: old (3.4 kernel), current upstream, and
> my rewrite.
>
> thanks
> grant
>
> On Tue, Mar 26, 2013 at 3:50 PM, Grant Grundler <grundler@chromium.org> wrote:
>> Last year Seungwon Jeon (Samsung) fixed a bug in CLKDIV computation.
>> But when debugging a related issue (http://crbug.com/221828) I found
>> the code unreadable.  This rewrite simplifies the computation and
>> explains each step.
>>
>> Signed-off-by: Grant Grundler <grundler@chromium.org>
>> ---
>> Tested on Samsung Series 3 Chromebook (exynos 5250 chipset) using
>> ChromeOS 3.4 kernel (not 3.9-rc3 which this patch is based against).
>>
>> I've written a test program to confirm this patch generates the
>> same correct values and will share that separately.
>>
>>  drivers/mmc/host/dw_mmc.c | 22 +++++++++++++++-------
>>  1 file changed, 15 insertions(+), 7 deletions(-)
>>
>>
>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>> index 9834221..6fdf55b 100644
>> --- a/drivers/mmc/host/dw_mmc.c
>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -631,14 +631,22 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>>
>>         if (slot->clock != host->current_speed || force_clkinit) {
>>                 div = host->bus_hz / slot->clock;
>> -               if (host->bus_hz % slot->clock && host->bus_hz > slot->clock)
>> -                       /*
>> -                        * move the + 1 after the divide to prevent
>> -                        * over-clocking the card.
>> +               if (host->bus_hz > slot->clock) {
>> +                       /* don't overclock due to integer math losses */
>> +                       if ((div * slot->clock) < host->bus_hz)
>> +                               div++;
>> +
>> +                       /* don't overclock due to resolution of HW */
>> +                       if (div & 1)
>> +                               div++;
>> +
>> +                       /* See 6.2.3 CLKDIV in "Mobile Storage Host Databook"
>> +                        * Look for dwc_mobile_storage_db.pdf from Synopsys.
>> +                        * CLKDIV value 0 means divisor 1, val 1 -> 2, ...
>>                          */
>> -                       div += 1;
>> -
>> -               div = (host->bus_hz != slot->clock) ? DIV_ROUND_UP(div, 2) : 0;
>> +                       div /= 2;
>> +               } else
>> +                       div = 0;        /* use bus_hz */
>>
>>                 dev_info(&slot->mmc->class_dev,
>>                          "Bus speed (slot %d) = %dHz (slot req %dHz, actual %dHZ"
>> --
>> 1.8.1.3
>>

--f46d043749e174d12504d8eb8891
Content-Type: text/x-csrc; charset=US-ASCII; name="test_dw_mmc.c"
Content-Disposition: attachment; filename="test_dw_mmc.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hero18qy1

LyogVGVzdCBkd19tbWMgZHJpdmVyIENMS0RJViBjb21wdXRhdGlvbi4KICogQ29weXJpZ2h0IChj
KSAyMDEzIFRoZSBDaHJvbWl1bSBPUyBBdXRob3JzLiBBbGwgcmlnaHRzIHJlc2VydmVkLgogKgog
KiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQg
YW5kL29yIG1vZGlmeQogKiBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1
YmxpYyBMaWNlbnNlIGFzIHB1Ymxpc2hlZCBieQogKiB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0
aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBvcgogKiAoYXQgeW91ciBvcHRp
b24pIGFueSBsYXRlciB2ZXJzaW9uLgogKgogKiBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQg
aW4gdGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwKICogYnV0IFdJVEhPVVQgQU5ZIFdB
UlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YKICogTUVSQ0hBTlRB
QklMSVRZIG9yIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlIHRoZQogKiBH
TlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLgogKgogKiBZb3Ugc2hv
dWxkIGhhdmUgcmVjZWl2ZWQgYSBjb3B5IG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5z
ZQogKiBhbG9uZyB3aXRoIHRoaXMgcHJvZ3JhbTsgaWYgbm90LCB3cml0ZSB0byB0aGUgRnJlZSBT
b2Z0d2FyZQogKiBGb3VuZGF0aW9uLCBJbmMuLCA1OSBUZW1wbGUgUGxhY2UsIFN1aXRlIDMzMCwg
Qm9zdG9uLCBNQSAgMDIxMTEtMTMwNyAgVVNBCiAqLwoKI2luY2x1ZGUgPHN0ZGlvLmg+CgovKiBm
cm9tIGluY2x1ZGUvbGludXgva2VybmVsLmggKi8KI2RlZmluZSBESVZfUk9VTkRfVVAobixkKSAo
KChuKSArIChkKSAtIDEpIC8gKGQpKQoKdW5zaWduZWQgaW50IG9yaWdpbmFsKHVuc2lnbmVkIGlu
dCBidXNfaHosIHVuc2lnbmVkIGludCBjbG9jaykKewoJdW5zaWduZWQgaW50IGRpdjsKCglpZiAo
YnVzX2h6ICUgY2xvY2spCgkJLyoKCQkgKiBtb3ZlIHRoZSArIDEgYWZ0ZXIgdGhlIGRpdmlkZSB0
byBwcmV2ZW50CgkJICogb3Zlci1jbG9ja2luZyB0aGUgY2FyZC4KCQkgKi8KCQlkaXYgPSAoKGJ1
c19oeiAvIGNsb2NrKSA+PiAxKSArIDE7CgllbHNlCgkJZGl2ID0gKGJ1c19oeiAgLyBjbG9jaykg
Pj4gMTsKCglyZXR1cm4gZGl2Owp9Cgp1bnNpZ25lZCBpbnQgdXBzdHJlYW0odW5zaWduZWQgaW50
IGJ1c19oeiwgdW5zaWduZWQgaW50IGNsb2NrKQp7Cgl1bnNpZ25lZCBpbnQgZGl2OwoKCWRpdiA9
IGJ1c19oeiAvIGNsb2NrOwoJaWYgKGJ1c19oeiAlIGNsb2NrICYmIGJ1c19oeiA+IGNsb2NrKQoJ
CS8qCgkJICogbW92ZSB0aGUgKyAxIGFmdGVyIHRoZSBkaXZpZGUgdG8gcHJldmVudAoJIAkgKiBv
dmVyLWNsb2NraW5nIHRoZSBjYXJkLgoJCSAqLwoJCWRpdiArPSAxOwoKCWRpdiA9IChidXNfaHog
IT0gY2xvY2spID8gRElWX1JPVU5EX1VQKGRpdiwgMikgOiAwOwoKCXJldHVybiBkaXY7Cn0KCgp1
bnNpZ25lZCBpbnQgZ2dnKHVuc2lnbmVkIGludCBidXNfaHosIHVuc2lnbmVkIGludCBjbG9jaykK
ewoJdW5zaWduZWQgaW50IGRpdjsKCglkaXYgPSBidXNfaHogLyBjbG9jazsKCWlmIChidXNfaHog
PiBjbG9jaykgewoJCS8qIGRvbid0IG92ZXJjbG9jayBkdWUgdG8gaW50ZWdlciBtYXRoIGxvc3Nl
cyAqLwoJCWlmICgoZGl2ICogY2xvY2spIDwgYnVzX2h6KQoJCQlkaXYrKzsKCgkJLyogZG9uJ3Qg
b3ZlcmNsb2NrIGR1ZSB0byByZXNvbHV0aW9uIG9mIEhXICovCgkJaWYgKGRpdiAmIDEpCgkJCWRp
disrOwoKCQkvKiBTZWUgNi4yLjMgQ0xLRElWIGluICJNb2JpbGUgU3RvcmFnZSBIb3N0IERhdGFi
b29rIgoJCSAqIExvb2sgZm9yIGR3Y19tb2JpbGVfc3RvcmFnZV9kYi5wZGYgZnJvbSBTeW5vcHN5
cy4KCQkgKiBDTEtESVYgdmFsdWUgMCBtZWFucyBkaXZpc29yIDEsIHZhbHVlIDEgLT4gMiwgdmFs
IDIgLT4gNCBldGMuCgkJICovCgkJZGl2IC89IDI7Cgl9IGVsc2UKCQlkaXYgPSAwOwkvKiB1c2Ug
YnVzX2h6ICovCgoJcmV0dXJuIGRpdjsKfQoKdW5zaWduZWQgaW50IGJ1c19oel90YmxbXSA9IHsg
MTMsIDE3LCAxOSwgMjAsIDUwMDAwMDAwLCAxMDAwMDAwMDB9Owp1bnNpZ25lZCBpbnQgc2xvdF9o
el90YmxbXSA9IHsgMTAsIDEzLCAyMSwgNDAsIDU3LCA0MDAwMDAsIDc4NDMxNCwgNTIwMDAwMDB9
OwoKc3RhdGljIHVuc2lnbmVkIGludCBkaXZfdG9faHoodW5zaWduZWQgaW50IGJ1c19oeiwgdW5z
aWduZWQgaW50IGQpCnsKCSByZXR1cm4gZCA/IChidXNfaHovKGQqMikpIDogYnVzX2h6Owp9Cgpz
dGF0aWMgdm9pZCB2ZXJpZnlfaHoodW5zaWduZWQgaW50IGJ1c19oeiwgdW5zaWduZWQgaW50IHJl
cXVlc3RlZF9oeiwKCQl1bnNpZ25lZCBpbnQgZGl2aWRlZF9oeiwgY29uc3QgY2hhciAqYWxnb19u
YW1lKQp7CglpZiAoZGl2aWRlZF9oeiA+IGJ1c19oeikKCQlwcmludGYoIiBbRkFJTDogICVzID4g
YnVzIGh6IV0iLCBhbGdvX25hbWUpOwoKCWlmIChkaXZpZGVkX2h6ID4gcmVxdWVzdGVkX2h6KQoJ
CXByaW50ZigiIFtGQUlMOiAlcyA+IHNsb3QgaHohXSIsIGFsZ29fbmFtZSk7Cn0KCnZvaWQgbWFp
bih2b2lkKQp7Cgl1bnNpZ25lZCBpbnQgaSwgajsKCglwcmludGYoImJ1cy9zbG90IGh6IAlPcmln
aW5hbAlVcHN0cmVhbQlHR0dcbiIpOwoJZm9yKGk9MDsgaSA8IHNpemVvZihidXNfaHpfdGJsKS9z
aXplb2YodW5zaWduZWQgaW50KTsgaSsrKSB7CgkJdW5zaWduZWQgaW50IGJ1c19oeiA9IGJ1c19o
el90YmxbaV07CgkJZm9yIChqPTA7IGogPCBzaXplb2Yoc2xvdF9oel90YmwpL3NpemVvZih1bnNp
Z25lZCBpbnQpOyBqKyspIHsKCQkJdW5zaWduZWQgaW50IHNsb3RfaHogPSBzbG90X2h6X3RibFtq
XTsKCQkJdW5zaWduZWQgaW50IHggPSBvcmlnaW5hbChidXNfaHosIHNsb3RfaHopOwoJCQl1bnNp
Z25lZCBpbnQgeSA9IHVwc3RyZWFtKGJ1c19oeiwgc2xvdF9oeik7CgkJCXVuc2lnbmVkIGludCB6
ID0gZ2dnKGJ1c19oeiwgc2xvdF9oeik7CgoJCQl1bnNpZ25lZCBpbnQgaHpfeCwgaHpfeSwgaHpf
ejsKCgkJCWh6X3ggPSBkaXZfdG9faHooYnVzX2h6LCB4KTsKCQkJaHpfeSA9IGRpdl90b19oeihi
dXNfaHosIHkpOwoJCQloel96ID0gZGl2X3RvX2h6KGJ1c19oeiwgeik7CgoJCQlwcmludGYoIiU4
ZC8lNmQJJTdkICU2ZAklN2QgJTZkCSU3ZCAlNmQiLAoJCQkJYnVzX2h6LCBzbG90X2h6LCB4LCBo
el94LCB5LCBoel95LCB6LCBoel96KTsKCgkJCXZlcmlmeV9oeihidXNfaHosIHNsb3RfaHosIGh6
X3gsICJPcmlnaW5hbCIpOwoJCQl2ZXJpZnlfaHooYnVzX2h6LCBzbG90X2h6LCBoel95LCAiVXBz
dHJlYW0iKTsKCQkJdmVyaWZ5X2h6KGJ1c19oeiwgc2xvdF9oeiwgaHpfeiwgIkdHRyIpOwoKCQkJ
aWYgKHggIT0geSkKI2lmIDAKLyogV2Uga25vdyBvcmlnaW5hbCAoMy40IGtlcm5lbCkgdmVyc2lv
biB3YXMgYnVnZ3kuCiAqIERvbid0IGhhdmUgdG8gYmUgcXVpdGUgc28gbG91ZCBhYm91dCBpdC4K
ICovCgkJCQlwcmludGYoIkRFQlVHOiBPcmlnICE9IFVwc3RyZWFtXG4iLAoJCQkJCWJ1c19oeiwg
c2xvdF9oeik7CgojZWxzZQoJCQkJcHJpbnRmKCIgW09yaWcgRml4ZWRdIik7CiNlbmRpZgoJCQlp
ZiAoeiAhPSB5KQoJCQkJcHJpbnRmKCIgV0FSTjogR0dHICE9IFVwc3RyZWFtIik7CgoJCQlwcmlu
dGYoIlxuIik7CgkJfQoJfQp9Cgo=
--f46d043749e174d12504d8eb8891--
