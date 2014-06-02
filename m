Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaFBKGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:06:40 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:58995 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaFBKGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:06:38 -0400
MIME-Version: 1.0
In-Reply-To: <5388B134.9090307@wwwdotorg.org>
References: <cover.1400662383.git.viresh.kumar@linaro.org>
	<dc2702973028425e3ded689a6da227658fb914c4.1400662383.git.viresh.kumar@linaro.org>
	<53877103.8070604@wwwdotorg.org>
	<CAKohponsZOpV74+SLMDLy0oCV-j896wA9--bwbwk4GUL59m1ug@mail.gmail.com>
	<5388B134.9090307@wwwdotorg.org>
Date: Mon, 2 Jun 2014 15:36:37 +0530
Message-ID: <CAKohpokxnyu5qk+Jb+LAfHsoFe0iFAg55k1DPN3PO7t+0obBkg@mail.gmail.com>
Subject: Re: [PATCH V4 3/3] cpufreq: Tegra: implement intermediate frequency callbacks
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Doug Anderson <dianders@chromium.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: multipart/mixed; boundary=089e0153745a08cefa04fad78de6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0153745a08cefa04fad78de6
Content-Type: text/plain; charset=UTF-8

On 30 May 2014 21:56, Stephen Warren <swarren@wwwdotorg.org> wrote:
> I believe the issue is this:
>
> We can't change the rate of pll_x while it's being used as a source for
> something. I'm not 100% sure why. I assume the PLL output simply isn't
> stable enough while changing rates; perhaps it can go out-of-range, or
> generate glitches.
>
> This means we must switch the CPU clock source to something else (we use
> pll_p) while changing the pll_x rate.
>
> Since the CPU is the only thing that uses pll_x, if we switch the CPU to
> some other clock source, pll_x will become unused, so it will be
> automatically disabled.
>
> Disabling the PLL, and then re-enabling it later when switching the CPU
> back to it, presumably takes some extra time (e.g. waiting for PLL lock
> when it starts back up), so the code takes an extra reference to the
> clock (prepare_enable) before switching the CPU away from it, and drops
> that (disable_unprepare) after switching the CPU back to it.
>
> The only case pll_x is disabled is when we use a cpufreq of 216MHz; that
> frequency is provided by pll_p itself, so we never switch back to pll_x
> in this case, and do want to shut down pll_x to save some power.
>
> Now, in your patch when switching from 216MHz to pll_x, the initial
> prepare_enable(pll_x) never happens, then the CPU is switched back to
> pll_x which turns it on, then the unpaired disable_unprepare(pll_x)
> happens which turns off pll_x even though the CPU is using it as clock
> source. Arguably the clock API has a bug in that it shouldn't allow
> these unpaired calls to break the reference counting, but that's the way
> the API is right now.

Okay, that was very helpful..

What about this ? (Attached for testing) :

Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Fri May 16 14:22:40 2014 +0530

    cpufreq: Tegra: implement intermediate frequency callbacks

    Tegra had always been switching to intermediate frequency (pll_p_clk) since
    ever. CPUFreq core has better support for handling notifications for these
    frequencies and so we can adapt Tegra's driver to it.

    Also do a WARN() if clk_set_parent() fails while moving back to pll_x as we
    should have atleast restored to earlier frequency on error.

    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 97
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------
 1 file changed, 62 insertions(+), 35 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index 6e774c6..25c145a 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -45,46 +45,51 @@ static struct clk *cpu_clk;
 static struct clk *pll_x_clk;
 static struct clk *pll_p_clk;
 static struct clk *emc_clk;
+static int pll_p_clk_count;

