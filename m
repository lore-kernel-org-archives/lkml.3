Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbaDXK36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:29:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60885 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbaDXK3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:29:48 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1404241316290.13595@math.ut.ee>
References: <alpine.SOC.1.00.1404241249480.13595@math.ut.ee>
	<CAKohpoktwh=SgHTfEgT7vYRVWHssXw7==+a9qAdtmJXepjT2Tw@mail.gmail.com>
	<alpine.SOC.1.00.1404241316290.13595@math.ut.ee>
Date: Thu, 24 Apr 2014 15:59:47 +0530
Message-ID: <CAKohpo=Lzzj5eki3644-ESB+P39+Q-ARFqN-S+_HM5UB802W3g@mail.gmail.com>
Subject: Re: 3.15-rc2: longhaul cpufreq stalls tasks for 120s+
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Meelis Roos <mroos@linux.ee>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b33d24413556b04f7c75415
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b33d24413556b04f7c75415
Content-Type: text/plain; charset=UTF-8

On 24 April 2014 15:46, Meelis Roos <mroos@linux.ee> wrote:
> I can add debug to where needed and try it.

I am quite sure below wouldn't fix it, but just wanted to check
for the corner case :(

Can you please try attached patch (mail's content would be
broken):

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index abda660..7198e23 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -355,10 +355,12 @@ void cpufreq_freq_transition_begin(struct
cpufreq_policy *policy,
                struct cpufreq_freqs *freqs)
 {
 wait:
+       smp_mb();
        wait_event(policy->transition_wait, !policy->transition_ongoing);

        spin_lock(&policy->transition_lock);

+       smp_mb();
        if (unlikely(policy->transition_ongoing)) {
                spin_unlock(&policy->transition_lock);
                goto wait;
@@ -380,8 +382,11 @@ void cpufreq_freq_transition_end(struct
cpufreq_policy *policy,

        cpufreq_notify_post_transition(policy, freqs, transition_failed);

+       smp_mb();
+
        policy->transition_ongoing = false;

+       smp_mb();
        wake_up(&policy->transition_wait);
 }
 EXPORT_SYMBOL_GPL(cpufreq_freq_transition_end);

--047d7b33d24413556b04f7c75415
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-cpufreq-add-smp_mb-s-to-cpufreq-transitions.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-add-smp_mb-s-to-cpufreq-transitions.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hudws76k0

RnJvbSAwOGQ0MmYzOWZlZDMyNmE3NGZhMjA2MmNmYzY2M2NhNDFlZTcxMTQ4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8MDhkNDJmMzlmZWQzMjZhNzRmYTIwNjJjZmM2NjNj
YTQxZWU3MTE0OC4xMzk4MzM1MzMxLmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogVGh1LCAyNCBBcHIg
MjAxNCAxNTo1ODo1MCArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IGFkZCBzbXBfbWIo
KXMgdG8gY3B1ZnJlcSB0cmFuc2l0aW9ucwoKU2lnbmVkLW9mZi1ieTogVmlyZXNoIEt1bWFyIDx2
aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KLS0tCiBkcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIHwg
NSArKysrKwogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jCmluZGV4
IGFiZGE2NjAuLjcxOThlMjMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMK
KysrIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYwpAQCAtMzU1LDEwICszNTUsMTIgQEAgdm9p
ZCBjcHVmcmVxX2ZyZXFfdHJhbnNpdGlvbl9iZWdpbihzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBv
bGljeSwKIAkJc3RydWN0IGNwdWZyZXFfZnJlcXMgKmZyZXFzKQogewogd2FpdDoKKwlzbXBfbWIo
KTsKIAl3YWl0X2V2ZW50KHBvbGljeS0+dHJhbnNpdGlvbl93YWl0LCAhcG9saWN5LT50cmFuc2l0
aW9uX29uZ29pbmcpOwogCiAJc3Bpbl9sb2NrKCZwb2xpY3ktPnRyYW5zaXRpb25fbG9jayk7CiAK
KwlzbXBfbWIoKTsKIAlpZiAodW5saWtlbHkocG9saWN5LT50cmFuc2l0aW9uX29uZ29pbmcpKSB7
CiAJCXNwaW5fdW5sb2NrKCZwb2xpY3ktPnRyYW5zaXRpb25fbG9jayk7CiAJCWdvdG8gd2FpdDsK
QEAgLTM4MCw4ICszODIsMTEgQEAgdm9pZCBjcHVmcmVxX2ZyZXFfdHJhbnNpdGlvbl9lbmQoc3Ry
dWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ksCiAKIAljcHVmcmVxX25vdGlmeV9wb3N0X3RyYW5z
aXRpb24ocG9saWN5LCBmcmVxcywgdHJhbnNpdGlvbl9mYWlsZWQpOwogCisJc21wX21iKCk7CisK
IAlwb2xpY3ktPnRyYW5zaXRpb25fb25nb2luZyA9IGZhbHNlOwogCisJc21wX21iKCk7CiAJd2Fr
ZV91cCgmcG9saWN5LT50cmFuc2l0aW9uX3dhaXQpOwogfQogRVhQT1JUX1NZTUJPTF9HUEwoY3B1
ZnJlcV9mcmVxX3RyYW5zaXRpb25fZW5kKTsKLS0gCjEuNy4xMi5yYzIuMTguZzYxYjQ3MmUKCg==
--047d7b33d24413556b04f7c75415--
