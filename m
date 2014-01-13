Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaAMIam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:30:42 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:45165 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaAMIaj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:30:39 -0500
MIME-Version: 1.0
Reply-To: rajatxjain@gmail.com
In-Reply-To: <CAErSpo4gGW2r4X7UuefwcYTX=c4irWc60w2UCT0e_U-uSaujow@mail.gmail.com>
References: <52B0AEAD.6050604@gmail.com>
	<20131218010207.GC15119@google.com>
	<CAA93t1qh2Wn2uPKUGvbqrOJxDfqAqTNFSqOryC36Wm=gnygUog@mail.gmail.com>
	<CAErSpo6A0=0Ph22vMZ1_eC1L7ndoi5S6162zRDYkMoPf53Fhcg@mail.gmail.com>
	<4b24688d857e432eb7ecf9095c95b742@DM2PR05MB671.namprd05.prod.outlook.com>
	<bfe1b6a0b2494c71be43fea45f413575@DM2PR05MB671.namprd05.prod.outlook.com>
	<CAErSpo4gGW2r4X7UuefwcYTX=c4irWc60w2UCT0e_U-uSaujow@mail.gmail.com>
Date: Mon, 13 Jan 2014 00:30:39 -0800
Message-ID: <CAA93t1pwLNeCXPXOO1yTPiREVP=sos1bwpob=VnLhSm_zocEkw@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] pciehp: Don't disable the link permanently, during removal
From: Rajat Jain <rajatxjain@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatjain@juniper.net>, Rajat Jain <rajatjain.linux@gmail.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, Guenter Roeck <groeck@juniper.net>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai / Bjorn,


On Thu, Jan 9, 2014 at 12:58 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> >
>>> > On Sun, Jan 5, 2014 at 10:53 AM, Rajat Jain <rajatxjain@gmail.com>
>>> > wrote:
>>> > > Hello Bjorn,
>>> > >
>>> > > Just checking on the fate of this patch set...
>>> > >
>>> > > On Tue, Dec 17, 2013 at 5:02 PM, Bjorn Helgaas <bhelgaas@google.com>
>>> > wrote:
>>> > >> [+cc yinghai@kernel.org (seems to be Yinghai's preferred email]
>>> > >>
>>> > >> On Tue, Dec 17, 2013 at 12:06:05PM -0800, Rajat Jain wrote:
>>> > >>> We need future link up events for hot-add, thus don't disable the
>>> > >>> link permanently during device removal. Also, remove the static
>>> > >>> functions that are now left unused.
>>> > >>
>>> > >> The changelog should mention that this reverts part of 2debd9289997
>>> > ("PCI:
>>> > >> pciehp: Disable/enable link during slot power off/on").
>>> > >
>>> > > Sure. Do you want me to submit another patch set (bumping up the
>>> > > version) with this change log, or you'd want to add this change log
>>> > > while merging?
>>> > >
>>> > >>
>>> > >> Yinghai, can you tell us whether this is an issue on your systems?
>>> > >
>>> > > As Yinghai confirms further down this thread, his issue was
>>> > > confirmed by Intel to be a bug in the repeater chip.
>>> > > ----------------------------------
>>> > > Yinghai writes:
>>> > >> According to HW guys and Intel, that should be bug of repeater.
>>> > >>
>>> > > ---------------------------------
>>> > >  I don't know about the details of his scenario, except that when
>>> > > the adapter was disabled the repeater kept on flapping the link up &
>>> > > down (and hence disabling the link solved the problem then). Yinghai
>>> > > couldn't test, but I believe with this patch even if we disable
>>> > > presence detect interrupt, the "adapter present / no present"
>>> > > messages would (rightly) convert to "Link Up / Link Down" messages
>>> > > (since the repeater keeps on flapping the link).
>>> > >
>>> > > Since it is a platform specific bug, I'm not sure what can be done
>>> > > to remove those messages except may be reduce the verbosity? If
>>> > > you'd like I could change all the INFO messages to DBG messages.
>>> >
>>> > Even if it's a defect in a particular piece of hardware, I don't want
>>> > to regress on that hardware, even if the regression is just extra
>>> > messages that we didn't see before.
>>> >
>>> > I think ideally we would add some sort of quirk for that hardware so
>>> > it works just as well as it does today.  I think extra messages will
>>> > lead to a bug reports from users.
>>>
>>> Sure, I can do that. I think what the quirk would have to do is that for
>>> that particular platform, don't enable the link-state based hotplug.
>>> (Since link-state hotplug will not work if we disable the link
>>> permanently as we do today on card removal).
>>>
>>> But the question is how to determine that the quirk has to be applied? I
>>> think the objective is to apply the quirk to the platforms that have a
>>> "PCIe repeater". Since this does not depend on a PCI device / vendor ID,
>>> and I think the PCIe repeater is probably not even visible to the pciehp
>>> or the PCI subsystem, how do I determine that the quirk has to be
>>> applied?
>>
>> Any ideas on how do I identify the platforms that may have this problem?
>
> I sure don't know.  I suspect you're right that the PCIe repeater is
> invisible to software, at least in terms of PCI config space.  Maybe
> we could use DMI to identify platforms.  That's not a very good
> solution because we have to come up with a list, but I can't think of
> a better way.  Yinghai knows more about the platform and might have
> better ideas.

Yinghai: I am trying to understand what exactly is this platform bug
and how to add a quirk such that this platform remains unaffected. Can
you please help me by suggesting how to decide if this is _the_
platform that has the bug (the pcie repeater).

Bjorn: It seems to be that identification of this platform will be out
PCI code (since the bug seems to be in a pcie repeater chip which is
not a PCI device visible to SW). So even if we find a way to identify
this platform (e.g DMI) , I doubt if you'd want me to add that in the
pciehp code (which is platform independent so far). At best, the only
way out I can see is to provide a knob from the pciehp, that can be
use by the platform code to either enable or disable the link state
hotplug. It could go back towards using a module parameter like
pciehp_use_link_events. Please suggest.

The only other way I can think of, is that I can remove the debug
message altogether (Link up / Link down). (Or the user can change the
verbosity).

Humm, when I think of it, we're trying to address a bug of a chip
which is not a PCI device, into pciehp. I'm praying it doesn't bring
this patch set to a dead end :-)

Thanks,

Rajat

>
> Bjorn
>
>>> If (hw_has_pcie_repeater)
>>>       Don't use link-state hotplug (and disable link permanently during
>>> card removal) Else
>>>       Use link-state hotplug (and don't disable the link permanently)
>>>
>>>
>>> Yinghai: Since I do not have that hardware, I will need some help in
>>> testing the patch with the quirk. I was wondering if you'd still have
>>> that hardware around and would be able to help me with testing?
>>>
>>> Thanks,
>>>
>>> Rajat
>>>   {.n +       +%  lzwm  b 맲  r  zX   \ )   w*jg         ݢj/   z ޖ  2 ޙ
>>> & )ߡ a       G   h   j:+v   w ٥
