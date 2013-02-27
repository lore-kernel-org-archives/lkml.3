Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746Ab3B0St7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:49:59 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:58474 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759862Ab3B0St6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:49:58 -0500
Date: Wed, 27 Feb 2013 10:49:53 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        arve@android.com, kernel-team@android.com,
        John Stultz <john.stultz@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v4] drivers/tty: Folding Android's keyreset driver in
 sysRQ
Message-ID: <20130227184953.GA28638@core.coreip.homeip.net>
References: <1352665488-13818-1-git-send-email-mathieu.poirier@linaro.org>
 <20121119072525.GA16730@core.coreip.homeip.net>
 <CAPM=9tw8mefcYTqELXFbZWZ44a--SNcPnRMAvMSGTiODzRpDhg@mail.gmail.com>
 <CA+55aFysXNSJMHL-rKZ_fvPP3t357zTC-6hyHmh=S6K-Qx0WbQ@mail.gmail.com>
 <512E4954.6060601@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512E4954.6060601@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 10:58:44AM -0700, Mathieu Poirier wrote:
> On 13-02-27 09:57 AM, Linus Torvalds wrote:
> > On Tue, Feb 26, 2013 at 11:33 PM, Dave Airlie <airlied@gmail.com> wrote:
> >>
> >> It looks to me like the weak bit isn't working so well
> >>
> >>         if (platform_sysrq_reset_seq) {
> >>                 for (i = 0; i < ARRAY_SIZE(sysrq_reset_seq); i++) {
> >>                         key = platform_sysrq_reset_seq[i];
> >>   6d:   66 8b 8c 00 00 00 00    mov    0x0(%eax,%eax,1),%cx
> >>   74:   00
> >>
> >> is around where it craps out.
> >> gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC)
> >> Fedora 18 machine.
> > 
> > Hmm. I would love to blame gcc, but no, I think the code is crap.
> > 
> > The whole 'platform_sysrq_reset_seq[]' thing is broken in current git,
> > and it apparently only happens to work by mistake for most of us.
> > 
> > Doing a "grep" for it shows all three uses:
> > 
> >    git grep platform_sysrq_reset_seq
> > 
> >   extern unsigned short platform_sysrq_reset_seq[] __weak;
> >   if (platform_sysrq_reset_seq) {
> >             key = platform_sysrq_reset_seq[i];
> > 
> > and the thing is, if it is declared as an array (not a pointer), then
> > I think it is perfectly understandable that when then testing the
> > *address* of that array, gcc just says "you're stupid, you're testing
> > something that cannot possibly be NULL, so I'll throw your idiotic
> > test away".
> > 
> > And gcc would be completely correct. That test is moronic. You just
> > said that platform_sysrq_reset_seq[] was an external array, there is
> > no way in hell that is NULL.
> > 
> > Now, if it was a _pointer_, that would be a different thing entirely.
> > A pointer can have a NULL value. A named array, not so much.
> > 
> > So I *think* the fix might be something like the attached. Totally
> > untested. It may compile, or it may not.
> > 
> >                 Linus
> > 
> 
> Your fix is compiling, running and yielding the correct results -
> apologies about that.
> 

Actually defining platform_sysrq_reset_seq as __weak array was my doing
so the fault is actually mine. Mathieu had a function there originally.

Thanks.

-- 
Dmitry
