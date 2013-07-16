Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3GPLRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:17:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60335 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab3GPLRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:17:14 -0400
X-AuditID: cbfee61b-b7f1f6d000000f14-77-51e52bb85835
Date: Tue, 16 Jul 2013 13:17:04 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v5 3/7] cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to
 work with common boost solution
Message-id: <20130716131704.6e3c5373@amdc308.digital.local>
In-reply-to: <CAKohpomdkF-XVWXaxNx+SfnHvHE_N6=gcU06YD6D7_oB0-M9aA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-4-git-send-email-l.majewski@samsung.com>
 <CAKohpomdkF-XVWXaxNx+SfnHvHE_N6=gcU06YD6D7_oB0-M9aA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+xoO4O7aeBBms3G1j8ebuc1eJp0w92
	i3mfZS3W7P/JZNF59gmzRe+Cq2wWbx5xW1zeNYfN4nPvEUaL240r2Cz6F/YyWTx52MdmsfGr
	hwOvx+I9L5k87lzbw+axbtpbZo++LasYPR4tbmH0OH5jO5PH501yAexRXDYpqTmZZalF+nYJ
	XBkne/YxFhzjqrj18RRbA2MfRxcjJ4eEgInE/ifTmCBsMYkL99azdTFycQgJTGeUOPx3HZTT
	ziRxvfcSK0gVi4CqxMcvsxlBbDYBPYnPd58CdXNwiAhoSby8mQpSzyzwkVni7sHbLCBxYYFC
	idkLlUHKeQWsJfZMPAvWyikQLNGxYBojxPwWJomVsxvBruAXkJRo//eDGeIiO4lznzawQzQL
	SvyYfI8FxGYG2rV5WxMrhC0vsXnNW+YJjIKzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJ
	ucWleel6yfm5mxjBkfRMegfjqgaLQ4wCHIxKPLwHOZ8ECrEmlhVX5h5ilOBgVhLhvcX/NFCI
	NyWxsiq1KD++qDQntfgQozQHi5I478FW60AhgfTEktTs1NSC1CKYLBMHp1QD4/LXMTb1O49w
	uni9zu80/a/SaXPh/YMT3/7ILXnzceGCU74t2zh2zzi0kDHFc2/Lu3lCiUceKred9HtcP9d3
	8w2erMDsR089i7o6vRdf1HF90t3wI3yb7Celr4sLJnRurXJa+0LZP+P63gVvO5/YTt84x+P5
	rYe3L01aN7Vgcy7TpBmPXI/Y1B9QYinOSDTUYi4qTgQARbxG/aACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013 15:34:02 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 4 July 2013 14:20, Lukasz Majewski <l.majewski@samsung.com> wrote:
> >  static void __init acpi_cpufreq_boost_init(void)
> > @@ -953,33 +937,22 @@ static void __init
> > acpi_cpufreq_boost_init(void) if (!msrs)
> >                         return;
> >
> > -               boost_supported = true;
> > -               boost_enabled = boost_state(0);
> > +               cpufreq_set_boost_enabled(boost_state(0));
> > +               acpi_cpufreq_driver.boost_supported = true;
> 
> You are again doing the same mistake. Boost must be
> always supported for acpi-cpufreq with read permissions, as it was
> earlier.

The boost attribute is exported to sysfs only when boost is supported
by the driver (as we had agreed earlier).  

The problem here is that the original acpi-cpufreq.c file had two
static flags:
static bool boost_enabled, boost_supported;

Both of them are not needed at acpi-cpufreq, since:
1. boost_enabled is defined at cpufreq.c core file.
2. boost_supported is defined at struct cpufreq_driver
(acpi_cpufreq_driver).

I've reused the boost_supported from acpi_cpufreq_driver structure to
avoid code duplication.


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
