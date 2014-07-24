Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbaGXOra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:47:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:45215 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932583AbaGXOr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:47:29 -0400
Date: Thu, 24 Jul 2014 10:47:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: gregkh@linuxfoundation.org, john.stultz@linaro.org,
        paul.gortmaker@windriver.com, gang.chen.5i5j@gmail.com,
        yongjun_wei@trendmicro.com.cn, dan.carpenter@oracle.com,
        tomas.winkler@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: Change kzalloc to kcalloc
Message-ID: <20140724144725.GA32669@home.goodmis.org>
References: <1406156581-6052-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406156581-6052-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 07:03:01PM -0400, Nicholas Krause wrote:
> This changes the call to kzalloc to kcalloc in ion_dummy_driver
> for allocating the heap.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/staging/android/ion/ion_dummy_driver.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/android/ion/ion_dummy_driver.c b/drivers/staging/android/ion/ion_dummy_driver.c
> index 3a45e79..8883432 100644
> --- a/drivers/staging/android/ion/ion_dummy_driver.c
> +++ b/drivers/staging/android/ion/ion_dummy_driver.c
> @@ -67,9 +67,8 @@ static int __init ion_dummy_init(void)
>  {
>  	int i, err;
>  
> 	idev = ion_device_create(NULL);
> -	heaps = kzalloc(sizeof(struct ion_heap *) * dummy_ion_pdata.nr,
> -			GFP_KERNEL);
> +	heaps = kcalloc(*dummy_ion_pdata.nr , sizeof((struct ion_heap *) *dummy_ion_pdata.nr) , GFP_KERNEL);
>  	if (!heaps)
>  		return -ENOMEM;
>  

Hi Nick,

Look, I know you are really enthusiastic, and want to help out. I get it.
But this patch is proof that you are not yet ready to work on a complex
project such as the Linux kernel. Maybe you want to try something
a bit easier. Like, say, systemd?

First of all, there was really nothing wrong with this code in the first
place. It is fine to use kzalloc. But lets just say you want to convert
it to kcalloc. The proper answer would have been:

	heaps = kcalloc(dummy_ion_pdata.nr, sizeof(struct ion_heap *), GFP_KERNEL);

That's rather simple. Just look at the prototype of kcalloc():

void *kcalloc(size_t n, size_t size, gfp_t flags)

The three parameters are the number of elements, the size of each individual
element, and then finally the flags used on how to allocate that memory.
I have to say, you did get the flags part correct.

Now lets look at what you did. For the size you had:

  *dummy_ion_ptr.nr

Do you have any idea of what that is? You just dereferenced the count.
That is, you didn't use the count, but you used the memory that is at
some location from address 0 + dummy_ion_ptr.nr. Now this probably wont
compile. At least not on 64 bit boxes as that nr field is only 32 bits
and a pointer would need to be 64 bits. It could possibly compile on
32 bit boxes, but it would definitely give you a warning about that.

Now lets look at the second parameter you used.

  sizeof((struct ion_heap *) *dummy_ion_pdata.nr)

This one takes a bit of thinking about. I'm actually confused at what
you were even trying to do. What the compiler would try to do is to
break it up. First you again dereference the dummy_ion_pdata.nr with

   *dummy_ion_pdata.nr

And then you convert the answer to that into the type "struct ion_heap *"

   (struct ion_heap *) *dummy_ion_pdata.nr

Finally, you take the sizeof of that answer. As you converted the type
into "struct ion_heap *", I think it would give you the size of that
pointer, that is, if it would compile in the first place.

Congrats! that is actually what we want the second parameter to be!
Although I doubt that you meant to do it that way. No one would mean
to do it that way unless they had no idea of what they were doing.


Basically what this patch tells me is that you do not have enough basic
knowledge of the C language to be programming in the kernel. Maybe you
want to be a BIOS programmer?

My advice to you is to find another project (Gnome?) and work with them
until you have a strong concept of C coding and then, and only then,
come back to working on the kernel. Kernel development is no place for
novice programmers. Sorry, but that's true. It will only give you a
bad reputation, and nasty comments from the real kernel developers.

Cheers!

-- Steve

