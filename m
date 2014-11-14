Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbaKNAMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:12:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232AbaKNAMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:12:47 -0500
Date: Fri, 14 Nov 2014 01:11:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Drysdale <drysdale@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Meredydd Luff <meredydd@senatehouse.org>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>,
        Christoph Hellwig <hch@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: + syscallsx86-implement-execveat-system-call.patch added to
	-mm tree
Message-ID: <20141114001159.GA31545@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1479,7 +1489,26 @@ static int do_execve_common(struct filen
>
>  	bprm->file = file;
> -	bprm->filename = bprm->interp = filename->name;
> +	if (fd == AT_FDCWD || filename->name[0] == '/') {
> +		bprm->filename = filename->name;
> +	} else {
> +		if (filename->name[0] == '\0')
> +			pathbuf = kasprintf(GFP_TEMPORARY, "/dev/fd/%d", fd);
> +		else
> +			pathbuf = kasprintf(GFP_TEMPORARY, "/dev/fd/%d/%s",
> +					    fd, filename->name);
> +		if (!pathbuf) {
> +			retval = -ENOMEM;
> +			goto out_unmark;
> +		}
> +		/* Record that a name derived from an O_CLOEXEC fd will be
> +		 * inaccessible after exec. Relies on having exclusive access to
> +		 * current->files (due to unshare_files above). */
> +		if (close_on_exec(fd, current->files->fdt))
> +			bprm->interp_flags |= BINPRM_FLAGS_PATH_INACCESSIBLE;
> +		bprm->filename = pathbuf;
+	}
+	bprm->interp = bprm->filename;

Not sure I understand this patch, will try to read later...

Just once question, don't we leak pathbuf if exec() succeeds?

OTOH, if it fails,

>  out_free:
>  	free_bprm(bprm);
> +	kfree(pathbuf);

Is it correct if we fail after bprm_change_interp() was called? It seems
that we can free interp == pathbuf twice?

Oleg.

