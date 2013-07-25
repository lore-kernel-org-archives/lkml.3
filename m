Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab3GYP3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:29:19 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58636 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab3GYP3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:29:16 -0400
MIME-Version: 1.0
Date: Thu, 25 Jul 2013 23:29:15 +0800
Message-ID: <CABawtvM8D_FUPuRmi-ETwWGWMoS3X4ZATy2tB1RbCY-ku-aunA@mail.gmail.com>
Subject: [PATCH] hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
From: Ethan Zhao <ethan.kernel@gmail.com>
To: tglx@linutronix.de, mingo@kernel.org
Cc: johlstei@codeaurora.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b3a93865ca1cc04e257b031
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b3a93865ca1cc04e257b031
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

commit 968320b hrtimer: Fix extra wakeups from __remove_hrtimer()
introduced a significant scheduling
performance regression, following is the test:

a. Test environment:
SUN FIRE X4170 M2 SERVER
CPU model name: Intel(R) Xeon(R) CPU X5675  @ 3.07GHz
2 socket X 6 core X 2 thread

b. To eliminate the disturbing of variable frequency technology of
Intel CPU. We disabled the C-States, P-States
T-States etc SpeedStep, Turboboost, power management in BIOS configuration.

c. Test case:
1.test tool (Any better tools ?)
  http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test-1m.c
2.after boot the test kernel a few minutes, execute
 $time ./pipe-test-1m
  collect data output by time like:
  real    0m9.326s
  user    0m0.352s
  sys     0m5.640s
3.after the test case finished a few seconds, redo the same one.

d. Test result data
Test kernel without patch 968320b hrtimer: Fix extra wakeups from
__remove_hrtimer() /
Or applied this patch to disable reprogramming in remove_hrtimer()
---------------------------------------------------------------------------=
------------------------------
|      |    1     |     2    |   3      |    4     |    5     | 6    |
   7     |    8     |   AVG        |
---------------------------------------------------------------------------=
------------------------------
| real | 0m5.328s | 0m5.372s | 0m5.307s | 0m5.307s | 0m5.330s |
0m5.315s | 0m5.318s | 0m5.317s | 5.32425s |
---------------------------------------------------------------------------=
------------------------------
| user | 0m0.106s | 0m0.098s | 0m0.108s | 0m0.120s | 0m0.113s |
0m0.121s | 0m0.125s | 0m0.103s | 0.11175s |
---------------------------------------------------------------------------=
------------------------------
| sys  | 0m2.287s | 0m2.334s | 0m2.269s | 0m2.269s | 0m2.298s |
0m2.274s | 0m2.263s | 0m2.292s | 2.28575s |
---------------------------------------------------------------------------=
------------------------------

With patch 968320b hrtimer: Fix extra wakeups from __remove_hrtimer()
Redo the test more than 10 times, select 8 of them, collect the data
into following tables.
---------------------------------------------------------------------------=
------------------------------
|      |    1     |     2    |   3      |    4     |    5     | 6    |
   7     |    8     |   AVG       |
---------------------------------------------------------------------------=
------------------------------
| real | 0m7.132s | 0m6.741s | 0m6.996s | 0m9.269s | 0m6.742s |
0m6.977s | 0m6.802s | 0m6.957s | 7.202s   |
---------------------------------------------------------------------------=
------------------------------
| user | 0m0.033s | 0m0.031s | 0m0.048s | 0m0.436s | 0m0.022s |
0m0.005s | 0m0.014s | 0m0.014s | 0.075375s|
---------------------------------------------------------------------------=
------------------------------
| sys  | 0m3.119s | 0m2.940s | 0m3.185s | 0m4.023s | 0m3.053s |
0m3.152s | 0m3.054s | 0m3.124s | 3.20625s |
---------------------------------------------------------------------------=
------------------------------

e. Conclusion
We found the performance has 1.87775S(average value) down introduced by com=
mit
968320b hrtimer: Fix extra wakeups from __remove_hrtimer().
That is more than -35% !

Disable reprogramming in remove_hrtimer() to fix this performance regressio=
n:
function remove_hrtimer() with reprogramming the clock device is
called in following two functions:

1. In function hrtimer_try_to_cancel()
    Whatever you reprogram the clock device or not, the timer function
wouldn=92t be called anymore. So set reprogram
to 0 doesn=92t change the result of hrtimer_try_to_cancel()

           hrtimer_try_to_cancel()
           --- > remove_hrtimer()
               ---- > __remove_hrtimer(timer, base, state, reprogram);

