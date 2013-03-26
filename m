Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab3CZWxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:53:54 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:59426 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab3CZWxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:53:51 -0400
MIME-Version: 1.0
In-Reply-To: <1364338202-10311-1-git-send-email-grundler@chromium.org>
References: <1364338202-10311-1-git-send-email-grundler@chromium.org>
Date: Tue, 26 Mar 2013 15:53:50 -0700
X-Google-Sender-Auth: tiJJHn_EWeLkLp3vLpgdI7OX_tc
Message-ID: <CANEJEGs1hpm9_bKgSuYsJtWSxvc3FjCd6ihYXhvVpEt2UdKV4w@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: rewrite CLKDIV computation
From: Grant Grundler <grundler@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Doug Anderson <dianders@chromium.org>, Will Newton <will.newton@gmail.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Bing Zhao <bzhao@marvell.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ashok Nagarajan <asnagarajan@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e01184998884cf004d8dbcba7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01184998884cf004d8dbcba7
Content-Type: text/plain; charset=UTF-8

I've attached the test program I wrote to compare the different
flavors of CLKDIV computation: old (3.4 kernel), current upstream, and
my rewrite.

thanks
grant

On Tue, Mar 26, 2013 at 3:50 PM, Grant Grundler <grundler@chromium.org> wrote:
> Last year Seungwon Jeon (Samsung) fixed a bug in CLKDIV computation.
> But when debugging a related issue (http://crbug.com/221828) I found
> the code unreadable.  This rewrite simplifies the computation and
> explains each step.
>
> Signed-off-by: Grant Grundler <grundler@chromium.org>
> ---
> Tested on Samsung Series 3 Chromebook (exynos 5250 chipset) using
> ChromeOS 3.4 kernel (not 3.9-rc3 which this patch is based against).
>
> I've written a test program to confirm this patch generates the
> same correct values and will share that separately.
>
>  drivers/mmc/host/dw_mmc.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
>
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 9834221..6fdf55b 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -631,14 +631,22 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>
>         if (slot->clock != host->current_speed || force_clkinit) {
>                 div = host->bus_hz / slot->clock;
> -               if (host->bus_hz % slot->clock && host->bus_hz > slot->clock)
> -                       /*
> -                        * move the + 1 after the divide to prevent
> -                        * over-clocking the card.
> +               if (host->bus_hz > slot->clock) {
> +                       /* don't overclock due to integer math losses */
> +                       if ((div * slot->clock) < host->bus_hz)
> +                               div++;
> +
> +                       /* don't overclock due to resolution of HW */
> +                       if (div & 1)
> +                               div++;
> +
> +                       /* See 6.2.3 CLKDIV in "Mobile Storage Host Databook"
> +                        * Look for dwc_mobile_storage_db.pdf from Synopsys.
> +                        * CLKDIV value 0 means divisor 1, val 1 -> 2, ...
>                          */
> -                       div += 1;
> -
> -               div = (host->bus_hz != slot->clock) ? DIV_ROUND_UP(div, 2) : 0;
> +                       div /= 2;
> +               } else
> +                       div = 0;        /* use bus_hz */
>
>                 dev_info(&slot->mmc->class_dev,
>                          "Bus speed (slot %d) = %dHz (slot req %dHz, actual %dHZ"
> --
> 1.8.1.3
>

--089e01184998884cf004d8dbcba7
Content-Type: text/x-csrc; charset=US-ASCII; name="test_dw_mmc.c"
Content-Disposition: attachment; filename="test_dw_mmc.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hernuyrx0

I2luY2x1ZGUgPHN0ZGlvLmg+CgovKiBmcm9tIGluY2x1ZGUvbGludXgva2VybmVsLmggKi8KI2Rl
ZmluZSBESVZfUk9VTkRfVVAobixkKSAoKChuKSArIChkKSAtIDEpIC8gKGQpKQoKdW5zaWduZWQg
aW50IG9yaWdpbmFsKHVuc2lnbmVkIGludCBidXNfaHosIHVuc2lnbmVkIGludCBjbG9jaykKewoJ
dW5zaWduZWQgaW50IGRpdjsKCglpZiAoYnVzX2h6ICUgY2xvY2spCgkJLyoKCQkgKiBtb3ZlIHRo
ZSArIDEgYWZ0ZXIgdGhlIGRpdmlkZSB0byBwcmV2ZW50CgkJICogb3Zlci1jbG9ja2luZyB0aGUg
Y2FyZC4KCQkgKi8KCQlkaXYgPSAoKGJ1c19oeiAvIGNsb2NrKSA+PiAxKSArIDE7CgllbHNlCgkJ
ZGl2ID0gKGJ1c19oeiAgLyBjbG9jaykgPj4gMTsKCglyZXR1cm4gZGl2Owp9Cgp1bnNpZ25lZCBp
bnQgdXBzdHJlYW0odW5zaWduZWQgaW50IGJ1c19oeiwgdW5zaWduZWQgaW50IGNsb2NrKQp7Cgl1
bnNpZ25lZCBpbnQgZGl2OwoKCWRpdiA9IGJ1c19oeiAvIGNsb2NrOwoJaWYgKGJ1c19oeiAlIGNs
b2NrICYmIGJ1c19oeiA+IGNsb2NrKQoJCS8qCgkJICogbW92ZSB0aGUgKyAxIGFmdGVyIHRoZSBk
aXZpZGUgdG8gcHJldmVudAoJIAkgKiBvdmVyLWNsb2NraW5nIHRoZSBjYXJkLgoJCSAqLwoJCWRp
diArPSAxOwoKCWRpdiA9IChidXNfaHogIT0gY2xvY2spID8gRElWX1JPVU5EX1VQKGRpdiwgMikg
OiAwOwoKCXJldHVybiBkaXY7Cn0KCgp1bnNpZ25lZCBpbnQgZ2dnKHVuc2lnbmVkIGludCBidXNf
aHosIHVuc2lnbmVkIGludCBjbG9jaykKewoJdW5zaWduZWQgaW50IGRpdjsKCglkaXYgPSBidXNf
aHogLyBjbG9jazsKCWlmIChidXNfaHogPiBjbG9jaykgewoJCS8qIGRvbid0IG92ZXJjbG9jayBk
dWUgdG8gaW50ZWdlciBtYXRoIGxvc3NlcyAqLwoJCWlmICgoZGl2ICogY2xvY2spIDwgYnVzX2h6
KQoJCQlkaXYrKzsKCgkJLyogZG9uJ3Qgb3ZlcmNsb2NrIGR1ZSB0byByZXNvbHV0aW9uIG9mIEhX
ICovCgkJaWYgKGRpdiAmIDEpCgkJCWRpdisrOwoKCQkvKiBTZWUgNi4yLjMgQ0xLRElWIGluICJN
b2JpbGUgU3RvcmFnZSBIb3N0IERhdGFib29rIgoJCSAqIExvb2sgZm9yIGR3Y19tb2JpbGVfc3Rv
cmFnZV9kYi5wZGYgZnJvbSBTeW5vcHN5cy4KCQkgKiBDTEtESVYgdmFsdWUgMCBtZWFucyBkaXZp
c29yIDEsIHZhbHVlIDEgLT4gMiwgdmFsIDIgLT4gNCBldGMuCgkJICovCgkJZGl2IC89IDI7Cgl9
IGVsc2UKCQlkaXYgPSAwOwkvKiB1c2UgYnVzX2h6ICovCgoJcmV0dXJuIGRpdjsKfQoKdW5zaWdu
ZWQgaW50IGJ1c19oel90YmxbXSA9IHsgMTMsIDE3LCAxOSwgMjAsIDUwMDAwMDAwLCAxMDAwMDAw
MDB9Owp1bnNpZ25lZCBpbnQgc2xvdF9oel90YmxbXSA9IHsgMTAsIDEzLCAyMSwgNDAsIDU3LCA0
MDAwMDAsIDc4NDMxNCwgNTIwMDAwMDB9OwoKc3RhdGljIHVuc2lnbmVkIGludCBkaXZfdG9faHoo
dW5zaWduZWQgaW50IGJ1c19oeiwgdW5zaWduZWQgaW50IGQpCnsKCSByZXR1cm4gZCA/IChidXNf
aHovKGQqMikpIDogYnVzX2h6Owp9CgpzdGF0aWMgdm9pZCB2ZXJpZnlfaHoodW5zaWduZWQgaW50
IGJ1c19oeiwgdW5zaWduZWQgaW50IHJlcXVlc3RlZF9oeiwKCQl1bnNpZ25lZCBpbnQgZGl2aWRl
ZF9oeiwgY29uc3QgY2hhciAqYWxnb19uYW1lKQp7CglpZiAoZGl2aWRlZF9oeiA+IGJ1c19oeikK
CQlwcmludGYoIiBbRkFJTDogICVzID4gYnVzIGh6IV0iLCBhbGdvX25hbWUpOwoKCWlmIChkaXZp
ZGVkX2h6ID4gcmVxdWVzdGVkX2h6KQoJCXByaW50ZigiIFtGQUlMOiAlcyA+IHNsb3QgaHohXSIs
IGFsZ29fbmFtZSk7Cn0KCnZvaWQgbWFpbih2b2lkKQp7Cgl1bnNpZ25lZCBpbnQgaSwgajsKCglw
cmludGYoImJ1cy9zbG90IGh6IAlPcmlnaW5hbAlVcHN0cmVhbQlHR0dcbiIpOwoJZm9yKGk9MDsg
aSA8IHNpemVvZihidXNfaHpfdGJsKS9zaXplb2YodW5zaWduZWQgaW50KTsgaSsrKSB7CgkJdW5z
aWduZWQgaW50IGJ1c19oeiA9IGJ1c19oel90YmxbaV07CgkJZm9yIChqPTA7IGogPCBzaXplb2Yo
c2xvdF9oel90YmwpL3NpemVvZih1bnNpZ25lZCBpbnQpOyBqKyspIHsKCQkJdW5zaWduZWQgaW50
IHNsb3RfaHogPSBzbG90X2h6X3RibFtqXTsKCQkJdW5zaWduZWQgaW50IHggPSBvcmlnaW5hbChi
dXNfaHosIHNsb3RfaHopOwoJCQl1bnNpZ25lZCBpbnQgeSA9IHVwc3RyZWFtKGJ1c19oeiwgc2xv
dF9oeik7CgkJCXVuc2lnbmVkIGludCB6ID0gZ2dnKGJ1c19oeiwgc2xvdF9oeik7CgoJCQl1bnNp
Z25lZCBpbnQgaHpfeCwgaHpfeSwgaHpfejsKCgkJCWh6X3ggPSBkaXZfdG9faHooYnVzX2h6LCB4
KTsKCQkJaHpfeSA9IGRpdl90b19oeihidXNfaHosIHkpOwoJCQloel96ID0gZGl2X3RvX2h6KGJ1
c19oeiwgeik7CgoJCQlwcmludGYoIiU4ZC8lNmQJJTdkICU2ZAklN2QgJTZkCSU3ZCAlNmQiLAoJ
CQkJYnVzX2h6LCBzbG90X2h6LCB4LCBoel94LCB5LCBoel95LCB6LCBoel96KTsKCgkJCXZlcmlm
eV9oeihidXNfaHosIHNsb3RfaHosIGh6X3gsICJPcmlnaW5hbCIpOwoJCQl2ZXJpZnlfaHooYnVz
X2h6LCBzbG90X2h6LCBoel95LCAiVXBzdHJlYW0iKTsKCQkJdmVyaWZ5X2h6KGJ1c19oeiwgc2xv
dF9oeiwgaHpfeiwgIkdHRyIpOwoKCQkJaWYgKHggIT0geSkKI2lmIDAKLyogV2Uga25vdyBvcmln
aW5hbCAoMy40IGtlcm5lbCkgdmVyc2lvbiB3YXMgYnVnZ3kuCiAqIERvbid0IGhhdmUgdG8gYmUg
cXVpdGUgc28gbG91ZCBhYm91dCBpdC4KICovCgkJCQlwcmludGYoIkRFQlVHOiBPcmlnICE9IFVw
c3RyZWFtXG4iLAoJCQkJCWJ1c19oeiwgc2xvdF9oeik7CgojZWxzZQoJCQkJcHJpbnRmKCIgW09y
aWcgRml4ZWRdIik7CiNlbmRpZgoJCQlpZiAoeiAhPSB5KQoJCQkJcHJpbnRmKCIgV0FSTjogR0dH
ICE9IFVwc3RyZWFtIik7CgoJCQlwcmludGYoIlxuIik7CgkJfQoJfQp9Cgo=
--089e01184998884cf004d8dbcba7--
