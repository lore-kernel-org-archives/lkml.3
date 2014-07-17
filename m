Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbaGQAul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 20:50:41 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:39467 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbaGQAuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 20:50:39 -0400
MIME-Version: 1.0
In-Reply-To: <53C430EA.1060205@tilera.com>
References: <1405363782-6570-1-git-send-email-xerofoify@gmail.com>
	<1405364357.13661.15.camel@x220>
	<53C430EA.1060205@tilera.com>
Date: Wed, 16 Jul 2014 20:50:38 -0400
Message-ID: <CAPDOMVjKe8q23nCTwfygxE8dp5gzsNtL+m2e4ZzpCa+E6U_jYg@mail.gmail.com>
Subject: Re: [PATCH] title: no lookup_page for if statement
From: Nick Krause <xerofoify@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Johannes Weiner <hannes@cmpxchg.org>,
        mhocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        zlu <zlu@tilera.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 3:35 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> On 7/14/2014 2:59 PM, Paul Bolle wrote:
>>
>> On Mon, 2014-07-14 at 14:49 -0400, Nicholas Krause wrote:
>>>
>>> >This patch removes the if define statement for page_lookup in order
>>> >to remove a fix me of this not being defined as of yet.
>>> >
>>> >Signed-off-by: Nicholas Krause<xerofoify@gmail.com>
>
>
> Nicholas, you can't just enable this code; it will break the
> build, since there is no lookup_address() symbol on tile.
>
> I'd like to encourage you to look for more substantive kinds of
> changes to submit to LKML.  This one and the last one (adding some
> underscores to some obsolete symbols) both have ended up costing me
> some time to look at and figure out what's actually going on, but
> for no real value.  I suspect there may be "janitor" tasks that
> are more useful if you are looking for small starting points
> (Google for "linux kernel janitors").
>
> That said I'm going to go ahead and check in the following change
> which actually does work, now that my attention has been drawn here.
>
> diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
> index 6c0571216a9d..7e884001ca6a 100644
> --- a/arch/tile/mm/fault.c
> +++ b/arch/tile/mm/fault.c
> @@ -513,17 +513,14 @@ no_context:
>
>         bust_spinlocks(1);
>
> -       /* FIXME: no lookup_address() yet */
> -#ifdef SUPPORT_LOOKUP_ADDRESS
> -       if (fault_num == INT_ITLB_MISS) {
> -               pte_t *pte = lookup_address(address);
> +       if (fault_num == INT_ITLB_MISS && address >= PAGE_OFFSET) {
> +               pte_t *pte = virt_to_kpte(address);
>
> -               if (pte && pte_present(*pte) && !pte_exec_kernel(*pte))
> -                       pr_crit("kernel tried to execute"
> -                              " non-executable page - exploit attempt?"
> -                              " (uid: %d)\n", current->uid);
> +               if (pte && pte_present(*pte) && !pte_exec(*pte))
> +                       pr_crit("kernel tried to execute non-executable
> page"
> +                               " - exploit attempt? (uid: %d)\n",
> +                               from_kuid(&init_user_ns, current_uid()));
>         }
> -#endif
>         if (address < PAGE_SIZE)
>                 pr_alert("Unable to handle kernel NULL pointer
> dereference\n");
>         else
>
> --
> Chris Metcalf, Tilera Corp.
> http://www.tilera.com
>
Chris,
Understood I screwed up here. I am doing other changes with build and
warning errors. Plus some
fix me issues that are simple. I will double check my patches and the
code they are relating to more
carefully. I should have asked you before writing this patch:(.
Nick
