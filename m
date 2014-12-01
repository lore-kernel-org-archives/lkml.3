Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbaLAStf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 13:49:35 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:63011 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbaLAStc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 13:49:32 -0500
MIME-Version: 1.0
In-Reply-To: <1416901802-24211-39-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-1-git-send-email-jiang.liu@linux.intel.com> <1416901802-24211-39-git-send-email-jiang.liu@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 1 Dec 2014 11:49:11 -0700
Message-ID: <CAErSpo7-GezRLKe4hTAm=KhYHUw6zggi+4LRXjh25K-f+_hAng@mail.gmail.com>
Subject: Re: [Patch Part3 v4 38/38] x86, irq: Add kernel parameter
 vector_alloc to set CPU vector allocation policy
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Jonathan Corbet <corbet@lwn.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Daniel J Blueman <daniel@numascale.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 12:50 AM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> Parameter vector_alloc should be set to an integer with:
> bit 0:  enable allocating CPU vector from CPUs on device local node.
>         That's to allocate from cpumask_of_node(irq_data->node).
> bit 1: enable the default policy, which is to allocate from
>        apic->target_cpus().
>
> When allocating vectors, it tries all enabled policies from lower bit
> position to higher bit position.
>
> This option could be use to optimize interrupt distribution on large
> system such as NumaChip etc.

Why can't we figure this out automatically?  Having a kernel parameter
is a pain in the neck for users.

> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Cc: Daniel J Blueman <daniel@numascale.com>
> ---
>  Documentation/kernel-parameters.txt |    6 ++++++
>  arch/x86/kernel/apic/vector.c       |   11 +++++++++++
>  2 files changed, 17 insertions(+)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 4c81a860cc2b..a175c5016954 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -3709,6 +3709,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>         vector=         [IA-64,SMP]
>                         vector=percpu: enable percpu vector domain
>
> +       vector_alloc=   [x86,SMP]
> +                       vector_alloc=policy: policy is a bitmap, bit 0
> +                       for allocating CPU vector from CPUs on device local
> +                       node; bit 1 for the default policy to allocating from
> +                       apic->target_cpus(). All higher bits are reserved.
> +
>         video=          [FB] Frame buffer configuration
>                         See Documentation/fb/modedb.txt.
>
> diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
> index 16de8906ee1e..1158843551c7 100644
> --- a/arch/x86/kernel/apic/vector.c
> +++ b/arch/x86/kernel/apic/vector.c
> @@ -79,6 +79,17 @@ void set_vector_alloc_policy(unsigned int policy)
>                 x86_vector_alloc_policy = policy | X86_VECTOR_POL_CALLER;
>  }
>
> +static int __init apic_parse_vector_policy(char *str)
> +{
> +       int policy;
> +
> +       if (get_option(&str, &policy) == 1)
> +               set_vector_alloc_policy(policy);
> +
> +       return 1;
> +}
> +__setup("vector_alloc=", apic_parse_vector_policy);
> +
>  static struct apic_chip_data *alloc_apic_chip_data(int node)
>  {
>         struct apic_chip_data *data;
> --
> 1.7.10.4
>