2. In function  __hrtimer_start_range_ns(),
    After remove_hrtimer() was called, the rest of code in this
function will check the new timer added into queue is
the leftmost or not, if needed, will reprogram the clock device.

     __hrtimer_start_range_ns()
    {
      =85 =85
      ret =3D remove_hrtimer(timer, base);
      =85 =85
      leftmost =3D enqueue_hrtimer(timer, new_base);
      if (leftmost && new_base->cpu_base =3D=3D &__get_cpu_var(hrtimer_base=
s)
&& hrtimer_enqueue_reprogram(timer, new_base)) {
      =85 =85
    }

Will we lose the chance to reprogram the clock device after remove_hrtimer(=
) ?
I think No, Because we didn=92t reprogram the clock device in
remove_hrtimer(), if the timer removed is just the next one
will expire, we still could get reprogrammed in hrtimer_interrupt().
So reprogramming in remove_hrtimer() is not necessary-----If I am
wrong, just point out.

Why
   commit 968320b hrtimer: Fix extra wakeups from __remove_hrtimer()
Introduced performance regression?
The reprogramming is expensive ?  not cheap so far.
We lost one chance to wakeup?
Yes, commit 968320b actually will delay the next expiry time to the
timer next to the one removed. and it looks rational.
If the extra wakeup is not harmful, We really need it to keep the
performance and get the chance to wakeup in time.

Reported-by: lijun.huang@oracle.com <lijun.huang@oracle.com>
Signed-off-by: ethan.zhao <ethan.zhao@oracle.com>
---
 kernel/hrtimer.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index fd4b13b..742dc6b 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -934,26 +934,16 @@ remove_hrtimer(struct hrtimer *timer, struct
hrtimer_clock_base *base)
 {
  if (hrtimer_is_queued(timer)) {
  unsigned long state;
- int reprogram;

- /*
- * Remove the timer and force reprogramming when high
- * resolution mode is active and the timer is on the current
- * CPU. If we remove a timer on another CPU, reprogramming is
- * skipped. The interrupt event on this CPU is fired and
- * reprogramming happens in the interrupt handler. This is a
- * rare case and less expensive than a smp call.
- */
  debug_deactivate(timer);
  timer_stats_hrtimer_clear_start_info(timer);
- reprogram =3D base->cpu_base =3D=3D &__get_cpu_var(hrtimer_bases);
  /*
  * We must preserve the CALLBACK state flag here,
  * otherwise we could move the timer base in
  * switch_hrtimer_base.
  */
  state =3D timer->state & HRTIMER_STATE_CALLBACK;
- __remove_hrtimer(timer, base, state, reprogram);
+ __remove_hrtimer(timer, base, state, 0);
  return 1;
  }
  return 0;
--=20
1.7.1

--047d7b3a93865ca1cc04e257b031
Content-Type: application/octet-stream; name="hrtimer_noreprog.patch"
Content-Disposition: attachment; filename="hrtimer_noreprog.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hjk456pe0

RnJvbSAwOTVjODE4OGEyZTZjNjkxMWI2OWNkYWUzOGY0Y2FiNjcyYzE2MjEwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogZXRoYW4uemhhbyA8ZXRoYW4uemhhb0BvcmFjbGUuY29tPg0K
RGF0ZTogVGh1LCAyNSBKdWwgMjAxMyAxODowMDozMSAtMDQwMA0KU3ViamVjdDogW1BBVENIXSBo
cnRpbWVyOiBGaXggYSBwZXJmb3JtYW5jZSByZWdyZXNzaW9uIGJ5IGRpc2FibGUgcmVwcm9ncmFt
bWluZyBpbiByZW1vdmVfaHJ0aW1lcg0KY29tbWl0IDk2ODMyMGIgaHJ0aW1lcjogRml4IGV4dHJh
IHdha2V1cHMgZnJvbSBfX3JlbW92ZV9ocnRpbWVyKCkgaW50cm9kdWNlZCBhIHNpZ25pZmljYW50
IHNjaGVkdWxlciANCnBlcmZvcm1hbmNlIHJlZ3Jlc3Npb24sIGZvbGxvd2luZyBpcyB0aGUgdGVz
dDoNCg0KYS4gVGVzdCBlbnZpcm9ubWVudDoNClNVTiBGSVJFIFg0MTcwIE0yIFNFUlZFUg0KQ1BV
IG1vZGVsIG5hbWU6IEludGVsKFIpIFhlb24oUikgQ1BVIFg1Njc1ICBAIDMuMDdHSHoNCjIgc29j
a2V0IFggNiBjb3JlIFggMiB0aHJlYWQNCg0KYi4gVG8gZWxpbWluYXRlIHRoZSBkaXN0dXJiaW5n
IG9mIHZhcmlhYmxlIGZyZXF1ZW5jeSB0ZWNobm9sb2d5IG9mIEludGVsIENQVS4gV2UgZGlzYWJs
ZWQgdGhlIEMtU3RhdGVzLCBQLVN0YXRlcw0KVC1TdGF0ZXMgZXRjIFNwZWVkU3RlcCwgVHVyYm9i
b29zdCwgcG93ZXIgbWFuYWdlbWVudCBpbiBCSU9TIGNvbmZpZ3VyYXRpb24uDQoNCmMuIFRlc3Qg
Y2FzZToNCjEudGVzdCB0b29sIChBbnkgYmV0dGVyIHRvb2xzID8pDQogIGh0dHA6Ly9wZW9wbGUu
cmVkaGF0LmNvbS9taW5nby9jZnMtc2NoZWR1bGVyL3Rvb2xzL3BpcGUtdGVzdC0xbS5jDQoyLmFm
dGVyIGJvb3QgdGhlIHRlc3Qga2VybmVsIGEgZmV3IG1pbnV0ZXMsIGV4ZWN1dGUNCiAkdGltZSAu
L3BpcGUtdGVzdC0xbQ0KICBjb2xsZWN0IGRhdGEgb3V0cHV0IGJ5IHRpbWUgbGlrZToNCiAgcmVh
bCAgICAwbTkuMzI2cw0KICB1c2VyICAgIDBtMC4zNTJzDQogIHN5cyAgICAgMG01LjY0MHMNCjMu
YWZ0ZXIgdGhlIHRlc3QgY2FzZSBmaW5pc2hlZCBhIGZldyBzZWNvbmRzLCByZWRvIHRoZSBzYW1l
IG9uZS4NCg0KZC4gVGVzdCByZXN1bHQgZGF0YQ0KVGVzdCBrZXJuZWwgd2l0aG91dCBwYXRjaCA5
NjgzMjBiIGhydGltZXI6IEZpeCBleHRyYSB3YWtldXBzIGZyb20gX19yZW1vdmVfaHJ0aW1lcigp
IC8NCk9yIGFwcGxpZWQgdGhpcyBwYXRjaCB0byBkaXNhYmxlIHJlcHJvZ3JhbW1pbmcgaW4gcmVt
b3ZlX2hydGltZXIoKQ0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tDQp8ICAgICAgfCAgICAxICAgICB8ICAgICAyICAgIHwgICAzICAgICAgfCAgICA0ICAg
ICB8ICAgIDUgICAgIHwgNiAgICB8ICAgIDcgICAgIHwgICAgOCAgICAgfCAgIEFWRyAgICAgICAg
fA0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQp8IHJl
YWwgfCAwbTUuMzI4cyB8IDBtNS4zNzJzIHwgMG01LjMwN3MgfCAwbTUuMzA3cyB8IDBtNS4zMzBz
IHwgMG01LjMxNXMgfCAwbTUuMzE4cyB8IDBtNS4zMTdzIHwgNS4zMjQyNXMgfA0KLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQp8IHVzZXIgfCAwbTAuMTA2
cyB8IDBtMC4wOThzIHwgMG0wLjEwOHMgfCAwbTAuMTIwcyB8IDBtMC4xMTNzIHwgMG0wLjEyMXMg
fCAwbTAuMTI1cyB8IDBtMC4xMDNzIHwgMC4xMTE3NXMgfA0KLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQp8IHN5cyAgfCAwbTIuMjg3cyB8IDBtMi4zMzRz
IHwgMG0yLjI2OXMgfCAwbTIuMjY5cyB8IDBtMi4yOThzIHwgMG0yLjI3NHMgfCAwbTIuMjYzcyB8
IDBtMi4yOTJzIHwgMi4yODU3NXMgfA0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQoNCldpdGggcGF0Y2ggOTY4MzIwYiBocnRpbWVyOiBGaXggZXh0cmEg
d2FrZXVwcyBmcm9tIF9fcmVtb3ZlX2hydGltZXIoKQ0KUmVkbyB0aGUgdGVzdCBtb3JlIHRoYW4g
MTAgdGltZXMsIHNlbGVjdCA4IG9mIHRoZW0sIGNvbGxlY3QgdGhlIGRhdGEgaW50byBmb2xsb3dp
bmcgdGFibGVzLg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tDQp8ICAgICAgfCAgICAxICAgICB8ICAgICAyICAgIHwgICAzICAgICAgfCAgICA0ICAgICB8
ICAgIDUgICAgIHwgNiAgICB8ICAgIDcgICAgIHwgICAgOCAgICAgfCAgIEFWRyAgICAgICB8DQot
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCnwgcmVhbCB8
IDBtNy4xMzJzIHwgMG02Ljc0MXMgfCAwbTYuOTk2cyB8IDBtOS4yNjlzIHwgMG02Ljc0MnMgfCAw
bTYuOTc3cyB8IDBtNi44MDJzIHwgMG02Ljk1N3MgfCA3LjIwMnMgICB8DQotLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCnwgdXNlciB8IDBtMC4wMzNzIHwg
MG0wLjAzMXMgfCAwbTAuMDQ4cyB8IDBtMC40MzZzIHwgMG0wLjAyMnMgfCAwbTAuMDA1cyB8IDBt
MC4wMTRzIHwgMG0wLjAxNHMgfCAwLjA3NTM3NXN8DQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCnwgc3lzICB8IDBtMy4xMTlzIHwgMG0yLjk0MHMgfCAw
bTMuMTg1cyB8IDBtNC4wMjNzIHwgMG0zLjA1M3MgfCAwbTMuMTUycyB8IDBtMy4wNTRzIHwgMG0z
LjEyNHMgfCAzLjIwNjI1cyB8DQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCg0KZS4gQ29uY2x1c2lvbg0KV2UgZm91bmQgdGhlIHBlcmZvcm1hbmNlIGhh
cyAxLjg3Nzc1UyhhdmVyYWdlIHZhbHVlKSBkb3duIGludHJvZHVjZWQgYnkgY29tbWl0DQo5Njgz
MjBiIGhydGltZXI6IEZpeCBleHRyYSB3YWtldXBzIGZyb20gX19yZW1vdmVfaHJ0aW1lcigpLg0K
VGhhdCBpcyBtb3JlIHRoYW4gLTM1JSAhDQogDQpEaXNhYmxlIHJlcHJvZ3JhbW1pbmcgaW4gcmVt
b3ZlX2hydGltZXIoKSB0byBmaXggdGhpcyBwZXJmb3JtYW5jZSByZWdyZXNzaW9uOg0KZnVuY3Rp
b24gcmVtb3ZlX2hydGltZXIoKSB3aXRoIHJlcHJvZ3JhbW1pbmcgdGhlIGNsb2NrIGRldmljZSBp
cyBjYWxsZWQgaW4gZm9sbG93aW5nIHR3byBjYXNlczoNCg0KMS4JSW4gZnVuY3Rpb24gaHJ0aW1l
cl90cnlfdG9fY2FuY2VsKCkNCiAgICBXaGF0ZXZlciB5b3UgcmVwcm9ncmFtIHRoZSBjbG9jayBk
ZXZpY2Ugb3Igbm90LCB0aGUgdGltZXIgZnVuY3Rpb24gd291bGRu4oCZdCBiZSBjYWxsZWQgYW55
bW9yZS4gU28gc2V0IHJlcHJvZ3JhbSANCgl0byAwIGRvZXNu4oCZdCBjaGFuZ2UgdGhlIHJlc3Vs
dCBvZiBocnRpbWVyX3RyeV90b19jYW5jZWwoKQ0KDQogICAgICAgICAgIGhydGltZXJfdHJ5X3Rv
X2NhbmNlbCgpIA0KICAgICAgICAgICAtLS0gPiByZW1vdmVfaHJ0aW1lcigpIA0KICAgICAgICAg
ICAgICAgLS0tLSA+IF9fcmVtb3ZlX2hydGltZXIodGltZXIsIGJhc2UsIHN0YXRlLCByZXByb2dy
YW0pOw0KDQoyLglJbiBmdW5jdGlvbiAgX19ocnRpbWVyX3N0YXJ0X3JhbmdlX25zKCksIA0KICAg
IEFmdGVyIHJlbW92ZV9ocnRpbWVyKCkgd2FzIGNhbGxlZCwgdGhlIHJlc3Qgb2YgY29kZSBpbiB0
aGlzIGZ1bmN0aW9uIHdpbGwgY2hlY2sgdGhlIG5ldyB0aW1lciBhZGRlZCBpbnRvIHF1ZXVlIGlz
IA0KCXRoZSBsZWZ0bW9zdCBvciBub3QsIGlmIG5lZWRlZCwgd2lsbCByZXByb2dyYW0gdGhlIGNs
b2NrIGRldmljZS4NCg0KICAgICBfX2hydGltZXJfc3RhcnRfcmFuZ2VfbnMoKQ0KICAgIHsNCiAg
ICAgIOKApiDigKYNCiAgICAgIHJldCA9IHJlbW92ZV9ocnRpbWVyKHRpbWVyLCBiYXNlKTsgICAg
ICANCiAgICAgIOKApiDigKYNCiAgICAgIGxlZnRtb3N0ID0gZW5xdWV1ZV9ocnRpbWVyKHRpbWVy
LCBuZXdfYmFzZSk7DQogICAgICBpZiAobGVmdG1vc3QgJiYgbmV3X2Jhc2UtPmNwdV9iYXNlID09
ICZfX2dldF9jcHVfdmFyKGhydGltZXJfYmFzZXMpDQoJCSYmIGhydGltZXJfZW5xdWV1ZV9yZXBy
b2dyYW0odGltZXIsIG5ld19iYXNlKSkgew0KICAgICAg4oCmIOKApg0KICAgIH0NCg0KV2lsbCB3
ZSBsb3NlIHRoZSBjaGFuY2UgdG8gcmVwcm9ncmFtIHRoZSBjbG9jayBkZXZpY2UgYWZ0ZXIgcmVt
b3ZlX2hydGltZXIoKSA/DQpJIHRoaW5rIE5vLCBCZWNhdXNlIHdlIGRpZG7igJl0IHJlcHJvZ3Jh
bSB0aGUgY2xvY2sgZGV2aWNlIGluIHJlbW92ZV9ocnRpbWVyKCksIGlmIHRoZSB0aW1lciByZW1v
dmVkIGlzIGp1c3QgdGhlIG5leHQgb25lIA0Kd2lsbCBleHBpcmUsIHdlIHN0aWxsIGNvdWxkIGdl
dCByZXByb2dyYW1tZWQgaW4gaHJ0aW1lcl9pbnRlcnJ1cHQoKS4gICAgIA0KU28gcmVwcm9ncmFt
bWluZyBpbiByZW1vdmVfaHJ0aW1lcigpIGlzIG5vdCBuZWNlc3NhcnktLS0tLUlmIEkgYW0gd3Jv
bmcsIGp1c3QgcG9pbnQgb3V0Lg0KICAgICAgICAgIA0KV2h5IA0KICAgY29tbWl0IDk2ODMyMGIg
aHJ0aW1lcjogRml4IGV4dHJhIHdha2V1cHMgZnJvbSBfX3JlbW92ZV9ocnRpbWVyKCkgDQpJbnRy
b2R1Y2VkIHBlcmZvcm1hbmNlIHJlZ3Jlc3Npb24/DQpUaGUgcmVwcm9ncmFtbWluZyBpcyBleHBl
bnNpdmUgPyAgbm90IGNoZWFwIHNvIGZhci4NCldlIGxvc3Qgb25lIGNoYW5jZSB0byB3YWtldXA/
IA0KWWVzLCBjb21taXQgOTY4MzIwYiBhY3R1YWxseSB3aWxsIGRlbGF5IHRoZSBuZXh0IGV4cGly
eSB0aW1lIHRvIHRoZSB0aW1lciBuZXh0IHRvIHRoZSBvbmUgcmVtb3ZlZC4gYW5kIGl0IGxvb2tz
IHJhdGlvbmFsLg0KSWYgdGhlIGV4dHJhIHdha2V1cCBpcyBub3QgaGFybWZ1bCwgV2UgcmVhbGx5
IG5lZWQgaXQgdG8ga2VlcCB0aGUgcGVyZm9ybWFuY2UgYW5kIGdldCB0aGUgY2hhbmNlIHRvIHdh
a2V1cCBpbiB0aW1lLg0KDQpSZXBvcnRlZC1ieTogbGlqdW4uaHVhbmdAb3JhY2xlLmNvbSA8bGlq
dW4uaHVhbmdAb3JhY2xlLmNvbT4NClNpZ25lZC1vZmYtYnk6IGV0aGFuLnpoYW8gPGV0aGFuLnpo
YW9Ab3JhY2xlLmNvbT4NCi0tLQ0KIGtlcm5lbC9ocnRpbWVyLmMgfCAgIDEyICstLS0tLS0tLS0t
LQ0KIDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkNCg0K
ZGlmZiAtLWdpdCBhL2tlcm5lbC9ocnRpbWVyLmMgYi9rZXJuZWwvaHJ0aW1lci5jDQppbmRleCBm
ZDRiMTNiLi43NDJkYzZiIDEwMDY0NA0KLS0tIGEva2VybmVsL2hydGltZXIuYw0KKysrIGIva2Vy
bmVsL2hydGltZXIuYw0KQEAgLTkzNCwyNiArOTM0LDE2IEBAIHJlbW92ZV9ocnRpbWVyKHN0cnVj
dCBocnRpbWVyICp0aW1lciwgc3RydWN0IGhydGltZXJfY2xvY2tfYmFzZSAqYmFzZSkNCiB7DQog
CWlmIChocnRpbWVyX2lzX3F1ZXVlZCh0aW1lcikpIHsNCiAJCXVuc2lnbmVkIGxvbmcgc3RhdGU7
DQotCQlpbnQgcmVwcm9ncmFtOw0KIA0KLQkJLyoNCi0JCSAqIFJlbW92ZSB0aGUgdGltZXIgYW5k
IGZvcmNlIHJlcHJvZ3JhbW1pbmcgd2hlbiBoaWdoDQotCQkgKiByZXNvbHV0aW9uIG1vZGUgaXMg
YWN0aXZlIGFuZCB0aGUgdGltZXIgaXMgb24gdGhlIGN1cnJlbnQNCi0JCSAqIENQVS4gSWYgd2Ug
cmVtb3ZlIGEgdGltZXIgb24gYW5vdGhlciBDUFUsIHJlcHJvZ3JhbW1pbmcgaXMNCi0JCSAqIHNr
aXBwZWQuIFRoZSBpbnRlcnJ1cHQgZXZlbnQgb24gdGhpcyBDUFUgaXMgZmlyZWQgYW5kDQotCQkg
KiByZXByb2dyYW1taW5nIGhhcHBlbnMgaW4gdGhlIGludGVycnVwdCBoYW5kbGVyLiBUaGlzIGlz
IGENCi0JCSAqIHJhcmUgY2FzZSBhbmQgbGVzcyBleHBlbnNpdmUgdGhhbiBhIHNtcCBjYWxsLg0K
LQkJICovDQogCQlkZWJ1Z19kZWFjdGl2YXRlKHRpbWVyKTsNCiAJCXRpbWVyX3N0YXRzX2hydGlt
ZXJfY2xlYXJfc3RhcnRfaW5mbyh0aW1lcik7DQotCQlyZXByb2dyYW0gPSBiYXNlLT5jcHVfYmFz
ZSA9PSAmX19nZXRfY3B1X3ZhcihocnRpbWVyX2Jhc2VzKTsNCiAJCS8qDQogCQkgKiBXZSBtdXN0
IHByZXNlcnZlIHRoZSBDQUxMQkFDSyBzdGF0ZSBmbGFnIGhlcmUsDQogCQkgKiBvdGhlcndpc2Ug
d2UgY291bGQgbW92ZSB0aGUgdGltZXIgYmFzZSBpbg0KIAkJICogc3dpdGNoX2hydGltZXJfYmFz
ZS4NCiAJCSAqLw0KIAkJc3RhdGUgPSB0aW1lci0+c3RhdGUgJiBIUlRJTUVSX1NUQVRFX0NBTExC
QUNLOw0KLQkJX19yZW1vdmVfaHJ0aW1lcih0aW1lciwgYmFzZSwgc3RhdGUsIHJlcHJvZ3JhbSk7
DQorCQlfX3JlbW92ZV9ocnRpbWVyKHRpbWVyLCBiYXNlLCBzdGF0ZSwgMCk7DQogCQlyZXR1cm4g
MTsNCiAJfQ0KIAlyZXR1cm4gMDsNCi0tIA0KMS43LjE=
--047d7b3a93865ca1cc04e257b031--
