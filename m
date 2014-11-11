Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaKKNEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:04:40 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:44726 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaKKNEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:04:38 -0500
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Christian Riesch <christian.riesch@omicron.at>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>,
        Peter Hurley <peter@hurleysoftware.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2] n_tty: Fix read_buf race condition, increment read_head after pushing data
References: <a2e126c9-3001-4255-91c9-6311b54988c5@EXC02-ATKLA.omicron.at>
Date: Tue, 11 Nov 2014 13:04:28 +0000
In-Reply-To: <a2e126c9-3001-4255-91c9-6311b54988c5@EXC02-ATKLA.omicron.at>
	(Christian Riesch's message of "Tue, 11 Nov 2014 08:24:17 +0100")
Message-ID: <yw1x4mu5j3c3.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Riesch <christian.riesch@omicron.at> writes:

> Commit 19e2ad6a09f0c06dbca19c98e5f4584269d913dd ("n_tty: Remove overflow
> tests from receive_buf() path") moved the increment of read_head into
> the arguments list of read_buf_addr(). Function calls represent a
> sequence point in C. Therefore read_head is incremented before the
> character c is placed in the buffer. Since the circular read buffer is
> a lock-less design since commit 6d76bd2618535c581f1673047b8341fd291abc67
> ("n_tty: Make N_TTY ldisc receive path lockless"), this creates a race
> condition that leads to communication errors.
>
> This patch modifies the code to increment read_head _after_ the data
> is placed in the buffer and thus fixes the race for non-SMP machines.
> To fix the problem for SMP machines, memory barriers must be added in
> a separate patch.
>
> Signed-off-by: Christian Riesch <christian.riesch@omicron.at>
> Cc: <stable@vger.kernel.org>
> ---
>
> This is version 2 of the patch in [1].
>
> Changes for v2:
> - Rewrote commit message. Since I did not know better, I blamed the compiler
>   in v1, but actually the code was wrong. See the discussion in [1].
> - Removed memory barriers. For non-SMP machines they are not required,
>   for SMP machines more brainwork and discussions are needed.
>
> Best regards,
> Christian
>
> [1] https://lkml.org/lkml/2014/11/6/216
>
>  drivers/tty/n_tty.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index 2e900a9..b09f326 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -321,7 +321,9 @@ static void n_tty_check_unthrottle(struct tty_struct *tty)
>
>  static inline void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
>  {
> -	*read_buf_addr(ldata, ldata->read_head++) = c;
> +	*read_buf_addr(ldata, ldata->read_head) = c;
> +	/* increment read_head _after_ placing the character in the buffer */
> +	ldata->read_head++;
>  }

Is that comment really necessary?

-- 
Måns Rullgård
mans@mansr.com
