Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab3IZSGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:06:47 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:46419 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab3IZSGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:06:42 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <20130926153359.GE704@fieldses.org>
References: <1378919210-10372-1-git-send-email-zab@redhat.com>
	<CAELBmZBGD4rph=gjLCPKCdEj+nzEQ-F=DExoL+h3vRm7qF7dCQ@mail.gmail.com>
	<20130925183828.GA30372@lenny.home.zabbo.net>
	<CAFX2JfnyF8kyMYzCdqdr2JkoyQCom1bFLpFj89wODjoju54-Ow@mail.gmail.com>
	<20130925190620.GB30372@lenny.home.zabbo.net>
	<20130925195526.GA18971@fieldses.org>
	<20130925210742.GG30372@lenny.home.zabbo.net>
	<CAJfpegsQ0A3T+46o9nsPwaH83JCbgyhgRNGPgzTqs0EcsmDuiQ@mail.gmail.com>
	<20130926153359.GE704@fieldses.org>
Date: Thu, 26 Sep 2013 20:06:41 +0200
Message-ID: <CAJfpegsUchb0eX+Hi3rN5Ypje3Y-dgo=pxgM1Y3BQbHVp=1hSw@mail.gmail.com>
Subject: Re: [RFC] extending splice for copy offloading
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Zach Brown <zab@redhat.com>, Anna Schumaker <schumaker.anna@gmail.com>,
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

On Thu, Sep 26, 2013 at 5:34 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Thu, Sep 26, 2013 at 10:58:05AM +0200, Miklos Szeredi wrote:
>> On Wed, Sep 25, 2013 at 11:07 PM, Zach Brown <zab@redhat.com> wrote:
>> >> A client-side copy will be slower, but I guess it does have the
>> >> advantage that the application can track progress to some degree, and
>> >> abort it fairly quickly without leaving the file in a totally undefined
>> >> state--and both might be useful if the copy's not a simple constant-time
>> >> operation.
>> >
>> > I suppose, but can't the app achieve a nice middle ground by copying the
>> > file in smaller syscalls?  Avoid bulk data motion back to the client,
>> > but still get notification every, I dunno, few hundred meg?
>>
>> Yes.  And if "cp"  could just be switched from a read+write syscall
>> pair to a single splice syscall using the same buffer size.
>
> Will the various magic fs-specific copy operations become inefficient
> when the range copied is too small?

We could treat spice-copy operations just like write operations (can
be buffered, coalesced, synced).

But I'm not sure it's worth the effort; 99% of the use of this
interface will be copying whole files.  And for that perhaps we need a
different API, one which has been discussed some time ago:
asynchronous copyfile() returns immediately with a pollable event
descriptor indicating copy progress, and some way to cancel the copy.
And that can internally rely on ->direct_splice(), with appropriate
algorithms for determine the optimal  chunk size.

Thanks,
Miklos
