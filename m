Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbaJUONP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:13:15 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:59694 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884AbaJUONL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:13:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, viro@zeniv.linux.org.uk,
        John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        Linux API <linux-api@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Anup Patel <anup.patel@linaro.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the kernel
Date: Tue, 21 Oct 2014 16:12:24 +0200
Message-ID: <4227199.e5u61J7jtX@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141021103622.GB23161@amd>
References: <20141016124741.GA3832@kroah.com> <20141016231221.GA13592@kroah.com> <20141021103622.GB23161@amd>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QTPHnJR2EbY1dwereMuwPhO/rwknS0oqnOid/iSy2Bs
 SdA4YxP1WqggG3ejnNgquylywHdbFgHQKZ/sR4pu3jTE4WJwfd
 ayC0GZBBVJywzBUk6ShcgcDzGnnKzpiZI4T4pmCEE7b7JIKE4l
 eb1j9oFkZb01wzLIc9SBAkJKihCti1qQz//JPuzvhY0gfr7ZTI
 r9NlWrYcjf68oOafttiOMGg/h6p17uDrGcLpZta+xDjaiGm+vn
 yCmNGGzmBRsuFm7cdF04Yi/qYTHLFDHl8nAA605tVSTARbLMbo
 GZr2A2FZDkkdXzeNp2pvAlP0ukjdoOfrked5rqv4PQ6QV9Pdf8
 OwlsMSKtAtUxaG5gQDzQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 October 2014 12:36:22 Pavel Machek wrote:
> On Fri 2014-10-17 01:12:21, Greg Kroah-Hartman wrote:
> > On Thu, Oct 16, 2014 at 10:09:04AM -0700, John Stultz wrote:
> > > On Thu, Oct 16, 2014 at 5:47 AM, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> > > Are the Android guys comfortable with the ABI stability rules they'll
> > > now face?
> > 
> > Just because something is in staging, doesn't mean you don't have to
> > follow the same ABI stability rules as the rest of the kernel.  If a
> > change had happened to this code that broke userspace in the past, I
> > would have reverted it.  So this should not be anything different from
> > what has been happening inthe past.
> 
> Actually, there's big difference.
> 
> If Al Viro changes core filesystem in a way that breaks
> staging/binder, binder is broken, and if it can't be fixed... well it
> can't be fixed.
> 
> If Al Viro changes core filesystem in a way that breaks
> drivers/binder, Al's change is going to be reverted.

One might have argued that we'd have to do that already, but the reasons
for doing that with binder in the main kernel are certainly stronger.

> It is really hard to review without API documentation. Normally, API
> documentation is required for stuff like this.
> 
> For example: does it add new files in /proc?
> 
> Given that it is stable, can we get rid of binder_debug() and
> especially BINDER_DEBUG_ENTRY stuff?

Good point. We require documentation for every single sysfs attribute
that gets added to a driver (some escape the review, but that doesn't
change the rule), so we should not make an exception for a new procfs
file here.

> Checkpatch warns about 98 too long lines. Some of them could be fixed
> easily.

I don't think this should be an argument.

> This looks scary:
> 
>                         trace_binder_transaction_fd(t, fp->handle,
>                         target_fd);
> 			                binder_debug(BINDER_DEBUG_TRANSACTION,
>                                      "        fd %d -> %d\n",
>                         fp->handle, target_fd);
>                         /* TODO: fput? */
>                         fp->handle = target_fd;
> 			        } break;
> 
> Could binder_transcation() be split to smaller functions according to
> CodingStyle? 17 goto targets at the end of function are not exactly
> easy to read.
> 
> ginder_thread_read/write also needs splitting.

Yes, in principle, but this is still a detail that would mainly serve
to simplify review. The problem is more the lack of review and
documentation of the API.

> binder_ioctl_write_read: just use direct return, no need to goto out
> if it just returns.

details, and a lot of people actually like the style used there.

>    proc->user_buffer_offset = vma->vm_start - (uintptr_t)proc->buffer;
>         mutex_unlock(&binder_mmap_lock);
> 
> #ifdef CONFIG_CPU_CACHE_VIPT
>         if (cache_is_vipt_aliasing()) {
>                 while (CACHE_COLOUR((vma->vm_start ^
>         (uint32_t)proc->buffer))) {
> 
> Should this be (uintptr_t)?

It should probably call an architecture specific helper.

	Arnd
