Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3CCA4V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 19:56:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14364 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3CCA4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 19:56:20 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=tLUlnkoJZcZI9ocdGARlSQ==:17 a=c11ml42nfjYA:10 a=wom5GMh1gUkA:10 a=e0MqpSAjzYYA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=hBqU3vQJAAAA:8 a=5vcxqjp_onUA:10 a=1XWaLZrsAAAA:8 a=JqEG_dyiAAAA:8 a=CYTZQYrzOqamQ2FtDnEA:9 a=CjuIK1q_8ugA:10 a=UTB_XpHje0EA:10 a=tLUlnkoJZcZI9ocdGARlSQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 70.114.148.7
Date: Sat, 2 Mar 2013 18:57:00 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Kees Cook <keescook@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Brad Spengler <spender@grsecurity.net>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: user ns: arbitrary module loading
Message-ID: <20130303005700.GA32213@austin.hallyn.com>
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (keescook@google.com):
> The rearranging done for user ns has resulted in allowing arbitrary
> kernel module loading[1] (i.e. re-introducing a form of CVE-2011-1019)
> by what is assumed to be an unprivileged process.
> 
> At present, it does look to require at least CAP_SETUID along the way
> to set up the uidmap (but things like the setuid helper newuidmap
> might soon start providing such a thing by default).
> 
> It might be worth examining GRKERNSEC_MODHARDEN in grsecurity, which
> examines module symbols to verify that request_module() for a
> filesystem only loads a module that defines "register_filesystem"
> (among other things).
> 
> -Kees
> 
> [1] https://twitter.com/grsecurity/status/307473816672665600

So the concern is root in a child user namespace doing

	mount -t randomfs <...>

in which case do_new_mount() checks ns_capable(), not capable(),
before trying to load a module for randomfs.

As well as (secondly) the fact that there is no enforcement on
the format of the module names (i.e. fs-*).

Kees, from what I've seen the GRKERNSEC_MODHARDEN won't be acceptable.
At least Eric Paris is strongly against it.  But how about if we
add a check for 'current_user_ns() == &init_user_ns' at that place
instead?

Eric Biederman, do you have any objections to that?

thanks,
-serge
