Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaKDB3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:29:01 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37856 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaKDB26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:28:58 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-sh\@vger.kernel.org" <linux-sh@vger.kernel.org>,
        linux-pm@vger.kernel.org,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/9] ARM: shmobile: R-Mobile: DT PM domain support
References: <1415028896-9005-1-git-send-email-geert+renesas@glider.be>
	<CANLsYkzVw_fQQuK9pEomMp6A_z2Qg9L-Hj1f+8b_1o7cFjMiDw@mail.gmail.com>
Date: Mon, 03 Nov 2014 17:28:54 -0800
In-Reply-To: <CANLsYkzVw_fQQuK9pEomMp6A_z2Qg9L-Hj1f+8b_1o7cFjMiDw@mail.gmail.com>
	(Mathieu Poirier's message of "Mon, 3 Nov 2014 14:02:31 -0700")
Message-ID: <7hegtj69ex.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Poirier <mathieu.poirier@linaro.org> writes:

> On 3 November 2014 08:34, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
>>         Hi Rafael, Simon, Magnus,
>>
>> This patch series enables DT support for PM domains on Renesas R-Mobile SoCs.
>>
>> Currently it's limited to R-Mobile A1 (r8a7740), but given the similarity of
>> the SYSC System-Controller on the various SH-Mobile/R-Mobile SoCs, and the
>> abstraction of PM domains in DT, it should be sufficiently generic to handle
>> other SoCs in the future (e.g. SH-Mobile AP4 (sh7372), SH-Mobile AG5 (sh73a0),
>> R-Mobile APE6 (r8a73a4)).
>>
>> Functionality-wise, this behaves the same as the legacy (non-DT) version
>> (modulo missing DT support in some device drivers).
>>
>> Dependencies:
>>   - This is based on Simon Horman's renesas-devel-20141030-v3.18-rc2, and
>>     Rafael J. Wysocki's linux-pm.git#linux-next,
>>   - This depends on "PM / Domains: Change prototype for the ->attach_dev()
>>     callback" from Ulf hanson, which is intended to still enter v3.18-rcX
>>     through the linux-pm tree.
>>     As this is a one-line change, I included this patch as the first patch of
>>     this series.  Perhaps it's even acceptable for Simon to (also) apply it, so
>>     we don't have to wait for the v3.18-rcX that will include it?
>>
>> For your convenience, I've also pushed this to
>> git://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git#rmobile-genpd
>>
>> Changes compared to v3 (more detailed changelogs in the individual patches):
>>   - I dropped the patch to add preliminary PM domain latencies, as I want to do
>>     more measurements for PM domains that are currently never powered off.
>>     Values seem to range between 8.5 and 26 us, depending on the PM domain.
>>   - I dropped all patches related to QoS device latencies, as these need more
>>     discussion,
>>   - The power-{on,off}-latency properties have been changed from a single value
>>     to a list,
>>   - Device save/restore state latencies have been dropped, as they're Linux
>>     driver-specific, and thus don't belong in DT,
>>   - Use proper pm_clk_create()/pm_clk_destroy(), and update for attach_dev()
>>     returning an error code again,
>>   - New patch to enable module clocks if !CONFIG_PM_RUNTIME,
>>   - Always keep D4 powered, until the new Coresight code handles runtime
>>     PM,
>
> I took the time to really look at the problems you are experiencing
> with pm runtime in hw_breackpoint.c this weekend.  The coresight
> patchset, when supplemented with PM runtime awareness, will fix that
> problem *only* when traces are activated.  The other obvious condition
> is that other component using the same power domain are also converted
> to using runtime PM.
>
> That being said, the coresight framework and breakpoint handler code
> are two different subsystem.  Their only commonality is that they make
> use of the debug registers (and not even the same ones).  As such (and
> in my opinion) the code in hw_breakpoint should be getting its own pm
> runtime reference without relying on the coresight subsystem.  As
> indicated above, that would only work in some cases.
>
> Supplementing hw_breakpoint to interact with the runtime PM may prove
> trickier than it seems... I'm especially worried about the
> non-blocking requirement inherent to using "smp_call_function()".  I'm
> stepping forward to look into that problem but before doing so I need
> to finish runtime PM on coresight.

Matthieu, without looking more deeply myself, I'm not sure this is what
you need, but have a look at the "IRQ safe" mode of runtime PM.  If you
know your devices runtime PM callbacks are IRQ safe, you can call
pm_runtime_irq_safe(), and your callbacks will be called with IRQs
disabled.

Kevin
