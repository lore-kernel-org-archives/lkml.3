Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298AbaLKWCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:02:37 -0500
Received: from smtp.outflux.net ([198.145.64.163]:45116 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933939AbaLKWCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:02:36 -0500
Date: Thu, 11 Dec 2014 14:02:29 -0800
From: Kees Cook <keescook@chromium.org>
To: Hanno =?iso-8859-1?Q?B=F6ck?= <hanno@hboeck.de>
Cc: linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: VDSO randomization not very random
Message-ID: <20141211220229.GR18807@outflux.net>
References: <20141211224501.2292cdee@pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141211224501.2292cdee@pc>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hanno,

On Thu, Dec 11, 2014 at 10:45:01PM +0100, Hanno Böck wrote:
> Hello,
> 
> I already reported this into your bugzilla, however Greg KH told me it
> might be a better idea to post it here:
> 
> With current Linux kernels it seems the address randomization for
> loading the vdso library is not that random and can easily be
> bruteforced.
> 
> This can easily be demonstrated. Get libvdso address from one
> executable:
> $ ldd /usr/bin/less|grep vdso
> 	linux-vdso.so.1 (0x00007fff73bfe000)
> 
> Now run ldd mutliple times and check if the same address appears:
> c=0; while (true); do let c=c+1; ldd /usr/bin/less|grep
> 0x00007fff73bfe000; [ "$?" == 0 ] && echo $c; done
> 
> It usually takes only a few seconds and around 1000-2000 tries until
> the loading address is repeated (note that results may vary, it seems
> the randomization is biased, some values repeat more often than others).
> 
> This information is mostly from this blog entry:
> http://v0ids3curity.blogspot.in/2014/12/return-to-vdso-using-elf-auxiliary.html
> And here's a thread on oss-security discussing the issue:
> http://www.openwall.com/lists/oss-security/2014/12/09/10
> 
> The latest version of paxtest added a check for this that guesses the
> randomness of vdso:
> https://grsecurity.net/~spender/paxtest-0.9.13.tar.gz $ ./randvdso 
> VDSO randomisation test                  : 11 quality bits (guessed)
> 
> Bugzilla entry:
> https://bugzilla.kernel.org/show_bug.cgi?id=89591

I'm hoping this will get addressed as part of the discussion around
the "ASLRv3" patches. PIE (as well as VDSO) randomization has been a
per-arch implementation, and it would be best to unify this in a common
high-entropy solution.

I think the problem with VDSO right now is that it is randomized in
relationship to the stack, rather than being randomized on its own.

-Kees

-- 
Kees Cook
Chrome OS Security
