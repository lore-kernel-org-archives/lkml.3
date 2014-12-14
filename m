Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaLNIeG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 03:34:06 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:8713 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406AbaLNIeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 03:34:02 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvkGABNLjVQOAjMV/2dsb2JhbABagwZSWMVbhTc5AoEPFwEBAQEBfYQMAQEBBCcRHiIBEAgDFAMBCRYECwkDAgECAScWCAYNAQUCAognDsAekB8BAQEBAQEBAwEBAQEBAQEBGo9yB4QpAQSMLIUUhmyIGodiIoIwgU8rMAWCPgEBAQ
Message-ID: <548D4B75.8060808@internode.on.net>
Date: Sun, 14 Dec 2014 19:03:57 +1030
From: Arthur Marsh <arthur.marsh@internode.on.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Colin Watson <cjwatson@debian.org>, 772807@bugs.debian.org,
        linux-kernel@vger.kernel.org, vapier@gentoo.org,
        Joe Perches <joe@perches.com>
Subject: Re: Bug#772807: binfmt-support: unable to close /proc/sys/fs/binfmt_misc/register:
 Invalid argument
References: <20141211102439.5047.90481.reportbug@localhost> <20141211104408.GQ3020@riva.ucam.org> <548987B8.8090202@internode.on.net> <20141211124024.GR3020@riva.ucam.org> <548A6D63.3010106@internode.on.net> <20141212060138.GC22149@ZenIV.linux.org.uk>
In-Reply-To: <20141212060138.GC22149@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Al Viro wrote on 12/12/14 16:31:
> On Fri, Dec 12, 2014 at 02:51:55PM +1030, Arthur Marsh wrote:
>> 6b899c4e9a049dfca759d990bd53b14f81c3626c is the first bad commit
>> commit 6b899c4e9a049dfca759d990bd53b14f81c3626c
>> Author: Mike Frysinger <vapier@gentoo.org>
>> Date:   Wed Dec 10 15:52:08 2014 -0800
>>
>>      binfmt_misc: add comments & debug logs
>>
>>      When trying to develop a custom format handler, the errors returned all
>>      effectively get bucketed as EINVAL with no kernel messages.  The other
>>      errors (ENOMEM/EFAULT) are internal/obvious and basic.  Thus any time a
>>      bad handler is rejected, the developer has to walk the dense code and
>>      try to guess where it went wrong.  Needing to dive into kernel code is
>>      itself a fairly high barrier for a lot of people.
>>
>>      To improve this situation, let's deploy extensive pr_debug markers at
>>      logical parse points, and add comments to the dense parsing logic.  It
>>      let's you see exactly where the parsing aborts, the string the kernel
>>      received (useful when dealing with shell code), how it translated the
>>      buffers to binary data, and how it will apply the mask at runtime.
>
> ... and looking at it shows the following garbage:
>                  p[-1] = '\0';
> -               if (!e->magic[0])
> +               if (p == e->magic)
>
> That code makes no sense whatsoever - if p *was* equal to e->magic, the
> assignment before it would be obviously broken.  And a few lines later we
> have another chunk just like that.
>
> Moreover, if you look at further context, you'll see that it's
>                  e->magic = p;
>                  p = scanarg(p, del);
>                  if (!p)
>                          sod off
>                  p[-1] = '\0';
>                  if (p == e->magic)
> 			sod off
> Now, that condition could be true only if scanarg(p, del) would return p,
> right?  Let's take a look at scanarg():
> static char *scanarg(char *s, char del)
> {
>          char c;
>
>          while ((c = *s++) != del) {
>                  if (c == '\\' && *s == 'x') {
>                          s++;
>                          if (!isxdigit(*s++))
>                                  return NULL;
>                          if (!isxdigit(*s++))
>                                  return NULL;
>                  }
>          }
>          return s;
> }
>
> See that s++ in the loop condition?  There's no way in hell it would *not*
> increment s.  If we return non-NULL, we know that c was equal to del *and*
> c is equal to previous_value_of_s[0], i.e. s[-1].  IOW, return value points
> to the byte following the first instance of delimeter starting at the argument.
>
> And p[-1] = '\0' replaces delimiter with NUL.  IOW, the checks used to be
> correct.  And got buggered.
>
> Subject: unfuck fs/binfmt_misc.c
>
> Undo some of the "prettifying" braindamage.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 70789e1..a6b6697 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -5,6 +5,8 @@
>    *
>    * binfmt_misc detects binaries via a magic or filename extension and invokes
>    * a specified wrapper. See Documentation/binfmt_misc.txt for more details.
> + *
> + * Cetero censeo, checkpatch.pl esse delendam
>    */
>
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> @@ -131,9 +133,8 @@ static int load_misc_binary(struct linux_binprm *bprm)
>   	int retval;
>   	int fd_binary = -1;
>
> -	retval = -ENOEXEC;
>   	if (!enabled)
> -		goto ret;
> +		return -ENOEXEC;
>
>   	/* to keep locking time low, we copy the interpreter string */
>   	read_lock(&entries_lock);
> @@ -142,12 +143,12 @@ static int load_misc_binary(struct linux_binprm *bprm)
>   		strlcpy(iname, fmt->interpreter, BINPRM_BUF_SIZE);
>   	read_unlock(&entries_lock);
>   	if (!fmt)
> -		goto ret;
> +		return -ENOEXEC;
>
>   	if (!(fmt->flags & MISC_FMT_PRESERVE_ARGV0)) {
>   		retval = remove_arg_zero(bprm);
>   		if (retval)
> -			goto ret;
> +			return retval;
>   	}
>
>   	if (fmt->flags & MISC_FMT_OPEN_BINARY) {
> @@ -157,10 +158,9 @@ static int load_misc_binary(struct linux_binprm *bprm)
>   		 * to it
>   		 */
>   		fd_binary = get_unused_fd_flags(0);
> -		if (fd_binary < 0) {
> -			retval = fd_binary;
> -			goto ret;
> -		}
> +		if (fd_binary < 0)
> +			return fd_binary;
> +
>   		fd_install(fd_binary, bprm->file);
>
>   		/* if the binary is not readable than enforce mm->dumpable=0
> @@ -219,14 +219,13 @@ static int load_misc_binary(struct linux_binprm *bprm)
>   	if (retval < 0)
>   		goto error;
>
> -ret:
>   	return retval;
>   error:
>   	if (fd_binary > 0)
>   		sys_close(fd_binary);
>   	bprm->interp_flags = 0;
>   	bprm->interp_data = 0;
> -	goto ret;
> +	return retval;
>   }
>
>   /* Command parsers */
> @@ -250,6 +249,7 @@ static char *scanarg(char *s, char del)
>   				return NULL;
>   		}
>   	}
> +	s[-1] = '\0';
>   	return s;
>   }
>
> @@ -316,7 +316,7 @@ static Node *create_entry(const char __user *buffer, size_t count)
>
>   	memset(e, 0, sizeof(Node));
>   	if (copy_from_user(buf, buffer, count))
> -		goto efault;
> +		goto Efault;
>
>   	del = *p++;	/* delimeter */
>
> @@ -329,13 +329,13 @@ static Node *create_entry(const char __user *buffer, size_t count)
>   	e->name = p;
>   	p = strchr(p, del);
>   	if (!p)
> -		goto einval;
> +		goto Einval;
>   	*p++ = '\0';
>   	if (!e->name[0] ||
>   	    !strcmp(e->name, ".") ||
>   	    !strcmp(e->name, "..") ||
>   	    strchr(e->name, '/'))
> -		goto einval;
> +		goto Einval;
>
>   	pr_debug("register: name: {%s}\n", e->name);
>
> @@ -350,10 +350,10 @@ static Node *create_entry(const char __user *buffer, size_t count)
>   		e->flags = (1 << Enabled) | (1 << Magic);
>   		break;
>   	default:
> -		goto einval;
> +		goto Einval;
>   	}
>   	if (*p++ != del)
> -		goto einval;
> +		goto Einval;
>
>   	if (test_bit(Magic, &e->flags)) {
>   		/* Handle the 'M' (magic) format. */
> @@ -362,21 +362,20 @@ static Node *create_entry(const char __user *buffer, size_t count)
>   		/* Parse the 'offset' field. */
>   		s = strchr(p, del);
>   		if (!s)
> -			goto einval;
> +			goto Einval;
>   		*s++ = '\0';
>   		e->offset = simple_strtoul(p, &p, 10);
>   		if (*p++)
> -			goto einval;
> +			goto Einval;
>   		pr_debug("register: offset: %#x\n", e->offset);
>
>   		/* Parse the 'magic' field. */
>   		e->magic = p;
>   		p = scanarg(p, del);
>   		if (!p)
> -			goto einval;
> -		p[-1] = '\0';
> -		if (p == e->magic)
> -			goto einval;
> +			goto Einval;
> +		if (!e->magic[0])
> +			goto Einval;
>   		if (USE_DEBUG)
>   			print_hex_dump_bytes(
>   				KBUILD_MODNAME ": register: magic[raw]: ",
> @@ -386,9 +385,8 @@ static Node *create_entry(const char __user *buffer, size_t count)
>   		e->mask = p;
>   		p = scanarg(p, del);
>   		if (!p)
> -			goto einval;
> -		p[-1] = '\0';
> -		if (p == e->mask) {
> +			goto Einval;
> +		if (!e->mask[0]) {
>   			e->mask = NULL;
>   			pr_debug("register:  mask[raw]: none\n");
>   		} else if (USE_DEBUG)
> @@ -405,9 +403,9 @@ static Node *create_entry(const char __user *buffer, size_t count)
>   		e->size = string_unescape_inplace(e->magic, UNESCAPE_HEX);
>   		if (e->mask &&
>   		    string_unescape_inplace(e->mask, UNESCAPE_HEX) != e->size)
> -			goto einval;
> +			goto Einval;
>   		if (e->size + e->offset > BINPRM_BUF_SIZE)
> -			goto einval;
> +			goto Einval;
>   		pr_debug("register: magic/mask length: %i\n", e->size);
>   		if (USE_DEBUG) {
>   			print_hex_dump_bytes(
> @@ -439,23 +437,23 @@ static Node *create_entry(const char __user *buffer, size_t count)
>   		/* Skip the 'offset' field. */
>   		p = strchr(p, del);
>   		if (!p)
> -			goto einval;
> +			goto Einval;
>   		*p++ = '\0';
>
>   		/* Parse the 'magic' field. */
>   		e->magic = p;
>   		p = strchr(p, del);
>   		if (!p)
> -			goto einval;
> +			goto Einval;
>   		*p++ = '\0';
>   		if (!e->magic[0] || strchr(e->magic, '/'))
> -			goto einval;
> +			goto Einval;
>   		pr_debug("register: extension: {%s}\n", e->magic);
>
>   		/* Skip the 'mask' field. */
>   		p = strchr(p, del);
>   		if (!p)
> -			goto einval;
> +			goto Einval;
>   		*p++ = '\0';
>   	}
>
> @@ -463,10 +461,10 @@ static Node *create_entry(const char __user *buffer, size_t count)
>   	e->interpreter = p;
>   	p = strchr(p, del);
>   	if (!p)
> -		goto einval;
> +		goto Einval;
>   	*p++ = '\0';
>   	if (!e->interpreter[0])
> -		goto einval;
> +		goto Einval;
>   	pr_debug("register: interpreter: {%s}\n", e->interpreter);
>
>   	/* Parse the 'flags' field. */
> @@ -474,17 +472,17 @@ static Node *create_entry(const char __user *buffer, size_t count)
>   	if (*p == '\n')
>   		p++;
>   	if (p != buf + count)
> -		goto einval;
> +		goto Einval;
>
>   	return e;
>
>   out:
>   	return ERR_PTR(err);
>
> -efault:
> +Efault:
>   	kfree(e);
>   	return ERR_PTR(-EFAULT);
> -einval:
> +Einval:
>   	kfree(e);
>   	return ERR_PTR(-EINVAL);
>   }
>

I had to revert Al Viro's "Undo some of the "prettifying" braindamage." 
patch above to apply the execveat() commit below that is now in Linus' 
git head:

https://github.com/torvalds/linux/commit/51f39a1f0cea1cacf8c787f652f26dfee9611874

After that, trying to apply Al Viro's patch resulted in on failed hunk 
and code that wouldn't build.

binfmt_misc.c building but not working doesn't break things for me, but 
it would be good to get fixed.

Regards,

Arthur.

