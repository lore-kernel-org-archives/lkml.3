Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbaGDIzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:55:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301AbaGDIzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:55:19 -0400
Message-ID: <1404464117.1915.7.camel@linux-fkkt.site>
Subject: Re: [PATCH][RFC] USB: zerocopy support for usbfs
From: Oliver Neukum <oneukum@suse.de>
To: Stefan Klug <stefan.klug@baslerweb.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu
Date: Fri, 04 Jul 2014 10:55:17 +0200
In-Reply-To: <53B42B14.7010303@baslerweb.com>
References: <53B42B14.7010303@baslerweb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-02 at 17:53 +0200, Stefan Klug wrote:

> @@ -1471,6 +1526,57 @@ static int proc_do_submiturb(struct
> usb_dev_state 
> *ps, struct usbdevfs_urb *uurb
>               }
>               totlen -= u;
>           }
> +    } else if(num_pages) {
> +        pages = kmalloc(num_pages*sizeof(struct page*), GFP_KERNEL);
> +        if(!pages) {
> +            ret = -ENOMEM;
> +            goto error;
> +        }
> +
> +        //create the scatterlist
> +        as->urb->sg = kmalloc(num_pages * sizeof(struct
> scatterlist), 
> GFP_KERNEL);
> +        if (!as->urb->sg) {
> +            ret = -ENOMEM;
> +            goto error;
> +        }
> +
> +        ret = get_user_pages_fast((unsigned long)buf_aligned,
> +                   num_pages,
> +                   is_in,
> +                   pages);
> +
> +        if(ret < 0) {
> +            printk("get_user_pages failed %i\n", ret);
> +            goto error;
> +        }
> +
> +        //did we get all pages?
> +        if(ret < num_pages) {
> +            printk("get_user_pages didn't deliver all pages %i\n",
> ret);
> +            //free the pages and error out
> +            for(i=0; i<ret; i++) {
> +                page_cache_release(pages[i]);
> +            }
> +            ret = -ENOMEM;
> +            goto error;
> +        }
> +
> +        as->is_user_mem = 1;
> +        as->urb->num_sgs = num_pages;
> +        sg_init_table(as->urb->sg, as->urb->num_sgs);
> +
> +        totlen = uurb->buffer_length + buf_offset;
> +        o = buf_offset;
> +        for (i = 0; i < as->urb->num_sgs; i++) {
> +            u = (totlen > PAGE_SIZE) ? PAGE_SIZE : totlen;
> +            u-= o;
> +            sg_set_page(&as->urb->sg[i], pages[i], u, o);
> +            totlen -= u + o;
> +            o = 0;
> +        }
> +
> +        kfree(pages);
> +        pages = NULL;
>       } else if (uurb->buffer_length > 0) {
>           as->urb->transfer_buffer = kmalloc(uurb->buffer_length,
>                   GFP_KERNEL)


One more thing: Where do you check that the memory the user has passed
a pointer to is actually writable? It seems to me that for zerocopy you
must do the check before you submit the URB to the HCD.

	Regards
		Oliver


