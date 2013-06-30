Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab3F3Vta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 17:49:30 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48721 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab3F3VtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 17:49:17 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130630181945.GA5171@redhat.com>
References: <CA+icZUXo=Z4gDfCMvLqRQDq_fpNAq+UqtUw=jrU=3=kVZP-2+A@mail.gmail.com>
	<20130630181945.GA5171@redhat.com>
Date: Sun, 30 Jun 2013 23:49:15 +0200
Message-ID: <CA+icZUV5PhY9pFxbR-paBe-CZMVQNKk3chdATvocgqDixM1oeQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 28 [ BISECTED: rsyslog/imklog: High CPU
 usage ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Lukas Czerner <lczerner@redhat.com>,
        Samuel Ortiz <samuel@sortiz.org>, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Ralf Baechle <ralf@linux-mips.org>, Valdis.Kletnieks@vt.edu
Content-Type: multipart/mixed; boundary=f46d0437450155363504e06615f8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0437450155363504e06615f8
Content-Type: text/plain; charset=UTF-8

On Sun, Jun 30, 2013 at 8:19 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> Andrew, please drop these
>
>         wait-introduce-wait_event_commonwq-condition-state-timeout.patch
>         wait-introduce-prepare_to_wait_event.patch
>
> patches again. I'll send v3 although it really looks like I should
> never try to touch wait.h.
>
> On 06/29, Sedat Dilek wrote:
>>
>> As this all did not show me what caused the problem I started a
>> git-bisect session.
>>
>> This revealed the following culprit commit:
>>
>>      commit bb1f30cb7d3ba21098f0ee7e0382160ba2599a43
>>      "wait: introduce wait_event_common(wq, condition, state, timeout)"
>
> Heh. First of all, I am really sorry.
>
> Not only "__wait_no_timeout(tout) ?:" was wrong, I didn't bother
> to recheck this logic even after I got the "warning: the omitted
> middle operand in ?:" reports.
>
> Sedat, thanks you very much! Any chance you can try the patch below?
>

Thanks for the quick fix!

No worries. Good we catched the issue, now.

Yupp, the patch fixes the issue here.

Please, send a patch against reported tree (here: next-20130628) next time.
( Attached is the one which applied here. )

I have zero clue about that "tout-tout" and "?" but you should keep
coding-style within your patch?
...
+                       __ret = __wait_no_timeout(tout) ? 0 :           \
+                                                       (__tout ?: 1);
 \ <--- ((__tout) ?: 1) like below ((tout) ?: 1)
...
+               __ret = __wait_no_timeout(tout) ? 0 : ((tout) ?: 1);    \

Feel free to give credits :-).

- Sedat -

