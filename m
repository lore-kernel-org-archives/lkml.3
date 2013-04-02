Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874Ab3DBMBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 08:01:05 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:36453 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759513Ab3DBMBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 08:01:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAH3Oq6SZHjjMDLbYNrgzZazsBXW61Z8_MjCoG7nwYNOe=eerPw@mail.gmail.com>
References: <1364549049-29278-1-git-send-email-ning.n.jiang@gmail.com>
	<5158C9B8.3070208@linaro.org>
	<CAH3Oq6SZHjjMDLbYNrgzZazsBXW61Z8_MjCoG7nwYNOe=eerPw@mail.gmail.com>
Date: Tue, 2 Apr 2013 20:01:00 +0800
Message-ID: <CAH3Oq6Q=dQ732w0EqK1yG8WwSiG6O6dpB7cXYj2QKH5MfAPRow@mail.gmail.com>
Subject: Re: [PATCH] ARM: timer: Shutdown clock event device when stopping
 local timer
From: Ning Jiang <ning.n.jiang@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux@arm.linux.org.uk, kgene.kim@samsung.com, davidb@codeaurora.org,
        dwalker@fifo99.com, bryanh@codeaurora.org, john.stultz@linaro.org,
        tglx@linutronix.de, linus.walleij@linaro.org, shawn.guo@linaro.org,
        rob.herring@calxeda.com, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: multipart/mixed; boundary=bcaec54eed56b3ed0d04d95f7d62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec54eed56b3ed0d04d95f7d62
Content-Type: text/plain; charset=ISO-8859-1

