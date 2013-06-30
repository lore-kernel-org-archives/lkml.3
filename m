Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab3F3LuI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 07:50:08 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49007 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3F3LuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 07:50:04 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXo=Z4gDfCMvLqRQDq_fpNAq+UqtUw=jrU=3=kVZP-2+A@mail.gmail.com>
References: <CA+icZUXo=Z4gDfCMvLqRQDq_fpNAq+UqtUw=jrU=3=kVZP-2+A@mail.gmail.com>
Date: Sun, 30 Jun 2013 13:50:01 +0200
Message-ID: <CA+icZUUii2YvA8RQpTb-MC9xWDCQecA_HXoqXQreCKaTN=wTwg@mail.gmail.com>
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
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: multipart/mixed; boundary=089e013c683c4ecc4004e05db6d3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e013c683c4ecc4004e05db6d3
Content-Type: text/plain; charset=UTF-8

On Sat, Jun 29, 2013 at 11:44 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Jun 28, 2013 at 9:33 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> Changes since 20130627:
>>
>> This tree produces the following warning when built for many (all?)
>> configs (it has been fixed in the drm tree):
>>
>> drivers/video/Kconfig:42:error: recursive dependency detected!
>> drivers/video/Kconfig:42:       symbol FB is selected by DRM_KMS_HELPER
>> drivers/gpu/drm/Kconfig:29:     symbol DRM_KMS_HELPER is selected by DRM_OMAP
>> drivers/gpu/drm/omapdrm/Kconfig:2:      symbol DRM_OMAP depends on FB_OMAP2
>> drivers/video/omap2/omapfb/Kconfig:1:   symbol FB_OMAP2 depends on FB
>>
>> The arm-soc tree gained a conflict against the mfd tree.
>>
>> I applied a patch to the akpm tree to remove a lot of warnings.
>>
>
> [ I kept the CC list of the culprit commit (sorry if I forgot anyone) ]
>
> Hi,
>
> [ SYMPTOM ]
>
> Last Friday I wanted to listen to some music-videos on my
> next-20130628 kernel and noticed that my battery got sucked empty very
> fast.
> I could see with htop that 2 (of 4) rsyslogd processes ran on 100%.
>
> NOTE: next-20130627 (Thursday's Linux-Next) did NOT show these symptoms.
>
> [ "CSI dileks" CHECKS THE LOGS ]
>
> While investigating the logs I saw this:
>
> [ /var/log/syslog ]
> Jun 29 15:25:34 fambox rsyslogd: [origin software="rsyslogd"
> swVersion="5.8.6" x-pid="900" x-info="http://www.rsyslog.com"] exiting
> on signal 15.
> Jun 29 15:25:39 fambox kernel: imklog 5.8.6, log source = /proc/kmsg started.
> Jun 29 15:25:39 fambox rsyslogd: [origin software="rsyslogd"
> swVersion="5.8.6" x-pid="4689" x-info="http://www.rsyslog.com"] start
> Jun 29 15:25:39 fambox rsyslogd: rsyslogd's groupid changed to 103
> Jun 29 15:25:39 fambox rsyslogd: rsyslogd's userid changed to 101
> Jun 29 15:25:39 fambox rsyslogd-2039: Could not open output pipe
> '/dev/xconsole' [try http://www.rsyslog.com/e/2039 ]
> Jun 29 15:25:39 fambox kernel:
> Jun 29 15:26:09 fambox kernel: last message repeated 30176 times
> Jun 29 15:27:09 fambox kernel: last message repeated 59603 times
> Jun 29 15:28:09 fambox kernel: last message repeated 60081 times
> Jun 29 15:29:09 fambox kernel: last message repeated 60148 times
>
> [ 1ST TRYOUT ]
>
> [1] recommends to use a more modern rsyslog-version, so I upgraded
> from (5.8.6-1ubuntu8.4) to (7.4.1-0ubuntu1ppa1) from an unofficial
> 3rd-party software-archive [2] for Ubuntu/precise.
> This did not help - still 100% CPU usage observed.
>
> [ 2ND TRYOUT: WORKAROUND ]
>
> Following [1], I temporarily disabled imklog rsyslog-module:
>
> [ /etc/rsyslog.conf ]
> ...
> -$ModLoad imklog   # provides kernel logging support (previously done by rklogd)
> +# XXX: Workaround: Do NOT load imklog as it causes 100% CPU workload
> by flooding logs. -dileks
> +#$ModLoad imklog   # provides kernel logging support (previously done
> by rklogd)
>
> Yeah, this resulted in a "normal" system - no high CPU loads anymore
> (in idle-mode).
>
> [ CURIOSITY KILLED THE CAT ]
>
> I cannot say if this here is related...
>
> [ /var/log/syslog ]
> fambox rsyslogd-2039: Could not open output pipe '/dev/xconsole' [try
> http://www.rsyslog.com/e/2039 ]
>
> ...it looks like I have to create a '/dev/xconsole' manually.
>
>      root# mknod -m 640 /dev/xconsole p
>
> With the "BROKEN" kernel this IIRC did not help, the good one did not
> show xconsole-related stuff in the logs.
> But I might remember wrong.
>
> See also:
>
> [ /etc/rsyslog.d/50-default.conf ]
> ...
> # The named pipe /dev/xconsole is for the `xconsole' utility.  To use it,
> # you must invoke `xconsole' with the `-file' option:
> #
> #    $ xconsole -file /dev/xconsole [...]
> #
> # NOTE: adjust the list below, or you'll go crazy if you have a reasonably
> #      busy site..
> #
> daemon.*;mail.*;\
>         news.err;\
>         *.=debug;*.=info;\
>         *.=notice;*.=warn       |/dev/xconsole
> - EOF -
>
> Running manually 'xconsole -file /dev/xconsole' was not successful
> (could not open... device) with the bad kernel.
> Might be good to comment that xconsole block?
>
> [ GIT-BISECT SESSION ]
>
> As this all did not show me what caused the problem I started a
> git-bisect session.
>
> This revealed the following culprit commit:
>
>      commit bb1f30cb7d3ba21098f0ee7e0382160ba2599a43
>      "wait: introduce wait_event_common(wq, condition, state, timeout)"
>
> This commit was 1st introduced with Friday's next-20130628!
>
> NOTE: See also git-bisect-log.txt and git-bisect-visualize.txt for the results.
>
> Reverting it successfully with two other related patches results in a
> "normal" system again.
>
> See attached patch lists:
>       Revert "fix warnings from ?: operator in wait.h"
>       Revert "wait: introduce prepare_to_wait_event()"
>       Revert "wait: introduce wait_event_common(wq, condition, state, timeout)"
>
> [ GIVEAWAYS ]
>
> For the sake of completeness I have attached my kernel-config.
>
> Oleg, can you look at that?
> If you need more inputs lemme know.
>
> Thanks in advance.
>
> Regards,
> - Sedat -
>
> [1] http://www.gossamer-threads.com/lists/rsyslog/users/8087
> [2] https://launchpad.net/~tmortensen/+archive/rsyslogv7

Hi Andrew, Hi Stephen,

there seems to be a small hunk in wait.h to be different compared with
the wait.h-patches in next-20130628:

diff --git a/include/linux/wait.h b/include/linux/wait.h
index f3b793d..0a5573e 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -226,12 +226,13 @@ wait_queue_head_t *bit_waitqueue(void *, int);
        if (condition) {                                                \
                __ret = __wait_no_timeout(tout);                        \
                if (!__ret) {                                           \
-                       __ret = (tout);                                 \
+                       __ret = tout;                                   \
                        if (!__ret)                                     \
                                __ret = 1;                              \
                }                                                       \
-       } else                                                          \
+       } else {                                                        \
                __ret = __wait_event_common(wq, condition, state, tout);\
+       }                                                               \
        __ret;                                                          \
 })

I have attached the triple patchset from mmots whereas 3-3 as v2.

The high CPU workload still remains.

Regards,
- Sedat -

--089e013c683c4ecc4004e05db6d3
Content-Type: application/octet-stream; 
	name="1-3-wait-introduce-wait_event_commonwq-condition-state-timeout.patch"
Content-Disposition: attachment; 
	filename="1-3-wait-introduce-wait_event_commonwq-condition-state-timeout.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hik6czsd4

