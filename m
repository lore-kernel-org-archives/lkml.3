Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaLCR3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:29:22 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52275 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaLCR3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:29:20 -0500
From: Rob Ward <robert.ward114@googlemail.com>
X-Google-Original-From: Rob Ward <rob@rob-thinkpad>
Date: Wed, 3 Dec 2014 17:29:06 +0000 (GMT)
To: Arnd Bergmann <arnd@arndb.de>
cc: Rob Ward <robert.ward114@googlemail.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: char: mem: Make /dev/mem an optional device
In-Reply-To: <89216621.RaKMSXnzQp@wuerfel>
Message-ID: <alpine.DEB.2.10.1412031659170.7838@rob-thinkpad>
References: <alpine.DEB.2.10.1412030818030.7838@rob-thinkpad> <89216621.RaKMSXnzQp@wuerfel>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wed, 3 Dec 2014, Arnd Bergmann wrote:

> On Wednesday 03 December 2014 08:21:04 Rob Ward wrote:
> > From ecd3ac31f6be2372d2beac0cc4831e74aeae75d2 Mon Sep 17 00:00:00 2001
> > From: Rob Ward <robert.ward114@googlemail.com>
> > Date: Wed, 5 Nov 2014 19:13:53 +0000
> > Subject: [PATCH] drivers: char: mem: Make /dev/mem an optional device
> 
> Please leave out these headers from the email. If you use git-send-email,
> it will work the right way, but for regular email clients you need to
> remove them manually.

Apologies, I will remove them in the future, I really should get 
send-email setup :-)
> 
> > Adds Kconfig option CONFIG_DEVMEM that allows the
> > /dev/mem device to be disabled.
> > 
> > Option defaults to /dev/mem enabled.
> 
> Please explain the purpose of this. Are you doing this for security
> considerations, for space savings, or something else.
> 
For the most part as a security consideration but a ever so 
slightly smaller kernel may be a nice side effect.

> If you are worried about security, please explain the possible attack
> vector you are closing, if you want to save kernel text size, show
> how much you save. It also helps to show a guess of what might break
> if you turn it off.

The aim is to reduce the potential methods of attack, having access
to areas of memory via a device makes reading potentially important data 
from RAM very easy, this change doesn't stop this but does make it harder 
than opening a file.

Additionally many platforms(MIPS as an example) do not restict the area of 
RAM that can be accessed at all. /dev/mem works out which areas of memory 
can be read using the range_is_allowed() function in drivers/char/mem.c 
which in turn determines what can be read based on the config option 
CONFIG_STRICT_DEVMEM which if enabled calls devmem_is_allowed implemented
per platform.

devmem_is_allowed is not implemented on several platforms and the
default is to allow access to any location.

x86 and others do have restrictions implemented, usually based on
areas that bios places data etc.

On "secure" and embedded systems access to /dev/mem is not usually needed
and so disabling it is a desirable feature and prevents the need to 
implement custom restrictions.
> 
> > Signed-off-by: Rob Ward <robert.ward114@googlemail.com>
> > ---
> >  drivers/char/Kconfig |  9 +++++++++
> >  drivers/char/mem.c   | 19 ++++++++++++++++++-
> >  2 files changed, 27 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> > index efefd12..a4af822 100644
> > --- a/drivers/char/Kconfig
> > +++ b/drivers/char/Kconfig
> > @@ -6,6 +6,15 @@ menu "Character devices"
> >  
> >  source "drivers/tty/Kconfig"
> >  
> > +config DEVMEM
> > +	bool "/dev/mem virtual device support"
> > +	default y
> 
> Should this be
> 
> 	bool "/dev/mem virtual device support" if EXPERT
> 
> so normal users don't accidentally disable it?

It would be nice to keep this in sync with DEVKMEM as
well, would a follow up change to implement this for kmem
to keep in sync be acceptable?

> 
> > diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> > index 524b707..feadc87 100644
> > --- a/drivers/char/mem.c
> > +++ b/drivers/char/mem.c
> > @@ -92,6 +92,7 @@ void __weak unxlate_dev_mem_ptr(unsigned long phys, void *addr)
> >   * This funcion reads the *physical* memory. The f_pos points directly to the
> >   * memory location.
> >   */
> > +#ifdef CONFIG_DEVMEM
> >  static ssize_t read_mem(struct file *file, char __user *buf,
> >  			size_t count, loff_t *ppos)
> >  {
> > @@ -216,6 +217,7 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
> >  	*ppos += written;
> >  	return written;
> >  }
> > +#endif
> 
> Adding a lot of #ifdef isn't nice, there are better ways to achieve the
> same.
> 
> > +#ifdef CONFIG_DEVMEM
> >  static const struct file_operations mem_fops = {
> >  	.llseek		= memory_lseek,
> >  	.read		= read_mem,
> > @@ -720,6 +734,7 @@ static const struct file_operations mem_fops = {
> >  	.open		= open_mem,
> >  	.get_unmapped_area = get_unmapped_area_mem,
> >  };
> > +#endif
> 
> I would probably do it here an leave the mem_fops visible to the compiler
> but mark it as '__maybe_unused' to avoid the warning when the reference below
> is not there.
>
I will modify to implement this way.
 
> >  #ifdef CONFIG_DEVKMEM
> >  static const struct file_operations kmem_fops = {
> > @@ -782,7 +797,9 @@ static const struct memdev {
> >  	const struct file_operations *fops;
> >  	struct backing_dev_info *dev_info;
> >  } devlist[] = {
> > +#ifdef CONFIG_DEVMEM
> >  	 [1] = { "mem", 0, &mem_fops, &directly_mappable_cdev_bdi },
> > +#endif
> >  #ifdef CONFIG_DEVKMEM
> >  	 [2] = { "kmem", 0, &kmem_fops, &directly_mappable_cdev_bdi },
> >  #endif
> 
> To keep it in sync with kmem, I would then submit a cleanup patch to
> do the same for kmem_fops and replace the other #ifdef lines with
> __maybe_unused statement for kmem_fops.
> 
Will do

> 	Arnd
> 

Cheers,

Rob Ward