-static int tegra_cpu_clk_set_rate(unsigned long rate)
+static unsigned int tegra_get_intermediate(struct cpufreq_policy *policy,
+                                          unsigned int index)
+{
+       unsigned int ifreq = clk_get_rate(pll_p_clk) / 1000;
+
+       /*
+        * Don't switch to intermediate freq if:
+        * - we are already at it, i.e. policy->cur == ifreq
+        * - index corresponds to ifreq
+        */
+       if ((freq_table[index].frequency == ifreq) || (policy->cur == ifreq))
+               return 0;
+
+       return ifreq;
+}
+
+static int tegra_target_intermediate(struct cpufreq_policy *policy,
+                                    unsigned int index)
 {
        int ret;

        /*
         * Take an extra reference to the main pll so it doesn't turn
-        * off when we move the cpu off of it
+        * off when we move the cpu off of it as enabling it again while we
+        * switch to it from tegra_target() would take additional time. Though
+        * when target-freq is intermediate freq, we don't need to take this
+        * reference.
         */
        clk_prepare_enable(pll_x_clk);

        ret = clk_set_parent(cpu_clk, pll_p_clk);
-       if (ret) {
-               pr_err("Failed to switch cpu to clock pll_p\n");
-               goto out;
-       }
-
-       if (rate == clk_get_rate(pll_p_clk))
-               goto out;
-
-       ret = clk_set_rate(pll_x_clk, rate);
-       if (ret) {
-               pr_err("Failed to change pll_x to %lu\n", rate);
-               goto out;
-       }
-
-       ret = clk_set_parent(cpu_clk, pll_x_clk);
-       if (ret) {
-               pr_err("Failed to switch cpu to clock pll_x\n");
-               goto out;
-       }
+       if (ret)
+               clk_disable_unprepare(pll_x_clk);
+       else
+               pll_p_clk_count++;

-out:
-       clk_disable_unprepare(pll_x_clk);
        return ret;
 }

 static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
 {
        unsigned long rate = freq_table[index].frequency;
+       unsigned int ifreq = clk_get_rate(pll_p_clk) / 1000;
        int ret = 0;

        /*
@@ -98,10 +103,30 @@ static int tegra_target(struct cpufreq_policy
*policy, unsigned int index)
        else
                clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */

-       ret = tegra_cpu_clk_set_rate(rate * 1000);
+       /*
+        * target freq == pll_p, don't need to take extra reference to pll_x_clk
+        * as it isn't used anymore.
+        */
+       if (rate == ifreq)
+               return clk_set_parent(cpu_clk, pll_p_clk);
+
+       ret = clk_set_rate(pll_x_clk, rate * 1000);
+       /* Restore to earlier frequency on error, i.e. pll_x */
        if (ret)
-               pr_err("cpu-tegra: Failed to set cpu frequency to %lu kHz\n",
-                       rate);
+               pr_err("Failed to change pll_x to %lu\n", rate);
+
+       ret = clk_set_parent(cpu_clk, pll_x_clk);
+       /* This shouldn't fail while changing or restoring */
+       WARN_ON(ret);
+
+       /*
+        * Drop count to pll_x clock only if we switched to intermediate freq
+        * earlier while transitioning to a target frequency.
+        */
+       if (pll_p_clk_count) {
+               clk_disable_unprepare(pll_x_clk);
+               pll_p_clk_count--;
+       }

        return ret;
 }
@@ -137,16 +162,18 @@ static int tegra_cpu_exit(struct cpufreq_policy *policy)
 }

 static struct cpufreq_driver tegra_cpufreq_driver = {
-       .flags          = CPUFREQ_NEED_INITIAL_FREQ_CHECK,
-       .verify         = cpufreq_generic_frequency_table_verify,
-       .target_index   = tegra_target,
-       .get            = cpufreq_generic_get,
-       .init           = tegra_cpu_init,
-       .exit           = tegra_cpu_exit,
-       .name           = "tegra",
-       .attr           = cpufreq_generic_attr,
+       .flags                  = CPUFREQ_NEED_INITIAL_FREQ_CHECK,
+       .verify                 = cpufreq_generic_frequency_table_verify,
+       .get_intermediate       = tegra_get_intermediate,
+       .target_intermediate    = tegra_target_intermediate,
+       .target_index           = tegra_target,
+       .get                    = cpufreq_generic_get,
+       .init                   = tegra_cpu_init,
+       .exit                   = tegra_cpu_exit,
+       .name                   = "tegra",
+       .attr                   = cpufreq_generic_attr,
 #ifdef CONFIG_PM
-       .suspend        = cpufreq_generic_suspend,
+       .suspend                = cpufreq_generic_suspend,
 #endif
 };

