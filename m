Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbaKRKge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:36:34 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:63819 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbaKRKg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:36:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: linaro-acpi@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        rjw@rjwysocki.net, linux-pci@vger.kernel.org, catalin.marinas@arm.com,
        x86@kernel.org, Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, linux-acpi@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, bhelgaas@google.com, tglx@linutronix.de
Subject: Re: [Linaro-acpi] [RFC PATCH 4/4] arm64, acpi, pci: Provide arch-specific calls for PCI host bridge dirver (PNP0A03).
Date: Tue, 18 Nov 2014 11:35:40 +0100
Message-ID: <2257579.qvqyac3u3y@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <546B1CA6.1030300@linaro.org>
References: <1415366876-30811-1-git-send-email-tomasz.nowicki@linaro.org> <2009440.GJsvyI3SUN@wuerfel> <546B1CA6.1030300@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:wUJTPFhR5eOiw3tRBs5E40vIJOHDITeNiXA1FoPoK3V
 wIX4sp85MW2VaPD7NKBpYshPXayadoVXQv6R3GVJklNn/ptK5r
 VrvDPE4NHuDISuuw2QoMvqxbQG3BolGtmPVwfDisGUNHK0kaGa
 P/2sGrN+kGAHiCkXUrYRiVp3DUjLZbCT+j6HUN90lbnpJ7hTOa
 JOZzbfXRBtT2UEzL+2B9nAsOuZ5TIeP0doDIRhV+RCOWPE21qX
 jMfzMw2rHQl/zmcH//8zSrYB4dGiiE6OJK4nw8w5UFRl9r1poi
 expeiV0/PTsaBq33ie4b7Yzv0UwjEnTjNopzjxrOAMox7MAIpE
 sgAXFmPEjmYSmbBZKfPQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 November 2014 11:17:10 Tomasz Nowicki wrote:
> On 14.11.2014 15:53, Arnd Bergmann wrote:
> > On Friday 14 November 2014 15:10:12 Tomasz Nowicki wrote:
> >> On 07.11.2014 15:24, Arnd Bergmann wrote:
> >>> On Friday 07 November 2014 14:27:56 Tomasz Nowicki wrote:
> >>>>
> >>>>    #ifdef CONFIG_PCI
> >>>> +struct pci_controller {
> >>>> +  struct acpi_device *companion;
> >>>> +  int segment;
> >>>> +  int node;               /* nearest node with memory or NUMA_NO_NODE for global allocation */
> >>>> +};
> >>>> +
> >>>> +#define PCI_CONTROLLER(busdev) ((struct pci_controller *) busdev->sysdata)
> >>>> +
> >>>
> >>> Don't use busdev->sysdata in architecture specific code, it belongs to the
> >>> host bridge driver with the new model. For ACPI you don't have a host bridge
> >>> driver, but it's better to keep these separate.
> >>>
> >>> The segment is always the same as the domain number, so just use that.
> >>> The node and companion members here can get added to struct pci_host_bridge.
> >>
> >> The reason why I put segment field to struct pci_controller is to
> >> initialize domain_nr of struct pci_bus being in pci_create_root_bus(),
> >> domain_nr can be used later on though. Correct me I am wrong.
> >>
> >> Honestly I do not see the way to create root bus without e.g.
> >> sysdata.segment here.
> >
> > See the patches that Liviu and Lorenzo have been posting recently. This
> > should be straightforward in 3.19.
> 
> Hi Arnd,
> 
> I have been looking into patch (if that what you meant) :
> [RFC PATCH v2] drivers: pci: move PCI domain assignment to generic PCI code
> 
> This is not enough for me since it gets domain number from its OF parent 
> or just uses sequential increased domain number. In my case, I do not 
> have parent so I need to get segment from ACPI node which is not 
> available there.
> 
> On the other hand, patch set posted by Wang Yijing:
> [RFC PATCH 00/16] Refine PCI host bridge scan interfaces
> tends to solve that issue.
> 
> What would be the best way for this patch, keep busdev->sysdata usage 
> and rebase once Wang Yijing patch set will be accepted?

I think the "Refine PCI host bridge scan interfaces" series is still in an
early stage, you may need something sooner than that.

What I meant is that with "drivers: pci: move PCI domain assignment to
generic PCI code", we already have a way to put the domain number into
'struct pci_bus' and retrieve it from there without ever consulting
the sysdata pointer. You should build on top of that and do it the same
way. Of course you will have to put it in there differently, but you can
get it out the same way.

	Arnd
