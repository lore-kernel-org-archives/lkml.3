Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaFFSDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:03:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaFFSC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:02:59 -0400
Date: Fri, 6 Jun 2014 14:02:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140606180214.GH1526@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
 <20140605111535.GB16642@pd.tnic>
 <20140605201732.GF14083@redhat.com>
 <20140606021133.GB27257@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140606021133.GB27257@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 04:11:33AM +0200, Borislav Petkov wrote:

[..]
> > > Might wanna define pr_fmt when using the pr_* things fo the first time
> > > in this file.
> > 
> > Hmm....
> > 
> > I see that printk.h already provides a definition is pr_fmt is not
> > defined. So that means I shouldn't have to define pr_fmt() before I
> > use pr_*?
> > 
> > #ifndef pr_fmt
> > #define pr_fmt(fmt) fmt
> > #endif
> 
> Yep, so you could do
> 
> #undef pr_fmt
> #define pr_fmt(fmt) "kexec: "
> 
> or you can do the standard
> 
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> Just look around the tree for examples, there's plenty.

Ok, got it. So this will allow me to prefix subsystem name to the
message. It is a good idea. Will do.

[..]
> > > > +	kbuf->buf_align = max(buf_align, PAGE_SIZE);
> > > > +	kbuf->buf_min = buf_min;
> > > > +	kbuf->buf_max = buf_max;
> > > > +	kbuf->top_down = top_down;
> > > > +
> > > > +	/* Walk the RAM ranges and allocate a suitable range for the buffer */
> > > > +	walk_system_ram_res(0, -1, kbuf, walk_ram_range_callback);
> > > > +
> > > > +	/*
> > > > +	 * If range could be found successfully, it would have incremented
> > > > +	 * the nr_segments value.
> > > > +	 */
> > > > +	new_nr_segments = image->nr_segments;
> > > > +
> > > > +	/* A suitable memory range could not be found for buffer */
> > > > +	if (new_nr_segments == nr_segments)
> > > > +		return -EADDRNOTAVAIL;
> > > 
> > > Right, why don't you check walk_system_ram_res's retval? If it is != 0,
> > > i.e. walk_ram_range_callback gives a 1 on "success", you can drop this
> > > way of checking whether finding a new range succeeded.
> > 
> > In last version when I had ELF header support, I was checking for return
> > code 1 at one place and you had not liked that.
> > 
> > Anyway, I am thinking that problem here is that walk_* variants use
> > return code of called function to decide whether to continue looping
> > or not. I think these are two independent activities.  Pass a boolean
> > to called function which should be set to false if callee wants to
> > stop the loop.
> > 
> > That way, callee can pass both errors and success without having to
> > worry about loop. And callee can return 0 to represent success and
> > negative error code to represent error.
> 
> But why? It should be caller's responsibility to deal with the errors.
> If it encounters one, it either decides to stop looping or not.

There are cases where there is no error still looping needs to stop.

For example, suppose you are looking for a memory range of size x
between addresses A and B. Assume there are 20 SYSTEM RAM entries
between address A and B. Now lets say you found a suitable range
in the first call itself. In that called function is successful
and does not want to be called again.

But upon returning success "0", walk_* functions will continue to
call with rest of the overlapping ranges. Its seems pretty wasteful
and called function will have to keep a state which tells that
ignore further calls.

Now to stop looping we can't return error as that return code
will be passed to the function who called walk_* and that function
will think that error happened. But actually it did not.

So to me it makes sense to decouple two things. Error code and when
to stop looping.

> 
> In any case, you don't need a second bool arg to pass around.

I would say give it some more thought. It makes dealing with errors
easy.

> 
> If you want to make it more explicit, you could do
> 
> #define RES_OK		0
> #define RES_ERR		1
> #define RES_STOP	2

You are saying that called back function should return this to walk_*
functions? But then we lose the actual error code which should be
passed to parent function which actually called walk_* function.

Thanks
Vivek
