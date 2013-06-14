Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3FNRpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 13:45:11 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:57662 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3FNRpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 13:45:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUO350kqrXB5=yQ-OxOeSJj4+P6WPg4gGgXxFEvfoLyng@mail.gmail.com>
References: <CAE9FiQVu5QyxaKsYzzQoroQD=TvsziHzDOtoeg=FvhZ8HyN5yw@mail.gmail.com>
 <CAErSpo7ChfRiEn0eR1rf-mVheUS9Yf8f+j4n78PJcGYh+yMVgA@mail.gmail.com>
 <CAE9FiQXkDg7Y336S=DXoms44=5HLaiUx=sWviupz1fJmaDUEzQ@mail.gmail.com>
 <CAE9FiQU5c=ztzbskNnYFFKF9V5zO+jnRcMBCivLxA1F3fSfX5w@mail.gmail.com>
 <20130401235256.GA31966@google.com> <CAE9FiQV8cPh-s6=EQu_cZTtn86+NwZE5KuGMhf43aOhzkL=hwA@mail.gmail.com>
 <CAErSpo7Jni1ZSf_W=vB3kqsucPpoepa2Q5g=77a6D3FaPwe9LA@mail.gmail.com>
 <CAE9FiQWjQXwiTWju6cBc_o25jy_wmZ1u+Pifh1wdnxtV=i5ENw@mail.gmail.com>
 <CAErSpo7=a-wX6BLbm_O1nUMMrQHOgtSm3xZHKuRqaz8rnKSbRA@mail.gmail.com>
 <CAE9FiQUbw7OUhRB+gKMxkuE9+nm9097+mwZ2z4adO8Hv_NjF1Q@mail.gmail.com>
 <20130614141101.GA29452@google.com> <CAE9FiQVr-OWeqEHFXn0MjNiSD0WM=FNO_DFo6m9UbbG60uonpw@mail.gmail.com>
 <CAErSpo7grN-93zZfBJOHZH-pR1wDYrojTwt=B=++QqA0rPb3Rg@mail.gmail.com> <CAE9FiQUO350kqrXB5=yQ-OxOeSJj4+P6WPg4gGgXxFEvfoLyng@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 14 Jun 2013 11:44:42 -0600
Message-ID: <CAErSpo6vEOw10YV=Sou6wjjSc2GWr-oX=Dvbt7Xt=RJKi4RELw@mail.gmail.com>
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Roman Yepishev <roman.yepishev@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 10:57 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Jun 14, 2013 at 9:33 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Fri, Jun 14, 2013 at 10:17 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> Can you please refer to specific function names?  I can't read your mind.
>>
>> You might be referring to quirk_disable_aspm_l0s().  This is a
>> pci_fixup_final quirk that calls pci_disable_link_state().  In the
>> current tree, we enumerate devices before requesting _OSC control.
>> However, pci_fixup_final quirks are not run until the
>> pci_apply_final_quirks() fs_initcall, which is after we request _OSC
>> control.
>>
>> As far as I can tell, we never call pci_disable_link_state() before
>> calling pcie_no_aspm().
>
> ok, you are right, that is not pci_disable_link_state.
>
> It is pcie_aspm_init_link_state ==> pcie_aspm_sanity_check in booting path
> that disable aspm.  It has  "if (aspm_disabled)" in it, and it cause
> the difference.

Yes, I agree, the pcie_aspm_init_link_state() path uses aspm_disabled
before we set it:

    acpi_pci_root_add
      pci_acpi_scan_root
        pci_scan_child_bus
          pci_scan_slot
            pcie_aspm_init_link_state
              pcie_aspm_sanity_check
                if (aspm_disabled)              # used before set
                  ...
      acpi_pci_osc_control_set
      pcie_no_aspm
        aspm_disabled = 1                       # set

That might mean we do some ASPM configuration during enumeration (in
pci_scan_slot()) even though the BIOS hasn't given us permission.  It
looks like we did that even in v3.7, since we did the enumeration
before the _OSC there as well.  That looks like a bug to me.

I don't think the fact that we have been doing ASPM config during
enumeration before _OSC is an argument for dropping the check in
pci_disable_link_state().

Bjorn
