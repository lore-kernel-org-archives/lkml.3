Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934807AbaGPR4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:56:11 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:23234 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752329AbaGPR4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:56:08 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18liZ/fhOOGIxdMBGV3MVWOmBAlzH4ZLNg=
X-DKIM: OpenDKIM Filter v2.0.1 titan 179B25AD2DF
Date: Wed, 16 Jul 2014 13:56:03 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Boaz Harrosh <openosd@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, pramod.gurav.etc@gmail.com,
        viro@zeniv.linux.org.uk, Markus Mayer <markus.mayer@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/direct-io.c: Fix compilation warning for
 uninitialized variables
Message-ID: <20140716175603.GD13108@titan.lakedaemon.net>
References: <1404452632-10912-1-git-send-email-pramod.gurav.etc@gmail.com>
 <20140713115022.GA6054@infradead.org>
 <53C6B199.2070606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53C6B199.2070606@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 08:08:41PM +0300, Boaz Harrosh wrote:
> On 07/13/2014 02:50 PM, Christoph Hellwig wrote:
> > pramod.gurav.etc@gmail.com wrote ...
> >> diff --git a/fs/direct-io.c b/fs/direct-io.c
> >> index 98040ba388ac..c0a9854d2bc7 100644
> >> --- a/fs/direct-io.c
> >> +++ b/fs/direct-io.c
> >> @@ -910,7 +910,8 @@ static int do_direct_IO(struct dio *dio, struct dio_submit *sdio,
> >>  
> >>  	while (sdio->block_in_file < sdio->final_block_in_request) {
> >>  		struct page *page;
> >> -		size_t from, to;
> >> +		size_t from = 0;
> >> +		size_t to = 0;
> >>  		page = dio_get_page(dio, sdio, &from, &to);
> >>  		if (IS_ERR(page)) {
> >>  			ret = PTR_ERR(page);
> > Looks good to me,
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > Al, can you pick this up?  It's the only warnings in many of my usual
> > kernel builds at the moment.
> > 
> <>
> 
> Paul Bolle <pebolle@tiscali.nl> wrote ...
> <>
> > @@ -911,11 +907,15 @@ static int do_direct_IO(struct dio *dio, struct dio_submit *sdio,
> >  	while (sdio->block_in_file < sdio->final_block_in_request) {
> >  		struct page *page;
> >  		size_t from, to;
> > -		page = dio_get_page(dio, sdio, &from, &to);
> > +
> > +		page = dio_get_page(dio, sdio);
> >  		if (IS_ERR(page)) {
> >  			ret = PTR_ERR(page);
> >  			goto out;
> >  		}
> > +		from = sdio->head ? 0 : sdio->from;
> > +		to = (sdio->head == sdio->tail - 1) ? sdio->to : PAGE_SIZE;
> > +		sdio->head++;
> >  
> >  		while (from < to) {
> >  			unsigned this_chunk_bytes;	/* # of bytes mapped */
> <>
> 
> This is the wrong fix. GCC is wrong here. As shown by Paul Bolle if
> you move the from / to set from dio_get_page() to here the warning goes away.

Actually, that was me.

> The minimal fix must use uninitialized_var() in this case. See patch below

I didn't know about uninitialized_var() when I wrote the patch.  As the
comment for it states:

/*
 * A trick to suppress uninitialized variable warning without generating
 * any code
 */


So,

> But I think the proper fix Is the one Paul Bolle <pebolle@tiscali.nl> sent (above)
> 
> 
> ----
> From: Boaz Harrosh <boaz@plexistor.com>
> Date: Wed, 16 Jul 2014 20:02:29 +0300
> Subject: [PATCH] do_direct_IO: Fix compiler warning
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> This fixes
> ../fs/direct-io.c: In function ‘do_blockdev_direct_IO’:
> ../fs/direct-io.c:1011:12: warning: ‘from’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>     u = (to - from) >> blkbits;
>             ^
> ../fs/direct-io.c:1011:12: warning: ‘to’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>     u = (to - from) >> blkbits;
> 
> I use: gcc version 4.8.3 20140624 (Red Hat 4.8.3-1)
> 
> GCC is wrong here so we should use the uninitialized_var() macro
> and not silence it with = 0;
> 
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.

> ---
>  fs/direct-io.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 98040ba..156e6f0 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -910,7 +910,8 @@ static int do_direct_IO(struct dio *dio, struct dio_submit *sdio,
>  
>  	while (sdio->block_in_file < sdio->final_block_in_request) {
>  		struct page *page;
> -		size_t from, to;
> +		size_t uninitialized_var(from), uninitialized_var(to);
> +
>  		page = dio_get_page(dio, sdio, &from, &to);
>  		if (IS_ERR(page)) {
>  			ret = PTR_ERR(page);
> -- 
> 1.9.3
> 
