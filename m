Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080Ab3CHAUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 19:20:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759872Ab3CHAUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 19:20:54 -0500
Date: Thu, 7 Mar 2013 19:20:44 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: fasync_remove_entry oops
Message-ID: <20130308002044.GA18640@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
 <20130307213819.GB19543@redhat.com>
 <CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
 <20130307220333.GA31039@redhat.com>
 <20130307223610.GA2494@redhat.com>
 <20130307231442.GA4806@redhat.com>
 <CA+55aFxDYcfxKO_h7ZTrs7o2+i=EjKxBtpeZWASQ75PVK7cJOA@mail.gmail.com>
 <20130307235409.GA8729@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307235409.GA8729@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 06:54:09PM -0500, Dave Jones wrote:
 > On Thu, Mar 07, 2013 at 03:46:24PM -0800, Linus Torvalds wrote:
 >  > On Thu, Mar 7, 2013 at 3:14 PM, Dave Jones <davej@redhat.com> wrote:
 >  > > And.. More fun with pipes.
 >  > >         for (fp = fapp; (fa = *fp) != NULL; fp = &fa->fa_next) {
 >  > >     1650:       49 8b 06                mov    (%r14),%rax
 >  > >
 >  > > So we got to fasync_remove_entry with a NULL fa struct.
 >  > >
 >  > > Can we just add more NULL checks here, or does that need to happen
 >  > > at a higher level ?
 >  > 
 >  > I think you'll find that it's not fapp that was NULL.
 > 
 > yeah, brainfart
 > 
 >  > The caller was
 >  > pipe_rdwr_fasync -> fasync_helper, and pipe_rdwr_fasync always passes
 >  > in
 >  > 
 >  >     &pipe->fasync_readers
 >  > 
 >  > (and writers) so it looks like it is pipe that was NULL. Really odd.
 >  > How did the open of the pipe succeed with a NULL i_pipe? We do have
 >  > i_pipe == NULL, but that should happen only with a not-yet-opened
 >  > pipe, or after the last close.
 >  > 
 >  > In neither case should you have that pipe_rdwr_fasync() call.
 >  > 
 >  > The fact that this happens for a delayed __fput() makes me think it
 >  > was never a successful open to begin with, but how did the FASYNC flag
 >  > get set in that case? Do we actually allow it in the open flags..
 >  > Hmm..
 >  > 
 >  > So if we need new NULL pointer checks, I think they'd need to be
 >  > something like the attached patch.
 >  
 > I'll give it a shot. Can't be any worse than what we have already.

I seem to be hitting the first pipe related oops a few times..
(Subject: pipe_release oops 3-4 mails upthread)

I don't know yet if that's just preventing me from getting to test the
pipe_rdwr_fasync path, but I haven't hit it since applying that patch.

	Dave 