RnJvbTogT2xlZyBOZXN0ZXJvdiA8b2xlZ0ByZWRoYXQuY29tPgpTdWJqZWN0OiB3YWl0OiBpbnRy
b2R1Y2Ugd2FpdF9ldmVudF9jb21tb24od3EsIGNvbmRpdGlvbiwgc3RhdGUsIHRpbWVvdXQpCgox
LiA0YzY2M2NmYyAiZml4IGZhbHNlIHRpbWVvdXRzIHdoZW4gdXNpbmcgd2FpdF9ldmVudF90aW1l
b3V0KCkiCiAgIGlzIG5vdCBlbm91Z2gsIHdhaXQod3EsIHRydWUsIDApIHN0aWxsIHJldHVybnMg
emVyby4KCiAgIF9fd2FpdF9ldmVudF90aW1lb3V0KCkgd2FzIGFscmVhZHkgZml4ZWQgYnV0IHdl
IG5lZWQgdGhlIHNhbWUKICAgbG9naWMgaW4gd2FpdF9ldmVudF90aW1lb3V0KCkgaWYgdGhlIGZh
c3QtcGF0aCBjaGVjayBzdWNjZWVkcy4KCjIuIHdhaXRfZXZlbnRfdGltZW91dC9fX3dhaXRfZXZl
bnRfdGltZW91dCBpbnRlcmZhY2UgZG8gbm90IG1hdGNoCiAgIHdhaXRfZXZlbnQoKSwgeW91IGNh
bid0IHVzZSBfX3dhaXRfZXZlbnRfdGltZW91dCgpIGluc3RlYWQgb2YKICAgd2FpdF9ldmVudF90
aW1lb3V0KCkgaWYgeW91IGRvIG5vdCBuZWVkIHRoZSBmYXN0LXBhdGggY2hlY2suCgogICBTYW1l
IGZvciB3YWl0X2V2ZW50X2ludGVycnVwdGlibGUvX193YWl0X2V2ZW50X2ludGVycnVwdGlibGUs
CiAgIHNvIHRoaXMgcGF0Y2ggY2xlYW51cHMgcnRseC5jLCBpcF92c19zeW5jLmMsIGFuZCBhZl9p
cmRhLmM6CgoJLQlfX3dhaXRfZXZlbnRfaW50ZXJydXB0aWJsZSh3cSwgY29uZCwgcmV0KTsKCSsJ
cmV0ID0gX193YWl0X2V2ZW50X2ludGVycnVwdGlibGUod3EsIGNvbmQpOwoKMy4gd2FpdF9ldmVu
dF8qIG1hY3JvcyBkdXBsaWNhdGUgdGhlIHNhbWUgY29kZS4KClRoaXMgcGF0Y2ggYWRkcyBhIHNp
bmdsZSBoZWxwZXIgd2FpdF9ldmVudF9jb21tb24oKSB3aGljaCBob3BlZnVsbHkKZG9lcyBldmVy
eXRoaW5nIHJpZ2h0LiBDb21waWxlciBvcHRpbWl6ZXMgb3V0IHRoZSAiZGVhZCIgY29kZSB3aGVu
CndlIGRvIG5vdCBuZWVkIHNpZ25hbF9wZW5kaW5nL3NjaGVkdWxlX3RpbWVvdXQuCgoic2l6ZSB2
bWxpbnV4IiByZXBvcnRzOgoKCQkgICB0ZXh0CSAgIGRhdGEJICAgIGJzcwkgICAgZGVjCSAgICBo
ZXgJZmlsZW5hbWUKCS0JNDk3ODYwMQkyOTM1MDgwCTEwMTA0ODMyCTE4MDE4NTEzCTExMmYwZDEJ
dm1saW51eAoJKwk0OTc3NzY5CTI5MzA5ODQJMTAxMDQ4MzIJMTgwMTM1ODUJMTEyZGQ5MQl2bWxp
bnV4CgpidXQgSSB0aGluayB0aGlzIGRlcGVuZHMgb24gZ2NjL2NvbmZpZy4KCkluIHBhcnRpY3Vs
YXIsIHdhaXRfZXZlbl90aW1lb3V0KHRydWUsIG5vbl9jb25zdF90aW1lb3V0KSBzaG91bGQKZ2Vu
ZXJhdGUgbW9yZSBjb2RlIGluIHRoZSBub24tdm9pZCBjb250ZXh0IGJlY2F1c2UgdGhlIHBhdGNo
IGFkZHMKdGhlIGFkZGl0aW9uYWwgY29kZSB0byBmaXggdGhlIDFzdCBwcm9ibGVtLgoKU2lnbmVk
LW9mZi1ieTogT2xlZyBOZXN0ZXJvdiA8b2xlZ0ByZWRoYXQuY29tPgpSZXZpZXdlZC1ieTogVGVq
dW4gSGVvIDx0akBrZXJuZWwub3JnPgpDYzogRGFuaWVsIFZldHRlciA8ZGFuaWVsLnZldHRlckBm
ZndsbC5jaD4KQ2M6IEltcmUgRGVhayA8aW1yZS5kZWFrQGludGVsLmNvbT4KQ2M6IEx1a2FzIEN6
ZXJuZXIgPGxjemVybmVyQHJlZGhhdC5jb20+CkNjOiBTYW11ZWwgT3J0aXogPHNhbXVlbEBzb3J0
aXoub3JnPgpDYzogV2Vuc29uZyBaaGFuZyA8d2Vuc29uZ0BsaW51eC12cy5vcmc+CkNjOiBTaW1v
biBIb3JtYW4gPGhvcm1zQHZlcmdlLm5ldC5hdT4KQ2M6IEp1bGlhbiBBbmFzdGFzb3YgPGphQHNz
aS5iZz4KQ2M6IFJhbGYgQmFlY2hsZSA8cmFsZkBsaW51eC1taXBzLm9yZz4KU2lnbmVkLW9mZi1i
eTogQW5kcmV3IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4KLS0tCgogYXJjaC9t
aXBzL2tlcm5lbC9ydGx4LmMgICAgICAgICB8ICAgMTcgKy0KIGluY2x1ZGUvbGludXgvd2FpdC5o
ICAgICAgICAgICAgfCAgMTgzICsrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLQogbmV0L2ly
ZGEvYWZfaXJkYS5jICAgICAgICAgICAgICB8ICAgIDUgCiBuZXQvbmV0ZmlsdGVyL2lwdnMvaXBf
dnNfc3luYy5jIHwgICAgNSAKIDQgZmlsZXMgY2hhbmdlZCwgODIgaW5zZXJ0aW9ucygrKSwgMTI4
IGRlbGV0aW9ucygtKQoKZGlmZiAtcHVOIGFyY2gvbWlwcy9rZXJuZWwvcnRseC5jfndhaXQtaW50
cm9kdWNlLXdhaXRfZXZlbnRfY29tbW9ud3EtY29uZGl0aW9uLXN0YXRlLXRpbWVvdXQgYXJjaC9t
aXBzL2tlcm5lbC9ydGx4LmMKLS0tIGEvYXJjaC9taXBzL2tlcm5lbC9ydGx4LmN+d2FpdC1pbnRy
b2R1Y2Utd2FpdF9ldmVudF9jb21tb253cS1jb25kaXRpb24tc3RhdGUtdGltZW91dAorKysgYS9h
cmNoL21pcHMva2VybmVsL3J0bHguYwpAQCAtMTcyLDggKzE3Miw4IEBAIGludCBydGx4X29wZW4o
aW50IGluZGV4LCBpbnQgY2FuX3NsZWVwKQogCWlmIChydGx4ID09IE5VTEwpIHsKIAkJaWYoIChw
ID0gdnBlX2dldF9zaGFyZWQodGNsaW1pdCkpID09IE5VTEwpIHsKIAkJICAgIGlmIChjYW5fc2xl
ZXApIHsKLQkJCV9fd2FpdF9ldmVudF9pbnRlcnJ1cHRpYmxlKGNoYW5uZWxfd3FzW2luZGV4XS5s
eF9xdWV1ZSwKLQkJCQkocCA9IHZwZV9nZXRfc2hhcmVkKHRjbGltaXQpKSwgcmV0KTsKKwkJCXJl
dCA9IF9fd2FpdF9ldmVudF9pbnRlcnJ1cHRpYmxlKGNoYW5uZWxfd3FzW2luZGV4XS5seF9xdWV1
ZSwKKwkJCQkocCA9IHZwZV9nZXRfc2hhcmVkKHRjbGltaXQpKSk7CiAJCQlpZiAocmV0KQogCQkJ
CWdvdG8gb3V0X2ZhaWw7CiAJCSAgICB9IGVsc2UgewpAQCAtMjYzLDExICsyNjMsMTEgQEAgdW5z
aWduZWQgaW50IHJ0bHhfcmVhZF9wb2xsKGludCBpbmRleCwgaQogCS8qIGRhdGEgYXZhaWxhYmxl
IHRvIHJlYWQ/ICovCiAJaWYgKGNoYW4tPmx4X3JlYWQgPT0gY2hhbi0+bHhfd3JpdGUpIHsKIAkJ
aWYgKGNhbl9zbGVlcCkgewotCQkJaW50IHJldCA9IDA7CisJCQlpbnQgcmV0OwogCi0JCQlfX3dh
aXRfZXZlbnRfaW50ZXJydXB0aWJsZShjaGFubmVsX3dxc1tpbmRleF0ubHhfcXVldWUsCisJCQly
ZXQgPSBfX3dhaXRfZXZlbnRfaW50ZXJydXB0aWJsZShjaGFubmVsX3dxc1tpbmRleF0ubHhfcXVl
dWUsCiAJCQkJKGNoYW4tPmx4X3JlYWQgIT0gY2hhbi0+bHhfd3JpdGUpIHx8Ci0JCQkJc3Bfc3Rv
cHBpbmcsIHJldCk7CisJCQkJc3Bfc3RvcHBpbmcpOwogCQkJaWYgKHJldCkKIAkJCQlyZXR1cm4g
cmV0OwogCkBAIC00NDAsMTQgKzQ0MCwxMyBAQCBzdGF0aWMgc3NpemVfdCBmaWxlX3dyaXRlKHN0
cnVjdCBmaWxlICpmCiAKIAkvKiBhbnkgc3BhY2UgbGVmdC4uLiAqLwogCWlmICghcnRseF93cml0
ZV9wb2xsKG1pbm9yKSkgewotCQlpbnQgcmV0ID0gMDsKKwkJaW50IHJldDsKIAogCQlpZiAoZmls
ZS0+Zl9mbGFncyAmIE9fTk9OQkxPQ0spCiAJCQlyZXR1cm4gLUVBR0FJTjsKIAotCQlfX3dhaXRf
ZXZlbnRfaW50ZXJydXB0aWJsZShjaGFubmVsX3dxc1ttaW5vcl0ucnRfcXVldWUsCi0JCQkJCSAg
IHJ0bHhfd3JpdGVfcG9sbChtaW5vciksCi0JCQkJCSAgIHJldCk7CisJCXJldCA9IF9fd2FpdF9l
dmVudF9pbnRlcnJ1cHRpYmxlKGNoYW5uZWxfd3FzW21pbm9yXS5ydF9xdWV1ZSwKKwkJCQkJICAg
cnRseF93cml0ZV9wb2xsKG1pbm9yKSk7CiAJCWlmIChyZXQpCiAJCQlyZXR1cm4gcmV0OwogCX0K
ZGlmZiAtcHVOIGluY2x1ZGUvbGludXgvd2FpdC5ofndhaXQtaW50cm9kdWNlLXdhaXRfZXZlbnRf
Y29tbW9ud3EtY29uZGl0aW9uLXN0YXRlLXRpbWVvdXQgaW5jbHVkZS9saW51eC93YWl0LmgKLS0t
IGEvaW5jbHVkZS9saW51eC93YWl0Lmh+d2FpdC1pbnRyb2R1Y2Utd2FpdF9ldmVudF9jb21tb253
cS1jb25kaXRpb24tc3RhdGUtdGltZW91dAorKysgYS9pbmNsdWRlL2xpbnV4L3dhaXQuaApAQCAt
MTc5LDE4ICsxNzksNTIgQEAgd2FpdF9xdWV1ZV9oZWFkX3QgKmJpdF93YWl0cXVldWUodm9pZCAq
LAogI2RlZmluZSB3YWtlX3VwX2ludGVycnVwdGlibGVfc3luY19wb2xsKHgsIG0pCQkJCVwKIAlf
X3dha2VfdXBfc3luY19rZXkoKHgpLCBUQVNLX0lOVEVSUlVQVElCTEUsIDEsICh2b2lkICopICht
KSkKIAotI2RlZmluZSBfX3dhaXRfZXZlbnQod3EsIGNvbmRpdGlvbikgCQkJCQlcCi1kbyB7CQkJ
CQkJCQkJXAorI2RlZmluZSBfX3dhaXRfbm9fdGltZW91dCh0b3V0KQlcCisJKF9fYnVpbHRpbl9j
b25zdGFudF9wKHRvdXQpICYmICh0b3V0KSA9PSBNQVhfU0NIRURVTEVfVElNRU9VVCkKKworLyog
dWdsaWZpZWQgc2lnbmFsX3BlbmRpbmdfc3RhdGUoKSBvcHRpbWl6ZWQgZm9yIGNvbnN0YW50IHN0
YXRlICovCisjZGVmaW5lIF9fd2FpdF9zaWduYWxfcGVuZGluZyhzdGF0ZSkJCQkJCVwKKwkoKHN0
YXRlID09IFRBU0tfSU5URVJSVVBUSUJMRSkgPyBzaWduYWxfcGVuZGluZyhjdXJyZW50KSA6CVwK
KwkgKHN0YXRlID09IFRBU0tfS0lMTEFCTEUpID8gZmF0YWxfc2lnbmFsX3BlbmRpbmcoY3VycmVu
dCkgOglcCisJICAwKQorCisjZGVmaW5lIF9fd2FpdF9ldmVudF9jb21tb24od3EsIGNvbmRpdGlv
biwgc3RhdGUsIHRvdXQpCQkJXAorKHsJCQkJCQkJCQlcCiAJREVGSU5FX1dBSVQoX193YWl0KTsJ
CQkJCQlcCisJbG9uZyBfX3JldCA9IDAsIF9fdG91dCA9IHRvdXQ7CQkJCQlcCiAJCQkJCQkJCQlc
CiAJZm9yICg7OykgewkJCQkJCQlcCi0JCXByZXBhcmVfdG9fd2FpdCgmd3EsICZfX3dhaXQsIFRB
U0tfVU5JTlRFUlJVUFRJQkxFKTsJXAotCQlpZiAoY29uZGl0aW9uKQkJCQkJCVwKKwkJcHJlcGFy
ZV90b193YWl0KCZ3cSwgJl9fd2FpdCwgc3RhdGUpOwkJCVwKKwkJaWYgKGNvbmRpdGlvbikgewkJ
CQkJXAorCQkJX19yZXQgPSBfX3dhaXRfbm9fdGltZW91dCh0b3V0KSA/OiBfX3RvdXQgPzogMTsJ
XAorCQkJYnJlYWs7CQkJCQkJXAorCQl9CQkJCQkJCVwKKwkJCQkJCQkJCVwKKwkJaWYgKF9fd2Fp
dF9zaWduYWxfcGVuZGluZyhzdGF0ZSkpIHsJCQlcCisJCQlfX3JldCA9IC1FUkVTVEFSVFNZUzsJ
CQkJXAorCQkJYnJlYWs7CQkJCQkJXAorCQl9CQkJCQkJCVwKKwkJCQkJCQkJCVwKKwkJaWYgKF9f
d2FpdF9ub190aW1lb3V0KHRvdXQpKQkJCQlcCisJCQlzY2hlZHVsZSgpOwkJCQkJXAorCQllbHNl
IGlmIChfX3RvdXQpCQkJCQlcCisJCQlfX3RvdXQgPSBzY2hlZHVsZV90aW1lb3V0KF9fdG91dCk7
CQlcCisJCWVsc2UJCQkJCQkJXAogCQkJYnJlYWs7CQkJCQkJXAotCQlzY2hlZHVsZSgpOwkJCQkJ
CVwKIAl9CQkJCQkJCQlcCiAJZmluaXNoX3dhaXQoJndxLCAmX193YWl0KTsJCQkJCVwKLX0gd2hp
bGUgKDApCisJX19yZXQ7CQkJCQkJCQlcCit9KQorCisjZGVmaW5lIHdhaXRfZXZlbnRfY29tbW9u
KHdxLCBjb25kaXRpb24sIHN0YXRlLCB0b3V0KQkJCVwKKyh7CQkJCQkJCQkJXAorCWxvbmcgX19y
ZXQ7CQkJCQkJCVwKKwlpZiAoY29uZGl0aW9uKQkJCQkJCQlcCisJCV9fcmV0ID0gX193YWl0X25v
X3RpbWVvdXQodG91dCkgPzogKHRvdXQpID86IDE7CQlcCisJZWxzZQkJCQkJCQkJXAorCQlfX3Jl
dCA9IF9fd2FpdF9ldmVudF9jb21tb24od3EsIGNvbmRpdGlvbiwgc3RhdGUsIHRvdXQpO1wKKwlf
X3JldDsJCQkJCQkJCVwKK30pCiAKIC8qKgogICogd2FpdF9ldmVudCAtIHNsZWVwIHVudGlsIGEg
Y29uZGl0aW9uIGdldHMgdHJ1ZQpAQCAtMjA0LDI5ICsyMzgsMTMgQEAgZG8gewkJCQkJCQkJCVwK
ICAqIHdha2VfdXAoKSBoYXMgdG8gYmUgY2FsbGVkIGFmdGVyIGNoYW5naW5nIGFueSB2YXJpYWJs
ZSB0aGF0IGNvdWxkCiAgKiBjaGFuZ2UgdGhlIHJlc3VsdCBvZiB0aGUgd2FpdCBjb25kaXRpb24u
CiAgKi8KLSNkZWZpbmUgd2FpdF9ldmVudCh3cSwgY29uZGl0aW9uKSAJCQkJCVwKLWRvIHsJCQkJ
CQkJCQlcCi0JaWYgKGNvbmRpdGlvbikJIAkJCQkJCVwKLQkJYnJlYWs7CQkJCQkJCVwKLQlfX3dh
aXRfZXZlbnQod3EsIGNvbmRpdGlvbik7CQkJCQlcCi19IHdoaWxlICgwKQotCi0jZGVmaW5lIF9f
d2FpdF9ldmVudF90aW1lb3V0KHdxLCBjb25kaXRpb24sIHJldCkJCQlcCi1kbyB7CQkJCQkJCQkJ
XAotCURFRklORV9XQUlUKF9fd2FpdCk7CQkJCQkJXAotCQkJCQkJCQkJXAotCWZvciAoOzspIHsJ
CQkJCQkJXAotCQlwcmVwYXJlX3RvX3dhaXQoJndxLCAmX193YWl0LCBUQVNLX1VOSU5URVJSVVBU
SUJMRSk7CVwKLQkJaWYgKGNvbmRpdGlvbikJCQkJCQlcCi0JCQlicmVhazsJCQkJCQlcCi0JCXJl
dCA9IHNjaGVkdWxlX3RpbWVvdXQocmV0KTsJCQkJXAotCQlpZiAoIXJldCkJCQkJCQlcCi0JCQli
cmVhazsJCQkJCQlcCi0JfQkJCQkJCQkJXAotCWlmICghcmV0ICYmIChjb25kaXRpb24pKQkJCQkJ
XAotCQlyZXQgPSAxOwkJCQkJCVwKLQlmaW5pc2hfd2FpdCgmd3EsICZfX3dhaXQpOwkJCQkJXAot
fSB3aGlsZSAoMCkKKyNkZWZpbmUgX193YWl0X2V2ZW50KHdxLCBjb25kaXRpb24pCQkJCQlcCisJ
X193YWl0X2V2ZW50X2NvbW1vbih3cSwgY29uZGl0aW9uLAkJCQlcCisJCQlUQVNLX1VOSU5URVJS
VVBUSUJMRSwgTUFYX1NDSEVEVUxFX1RJTUVPVVQpCVwKKworI2RlZmluZSB3YWl0X2V2ZW50KHdx
LCBjb25kaXRpb24pCQkJCQlcCisJd2FpdF9ldmVudF9jb21tb24od3EsIGNvbmRpdGlvbiwJCQkJ
XAorCQkJVEFTS19VTklOVEVSUlVQVElCTEUsIE1BWF9TQ0hFRFVMRV9USU1FT1VUKQlcCiAKIC8q
KgogICogd2FpdF9ldmVudF90aW1lb3V0IC0gc2xlZXAgdW50aWwgYSBjb25kaXRpb24gZ2V0cyB0
cnVlIG9yIGEgdGltZW91dCBlbGFwc2VzCkBAIC0yNDUsMzEgKzI2MywxMyBAQCBkbyB7CQkJCQkJ
CQkJXAogICogamlmZmllcyAoYXQgbGVhc3QgMSkgaWYgdGhlIEBjb25kaXRpb24gZXZhbHVhdGVk
IHRvICV0cnVlIGJlZm9yZQogICogdGhlIEB0aW1lb3V0IGVsYXBzZWQuCiAgKi8KLSNkZWZpbmUg
d2FpdF9ldmVudF90aW1lb3V0KHdxLCBjb25kaXRpb24sIHRpbWVvdXQpCQkJXAotKHsJCQkJCQkJ
CQlcCi0JbG9uZyBfX3JldCA9IHRpbWVvdXQ7CQkJCQkJXAotCWlmICghKGNvbmRpdGlvbikpIAkJ
CQkJCVwKLQkJX193YWl0X2V2ZW50X3RpbWVvdXQod3EsIGNvbmRpdGlvbiwgX19yZXQpOwkJXAot
CV9fcmV0OwkJCQkJCQkJXAotfSkKKyNkZWZpbmUgX193YWl0X2V2ZW50X3RpbWVvdXQod3EsIGNv
bmRpdGlvbiwgdGltZW91dCkJCQlcCisJX193YWl0X2V2ZW50X2NvbW1vbih3cSwgY29uZGl0aW9u
LAkJCQlcCisJCQlUQVNLX1VOSU5URVJSVVBUSUJMRSwgdGltZW91dCkKIAotI2RlZmluZSBfX3dh
aXRfZXZlbnRfaW50ZXJydXB0aWJsZSh3cSwgY29uZGl0aW9uLCByZXQpCQkJXAotZG8gewkJCQkJ
CQkJCVwKLQlERUZJTkVfV0FJVChfX3dhaXQpOwkJCQkJCVwKLQkJCQkJCQkJCVwKLQlmb3IgKDs7
KSB7CQkJCQkJCVwKLQkJcHJlcGFyZV90b193YWl0KCZ3cSwgJl9fd2FpdCwgVEFTS19JTlRFUlJV
UFRJQkxFKTsJXAotCQlpZiAoY29uZGl0aW9uKQkJCQkJCVwKLQkJCWJyZWFrOwkJCQkJCVwKLQkJ
aWYgKCFzaWduYWxfcGVuZGluZyhjdXJyZW50KSkgewkJCQlcCi0JCQlzY2hlZHVsZSgpOwkJCQkJ
XAotCQkJY29udGludWU7CQkJCQlcCi0JCX0JCQkJCQkJXAotCQlyZXQgPSAtRVJFU1RBUlRTWVM7
CQkJCQlcCi0JCWJyZWFrOwkJCQkJCQlcCi0JfQkJCQkJCQkJXAotCWZpbmlzaF93YWl0KCZ3cSwg
Jl9fd2FpdCk7CQkJCQlcCi19IHdoaWxlICgwKQorI2RlZmluZSB3YWl0X2V2ZW50X3RpbWVvdXQo
d3EsIGNvbmRpdGlvbiwgdGltZW91dCkJCQlcCisJd2FpdF9ldmVudF9jb21tb24od3EsIGNvbmRp
dGlvbiwJCQkJXAorCQkJVEFTS19VTklOVEVSUlVQVElCTEUsIHRpbWVvdXQpCiAKIC8qKgogICog
d2FpdF9ldmVudF9pbnRlcnJ1cHRpYmxlIC0gc2xlZXAgdW50aWwgYSBjb25kaXRpb24gZ2V0cyB0
cnVlCkBAIC0yODYsMzUgKzI4NiwxMyBAQCBkbyB7CQkJCQkJCQkJXAogICogVGhlIGZ1bmN0aW9u
IHdpbGwgcmV0dXJuIC1FUkVTVEFSVFNZUyBpZiBpdCB3YXMgaW50ZXJydXB0ZWQgYnkgYQogICog
c2lnbmFsIGFuZCAwIGlmIEBjb25kaXRpb24gZXZhbHVhdGVkIHRvIHRydWUuCiAgKi8KLSNkZWZp
bmUgd2FpdF9ldmVudF9pbnRlcnJ1cHRpYmxlKHdxLCBjb25kaXRpb24pCQkJCVwKLSh7CQkJCQkJ
CQkJXAotCWludCBfX3JldCA9IDA7CQkJCQkJCVwKLQlpZiAoIShjb25kaXRpb24pKQkJCQkJCVwK
LQkJX193YWl0X2V2ZW50X2ludGVycnVwdGlibGUod3EsIGNvbmRpdGlvbiwgX19yZXQpOwlcCi0J
X19yZXQ7CQkJCQkJCQlcCi19KQorI2RlZmluZSBfX3dhaXRfZXZlbnRfaW50ZXJydXB0aWJsZSh3
cSwgY29uZGl0aW9uKQkJCVwKKwlfX3dhaXRfZXZlbnRfY29tbW9uKHdxLCBjb25kaXRpb24sCQkJ
CVwKKwkJCVRBU0tfSU5URVJSVVBUSUJMRSwgTUFYX1NDSEVEVUxFX1RJTUVPVVQpCiAKLSNkZWZp
bmUgX193YWl0X2V2ZW50X2ludGVycnVwdGlibGVfdGltZW91dCh3cSwgY29uZGl0aW9uLCByZXQp
CQlcCi1kbyB7CQkJCQkJCQkJXAotCURFRklORV9XQUlUKF9fd2FpdCk7CQkJCQkJXAotCQkJCQkJ
CQkJXAotCWZvciAoOzspIHsJCQkJCQkJXAotCQlwcmVwYXJlX3RvX3dhaXQoJndxLCAmX193YWl0
LCBUQVNLX0lOVEVSUlVQVElCTEUpOwlcCi0JCWlmIChjb25kaXRpb24pCQkJCQkJXAotCQkJYnJl
YWs7CQkJCQkJXAotCQlpZiAoIXNpZ25hbF9wZW5kaW5nKGN1cnJlbnQpKSB7CQkJCVwKLQkJCXJl
dCA9IHNjaGVkdWxlX3RpbWVvdXQocmV0KTsJCQlcCi0JCQlpZiAoIXJldCkJCQkJCVwKLQkJCQli
cmVhazsJCQkJCVwKLQkJCWNvbnRpbnVlOwkJCQkJXAotCQl9CQkJCQkJCVwKLQkJcmV0ID0gLUVS
RVNUQVJUU1lTOwkJCQkJXAotCQlicmVhazsJCQkJCQkJXAotCX0JCQkJCQkJCVwKLQlpZiAoIXJl
dCAmJiAoY29uZGl0aW9uKSkJCQkJCVwKLQkJcmV0ID0gMTsJCQkJCQlcCi0JZmluaXNoX3dhaXQo
JndxLCAmX193YWl0KTsJCQkJCVwKLX0gd2hpbGUgKDApCisjZGVmaW5lIHdhaXRfZXZlbnRfaW50
ZXJydXB0aWJsZSh3cSwgY29uZGl0aW9uKQkJCQlcCisJd2FpdF9ldmVudF9jb21tb24od3EsIGNv
bmRpdGlvbiwJCQkJXAorCQkJVEFTS19JTlRFUlJVUFRJQkxFLCBNQVhfU0NIRURVTEVfVElNRU9V
VCkKIAogLyoqCiAgKiB3YWl0X2V2ZW50X2ludGVycnVwdGlibGVfdGltZW91dCAtIHNsZWVwIHVu
dGlsIGEgY29uZGl0aW9uIGdldHMgdHJ1ZSBvciBhIHRpbWVvdXQgZWxhcHNlcwpAQCAtMzM0LDEz
ICszMTIsMTMgQEAgZG8gewkJCQkJCQkJCVwKICAqIGEgc2lnbmFsLCBvciB0aGUgcmVtYWluaW5n
IGppZmZpZXMgKGF0IGxlYXN0IDEpIGlmIHRoZSBAY29uZGl0aW9uCiAgKiBldmFsdWF0ZWQgdG8g
JXRydWUgYmVmb3JlIHRoZSBAdGltZW91dCBlbGFwc2VkLgogICovCisjZGVmaW5lIF9fd2FpdF9l
dmVudF9pbnRlcnJ1cHRpYmxlX3RpbWVvdXQod3EsIGNvbmRpdGlvbiwgdGltZW91dCkJXAorCV9f
d2FpdF9ldmVudF9jb21tb24od3EsIGNvbmRpdGlvbiwJCQkJXAorCQkJVEFTS19JTlRFUlJVUFRJ
QkxFLCB0aW1lb3V0KQorCiAjZGVmaW5lIHdhaXRfZXZlbnRfaW50ZXJydXB0aWJsZV90aW1lb3V0
KHdxLCBjb25kaXRpb24sIHRpbWVvdXQpCVwKLSh7CQkJCQkJCQkJXAotCWxvbmcgX19yZXQgPSB0
aW1lb3V0OwkJCQkJCVwKLQlpZiAoIShjb25kaXRpb24pKQkJCQkJCVwKLQkJX193YWl0X2V2ZW50
X2ludGVycnVwdGlibGVfdGltZW91dCh3cSwgY29uZGl0aW9uLCBfX3JldCk7IFwKLQlfX3JldDsJ
CQkJCQkJCVwKLX0pCisJd2FpdF9ldmVudF9jb21tb24od3EsIGNvbmRpdGlvbiwJCQkJXAorCQkJ
VEFTS19JTlRFUlJVUFRJQkxFLCB0aW1lb3V0KQogCiAjZGVmaW5lIF9fd2FpdF9ldmVudF9ocnRp
bWVvdXQod3EsIGNvbmRpdGlvbiwgdGltZW91dCwgc3RhdGUpCQlcCiAoewkJCQkJCQkJCVwKQEAg
LTYwNywyNCArNTg1LDYgQEAgZG8gewkJCQkJCQkJCVwKIAogCiAKLSNkZWZpbmUgX193YWl0X2V2
ZW50X2tpbGxhYmxlKHdxLCBjb25kaXRpb24sIHJldCkJCQlcCi1kbyB7CQkJCQkJCQkJXAotCURF
RklORV9XQUlUKF9fd2FpdCk7CQkJCQkJXAotCQkJCQkJCQkJXAotCWZvciAoOzspIHsJCQkJCQkJ
XAotCQlwcmVwYXJlX3RvX3dhaXQoJndxLCAmX193YWl0LCBUQVNLX0tJTExBQkxFKTsJCVwKLQkJ
aWYgKGNvbmRpdGlvbikJCQkJCQlcCi0JCQlicmVhazsJCQkJCQlcCi0JCWlmICghZmF0YWxfc2ln
bmFsX3BlbmRpbmcoY3VycmVudCkpIHsJCQlcCi0JCQlzY2hlZHVsZSgpOwkJCQkJXAotCQkJY29u
dGludWU7CQkJCQlcCi0JCX0JCQkJCQkJXAotCQlyZXQgPSAtRVJFU1RBUlRTWVM7CQkJCQlcCi0J
CWJyZWFrOwkJCQkJCQlcCi0JfQkJCQkJCQkJXAotCWZpbmlzaF93YWl0KCZ3cSwgJl9fd2FpdCk7
CQkJCQlcCi19IHdoaWxlICgwKQotCiAvKioKICAqIHdhaXRfZXZlbnRfa2lsbGFibGUgLSBzbGVl
cCB1bnRpbCBhIGNvbmRpdGlvbiBnZXRzIHRydWUKICAqIEB3cTogdGhlIHdhaXRxdWV1ZSB0byB3
YWl0IG9uCkBAIC02NDAsMTQgKzYwMCwxMyBAQCBkbyB7CQkJCQkJCQkJXAogICogVGhlIGZ1bmN0
aW9uIHdpbGwgcmV0dXJuIC1FUkVTVEFSVFNZUyBpZiBpdCB3YXMgaW50ZXJydXB0ZWQgYnkgYQog
ICogc2lnbmFsIGFuZCAwIGlmIEBjb25kaXRpb24gZXZhbHVhdGVkIHRvIHRydWUuCiAgKi8KLSNk
ZWZpbmUgd2FpdF9ldmVudF9raWxsYWJsZSh3cSwgY29uZGl0aW9uKQkJCQlcCi0oewkJCQkJCQkJ
CVwKLQlpbnQgX19yZXQgPSAwOwkJCQkJCQlcCi0JaWYgKCEoY29uZGl0aW9uKSkJCQkJCQlcCi0J
CV9fd2FpdF9ldmVudF9raWxsYWJsZSh3cSwgY29uZGl0aW9uLCBfX3JldCk7CQlcCi0JX19yZXQ7
CQkJCQkJCQlcCi19KQorI2RlZmluZSBfX3dhaXRfZXZlbnRfa2lsbGFibGUod3EsIGNvbmRpdGlv
bikJCQkJXAorCV9fd2FpdF9ldmVudF9jb21tb24od3EsIGNvbmRpdGlvbiwJCQkJXAorCQkJVEFT
S19LSUxMQUJMRSwgTUFYX1NDSEVEVUxFX1RJTUVPVVQpCiAKKyNkZWZpbmUgd2FpdF9ldmVudF9r
aWxsYWJsZSh3cSwgY29uZGl0aW9uKQkJCQlcCisJd2FpdF9ldmVudF9jb21tb24od3EsIGNvbmRp
dGlvbiwJCQkJXAorCQkJVEFTS19LSUxMQUJMRSwgTUFYX1NDSEVEVUxFX1RJTUVPVVQpCiAKICNk
ZWZpbmUgX193YWl0X2V2ZW50X2xvY2tfaXJxKHdxLCBjb25kaXRpb24sIGxvY2ssIGNtZCkJCQlc
CiBkbyB7CQkJCQkJCQkJXApkaWZmIC1wdU4gbmV0L2lyZGEvYWZfaXJkYS5jfndhaXQtaW50cm9k
dWNlLXdhaXRfZXZlbnRfY29tbW9ud3EtY29uZGl0aW9uLXN0YXRlLXRpbWVvdXQgbmV0L2lyZGEv
YWZfaXJkYS5jCi0tLSBhL25ldC9pcmRhL2FmX2lyZGEuY353YWl0LWludHJvZHVjZS13YWl0X2V2
ZW50X2NvbW1vbndxLWNvbmRpdGlvbi1zdGF0ZS10aW1lb3V0CisrKyBhL25ldC9pcmRhL2FmX2ly
ZGEuYwpAQCAtMjU2Myw5ICsyNTYzLDggQEAgYmVkOgogCQkJCSAgamlmZmllcyArIG1zZWNzX3Rv
X2ppZmZpZXModmFsKSk7CiAKIAkJCS8qIFdhaXQgZm9yIElSLUxNUCB0byBjYWxsIHVzIGJhY2sg
Ki8KLQkJCV9fd2FpdF9ldmVudF9pbnRlcnJ1cHRpYmxlKHNlbGYtPnF1ZXJ5X3dhaXQsCi0JCQkg
ICAgICAoc2VsZi0+Y2FjaGVkYWRkciAhPSAwIHx8IHNlbGYtPmVycm5vID09IC1FVElNRSksCi0J
CQkJCQkgICBlcnIpOworCQkJZXJyID0gX193YWl0X2V2ZW50X2ludGVycnVwdGlibGUoc2VsZi0+
cXVlcnlfd2FpdCwKKwkJCSAgICAgIChzZWxmLT5jYWNoZWRhZGRyICE9IDAgfHwgc2VsZi0+ZXJy
bm8gPT0gLUVUSU1FKSk7CiAKIAkJCS8qIElmIHdhdGNoZG9nIGlzIHN0aWxsIGFjdGl2YXRlZCwg
a2lsbCBpdCEgKi8KIAkJCWRlbF90aW1lcigmKHNlbGYtPndhdGNoZG9nKSk7CmRpZmYgLXB1TiBu
ZXQvbmV0ZmlsdGVyL2lwdnMvaXBfdnNfc3luYy5jfndhaXQtaW50cm9kdWNlLXdhaXRfZXZlbnRf
Y29tbW9ud3EtY29uZGl0aW9uLXN0YXRlLXRpbWVvdXQgbmV0L25ldGZpbHRlci9pcHZzL2lwX3Zz
X3N5bmMuYwotLS0gYS9uZXQvbmV0ZmlsdGVyL2lwdnMvaXBfdnNfc3luYy5jfndhaXQtaW50cm9k
dWNlLXdhaXRfZXZlbnRfY29tbW9ud3EtY29uZGl0aW9uLXN0YXRlLXRpbWVvdXQKKysrIGEvbmV0
L25ldGZpbHRlci9pcHZzL2lwX3ZzX3N5bmMuYwpAQCAtMTYyNCwxMiArMTYyNCw5IEBAIHN0YXRp
YyBpbnQgc3luY190aHJlYWRfbWFzdGVyKHZvaWQgKmRhdGEKIAkJCWNvbnRpbnVlOwogCQl9CiAJ
CXdoaWxlIChpcF92c19zZW5kX3N5bmNfbXNnKHRpbmZvLT5zb2NrLCBzYi0+bWVzZykgPCAwKSB7
Ci0JCQlpbnQgcmV0ID0gMDsKLQogCQkJX193YWl0X2V2ZW50X2ludGVycnVwdGlibGUoKnNrX3Ns
ZWVwKHNrKSwKIAkJCQkJCSAgIHNvY2tfd3JpdGVhYmxlKHNrKSB8fAotCQkJCQkJICAga3RocmVh
ZF9zaG91bGRfc3RvcCgpLAotCQkJCQkJICAgcmV0KTsKKwkJCQkJCSAgIGt0aHJlYWRfc2hvdWxk
X3N0b3AoKSk7CiAJCQlpZiAodW5saWtlbHkoa3RocmVhZF9zaG91bGRfc3RvcCgpKSkKIAkJCQln
b3RvIGRvbmU7CiAJCX0KXwo=
--089e013c683c4ecc4004e05db6d3
Content-Type: application/octet-stream; 
	name="2-3-wait-introduce-wait_event_commonwq-condition-state-timeout-fix.patch"
