Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab3FKSi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:38:27 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:48788 "HELO
	shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753181Ab3FKSiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:38:25 -0400
Date: Tue, 11 Jun 2013 13:38:25 -0500
From: vcaputo@gnugeneration.com
To: Andy Lutomirski <luto@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: Re: adopt(pid_t pid) syscall proposal [patch included]
Message-ID: <20130611183825.GK5638@shells.gnugeneration.com>
References: <20130611012304.GI5638@shells.gnugeneration.com> <51B754D6.6010606@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B754D6.6010606@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 09:48:22AM -0700, Andy Lutomirski wrote:
> On 06/10/2013 06:23 PM, vcaputo@gnugeneration.com wrote:
> >+			if (!uid_eq(cred->euid, tcred->suid) &&
> >+			    !uid_eq(cred->euid, tcred->uid)  &&
> >+			    !uid_eq(cred->uid,  tcred->suid) &&
> >+			    !uid_eq(cred->uid,  tcred->uid) &&
> >+			    !ns_capable(cred->user_ns, CAP_KILL)) {
> >+				ret = -EPERM;
> >+				goto out_unlock;
> >+			}
> >+
> 
> That check's far too permissive.

I suspected, but that's easily improved, I just wanted to get this out
there and see what people thought, start the discussion, as well as
get my use case functional.  Although I'm curious, what is your cause
for concern with the existing checks?

> 
> This sounds like it will break anything that uses wait and expects its 
> children to not be stolen out from under it.

This thought crossed my mind, and originally I intended to restrict
adoption to orphans who had become children of init.  It seemed like
more general use might be desirable so I left that out.  If this
really is a possibility worth preventing we could put that restriction
on it.  To the best of my knowledge, nothing informs init of its
becoming parent of an orphan, so we should be able to steal the orphan
back without harm.  This still enables the use case of screen/tmux
reattachment.

> 
> Also, you'll have problems with screen -x or the default tmux shareable 
> configuration.  It sounds like this is better done in userspace.

It just needs some determination of "session leader" applied to which
attach adopts the backend before invoking adopt(), that logic goes in
userspace.  I imagine the implementations of both screen and tmux
already have such determinations happening for other reasons.

Regards,
Vito Caputo
