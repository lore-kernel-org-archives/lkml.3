Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab3GQFSC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 01:18:02 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:44665 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3GQFSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 01:18:00 -0400
Message-ID: <51E628F8.6030303@gmail.com>
Date: Wed, 17 Jul 2013 13:17:44 +0800
From: Sam Ben <sam.bennn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Nate Zimmer <nzimmer@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Rob Landley <rob@landley.net>,
        Mike Travis <travis@sgi.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC 0/4] Transparent on-demand struct page initialization embedded
 in the buddy allocator
References: <1373594635-131067-1-git-send-email-holt@sgi.com>
In-Reply-To: <1373594635-131067-1-git-send-email-holt@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 10:03 AM, Robin Holt wrote:
> We have been working on this since we returned from shutdown and have
> something to discuss now.  We restricted ourselves to 2MiB initialization
> to keep the patch set a little smaller and more clear.
>
> First, I think I want to propose getting rid of the page flag.  If I knew
> of a concrete way to determine that the page has not been initialized,
> this patch series would look different.  If there is no definitive
> way to determine that the struct page has been initialized aside from
> checking the entire page struct is zero, then I think I would suggest
> we change the page flag to indicate the page has been initialized.
>
> The heart of the problem as I see it comes from expand().  We nearly
> always see a first reference to a struct page which is in the middle
> of the 2MiB region.  Due to that access, the unlikely() check that was
> originally proposed really ends up referencing a different page entirely.
> We actually did not introduce an unlikely and refactor the patches to
> make that unlikely inside a static inline function.  Also, given the
> strong warning at the head of expand(), we did not feel experienced
> enough to refactor it to make things always reference the 2MiB page
> first.
>
> With this patch, we did boot a 16TiB machine.  Without the patches,
> the v3.10 kernel with the same configuration took 407 seconds for
> free_all_bootmem.  With the patches and operating on 2MiB pages instead
> of 1GiB, it took 26 seconds so performance was improved.  I have no feel
> for how the 1GiB chunk size will perform.

How to test how much time spend on free_all_bootmem?

>
> I am on vacation for the next three days so I am sorry in advance for
> my infrequent or non-existant responses.
>
>
> Signed-off-by: Robin Holt <holt@sgi.com>
> Signed-off-by: Nate Zimmer <nzimmer@sgi.com>
> To: "H. Peter Anvin" <hpa@zytor.com>
> To: Ingo Molnar <mingo@kernel.org>
> Cc: Linux Kernel <linux-kernel@vger.kernel.org>
> Cc: Linux MM <linux-mm@kvack.org>
> Cc: Rob Landley <rob@landley.net>
> Cc: Mike Travis <travis@sgi.com>
> Cc: Daniel J Blueman <daniel@numascale-asia.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