> Oleg.
>
>
> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -191,12 +191,8 @@ wait_queue_head_t *bit_waitqueue(void *, int);
>         for (;;) {                                                      \
>                 __ret = prepare_to_wait_event(&wq, &__wait, state);     \
>                 if (condition) {                                        \
> -                       __ret = __wait_no_timeout(tout);                \
> -                       if (!__ret) {                                   \
> -                               __ret = __tout;                         \
> -                               if (!__ret)                             \
> -                                       __ret = 1;                      \
> -                       }                                               \
> +                       __ret = __wait_no_timeout(tout) ? 0 :           \
> +                                                       (__tout ?: 1);  \
>                         break;                                          \
>                 }                                                       \
>                                                                         \
> @@ -217,16 +213,10 @@ wait_queue_head_t *bit_waitqueue(void *, int);
>  #define wait_event_common(wq, condition, state, tout)                  \
>  ({                                                                     \
>         long __ret;                                                     \
> -       if (condition) {                                                \
> -               __ret = __wait_no_timeout(tout);                        \
> -               if (!__ret) {                                           \
> -                       __ret = tout;                                   \
> -                       if (!__ret)                                     \
> -                               __ret = 1;                              \
> -               }                                                       \
> -       } else {                                                        \
> +       if (condition)                                                  \
> +               __ret = __wait_no_timeout(tout) ? 0 : ((tout) ?: 1);    \
> +       else                                                            \
>                 __ret = __wait_event_common(wq, condition, state, tout);\
> -       }                                                               \
>         __ret;                                                          \
>  })
>
>

--f46d0437450155363504e06615f8
Content-Type: application/octet-stream; 
	name="3.10.0-rc7-next20130628-10-iniza-small.patch"
Content-Disposition: attachment; 
	filename="3.10.0-rc7-next20130628-10-iniza-small.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hikrs5x20

QW5kcmV3IE1vcnRvbiAoMSk6CiAgICAgIHdhaXQtaW50cm9kdWNlLXdhaXRfZXZlbnRfY29tbW9u
d3EtY29uZGl0aW9uLXN0YXRlLXRpbWVvdXQtZml4CgpEYXZlIEFpcmxpZSAoMik6CiAgICAgIGRy
bS9vbWFwOiBkcm9wIHRoZSAhRkJfT01BUDIgZGVwCiAgICAgIFJldmVydCAiZHJtOiBrbXNfaGVs
cGVyOiBkb24ndCBsb3NlIGhvdHBsdWcgZXZlbnQiCgpPbGVnIE5lc3Rlcm92ICgyKToKICAgICAg
d2FpdDogaW50cm9kdWNlIHdhaXRfZXZlbnRfY29tbW9uKHdxLCBjb25kaXRpb24sIHN0YXRlLCB0
aW1lb3V0KQogICAgICB3YWl0OiBpbnRyb2R1Y2UgcHJlcGFyZV90b193YWl0X2V2ZW50KCkKClNl
ZGF0IERpbGVrICgxMyk6CiAgICAgIGtidWlsZDogZGViLXBrZzogVHJ5IHRvIGRldGVybWluZSBk
aXN0cmlidXRpb24KICAgICAga2J1aWxkOiBkZWItcGtnOiBCdW1wIHllYXIgaW4gZGViaWFuL2Nv
cHlyaWdodCBmaWxlCiAgICAgIGtidWlsZDogZGViLXBrZzogVXBkYXRlIGdpdCByZXBvc2l0b3J5
IFVSTCBpbiBkZWJpYW4vY29weXJpZ2h0IGZpbGUKICAgICAgTWVyZ2UgdGFnICduZXh0LTIwMTMw
NjI4JyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy8uLi4vbmV4dC9saW51eC1uZXh0IGludG8gTGlu
dXgtTmV4dC12MjAxMzA2MjgKICAgICAgUmV2ZXJ0ICJmaXggd2FybmluZ3MgZnJvbSA/OiBvcGVy
YXRvciBpbiB3YWl0LmgiCiAgICAgIFJldmVydCAid2FpdDogaW50cm9kdWNlIHByZXBhcmVfdG9f
d2FpdF9ldmVudCgpIgogICAgICBSZXZlcnQgIndhaXQ6IGludHJvZHVjZSB3YWl0X2V2ZW50X2Nv
bW1vbih3cSwgY29uZGl0aW9uLCBzdGF0ZSwgdGltZW91dCkiCiAgICAgIHdhaXQ6IFRlc3QgcGF0
Y2ggZnJvbSBPLiBOZXN0ZXJvdiB0byBmaXggdGhlIHJzeXNsb2cvaW1rbG9nIGlzc3VlCiAgICAg
IE1lcmdlIGJyYW5jaCAnZGViLXBrZy0zLjEwLWZpeGVzJyBpbnRvIDMuMTAuMC1yYzctbmV4dDIw
MTMwNjI4LTEwLWluaXphLXNtYWxsCiAgICAgIE1lcmdlIGJyYW5jaCAnZHJtLW5leHQtZml4ZXMn
IGludG8gMy4xMC4wLXJjNy1uZXh0MjAxMzA2MjgtMTAtaW5pemEtc21hbGwKICAgICAgTWVyZ2Ug
YnJhbmNoICdyZXZlcnQtd2FpdC5oLW5leHQyMDEzMDYyOCcgaW50byAzLjEwLjAtcmM3LW5leHQy
MDEzMDYyOC0xMC1pbml6YS1zbWFsbAogICAgICBNZXJnZSBicmFuY2ggJ3dhaXQuaC1uZXh0LWZp
eGVzLWZyb20tYWtwbS1tbW90cycgaW50byAzLjEwLjAtcmM3LW5leHQyMDEzMDYyOC0xMC1pbml6
YS1zbWFsbAogICAgICBNZXJnZSBicmFuY2ggJ3dhaXQuaC1maXgtb25lc3Rlcm92JyBpbnRvIDMu
MTAuMC1yYzctbmV4dDIwMTMwNjI4LTEwLWluaXphLXNtYWxsCgogZHJpdmVycy9ncHUvZHJtL2Ry
bV9jcnRjX2hlbHBlci5jIHwgMzIgKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIGRy
aXZlcnMvZ3B1L2RybS9vbWFwZHJtL0tjb25maWcgICB8ICAyICstCiBpbmNsdWRlL2RybS9kcm1f
Y3J0Yy5oICAgICAgICAgICAgfCAgMSAtCiBpbmNsdWRlL2xpbnV4L3dhaXQuaCAgICAgICAgICAg
ICAgfCAxOSArKysrKy0tLS0tLS0tLS0tLS0tCiBzY3JpcHRzL3BhY2thZ2UvYnVpbGRkZWIgICAg
ICAgICAgfCAxOSArKysrKysrKysrKysrKysrLS0tCiA1IGZpbGVzIGNoYW5nZWQsIDIzIGluc2Vy
dGlvbnMoKyksIDUwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9k
cm1fY3J0Y19oZWxwZXIuYyBiL2RyaXZlcnMvZ3B1L2RybS9kcm1fY3J0Y19oZWxwZXIuYwppbmRl
eCBmNjgyOWJhLi43MzhhNDI5IDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vZHJtX2NydGNf
aGVscGVyLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2RybV9jcnRjX2hlbHBlci5jCkBAIC0xMjIs
NyArMTIyLDYgQEAgaW50IGRybV9oZWxwZXJfcHJvYmVfc2luZ2xlX2Nvbm5lY3Rvcl9tb2Rlcyhz
dHJ1Y3QgZHJtX2Nvbm5lY3RvciAqY29ubmVjdG9yLAogCWludCBjb3VudCA9IDA7CiAJaW50IG1v
ZGVfZmxhZ3MgPSAwOwogCWJvb2wgdmVyYm9zZV9wcnVuZSA9IHRydWU7Ci0JZW51bSBkcm1fY29u
bmVjdG9yX3N0YXR1cyBvbGRfc3RhdHVzOwogCiAJRFJNX0RFQlVHX0tNUygiW0NPTk5FQ1RPUjol
ZDolc11cbiIsIGNvbm5lY3Rvci0+YmFzZS5pZCwKIAkJCWRybV9nZXRfY29ubmVjdG9yX25hbWUo
Y29ubmVjdG9yKSk7CkBAIC0xMzgsMzIgKzEzNyw3IEBAIGludCBkcm1faGVscGVyX3Byb2JlX3Np
bmdsZV9jb25uZWN0b3JfbW9kZXMoc3RydWN0IGRybV9jb25uZWN0b3IgKmNvbm5lY3RvciwKIAkJ
aWYgKGNvbm5lY3Rvci0+ZnVuY3MtPmZvcmNlKQogCQkJY29ubmVjdG9yLT5mdW5jcy0+Zm9yY2Uo
Y29ubmVjdG9yKTsKIAl9IGVsc2UgewotCQlvbGRfc3RhdHVzID0gY29ubmVjdG9yLT5zdGF0dXM7
Ci0KIAkJY29ubmVjdG9yLT5zdGF0dXMgPSBjb25uZWN0b3ItPmZ1bmNzLT5kZXRlY3QoY29ubmVj
dG9yLCB0cnVlKTsKLQotCQkvKgotCQkgKiBOb3JtYWxseSBlaXRoZXIgdGhlIGRyaXZlcidzIGhw
ZCBjb2RlIG9yIHRoZSBwb2xsIGxvb3Agc2hvdWxkCi0JCSAqIHBpY2sgdXAgYW55IGNoYW5nZXMg
YW5kIGZpcmUgdGhlIGhvdHBsdWcgZXZlbnQuIEJ1dCBpZgotCQkgKiB1c2Vyc3BhY2Ugc25lYWtz
IGluIGEgcHJvYmUsIHdlIG1pZ2h0IG1pc3MgYSBjaGFuZ2UuIEhlbmNlCi0JCSAqIGNoZWNrIGhl
cmUsIGFuZCBpZiBhbnl0aGluZyBjaGFuZ2VkIHN0YXJ0IHRoZSBob3RwbHVnIGNvZGUuCi0JCSAq
LwotCQlpZiAob2xkX3N0YXR1cyAhPSBjb25uZWN0b3ItPnN0YXR1cykgewotCQkJRFJNX0RFQlVH
X0tNUygiW0NPTk5FQ1RPUjolZDolc10gc3RhdHVzIHVwZGF0ZWQgZnJvbSAlZCB0byAlZFxuIiwK
LQkJCQkgICAgICBjb25uZWN0b3ItPmJhc2UuaWQsCi0JCQkJICAgICAgZHJtX2dldF9jb25uZWN0
b3JfbmFtZShjb25uZWN0b3IpLAotCQkJCSAgICAgIG9sZF9zdGF0dXMsIGNvbm5lY3Rvci0+c3Rh
dHVzKTsKLQotCQkJLyoKLQkJCSAqIFRoZSBob3RwbHVnIGV2ZW50IGNvZGUgbWlnaHQgY2FsbCBp
bnRvIHRoZSBmYgotCQkJICogaGVscGVycywgYW5kIHNvIGV4cGVjdHMgdGhhdCB3ZSBkbyBub3Qg
aG9sZCBhbnkKLQkJCSAqIGxvY2tzLiBGaXJlIHVwIHRoZSBwb2xsIHN0cnVjdCBpbnN0ZWFkLCBp
dCB3aWxsCi0JCQkgKiBkaXNhYmxlIGl0c2VsZiBhZ2Fpbi4KLQkJCSAqLwotCQkJZGV2LT5tb2Rl
X2NvbmZpZy5kZWxheWVkX2V2ZW50ID0gdHJ1ZTsKLQkJCXNjaGVkdWxlX2RlbGF5ZWRfd29yaygm
ZGV2LT5tb2RlX2NvbmZpZy5vdXRwdXRfcG9sbF93b3JrLAotCQkJCQkgICAgICAwKTsKLQkJfQog
CX0KIAogCS8qIFJlLWVuYWJsZSBwb2xsaW5nIGluIGNhc2UgdGhlIGdsb2JhbCBwb2xsIGNvbmZp
ZyBjaGFuZ2VkLiAqLwpAQCAtMTAxMSwxMSArOTg1LDcgQEAgc3RhdGljIHZvaWQgb3V0cHV0X3Bv
bGxfZXhlY3V0ZShzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJc3RydWN0IGRybV9kZXZpY2Ug
KmRldiA9IGNvbnRhaW5lcl9vZihkZWxheWVkX3dvcmssIHN0cnVjdCBkcm1fZGV2aWNlLCBtb2Rl
X2NvbmZpZy5vdXRwdXRfcG9sbF93b3JrKTsKIAlzdHJ1Y3QgZHJtX2Nvbm5lY3RvciAqY29ubmVj
dG9yOwogCWVudW0gZHJtX2Nvbm5lY3Rvcl9zdGF0dXMgb2xkX3N0YXR1czsKLQlib29sIHJlcG9s
bCA9IGZhbHNlLCBjaGFuZ2VkOwotCi0JLyogUGljayB1cCBhbnkgY2hhbmdlcyBkZXRlY3RlZCBi
eSB0aGUgcHJvYmUgZnVuY3Rpb25zLiAqLwotCWNoYW5nZWQgPSBkZXYtPm1vZGVfY29uZmlnLmRl
bGF5ZWRfZXZlbnQ7Ci0JZGV2LT5tb2RlX2NvbmZpZy5kZWxheWVkX2V2ZW50ID0gZmFsc2U7CisJ
Ym9vbCByZXBvbGwgPSBmYWxzZSwgY2hhbmdlZCA9IGZhbHNlOwogCiAJaWYgKCFkcm1fa21zX2hl
bHBlcl9wb2xsKQogCQlyZXR1cm47CmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vb21hcGRy
bS9LY29uZmlnIGIvZHJpdmVycy9ncHUvZHJtL29tYXBkcm0vS2NvbmZpZwppbmRleCA0NTg3NWEw
Li4yMGM0MWU3IDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vb21hcGRybS9LY29uZmlnCisr
KyBiL2RyaXZlcnMvZ3B1L2RybS9vbWFwZHJtL0tjb25maWcKQEAgLTEsNyArMSw3IEBACiAKIGNv
bmZpZyBEUk1fT01BUAogCXRyaXN0YXRlICJPTUFQIERSTSIKLQlkZXBlbmRzIG9uIERSTSAmJiAh
RkJfT01BUDIKKwlkZXBlbmRzIG9uIERSTQogCWRlcGVuZHMgb24gQVJDSF9PTUFQMlBMVVMgfHwg
QVJDSF9NVUxUSVBMQVRGT1JNCiAJZGVwZW5kcyBvbiBPTUFQMl9EU1MKIAlzZWxlY3QgRFJNX0tN
U19IRUxQRVIKZGlmZiAtLWdpdCBhL2luY2x1ZGUvZHJtL2RybV9jcnRjLmggYi9pbmNsdWRlL2Ry
bS9kcm1fY3J0Yy5oCmluZGV4IDY2M2MzYWIuLmZhMTJhMmYgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUv
ZHJtL2RybV9jcnRjLmgKKysrIGIvaW5jbHVkZS9kcm0vZHJtX2NydGMuaApAQCAtODExLDcgKzgx
MSw2IEBAIHN0cnVjdCBkcm1fbW9kZV9jb25maWcgewogCS8qIG91dHB1dCBwb2xsIHN1cHBvcnQg
Ki8KIAlib29sIHBvbGxfZW5hYmxlZDsKIAlib29sIHBvbGxfcnVubmluZzsKLQlib29sIGRlbGF5
ZWRfZXZlbnQ7CiAJc3RydWN0IGRlbGF5ZWRfd29yayBvdXRwdXRfcG9sbF93b3JrOwogCiAJLyog
cG9pbnRlcnMgdG8gc3RhbmRhcmQgcHJvcGVydGllcyAqLwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9s
aW51eC93YWl0LmggYi9pbmNsdWRlL2xpbnV4L3dhaXQuaAppbmRleCBmM2I3OTNkLi41MDM0MjAz
IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L3dhaXQuaAorKysgYi9pbmNsdWRlL2xpbnV4L3dh
aXQuaApAQCAtMTk3LDEyICsxOTcsOCBAQCB3YWl0X3F1ZXVlX2hlYWRfdCAqYml0X3dhaXRxdWV1
ZSh2b2lkICosIGludCk7CiAJZm9yICg7OykgewkJCQkJCQlcCiAJCV9fcmV0ID0gcHJlcGFyZV90
b193YWl0X2V2ZW50KCZ3cSwgJl9fd2FpdCwgc3RhdGUpOwlcCiAJCWlmIChjb25kaXRpb24pIHsJ
CQkJCVwKLQkJCV9fcmV0ID0gX193YWl0X25vX3RpbWVvdXQodG91dCk7CQlcCi0JCQlpZiAoIV9f
cmV0KSB7CQkJCQlcCi0JCQkJX19yZXQgPSBfX3RvdXQ7CQkJCVwKLQkJCQlpZiAoIV9fcmV0KQkJ
CQlcCi0JCQkJCV9fcmV0ID0gMTsJCQlcCi0JCQl9CQkJCQkJXAorCQkJX19yZXQgPSBfX3dhaXRf
bm9fdGltZW91dCh0b3V0KSA/IDAgOgkJXAorCQkJCQkJCShfX3RvdXQgPzogMSk7CVwKIAkJCWJy
ZWFrOwkJCQkJCVwKIAkJfQkJCQkJCQlcCiAJCQkJCQkJCQlcCkBAIC0yMjMsMTQgKzIxOSw5IEBA
IHdhaXRfcXVldWVfaGVhZF90ICpiaXRfd2FpdHF1ZXVlKHZvaWQgKiwgaW50KTsKICNkZWZpbmUg
d2FpdF9ldmVudF9jb21tb24od3EsIGNvbmRpdGlvbiwgc3RhdGUsIHRvdXQpCQkJXAogKHsJCQkJ
CQkJCQlcCiAJbG9uZyBfX3JldDsJCQkJCQkJXAotCWlmIChjb25kaXRpb24pIHsJCQkJCQlcCi0J
CV9fcmV0ID0gX193YWl0X25vX3RpbWVvdXQodG91dCk7CQkJXAotCQlpZiAoIV9fcmV0KSB7CQkJ
CQkJXAotCQkJX19yZXQgPSAodG91dCk7CQkJCQlcCi0JCQlpZiAoIV9fcmV0KQkJCQkJXAotCQkJ
CV9fcmV0ID0gMTsJCQkJXAotCQl9CQkJCQkJCVwKLQl9IGVsc2UJCQkJCQkJCVwKKwlpZiAoY29u
ZGl0aW9uKQkJCQkJCQlcCisJCV9fcmV0ID0gX193YWl0X25vX3RpbWVvdXQodG91dCkgPyAwIDog
KCh0b3V0KSA/OiAxKTsJXAorCWVsc2UJCQkJCQkJCVwKIAkJX19yZXQgPSBfX3dhaXRfZXZlbnRf
Y29tbW9uKHdxLCBjb25kaXRpb24sIHN0YXRlLCB0b3V0KTtcCiAJX19yZXQ7CQkJCQkJCQlcCiB9
KQpkaWZmIC0tZ2l0IGEvc2NyaXB0cy9wYWNrYWdlL2J1aWxkZGViIGIvc2NyaXB0cy9wYWNrYWdl
L2J1aWxkZGViCmluZGV4IGFjYjg2NTAuLjdkN2M5ZDggMTAwNjQ0Ci0tLSBhL3NjcmlwdHMvcGFj
a2FnZS9idWlsZGRlYgorKysgYi9zY3JpcHRzL3BhY2thZ2UvYnVpbGRkZWIKQEAgLTE3Miw5ICsx
NzIsMjIgQEAgZWxzZQogZmkKIG1haW50YWluZXI9IiRuYW1lIDwkZW1haWw+IgogCisjIFRyeSB0
byBkZXRlcm1pbmUgZGlzdHJpYnV0aW9uCitpZiBbIC1lICQod2hpY2ggbHNiX3JlbGVhc2UpIF07
IHRoZW4KKyAgICAgICBjb2RlbmFtZT0kKGxzYl9yZWxlYXNlIC0tY29kZW5hbWUgLS1zaG9ydCkK
KyAgICAgICBpZiBbICIkY29kZW5hbWUiICE9ICIiIF07IHRoZW4KKwkJZGlzdHJpYnV0aW9uPSRj
b2RlbmFtZQorICAgICAgIGVsc2UKKwkJZGlzdHJpYnV0aW9uPSJVTlJFTEVBU0VEIgorCQllY2hv
ICJXQVJOSU5HOiBUaGUgZGlzdHJpYnV0aW9uIGNvdWxkIE5PVCBiZSBkZXRlcm1pbmVkISIKKyAg
ICAgICBmaQorZWxzZQorICAgICAgIGVjaG8gIkhJTlQ6IEluc3RhbGwgbHNiX3JlbGVhc2UgYmlu
YXJ5LCB0aGlzIGhlbHBzIHRvIGlkZW50aWZ5IHlvdXIgZGlzdHJpYnV0aW9uISIKK2ZpCisKICMg
R2VuZXJhdGUgYSBzaW1wbGUgY2hhbmdlbG9nIHRlbXBsYXRlCiBjYXQgPDxFT0YgPiBkZWJpYW4v
Y2hhbmdlbG9nCi1saW51eC11cHN0cmVhbSAoJHBhY2thZ2V2ZXJzaW9uKSB1bnN0YWJsZTsgdXJn
ZW5jeT1sb3cKK2xpbnV4LXVwc3RyZWFtICgkcGFja2FnZXZlcnNpb24pICRkaXN0cmlidXRpb247
IHVyZ2VuY3k9bG93CiAKICAgKiBDdXN0b20gYnVpbHQgTGludXgga2VybmVsLgogCkBAIC0xODgs
MTAgKzIwMSwxMCBAQCBUaGlzIGlzIGEgcGFja2Fja2VkIHVwc3RyZWFtIHZlcnNpb24gb2YgdGhl
IExpbnV4IGtlcm5lbC4KIFRoZSBzb3VyY2VzIG1heSBiZSBmb3VuZCBhdCBtb3N0IExpbnV4IGZ0
cCBzaXRlcywgaW5jbHVkaW5nOgogZnRwOi8vZnRwLmtlcm5lbC5vcmcvcHViL2xpbnV4L2tlcm5l
bAogCi1Db3B5cmlnaHQ6IDE5OTEgLSAyMDA5IExpbnVzIFRvcnZhbGRzIGFuZCBvdGhlcnMuCitD
b3B5cmlnaHQ6IDE5OTEgLSAyMDEzIExpbnVzIFRvcnZhbGRzIGFuZCBvdGhlcnMuCiAKIFRoZSBn
aXQgcmVwb3NpdG9yeSBmb3IgbWFpbmxpbmUga2VybmVsIGRldmVsb3BtZW50IGlzIGF0OgotZ2l0
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4
LTIuNi5naXQKK2dpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90
b3J2YWxkcy9saW51eC5naXQKIAogICAgIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5
b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5CiAgICAgaXQgdW5kZXIgdGhlIHRl
cm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQgYnkK
--f46d0437450155363504e06615f8--
