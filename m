Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbaFPVPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:15:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880AbaFPVPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:15:42 -0400
Date: Mon, 16 Jun 2014 17:15:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/13] kexec-bzImage: Support for loading bzImage using
 64bit entry
Message-ID: <20140616211500.GA1870@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-12-git-send-email-vgoyal@redhat.com>
 <20140615163515.GA17016@pd.tnic>
 <20140616200608.GD4515@redhat.com>
 <20140616205743.GI8170@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616205743.GI8170@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 10:57:43PM +0200, Borislav Petkov wrote:
> On Mon, Jun 16, 2014 at 04:06:08PM -0400, Vivek Goyal wrote:
> > There can be more than one loader and the one which claims first
> > to recognize the image will get to load the image. So once 32 bit
> > loader support comes in, it might happen that we ask 64bit loader
> > first and it rejects the image and then we ask 32bit loader.
> 
> What does that have to do with anything??

Say down the line you support 3 types of kernel images. 64bit bzImage, 
32bit bzImage and ELF vmlinux. And there are 3 different loader
implementations in kernel. Now assume user us trying to load an ELF vmlinux
image. 

Generic code will call.

arch_kexec_kernel_image_probe {
        for (i = 0; i < nr_file_types; i++) {
                if (!kexec_file_type[i].probe)
                        continue;

                ret = kexec_file_type[i].probe(buf, buf_len);
                if (!ret) {
                        image->file_handler_idx = i;
                        return ret;
                }
        }
	return ret;
}

This code calls into very registered loader and if nobody is ready to
load the image it returns error. Say first bzImage64 and bzImage32 bit
loader are called. They both will reject the image and vmlinux loader
will accept it.

Do we want to show all the rejection messages from bzImage64 and bzImage32
loaders. It might be too verbose to show users that before vmlinux loader
accepted the image other loaders on this arches rejcted the image.

This is very similar to binary file loaing. Looks at load_elf_binary(). If
it does not find elf header it knows it is not an ELF binary and
returns error -ENOEXEC without outputing any messages.

> 
> > So these message are really debug message which tells why loader
> > is not accepting an image. It might not be image destined for that
> > loader at all.
> > 
> > pr_debug() allows being verbose if user wants to for debugging purposes.
> > You just have to make sure that CONFIG_DYNAMIC_DEBUG=y and enable verbosity
> > in individual file.
> > 
> > echo 'file kexec-bzimage.c +p' > /sys/kernel/debug/dynamic_debug/control
> 
> So people are supposed to enable dynamic_debug just so that they see
> *why* their image doesn't load.
> 
> Doesn't sound optimal to me.

This is one way of doing it. I can change it if you think that displaying
messages from all the loaders is fine.

> 
> > Same here. We will potentially be trying multiple loaders and if every
> > loader prints messages for rejection by default, it is too much of
> > info, IMO.
> 
> For max two loaders on one architecture? I don't think so. Now you're
> just arguing for the sake of it.

Well, we have 3 loaders in user space currently for x86_64. bzImage64,
bzImage32 and ELF vmlinux. So one would think that somebody might
go about implementing these in kernel space too.

> 
> > I like doing memory allocations early in the functions (as far as
> > possible) and error out if need be. If memory is available to begin
> > with for all the data structures needed by this function, it is kind
> > of pointless to do rest of the processing.
> 
> We're talking about memory for a single void * which is ridiculous. And
> I think simplifying the error paths is a much higher win than doing some
> minor allocation.

Ok, I will change it.

> 
> > Hmm..., If you feel strongly about it, I can make this change. I
> > thought I just made it easier to share the code between 32bit and
> > 64bit by this.
> 
> Someone later can do that - right now this code is 64-bit only as far as
> we're concerned and if it can be made to work on 32-bit, then people are
> free to do so.

Ok.

Thanks
Vivek
