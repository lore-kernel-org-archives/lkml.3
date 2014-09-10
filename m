Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaIJOxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:53:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaIJOxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:53:50 -0400
Date: Wed, 10 Sep 2014 22:53:34 +0800
From: Baoquan He <bhe@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Deutschmann <whissi@whissi.de>, Dave Young <dyoung@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, WANG Chao <chaowang@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] kaslr: check user's config too when handle
 relocations
Message-ID: <20140910145334.GB1887@dhcp-17-102.nay.redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
 <1409926097-2101-2-git-send-email-bhe@redhat.com>
 <CAGXu5j+ih52B+ert+OF2wtm07wZDS_u6S0H7bwfycpJuBXT2_w@mail.gmail.com>
 <20140909062416.GA2872@dhcp-16-105.nay.redhat.com>
 <CAGXu5jJ+oUGszKUX12cqJ9RQBXCzO9j9e-5gBDmTH-cF80=xNg@mail.gmail.com>
 <20140909192813.GB9435@redhat.com>
 <20140910072115.GA31685@dhcp-16-116.nay.redhat.com>
 <20140910143019.GA3771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910143019.GA3771@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/14 at 10:30am, Vivek Goyal wrote:
> On Wed, Sep 10, 2014 at 03:21:15PM +0800, Baoquan He wrote:
 
 
> > In fact, I think below checking will be clearer and works too.
> > 
> > 
> > static void handle_relocations(void *output, unsigned long output_len)
> > {
> > 
> > ...
> > 
> > #if CONFIG_X86_64
> > 
> > or
> > 
> > #if CONFIG_RANDOMIZE_BASE
> > #ifdef CONFIG_HIBERNATION
> > 	if (!cmdline_find_option_bool("kaslr")) {
> >                debug_putstr("No relocation needed... ");
> >                return;
> > 	}
> > #else
> > 	if (cmdline_find_option_bool("nokaslr")) {
> >                debug_putstr("No relocation needed... ");
> >                return;
> > 	}
> > #endif
> 
> > 
> > 	if (max_addr > CONFIG_RANDOMIZE_BASE_MAX_OFFSET) {
> >                 debug_putstr("Random addr is not allowed. No relocation
> > needed... \n");
> >                 return;
> 
> Hi Bao,
> 
> I dont think that this is required or this is correct. kaslr will not
> choose a physical location which is beyond CONFIG_RANDOMIZE_BASE_MAX_OFFSET,
> So not sure what will this do.
> 
> Just the other check of output_orig == output should fix issue for us.
> 
> If one is not passing nokaslr in case of kexec, and kernel is loaded
> high (say 64G), I think kaslr will automatically move kernel below 1G
> and handle_relocations() should succeed.

No, if kernel is loaded high (say 64G), the random kernel location
choosing won't happen. Since in process_e820_entry() it only accepts the
memory region which is above output, plus the
CONFIG_RANDOMIZE_BASE_MAX_OFFSET checking, any kenrel loaded high above
1G will not get a new random kernel location. So it's safe in this case.

> 
> In case of kdump we will have to pass nokaslr, as we don't want kernel
> to move as it could stomp over other things we have loaded.

For kdump and kexec nokaslr is unnecessary. As you know we always
call add_buffer with buf_end as 1, this will cause kernel loaded at the
top of available memory. E.g on my pc with 16G memory, kexec kernel will
be put nearby 16G, so no random location choosing happen as I said in
above. For kdump, if reserved memory is at 500M~700M, then kernel will
be put nearby 700M, the random location choosing also never happen.

In fact, for some cases I need change kexec-tools user app code, to make
kernel be put from down to top.

> 
> So I would suggest that test and repost the other patch with proper changelog
> and that might be sufficient for now. Only other thing we will need is
> Kees's patch for avoiding setup data regions in kaslr.

Anyway, it's great people think the "output_orig=output" is good and can
solve our problems, and it does change less code. I can repost that one
with your suggestion that put some comments above that.

Thanks for your comments and suggstion.

> 
> Thanks
> Vivek
