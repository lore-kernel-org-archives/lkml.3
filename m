Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab3BGQWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:22:25 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:45629 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754325Ab3BGQWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:22:23 -0500
Message-ID: <1360254134.4102.47.camel@thor.lan>
Subject: Re: [PATCH v3 07/23] tty: Strengthen no-subsequent-use guarantee of
 tty_ldisc_halt()
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>
Date: Thu, 07 Feb 2013 11:22:14 -0500
In-Reply-To: <5113CA5A.8070307@suse.cz>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
	 <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
	 <1360095638-6624-8-git-send-email-peter@hurleysoftware.com>
	 <5113CA5A.8070307@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 16:38 +0100, Jiri Slaby wrote:
> On 02/05/2013 09:20 PM, Peter Hurley wrote:
> > @@ -688,9 +702,9 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
> >  	 *	parallel to the change and re-referencing the tty.
> >  	 */
> >  
> > -	work = tty_ldisc_halt(tty);
> > +	retval = tty_ldisc_halt(tty, &work, 5 * HZ);
> >  	if (o_tty)
> > -		o_work = tty_ldisc_halt(o_tty);
> > +		tty_ldisc_halt(o_tty, &o_work, 0);
> 
> Zero in there will cause the other end's work not to be cancelled and
> TTY_LDISC_HALTED unset if there are two or more readers on the slave,
> right? So there should be something like:
> if (timeout)
>   retval = tty_ldisc_wait_idle(tty, timeout);
>   ...
> 
> in tty_ldisc_halt.

True.

Fixed in 08/23, where both ldiscs are halted simultaneously, forced to
wait for identical timeouts, and returns an error if either tty timed
out. From 08/23

in tty_ldisc_halt():

        retval = tty_ldisc_wait_idle(tty, timeout);
+       if (!retval && o_tty)
+               retval = tty_ldisc_wait_idle(o_tty, timeout);
        if (retval)
                return retval;

in tty_set_ldisc():

-       retval = tty_ldisc_halt(tty, &work, 5 * HZ);
-       if (o_tty)
-               tty_ldisc_halt(o_tty, &o_work, 0);
+       retval = tty_ldisc_halt(tty, o_tty, &work, &o_work, 5 * HZ);


If you'd prefer, I could put the 5 sec. wait in 7/23 as well, test the
error and so forth.

