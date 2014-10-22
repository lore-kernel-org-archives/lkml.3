Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbaJVCsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 22:48:15 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39793 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232AbaJVCsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 22:48:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        "Hoemann\, Jerry" <jerry.hoemann@hp.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, Baoquan He <bhe@redhat.com>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list\:INTEL IOMMU \(VT-d\)" <iommu@lists.linux-foundation.org>,
        doug.hatch@hp.com,
        "ishii.hironobu\@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        zhenhua@hp.com, Zhen-Hua <zhen-hual@hp.com>,
        "Vaden\, Tom L \(HP Server OS Architecture\)" <tom.vaden@hp.com>
References: <1398386198-19304-1-git-send-email-bill.sumner@hp.com>
	<1398854973.12733.23.camel@i7.infradead.org>
	<20140702133258.GN26537@8bytes.org>
	<CAErSpo69VmK5zD-ztNVHCA=KrK8zucqubY17z0K3rcpe6ReNUA@mail.gmail.com>
Date: Tue, 21 Oct 2014 21:47:22 -0500
In-Reply-To: <CAErSpo69VmK5zD-ztNVHCA=KrK8zucqubY17z0K3rcpe6ReNUA@mail.gmail.com>
	(Bjorn Helgaas's message of "Tue, 21 Oct 2014 20:16:46 -0600")
Message-ID: <87mw8on7lx.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18MVyIERy4yFfx2wMQze2wiDjn5mPh7+Do=
X-SA-Exim-Connect-IP: 68.113.178.29
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Bjorn Helgaas <bhelgaas@google.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 469 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 4.4 (0.9%), b_tie_ro: 3.1 (0.7%), parse: 1.32 (0.3%),
	extract_message_metadata: 19 (4.1%), get_uri_detail_list: 5.0 (1.1%),
	tests_pri_-1000: 6 (1.4%), tests_pri_-950: 1.21 (0.3%), tests_pri_-900: 0.99
	(0.2%), tests_pri_-400: 28 (6.0%), check_bayes: 27 (5.8%), b_tokenize: 9
	(2.0%), b_tok_get_all: 10 (2.1%), b_comp_prob: 2.8 (0.6%), b_tok_touch_all:
	2.8 (0.6%), b_finish: 0.67 (0.1%), tests_pri_0: 396 (84.5%), tests_pri_500: 7
	(1.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 0/8] iommu/vt-d: Fix crash dump failure caused by legacy DMA/IO
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas <bhelgaas@google.com> writes:

> [-cc Bill, +cc Zhen-Hua, Eric, Tom, Jerry]
>
> Hi Joerg,
>
> I was looking at Zhen-Hua's recent patches, trying to figure out if I
> need to do anything with them.  Resetting devices in the old kernel
> seems like a non-starter.  Resetting devices in the new kernel, ...,
> well, maybe.  It seems ugly, and it seems like the sort of problem
> that IOMMUs are designed to solve.  Anyway, I found this old
> discussion that I didn't quite understand:

For context here is the kexec on panic design, and what I know from
previous rounds of similar conversations.

The way kexec on panic aka kdump is designed to work is that the
recovery kernel lives in a piece of memory reserved at boot time and
known not to be in use by any driver (because we never ever use it for
DMA).  If DMA's continue from any source the old kernel may be a little
more corrupted but our currently running kernel should not.

Device drivers that we use in the recovery kernel are required to be
able to initialize their devices from an arbitrary state or fail to
initialize their devices.

We have discussed things on various occassions but IOMMUs all have their
own individual idiosynchrousies and came late to the party so that it
is hard to generalize.

The reserved region is generally low enough in memory that simply
not using IOMMUs works.

The major challenge with initializing an IOMMU would be that there are
potentially devices whose driver is not loaded in the recover kernel
with on-going DMA sessions (perhaps a NIC in response to network
packet).

Which essentially means that if you are going to use an IOMMU slot in a
recovery kernel you have to either know that IOMMU slot was reserved for
the recovery kernel (what has always felt like the easiest way to me).
Or you have to know everything that could target that IOMMU slot has
been reset or has it's driver loaded.

I have always thought the simplist and easiest solution would be to
reserve a few IOMMU slots for the kexec on panic kernel.  But if folks
can find other ways to guarantee that an on-going DMA isn't targeting
an IOMMU slot (such as resetting everything downstream from that
IOMMU slot) more power to you.

> On Wed, Jul 2, 2014 at 7:32 AM, Joerg Roedel <joro@8bytes.org> wrote:
>> On Wed, Apr 30, 2014 at 11:49:33AM +0100, David Woodhouse wrote:
>
>>> After the last round of this patchset, we discussed a potential
>>> improvement where you point every virtual bus address at the *same*
>>> physical scratch page.
>>
>> That is a solution to prevent the in-flight DMA failures. But what
>> happens when there is some in-flight DMA to a disk to write some inodes
>> or a new superblock. Then this scratch address-space may cause
>> filesystem corruption at worst.
>
> This in-flight DMA is from a device programmed by the old kernel, and
> it would be reading data from the old kernel's buffers.  I think
> you're suggesting that we might want that DMA read to complete so the
> device can update filesystem metadata?
>
> I don't really understand that argument.  Don't we usually want to
> stop any data from escaping the machine after a crash, on the theory
> that the old kernel is crashing because something is catastrophically
> wrong and we may have already corrupted things in memory?  If so,
> allowing this old DMA to complete is just as likely to make things
> worse as to make them better.
>
> Without kdump, we likely would reboot through the BIOS and the device
> would get reset and the DMA would never happen at all.  So if we made
> the dump kernel program the IOMMU to prevent the DMA, that seems like
> a similar situation.
>
>> So with this in mind I would prefer initially taking over the
>> page-tables from the old kernel before the device drivers re-initialize
>> the devices.
>
> This makes the dump kernel more dependent on data from the old kernel,
> which we obviously want to avoid when possible.
>
> I didn't find the previous discussion where pointing every virtual bus
> address at the same physical scratch page was proposed.  Why was that
> better than programming the IOMMU to reject every DMA?
>
> Bjorn

Eric

