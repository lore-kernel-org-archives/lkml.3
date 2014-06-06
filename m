Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaFFCOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 22:14:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47165 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbaFFCOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 22:14:48 -0400
Date: Fri, 6 Jun 2014 04:11:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140606021133.GB27257@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
 <20140605111535.GB16642@pd.tnic>
 <20140605201732.GF14083@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140605201732.GF14083@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 04:17:32PM -0400, Vivek Goyal wrote:
> I think everything is already available in "struct kimage *image". So
> I don't have to pass all these separately. I think I will remove all
> these extra parameters and expect arch function to retrieve all that
> from "struct kimage *image".

Sounds good.

> I guess I was trying to make "struct kimage" mostly opaque to arch
> functions.

Sure, of course. The question is, is it really worth it at the price
of having a lot of args. And you're passing struct kimage to arch_*
functions anyway.

...

> It is obivious that we are freeing memory but what was not obivious to
> me that I already copied contents of these buffers in a seaparate memory
> region (segment), hence I am able to free it. So I would like to keep
> comment there.

Ok.

> > > +
> > > +	result = -ENOMEM;
> > > +	image->control_code_page = kimage_alloc_control_pages(image,
> > > +					   get_order(KEXEC_CONTROL_PAGE_SIZE));
> > > +	if (!image->control_code_page) {
> > > +		pr_err("Could not allocate control_code_buffer\n");
> > 
> > Might wanna define pr_fmt when using the pr_* things fo the first time
> > in this file.
> 
> Hmm....
> 
> I see that printk.h already provides a definition is pr_fmt is not
> defined. So that means I shouldn't have to define pr_fmt() before I
> use pr_*?
> 
> #ifndef pr_fmt
> #define pr_fmt(fmt) fmt
> #endif

Yep, so you could do

#undef pr_fmt
#define pr_fmt(fmt) "kexec: "

or you can do the standard

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Just look around the tree for examples, there's plenty.

> > This test looks strange: according to it, kexec_file_load has to always
> > be called with both KEXEC_FILE_UNLOAD and KEXEC_FILE_ON_CRASH set.
> 
> I think this test says that "flags" has to be some combination of valid
> flags and superset is in KEXEC_FILE_FLAGS.
> 
> So user can pass only KEXEC_FILE_ON_CRASH.
> flags = 0x00000002
> KEXEC_FILE_FLAGS = 0x0x00000003
> flags & KEXEC_FILE_FLAGS = 0x00000002 = flags.

Bah, ignore me - I got confused, sorry.

> > > +	kbuf->buf_align = max(buf_align, PAGE_SIZE);
> > > +	kbuf->buf_min = buf_min;
> > > +	kbuf->buf_max = buf_max;
> > > +	kbuf->top_down = top_down;
> > > +
> > > +	/* Walk the RAM ranges and allocate a suitable range for the buffer */
> > > +	walk_system_ram_res(0, -1, kbuf, walk_ram_range_callback);
> > > +
> > > +	/*
> > > +	 * If range could be found successfully, it would have incremented
> > > +	 * the nr_segments value.
> > > +	 */
> > > +	new_nr_segments = image->nr_segments;
> > > +
> > > +	/* A suitable memory range could not be found for buffer */
> > > +	if (new_nr_segments == nr_segments)
> > > +		return -EADDRNOTAVAIL;
> > 
> > Right, why don't you check walk_system_ram_res's retval? If it is != 0,
> > i.e. walk_ram_range_callback gives a 1 on "success", you can drop this
> > way of checking whether finding a new range succeeded.
> 
> In last version when I had ELF header support, I was checking for return
> code 1 at one place and you had not liked that.
> 
> Anyway, I am thinking that problem here is that walk_* variants use
> return code of called function to decide whether to continue looping
> or not. I think these are two independent activities.  Pass a boolean
> to called function which should be set to false if callee wants to
> stop the loop.
> 
> That way, callee can pass both errors and success without having to
> worry about loop. And callee can return 0 to represent success and
> negative error code to represent error.

But why? It should be caller's responsibility to deal with the errors.
If it encounters one, it either decides to stop looping or not.

In any case, you don't need a second bool arg to pass around.

If you want to make it more explicit, you could do

#define RES_OK		0
#define RES_ERR		1
#define RES_STOP	2

("RES" for resource :-)) and signal what to do by returning one of those
return values. Or?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
