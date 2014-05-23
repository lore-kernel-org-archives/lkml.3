Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaEWNCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:02:04 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:53091 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaEWNCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:02:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140523115622.GU27560@rric.localhost>
References: <20140521231615.26447.38060.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140521231817.26447.55150.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140521233802.GA21575@pd.tnic> <CAErSpo4hcitey+jtZkgpbZsEswJJekStXONct9rrh0aQ_R0h8g@mail.gmail.com>
 <20140522191746.GL4383@pd.tnic> <CAErSpo7=0-xdnu4DQufu_6eS=6AYhnDRaQvzeiMEC5a=zKU0Jg@mail.gmail.com>
 <537E8ACF.6000103@amd.com> <CAErSpo6AMGPFELx+2qJXYaxaLRhk2F2J=wn4=gLgmvYGdLup7A@mail.gmail.com>
 <20140523115622.GU27560@rric.localhost>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 23 May 2014 07:01:41 -0600
Message-ID: <CAErSpo5t+u+AYS5m6wo+AG7uXEkseUcmK9d-FF+SwpkcEWnkqA@mail.gmail.com>
Subject: Re: [PATCH V5 3/4] x86/PCI: Stop enabling ECS for AMD CPUs after Fam16h
To: Robert Richter <rric@kernel.org>
Cc: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 5:56 AM, Robert Richter <rric@kernel.org> wrote:
> On 22.05.14 20:54:54, Bjorn Helgaas wrote:
>> I'm going to go out on a limb and guess that Windows does not enable
>> ECS, so it probably uses ECAM.  Therefore, I suspect Linux's parsing
>> of MCFG is broken in some way, and we probably *could* use ECAM in all
>> these cases I'm seeing.
>
> Even if ECS is not enabled the system should be fine anyway, as ECS is
> only used to enable certain features. For family 10h this was
> originally the IBS EILVT (extended interrupt local vector table,
> needed for hw profiling) setup which need to be set by the OS which
> the BIOS didn't right. This should be fixed now and properly set by
> the BIOS on 15h+ systems.
>
> I don't remember what was added to 16h where ECS was needed, I think
> there was one (Suravee?). Not sure if this is essential.
>
> So using MCFG should be fine, since if in the rare case when it is
> broken, the system should work properly anyway without it and only
> some special features, if any, do not work anymore (e.g. IBS should
> work fine).

[I guess I've been using the wrong term here.  I think "ECS" just
refers to the extended config space itself, and I should have been
saying "IO ECS" or "EnableCf8ExtCfg".]

My understanding was that if we don't enable IO ECS and we don't have
MCFG, we will not be able to access extended config space.  The system
can certainly boot without extended config space, but some drivers may
not work correctly, so it would be a regression from the user point of
view.

The case where MCFG is broken may be rare, but I still want to avoid
the regression.  And my guess is that the MCFG is not really broken in
these cases, because I suspect Windows is using it.  Our MCFG parsing
code is a mess, and I suspect that we are claiming MCFG is broken when
it really isn't.

If I understand correctly, IO ECS is also limited to domain 0, so if
we have multiple PCI host bridges, i.e., multiple PNP0A03/PNP0A08
devices, and we want them in different domains, we'd have to use ECAM.

Bjorn
