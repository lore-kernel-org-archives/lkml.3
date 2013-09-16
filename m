Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab3IPQX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:23:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab3IPQXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:23:55 -0400
Message-ID: <523730F2.40408@redhat.com>
Date: Mon, 16 Sep 2013 18:25:22 +0200
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Matt Fleming <matt@console-pimps.org>, jerry.hoemann@hp.com,
        Andrew Fish <afish@apple.com>, edk2-devel@lists.sourceforge.net,
        linux-efi@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Brian Richardson <brian.richardson@intel.com>,
        Colin Ian King <colin.king@canonical.com>,
        Randy Wright <rwright@hp.com>, Linn Crosetto <linn.crosetto@hp.com>,
        terry.lee@hp.com, samer.el-haj-mahmoud@hp.com, randy.pawell@hp.com,
        chrisp@hp.com, linda.knippers@hp.com, dong.wei@hp.com,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Chao Zhang <chao.b.zhang@intel.com>, Yao Jiewen <jiewen.yao@intel.com>
Subject: Re: [edk2] Corrupted EFI region
References: <20130806141036.GD14891@pd.tnic> <520116D1.2010000@redhat.com> <20130807151935.GJ17920@pd.tnic> <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com> <20130807201908.GG2515@console-pimps.org> <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com> <20130808101730.GJ2515@console-pimps.org> <20130913203812.GA312@anatevka.fc.hp.com> <20130916105920.GB2697@console-pimps.org> <5236F096.8040702@redhat.com> <20130916155751.GA3636@leaf>
In-Reply-To: <20130916155751.GA3636@leaf>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/13 17:57, Josh Triplett wrote:

>> The edk2 commit that flipped the memory type underneath the image data
>> from EfiReservedMemoryType to EfiBootServicesData is:
>>
>>     https://github.com/tianocore/edk2/commit/4c58575e
>>
>> I think this commit is wrong. It's fine for OSPM to release the image
>> data at some point, but not right after ExitBootServices(), because
>> referencing pointers in ACPI tables survive strictly longer.
>>
>> ... Actually, the commit does follow the ACPI spec 5.0:
>>
>> 5.2.22.4 Image Address
>>
>>     The Image Address contains the location in memory where an
>>     in-memory copy of the boot image can be found. The image should be
>>     stored in EfiBootServicesData, allowing the system to reclaim
>>     the memory when the image is no longer needed.
>>
>> The ACPI spec 5.0 should recommend EfiACPIReclaimMemory here IMO. (I
>> take the current wording ("should be stored") as a recommendation only.)
> 
> I agree that UEFI *should* store the BGRT in EfiACPIReclaimMemory, but
> in practice the UEFI firmware I've seen with a BGRT does follow that
> recommendation and store it in EfiBootServicesData.  So, even if the
> recommendation in the spec changed, the kernel would still have to
> accomodate both possibilities.

Just for the theoretical debate:

The edk2 commit linked above is 5 days old. All UEFI firmware in the
wild (on released hardware) should be using EfiReservedMemoryType (the
pre-patch memory type), which is even stricter.

EfiReservedMemoryType can never be released & repurposed, so it should
make no difference for crash kernel allocation, shouldn't it?

- call efi_free_boot_services() -- doesn't touch the image data (which
  is in RAM of EfiReservedMemoryType),
- reserve crash kernel,
- access BGRT via ACPI.

BGRT had appeared in edk2 with

  https://github.com/tianocore/edk2/commit/0284e90c

and EfiReservedMemoryType used to be the allocation type until commit
4c58575e.

Or are you alluding to UEFI firmware that's not based on TianoCore?

Laszlo
