Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaKXH2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 02:28:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbaKXH2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 02:28:21 -0500
Message-ID: <5472DE06.6000307@redhat.com>
Date: Mon, 24 Nov 2014 15:28:06 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dexuan Cui <decui@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        KY Srinivasan <kys@microsoft.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH] hv: hv_balloon: avoid memory leak on alloc_error of 2MB
 memory block
References: <1416808575-5383-1-git-send-email-decui@microsoft.com> <5472BF95.2000904@redhat.com> <F792CF86EFE20D4AB8064279AFBA51C613E5FD2B@HKNPRD3002MB017.064d.mgd.msft.net>
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C613E5FD2B@HKNPRD3002MB017.064d.mgd.msft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 02:08 PM, Dexuan Cui wrote:
>> -----Original Message-----
>> > From: Jason Wang [mailto:jasowang@redhat.com]
>> > Sent: Monday, November 24, 2014 13:18 PM
>> > To: Dexuan Cui; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
>> > driverdev-devel@linuxdriverproject.org; olaf@aepfle.de;
>> > apw@canonical.com; KY Srinivasan
>> > Cc: Haiyang Zhang
>> > Subject: Re: [PATCH] hv: hv_balloon: avoid memory leak on alloc_error of
>> > 2MB memory block
>> > 
>> > On 11/24/2014 01:56 PM, Dexuan Cui wrote:
>>> > > If num_ballooned is not 0, we shouldn't neglect the already-allocated
>> > 2MB
>>> > > memory block(s).
>>> > >
>>> > > Cc: K. Y. Srinivasan <kys@microsoft.com>
>>> > > Cc: <stable@vger.kernel.org>
>>> > > Signed-off-by: Dexuan Cui <decui@microsoft.com>
>>> > > ---
>>> > >  drivers/hv/hv_balloon.c | 4 +++-
>>> > >  1 file changed, 3 insertions(+), 1 deletion(-)
>>> > >
>>> > > diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
>>> > > index 5e90c5d..cba2d3b 100644
>>> > > --- a/drivers/hv/hv_balloon.c
>>> > > +++ b/drivers/hv/hv_balloon.c
>>> > > @@ -1091,6 +1091,8 @@ static void balloon_up(struct work_struct
>> > *dummy)
>>> > >  	bool done = false;
>>> > >  	int i;
>>> > >
>>> > > +	/* The host does balloon_up in 2MB. */
>>> > > +	WARN_ON(num_pages % PAGES_IN_2M != 0);
>>> > >
>>> > >  	/*
>>> > >  	 * We will attempt 2M allocations. However, if we fail to
>>> > > @@ -1111,7 +1113,7 @@ static void balloon_up(struct work_struct
>> > *dummy)
>>> > >  						bl_resp, alloc_unit,
>>> > >  						 &alloc_error);
>>> > >
>>> > > -		if ((alloc_error) && (alloc_unit != 1)) {
>>> > > +		if (alloc_error && (alloc_unit != 1) && num_ballooned == 0)
>> > {
>>> > >  			alloc_unit = 1;
>>> > >  			continue;
>>> > >  		}
>> > 
>> > Before the change, we may retry the 4K allocation when part or all 2M
>> > allocations were failed. This makes sense when memory is fragmented. But
> Yes, but all the partially-allocated 2MB memory blocks are lost(mem leak).
>
>> > after the change, if part of 2M allocation were failed, we won't retry
>> > 4K allocation. Is this expected?
> Hi Jason,
> The patch doesn't break the "try 2MB first; then try 4K" logic:
>
> With the change, we'll retry the 2MB allocation in the next iteration of the
> same while (!done) loop -- we expect this retry will cause
> "alloc_error && (alloc_unit != 1) && num_ballooned == 0" to be true,
> so we'll later try 4K allocation, as we did before.

If I read the code correctly, if part of 2M allocation fails.
alloc_balloon_pages() will have a non zero return value with alloc_error
set. Then it will match the following check:

                if ((alloc_error) || (num_ballooned == num_pages))
{               

which will set done to true. So there's no second iteration of while
(!done) loop?

Probably you need something like:

if ((alloc_unit != 1) && (num_ballooned == 0)) {
    alloc_unit = 1;
    continue;
}

if ((alloc_unit == 1) || (num_ballooned = num_pages)) {
    ...
}

