Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbaAWTYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:24:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138AbaAWTYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:24:35 -0500
Date: Thu, 23 Jan 2014 14:24:03 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, Peter Zijlstra <peterz@infradead.org>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] pid: change task_struct::pid to read-only
Message-ID: <20140123192403.GA5823@madcap2.tricolour.ca>
References: <8aa73d2b884439496f87d5f34c12ba9b4b40f7e5.1377032086.git.rgb@redhat.com>
 <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
 <20131217153611.GA18321@redhat.com>
 <20131217154004.GA21656@redhat.com>
 <20131220190157.GA1452@redhat.com>
 <20131220213348.GE7959@laptop.programming.kicks-ass.net>
 <20131222160321.GA17510@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131222160321.GA17510@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/22, Oleg Nesterov wrote:
> On 12/20, Peter Zijlstra wrote:
> >
> > On Fri, Dec 20, 2013 at 08:01:57PM +0100, Oleg Nesterov wrote:
> > > The only problem is that
> > >
> > > 	#define ASSIGN_CONST(l, r)      (*(typeof(r) *)&(l) = (r))
> > >
> > > obviously can't work in this case ;) We need something more clever.
> >
> > Hmm indeed, C++ has both the const_cast<>() thingy and the template
> > system is powerful enough to actually implement const_cast<>() inside
> > the language.
> 
> So, how about
> 
> 	#define CONST_CAST(type, lval)	\
> 		(*({					\
> 			(void)((type *)0 == &(lval));	\
> 			(type *)&(lval);		\
> 		}))					\
> 
> de_thread/copy_process can do
> 
> 	CONST_CAST(pid_t, tsk->pid) = leader->pid;
> 
> and if "type" is wrong we have a warning.

Cool.  This works very nicely.  Thanks for the ideas Oleg!

> Oleg.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
