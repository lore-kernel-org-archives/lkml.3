Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab3EBIBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:01:15 -0400
Received: from mx3.valvesoftware.com ([208.64.203.145]:54977 "EHLO
	mx3.valvesoftware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab3EBIBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:01:13 -0400
X-Greylist: delayed 1263 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 May 2013 04:01:13 EDT
Message-ID: <518217D1.3070008@valvesoftware.com>
Date: Thu, 2 May 2013 00:37:53 -0700
From: "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <sonnyrao@chromium.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm,x86: limit 32 bit kernel to 12GB memory
References: <517B1153.8000401@valvesoftware.com> <517B2FB4.30605@redhat.com> <20130427024248.GA1229@cmpxchg.org> <517EEBD1.503@valvesoftware.com> <CA+55aFxcq44JsrrR5KKuT=DZQHCfOE3KHQrcD215T+deYesW2g@mail.gmail.com> <517F14D1.3070307@redhat.com> <20130502013426.GC9583@home.goodmis.org> <20130501224604.21ebc42a@annuminas.surriel.com>
In-Reply-To: <20130501224604.21ebc42a@annuminas.surriel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: 86b76815-e903-4403-b95d-5abb05264373
X-Mlf-Version: 7.3.6.7163
X-Mlf-UniqueId: o201305020740090007138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>

On 05/01/2013 07:46 PM, Rik van Riel wrote:
> On Wed, 1 May 2013 21:34:26 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Mon, Apr 29, 2013 at 08:48:17PM -0400, Rik van Riel wrote:
>>>
>>> It could also print out a friendly message, to
>>> inform the user they should upgrade to a 64 bit
>>> kernel to enjoy the use of all of their memory.
>>
>> Oh, oh, oh!!! Can we use my message:
>>
>>    http://lwn.net/Articles/501769/
>>
>> OK, maybe it's not so friendly ;-)
>
> Here's a somewhat friendlier one. Printing out the total amount of
> memory in the system may give them some extra motivation to upgrade
> to a 64 bit kernel :)
>
> ---8<----
> Subject: mm,x86: limit 32 bit kernel to 12GB memory
>
> Running 32 bit kernels on very large memory systems is a recipe
> for disaster, due to fundamental architectural limits in both
> Linux and the hardware. Moreover, all modern hardware with large
> memory supports 64 bits.
>
> However, many users continue using 32 bit kernels, and end up
> encountering stability and performance problems as a result.
>
> It may be better to save those people the frustration of stability
> issues by limiting memory on a 32 bit kernel to 12GB (about the upper
> limit that still works right), and printing a friendly reminder that
> they really should be using a 64 bit kernel.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>   arch/x86/include/asm/setup.h |  1 +
>   arch/x86/mm/init_32.c        | 11 +++++++++++
>   2 files changed, 12 insertions(+)
>
> diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
> index b7bf350..79de6bf 100644
> --- a/arch/x86/include/asm/setup.h
> +++ b/arch/x86/include/asm/setup.h
> @@ -14,6 +14,7 @@
>    */
>   #define MAXMEM_PFN	PFN_DOWN(MAXMEM)
>   #define MAX_NONPAE_PFN	(1 << 20)
> +#define MAX_PAE_PFN	(3 << 20)
>
>   #endif /* __i386__ */
>
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 3ac7e31..e35b3f5 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -600,6 +600,12 @@ static void __init lowmem_pfn_init(void)
>
>   #define MSG_HIGHMEM_TRIMMED \
>   	"Warning: only 4GB will be used. Use a HIGHMEM64G enabled kernel!\n"
> +
> +#define MSG_HIGHMEM_INSANE \
> +	"Warning: 32 bit kernels on large memory systems have problems.\n" \
> +	"Limiting memory to 12GB for system stability.\n" \
> +	"Use a 64 bit kernel to access all %lu MB of memory.\n"
> +
>   /*
>    * We have more RAM than fits into lowmem - we try to put it into
>    * highmem, also taking the highmem=x boot parameter into account:
> @@ -634,6 +640,11 @@ static void __init highmem_pfn_init(void)
>   		max_pfn = MAX_NONPAE_PFN;
>   		printk(KERN_WARNING MSG_HIGHMEM_TRIMMED);
>   	}
> +#else /* !CONFIG_HIGHMEM64G */
> +	if (max_pfn > MAX_PAE_PFN) {
> +		printk(KERN_WARNING MSG_HIGHMEM_INSANE, max_pfn>>8);
> +		max_pfn = MAX_PFN;
> +	}
>   #endif /* !CONFIG_HIGHMEM64G */
>   #endif /* !CONFIG_HIGHMEM */
>   }
>

