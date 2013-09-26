Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab3IZI6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:58:10 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:33730 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3IZI6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:58:06 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <20130925210742.GG30372@lenny.home.zabbo.net>
References: <1378919210-10372-1-git-send-email-zab@redhat.com>
	<CAELBmZBGD4rph=gjLCPKCdEj+nzEQ-F=DExoL+h3vRm7qF7dCQ@mail.gmail.com>
	<20130925183828.GA30372@lenny.home.zabbo.net>
	<CAFX2JfnyF8kyMYzCdqdr2JkoyQCom1bFLpFj89wODjoju54-Ow@mail.gmail.com>
	<20130925190620.GB30372@lenny.home.zabbo.net>
	<20130925195526.GA18971@fieldses.org>
	<20130925210742.GG30372@lenny.home.zabbo.net>
Date: Thu, 26 Sep 2013 10:58:05 +0200
Message-ID: <CAJfpegsQ0A3T+46o9nsPwaH83JCbgyhgRNGPgzTqs0EcsmDuiQ@mail.gmail.com>
Subject: Re: [RFC] extending splice for copy offloading
From: Miklos Szeredi <miklos@szeredi.hu>
To: Zach Brown <zab@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Anna Schumaker <schumaker.anna@gmail.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Bryan Schumaker <bjschuma@netapp.com>,
        "Martin K. Petersen" <mkp@mkp.net>, Jens Axboe <axboe@kernel.dk>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Eric Wong <normalperson@yhbt.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 11:07 PM, Zach Brown <zab@redhat.com> wrote:
>> A client-side copy will be slower, but I guess it does have the
>> advantage that the application can track progress to some degree, and
>> abort it fairly quickly without leaving the file in a totally undefined
>> state--and both might be useful if the copy's not a simple constant-time
>> operation.
>
> I suppose, but can't the app achieve a nice middle ground by copying the
> file in smaller syscalls?  Avoid bulk data motion back to the client,
> but still get notification every, I dunno, few hundred meg?

Yes.  And if "cp"  could just be switched from a read+write syscall
pair to a single splice syscall using the same buffer size.  And then
the user would only notice that things got faster in case of server
side copy.  No problems with long blocking times (at least not much
worse than it was).

However "cp" doesn't do reflinking by default, it has a switch for
that.  If we just want "cp" and the like to use splice without fearing
side effects then by default we should try to be as close to
read+write behavior as possible.  No?   That's what I'm really
worrying about when you want to wire up splice to reflink by default.
I do think there should be a flag for that.  And if on the block level
some magic happens, so be it.  It's not the fs deverloper's worry any
more ;)

Thanks,
Miklos
