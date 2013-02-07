Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab3BGPiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:38:11 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:50755 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758710Ab3BGPiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:38:07 -0500
Message-ID: <5113CA5A.8070307@suse.cz>
Date: Thu, 07 Feb 2013 16:38:02 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3 07/23] tty: Strengthen no-subsequent-use guarantee
 of tty_ldisc_halt()
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com> <1360095638-6624-1-git-send-email-peter@hurleysoftware.com> <1360095638-6624-8-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-8-git-send-email-peter@hurleysoftware.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 09:20 PM, Peter Hurley wrote:
> @@ -688,9 +702,9 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
>  	 *	parallel to the change and re-referencing the tty.
>  	 */
>  
> -	work = tty_ldisc_halt(tty);
> +	retval = tty_ldisc_halt(tty, &work, 5 * HZ);
>  	if (o_tty)
> -		o_work = tty_ldisc_halt(o_tty);
> +		tty_ldisc_halt(o_tty, &o_work, 0);

Zero in there will cause the other end's work not to be cancelled and
TTY_LDISC_HALTED unset if there are two or more readers on the slave,
right? So there should be something like:
if (timeout)
  retval = tty_ldisc_wait_idle(tty, timeout);
  ...

in tty_ldisc_halt.

-- 
js
suse labs