Content-Disposition: attachment; 
	filename="2-3-wait-introduce-wait_event_commonwq-condition-state-timeout-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hik6d3k65

RnJvbTogQW5kcmV3IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4KU3ViamVjdDog
d2FpdC1pbnRyb2R1Y2Utd2FpdF9ldmVudF9jb21tb253cS1jb25kaXRpb24tc3RhdGUtdGltZW91
dC1maXgKCmZhaXggd2FybmluZ3MsIGF2b2lkIGV5ZS1nbGF6aW5nIHVzZSBvZiBnY2MgPzogZXh0
ZW5zaW9uCgpDYzogRGFuaWVsIFZldHRlciA8ZGFuaWVsLnZldHRlckBmZndsbC5jaD4KQ2M6IElt
cmUgRGVhayA8aW1yZS5kZWFrQGludGVsLmNvbT4KQ2M6IEp1bGlhbiBBbmFzdGFzb3YgPGphQHNz
aS5iZz4KQ2M6IEx1a2FzIEN6ZXJuZXIgPGxjemVybmVyQHJlZGhhdC5jb20+CkNjOiBPbGVnIE5l
c3Rlcm92IDxvbGVnQHJlZGhhdC5jb20+CkNjOiBSYWxmIEJhZWNobGUgPHJhbGZAbGludXgtbWlw
cy5vcmc+CkNjOiBTYW11ZWwgT3J0aXogPHNhbXVlbEBzb3J0aXoub3JnPgpDYzogU2ltb24gSG9y
bWFuIDxob3Jtc0B2ZXJnZS5uZXQuYXU+CkNjOiBUZWp1biBIZW8gPHRqQGtlcm5lbC5vcmc+CkNj
OiBXZW5zb25nIFpoYW5nIDx3ZW5zb25nQGxpbnV4LXZzLm9yZz4KQ2M6IFJhbmR5IER1bmxhcCA8
cmR1bmxhcEBpbmZyYWRlYWQub3JnPgpTaWduZWQtb2ZmLWJ5OiBBbmRyZXcgTW9ydG9uIDxha3Bt
QGxpbnV4LWZvdW5kYXRpb24ub3JnPgotLS0KCiBpbmNsdWRlL2xpbnV4L3dhaXQuaCB8ICAgMTkg
KysrKysrKysrKysrKysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDQg
ZGVsZXRpb25zKC0pCgpkaWZmIC1wdU4gaW5jbHVkZS9saW51eC93YWl0Lmh+d2FpdC1pbnRyb2R1
Y2Utd2FpdF9ldmVudF9jb21tb253cS1jb25kaXRpb24tc3RhdGUtdGltZW91dC1maXggaW5jbHVk
ZS9saW51eC93YWl0LmgKLS0tIGEvaW5jbHVkZS9saW51eC93YWl0Lmh+d2FpdC1pbnRyb2R1Y2Ut
d2FpdF9ldmVudF9jb21tb253cS1jb25kaXRpb24tc3RhdGUtdGltZW91dC1maXgKKysrIGEvaW5j
bHVkZS9saW51eC93YWl0LmgKQEAgLTE5Niw3ICsxOTYsMTIgQEAgd2FpdF9xdWV1ZV9oZWFkX3Qg
KmJpdF93YWl0cXVldWUodm9pZCAqLAogCWZvciAoOzspIHsJCQkJCQkJXAogCQlwcmVwYXJlX3Rv
X3dhaXQoJndxLCAmX193YWl0LCBzdGF0ZSk7CQkJXAogCQlpZiAoY29uZGl0aW9uKSB7CQkJCQlc
Ci0JCQlfX3JldCA9IF9fd2FpdF9ub190aW1lb3V0KHRvdXQpID86IF9fdG91dCA/OiAxOwlcCisJ
CQlfX3JldCA9IF9fd2FpdF9ub190aW1lb3V0KHRvdXQpOwkJXAorCQkJaWYgKCFfX3JldCkgewkJ
CQkJXAorCQkJCV9fcmV0ID0gX190b3V0OwkJCQlcCisJCQkJaWYgKCFfX3JldCkJCQkJXAorCQkJ
CQlfX3JldCA9IDE7CQkJXAorCQkJfQkJCQkJCVwKIAkJCWJyZWFrOwkJCQkJCVwKIAkJfQkJCQkJ
CQlcCiAJCQkJCQkJCQlcCkBAIC0yMTksMTAgKzIyNCwxNiBAQCB3YWl0X3F1ZXVlX2hlYWRfdCAq
Yml0X3dhaXRxdWV1ZSh2b2lkICosCiAjZGVmaW5lIHdhaXRfZXZlbnRfY29tbW9uKHdxLCBjb25k
aXRpb24sIHN0YXRlLCB0b3V0KQkJCVwKICh7CQkJCQkJCQkJXAogCWxvbmcgX19yZXQ7CQkJCQkJ
CVwKLQlpZiAoY29uZGl0aW9uKQkJCQkJCQlcCi0JCV9fcmV0ID0gX193YWl0X25vX3RpbWVvdXQo
dG91dCkgPzogKHRvdXQpID86IDE7CQlcCi0JZWxzZQkJCQkJCQkJXAorCWlmIChjb25kaXRpb24p
IHsJCQkJCQlcCisJCV9fcmV0ID0gX193YWl0X25vX3RpbWVvdXQodG91dCk7CQkJXAorCQlpZiAo
IV9fcmV0KSB7CQkJCQkJXAorCQkJX19yZXQgPSB0b3V0OwkJCQkJXAorCQkJaWYgKCFfX3JldCkJ
CQkJCVwKKwkJCQlfX3JldCA9IDE7CQkJCVwKKwkJfQkJCQkJCQlcCisJfSBlbHNlIHsJCQkJCQkJ
XAogCQlfX3JldCA9IF9fd2FpdF9ldmVudF9jb21tb24od3EsIGNvbmRpdGlvbiwgc3RhdGUsIHRv
dXQpO1wKKwl9CQkJCQkJCQlcCiAJX19yZXQ7CQkJCQkJCQlcCiB9KQogCl8K
--089e013c683c4ecc4004e05db6d3
Content-Type: application/octet-stream; 
	name="3-3-wait-introduce-prepare_to_wait_event-v2.patch"
