Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaFMGjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:39:31 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:57440 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaFMGj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:39:29 -0400
MIME-Version: 1.0
X-Originating-IP: [5.35.52.78]
In-Reply-To: <5399ab3b.4825e00a.60fd.5014SMTPIN_ADDED_BROKEN@mx.google.com>
References: <CAOJe8K3fy3XFxDdVc3y1hiMAqUCPmkUhECU7j5TT=E=gxwBqHg@mail.gmail.com>
	<20140611173851.GA5556@MacBook-Pro.local>
	<CAOJe8K1TgTDX5=LdE9r6c0ami7TRa7zr0hL_uu6YpiWrsePAgQ@mail.gmail.com>
	<B01EB0A1-992B-49F4-93AE-71E4BA707795@arm.com>
	<CAOJe8K3LDhhPWbtdaWt23mY+2vnw5p05+eyk2D8fovOxC10cgA@mail.gmail.com>
	<CAOJe8K2WaJUP9_buwgKw89fxGe56mGP1Mn8rDUO9W48KZzmybA@mail.gmail.com>
	<5399ab3b.4825e00a.60fd.5014SMTPIN_ADDED_BROKEN@mx.google.com>
Date: Fri, 13 Jun 2014 10:39:28 +0400
Message-ID: <CAOJe8K0ZdW3XdTGKDmrd18R0MvN+7=rU-YQf26aFG512a-fTmA@mail.gmail.com>
Subject: Re: kmemleak: Unable to handle kernel paging request
From: Denis Kirjanov <kda@linux-powerpc.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/14, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> Hi Denis,
>
> On Thu, Jun 12, 2014 at 04:00:57PM +0400, Denis Kirjanov wrote:
>> On 6/12/14, Denis Kirjanov <kda@linux-powerpc.org> wrote:
>> > On 6/12/14, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> >> On 11 Jun 2014, at 21:04, Denis Kirjanov <kda@linux-powerpc.org>
>> >> wrote:
>> >>> On 6/11/14, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> >>>> On Wed, Jun 11, 2014 at 04:13:07PM +0400, Denis Kirjanov wrote:
>> >>>>> I got a trace while running 3.15.0-08556-gdfb9454:
>> >>>>>
>> >>>>> [  104.534026] Unable to handle kernel paging request for data at
>> >>>>> address 0xc00000007f000000
>> >>>>
>> >>>> Were there any kmemleak messages prior to this, like "kmemleak
>> >>>> disabled"? There could be a race when kmemleak is disabled because
>> >>>> of
>> >>>> some fatal (for kmemleak) error while the scanning is taking place
>> >>>> (which needs some more thinking to fix properly).
>> >>>
>> >>> No. I checked for the similar problem and didn't find anything
>> >>> relevant.
>> >>> I'll try to bisect it.
>> >>
>> >> Does this happen soon after boot? I guess it’s the first scan
>> >> (scheduled at around 1min after boot). Something seems to be telling
>> >> kmemleak that there is a valid memory block at 0xc00000007f000000.
>> >
>> > Yeah, it happens after a while with a booted system so that's the
>> > first kmemleak scan.
>> >
>> >> Catalin
>> >
>>
>> I've bisected to this commit: d4c54919ed86302094c0ca7d48a8cbd4ee753e92
>> "mm: add !pte_present() check on existing hugetlb_entry callbacks".
>> Reverting the commit fixes the issue
>
> Thanks for the effort of bisecting.
> I guess that this bug happens because pte_none() check was gone in this
> commit, so could you try to find if the following patch fixes the problem?
>
> I don't know much about kmemleak's details, so I'm not sure how this bug
> affected kmemleak. So I'm appreciated if you would add some comment in
> patch description.
>
> Thanks,
> Naoya Horiguchi
> ---
> Date: Thu, 12 Jun 2014 08:56:27 -0400
> Subject: [PATCH] mm: revoke pte_none() check for hugetlb_entry() callbacks
>
> commit: d4c54919ed86302094c0ca7d48a8cbd4ee753e92 ("mm: add !pte_present()
> check on existing hugetlb_entry callbacks") removed pte_none() check in
> a ->hugetlb_entry() handler, which unexpectedly broke other features like
> kmemleak.
>
> pte_none() check should be done in common page walk code, because we do
> so for normal pages and page walk might want to handle holes with
> ->pte_hole() callback.
>
> Reported-by: Denis Kirjanov <kda@linux-powerpc.org>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  mm/pagewalk.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 2beeabf502c5..0618657285c4 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -118,6 +118,13 @@ static int walk_hugetlb_range(struct vm_area_struct
> *vma,
>  	do {
>  		next = hugetlb_entry_end(h, addr, end);
>  		pte = huge_pte_offset(walk->mm, addr & hmask);
> +		if (huge_pte_none(*pte)) {
> +			if (walk->pte_hole)
> +				err = walk->pte_hole(addr, next, walk);
> +			if (err)
> +				break;
> +			continue;
> +		}
>  		if (pte && walk->hugetlb_entry)
>  			err = walk->hugetlb_entry(pte, hmask, addr, next, walk);
>  		if (err)
> --
> 1.9.3

Nope, Unfortunately I still see the issue :/

>
