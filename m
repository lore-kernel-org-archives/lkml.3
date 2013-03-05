Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3CEQaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 11:30:06 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:13073 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3CEQaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 11:30:05 -0500
X-IronPort-AV: E=Sophos;i="4.84,787,1355097600"; 
   d="scan'208";a="2197021"
Message-ID: <51361D89.2060604@citrix.com>
Date: Tue, 5 Mar 2013 17:30:01 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH RFC 04/12] xen-blkfront: pre-allocate pages for requests
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com> <1362047335-26402-5-git-send-email-roger.pau@citrix.com> <20130304193904.GI15386@phenom.dumpdata.com> <5135D149.1010805@citrix.com> <20130305141858.GG2589@phenom.dumpdata.com>
In-Reply-To: <20130305141858.GG2589@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/13 15:18, Konrad Rzeszutek Wilk wrote:
> On Tue, Mar 05, 2013 at 12:04:41PM +0100, Roger Pau Monné wrote:
>> On 04/03/13 20:39, Konrad Rzeszutek Wilk wrote:
>>> On Thu, Feb 28, 2013 at 11:28:47AM +0100, Roger Pau Monne wrote:
>>>> This prevents us from having to call alloc_page while we are preparing
>>>> the request. Since blkfront was calling alloc_page with a spinlock
>>>> held we used GFP_ATOMIC, which can fail if we are requesting a lot of
>>>> pages since it is using the emergency memory pools.
>>>>
>>>> Allocating all the pages at init prevents us from having to call
>>>> alloc_page, thus preventing possible failures.
>>>>
>>>> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
>>>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>>> Cc: xen-devel@lists.xen.org
>>>> ---
>>>>  drivers/block/xen-blkfront.c |  120 +++++++++++++++++++++++++++--------------
>>>>  1 files changed, 79 insertions(+), 41 deletions(-)
>>>>
>>>> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
>>>> index 2e39eaf..5ba6b87 100644
>>>> --- a/drivers/block/xen-blkfront.c
>>>> +++ b/drivers/block/xen-blkfront.c
>>>> @@ -165,6 +165,69 @@ static int add_id_to_freelist(struct blkfront_info *info,
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +static int fill_grant_buffer(struct blkfront_info *info, int num)
>>>> +{
>>>> +	struct page *granted_page;
>>>> +	struct grant *gnt_list_entry, *n;
>>>> +	int i = 0;
>>>> +
>>>> +	while(i < num) {
>>>> +		gnt_list_entry = kzalloc(sizeof(struct grant), GFP_NOIO);
>>>
>>> GFP_NORMAL ?
>>
>> drivers/block/xen-blkfront.c:175: error: ‘GFP_NORMAL’ undeclared (first
>> use in this function)
>>
>> Did you mean GFP_KERNEL? I think GFP_NOIO is more suitable, it can block
>> but no IO will be performed.
> 
> <sigh> I meant GFP_KERNEL. Sorry about the incorrect advice. The GFP_KERNEL
> is the more general purpose pool - is there a good reason to use _NOIO?
> This is after all during initialization when there is no IO using this driver.

We are already allocating memory using GFP_NOIO during setup
(setup_blkring and blkif_recover), the only reason I can think could be
helpful to use _NOIO is if the kernel tries to swap memory pages to the
disk, but if it has to swap pages to disk at this point we won't
probably be able to correctly setup blkfront anyway, either using _NOIO
or _KERNEL.

>>>>  
>>>>  	/* No more gnttab callback work. */
>>>>  	gnttab_cancel_free_callback(&info->callback);
>>>> @@ -1088,6 +1120,12 @@ again:
>>>>  		goto destroy_blkring;
>>>>  	}
>>>>  
>>>> +	/* Allocate memory for grants */
>>>> +	err = fill_grant_buffer(info, BLK_RING_SIZE *
>>>> +	                              BLKIF_MAX_SEGMENTS_PER_REQUEST);
>>>> +	if (err)
>>>> +		goto out;
>>>
>>> That looks to be in the wrong function - talk_to_blkback function is
>>> to talk to the blkback. Not do initialization type operations.
>>
>> Yes, I know it's not the best place to place it. It's here mainly
>> because that's the only function that gets called by both driver
>> initialization and resume.
>>
>> Last patch moves this to a more sensible place.
> 
> Lets make it part of this patch from the start. We still have two
> months of time before the next merge window opens - so we have
> time to make it nice and clean.

I'm moving this to blkfront_setup_indirect in a later patch (because
this function doesn't yet exist at this point), but I can put it in a
more suitable place in this patch.

