Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbaIEKOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:14:01 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:59591 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbaIEKN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:13:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-acpi@lists.linaro.org
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Will Deacon <Will.Deacon@arm.com>, Mark Brown <broonie@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v3 13/17] ARM64 / ACPI: Add GICv2 specific ACPI boot support
Date: Fri, 05 Sep 2014 12:13:22 +0200
Message-ID: <3400229.hn32yHbVD2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <540986B2.7000901@arm.com>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <4895927.Zp4WL2AZAF@wuerfel> <540986B2.7000901@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:gZsRtMc/GXqK1mOsMntIT7+eN2ePQvnQXc5i0EiN68/
 FkJFK64hLuftAO8QapRTMDrr9bm3lY0ZdUgsHXRlVfLHr1n+WJ
 Tj9KiePcyNR5kHDiEvtZoQgYcYFronzSSME6TY/kODhwBnCnPT
 zLYimn76XEwb5BaBcTFKVsn59uW4SB6zkPTxB/p7329G9oSomq
 CQiZprnhihjugQ+9pLABfJe7f+1VyHFKNRGevTOjy1+EmtRmSs
 na+Mh5J3IHvGzgs5KZZQpnth+JruFLjDP5noOKLOsFTgvnkG7+
 PDqE6a2OSMJlLKMt4BNcrCrBm+EaGBoH+uTQTfTh11jbSFaYXo
 5n1iCfJ21sFPSpzkNuIU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 10:47:30 Marc Zyngier wrote:
> > 
> > I still prefer being explicit here for the same reason I mentioned earlier:
> > I want it to be very clear that we don't support arbitrary irqchips other
> > than the ones in the APCI specification. The infrastructure exists on DT
> > because we have to support a large number of incompatible irqchips.
> 
> I'm not suggesting that we should support more than the ACPI spec says.
> And that's certainly the whole point of a spec, isn't it? ACPI says what
> we support, and we're not going any further. I'm just saying that we
> shouldn't make the maintenance burden heavier, and the code nothing
> short of disgusting. Using our current infrastructure doesn't mean we're
> going to support GIcv2.37.

Ok

> > In particular, the ACPI tables describing the irqchip have no way to
> > identify the GIC at all, if I read the spec correctly, you have to
> > parse the tables, ioremap the registers and then read the ID to know
> > if you have GICv1/v2/v2m/v3/v4. There doesn't seem to be any "device"
> > for the GIC that a hypothetical probe function would be based on.
> 
> This is not the way I read the spec. Table 5-46 (Interrupt Controller
> Structure) tells you if you have a CPU interface (GICv1/v2) or a
> redistributor (GICv3/v4). That's enough to know whether or not you
> should carry on probing a particular controller.

Ah, good. I missed that.

> The various GIC versions don't really have a unified memory map anyway
> (well, none that you can rely on), and you really have to rely on ACPI
> to tell you what you have.

So we are back to needing to support two different irqchip drivers
(v1/v2/v2m and v3/v4), instead of five or more, right?

> > It does seem wrong to parse the tables in the irq-gic.c file though:
> > that part can well be common across the various gic versions and then
> > call into either irq-gic.c or irq-gic-v3.c for the version specific
> > parts. Whether we put that common code into drivers/irqchip/irqchip.c,
> > drivers/irqchip/gic-common.c, drivers/irqchip/irq-acpi-gic.c or
> > drivers/acpi/irq-gic.c I don't care at all.
> 
> I don't think so you can make that common code very easily. The
> information required by both drivers is organized differently.
> If it was, I'd have done that for the DT binding.

I see, and that's also what Tomasz just explained. So can we just
have one an irqchip_init() function doing this:?

if (dt)
	of_irq_init(__irqchip_of_table);
else if (acpi) {
	read cpu-interface and redistributor address from acpi tables
	if (cpu-interface)
		gic_v2_acpi_init(table);
	else if(redistributor)
		gic_v3_acpi_init(table)
}

	Arnd
