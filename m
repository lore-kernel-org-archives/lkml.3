Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3KFXqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 18:46:22 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:34090 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3KFXqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 18:46:21 -0500
MIME-Version: 1.0
In-Reply-To: <20131106221012.GA13488@kroah.com>
References: <1383699252-8898-1-git-send-email-ohaugan@codeaurora.org>
	<20131106015645.GA28769@kroah.com>
	<CAPkvG_eEhArzS2feJ_8y6vKBjtd7bYUNwwWWz-MQHUDXCu_5hg@mail.gmail.com>
	<20131106221012.GA13488@kroah.com>
Date: Wed, 6 Nov 2013 15:46:19 -0800
Message-ID: <CAPkvG_fgkqeQt3=eqnDM7bWQXdeeybRULiU2MdNh5KF1KoeRFw@mail.gmail.com>
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Olav Haugan <ohaugan@codeaurora.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 2:10 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Nov 06, 2013 at 01:09:59PM -0800, Nitin Gupta wrote:
>> On Tue, Nov 5, 2013 at 5:56 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Tue, Nov 05, 2013 at 04:54:12PM -0800, Olav Haugan wrote:
>> >> zsmalloc encodes a handle using the page pfn and an object
>> >> index. On some hardware platforms the pfn could be 0 and this
>> >> causes the encoded handle to be 0 which is interpreted as an
>> >> allocation failure.
>> >
>> > What platforms specifically have this issue?
>> >
>> >>
>> >> To prevent this false error we ensure that the encoded handle
>> >> will not be 0 when allocation succeeds.
>> >>
>> >> Change-Id: Ifff930dcf254915b497aec5cb36f152a5e5365d6
>> >
>> > What is this?  What can anyone do with it?
>> >
>> >> Signed-off-by: Olav Haugan <ohaugan@codeaurora.org>
>> >> ---
>> >>  drivers/staging/zsmalloc/zsmalloc-main.c | 4 ++--
>> >>  1 file changed, 2 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
>> >> index 523b937..0e32c0f 100644
>> >> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
>> >> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
>> >> @@ -441,7 +441,7 @@ static void *obj_location_to_handle(struct page *page, unsigned long obj_idx)
>> >>       }
>> >>
>> >>       handle = page_to_pfn(page) << OBJ_INDEX_BITS;
>> >> -     handle |= (obj_idx & OBJ_INDEX_MASK);
>> >> +     handle |= ((obj_idx + 1) & OBJ_INDEX_MASK);
>> >>
>> >>       return (void *)handle;
>> >>  }
>> >> @@ -451,7 +451,7 @@ static void obj_handle_to_location(unsigned long handle, struct page **page,
>> >>                               unsigned long *obj_idx)
>> >>  {
>> >>       *page = pfn_to_page(handle >> OBJ_INDEX_BITS);
>> >> -     *obj_idx = handle & OBJ_INDEX_MASK;
>> >> +     *obj_idx = (handle & OBJ_INDEX_MASK) - 1;
>> >>  }
>> >
>> > I need someone who knows how to test this code to ack it before I can
>> > take it...
>> >
>> > And I thought we were deleting zsmalloc anyway, why are you using this
>> > code?  Isn't it no longer needed anymore?
>> >
>>
>> zsmalloc is used by zram. Other zstuff has switched to zbud since they
>> need to do shrinking which is much easier to implement with simpler
>> design of zbud. For zram, which is a block device, we don't do such
>> active shrinking, so uses zsmalloc which provides much better density.
>
> Ok, so what's the plan of getting these other things out of staging?

Other zstuff: zswap and zcache

1) zswap (along with zbud allocator, frontcache, cleancache) is
already out of staging into mm/ (by Seth Jennings)
2) zcache seems to have been completely removed (not sure if Dan ever
wants to reintroduce it)

> I'm getting really tired of them hanging around in here for many years
> now...
>

Minchan has tried many times to promote zram out of staging. This was
his most recent attempt:

https://lkml.org/lkml/2013/8/21/54

There he provided arguments for zram inclusion, how it can help in
situations where zswap can't and why generalizing /dev/ramX would
not be a great idea. So, cannot say why it wasn't picked up
for inclusion at that time.

> Should I just remove them if no one is working on getting them merged
> "properly"?
>

Please refer the mail thread (link above) and see Minchan's
justifications for zram.
If they don't sound convincing enough then please remove zram+zsmalloc
from staging.

Nitin