Content-Disposition: attachment; 
	filename="3-3-wait-introduce-prepare_to_wait_event-v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hik6d6qz6

RnJvbTogT2xlZyBOZXN0ZXJvdiA8b2xlZ0ByZWRoYXQuY29tPgpTdWJqZWN0OiB3YWl0OiBpbnRy
b2R1Y2UgcHJlcGFyZV90b193YWl0X2V2ZW50KCkKCkFkZCB0aGUgbmV3IGhlbHBlciwgcHJlcGFy
ZV90b193YWl0X2V2ZW50KCkgd2hpY2ggc2hvdWxkIG9ubHkgYmUgdXNlZCBieQp3YWl0X2V2ZW50
X2NvbW1vbi9ldGMuCgpwcmVwYXJlX3RvX3dhaXRfZXZlbnQoKSByZXR1cm5zIC1FUkVTVEFSVFNZ
UyBpZiBzaWduYWxfcGVuZGluZ19zdGF0ZSgpIGlzCnRydWUsIG90aGVyd2lzZSBpdCBjYWxscyBw
cmVwYXJlX3RvX3dhaXQoKS4gIFRoaXMgYWxsb3dzIHRvIHVuaW5saW5lIHRoZQpzaWduYWwtcGVu
ZGluZyBjaGVja3MgaW4gd2FpdF9ldmVudF8qLgoKQWxzbywgaXQgY2FuIGluaXRpYWxpemUgd2Fp
dC0+cHJpdmF0ZS9mdW5jLiAgV2UgZG8gbm90IGNhcmUgdGhleSB3ZXJlCmFscmVhZHkgaW5pdGlh
bGl6ZWQsIHRoZSB2YWx1ZXMgYXJlIHRoZSBzYW1lLiAgVGhpcyBhbHNvIHNoYXZlcyBhIGNvdXBs
ZQpvZiBpbnNucyBmcm9tIHRoZSBpbmxpbmVkIGNvZGUuCgpVbmxpa2UgdGhlIHByZXZpb3VzIGNo
YW5nZSwgdGhpcyBwYXRjaCAicmVsaWFibHkiIHNocmlua3MgdGhlIHNpemUgb2YKZ2VuZXJhdGVk
IGNvZGUgZm9yIGV2ZXJ5IHdhaXRfZXZlbnQqKCkgY2FsbCwKCgktCTQ5Nzc3NjkgMjkzMDk4NCAx
MDEwNDgzMiAgICAgICAgMTgwMTM1ODUgICAgICAgIDExMmRkOTEgdm1saW51eAoJKwk0OTc2ODQ3
CTI5MzA5ODQJMTAxMDQ4MzIJMTgwMTI2NjMJMTEyZDlmNwl2bWxpbnV4CgpvbiBteSBidWlsZC4K
ClNpZ25lZC1vZmYtYnk6IE9sZWcgTmVzdGVyb3YgPG9sZWdAcmVkaGF0LmNvbT4KUmV2aWV3ZWQt
Ynk6IFRlanVuIEhlbyA8dGpAa2VybmVsLm9yZz4KQ2M6IERhbmllbCBWZXR0ZXIgPGRhbmllbC52
ZXR0ZXJAZmZ3bGwuY2g+CkNjOiBJbXJlIERlYWsgPGltcmUuZGVha0BpbnRlbC5jb20+CkNjOiBM
dWthcyBDemVybmVyIDxsY3plcm5lckByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBBbmRyZXcg
TW9ydG9uIDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPgotLS0KWyBkaWxla3M6IHYyOiBSZWZy
ZXNoIHRvIGZpdCBvbiB0b3Agb2YgbXkgcmV2ZXJ0LXdhaXQuaC1uZXh0MjAxMzA2MjggcGF0Y2hz
ZXQuIF0KCiBpbmNsdWRlL2xpbnV4L3dhaXQuaCB8ICAgMjIgKysrKysrKysrKystLS0tLS0tLS0t
LQoga2VybmVsL3dhaXQuYyAgICAgICAgfCAgIDEzICsrKysrKysrKysrKysKIDIgZmlsZXMgY2hh
bmdlZCwgMjQgaW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pCgpkaWZmIC1wdU4gaW5jbHVk
ZS9saW51eC93YWl0Lmh+d2FpdC1pbnRyb2R1Y2UtcHJlcGFyZV90b193YWl0X2V2ZW50IGluY2x1
ZGUvbGludXgvd2FpdC5oCi0tLSBhL2luY2x1ZGUvbGludXgvd2FpdC5ofndhaXQtaW50cm9kdWNl
LXByZXBhcmVfdG9fd2FpdF9ldmVudAorKysgYS9pbmNsdWRlL2xpbnV4L3dhaXQuaApAQCAtMTgy
LDE5ICsxODIsMjAgQEAgd2FpdF9xdWV1ZV9oZWFkX3QgKmJpdF93YWl0cXVldWUodm9pZCAqLAog
I2RlZmluZSBfX3dhaXRfbm9fdGltZW91dCh0b3V0KQlcCiAJKF9fYnVpbHRpbl9jb25zdGFudF9w
KHRvdXQpICYmICh0b3V0KSA9PSBNQVhfU0NIRURVTEVfVElNRU9VVCkKIAotLyogdWdsaWZpZWQg
c2lnbmFsX3BlbmRpbmdfc3RhdGUoKSBvcHRpbWl6ZWQgZm9yIGNvbnN0YW50IHN0YXRlICovCi0j
ZGVmaW5lIF9fd2FpdF9zaWduYWxfcGVuZGluZyhzdGF0ZSkJCQkJCVwKLQkoKHN0YXRlID09IFRB
U0tfSU5URVJSVVBUSUJMRSkgPyBzaWduYWxfcGVuZGluZyhjdXJyZW50KSA6CVwKLQkgKHN0YXRl
ID09IFRBU0tfS0lMTEFCTEUpID8gZmF0YWxfc2lnbmFsX3BlbmRpbmcoY3VycmVudCkgOglcCi0J
ICAwKQorI2RlZmluZSBfX3dhaXRfaW50ZXJydXB0aWJsZShzdGF0ZSkJCQkJCVwKKwkoIV9fYnVp
bHRpbl9jb25zdGFudF9wKHN0YXRlKSB8fAkJCQlcCisJCXN0YXRlID09IFRBU0tfSU5URVJSVVBU
SUJMRSB8fCBzdGF0ZSA9PSBUQVNLX0tJTExBQkxFKQogCiAjZGVmaW5lIF9fd2FpdF9ldmVudF9j
b21tb24od3EsIGNvbmRpdGlvbiwgc3RhdGUsIHRvdXQpCQkJXAogKHsJCQkJCQkJCQlcCi0JREVG
SU5FX1dBSVQoX193YWl0KTsJCQkJCQlcCi0JbG9uZyBfX3JldCA9IDAsIF9fdG91dCA9IHRvdXQ7
CQkJCQlcCisJbG9uZyBfX3JldCwgX190b3V0ID0gdG91dDsJCQkJCVwKKwl3YWl0X3F1ZXVlX3Qg
X193YWl0OwkJCQkJCVwKKwkJCQkJCQkJCVwKKwlJTklUX0xJU1RfSEVBRCgmX193YWl0LnRhc2tf
bGlzdCk7CQkJCVwKKwlfX3dhaXQuZmxhZ3MgPSAwOwkJCQkJCVwKIAkJCQkJCQkJCVwKIAlmb3Ig
KDs7KSB7CQkJCQkJCVwKLQkJcHJlcGFyZV90b193YWl0KCZ3cSwgJl9fd2FpdCwgc3RhdGUpOwkJ
CVwKKwkJX19yZXQgPSBwcmVwYXJlX3RvX3dhaXRfZXZlbnQoJndxLCAmX193YWl0LCBzdGF0ZSk7
CVwKIAkJaWYgKGNvbmRpdGlvbikgewkJCQkJXAogCQkJX19yZXQgPSBfX3dhaXRfbm9fdGltZW91
dCh0b3V0KTsJCVwKIAkJCWlmICghX19yZXQpIHsJCQkJCVwKQEAgLTIwNCwxMCArMjA1LDggQEAg
d2FpdF9xdWV1ZV9oZWFkX3QgKmJpdF93YWl0cXVldWUodm9pZCAqLAogCQkJYnJlYWs7CQkJCQkJ
XAogCQl9CQkJCQkJCVwKIAkJCQkJCQkJCVwKLQkJaWYgKF9fd2FpdF9zaWduYWxfcGVuZGluZyhz
dGF0ZSkpIHsJCQlcCi0JCQlfX3JldCA9IC1FUkVTVEFSVFNZUzsJCQkJXAorCQlpZiAoX193YWl0
X2ludGVycnVwdGlibGUoc3RhdGUpICYmIF9fcmV0KQkJXAogCQkJYnJlYWs7CQkJCQkJXAotCQl9
CQkJCQkJCVwKIAkJCQkJCQkJCVwKIAkJaWYgKF9fd2FpdF9ub190aW1lb3V0KHRvdXQpKQkJCQlc
CiAJCQlzY2hlZHVsZSgpOwkJCQkJXApAQCAtNzkxLDYgKzc5MCw3IEBAIGV4dGVybiBsb25nIGlu
dGVycnVwdGlibGVfc2xlZXBfb25fdGltZW8KICAqIFdhaXRxdWV1ZXMgd2hpY2ggYXJlIHJlbW92
ZWQgZnJvbSB0aGUgd2FpdHF1ZXVlX2hlYWQgYXQgd2FrZXVwIHRpbWUKICAqLwogdm9pZCBwcmVw
YXJlX3RvX3dhaXQod2FpdF9xdWV1ZV9oZWFkX3QgKnEsIHdhaXRfcXVldWVfdCAqd2FpdCwgaW50
IHN0YXRlKTsKK2ludCBwcmVwYXJlX3RvX3dhaXRfZXZlbnQod2FpdF9xdWV1ZV9oZWFkX3QgKnEs
IHdhaXRfcXVldWVfdCAqd2FpdCwgaW50IHN0YXRlKTsKIHZvaWQgcHJlcGFyZV90b193YWl0X2V4
Y2x1c2l2ZSh3YWl0X3F1ZXVlX2hlYWRfdCAqcSwgd2FpdF9xdWV1ZV90ICp3YWl0LCBpbnQgc3Rh
dGUpOwogdm9pZCBmaW5pc2hfd2FpdCh3YWl0X3F1ZXVlX2hlYWRfdCAqcSwgd2FpdF9xdWV1ZV90
ICp3YWl0KTsKIHZvaWQgYWJvcnRfZXhjbHVzaXZlX3dhaXQod2FpdF9xdWV1ZV9oZWFkX3QgKnEs
IHdhaXRfcXVldWVfdCAqd2FpdCwKZGlmZiAtcHVOIGtlcm5lbC93YWl0LmN+d2FpdC1pbnRyb2R1
Y2UtcHJlcGFyZV90b193YWl0X2V2ZW50IGtlcm5lbC93YWl0LmMKLS0tIGEva2VybmVsL3dhaXQu
Y353YWl0LWludHJvZHVjZS1wcmVwYXJlX3RvX3dhaXRfZXZlbnQKKysrIGEva2VybmVsL3dhaXQu
YwpAQCAtNzgsNiArNzgsMTkgQEAgcHJlcGFyZV90b193YWl0KHdhaXRfcXVldWVfaGVhZF90ICpx
LCB3YQogfQogRVhQT1JUX1NZTUJPTChwcmVwYXJlX3RvX3dhaXQpOwogCitpbnQgcHJlcGFyZV90
b193YWl0X2V2ZW50KHdhaXRfcXVldWVfaGVhZF90ICpxLCB3YWl0X3F1ZXVlX3QgKndhaXQsIGlu
dCBzdGF0ZSkKK3sKKwlpZiAoc2lnbmFsX3BlbmRpbmdfc3RhdGUoc3RhdGUsIGN1cnJlbnQpKQor
CQlyZXR1cm4gLUVSRVNUQVJUU1lTOworCisJd2FpdC0+cHJpdmF0ZSA9IGN1cnJlbnQ7CisJd2Fp
dC0+ZnVuYyA9IGF1dG9yZW1vdmVfd2FrZV9mdW5jdGlvbjsKKwlwcmVwYXJlX3RvX3dhaXQocSwg
d2FpdCwgc3RhdGUpOworCisJcmV0dXJuIDA7Cit9CitFWFBPUlRfU1lNQk9MKHByZXBhcmVfdG9f
d2FpdF9ldmVudCk7CisKIHZvaWQKIHByZXBhcmVfdG9fd2FpdF9leGNsdXNpdmUod2FpdF9xdWV1
ZV9oZWFkX3QgKnEsIHdhaXRfcXVldWVfdCAqd2FpdCwgaW50IHN0YXRlKQogewpfCg==
--089e013c683c4ecc4004e05db6d3--
