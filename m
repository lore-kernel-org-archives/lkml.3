Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab3KORdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 12:33:46 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40130 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3KORdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 12:33:43 -0500
MIME-Version: 1.0
In-Reply-To: <20131115140738.GB6637@redhat.com>
References: <20131113224503.GB25344@anatevka.fc.hp.com>
	<52840206.5020006@zytor.com>
	<20131113235708.GC25344@anatevka.fc.hp.com>
	<CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com>
	<20131114180455.GA32212@anatevka.fc.hp.com>
	<CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com>
	<20131115005049.GJ5116@anatevka.fc.hp.com>
	<20131115062417.GB9237@gmail.com>
	<CAE9FiQWzSTtW8N=0hoUe6iCSM-k64Mv97n0whAS0_vZ+psuOsg@mail.gmail.com>
	<5285C639.5040203@zytor.com>
	<20131115140738.GB6637@redhat.com>
Date: Fri, 15 Nov 2013 09:33:41 -0800
X-Google-Sender-Auth: iZqWy8I-Ls_SGf75ip9UKXzqzcY
Message-ID: <CAE9FiQUnw9Ujmdtq-AgC4VctQ=fZSBkzehoTbvw=aZeARL+pwA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Early use of boot service memory
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        jerry.hoemann@hp.com, Pekka Enberg <penberg@kernel.org>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "list@ebiederm.org:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "list@ebiederm.org:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 6:07 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Nov 14, 2013 at 10:59:05PM -0800, H. Peter Anvin wrote:
>> On 11/14/2013 10:55 PM, Yinghai Lu wrote:
>> >
>> > Why just asking distros to append ",high" in their installation
>> > program for 64bit by default?
>> >
>> [...]
>> >
>> > What is hpa's suggestion?
>> >
>>
>> Pretty much what you just said ;)
>
> I think crashkernel=X,high is not a good default choice for distros.
> Reserving memory high reserves 72MB (or more) low memory for swiotlb. We
> work hard to keep crashkernel memory amount low and currently reserve
> 128M by default. Now suddenly our total memory reservation will shoot
> to 200 MB if we choose ,high option. That's jump of more than 50%. It
> is not needed.

If the system support intel IOMMU, we only need to that 72M for SWIOTLB
or AMD workaround.
If the user really care that for intel iommu enable system, they could use
"crashkernel=0,low" to have that 72M back.

and that 72M is under 4G instead of 896M.

so reserve 72M is not better than reserve 128M?

>
> We can do dumping operation successfully in *less* reserved memory by
> reserving memory below 4G. And hence crashkernel=,high is not a good
> default.
>
> Instead, crashkernel=X is a good default if we are ready to change
> semantics a bit. If sufficient crashkernel memory is not available
> in low memory area, look for it above 4G. This incurs penalty of
> 72M *only* if it has to and not by default on most of the systems.
>
> And this should solve jerry's problem too on *latest* kernels. For
> older kernels, we don't have ,high support. So using that is not
> an option. (until and unless somebody is ready to backport everything
> needed to boot old kernel above 4G).

that problem looks not related.

I have one system with 6TiB memory, kdump does not work even
crashkernel=512M in legacy mode. ( it only work on system with
4.5TiB).
--- first kernel can reserve the 512M under 896M, second kernel will
OOM as it load driver for every pci devices...

So why would RH guys not spend some time on optimizing your kdump initrd
build scripts and only put dump device related driver in it?

Thanks

Yinghai
