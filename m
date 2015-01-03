Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbbACB3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 20:29:30 -0500
Received: from exprod6og110.obsmtp.com ([64.18.1.25]:36916 "EHLO
	exprod6og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbbACB32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 20:29:28 -0500
From: Patrick Farrell <paf@cray.com>
To: Ashley Pittman <apittman@ddn.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "HPDD-discuss@lists.01.org" <HPDD-discuss@ml01.01.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [HPDD-discuss] [PATCH] staging: lustre: lustre:	include:
	lustre_update.h: Fix for possible null pointer dereference
Thread-Topic: [HPDD-discuss] [PATCH] staging: lustre: lustre:	include:
	lustre_update.h: Fix for possible null pointer dereference
Thread-Index: AQHQJrVbvmEZX1F3fU+EOlvD8x6kPJytmv0Q
Date: Sat, 3 Jan 2015 01:29:20 +0000
Message-ID: <DB0C8A206669AC40B1C4E52A8584A6F6149D6DFE@CFWEX01.americas.cray.com>
References: <1419201831-13878-1-git-send-email-rickard_strandqvist@spectrumdigital.se>,<DF2D8745-9436-429C-BE08-555F745E9D11@ddn.com>
In-Reply-To: <DF2D8745-9436-429C-BE08-555F745E9D11@ddn.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.234.40]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ashley,

I sort of understand your larger point, but in this case, I think the purpose of the assert is much better served by the move Rickard is suggesting.  Otherwise only one of its conditions will ever trigger.  It's not that different to die on the assertion or from a null dereference, but I think it's marginally better to fail the assertion.  And it definitely doesn't make sense to have it there and never triggered, which it was before.

- Patrick
________________________________________
From: HPDD-discuss [hpdd-discuss-bounces@lists.01.org] on behalf of Ashley Pittman [apittman@ddn.com]
Sent: Friday, January 02, 2015 11:55 AM
To: Rickard Strandqvist
Cc: devel@driverdev.osuosl.org; HPDD-discuss@lists.01.org; Greg Kroah-Hartman; linux-kernel@vger.kernel.org
Subject: Re: [HPDD-discuss] [PATCH] staging: lustre: lustre:    include:        lustre_update.h: Fix for possible null pointer dereference

Rickard,

> On 21 Dec 2014, at 22:43, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
>
> The NULL check was done to late, and there it was a risk
> of a possible null pointer dereference.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
> drivers/staging/lustre/lustre/include/lustre_update.h |    4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/lustre/lustre/include/lustre_update.h b/drivers/staging/lustre/lustre/include/lustre_update.h
> index 84defce..00e1361 100644
> --- a/drivers/staging/lustre/lustre/include/lustre_update.h
> +++ b/drivers/staging/lustre/lustre/include/lustre_update.h
> @@ -165,12 +165,14 @@ static inline int update_get_reply_buf(struct update_reply *reply, void **buf,
>       int  result;
>
>       ptr = update_get_buf_internal(reply, index, &size);
> +
> +     LASSERT((ptr != NULL && size >= sizeof(int)));
> +
>       result = *(int *)ptr;
>
>       if (result < 0)
>               return result;
>
> -     LASSERT((ptr != NULL && size >= sizeof(int)));

This looks odd to me, LASSERT is essentially BUG_ON() so is used for checking logic bugs.  Moving LASSERT calls doesn’t seem the correct way of resolving a logic problem and if you’re doing static analysis it might be more productive to do it this with LASSERT disabled.

>       *buf = ptr + sizeof(int);
>       return size - sizeof(int);
> }
> --
> 1.7.10.4
>
> _______________________________________________
> HPDD-discuss mailing list
> HPDD-discuss@lists.01.org
> https://lists.01.org/mailman/listinfo/hpdd-discuss

_______________________________________________
HPDD-discuss mailing list
HPDD-discuss@lists.01.org
https://lists.01.org/mailman/listinfo/hpdd-discuss
