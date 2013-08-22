Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab3HVUTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:19:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab3HVUTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:19:02 -0400
Date: Thu, 22 Aug 2013 16:19:00 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] dm ioctl: allow change device target type to error
Message-ID: <20130822201900.GB22556@redhat.com>
References: <5214CC25.1070307@oracle.com>
 <alpine.LRH.2.02.1308211041180.10797@file01.intranet.prod.int.rdu2.redhat.com>
 <52157C6E.6080406@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52157C6E.6080406@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21 2013 at 10:50pm -0400,
Joe Jin <joe.jin@oracle.com> wrote:

> Mikulas, thanks for you suggestions, I create new patch, can you please help
> review?
> 
> Subject: dm: add map_rq define for error
> 
> commit a5664da "dm ioctl: make bio or request based device type immutable"
> prevented "dmsetup wape_table" change the target type to "error" for there
> is not map_rq for error target type.
> 
> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> ---
>  drivers/md/dm-target.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
> index 37ba5db..b690910 100644
> --- a/drivers/md/dm-target.c
> +++ b/drivers/md/dm-target.c
> @@ -131,12 +131,19 @@ static int io_err_map(struct dm_target *tt, struct bio *bio)
>  	return -EIO;
>  }
>  
> +static int io_err_map_rq(struct dm_target *ti, struct request *clone,
> +			 union map_info *map_context)
> +{
> +	return -EIO;
> +}
> +
>  static struct target_type error_target = {
>  	.name = "error",
>  	.version = {1, 1, 0},
>  	.ctr  = io_err_ctr,
>  	.dtr  = io_err_dtr,
>  	.map  = io_err_map,
> +	.map_rq = io_err_map_rq,
>  };
>  
>  int __init dm_target_init(void)
> -- 
> 1.8.3.1

Hi Joe,

Unfortunately this isn't going to work properly.  Mikulas suggested a
new "error-rq" target.

I do like the idea of a single error target that is hybrid (supports
both bio-based and request-based) but the DM core would need to be
updated to support this.

Specifically, we'd need to check if the device (and active table) is
already bio-based or request-based and select the appropriate type.  If
it is a new device, default to selecting bio-based.

There are some wrappers and other logic thoughout DM core that will need
auditing too.

Mike