2013/4/1 Ning Jiang <ning.n.jiang@gmail.com>:
> 2013/4/1 Daniel Lezcano <daniel.lezcano@linaro.org>:
>> On 03/29/2013 10:24 AM, ning.n.jiang@gmail.com wrote:
>>> From: Ning Jiang <ning.n.jiang@gmail.com>
>>>
>>> Currently there are two problems when we try to stop local timer.
>>> First, it calls set_mode function directly so mode state is not
>>> updated for the clock event device. Second, it makes the device
>>> unused instead of shutdown.
>>>
>>> A subtle error will happen because of it. When a cpu is plugged out
>>> it will stop the local timer. It will call tick_nohz_idle_enter()
>>> in idle thread afterwards. It will cancel the sched timer and try
>>> to reprogram the next event. This is wrong since the local timer
>>> is supposed to be stopped.
>>>
>>> The right way to stop the local timer is to shutdown it by calling
>>> clockevents_set_mode(). Thus when we try to reprogram the clock
>>> event device, it will return directly without doing anything since
>>> the clock mode is CLOCK_EVT_MODE_SHUTDOWN.
>>>
>>> Signed-off-by: Ning Jiang <ning.n.jiang@gmail.com>
>>> ---
>>>  arch/arm/kernel/smp_twd.c                |    2 +-
>>>  arch/arm/mach-exynos/mct.c               |    2 +-
>>>  arch/arm/mach-msm/timer.c                |    2 +-
>>>  drivers/clocksource/arm_arch_timer.c     |    2 +-
>>>  drivers/clocksource/time-armada-370-xp.c |    2 +-
>>>  5 files changed, 5 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
>>> index 3f25650..c1d4ab4 100644
>>> --- a/arch/arm/kernel/smp_twd.c
>>> +++ b/arch/arm/kernel/smp_twd.c
>>> @@ -92,7 +92,7 @@ static int twd_timer_ack(void)
>>>
>>>  static void twd_timer_stop(struct clock_event_device *clk)
>>>  {
>>> -     twd_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
>>> +     clockevents_set_mode(clk, CLOCK_EVT_MODE_SHUTDOWN);
>>>       disable_percpu_irq(clk->irq);
>>
>> Wouldn't be clockevents_shutdown more adequate here ? The next event
>> will be also set.
>
> You're right. clockevents_shutdown seems more appropriate here. I'll
> submit a revised patch for it.
>

Here attached the revised patch. Any more comments?

--bcaec54eed56b3ed0d04d95f7d62
Content-Type: application/octet-stream; 
	name="0001-ARM-timer-Shutdown-clock-event-device-when-stopping-.patch"
Content-Disposition: attachment; 
	filename="0001-ARM-timer-Shutdown-clock-event-device-when-stopping-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hf10m0zo0

RnJvbSBmMWJlM2E0NTM4Yjc1MGQwNjM2ODNlNzcxY2RlYTY2NTdiNTg5NDhhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaW5nIEppYW5nIDxuaW5nLm4uamlhbmdAZ21haWwuY29tPgpE
YXRlOiBGcmksIDI5IE1hciAyMDEzIDE2OjAzOjUxICswODAwClN1YmplY3Q6IFtQQVRDSF0gQVJN
OiB0aW1lcjogU2h1dGRvd24gY2xvY2sgZXZlbnQgZGV2aWNlIHdoZW4gc3RvcHBpbmcgbG9jYWwg
dGltZXIKCkN1cnJlbnRseSB0aGVyZSBhcmUgdHdvIHByb2JsZW1zIHdoZW4gd2UgdHJ5IHRvIHN0
b3AgbG9jYWwgdGltZXIuCkZpcnN0LCBpdCBjYWxscyBzZXRfbW9kZSBmdW5jdGlvbiBkaXJlY3Rs
eSBzbyBtb2RlIHN0YXRlIGlzIG5vdAp1cGRhdGVkIGZvciB0aGUgY2xvY2sgZXZlbnQgZGV2aWNl
LiBTZWNvbmQsIGl0IG1ha2VzIHRoZSBkZXZpY2UKdW51c2VkIGluc3RlYWQgb2Ygc2h1dGRvd24u
CgpBIHN1YnRsZSBlcnJvciB3aWxsIGhhcHBlbiBiZWNhdXNlIG9mIGl0LiBXaGVuIGEgY3B1IGlz
IHBsdWdnZWQgb3V0Cml0IHdpbGwgc3RvcCB0aGUgbG9jYWwgdGltZXIuIEl0IHdpbGwgY2FsbCB0
aWNrX25vaHpfaWRsZV9lbnRlcigpCmluIGlkbGUgdGhyZWFkIGFmdGVyd2FyZHMuIEl0IHdpbGwg
Y2FuY2VsIHRoZSBzY2hlZCB0aW1lciBhbmQgdHJ5CnRvIHJlcHJvZ3JhbSB0aGUgbmV4dCBldmVu
dC4gVGhpcyBpcyB3cm9uZyBzaW5jZSB0aGUgbG9jYWwgdGltZXIKaXMgc3VwcG9zZWQgdG8gYmUg
c3RvcHBlZC4KClRoZSByaWdodCB3YXkgdG8gc3RvcCB0aGUgbG9jYWwgdGltZXIgaXMgdG8gc2h1
dGRvd24gaXQgYnkgY2FsbGluZwpjbG9ja2V2ZW50c19zZXRfbW9kZSgpLiBUaHVzIHdoZW4gd2Ug
dHJ5IHRvIHJlcHJvZ3JhbSB0aGUgY2xvY2sKZXZlbnQgZGV2aWNlLCBpdCB3aWxsIHJldHVybiBk
aXJlY3RseSB3aXRob3V0IGRvaW5nIGFueXRoaW5nIHNpbmNlCnRoZSBjbG9jayBtb2RlIGlzIENM
T0NLX0VWVF9NT0RFX1NIVVRET1dOLgoKU2lnbmVkLW9mZi1ieTogTmluZyBKaWFuZyA8bmluZy5u
LmppYW5nQGdtYWlsLmNvbT4KLS0tCiBhcmNoL2FybS9rZXJuZWwvc21wX3R3ZC5jICAgICAgICAg
ICAgICAgIHwgICAgMiArLQogYXJjaC9hcm0vbWFjaC1leHlub3MvbWN0LmMgICAgICAgICAgICAg
ICB8ICAgIDIgKy0KIGFyY2gvYXJtL21hY2gtbXNtL3RpbWVyLmMgICAgICAgICAgICAgICAgfCAg
ICAyICstCiBkcml2ZXJzL2Nsb2Nrc291cmNlL2FybV9hcmNoX3RpbWVyLmMgICAgIHwgICAgMiAr
LQogZHJpdmVycy9jbG9ja3NvdXJjZS90aW1lLWFybWFkYS0zNzAteHAuYyB8ICAgIDIgKy0KIDUg
ZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2FyY2gvYXJtL2tlcm5lbC9zbXBfdHdkLmMgYi9hcmNoL2FybS9rZXJuZWwvc21wX3R3ZC5j
CmluZGV4IDNmMjU2NTAuLjAwZmVlMzYgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtL2tlcm5lbC9zbXBf
dHdkLmMKKysrIGIvYXJjaC9hcm0va2VybmVsL3NtcF90d2QuYwpAQCAtOTIsNyArOTIsNyBAQCBz
dGF0aWMgaW50IHR3ZF90aW1lcl9hY2sodm9pZCkKIAogc3RhdGljIHZvaWQgdHdkX3RpbWVyX3N0
b3Aoc3RydWN0IGNsb2NrX2V2ZW50X2RldmljZSAqY2xrKQogewotCXR3ZF9zZXRfbW9kZShDTE9D
S19FVlRfTU9ERV9VTlVTRUQsIGNsayk7CisJY2xvY2tldmVudHNfc2h1dGRvd24oY2xrKTsKIAlk
aXNhYmxlX3BlcmNwdV9pcnEoY2xrLT5pcnEpOwogfQogCmRpZmYgLS1naXQgYS9hcmNoL2FybS9t
YWNoLWV4eW5vcy9tY3QuYyBiL2FyY2gvYXJtL21hY2gtZXh5bm9zL21jdC5jCmluZGV4IGM5ZDY2
NTAuLmFmYzFkOWIgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtL21hY2gtZXh5bm9zL21jdC5jCisrKyBi
L2FyY2gvYXJtL21hY2gtZXh5bm9zL21jdC5jCkBAIC00MjksNyArNDI5LDcgQEAgc3RhdGljIGlu
dCBfX2NwdWluaXQgZXh5bm9zNF9sb2NhbF90aW1lcl9zZXR1cChzdHJ1Y3QgY2xvY2tfZXZlbnRf
ZGV2aWNlICpldnQpCiBzdGF0aWMgdm9pZCBleHlub3M0X2xvY2FsX3RpbWVyX3N0b3Aoc3RydWN0
IGNsb2NrX2V2ZW50X2RldmljZSAqZXZ0KQogewogCXVuc2lnbmVkIGludCBjcHUgPSBzbXBfcHJv
Y2Vzc29yX2lkKCk7Ci0JZXZ0LT5zZXRfbW9kZShDTE9DS19FVlRfTU9ERV9VTlVTRUQsIGV2dCk7
CisJY2xvY2tldmVudHNfc2h1dGRvd24oZXZ0KTsKIAlpZiAobWN0X2ludF90eXBlID09IE1DVF9J
TlRfU1BJKQogCQlpZiAoY3B1ID09IDApCiAJCQlyZW1vdmVfaXJxKGV2dC0+aXJxLCAmbWN0X3Rp
Y2swX2V2ZW50X2lycSk7CmRpZmYgLS1naXQgYS9hcmNoL2FybS9tYWNoLW1zbS90aW1lci5jIGIv
YXJjaC9hcm0vbWFjaC1tc20vdGltZXIuYwppbmRleCAyOTY5MDI3Li44M2Q1MzgxIDEwMDY0NAot
LS0gYS9hcmNoL2FybS9tYWNoLW1zbS90aW1lci5jCisrKyBiL2FyY2gvYXJtL21hY2gtbXNtL3Rp
bWVyLmMKQEAgLTE1Miw3ICsxNTIsNyBAQCBzdGF0aWMgaW50IF9fY3B1aW5pdCBtc21fbG9jYWxf
dGltZXJfc2V0dXAoc3RydWN0IGNsb2NrX2V2ZW50X2RldmljZSAqZXZ0KQogCiBzdGF0aWMgdm9p
ZCBtc21fbG9jYWxfdGltZXJfc3RvcChzdHJ1Y3QgY2xvY2tfZXZlbnRfZGV2aWNlICpldnQpCiB7
Ci0JZXZ0LT5zZXRfbW9kZShDTE9DS19FVlRfTU9ERV9VTlVTRUQsIGV2dCk7CisJY2xvY2tldmVu
dHNfc2h1dGRvd24oZXZ0KTsKIAlkaXNhYmxlX3BlcmNwdV9pcnEoZXZ0LT5pcnEpOwogfQogCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2Nsb2Nrc291cmNlL2FybV9hcmNoX3RpbWVyLmMgYi9kcml2ZXJz
L2Nsb2Nrc291cmNlL2FybV9hcmNoX3RpbWVyLmMKaW5kZXggZDdhZDQyNS4uMTJmMTg2ZSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9jbG9ja3NvdXJjZS9hcm1fYXJjaF90aW1lci5jCisrKyBiL2RyaXZl
cnMvY2xvY2tzb3VyY2UvYXJtX2FyY2hfdGltZXIuYwpAQCAtMjQyLDcgKzI0Miw3IEBAIHN0YXRp
YyB2b2lkIF9fY3B1aW5pdCBhcmNoX3RpbWVyX3N0b3Aoc3RydWN0IGNsb2NrX2V2ZW50X2Rldmlj
ZSAqY2xrKQogCQkJZGlzYWJsZV9wZXJjcHVfaXJxKGFyY2hfdGltZXJfcHBpW1BIWVNfTk9OU0VD
VVJFX1BQSV0pOwogCX0KIAotCWNsay0+c2V0X21vZGUoQ0xPQ0tfRVZUX01PREVfVU5VU0VELCBj
bGspOworCWNsb2NrZXZlbnRzX3NodXRkb3duKGNsayk7CiB9CiAKIHN0YXRpYyBpbnQgX19jcHVp
bml0IGFyY2hfdGltZXJfY3B1X25vdGlmeShzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKnNlbGYsCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2Nsb2Nrc291cmNlL3RpbWUtYXJtYWRhLTM3MC14cC5jIGIvZHJp
dmVycy9jbG9ja3NvdXJjZS90aW1lLWFybWFkYS0zNzAteHAuYwppbmRleCA0N2E2NzMwLi4zZGE0
ODYxIDEwMDY0NAotLS0gYS9kcml2ZXJzL2Nsb2Nrc291cmNlL3RpbWUtYXJtYWRhLTM3MC14cC5j
CisrKyBiL2RyaXZlcnMvY2xvY2tzb3VyY2UvdGltZS1hcm1hZGEtMzcwLXhwLmMKQEAgLTIwMSw3
ICsyMDEsNyBAQCBzdGF0aWMgaW50IF9fY3B1aW5pdCBhcm1hZGFfMzcwX3hwX3RpbWVyX3NldHVw
KHN0cnVjdCBjbG9ja19ldmVudF9kZXZpY2UgKmV2dCkKIAogc3RhdGljIHZvaWQgIGFybWFkYV8z
NzBfeHBfdGltZXJfc3RvcChzdHJ1Y3QgY2xvY2tfZXZlbnRfZGV2aWNlICpldnQpCiB7Ci0JZXZ0
LT5zZXRfbW9kZShDTE9DS19FVlRfTU9ERV9VTlVTRUQsIGV2dCk7CisJY2xvY2tldmVudHNfc2h1
dGRvd24oZXZ0KTsKIAlkaXNhYmxlX3BlcmNwdV9pcnEoZXZ0LT5pcnEpOwogfQogCi0tIAoxLjcu
MQoK
--bcaec54eed56b3ed0d04d95f7d62--
