Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab3ITJfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:35:19 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:42623 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab3ITJfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:35:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokdOXrGVxEA89yrAq2T8MiqZNHrrXNagqqggo67rEmKYg@mail.gmail.com>
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com>
	<45987104.t6r4hvPgQn@vostro.rjw.lan>
	<523AF22F.1010909@linux.vnet.ibm.com>
	<CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
	<CACRpkdYBYdMJ6mTGUropOypx0ZVNn8eQMzV+eKocCSBZAu6xTA@mail.gmail.com>
	<CAKohpokQO82XMGwcTjVmNTbBVESyFqV4DAxMMU_RHEtN+LqUgg@mail.gmail.com>
	<CACRpkdYoNkgno24dtJAwOq2T9yoKQYgKQ+adfkSN8affYNePjQ@mail.gmail.com>
	<CAKohpokdOXrGVxEA89yrAq2T8MiqZNHrrXNagqqggo67rEmKYg@mail.gmail.com>
Date: Fri, 20 Sep 2013 15:05:16 +0530
Message-ID: <CAKohpomXsZ+BsE7j-J4qU+x9f+JPsNEMi3d=CmfMByzPw_wvtw@mail.gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b5daca0601f6e04e6cd634a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b5daca0601f6e04e6cd634a
Content-Type: text/plain; charset=ISO-8859-1

On 20 September 2013 14:19, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Hmm... Remember I told you last time that I have another way of fixing
> it up, probably we need that now..
>
> I wanted to add another variable to reflect if a cpufreq_driver is registered
> or not, and if not then return early from these routines..
>
> I will get that in now, please see if you can give it a try..
>
> But I am still surprised how are we reaching this place before your cpufreq
> driver gets registered..

Once we know what's going on in your system, please test attached patch
(Will send it separately once you have tested it):

commit 389fbc3c8ad7c339cd2d9572d73c355b7b967823
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Fri Sep 20 14:55:31 2013 +0530

    cpufreq: check cpufreq driver is valid and cpufreq isn't disabled
in cpufreq_get()

    cpufreq_get() can be called from external drivers which might not
be aware if
    cpufreq driver is registered or not. And so we should actually
check if cpufreq
    driver is registered or not and also if cpufreq is active or
disabled, at the
    beginning of cpufreq_get().

    Otherwise call to lock_policy_rwsem_read() might hit BUG_ON(!policy).

    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 82ecbe3..db004a8 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1460,6 +1460,9 @@ unsigned int cpufreq_get(unsigned int cpu)
 {
        unsigned int ret_freq = 0;

+       if (cpufreq_disabled() || !cpufreq_driver)
+               return -ENOENT;
+
        if (!down_read_trylock(&cpufreq_rwsem))
                return 0;

--047d7b5daca0601f6e04e6cd634a
Content-Type: application/octet-stream; 
	name="0001-cpufreq-check-cpufreq-driver-is-valid-and-cpufreq-is.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-check-cpufreq-driver-is-valid-and-cpufreq-is.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hlt7q3550

RnJvbSAzODlmYmMzYzhhZDdjMzM5Y2QyZDk1NzJkNzNjMzU1YjdiOTY3ODIzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8Mzg5ZmJjM2M4YWQ3YzMzOWNkMmQ5NTcyZDczYzM1
NWI3Yjk2NzgyMy4xMzc5NjY5NjI1LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogRnJpLCAyMCBTZXAg
MjAxMyAxNDo1NTozMSArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IGNoZWNrIGNwdWZy
ZXEgZHJpdmVyIGlzIHZhbGlkIGFuZCBjcHVmcmVxIGlzbid0CiBkaXNhYmxlZCBpbiBjcHVmcmVx
X2dldCgpCgpjcHVmcmVxX2dldCgpIGNhbiBiZSBjYWxsZWQgZnJvbSBleHRlcm5hbCBkcml2ZXJz
IHdoaWNoIG1pZ2h0IG5vdCBiZSBhd2FyZSBpZgpjcHVmcmVxIGRyaXZlciBpcyByZWdpc3RlcmVk
IG9yIG5vdC4gQW5kIHNvIHdlIHNob3VsZCBhY3R1YWxseSBjaGVjayBpZiBjcHVmcmVxCmRyaXZl
ciBpcyByZWdpc3RlcmVkIG9yIG5vdCBhbmQgYWxzbyBpZiBjcHVmcmVxIGlzIGFjdGl2ZSBvciBk
aXNhYmxlZCwgYXQgdGhlCmJlZ2lubmluZyBvZiBjcHVmcmVxX2dldCgpLgoKT3RoZXJ3aXNlIGNh
bGwgdG8gbG9ja19wb2xpY3lfcndzZW1fcmVhZCgpIG1pZ2h0IGhpdCBCVUdfT04oIXBvbGljeSku
CgpTaWduZWQtb2ZmLWJ5OiBWaXJlc2ggS3VtYXIgPHZpcmVzaC5rdW1hckBsaW5hcm8ub3JnPgot
LS0KIGRyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMgfCAzICsrKwogMSBmaWxlIGNoYW5nZWQsIDMg
aW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMgYi9k
cml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jCmluZGV4IDgyZWNiZTMuLmRiMDA0YTggMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMKKysrIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZy
ZXEuYwpAQCAtMTQ2MCw2ICsxNDYwLDkgQEAgdW5zaWduZWQgaW50IGNwdWZyZXFfZ2V0KHVuc2ln
bmVkIGludCBjcHUpCiB7CiAJdW5zaWduZWQgaW50IHJldF9mcmVxID0gMDsKIAorCWlmIChjcHVm
cmVxX2Rpc2FibGVkKCkgfHwgIWNwdWZyZXFfZHJpdmVyKQorCQlyZXR1cm4gLUVOT0VOVDsKKwog
CWlmICghZG93bl9yZWFkX3RyeWxvY2soJmNwdWZyZXFfcndzZW0pKQogCQlyZXR1cm4gMDsKIAot
LSAKMS43LjEyLnJjMi4xOC5nNjFiNDcyZQoK
--047d7b5daca0601f6e04e6cd634a--
