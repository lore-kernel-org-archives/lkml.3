Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab3FTHoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:44:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:59234 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3FTHoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:44:05 -0400
Date: Thu, 20 Jun 2013 09:44:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/itimer.c: for return value, using -EINVAL instead
 of -EFAULT
In-Reply-To: <51C2ACB8.6050701@asianux.com>
Message-ID: <alpine.DEB.2.02.1306200936470.4013@ionos.tec.linutronix.de>
References: <51C29FBC.1090507@asianux.com> <alpine.DEB.2.02.1306200847300.4013@ionos.tec.linutronix.de> <51C2ACB8.6050701@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, Chen Gang wrote:
> On 06/20/2013 02:59 PM, Thomas Gleixner wrote:
> > On Thu, 20 Jun 2013, Chen Gang wrote:
> > 
> >> > For the system call getitimer(), if the parameter 'value' is NULL, need
> >> > return -EINVAL, not -EFAULT.
> > Care to explain why? Because you are feeling so?
> > 
> 
> I am not feeling so, the original implementation really just checks the parameter 'value', if it is invalid, need return, is it incorrect ??
> 
> 
> > I recommend reading the man page of getitimer:
> > 
> >  ERRORS
> >        EFAULT new_value, old_value, or curr_value is not valid a pointer.
> > 
> > And NULL is definitely NOT a valid pointer.
> > 
> > The Posix spec does not specify an explicit error value for this
> > syscall, but the general policy is:
> > 
> > [EFAULT]
> >     Bad address. The system detected an invalid address in attempting
> >     to use an argument of a call. The reliable detection of this error
> >     cannot be guaranteed, and when not detected may result in the
> >     generation of a signal, indicating an address violation, which is
> >     sent to the process.
> > 
> > And we made use of this, which is correct and makes sense.
> > 
> > Returning EINVAL makes no sense at all, because EINVAL _IS_ a
> > specified error code for this syscall:
> > 
> > [EINVAL]
> >         The which argument is not recognized.
> 
> That means we need not check the parameter 'value' out side of copy_to_user().

We could do that, but that makes no sense. If we can detect it before
copy_to_user() we can return the exactly same return value which we
would return via copy_to_user(). That avoids to take a trap and run
through the fixup code.

Thanks,

	tglx

_