--089e0153745a08cefa04fad78de6
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-cpufreq-Tegra-implement-intermediate-frequency-callb.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-Tegra-implement-intermediate-frequency-callb.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hvxm4m250

RnJvbSBmYjJkODJhNTJkOTViYmQyMGU0ZWI3NWIzYjc5Zjc0ZWZhNGMxYTc1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8ZmIyZDgyYTUyZDk1YmJkMjBlNGViNzViM2I3OWY3
NGVmYTRjMWE3NS4xNDAxNzAzNTczLmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogRnJpLCAxNiBNYXkg
MjAxNCAxNDoyMjo0MCArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IFRlZ3JhOiBpbXBs
ZW1lbnQgaW50ZXJtZWRpYXRlIGZyZXF1ZW5jeSBjYWxsYmFja3MKClRlZ3JhIGhhZCBhbHdheXMg
YmVlbiBzd2l0Y2hpbmcgdG8gaW50ZXJtZWRpYXRlIGZyZXF1ZW5jeSAocGxsX3BfY2xrKSBzaW5j
ZQpldmVyLiBDUFVGcmVxIGNvcmUgaGFzIGJldHRlciBzdXBwb3J0IGZvciBoYW5kbGluZyBub3Rp
ZmljYXRpb25zIGZvciB0aGVzZQpmcmVxdWVuY2llcyBhbmQgc28gd2UgY2FuIGFkYXB0IFRlZ3Jh
J3MgZHJpdmVyIHRvIGl0LgoKQWxzbyBkbyBhIFdBUk4oKSBpZiBjbGtfc2V0X3BhcmVudCgpIGZh
aWxzIHdoaWxlIG1vdmluZyBiYWNrIHRvIHBsbF94IGFzIHdlCnNob3VsZCBoYXZlIGF0bGVhc3Qg
cmVzdG9yZWQgdG8gZWFybGllciBmcmVxdWVuY3kgb24gZXJyb3IuCgpTaWduZWQtb2ZmLWJ5OiBW
aXJlc2ggS3VtYXIgPHZpcmVzaC5rdW1hckBsaW5hcm8ub3JnPgotLS0KIGRyaXZlcnMvY3B1ZnJl
cS90ZWdyYS1jcHVmcmVxLmMgfCA5NyArKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0t
LS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDYyIGluc2VydGlvbnMoKyksIDM1IGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3B1ZnJlcS90ZWdyYS1jcHVmcmVxLmMgYi9kcml2ZXJz
L2NwdWZyZXEvdGVncmEtY3B1ZnJlcS5jCmluZGV4IDZlNzc0YzYuLjI1YzE0NWEgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvY3B1ZnJlcS90ZWdyYS1jcHVmcmVxLmMKKysrIGIvZHJpdmVycy9jcHVmcmVx
L3RlZ3JhLWNwdWZyZXEuYwpAQCAtNDUsNDYgKzQ1LDUxIEBAIHN0YXRpYyBzdHJ1Y3QgY2xrICpj
cHVfY2xrOwogc3RhdGljIHN0cnVjdCBjbGsgKnBsbF94X2NsazsKIHN0YXRpYyBzdHJ1Y3QgY2xr
ICpwbGxfcF9jbGs7CiBzdGF0aWMgc3RydWN0IGNsayAqZW1jX2NsazsKK3N0YXRpYyBpbnQgcGxs
X3BfY2xrX2NvdW50OwogCi1zdGF0aWMgaW50IHRlZ3JhX2NwdV9jbGtfc2V0X3JhdGUodW5zaWdu
ZWQgbG9uZyByYXRlKQorc3RhdGljIHVuc2lnbmVkIGludCB0ZWdyYV9nZXRfaW50ZXJtZWRpYXRl
KHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9saWN5LAorCQkJCQkgICB1bnNpZ25lZCBpbnQgaW5k
ZXgpCit7CisJdW5zaWduZWQgaW50IGlmcmVxID0gY2xrX2dldF9yYXRlKHBsbF9wX2NsaykgLyAx
MDAwOworCisJLyoKKwkgKiBEb24ndCBzd2l0Y2ggdG8gaW50ZXJtZWRpYXRlIGZyZXEgaWY6CisJ
ICogLSB3ZSBhcmUgYWxyZWFkeSBhdCBpdCwgaS5lLiBwb2xpY3ktPmN1ciA9PSBpZnJlcQorCSAq
IC0gaW5kZXggY29ycmVzcG9uZHMgdG8gaWZyZXEKKwkgKi8KKwlpZiAoKGZyZXFfdGFibGVbaW5k
ZXhdLmZyZXF1ZW5jeSA9PSBpZnJlcSkgfHwgKHBvbGljeS0+Y3VyID09IGlmcmVxKSkKKwkJcmV0
dXJuIDA7CisKKwlyZXR1cm4gaWZyZXE7Cit9CisKK3N0YXRpYyBpbnQgdGVncmFfdGFyZ2V0X2lu
dGVybWVkaWF0ZShzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKKwkJCQkgICAgIHVuc2ln
bmVkIGludCBpbmRleCkKIHsKIAlpbnQgcmV0OwogCiAJLyoKIAkgKiBUYWtlIGFuIGV4dHJhIHJl
ZmVyZW5jZSB0byB0aGUgbWFpbiBwbGwgc28gaXQgZG9lc24ndCB0dXJuCi0JICogb2ZmIHdoZW4g
d2UgbW92ZSB0aGUgY3B1IG9mZiBvZiBpdAorCSAqIG9mZiB3aGVuIHdlIG1vdmUgdGhlIGNwdSBv
ZmYgb2YgaXQgYXMgZW5hYmxpbmcgaXQgYWdhaW4gd2hpbGUgd2UKKwkgKiBzd2l0Y2ggdG8gaXQg
ZnJvbSB0ZWdyYV90YXJnZXQoKSB3b3VsZCB0YWtlIGFkZGl0aW9uYWwgdGltZS4gVGhvdWdoCisJ
ICogd2hlbiB0YXJnZXQtZnJlcSBpcyBpbnRlcm1lZGlhdGUgZnJlcSwgd2UgZG9uJ3QgbmVlZCB0
byB0YWtlIHRoaXMKKwkgKiByZWZlcmVuY2UuCiAJICovCiAJY2xrX3ByZXBhcmVfZW5hYmxlKHBs
bF94X2Nsayk7CiAKIAlyZXQgPSBjbGtfc2V0X3BhcmVudChjcHVfY2xrLCBwbGxfcF9jbGspOwot
CWlmIChyZXQpIHsKLQkJcHJfZXJyKCJGYWlsZWQgdG8gc3dpdGNoIGNwdSB0byBjbG9jayBwbGxf
cFxuIik7Ci0JCWdvdG8gb3V0OwotCX0KLQotCWlmIChyYXRlID09IGNsa19nZXRfcmF0ZShwbGxf
cF9jbGspKQotCQlnb3RvIG91dDsKLQotCXJldCA9IGNsa19zZXRfcmF0ZShwbGxfeF9jbGssIHJh
dGUpOwotCWlmIChyZXQpIHsKLQkJcHJfZXJyKCJGYWlsZWQgdG8gY2hhbmdlIHBsbF94IHRvICVs
dVxuIiwgcmF0ZSk7Ci0JCWdvdG8gb3V0OwotCX0KLQotCXJldCA9IGNsa19zZXRfcGFyZW50KGNw
dV9jbGssIHBsbF94X2Nsayk7Ci0JaWYgKHJldCkgewotCQlwcl9lcnIoIkZhaWxlZCB0byBzd2l0
Y2ggY3B1IHRvIGNsb2NrIHBsbF94XG4iKTsKLQkJZ290byBvdXQ7Ci0JfQorCWlmIChyZXQpCisJ
CWNsa19kaXNhYmxlX3VucHJlcGFyZShwbGxfeF9jbGspOworCWVsc2UKKwkJcGxsX3BfY2xrX2Nv
dW50Kys7CiAKLW91dDoKLQljbGtfZGlzYWJsZV91bnByZXBhcmUocGxsX3hfY2xrKTsKIAlyZXR1
cm4gcmV0OwogfQogCiBzdGF0aWMgaW50IHRlZ3JhX3RhcmdldChzdHJ1Y3QgY3B1ZnJlcV9wb2xp
Y3kgKnBvbGljeSwgdW5zaWduZWQgaW50IGluZGV4KQogewogCXVuc2lnbmVkIGxvbmcgcmF0ZSA9
IGZyZXFfdGFibGVbaW5kZXhdLmZyZXF1ZW5jeTsKKwl1bnNpZ25lZCBpbnQgaWZyZXEgPSBjbGtf
Z2V0X3JhdGUocGxsX3BfY2xrKSAvIDEwMDA7CiAJaW50IHJldCA9IDA7CiAKIAkvKgpAQCAtOTgs
MTAgKzEwMywzMCBAQCBzdGF0aWMgaW50IHRlZ3JhX3RhcmdldChzdHJ1Y3QgY3B1ZnJlcV9wb2xp
Y3kgKnBvbGljeSwgdW5zaWduZWQgaW50IGluZGV4KQogCWVsc2UKIAkJY2xrX3NldF9yYXRlKGVt
Y19jbGssIDEwMDAwMDAwMCk7ICAvKiBlbWMgNTBNaHogKi8KIAotCXJldCA9IHRlZ3JhX2NwdV9j
bGtfc2V0X3JhdGUocmF0ZSAqIDEwMDApOworCS8qCisJICogdGFyZ2V0IGZyZXEgPT0gcGxsX3As
IGRvbid0IG5lZWQgdG8gdGFrZSBleHRyYSByZWZlcmVuY2UgdG8gcGxsX3hfY2xrCisJICogYXMg
aXQgaXNuJ3QgdXNlZCBhbnltb3JlLgorCSAqLworCWlmIChyYXRlID09IGlmcmVxKQorCQlyZXR1
cm4gY2xrX3NldF9wYXJlbnQoY3B1X2NsaywgcGxsX3BfY2xrKTsKKworCXJldCA9IGNsa19zZXRf
cmF0ZShwbGxfeF9jbGssIHJhdGUgKiAxMDAwKTsKKwkvKiBSZXN0b3JlIHRvIGVhcmxpZXIgZnJl
cXVlbmN5IG9uIGVycm9yLCBpLmUuIHBsbF94ICovCiAJaWYgKHJldCkKLQkJcHJfZXJyKCJjcHUt
dGVncmE6IEZhaWxlZCB0byBzZXQgY3B1IGZyZXF1ZW5jeSB0byAlbHUga0h6XG4iLAotCQkJcmF0
ZSk7CisJCXByX2VycigiRmFpbGVkIHRvIGNoYW5nZSBwbGxfeCB0byAlbHVcbiIsIHJhdGUpOwor
CisJcmV0ID0gY2xrX3NldF9wYXJlbnQoY3B1X2NsaywgcGxsX3hfY2xrKTsKKwkvKiBUaGlzIHNo
b3VsZG4ndCBmYWlsIHdoaWxlIGNoYW5naW5nIG9yIHJlc3RvcmluZyAqLworCVdBUk5fT04ocmV0
KTsKKworCS8qCisJICogRHJvcCBjb3VudCB0byBwbGxfeCBjbG9jayBvbmx5IGlmIHdlIHN3aXRj
aGVkIHRvIGludGVybWVkaWF0ZSBmcmVxCisJICogZWFybGllciB3aGlsZSB0cmFuc2l0aW9uaW5n
IHRvIGEgdGFyZ2V0IGZyZXF1ZW5jeS4KKwkgKi8KKwlpZiAocGxsX3BfY2xrX2NvdW50KSB7CisJ
CWNsa19kaXNhYmxlX3VucHJlcGFyZShwbGxfeF9jbGspOworCQlwbGxfcF9jbGtfY291bnQtLTsK
Kwl9CiAKIAlyZXR1cm4gcmV0OwogfQpAQCAtMTM3LDE2ICsxNjIsMTggQEAgc3RhdGljIGludCB0
ZWdyYV9jcHVfZXhpdChzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSkKIH0KIAogc3RhdGlj
IHN0cnVjdCBjcHVmcmVxX2RyaXZlciB0ZWdyYV9jcHVmcmVxX2RyaXZlciA9IHsKLQkuZmxhZ3MJ
CT0gQ1BVRlJFUV9ORUVEX0lOSVRJQUxfRlJFUV9DSEVDSywKLQkudmVyaWZ5CQk9IGNwdWZyZXFf
Z2VuZXJpY19mcmVxdWVuY3lfdGFibGVfdmVyaWZ5LAotCS50YXJnZXRfaW5kZXgJPSB0ZWdyYV90
YXJnZXQsCi0JLmdldAkJPSBjcHVmcmVxX2dlbmVyaWNfZ2V0LAotCS5pbml0CQk9IHRlZ3JhX2Nw
dV9pbml0LAotCS5leGl0CQk9IHRlZ3JhX2NwdV9leGl0LAotCS5uYW1lCQk9ICJ0ZWdyYSIsCi0J
LmF0dHIJCT0gY3B1ZnJlcV9nZW5lcmljX2F0dHIsCisJLmZsYWdzCQkJPSBDUFVGUkVRX05FRURf
SU5JVElBTF9GUkVRX0NIRUNLLAorCS52ZXJpZnkJCQk9IGNwdWZyZXFfZ2VuZXJpY19mcmVxdWVu
Y3lfdGFibGVfdmVyaWZ5LAorCS5nZXRfaW50ZXJtZWRpYXRlCT0gdGVncmFfZ2V0X2ludGVybWVk
aWF0ZSwKKwkudGFyZ2V0X2ludGVybWVkaWF0ZQk9IHRlZ3JhX3RhcmdldF9pbnRlcm1lZGlhdGUs
CisJLnRhcmdldF9pbmRleAkJPSB0ZWdyYV90YXJnZXQsCisJLmdldAkJCT0gY3B1ZnJlcV9nZW5l
cmljX2dldCwKKwkuaW5pdAkJCT0gdGVncmFfY3B1X2luaXQsCisJLmV4aXQJCQk9IHRlZ3JhX2Nw
dV9leGl0LAorCS5uYW1lCQkJPSAidGVncmEiLAorCS5hdHRyCQkJPSBjcHVmcmVxX2dlbmVyaWNf
YXR0ciwKICNpZmRlZiBDT05GSUdfUE0KLQkuc3VzcGVuZAk9IGNwdWZyZXFfZ2VuZXJpY19zdXNw
ZW5kLAorCS5zdXNwZW5kCQk9IGNwdWZyZXFfZ2VuZXJpY19zdXNwZW5kLAogI2VuZGlmCiB9Owog
Ci0tIAoyLjAuMC5yYzIKCg==
--089e0153745a08cefa04fad78de6--
