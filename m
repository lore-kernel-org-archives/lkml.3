Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3IZQnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:43:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab3IZQnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:43:01 -0400
Date: Thu, 26 Sep 2013 18:36:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        codonell <codonell@redhat.com>, Eduard Benes <ebenes@redhat.com>,
        Karel Srot <ksrot@redhat.com>, Matt Newsome <mnewsome@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tty: Fix SIGTTOU not sent with tcflush()
Message-ID: <20130926163633.GA22849@redhat.com>
References: <52437AA2.5040907@hurleysoftware.com> <1380154395-4232-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380154395-4232-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Peter.

Well. I'am afraid my testing was wrong, because Karel reports
it fixes the problem...

But. I applied this patch to my 3.11 tree (last commit is bff157b3a)
which also has the additional patch (03e12617 "tty: disassociate_ctty()
sends the extra SIGCONT"), and

	TET_CONFIG=CFG TET_ROOT=.  ./T.tcflush 4

still fails... T.tcflush was compiled on another (Karel's) machine,
perhaps there is something in libc, I do not know.

So let me ask just in case, I assume the fix below doesn't depend on
other changes I could miss?

I'll retest after git-pull and report...

On 09/25, Peter Hurley wrote:
>
> Commit 'e7f3880cd9b98c5bf9391ae7acdec82b75403776'
>   tty: Fix recursive deadlock in tty_perform_flush()
> introduced a regression where tcflush() does not generate
> SIGTTOU for background process groups.
>
> Make sure ioctl(TCFLSH) calls tty_check_change() when
> invoked from the line discipline.
>
> Cc: stable@vger.kernel.org # v3.10+
> Reported-by: Oleg Nesterov <oleg@redhat.com>

Actually Reported-by: Karel Srot <ksrot@redhat.com>

my fault, forgot to mention this.

> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/tty_ioctl.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
> index 3500d41..088b4ca 100644
> --- a/drivers/tty/tty_ioctl.c
> +++ b/drivers/tty/tty_ioctl.c
> @@ -1201,6 +1201,9 @@ int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
>  		}
>  		return 0;
>  	case TCFLSH:
> +		retval = tty_check_change(tty);
> +		if (retval)
> +			return retval;
>  		return __tty_perform_flush(tty, arg);
>  	default:
>  		/* Try the mode commands */
> -- 
> 1.8.1.2
> 

