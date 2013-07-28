Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3G1IM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 04:12:56 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753238Ab3G1IMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 04:12:53 -0400
Message-ID: <51F4D275.70009@nod.at>
Date: Sun, 28 Jul 2013 10:12:37 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gabriel de Perthuis <g2p.code@gmail.com>
CC: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: Accept /dev/fd/* uml block devices
References: <1374938607-25747-1-git-send-email-g2p.code@gmail.com>
In-Reply-To: <1374938607-25747-1-git-send-email-g2p.code@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.07.2013 17:23, schrieb Gabriel de Perthuis:
> Useful for
> * limiting privileges
> * opening block devices O_EXCL

So, the goal of this patch is to allow passing a file descriptor
number as block device instead of a file?

I assume you have already a wrapper around UML which exec()'s it such that
it can reuse a fd?

> Use dup to work around the fact /proc/self/fd
> can't be opened after dropping privileges.
> This proc behaviour doesn't match TLPI and might be a bug.
> 
> Qemu has a slightly more complex fdset approach
> that provides fds with different access permissions.

I really don't like that you patch os_open_file(), this is a
generic function.

What about this one?
Allow ubda= (and all other UML block device kernel parameters) to
accept arguments like file:/foo/bar and fd:N.
Where N is a number and file: is default such that we do not break
old kernels.

Thanks,
//richard

> Signed-off-by: Gabriel de Perthuis <g2p.code@gmail.com>
> ---
>  arch/um/os-Linux/file.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/um/os-Linux/file.c b/arch/um/os-Linux/file.c
> index c17bd6f..cee65ba 100644
> --- a/arch/um/os-Linux/file.c
> +++ b/arch/um/os-Linux/file.c
> @@ -169,11 +169,11 @@ int os_file_mode(const char *file, struct openflags *mode_out)
>  	return err;
>  }
>  
>  int os_open_file(const char *file, struct openflags flags, int mode)
>  {
> -	int fd, err, f = 0;
> +	int fd, fd0, err, f = 0;
>  
>  	if (flags.r && flags.w)
>  		f = O_RDWR;
>  	else if (flags.r)
>  		f = O_RDONLY;
> @@ -190,11 +190,15 @@ int os_open_file(const char *file, struct openflags flags, int mode)
>  	if (flags.e)
>  		f |= O_EXCL;
>  	if (flags.a)
>  		f |= O_APPEND;
>  
> -	fd = open64(file, f, mode);
> +	if (!strncmp(file, "/dev/fd/", 8)
> +	    && sscanf(file, "/dev/fd/%d", &fd0) == 1)
> +		fd = dup(fd0);
> +	else
> +		fd = open64(file, f, mode);
>  	if (fd < 0)
>  		return -errno;
>  
>  	if (flags.cl && fcntl(fd, F_SETFD, 1)) {
>  		err = -errno;
> @@ -280,11 +284,11 @@ int os_file_size(const char *file, unsigned long long *size_out)
>  
>  	if (S_ISBLK(buf.ust_mode)) {
>  		int fd;
>  		long blocks;
>  
> -		fd = open(file, O_RDONLY, 0);
> +		fd = os_open_file(file, of_read(OPENFLAGS()), 0);
>  		if (fd < 0) {
>  			err = -errno;
>  			printk(UM_KERN_ERR "Couldn't open \"%s\", "
>  			       "errno = %d\n", file, errno);
>  			return err;
> 

