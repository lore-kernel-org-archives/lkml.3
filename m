Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbaKTGdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:33:14 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36695 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaKTGdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:33:12 -0500
Message-ID: <1416465189.8629.11.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net] tcp: fix connect() invalid -EADDRNOTAVAIL error
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jonathan Maxwell <jmaxwell37@gmail.com>
Cc: davem@davemloft.net, kuznet <kuznet@ms2.inr.ac.ru>,
        jmorris <jmorris@namei.org>, yoshfuji <yoshfuji@linux-ipv6.org>,
        kaber <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jon Maxwell <jmaxwell@redhat.com>
Date: Wed, 19 Nov 2014 22:33:09 -0800
In-Reply-To: <CAGHK07BrUmWxbNA3FzYtEqUOji_qn816=dmi_J40S_CKE3kMnA@mail.gmail.com>
References: <1416379060-15685-1-git-send-email-jmaxwell37@gmail.com>
	 <1416417120.14060.55.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAGHK07BrUmWxbNA3FzYtEqUOji_qn816=dmi_J40S_CKE3kMnA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-20 at 14:44 +1100, Jonathan Maxwell wrote:
> > > Prerequisites for this to happen:
> > > 1) The local tcp port range must be exhausted.
> > > 2) A process must have called bind() followed by connect() for all
> > > local ports.
> > 
> > How the bind() is done exactly ? How SO_REUSEADDR is used ?
> 
> It fails regardless. I tried both with and without for the client and
> server programs.
> 

This is the missing part from the programs.

By not using SO_REUSEADDR, programs basically do not allow another
programs to use same port.

> But removing the bind() and just calling connect() from the initial
> program
> then a subsequent connect() from a separate program succeeds. It seems
> that 
> this is inconsistent behaviour. The proposed fix makes it behave the
> same for
> 
> both cases.

This not consistent behavior is well known and somehow expected by some
applications.

bind() requests the kernel that this socket has a reserved port.

It means the socket can later disconnect from the target, and reconnect
to another, using _same_ source port, or chose to listen() on this port.

That is why kernel is so picky, otherwise the listen() might fail
later...

This is part of BSD socket semantic.

You have to use SO_REUSEADDR on both programs to relax these
constraints.

Your change might break existing programs, really expecting kernel
to behave as requested.



