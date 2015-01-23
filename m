Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbbAWNr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:47:28 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:57112 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbbAWNr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:47:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kevin Hilman <khilman@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3/resend 3/4] drivers: bus: Add Simple Power-Managed Bus DT Bindings
Date: Fri, 23 Jan 2015 14:46:35 +0100
Message-ID: <2160255.41m7rrCYxI@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdUMcyXdgv+xdd8Zo67rYnfh6JaSWfr1H3c6NrQs=JsNLg@mail.gmail.com>
References: <1421919253-4784-1-git-send-email-geert+renesas@glider.be> <7hvbjy30an.fsf@deeprootsystems.com> <CAMuHMdUMcyXdgv+xdd8Zo67rYnfh6JaSWfr1H3c6NrQs=JsNLg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:2kpG32yHO4iNec4M/MGLS/TRIwpSt551n72cVyPAl722VA8ePQA
 0vAD7tkjpA0xV3wpnNcxSzkLpjRJ2bgTolG33oHW7aFMK/7Sc2rNkJCTx628Q9Hs6iDxwWA
 ojebHnWqv2G4SO6kNfHfSoGndAGMDosRVF3KfZpczARI2VwDZUlCKcrZpMMbM9uxk49diRd
 5HSbNTiYpuUFSsaRNvOvg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 January 2015 09:56:51 Geert Uytterhoeven wrote:
> >> diff --git a/Documentation/devicetree/bindings/bus/simple-pm-bus.txt b/Documentation/devicetree/bindings/bus/simple-pm-bus.txt
> >> new file mode 100644
> >> index 0000000000000000..d03abf7fd8e3997a
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/bus/simple-pm-bus.txt
> >> @@ -0,0 +1,52 @@
> >> +Simple Power-Managed Bus
> >> +========================
> >> +
> >> +A Simple Power-Managed Bus is a transparent bus that doesn't need a real
> >> +driver, as it's typically initialized by the boot loader.
> >> +
> >> +However, its bus controller is part of a PM domain, or under the control of a
> >> +functional clock.  Hence, the bus controller's PM domain and/or clock must be
> >> +enabled for child devices connected to the bus (either on-SoC or externally)
> >> +to function.
> >> +
> >> +
> >> +Generic compatible values and properties
> >> +----------------------------------------
> >> +
> >> +Required properties:
> >> +  - compatible: Must be at least one of the vendor-specific compatible values
> >> +             from a vendor-specific section below, and "simple-bus" as a
> >> +             fallback.
> >
> > What happened to the idea of using something like "simple-pm-bus"?
> 
> I think that's a decision to make by the (successor of the) ePAPR committee.
> At least it would be nice to get some feedback from the DT review team
> about this.
> 
> If we go that road, the vendor-specific compatible value should still be
> documented, else checkpatch will complain when encountering it in a DTS.
> Then, should it become
> 
>     compatible = "renesas,bsc-sh73a0", "renesas,bsc", "simple-pm-bus",
> "simple-bus";
> 
> or should "simple-bus" just be added to of_default_bus_match_table[], so we
> can drop "simple-bus" from the list in the DTS:
> 
>     compatible = "renesas,bsc-sh73a0", "renesas,bsc", "simple-pm-bus";

I was thinking of the reverse: drop "simple-bus" bus from the list here,
but not add "simple-pm-bus" to of_default_bus_match_table. This will
cause child devices to no longer be probed automatically, and you will
have to call of_platform_populate() from simple_pm_bus_probe(), after
pm_runtime_enable(). This seems like a cleaner model to me, for two
reasons:

- In the binding, claiming compatibility with "simple-bus" feels
  wrong to me, because you have a bus that is not as simple as others

- The ordering between pm_runtime_enable() and the probing of the
  child devices is guaranteed, which I think it is not with your
  current code.

Does this make sense, or am I missing an important reason why there
has to be a "simple-bus" compatible string here?

	Arnd
